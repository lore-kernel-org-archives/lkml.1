Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZERKFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZERKFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbZERKEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:04:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:50617 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbZERKEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:04:07 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: benh@kernel.crashing.org, bluesmoke-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [v1 PATCH 2/4] EDAC: MCE & INT mode support for CPC925 driver
Date: Mon, 18 May 2009 18:04:58 +0800
Message-Id: <1242641100-15324-3-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1242641100-15324-2-git-send-email-qingtao.cao@windriver.com>
References: <1242641100-15324-1-git-send-email-qingtao.cao@windriver.com>
 <1242641100-15324-2-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 18 May 2009 10:03:55.0200 (UTC) FILETIME=[F41BBC00:01C9D79F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support EDAC INT mode and add a new EDAC MCE mode for CPC925 EDAC driver.
CPC925 Hypertransport hostbridge controller may trigger interrupt that
latches MPIC INT2 pin on Hypertransport Link Errors, and generate MCE on
memory ECC Errors and Processor Interface Errors.

The global variable "edac_op_state" defined by EDAC core will be
obsolete, not only different EDAC modules on the same machine may
operate in different EDAC modes, but further this could be the
case for different EDAC devices of the same EDAC module, for example,
each CPC925 EDAC device could work in the mode specified by their own
"op_state" member in their private structure.

A spinlock will be used to protect the EDAC MCE handler from being
silently unregistered, however, it also implies a constraint that
when EDAC MCE handler is called on one CPU, it will be bypassed by
another MCE event on other CPUs.

Following aspects for this patch have been tested:
1, module initialization and deletion;
2, creation and deletion for the mapping between hwirq==2 to a virq
   for the Hypertransport Link Errors;
3, registration and unregistration for the EDAC MCE handler from the
   generic MCE handler on PPC;

Note, due to the difficulty and complexity to generate a real hardware
ECC/HT Link/CPU Errors, below aspects have not been tested yet:
1, if ECC or CPU Errors would generate MCE event;
2, if HT Link Error will indeed latch MPIC INT2 pin;
3, if EDAC isr/mce methods could handle errors correctly.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 arch/powerpc/kernel/traps.c |   16 +++
 drivers/edac/cpc925_edac.c  |  275 ++++++++++++++++++++++++++++++++++++++++---
 drivers/edac/edac_stub.c    |    6 +
 include/linux/edac.h        |    6 +
 4 files changed, 284 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 678fbff..1ae3465 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -57,6 +57,10 @@
 #include <asm/dbell.h>
 #endif
 
+#ifdef CONFIG_EDAC
+#include <linux/edac.h>
+#endif
+
 #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
 int (*__debugger)(struct pt_regs *regs);
 int (*__debugger_ipi)(struct pt_regs *regs);
@@ -481,6 +485,18 @@ int machine_check_generic(struct pt_regs *regs)
 	default:
 		printk("Unknown values in msr\n");
 	}
+
+#ifdef CONFIG_EDAC
+	if (spin_trylock(&edac_mce_lock)) {
+		if (edac_mce_handler) {
+			int ret = edac_mce_handler();
+			spin_unlock(&edac_mce_lock);
+			return ret;
+		}
+		spin_unlock(&edac_mce_lock);
+	}
+#endif
+
 	return 0;
 }
 #endif /* everything else */
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 8c54196..36fc506 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -25,6 +25,8 @@
 #include <linux/edac.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <asm/reg.h>
 
 #include "edac_core.h"
 #include "edac_module.h"
@@ -273,22 +275,29 @@ enum brgctrl_bits {
 
 /* Private structure for edac memory controller */
 struct cpc925_mc_pdata {
+	int op_state;
 	void __iomem *vbase;
 	unsigned long total_mem;
 	const char *name;
 	int edac_idx;
+	struct mem_ctl_info *mci;
+	int (*mce)(struct mem_ctl_info *mci);
 };
 
 /* Private structure for common edac device */
 struct cpc925_dev_info {
+	int op_state;
 	void __iomem *vbase;
 	struct platform_device *pdev;
 	char *ctl_name;
 	int edac_idx;
 	struct edac_device_ctl_info *edac_dev;
+	int irq;
 	void (*init)(struct cpc925_dev_info *dev_info);
 	void (*exit)(struct cpc925_dev_info *dev_info);
 	void (*check)(struct edac_device_ctl_info *edac_dev);
+	int (*mce)(struct edac_device_ctl_info *edac_dev);
+	irqreturn_t (*isr)(int irq, void *dev_id);
 };
 
 /* Get total memory size from Open Firmware DTB */
@@ -382,6 +391,18 @@ static void cpc925_init_csrows(struct mem_ctl_info *mci)
 	}
 }
 
+/* Set up HID0_EMCP bit if necessary, MSR[ME] has been set up */
+static void cpc925_mce_enable(void)
+{
+	unsigned long hid0 = mfspr(SPRN_HID0);
+
+	if ((hid0 & HID0_EMCP) == 0)
+		mtspr(SPRN_HID0, hid0 | HID0_EMCP);
+
+	debugf0("%s: MSR[ME] = %d, HID0[EMCP] = %d\n", __func__,
+		mfmsr() & MSR_ME, mfspr(SPRN_HID0));
+}
+
 /* Enable memory controller ECC detection */
 static void cpc925_mc_init(struct mem_ctl_info *mci)
 {
@@ -402,6 +423,9 @@ static void cpc925_mc_init(struct mem_ctl_info *mci)
 		mccr |= MCCR_ECC_EN;
 		__raw_writel(mccr, pdata->vbase + REG_MCCR_OFFSET);
 	}
+
+	if (pdata->op_state == EDAC_OPSTATE_MCE)
+		cpc925_mce_enable();
 }
 
 /* Disable memory controller ECC detection */
@@ -520,7 +544,10 @@ static int cpc925_mc_find_channel(struct mem_ctl_info *mci, u16 syndrome)
 	return 1;
 }
 
-/* Check memory controller registers for ECC errors */
+/*
+ * Check memory controller registers for ECC errors,
+ * called when EDAC MC works in POLL mode.
+ */
 static void cpc925_mc_check(struct mem_ctl_info *mci)
 {
 	struct cpc925_mc_pdata *pdata = mci->pvt_info;
@@ -579,6 +606,70 @@ static void cpc925_mc_check(struct mem_ctl_info *mci)
 		syndrome);
 }
 
+/*
+ * Check memory controller registers for ECC errors,
+ * called when EDAC MC works in MCE mode.
+ */
+static int cpc925_mc_mce(struct mem_ctl_info *mci)
+{
+	struct cpc925_mc_pdata *pdata = mci->pvt_info;
+	u32 apiexcp;
+	u32 mear;
+	u32 mesr;
+	u16 syndrome;
+	unsigned long pfn = 0, offset = 0;
+	int csrow = 0, channel = 0;
+
+	/* APIEXCP is cleared when read */
+	apiexcp = __raw_readl(pdata->vbase + REG_APIEXCP_OFFSET);
+	if ((apiexcp & ECC_EXCP_DETECTED) == 0)
+		return 0;
+
+	mesr = __raw_readl(pdata->vbase + REG_MESR_OFFSET);
+	syndrome = mesr | (MESR_ECC_SYN_H_MASK | MESR_ECC_SYN_L_MASK);
+
+	mear = __raw_readl(pdata->vbase + REG_MEAR_OFFSET);
+
+	/* Revert column/row addresses into page frame number, etc */
+	cpc925_mc_get_pfn(mci, mear, &pfn, &offset, &csrow);
+
+	if (apiexcp & CECC_EXCP_DETECTED) {
+		cpc925_mc_printk(mci, KERN_EMERG, "DRAM CECC Fault\n");
+		channel = cpc925_mc_find_channel(mci, syndrome);
+		edac_mc_handle_ce(mci, pfn, offset, syndrome,
+				  csrow, channel, mci->ctl_name);
+	}
+
+	if (apiexcp & UECC_EXCP_DETECTED) {
+		cpc925_mc_printk(mci, KERN_EMERG, "DRAM UECC Fault\n");
+		edac_mc_handle_ue(mci, pfn, offset, csrow, mci->ctl_name);
+	}
+
+	cpc925_mc_printk(mci, KERN_EMERG, "Dump registers:\n");
+	cpc925_mc_printk(mci, KERN_EMERG, "APIMASK               0x%08x\n",
+		__raw_readl(pdata->vbase + REG_APIMASK_OFFSET));
+	cpc925_mc_printk(mci, KERN_EMERG, "APIEXCP               0x%08x\n",
+		apiexcp);
+	cpc925_mc_printk(mci, KERN_EMERG, "Mem Scrub Ctrl        0x%08x\n",
+		__raw_readl(pdata->vbase + REG_MSCR_OFFSET));
+	cpc925_mc_printk(mci, KERN_EMERG, "Mem Scrub Rge Start   0x%08x\n",
+		__raw_readl(pdata->vbase + REG_MSRSR_OFFSET));
+	cpc925_mc_printk(mci, KERN_EMERG, "Mem Scrub Rge End     0x%08x\n",
+		__raw_readl(pdata->vbase + REG_MSRER_OFFSET));
+	cpc925_mc_printk(mci, KERN_EMERG, "Mem Scrub Pattern     0x%08x\n",
+		__raw_readl(pdata->vbase + REG_MSPR_OFFSET));
+	cpc925_mc_printk(mci, KERN_EMERG, "Mem Chk Ctrl          0x%08x\n",
+		__raw_readl(pdata->vbase + REG_MCCR_OFFSET));
+	cpc925_mc_printk(mci, KERN_EMERG, "Mem Chk Rge End       0x%08x\n",
+		__raw_readl(pdata->vbase + REG_MCRER_OFFSET));
+	cpc925_mc_printk(mci, KERN_EMERG, "Mem Err Address       0x%08x\n",
+		mesr);
+	cpc925_mc_printk(mci, KERN_EMERG, "Mem Err Syndrome      0x%08x\n",
+		syndrome);
+
+	return 1;
+}
+
 /******************** CPU err device********************************/
 /* Enable CPU Errors detection */
 static void cpc925_cpu_init(struct cpc925_dev_info *dev_info)
@@ -609,7 +700,7 @@ static void cpc925_cpu_exit(struct cpc925_dev_info *dev_info)
 	return;
 }
 
-/* Check for CPU Errors */
+/* Check for CPU Errors, called in POLL mode */
 static void cpc925_cpu_check(struct edac_device_ctl_info *edac_dev)
 {
 	struct cpc925_dev_info *dev_info = edac_dev->pvt_info;
@@ -630,6 +721,28 @@ static void cpc925_cpu_check(struct edac_device_ctl_info *edac_dev)
 	edac_device_handle_ue(edac_dev, 0, 0, edac_dev->ctl_name);
 }
 
+/* Check for CPU Errors, called in MCE mode */
+static int cpc925_cpu_mce(struct edac_device_ctl_info *edac_dev)
+{
+	struct cpc925_dev_info *dev_info = edac_dev->pvt_info;
+	u32 apiexcp;
+	u32 apimask;
+
+	/* APIEXCP is cleared when read */
+	apiexcp = __raw_readl(dev_info->vbase + REG_APIEXCP_OFFSET);
+	if ((apiexcp & CPU_EXCP_DETECTED) == 0)
+		return 0;
+
+	apimask = __raw_readl(dev_info->vbase + REG_APIMASK_OFFSET);
+	cpc925_printk(KERN_EMERG, "Processor Interface Fault\n"
+				  "Processor Interface register dump:\n");
+	cpc925_printk(KERN_EMERG, "APIMASK               0x%08x\n", apimask);
+	cpc925_printk(KERN_EMERG, "APIEXCP               0x%08x\n", apiexcp);
+
+	edac_device_handle_ue(edac_dev, 0, 0, edac_dev->ctl_name);
+	return 1;
+}
+
 /******************** HT Link err device****************************/
 /* Enable HyperTransport Link Error detection */
 static void cpc925_htlink_init(struct cpc925_dev_info *dev_info)
@@ -704,23 +817,105 @@ static void cpc925_htlink_check(struct edac_device_ctl_info *edac_dev)
 	edac_device_handle_ce(edac_dev, 0, 0, edac_dev->ctl_name);
 }
 
+static irqreturn_t cpc925_htlink_isr(int irq, void *dev_id)
+{
+	struct edac_device_ctl_info *edac_dev = dev_id;
+	struct cpc925_dev_info *dev_info = edac_dev->pvt_info;
+	u32 brgctrl = __raw_readl(dev_info->vbase + REG_BRGCTRL_OFFSET);
+	u32 linkctrl = __raw_readl(dev_info->vbase + REG_LINKCTRL_OFFSET);
+	u32 errctrl = __raw_readl(dev_info->vbase + REG_ERRCTRL_OFFSET);
+	u32 linkerr = __raw_readl(dev_info->vbase + REG_LINKERR_OFFSET);
+
+	if (!((brgctrl & BRGCTRL_DETSERR) ||
+	      (linkctrl & HT_LINKCTRL_DETECTED) ||
+	      (errctrl & HT_ERRCTRL_DETECTED) ||
+	      (linkerr & HT_LINKERR_DETECTED)))
+		return IRQ_NONE;
+
+	cpc925_htlink_check(edac_dev);
+
+	return IRQ_HANDLED;
+}
+
+/* Private structure for EDAC Memory Controller */
+static struct cpc925_mc_pdata cpc925_mc_private = {
+	/* EDAC MC supports POLL and MCE mode */
+	.op_state = EDAC_OPSTATE_MCE,
+	.mce = cpc925_mc_mce,
+	.mci = NULL,
+};
+
+/*
+ * Private strucutures for common EDAC devices for CPU Error
+ * and Hypertransport Link Error
+ */
 static struct cpc925_dev_info cpc925_devs[] = {
 	{
+	/* CPU Error supports POLL and MCE mode */
+	.op_state = EDAC_OPSTATE_MCE,
 	.ctl_name = CPC925_CPU_ERR_DEV,
 	.init = cpc925_cpu_init,
 	.exit = cpc925_cpu_exit,
 	.check = cpc925_cpu_check,
+	.mce = cpc925_cpu_mce,
 	},
 	{
+	/* Hypertransport Link Error supports POLL and INT mode */
+	.op_state = EDAC_OPSTATE_INT,
 	.ctl_name = CPC925_HT_LINK_DEV,
 	.init = cpc925_htlink_init,
 	.exit = cpc925_htlink_exit,
 	.check = cpc925_htlink_check,
+	.irq = NO_IRQ,
+	.isr = cpc925_htlink_isr,
 	},
 	{0}, /* Terminated by NULL */
 };
 
 /*
+ * MCE handler for EDAC CPC925 driver, check memory controller and
+ * Hypertransport hostbridge to claim any possbile MCE instance.
+ */
+static int cpc925_mce_handler(void)
+{
+	struct cpc925_mc_pdata *pdata = &cpc925_mc_private;
+	struct cpc925_dev_info *dev_info;
+	int ret = 0;
+
+	if (pdata->op_state == EDAC_OPSTATE_MCE)
+		if (pdata->mce)
+			ret |= pdata->mce(pdata->mci);
+
+	for (dev_info = &cpc925_devs[0]; dev_info->init; dev_info++) {
+		if (dev_info->op_state == EDAC_OPSTATE_MCE)
+			if (dev_info->mce)
+				ret |= dev_info->mce(dev_info->edac_dev);
+	}
+
+	return ret;
+}
+
+/* Hook CPC925 MCE handler to PowerPC generic MCE handler */
+static void cpc925_mce_handler_setup(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&edac_mce_lock, flags);
+	edac_mce_handler = cpc925_mce_handler;
+	spin_unlock_irqrestore(&edac_mce_lock, flags);
+}
+
+static void cpc925_mce_handler_exit(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&edac_mce_lock, flags);
+	if (edac_mce_handler)
+		edac_mce_handler = NULL;
+	spin_unlock_irqrestore(&edac_mce_lock, flags);
+}
+
+/*
  * Add CPU Err detection and HyperTransport Link Err detection
  * as common "edac_device", they have no corresponding device
  * nodes in the Open Firmware DTB and we have to add platform
@@ -730,6 +925,7 @@ static struct cpc925_dev_info cpc925_devs[] = {
 static void cpc925_add_edac_devices(void __iomem *vbase)
 {
 	struct cpc925_dev_info *dev_info;
+	int ret = 0;
 
 	if (!vbase) {
 		cpc925_printk(KERN_ERR, "MMIO not established yet\n");
@@ -766,8 +962,36 @@ static void cpc925_add_edac_devices(void __iomem *vbase)
 		dev_info->edac_dev->mod_name = CPC925_EDAC_MOD_STR;
 		dev_info->edac_dev->dev_name = dev_name(&dev_info->pdev->dev);
 
-		if (edac_op_state == EDAC_OPSTATE_POLL)
+		if (dev_info->op_state == EDAC_OPSTATE_POLL)
 			dev_info->edac_dev->edac_check = dev_info->check;
+		else if (dev_info->irq == EDAC_OPSTATE_MCE) {
+			/*
+			 * do nothing, MCE handler has been registered
+			 * by memory controller.
+			 */
+		} else if (dev_info->op_state == EDAC_OPSTATE_INT) {
+			dev_info->irq =
+				edac_get_mpic_irq(MPIC_HWIRQ_INTERNAL_ERROR);
+			if (dev_info->irq == NO_IRQ) {
+				cpc925_printk(KERN_ERR,	"%s: failed to get "
+					"virq for %s\n", __func__,
+					dev_info->ctl_name);
+				goto err2;
+			}
+
+			ret = request_irq(dev_info->irq, dev_info->isr,
+					IRQF_SHARED, "[EDAC] CPC925 ",
+					dev_info->edac_dev);
+			if (ret < 0) {
+				cpc925_printk(KERN_INFO, "%s: failed to "
+					"request irq %d for %s\n", __func__,
+					dev_info->irq, dev_info->ctl_name);
+				goto err2;
+			}
+
+			debugf0("%s: Successfully requested irq %d for %s\n",
+				 __func__, dev_info->irq, dev_info->ctl_name);
+		}
 
 		if (dev_info->init)
 			dev_info->init(dev_info);
@@ -776,7 +1000,7 @@ static void cpc925_add_edac_devices(void __iomem *vbase)
 			cpc925_printk(KERN_ERR,
 				"Unable to add edac device for %s\n",
 				dev_info->ctl_name);
-			goto err2;
+			goto err3;
 		}
 
 		debugf0("%s: Successfully added edac device for %s\n",
@@ -784,9 +1008,13 @@ static void cpc925_add_edac_devices(void __iomem *vbase)
 
 		continue;
 
-err2:
+err3:
 		if (dev_info->exit)
 			dev_info->exit(dev_info);
+
+		if (dev_info->op_state == EDAC_OPSTATE_INT)
+			free_irq(dev_info->irq, dev_info->edac_dev);
+err2:
 		edac_device_free_ctl_info(dev_info->edac_dev);
 err1:
 		platform_device_unregister(dev_info->pdev);
@@ -802,15 +1030,17 @@ static void cpc925_del_edac_devices(void)
 	struct cpc925_dev_info *dev_info;
 
 	for (dev_info = &cpc925_devs[0]; dev_info->init; dev_info++) {
+		if (dev_info->exit)
+			dev_info->exit(dev_info);
+
 		if (dev_info->edac_dev) {
+			if (dev_info->op_state == EDAC_OPSTATE_INT)
+				free_irq(dev_info->irq, dev_info->edac_dev);
 			edac_device_del_device(dev_info->edac_dev->dev);
 			edac_device_free_ctl_info(dev_info->edac_dev);
 			platform_device_unregister(dev_info->pdev);
 		}
 
-		if (dev_info->exit)
-			dev_info->exit(dev_info);
-
 		debugf0("%s: Successfully deleted edac device for %s\n",
 			__func__, dev_info->ctl_name);
 	}
@@ -900,18 +1130,18 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 	}
 
 	nr_channels = cpc925_mc_get_channels(vbase);
-	mci = edac_mc_alloc(sizeof(struct cpc925_mc_pdata),
-			CPC925_NR_CSROWS, nr_channels + 1, edac_mc_idx);
+	mci = edac_mc_alloc(0, CPC925_NR_CSROWS, nr_channels + 1, edac_mc_idx);
 	if (!mci) {
 		cpc925_printk(KERN_ERR, "No memory for mem_ctl_info\n");
 		res = -ENOMEM;
 		goto err2;
 	}
 
-	pdata = mci->pvt_info;
+	pdata = mci->pvt_info = &cpc925_mc_private;
 	pdata->vbase = vbase;
 	pdata->edac_idx = edac_mc_idx++;
 	pdata->name = pdev->name;
+	pdata->mci = mci;
 
 	mci->dev = &pdev->dev;
 	platform_set_drvdata(pdev, mci);
@@ -922,15 +1152,16 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 	mci->mod_name = CPC925_EDAC_MOD_STR;
 	mci->mod_ver = CPC925_EDAC_REVISION;
 	mci->ctl_name = pdev->name;
-
-	if (edac_op_state == EDAC_OPSTATE_POLL)
-		mci->edac_check = cpc925_mc_check;
-
 	mci->ctl_page_to_phys = NULL;
 	mci->scrub_mode = SCRUB_SW_SRC;
 	mci->set_sdram_scrub_rate = NULL;
 	mci->get_sdram_scrub_rate = cpc925_get_sdram_scrub_rate;
 
+	if (pdata->op_state == EDAC_OPSTATE_POLL)
+		mci->edac_check = cpc925_mc_check;
+	else if (pdata->op_state == EDAC_OPSTATE_MCE)
+		cpc925_mce_handler_setup();
+
 	cpc925_init_csrows(mci);
 
 	/* Setup memory controller registers */
@@ -951,6 +1182,10 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 
 err3:
 	cpc925_mc_exit(mci);
+
+	if (pdata->op_state == EDAC_OPSTATE_MCE)
+		cpc925_mce_handler_exit();
+
 	edac_mc_free(mci);
 err2:
 	devm_release_mem_region(&pdev->dev, r->start, r->end-r->start+1);
@@ -963,14 +1198,19 @@ out:
 static int cpc925_remove(struct platform_device *pdev)
 {
 	struct mem_ctl_info *mci = platform_get_drvdata(pdev);
+	struct cpc925_mc_pdata *pdata = mci->pvt_info;
 
 	/*
 	 * Delete common edac devices before edac mc, because
 	 * the former share the MMIO of the latter.
 	 */
 	cpc925_del_edac_devices();
+
 	cpc925_mc_exit(mci);
 
+	if (pdata->op_state == EDAC_OPSTATE_MCE)
+		cpc925_mce_handler_exit();
+
 	edac_mc_del_mc(&pdev->dev);
 	edac_mc_free(mci);
 
@@ -981,7 +1221,7 @@ static struct platform_driver cpc925_edac_driver = {
 	.probe = cpc925_probe,
 	.remove = cpc925_remove,
 	.driver = {
-		   .name = "cpc925_edac",
+		.name = "cpc925_edac",
 	}
 };
 
@@ -992,9 +1232,6 @@ static int __init cpc925_edac_init(void)
 	printk(KERN_INFO "IBM CPC925 EDAC driver " CPC925_EDAC_REVISION "\n");
 	printk(KERN_INFO "\t(c) 2008 Wind River Systems, Inc\n");
 
-	/* Only support POLL mode so far */
-	edac_op_state = EDAC_OPSTATE_POLL;
-
 	ret = platform_driver_register(&cpc925_edac_driver);
 	if (ret) {
 		printk(KERN_WARNING "Failed to register %s\n",
diff --git a/drivers/edac/edac_stub.c b/drivers/edac/edac_stub.c
index 20b428a..d2814d0 100644
--- a/drivers/edac/edac_stub.c
+++ b/drivers/edac/edac_stub.c
@@ -44,3 +44,9 @@ void edac_atomic_assert_error(void)
 	edac_err_assert++;
 }
 EXPORT_SYMBOL_GPL(edac_atomic_assert_error);
+
+int (*edac_mce_handler)(void) = NULL;
+EXPORT_SYMBOL_GPL(edac_mce_handler);
+
+DEFINE_SPINLOCK(edac_mce_lock);
+EXPORT_SYMBOL_GPL(edac_mce_lock);
diff --git a/include/linux/edac.h b/include/linux/edac.h
index c122d22..da2dc20 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -12,12 +12,14 @@
 #ifndef _LINUX_EDAC_H_
 #define _LINUX_EDAC_H_
 
+#include <linux/spinlock.h>
 #include <asm/atomic.h>
 
 #define EDAC_OPSTATE_INVAL	-1
 #define EDAC_OPSTATE_POLL	0
 #define EDAC_OPSTATE_NMI	1
 #define EDAC_OPSTATE_INT	2
+#define EDAC_OPSTATE_MCE	3
 
 extern int edac_op_state;
 extern int edac_err_assert;
@@ -26,11 +28,15 @@ extern atomic_t edac_handlers;
 extern int edac_handler_set(void);
 extern void edac_atomic_assert_error(void);
 
+extern int (*edac_mce_handler)(void);
+extern spinlock_t edac_mce_lock;
+
 static inline void opstate_init(void)
 {
 	switch (edac_op_state) {
 	case EDAC_OPSTATE_POLL:
 	case EDAC_OPSTATE_NMI:
+	case EDAC_OPSTATE_MCE:
 		break;
 	default:
 		edac_op_state = EDAC_OPSTATE_POLL;
-- 
1.5.6.2


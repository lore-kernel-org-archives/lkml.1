Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbZEOIoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbZEOIoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbZEOInJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:43:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:58902 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006AbZEOInB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:43:01 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: bluesmoke-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [v0 PATCH 4/4] EDAC: INT mode support for AMD8131 driver
Date: Fri, 15 May 2009 16:43:54 +0800
Message-Id: <1242377034-7378-5-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1242377034-7378-4-git-send-email-qingtao.cao@windriver.com>
References: <1242377034-7378-1-git-send-email-qingtao.cao@windriver.com>
 <1242377034-7378-2-git-send-email-qingtao.cao@windriver.com>
 <1242377034-7378-3-git-send-email-qingtao.cao@windriver.com>
 <1242377034-7378-4-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 15 May 2009 08:42:54.0881 (UTC) FILETIME=[23E4A910:01C9D539]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support EDAC INT mode for AMD8131 EDAC driver, which may post upstream
NMI interrupt request messages that will latch MPIC INT0 pin.

Following aspects for this patch have been tested:
1, module initialization and deletion for NMI mode;
2, creation and deletion for the mapping between hwirq==0 to a virq;

Note, due to the difficulty and complexity to generate a real hardware
EDAC Errors, below aspects have not been tested yet:
1, code that controls the generation of the NMI Request Message;
2, the mapping from the NMI Request Messages to MPIC INT0 pin;
3, if EDAC isr methods could handle errors correctly.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
diff --git a/drivers/edac/amd8131_edac.c b/drivers/edac/amd8131_edac.c
index b432d60..913be34 100644
--- a/drivers/edac/amd8131_edac.c
+++ b/drivers/edac/amd8131_edac.c
@@ -28,6 +28,7 @@
 #include <linux/bitops.h>
 #include <linux/edac.h>
 #include <linux/pci_ids.h>
+#include <linux/interrupt.h>
 
 #include "edac_core.h"
 #include "edac_module.h"
@@ -36,6 +37,11 @@
 #define AMD8131_EDAC_REVISION	" Ver: 1.0.0 " __DATE__
 #define AMD8131_EDAC_MOD_STR	"amd8131_edac"
 
+static int amd8131_op_state = EDAC_OPSTATE_POLL;
+module_param(amd8131_op_state, int, 0444);
+MODULE_PARM_DESC(amd8131_op_state, "EDAC Error Reporting state: 0=Poll, 1=NMI");
+static int amd8131_nmi_irq;
+
 /* Wrapper functions for accessing PCI configuration space */
 static void edac_pci_read_dword(struct pci_dev *dev, int reg, u32 *val32)
 {
@@ -139,6 +145,17 @@ static void amd8131_pcix_init(struct amd8131_dev_info *dev_info)
 	edac_pci_read_dword(dev, REG_LNK_CTRL_B, &val32);
 	val32 |= LNK_CTRL_CRCFEN;
 	edac_pci_write_dword(dev, REG_LNK_CTRL_B, val32);
+
+	/* enable HT NMI messages generation on errors */
+	if (amd8131_op_state == EDAC_OPSTATE_NMI) {
+		edac_pci_read_dword(dev, REG_MISC_I, &val32);
+		val32 &= ~MISC_I_NIOAMODE;
+		edac_pci_write_dword(dev, REG_MISC_I, val32);
+
+		edac_pci_read_dword(dev, REG_MISC_II, &val32);
+		val32 |= MISC_II_NMIEN;
+		edac_pci_write_dword(dev, REG_MISC_II, val32);
+	}
 }
 
 static void amd8131_pcix_exit(struct amd8131_dev_info *dev_info)
@@ -165,6 +182,17 @@ static void amd8131_pcix_exit(struct amd8131_dev_info *dev_info)
 	edac_pci_read_dword(dev, REG_LNK_CTRL_B, &val32);
 	val32 &= ~LNK_CTRL_CRCFEN;
 	edac_pci_write_dword(dev, REG_LNK_CTRL_B, val32);
+
+	/* Disable HT NMI messages on errors*/
+	if (amd8131_op_state == EDAC_OPSTATE_NMI) {
+		edac_pci_read_dword(dev, REG_MISC_II, &val32);
+		val32 &= ~MISC_II_NMIEN;
+		edac_pci_write_dword(dev, REG_MISC_II, val32);
+
+		edac_pci_read_dword(dev, REG_MISC_I, &val32);
+		val32 |= MISC_I_NIOAMODE;
+		edac_pci_write_dword(dev, REG_MISC_I, val32);
+	}
 }
 
 static void amd8131_pcix_check(struct edac_pci_ctl_info *edac_dev)
@@ -233,12 +261,33 @@ static void amd8131_pcix_check(struct edac_pci_ctl_info *edac_dev)
 	}
 }
 
+static irqreturn_t amd8131_pcix_isr(int irq, void *dev_id)
+{
+	struct edac_pci_ctl_info *edac_pci = dev_id;
+	struct amd8131_dev_info *dev_info = edac_pci->pvt_info;
+	struct pci_dev *dev = dev_info->dev;
+	u32 val32;
+
+	/*
+	 * Only a handful of errors in PCI-X Bridge Memory Base-Limit
+	 * Register could trigger NMI interrupt request message.
+	 */
+	edac_pci_read_dword(dev, REG_MEM_LIM, &val32);
+	if (!(val32 & MEM_LIMIT_NMI_MASK))
+		return IRQ_NONE;
+
+	amd8131_pcix_check(edac_pci);
+
+	return IRQ_HANDLED;
+}
+
 static struct amd8131_info amd8131_chipset = {
 	.err_dev = PCI_DEVICE_ID_AMD_8131_APIC,
 	.devices = amd8131_devices,
 	.init = amd8131_pcix_init,
 	.exit = amd8131_pcix_exit,
 	.check = amd8131_pcix_check,
+	.isr = amd8131_pcix_isr,
 };
 
 /*
@@ -249,6 +298,7 @@ static struct amd8131_info amd8131_chipset = {
 static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	struct amd8131_dev_info *dev_info;
+	int ret = -ENODEV;
 
 	for (dev_info = amd8131_chipset.devices; dev_info->inst != NO_BRIDGE;
 		dev_info++)
@@ -256,7 +306,7 @@ static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 			break;
 
 	if (dev_info->inst == NO_BRIDGE) /* should never happen */
-		return -ENODEV;
+		goto out;
 
 	/*
 	 * We can't call pci_get_device() as we are used to do because
@@ -265,12 +315,11 @@ static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	dev_info->dev = pci_dev_get(dev);
 
 	if (pci_enable_device(dev_info->dev)) {
-		pci_dev_put(dev_info->dev);
 		printk(KERN_ERR "failed to enable:"
 			"vendor %x, device %x, devfn %x, name %s\n",
 			PCI_VENDOR_ID_AMD, amd8131_chipset.err_dev,
 			dev_info->devfn, dev_info->ctl_name);
-		return -ENODEV;
+		goto err1;
 	}
 
 	/*
@@ -280,8 +329,10 @@ static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	 */
 	dev_info->edac_idx = edac_pci_alloc_index();
 	dev_info->edac_dev = edac_pci_alloc_ctl_info(0, dev_info->ctl_name);
-	if (!dev_info->edac_dev)
-		return -ENOMEM;
+	if (!dev_info->edac_dev) {
+		ret = -ENOMEM;
+		goto err1;
+	}
 
 	dev_info->edac_dev->pvt_info = dev_info;
 	dev_info->edac_dev->dev = &dev_info->dev->dev;
@@ -289,7 +340,7 @@ static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	dev_info->edac_dev->ctl_name = dev_info->ctl_name;
 	dev_info->edac_dev->dev_name = dev_name(&dev_info->dev->dev);
 
-	if (edac_op_state == EDAC_OPSTATE_POLL)
+	if (amd8131_op_state == EDAC_OPSTATE_POLL)
 		dev_info->edac_dev->edac_check = amd8131_chipset.check;
 
 	if (amd8131_chipset.init)
@@ -298,8 +349,8 @@ static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (edac_pci_add_device(dev_info->edac_dev, dev_info->edac_idx) > 0) {
 		printk(KERN_ERR "failed edac_pci_add_device() for %s\n",
 			dev_info->ctl_name);
-		edac_pci_free_ctl_info(dev_info->edac_dev);
-		return -ENODEV;
+		ret = -ENOMEM;
+		goto err2;
 	}
 
 	printk(KERN_INFO "added one device on AMD8131 "
@@ -307,7 +358,18 @@ static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		PCI_VENDOR_ID_AMD, amd8131_chipset.err_dev,
 		dev_info->devfn, dev_info->ctl_name);
 
-	return 0;
+	ret = 0;
+	goto out;
+
+err2:
+	if (amd8131_chipset.exit)
+		amd8131_chipset.exit(dev_info);
+
+	edac_pci_free_ctl_info(dev_info->edac_dev);
+err1:
+	pci_dev_put(dev_info->dev);
+out:
+	return ret;
 }
 
 static void amd8131_remove(struct pci_dev *dev)
@@ -322,14 +384,14 @@ static void amd8131_remove(struct pci_dev *dev)
 	if (dev_info->inst == NO_BRIDGE) /* should never happen */
 		return;
 
+	if (amd8131_chipset.exit)
+		amd8131_chipset.exit(dev_info);
+
 	if (dev_info->edac_dev) {
 		edac_pci_del_device(dev_info->edac_dev->dev);
 		edac_pci_free_ctl_info(dev_info->edac_dev);
 	}
 
-	if (amd8131_chipset.exit)
-		amd8131_chipset.exit(dev_info);
-
 	pci_dev_put(dev_info->dev);
 }
 
@@ -342,9 +404,7 @@ static const struct pci_device_id amd8131_edac_pci_tbl[] = {
 	.class_mask = 0,
 	.driver_data = 0,
 	},
-	{
-	0,
-	}			/* table is NULL-terminated */
+	{0}	/* table is NULL-terminated */
 };
 MODULE_DEVICE_TABLE(pci, amd8131_edac_pci_tbl);
 
@@ -355,20 +415,97 @@ static struct pci_driver amd8131_edac_driver = {
 	.id_table = amd8131_edac_pci_tbl,
 };
 
+/*
+ * AMD8131 NMI handler - check PCI-X Bridges to claim any
+ * possible NMI instance.
+ * Southbridge NMI Request messages posted through Hypertransport
+ * Channel will be transferred to a MPIC interrupt instance.
+ *
+ * NOTE: According to AMD8131 data sheet 4.5.7 section,
+ * only a partial of error detections could generate NMI
+ * Upstream Hypertransport Interrupt request messages, so
+ * use NMI mode at sacrifice that not all error detections
+ * could be made use of.
+ */
+static irqreturn_t amd8131_nmi_handler(int irq, void *dev_id)
+{
+	struct amd8131_info *info = dev_id;
+	struct amd8131_dev_info *dev_info;
+	irqreturn_t ret = IRQ_NONE;
+
+	if (!info->isr)
+		return IRQ_NONE;
+
+	for (dev_info = info->devices; dev_info->inst != NO_BRIDGE; dev_info++)
+		ret |= info->isr(irq, dev_info->edac_dev);
+
+	return ret;
+}
+
+static void __init amd8131_nmi_handler_setup(void)
+{
+	int ret;
+
+	if (amd8131_op_state != EDAC_OPSTATE_NMI)
+		return;
+
+	amd8131_nmi_irq = NO_IRQ;
+
+#ifdef CONFIG_MPIC
+	amd8131_nmi_irq = edac_get_mpic_irq(MPIC_HWIRQ_HT_NMI);
+#endif
+
+	if (amd8131_nmi_irq == NO_IRQ) {
+		printk(KERN_ERR "%s: failed to get virq "
+			"for AMD8131 NMI requests\n", __func__);
+		return;
+	}
+
+	ret = request_irq(amd8131_nmi_irq, amd8131_nmi_handler,
+			  IRQF_SHARED, "[EDAC] AMD8131", &amd8131_chipset);
+	if (ret < 0) {
+		printk(KERN_INFO "%s: failed to request irq %d for "
+			"AMD8131 NMI requests\n", __func__, amd8131_nmi_irq);
+		return;
+	}
+
+	debugf0("%s: Successfully requested irq %d for AMD8131 NMI requests\n",
+		 __func__, amd8131_nmi_irq);
+}
+
+static void __exit amd8131_nmi_handler_exit(void)
+{
+	if (amd8131_op_state != EDAC_OPSTATE_NMI)
+		return;
+
+	if (amd8131_nmi_irq != NO_IRQ) {
+		free_irq(amd8131_nmi_irq, &amd8131_chipset);
+#ifdef CONGIF_MPIC
+		edac_put_mpic_irq(MPIC_HWIRQ_HT_NMI);
+#endif
+	}
+}
+
 static int __init amd8131_edac_init(void)
 {
+	int ret;
+
 	printk(KERN_INFO "AMD8131 EDAC driver " AMD8131_EDAC_REVISION "\n");
 	printk(KERN_INFO "\t(c) 2008 Wind River Systems, Inc.\n");
 
-	/* Only POLL mode supported so far */
-	edac_op_state = EDAC_OPSTATE_POLL;
+	ret = pci_register_driver(&amd8131_edac_driver);
 
-	return pci_register_driver(&amd8131_edac_driver);
+	if (ret == 0)
+		amd8131_nmi_handler_setup();
+
+	return ret;
 }
 
 static void __exit amd8131_edac_exit(void)
 {
 	pci_unregister_driver(&amd8131_edac_driver);
+
+	amd8131_nmi_handler_exit();
 }
 
 module_init(amd8131_edac_init);
diff --git a/drivers/edac/amd8131_edac.h b/drivers/edac/amd8131_edac.h
index 60e0d1c..7e86cbf 100644
--- a/drivers/edac/amd8131_edac.h
+++ b/drivers/edac/amd8131_edac.h
@@ -61,7 +61,8 @@ enum mem_limit_bits {
 	MEM_LIMIT_STA	= BIT(27),
 	MEM_LIMIT_MDPE	= BIT(24),
 	MEM_LIMIT_MASK	= MEM_LIMIT_DPE|MEM_LIMIT_RSE|MEM_LIMIT_RMA|
-				MEM_LIMIT_RTA|MEM_LIMIT_STA|MEM_LIMIT_MDPE
+				MEM_LIMIT_RTA|MEM_LIMIT_STA|MEM_LIMIT_MDPE,
+	MEM_LIMIT_NMI_MASK = MEM_LIMIT_DPE | MEM_LIMIT_RSE
 };
 
 /************************************************************
@@ -80,6 +81,22 @@ enum lnk_ctrl_bits {
 	LNK_CTRL_CRCFEN		= BIT(1)
 };
 
+/************************************************************
+ *	PCI-X Miscellaneous Register, Dev[B,A]:0x40
+ ************************************************************/
+#define REG_MISC_I	0x40
+enum misc_i_bits {
+	MISC_I_NIOAMODE	= BIT(0),
+};
+
+/************************************************************
+ *	PCI-X Miscellaneous II Register, Dev[B,A]:0x44
+ ************************************************************/
+#define REG_MISC_II	0x44
+enum misc_ii_bits {
+	MISC_II_NMIEN	= BIT(0),
+};
+
 enum pcix_bridge_inst {
 	NORTH_A = 0,
 	NORTH_B = 1,
@@ -113,6 +130,7 @@ struct amd8131_info {
 	void (*init)(struct amd8131_dev_info *dev_info);
 	void (*exit)(struct amd8131_dev_info *dev_info);
 	void (*check)(struct edac_pci_ctl_info *edac_dev);
+	irqreturn_t (*isr)(int irq, void *dev_id);
 };
 
 #endif /* _AMD8131_EDAC_H_ */

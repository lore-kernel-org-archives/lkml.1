Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbZERKG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbZERKG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbZERKEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:04:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:50618 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZERKEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:04:07 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: benh@kernel.crashing.org, bluesmoke-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [v1 PATCH 3/4] EDAC: INT mode support for AMD8111 driver
Date: Mon, 18 May 2009 18:04:59 +0800
Message-Id: <1242641100-15324-4-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1242641100-15324-3-git-send-email-qingtao.cao@windriver.com>
References: <1242641100-15324-1-git-send-email-qingtao.cao@windriver.com>
 <1242641100-15324-2-git-send-email-qingtao.cao@windriver.com>
 <1242641100-15324-3-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 18 May 2009 10:03:57.0340 (UTC) FILETIME=[F56245C0:01C9D79F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support EDAC INT mode for AMD8111 EDAC driver, which may post upstream
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
---
 drivers/edac/amd8111_edac.c |  348 +++++++++++++++++++++++++++++++++++++------
 drivers/edac/amd8111_edac.h |   43 +++++-
 2 files changed, 343 insertions(+), 48 deletions(-)

diff --git a/drivers/edac/amd8111_edac.c b/drivers/edac/amd8111_edac.c
index 35b78d0..10dc8ac 100644
--- a/drivers/edac/amd8111_edac.c
+++ b/drivers/edac/amd8111_edac.c
@@ -38,6 +38,11 @@
 
 #define PCI_DEVICE_ID_AMD_8111_PCI	0x7460
 
+static int amd8111_op_state = EDAC_OPSTATE_POLL;
+module_param(amd8111_op_state, int, 0444);
+MODULE_PARM_DESC(amd8111_op_state, "EDAC Error Reporting state: 0=Poll, 1=NMI");
+static int amd8111_nmi_irq;
+
 enum amd8111_edac_devs {
 	LPC_BRIDGE = 0,
 };
@@ -89,10 +94,9 @@ static void edac_pci_write_byte(struct pci_dev *dev, int reg, u8 val8)
 			" PCI Access Write Error at 0x%x\n", reg);
 }
 
+/* device specific methods for AMD8111 PCI Bridge device */
 /*
- * device-specific methods for amd8111 PCI Bridge Controller
- *
- * Error Reporting and Handling for amd8111 chipset could be found
+ * Error Reporting and Handling for AMD8111 chipset could be found
  * in its datasheet 3.1.2 section, P37
  */
 static void amd8111_pci_bridge_init(struct amd8111_pci_info *pci_info)
@@ -125,7 +129,7 @@ static void amd8111_pci_bridge_init(struct amd8111_pci_info *pci_info)
 		edac_pci_write_dword(dev, REG_PCI_INTBRG_CTRL, val32);
 
 	/* Last enable error detections */
-	if (edac_op_state == EDAC_OPSTATE_POLL) {
+	if (amd8111_op_state == EDAC_OPSTATE_POLL) {
 		/* Enable System Error reporting in global status register */
 		edac_pci_read_dword(dev, REG_PCI_STSCMD, &val32);
 		val32 |= PCI_STSCMD_SERREN;
@@ -140,6 +144,11 @@ static void amd8111_pci_bridge_init(struct amd8111_pci_info *pci_info)
 		edac_pci_read_dword(dev, REG_PCI_INTBRG_CTRL, &val32);
 		val32 |= PCI_INTBRG_CTRL_POLL_MASK;
 		edac_pci_write_dword(dev, REG_PCI_INTBRG_CTRL, val32);
+	} else if (amd8111_op_state == EDAC_OPSTATE_NMI) {
+		/* Enable Parity Error detection on secondary PCI bus */
+		edac_pci_read_dword(dev, REG_PCI_INTBRG_CTRL, &val32);
+		val32 |= PCI_INTBRG_CTRL_PEREN;
+		edac_pci_write_dword(dev, REG_PCI_INTBRG_CTRL, val32);
 	}
 }
 
@@ -148,7 +157,7 @@ static void amd8111_pci_bridge_exit(struct amd8111_pci_info *pci_info)
 	u32 val32;
 	struct pci_dev *dev = pci_info->dev;
 
-	if (edac_op_state == EDAC_OPSTATE_POLL) {
+	if (amd8111_op_state == EDAC_OPSTATE_POLL) {
 		/* Disable System Error reporting */
 		edac_pci_read_dword(dev, REG_PCI_STSCMD, &val32);
 		val32 &= ~PCI_STSCMD_SERREN;
@@ -163,6 +172,11 @@ static void amd8111_pci_bridge_exit(struct amd8111_pci_info *pci_info)
 		edac_pci_read_dword(dev, REG_PCI_INTBRG_CTRL, &val32);
 		val32 &= ~PCI_INTBRG_CTRL_POLL_MASK;
 		edac_pci_write_dword(dev, REG_PCI_INTBRG_CTRL, val32);
+	} else if (amd8111_op_state == EDAC_OPSTATE_NMI) {
+		/* Disable Parity Error detection on secondary PCI bus */
+		edac_pci_read_dword(dev, REG_PCI_INTBRG_CTRL, &val32);
+		val32 &= ~PCI_INTBRG_CTRL_PEREN;
+		edac_pci_write_dword(dev, REG_PCI_INTBRG_CTRL, val32);
 	}
 }
 
@@ -238,11 +252,136 @@ static void amd8111_pci_bridge_check(struct edac_pci_ctl_info *edac_dev)
 	}
 }
 
+static irqreturn_t amd8111_pci_bridge_isr(int irq, void *dev_id)
+{
+	struct edac_pci_ctl_info *edac_dev = dev_id;
+	struct amd8111_pci_info *pci_info = edac_dev->pvt_info;
+	struct pci_dev *dev = pci_info->dev;
+	u32 stscmd, htlink, intbrg, memlim;
+
+	edac_pci_read_dword(dev, REG_PCI_STSCMD, &stscmd);
+	edac_pci_read_dword(dev, REG_HT_LINK, &htlink);
+	edac_pci_read_dword(dev, REG_PCI_INTBRG_CTRL, &intbrg);
+	edac_pci_read_dword(dev, REG_MEM_LIM, &memlim);
+
+	if (!((stscmd & PCI_STSCMD_NMI_MASK) ||
+	      (htlink & HT_LINK_CRCERR) ||
+	      (intbrg & PCI_INTBRG_CTRL_DTSTAT) ||
+	      (memlim & MEM_LIMIT_CLEAR_MASK)))
+		return IRQ_NONE;
+
+	amd8111_pci_bridge_check(edac_dev);
+
+	return IRQ_HANDLED;
+}
+
+/* device specific methods for AMD8111 LPC Bridge device */
+/*
+ * According to AMD8111 datasheet 3.4.2.4 section, NMI is controlled
+ * by following equation:
+ * NMI = ~PORT70[NMIDIS] &
+ * 	(PM48[NMI_NOW] | ~PM48[NMI2SMI_EN] &
+ *	 (PORT61[SERR] & ~PORT61[CLRSERR]
+ *	 | PORT61[IOCHK] & ~PORT61[CLRIOCHK]
+ *	 | DevB:0x40[NMIONERR] & [status bits described in section 3.1.2]
+ *	 | DevA:0x1C[MDPE] & DevA:0x3C[PEREN]));
+ *
+ * PORT70[NMIDIS] and PM48[NMI2SMI_EN] will be turned off here
+ * if necessary, the rest of device-specific NMI control bits
+ * will be set separately.
+ */
+static int amd8111_NMI_global_enable(struct pci_dev *lpc_dev)
+{
+	struct pci_dev *dev = lpc_dev;
+	u8 val8;
+	u16 val16;
+	u32 val32, mapbase;
+	void __iomem *mmio_vbase;
+
+	/*
+	 * Global NMI disablement status could be read from
+	 * DevB:0x41[NMIDIS], clear PORT70[NMIDIS] only when
+	 * DevB:0x41[NMIDIS] is set.
+	 */
+	edac_pci_read_byte(dev, REG_IO_CTRL_2, &val8);
+	if (val8 & IO_CTRL_2_NMIDIS) {
+		val8 = __do_inb(REG_RTC);
+		val8 &= ~RTC_NMIDIS;
+		__do_outb(val8, REG_RTC);
+	}
+
+	/*
+	 * The start address of the 256-byte relocatable System Management
+	 * I/O register block is specified by DevB:3x58[PMBASE], and
+	 * accessing this MMIO region is controlled by DevB:3x41[PMIOEN].
+	 */
+	dev = pci_get_device(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8111_SMBUS,
+			     NULL);
+	if (!dev) {
+		printk(KERN_ERR "%s: AMD8111 NMI control device not found: "
+			"vendor %x, device %x\n", __func__,
+			PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8111_SMBUS);
+		return -ENODEV;
+	}
+
+	if (pci_enable_device(dev)) {
+		pci_dev_put(dev);
+		printk(KERN_ERR "%s: failed to enable: "
+			"vendor %x, device %x\n", __func__,
+			PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8111_SMBUS);
+		return -ENODEV;
+	}
+
+	edac_pci_read_byte(dev, REG_GEN_CONFIG_2, &val8);
+	if (!(val8 & GEN_CONFIG_2_PMIOEN)) {
+		val8 |= GEN_CONFIG_2_PMIOEN;
+		edac_pci_write_byte(dev, REG_GEN_CONFIG_2, val8);
+	}
+
+	/*
+	 * get the physical address of the relocatable 256-byte
+	 * System Management I/O register block.
+	 */
+	edac_pci_read_dword(dev, REG_SYSMAN_IO_SPACE, &val32);
+	mapbase = val32 & SYSMAN_IO_SPACE_PMBASE_MASK;
+	mapbase += dev->bus->resource[0]->start;
+
+	if (!request_mem_region(mapbase, AMD8111_SYSMAN_IO_SIZE,
+				"amd8111_PMxx")) {
+		pci_dev_put(dev);
+		printk(KERN_ERR "%s: failed to request region\n", __func__);
+		return -EBUSY;
+	}
+
+	mmio_vbase = ioremap(mapbase, AMD8111_SYSMAN_IO_SIZE);
+	if (!mmio_vbase) {
+		printk(KERN_ERR "%s: failed to ioremap region: "
+			"address 0x%x, len 0x%x\n", __func__,
+			mapbase, AMD8111_SYSMAN_IO_SIZE);
+		pci_dev_put(dev);
+		return -ENOMEM;
+	}
+
+	/* clear PM48[NMI2SMI_EN] if necessary */
+	val16 = in_le16(mmio_vbase + IO_TCO_CTRL_1);
+	if (val16 & IO_TCO_CTRL_1_NMI2SMI_EN) {
+		val16 &= ~IO_TCO_CTRL_1_NMI2SMI_EN;
+		out_le16(mmio_vbase + IO_TCO_CTRL_1, val16);
+		printk(KERN_INFO "%s: PM48[NMI2SMI_EN] is cleared\n", __func__);
+	}
+
+	iounmap(mmio_vbase);
+	release_mem_region(mapbase, AMD8111_SYSMAN_IO_SIZE);
+
+	pci_dev_put(dev);
+
+	return 0;
+}
+
 static struct resource *legacy_io_res;
 static int at_compat_reg_broken;
 #define LEGACY_NR_PORTS	1
 
-/* device-specific methods for amd8111 LPC Bridge device */
 static void amd8111_lpc_bridge_init(struct amd8111_dev_info *dev_info)
 {
 	u8 val8;
@@ -278,10 +417,29 @@ static void amd8111_lpc_bridge_init(struct amd8111_dev_info *dev_info)
 	edac_pci_read_byte(dev, REG_IO_CTRL_1, &val8);
 	if (val8 & IO_CTRL_1_CLEAR_MASK)
 		edac_pci_write_byte(dev, REG_IO_CTRL_1, val8);
+
+	if (amd8111_op_state == EDAC_OPSTATE_NMI) {
+		/* Enable NMI generation on errors */
+		edac_pci_read_byte(dev, REG_IO_CTRL_1, &val8);
+		val8 |= IO_CTRL_1_NMIONERR;
+		edac_pci_write_byte(dev, REG_IO_CTRL_1, val8);
+
+		amd8111_NMI_global_enable(dev);
+	}
 }
 
 static void amd8111_lpc_bridge_exit(struct amd8111_dev_info *dev_info)
 {
+	u8 val8;
+	struct pci_dev *dev = dev_info->dev;
+
+	if (amd8111_op_state == EDAC_OPSTATE_NMI) {
+		/* Disable NMI generation on errors */
+		edac_pci_read_byte(dev, REG_IO_CTRL_1, &val8);
+		val8 &= ~IO_CTRL_1_NMIONERR;
+		edac_pci_write_byte(dev, REG_IO_CTRL_1, val8);
+	}
+
 	if (legacy_io_res)
 		release_region(REG_AT_COMPAT, LEGACY_NR_PORTS);
 }
@@ -322,6 +480,22 @@ static void amd8111_lpc_bridge_check(struct edac_device_ctl_info *edac_dev)
 	}
 }
 
+static irqreturn_t amd8111_lpc_bridge_isr(int irq, void *dev_id)
+{
+	struct edac_device_ctl_info *edac_dev = dev_id;
+	struct amd8111_dev_info *dev_info = edac_dev->pvt_info;
+	struct pci_dev *dev = dev_info->dev;
+	u8 val8;
+
+	edac_pci_read_byte(dev, REG_IO_CTRL_1, &val8);
+	if (!(val8 & IO_CTRL_1_CLEAR_MASK))
+		return IRQ_NONE;
+
+	amd8111_lpc_bridge_check(edac_dev);
+
+	return IRQ_HANDLED;
+}
+
 /* General devices represented by edac_device_ctl_info */
 static struct amd8111_dev_info amd8111_devices[] = {
 	[LPC_BRIDGE] = {
@@ -330,6 +504,7 @@ static struct amd8111_dev_info amd8111_devices[] = {
 		.init = amd8111_lpc_bridge_init,
 		.exit = amd8111_lpc_bridge_exit,
 		.check = amd8111_lpc_bridge_check,
+		.isr = amd8111_lpc_bridge_isr,
 	},
 	{0},
 };
@@ -342,6 +517,7 @@ static struct amd8111_pci_info amd8111_pcis[] = {
 		.init = amd8111_pci_bridge_init,
 		.exit = amd8111_pci_bridge_exit,
 		.check = amd8111_pci_bridge_check,
+		.isr = amd8111_pci_bridge_isr,
 	},
 	{0},
 };
@@ -350,25 +526,24 @@ static int amd8111_dev_probe(struct pci_dev *dev,
 				const struct pci_device_id *id)
 {
 	struct amd8111_dev_info *dev_info = &amd8111_devices[id->driver_data];
+	int ret = -ENODEV;
 
 	dev_info->dev = pci_get_device(PCI_VENDOR_ID_AMD,
 					dev_info->err_dev, NULL);
-
 	if (!dev_info->dev) {
 		printk(KERN_ERR "EDAC device not found:"
 			"vendor %x, device %x, name %s\n",
 			PCI_VENDOR_ID_AMD, dev_info->err_dev,
 			dev_info->ctl_name);
-		return -ENODEV;
+		goto out;
 	}
 
 	if (pci_enable_device(dev_info->dev)) {
-		pci_dev_put(dev_info->dev);
 		printk(KERN_ERR "failed to enable:"
 			"vendor %x, device %x, name %s\n",
 			PCI_VENDOR_ID_AMD, dev_info->err_dev,
 			dev_info->ctl_name);
-		return -ENODEV;
+		goto err1;
 	}
 
 	/*
@@ -381,8 +556,10 @@ static int amd8111_dev_probe(struct pci_dev *dev,
 		edac_device_alloc_ctl_info(0, dev_info->ctl_name, 1,
 					   NULL, 0, 0,
 					   NULL, 0, dev_info->edac_idx);
-	if (!dev_info->edac_dev)
-		return -ENOMEM;
+	if (!dev_info->edac_dev) {
+		ret = -ENOMEM;
+		goto err1;
+	}
 
 	dev_info->edac_dev->pvt_info = dev_info;
 	dev_info->edac_dev->dev = &dev_info->dev->dev;
@@ -390,7 +567,7 @@ static int amd8111_dev_probe(struct pci_dev *dev,
 	dev_info->edac_dev->ctl_name = dev_info->ctl_name;
 	dev_info->edac_dev->dev_name = dev_name(&dev_info->dev->dev);
 
-	if (edac_op_state == EDAC_OPSTATE_POLL)
+	if (amd8111_op_state == EDAC_OPSTATE_POLL)
 		dev_info->edac_dev->edac_check = dev_info->check;
 
 	if (dev_info->init)
@@ -399,16 +576,27 @@ static int amd8111_dev_probe(struct pci_dev *dev,
 	if (edac_device_add_device(dev_info->edac_dev) > 0) {
 		printk(KERN_ERR "failed to add edac_dev for %s\n",
 			dev_info->ctl_name);
-		edac_device_free_ctl_info(dev_info->edac_dev);
-		return -ENODEV;
+		ret = -ENOMEM;
+		goto err2;
 	}
 
-	printk(KERN_INFO "added one edac_dev on AMD8111 "
+	printk(KERN_INFO "added one device on AMD8111 "
 		"vendor %x, device %x, name %s\n",
 		PCI_VENDOR_ID_AMD, dev_info->err_dev,
 		dev_info->ctl_name);
 
-	return 0;
+	ret = 0;
+	goto out;
+
+err2:
+	if (dev_info->exit)
+		dev_info->exit(dev_info);
+
+	edac_device_free_ctl_info(dev_info->edac_dev);
+err1:
+	pci_dev_put(dev_info->dev);
+out:
+	return ret;
 }
 
 static void amd8111_dev_remove(struct pci_dev *dev)
@@ -422,14 +610,14 @@ static void amd8111_dev_remove(struct pci_dev *dev)
 	if (!dev_info->err_dev)	/* should never happen */
 		return;
 
+	if (dev_info->exit)
+		dev_info->exit(dev_info);
+
 	if (dev_info->edac_dev) {
 		edac_device_del_device(dev_info->edac_dev->dev);
 		edac_device_free_ctl_info(dev_info->edac_dev);
 	}
 
-	if (dev_info->exit)
-		dev_info->exit(dev_info);
-
 	pci_dev_put(dev_info->dev);
 }
 
@@ -437,25 +625,24 @@ static int amd8111_pci_probe(struct pci_dev *dev,
 				const struct pci_device_id *id)
 {
 	struct amd8111_pci_info *pci_info = &amd8111_pcis[id->driver_data];
+	int ret = -ENODEV;
 
 	pci_info->dev = pci_get_device(PCI_VENDOR_ID_AMD,
 					pci_info->err_dev, NULL);
-
 	if (!pci_info->dev) {
 		printk(KERN_ERR "EDAC device not found:"
 			"vendor %x, device %x, name %s\n",
 			PCI_VENDOR_ID_AMD, pci_info->err_dev,
 			pci_info->ctl_name);
-		return -ENODEV;
+		goto out;
 	}
 
 	if (pci_enable_device(pci_info->dev)) {
-		pci_dev_put(pci_info->dev);
 		printk(KERN_ERR "failed to enable:"
 			"vendor %x, device %x, name %s\n",
 			PCI_VENDOR_ID_AMD, pci_info->err_dev,
 			pci_info->ctl_name);
-		return -ENODEV;
+		goto err1;
 	}
 
 	/*
@@ -465,8 +652,10 @@ static int amd8111_pci_probe(struct pci_dev *dev,
 	*/
 	pci_info->edac_idx = edac_pci_alloc_index();
 	pci_info->edac_dev = edac_pci_alloc_ctl_info(0, pci_info->ctl_name);
-	if (!pci_info->edac_dev)
-		return -ENOMEM;
+	if (!pci_info->edac_dev) {
+		ret = -ENOMEM;
+		goto err1;
+	}
 
 	pci_info->edac_dev->pvt_info = pci_info;
 	pci_info->edac_dev->dev = &pci_info->dev->dev;
@@ -474,7 +663,7 @@ static int amd8111_pci_probe(struct pci_dev *dev,
 	pci_info->edac_dev->ctl_name = pci_info->ctl_name;
 	pci_info->edac_dev->dev_name = dev_name(&pci_info->dev->dev);
 
-	if (edac_op_state == EDAC_OPSTATE_POLL)
+	if (amd8111_op_state == EDAC_OPSTATE_POLL)
 		pci_info->edac_dev->edac_check = pci_info->check;
 
 	if (pci_info->init)
@@ -483,16 +672,27 @@ static int amd8111_pci_probe(struct pci_dev *dev,
 	if (edac_pci_add_device(pci_info->edac_dev, pci_info->edac_idx) > 0) {
 		printk(KERN_ERR "failed to add edac_pci for %s\n",
 			pci_info->ctl_name);
-		edac_pci_free_ctl_info(pci_info->edac_dev);
-		return -ENODEV;
+		ret = -ENOMEM;
+		goto err2;
 	}
 
-	printk(KERN_INFO "added one edac_pci on AMD8111 "
+	printk(KERN_INFO "added one device on AMD8111 "
 		"vendor %x, device %x, name %s\n",
 		PCI_VENDOR_ID_AMD, pci_info->err_dev,
 		pci_info->ctl_name);
 
-	return 0;
+	ret = 0;
+	goto out;
+
+err2:
+	if (pci_info->exit)
+		pci_info->exit(pci_info);
+
+	edac_pci_free_ctl_info(pci_info->edac_dev);
+err1:
+	pci_dev_put(pci_info->dev);
+out:
+	return ret;
 }
 
 static void amd8111_pci_remove(struct pci_dev *dev)
@@ -506,14 +706,14 @@ static void amd8111_pci_remove(struct pci_dev *dev)
 	if (!pci_info->err_dev)	/* should never happen */
 		return;
 
+	if (pci_info->exit)
+		pci_info->exit(pci_info);
+
 	if (pci_info->edac_dev) {
 		edac_pci_del_device(pci_info->edac_dev->dev);
 		edac_pci_free_ctl_info(pci_info->edac_dev);
 	}
 
-	if (pci_info->exit)
-		pci_info->exit(pci_info);
-
 	pci_dev_put(pci_info->dev);
 }
 
@@ -527,9 +727,7 @@ static const struct pci_device_id amd8111_edac_dev_tbl[] = {
 	.class_mask = 0,
 	.driver_data = LPC_BRIDGE,
 	},
-	{
-	0,
-	}			/* table is NULL-terminated */
+	{0}	/* table is NULL-terminated */
 };
 MODULE_DEVICE_TABLE(pci, amd8111_edac_dev_tbl);
 
@@ -550,9 +748,7 @@ static const struct pci_device_id amd8111_edac_pci_tbl[] = {
 	.class_mask = 0,
 	.driver_data = PCI_BRIDGE,
 	},
-	{
-	0,
-	}			/* table is NULL-terminated */
+	{0}	/* table is NULL-terminated */
 };
 MODULE_DEVICE_TABLE(pci, amd8111_edac_pci_tbl);
 
@@ -563,6 +759,69 @@ static struct pci_driver amd8111_edac_pci_driver = {
 	.id_table = amd8111_edac_pci_tbl,
 };
 
+/*
+ * AMD8111 NMI handler - check Legacy ISA Bridge and PCI Bridge
+ * to claim any possible NMI instance.
+ * Southbridge NMI Request messages posted through Hypertransport
+ * Channel will be transferred to a MPIC interrupt instance.
+ */
+static irqreturn_t amd8111_nmi_handler(int irq, void *dev_id)
+{
+	struct amd8111_dev_info *dev_info;
+	struct amd8111_pci_info *pci_info;
+	irqreturn_t ret = IRQ_NONE;
+
+	for (dev_info = amd8111_devices; dev_info->err_dev; dev_info++)
+		if (dev_info->isr)
+			ret |= dev_info->isr(irq, dev_info->edac_dev);
+
+	for (pci_info = amd8111_pcis; pci_info->err_dev; pci_info++)
+		if (pci_info->isr)
+			ret |= pci_info->isr(irq, pci_info->edac_dev);
+
+	return ret;
+}
+
+static void __init amd8111_nmi_handler_setup(void)
+{
+	int ret;
+
+	if (amd8111_op_state != EDAC_OPSTATE_NMI)
+		return;
+
+	amd8111_nmi_irq = NO_IRQ;
+
+#ifdef CONFIG_MPIC
+	amd8111_nmi_irq = edac_get_mpic_irq(MPIC_HWIRQ_HT_NMI);
+#endif
+
+	if (amd8111_nmi_irq == NO_IRQ) {
+		printk(KERN_ERR "%s: failed to get virq "
+			"for AMD8111 NMI requests\n", __func__);
+		return;
+	}
+
+	ret = request_irq(amd8111_nmi_irq, amd8111_nmi_handler,
+			  IRQF_SHARED, "[EDAC] AMD8111", amd8111_devices);
+	if (ret < 0) {
+		printk(KERN_INFO "%s: failed to request irq %d for "
+			"AMD8111 NMI requests\n", __func__, amd8111_nmi_irq);
+		return;
+	}
+
+	debugf0("%s: Successfully requested irq %d for AMD8111 NMI requests\n",
+		__func__, amd8131_nmi_irq);
+}
+
+static void __exit amd8111_nmi_handler_exit(void)
+{
+	if (amd8111_op_state != EDAC_OPSTATE_NMI)
+		return;
+
+	if (amd8111_nmi_irq != NO_IRQ)
+		free_irq(amd8111_nmi_irq, amd8111_devices);
+}
+
 static int __init amd8111_edac_init(void)
 {
 	int val;
@@ -570,12 +829,12 @@ static int __init amd8111_edac_init(void)
 	printk(KERN_INFO "AMD8111 EDAC driver "	AMD8111_EDAC_REVISION "\n");
 	printk(KERN_INFO "\t(c) 2008 Wind River Systems, Inc.\n");
 
-	/* Only POLL mode supported so far */
-	edac_op_state = EDAC_OPSTATE_POLL;
-
 	val = pci_register_driver(&amd8111_edac_dev_driver);
 	val |= pci_register_driver(&amd8111_edac_pci_driver);
 
+	if (val == 0)
+		amd8111_nmi_handler_setup();
+
 	return val;
 }
 
@@ -583,8 +842,9 @@ static void __exit amd8111_edac_exit(void)
 {
 	pci_unregister_driver(&amd8111_edac_pci_driver);
 	pci_unregister_driver(&amd8111_edac_dev_driver);
-}
 
+	amd8111_nmi_handler_exit();
+}
 
 module_init(amd8111_edac_init);
 module_exit(amd8111_edac_exit);
diff --git a/drivers/edac/amd8111_edac.h b/drivers/edac/amd8111_edac.h
index 3579433..51776b1 100644
--- a/drivers/edac/amd8111_edac.h
+++ b/drivers/edac/amd8111_edac.h
@@ -33,9 +33,8 @@ enum pci_stscmd_bits {
 	PCI_STSCMD_RMA		= BIT(29),
 	PCI_STSCMD_RTA		= BIT(28),
 	PCI_STSCMD_SERREN	= BIT(8),
-	PCI_STSCMD_CLEAR_MASK	= (PCI_STSCMD_SSE |
-				   PCI_STSCMD_RMA |
-				   PCI_STSCMD_RTA)
+	PCI_STSCMD_NMI_MASK	= (PCI_STSCMD_RMA | PCI_STSCMD_RTA),
+	PCI_STSCMD_CLEAR_MASK	= (PCI_STSCMD_SSE | PCI_STSCMD_NMI_MASK),
 };
 
 /************************************************************
@@ -62,9 +61,10 @@ enum mem_limit_bits {
  ************************************************************/
 #define REG_HT_LINK	0xc4
 enum ht_link_bits {
+	HT_LINK_CRCERR	= BIT(8),
 	HT_LINK_LKFAIL	= BIT(4),
 	HT_LINK_CRCFEN	= BIT(1),
-	HT_LINK_CLEAR_MASK = (HT_LINK_LKFAIL)
+	HT_LINK_CLEAR_MASK = (HT_LINK_LKFAIL | HT_LINK_CRCERR)
 };
 
 /************************************************************
@@ -105,6 +105,39 @@ enum at_compat_bits {
 	AT_COMPAT_CLRSERR	= BIT(2),
 };
 
+#define REG_IO_CTRL_2 0x41
+enum io_ctrl_2_bits {
+	IO_CTRL_2_NMIDIS	= BIT(1),
+};
+
+/************************************************************
+ *	System Management Configuration Registers, DevB:3xXX
+ ************************************************************/
+#define REG_GEN_CONFIG_2 0x41
+enum gen_config_2_bits {
+	GEN_CONFIG_2_PMIOEN	= BIT(7),
+};
+
+#define REG_SYSMAN_IO_SPACE 0x58
+#define SYSMAN_IO_SPACE_PMBASE_MASK 0xff00
+
+/************************************************************
+ *	System Management I/O Space, PMxx
+ ************************************************************/
+#define AMD8111_SYSMAN_IO_SIZE 256
+#define IO_TCO_CTRL_1 0x48
+enum io_tco_ctrl_1_bits {
+	IO_TCO_CTRL_1_NMI2SMI_EN = BIT(9),
+};
+
+/************************************************************
+ *	Real-Time Clock Port I/O
+ ************************************************************/
+#define REG_RTC	0x70
+enum rtc_bits {
+	RTC_NMIDIS = BIT(7),
+};
+
 struct amd8111_dev_info {
 	u16 err_dev;	/* PCI Device ID */
 	struct pci_dev *dev;
@@ -114,6 +147,7 @@ struct amd8111_dev_info {
 	void (*init)(struct amd8111_dev_info *dev_info);
 	void (*exit)(struct amd8111_dev_info *dev_info);
 	void (*check)(struct edac_device_ctl_info *edac_dev);
+	irqreturn_t (*isr)(int irq, void *dev_id);
 };
 
 struct amd8111_pci_info {
@@ -125,6 +159,7 @@ struct amd8111_pci_info {
 	void (*init)(struct amd8111_pci_info *dev_info);
 	void (*exit)(struct amd8111_pci_info *dev_info);
 	void (*check)(struct edac_pci_ctl_info *edac_dev);
+	irqreturn_t (*isr)(int irq, void *dev_id);
 };
 
 #endif /* _AMD8111_EDAC_H_ */
-- 
1.5.6.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbYGMPNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbYGMPNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 11:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYGMPMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 11:12:54 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:20245 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbYGMPMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 11:12:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=r41hv0/VHLRcBRIwJHmSRqYqk0xR3oZzJCEKkNo/S9hYKT612CxeqfLkcvGOixSvyu
         7Q5RxOAQA1FWMhf3bpy3xQgndJ3NZZ5fGLkF2btMDkbK41WNX5/OdS4HO0ux4mZSDE/s
         fp+1soTzraIjuEpK/cgcbwdh8iXUI+/Avj67w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 14 Jul 2008 17:10:55 +0200
Message-Id: <20080714151055.3106.78013.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/5] ide: include PCI device name in messages from IDE PCI host drivers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:

* Apply small fixes to messages (s/dma/DMA/, remove trailing '.', etc).

* Fix printk() call in ide_setup_pci_baseregs() to use KERN_INFO.

* Move printk() call from ide_pci_clear_simplex() to the caller.

* Cleanup do_ide_setup_pci_device() a bit.

* amd74xx.c: remove superfluous PCI device revision information.

* hpt366.c: fix two printk() calls in ->init_chipset to use KERN_INFO.

* pdc202xx_new.c: fix printk() call in ->init_chipset to use KERN_INFO.

* pdc202xx_old.c: fix driver message in pdc202xx_init_one().

* via82cxxx.c: fix driver warning message in via_init_one().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against ide tree

 drivers/ide/pci/amd74xx.c      |   11 ++--
 drivers/ide/pci/generic.c      |    4 -
 drivers/ide/pci/hpt366.c       |   31 +++++++-----
 drivers/ide/pci/it821x.c       |   11 ++--
 drivers/ide/pci/pdc202xx_new.c |   21 ++++----
 drivers/ide/pci/pdc202xx_old.c |    9 ++-
 drivers/ide/pci/serverworks.c  |    3 -
 drivers/ide/pci/siimage.c      |    7 +-
 drivers/ide/pci/sis5513.c      |   17 ++++---
 drivers/ide/pci/trm290.c       |    4 -
 drivers/ide/pci/via82cxxx.c    |   13 ++---
 drivers/ide/setup-pci.c        |   99 +++++++++++++++++++++++------------------
 12 files changed, 131 insertions(+), 99 deletions(-)

Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -129,9 +129,9 @@ static void __devinit amd7411_cable_dete
 	amd_80w = ((t & 0x3) ? 1 : 0) | ((t & 0xc) ? 2 : 0);
 	for (i = 24; i >= 0; i -= 8)
 		if (((u >> i) & 4) && !(amd_80w & (1 << (1 - (i >> 4))))) {
-			printk(KERN_WARNING "%s: BIOS didn't set cable bits "
-					    "correctly. Enabling workaround.\n",
-					    name);
+			printk(KERN_WARNING "%s %s: BIOS didn't set cable bits "
+				"correctly. Enabling workaround.\n",
+				name, pci_name(dev));
 			amd_80w |= (1 << (1 - (i >> 4)));
 		}
 }
@@ -280,9 +280,8 @@ static int __devinit amd74xx_probe(struc
 			d.udma_mask = ATA_UDMA5;
 	}
 
-	printk(KERN_INFO "%s: %s (rev %02x) UDMA%s controller\n",
-			 d.name, pci_name(dev), dev->revision,
-			 amd_dma[fls(d.udma_mask) - 1]);
+	printk(KERN_INFO "%s %s: UDMA%s controller\n",
+		d.name, pci_name(dev), amd_dma[fls(d.udma_mask) - 1]);
 
 	/*
 	* Determine the system bus clock.
Index: b/drivers/ide/pci/generic.c
===================================================================
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -134,8 +134,8 @@ static int __devinit generic_init_one(st
 		u16 command;
 		pci_read_config_word(dev, PCI_COMMAND, &command);
 		if (!(command & PCI_COMMAND_IO)) {
-			printk(KERN_INFO "Skipping disabled %s IDE "
-					"controller.\n", d->name);
+			printk(KERN_INFO "%s %s: skipping disabled "
+				"controller\n", d->name, pci_name(dev));
 			goto out;
 		}
 	}
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1044,8 +1044,8 @@ static unsigned int __devinit init_chips
 		if ((temp & 0xFFFFF000) != 0xABCDE000) {
 			int i;
 
-			printk(KERN_WARNING "%s: no clock data saved by BIOS\n",
-			       name);
+			printk(KERN_WARNING "%s %s: no clock data saved by "
+				"BIOS\n", name, pci_name(dev));
 
 			/* Calculate the average value of f_CNT. */
 			for (temp = i = 0; i < 128; i++) {
@@ -1070,8 +1070,9 @@ static unsigned int __devinit init_chips
 		else
 			pci_clk = 66;
 
-		printk(KERN_INFO "%s: DPLL base: %d MHz, f_CNT: %d, "
-		       "assuming %d MHz PCI\n", name, dpll_clk, f_cnt, pci_clk);
+		printk(KERN_INFO "%s %s: DPLL base: %d MHz, f_CNT: %d, "
+			"assuming %d MHz PCI\n", name, pci_name(dev),
+			dpll_clk, f_cnt, pci_clk);
 	} else {
 		u32 itr1 = 0;
 
@@ -1137,7 +1138,8 @@ static unsigned int __devinit init_chips
 		}
 
 		if (info->timings->clock_table[clock] == NULL) {
-			printk(KERN_ERR "%s: unknown bus timing!\n", name);
+			printk(KERN_ERR "%s %s: unknown bus timing!\n",
+				name, pci_name(dev));
 			return -EIO;
 		}
 
@@ -1163,16 +1165,19 @@ static unsigned int __devinit init_chips
 				f_low += adjust >> 1;
 		}
 		if (adjust == 8) {
-			printk(KERN_ERR "%s: DPLL did not stabilize!\n", name);
+			printk(KERN_ERR "%s %s: DPLL did not stabilize!\n",
+				name, pci_name(dev));
 			return -EIO;
 		}
 
-		printk("%s: using %d MHz DPLL clock\n", name, dpll_clk);
+		printk(KERN_INFO "%s %s: using %d MHz DPLL clock\n",
+			name, pci_name(dev), dpll_clk);
 	} else {
 		/* Mark the fact that we're not using the DPLL. */
 		dpll_clk = 0;
 
-		printk("%s: using %d MHz PCI clock\n", name, pci_clk);
+		printk(KERN_INFO "%s %s: using %d MHz PCI clock\n",
+			name, pci_name(dev), pci_clk);
 	}
 
 	/* Store the clock frequencies. */
@@ -1357,7 +1362,8 @@ static void __devinit hpt374_init(struct
 	if (dev2->irq != dev->irq) {
 		/* FIXME: we need a core pci_set_interrupt() */
 		dev2->irq = dev->irq;
-		printk(KERN_INFO "HPT374: PCI config space interrupt fixed\n");
+		printk(KERN_INFO "HPT374 %s: PCI config space interrupt "
+			"fixed\n", pci_name(dev2));
 	}
 }
 
@@ -1392,8 +1398,8 @@ static int __devinit hpt36x_init(struct 
 	pci_read_config_byte(dev2, PCI_INTERRUPT_PIN, &pin2);
 
 	if (pin1 != pin2 && dev->irq == dev2->irq) {
-		printk(KERN_INFO "HPT36x: onboard version of chipset, "
-				 "pin1=%d pin2=%d\n", pin1, pin2);
+		printk(KERN_INFO "HPT36x %s: onboard version of chipset, "
+			"pin1=%d pin2=%d\n", pci_name(dev), pin1, pin2);
 		return 1;
 	}
 
@@ -1591,7 +1597,8 @@ static int __devinit hpt366_init_one(str
 
 	dyn_info = kzalloc(sizeof(*dyn_info) * (dev2 ? 2 : 1), GFP_KERNEL);
 	if (dyn_info == NULL) {
-		printk(KERN_ERR "%s: out of memory!\n", d.name);
+		printk(KERN_ERR "%s %s: out of memory!\n",
+			d.name, pci_name(dev));
 		pci_dev_put(dev2);
 		return -ENOMEM;
 	}
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -563,7 +563,8 @@ static void __devinit init_hwif_it821x(i
 		idev->timing10 = 1;
 		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 		if (idev->smart == 0)
-			printk(KERN_WARNING "it821x: Revision 0x10, workarounds activated.\n");
+			printk(KERN_WARNING "it821x %s: revision 0x10, "
+				"workarounds activated\n", pci_name(dev));
 	}
 
 	if (idev->smart == 0) {
@@ -603,11 +604,13 @@ static unsigned int __devinit init_chips
 
 	/* Force the card into bypass mode if so requested */
 	if (it8212_noraid) {
-		printk(KERN_INFO "it8212: forcing bypass mode.\n");
+		printk(KERN_INFO "it821x %s: forcing bypass mode\n",
+			pci_name(dev));
 		it8212_disable_raid(dev);
 	}
 	pci_read_config_byte(dev, 0x50, &conf);
-	printk(KERN_INFO "it821x: controller in %s mode.\n", mode[conf & 1]);
+	printk(KERN_INFO "it821x %s: controller in %s mode\n",
+		pci_name(dev), mode[conf & 1]);
 	return 0;
 }
 
@@ -648,7 +651,7 @@ static int __devinit it821x_init_one(str
 
 	itdevs = kzalloc(2 * sizeof(*itdevs), GFP_KERNEL);
 	if (itdevs == NULL) {
-		printk(KERN_ERR "it821x: out of memory\n");
+		printk(KERN_ERR "it821x %s: out of memory\n", pci_name(dev));
 		return -ENOMEM;
 	}
 
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -358,12 +358,13 @@ static unsigned int __devinit init_chips
 	 * registers setting.
 	 */
 	pll_input = detect_pll_input_clock(dma_base);
-	printk("%s: PLL input clock is %ld kHz\n", name, pll_input / 1000);
+	printk(KERN_INFO "%s %s: PLL input clock is %ld kHz\n",
+		name, pci_name(dev), pll_input / 1000);
 
 	/* Sanity check */
 	if (unlikely(pll_input < 5000000L || pll_input > 70000000L)) {
-		printk(KERN_ERR "%s: Bad PLL input clock %ld Hz, giving up!\n",
-		       name, pll_input);
+		printk(KERN_ERR "%s %s: Bad PLL input clock %ld Hz, giving up!"
+			"\n", name, pci_name(dev), pll_input);
 		goto out;
 	}
 
@@ -399,7 +400,8 @@ static unsigned int __devinit init_chips
 		r = 0x00;
 	} else {
 		/* Invalid ratio */
-		printk(KERN_ERR "%s: Bad ratio %ld, giving up!\n", name, ratio);
+		printk(KERN_ERR "%s %s: Bad ratio %ld, giving up!\n",
+			name, pci_name(dev), ratio);
 		goto out;
 	}
 
@@ -409,7 +411,8 @@ static unsigned int __devinit init_chips
 
 	if (unlikely(f < 0 || f > 127)) {
 		/* Invalid F */
-		printk(KERN_ERR "%s: F[%d] invalid!\n", name, f);
+		printk(KERN_ERR "%s %s: F[%d] invalid!\n",
+			name, pci_name(dev), f);
 		goto out;
 	}
 
@@ -455,8 +458,8 @@ static struct pci_dev * __devinit pdc202
 
 		if (dev2->irq != dev->irq) {
 			dev2->irq = dev->irq;
-			printk(KERN_INFO "PDC20270: PCI config space "
-					 "interrupt fixed\n");
+			printk(KERN_INFO "PDC20270 %s: PCI config space "
+				"interrupt fixed\n", pci_name(dev));
 		}
 
 		return dev2;
@@ -535,8 +538,8 @@ static int __devinit pdc202new_init_one(
 	    bridge->vendor == PCI_VENDOR_ID_INTEL &&
 	    (bridge->device == PCI_DEVICE_ID_INTEL_I960 ||
 	     bridge->device == PCI_DEVICE_ID_INTEL_I960RM)) {
-		printk(KERN_INFO "PDC20276: attached to I2O RAID controller, "
-				 "skipping\n");
+		printk(KERN_INFO "PDC20276 %s: attached to I2O RAID controller,"
+			" skipping\n", pci_name(dev));
 		return -ENODEV;
 	}
 
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -304,8 +304,8 @@ static void __devinit pdc202ata4_fixup_i
 		if (irq != irq2) {
 			pci_write_config_byte(dev,
 				(PCI_INTERRUPT_LINE)|0x80, irq);     /* 0xbc */
-			printk(KERN_INFO "%s: PCI config space interrupt "
-					 "mirror fixed\n", name);
+			printk(KERN_INFO "%s %s: PCI config space interrupt "
+				"mirror fixed\n", name, pci_name(dev));
 		}
 	}
 }
@@ -406,8 +406,9 @@ static int __devinit pdc202xx_init_one(s
 		    bridge->vendor == PCI_VENDOR_ID_INTEL &&
 		    (bridge->device == PCI_DEVICE_ID_INTEL_I960 ||
 		     bridge->device == PCI_DEVICE_ID_INTEL_I960RM)) {
-			printk(KERN_INFO "ide: Skipping Promise PDC20265 "
-				"attached to I2O RAID controller\n");
+			printk(KERN_INFO "pdc202xx_old %s: skipping Promise "
+				"PDC20265 attached to I2O RAID controller\n",
+				pci_name(dev));
 			return -ENODEV;
 		}
 	}
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -188,7 +188,8 @@ static unsigned int __devinit init_chips
 			pci_read_config_dword(isa_dev, 0x64, &reg);
 			reg &= ~0x00002000; /* disable 600ns interrupt mask */
 			if(!(reg & 0x00004000))
-				printk(KERN_DEBUG "%s: UDMA not BIOS enabled.\n", name);
+				printk(KERN_DEBUG "%s %s: UDMA not BIOS "
+					"enabled.\n", name, pci_name(dev));
 			reg |=  0x00004000; /* enable UDMA/33 support */
 			pci_write_config_dword(isa_dev, 0x64, reg);
 		}
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -539,7 +539,8 @@ static unsigned int __devinit init_chips
 			{ "== 100", "== 133", "== 2X PCI", "DISABLED!" };
 
 		tmp >>= 4;
-		printk(KERN_INFO "%s: BASE CLOCK %s\n", name, clk_str[tmp & 3]);
+		printk(KERN_INFO "%s %s: BASE CLOCK %s\n",
+			name, pci_name(dev), clk_str[tmp & 3]);
 	}
 
 	return 0;
@@ -779,8 +780,8 @@ static int __devinit siimage_init_one(st
 		* seem to get terminally confused in the PCI spaces.
 		*/
 		if (!request_mem_region(bar5, barsize, d.name)) {
-			printk(KERN_WARNING "siimage: IDE controller MMIO "
-					    "ports not available.\n");
+			printk(KERN_WARNING "siimage %s: MMIO ports not "
+				"available\n", pci_name(dev));
 		} else {
 			ioaddr = ioremap(bar5, barsize);
 			if (ioaddr == NULL)
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -380,8 +380,9 @@ static int __devinit sis_find_family(str
 		}
 		pci_dev_put(host);
 
-		printk(KERN_INFO "SIS5513: %s %s controller\n",
-			 SiSHostChipInfo[i].name, chipset_capability[chipset_family]);
+		printk(KERN_INFO "SIS5513 %s: %s %s controller\n",
+			pci_name(dev), SiSHostChipInfo[i].name,
+			chipset_capability[chipset_family]);
 	}
 
 	if (!chipset_family) { /* Belongs to pci-quirks */
@@ -396,7 +397,8 @@ static int __devinit sis_find_family(str
 			pci_write_config_dword(dev, 0x54, idemisc);
 
 			if (trueid == 0x5518) {
-				printk(KERN_INFO "SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller\n");
+				printk(KERN_INFO "SIS5513 %s: SiS 962/963 MuTIOL IDE UDMA133 controller\n",
+					pci_name(dev));
 				chipset_family = ATA_133;
 
 				/* Check for 5513 compability mapping
@@ -405,7 +407,8 @@ static int __devinit sis_find_family(str
 				 */
 				if ((idemisc & 0x40000000) == 0) {
 					pci_write_config_dword(dev, 0x54, idemisc | 0x40000000);
-					printk(KERN_INFO "SIS5513: Switching to 5513 register mapping\n");
+					printk(KERN_INFO "SIS5513 %s: Switching to 5513 register mapping\n",
+						pci_name(dev));
 				}
 			}
 	}
@@ -429,10 +432,12 @@ static int __devinit sis_find_family(str
 				pci_dev_put(lpc_bridge);
 
 				if (lpc_bridge->revision == 0x10 && (prefctl & 0x80)) {
-					printk(KERN_INFO "SIS5513: SiS 961B MuTIOL IDE UDMA133 controller\n");
+					printk(KERN_INFO "SIS5513 %s: SiS 961B MuTIOL IDE UDMA133 controller\n",
+						pci_name(dev));
 					chipset_family = ATA_133a;
 				} else {
-					printk(KERN_INFO "SIS5513: SiS 961 MuTIOL IDE UDMA100 controller\n");
+					printk(KERN_INFO "SIS5513 %s: SiS 961 MuTIOL IDE UDMA100 controller\n",
+						pci_name(dev));
 					chipset_family = ATA_100;
 				}
 			}
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -245,10 +245,10 @@ static void __devinit init_hwif_trm290(i
 	u8 reg = 0;
 
 	if ((dev->class & 5) && cfg_base)
-		printk(KERN_INFO "TRM290: chip");
+		printk(KERN_INFO "TRM290 %s: chip", pci_name(dev));
 	else {
 		cfg_base = 0x3df0;
-		printk(KERN_INFO "TRM290: using default");
+		printk(KERN_INFO "TRM290 %s: using default", pci_name(dev));
 	}
 	printk(KERN_CONT " config base at 0x%04x\n", cfg_base);
 	hwif->config_data = cfg_base;
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -401,20 +401,19 @@ static int __devinit via_init_one(struct
 	 */
 	via_config = via_config_find(&isa);
 	if (!via_config->id) {
-		printk(KERN_WARNING "VP_IDE: Unknown VIA SouthBridge, disabling DMA.\n");
+		printk(KERN_WARNING "VP_IDE %s: unknown chipset, skipping\n",
+			pci_name(dev));
 		return -ENODEV;
 	}
 
 	/*
 	 * Print the boot message.
 	 */
-	printk(KERN_INFO "VP_IDE: VIA %s (rev %02x) IDE %sDMA%s "
-		"controller on pci%s\n",
-		via_config->name, isa->revision,
+	printk(KERN_INFO "VP_IDE %s: VIA %s (rev %02x) IDE %sDMA%s\n",
+		pci_name(dev), via_config->name, isa->revision,
 		via_config->udma_mask ? "U" : "MW",
 		via_dma[via_config->udma_mask ?
-			(fls(via_config->udma_mask) - 1) : 0],
-		pci_name(dev));
+			(fls(via_config->udma_mask) - 1) : 0]);
 
 	pci_dev_put(isa);
 
@@ -454,7 +453,7 @@ static int __devinit via_init_one(struct
 
 	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
 	if (!vdev) {
-		printk(KERN_ERR "VP_IDE: out of memory :(\n");
+		printk(KERN_ERR "VP_IDE %s: out of memory :(\n", pci_name(dev));
 		return -ENOMEM;
 	}
 
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -39,17 +39,18 @@ static int ide_setup_pci_baseregs(struct
 	if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
 			 (progif & 5) != 5) {
 		if ((progif & 0xa) != 0xa) {
-			printk(KERN_INFO "%s: device not capable of full "
-				"native PCI mode\n", name);
+			printk(KERN_INFO "%s %s: device not capable of full "
+				"native PCI mode\n", name, pci_name(dev));
 			return -EOPNOTSUPP;
 		}
-		printk("%s: placing both ports into native PCI mode\n", name);
+		printk(KERN_INFO "%s %s: placing both ports into native PCI "
+			"mode\n", name, pci_name(dev));
 		(void) pci_write_config_byte(dev, PCI_CLASS_PROG, progif|5);
 		if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
 		    (progif & 5) != 5) {
-			printk(KERN_ERR "%s: rewrite of PROGIF failed, wanted "
-				"0x%04x, got 0x%04x\n",
-				name, progif|5, progif);
+			printk(KERN_ERR "%s %s: rewrite of PROGIF failed, "
+				"wanted 0x%04x, got 0x%04x\n",
+				name, pci_name(dev), progif | 5, progif);
 			return -EOPNOTSUPP;
 		}
 	}
@@ -57,14 +58,14 @@ static int ide_setup_pci_baseregs(struct
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
-static void ide_pci_clear_simplex(unsigned long dma_base, const char *name)
+static int ide_pci_clear_simplex(unsigned long dma_base, const char *name)
 {
 	u8 dma_stat = inb(dma_base + 2);
 
 	outb(dma_stat & 0x60, dma_base + 2);
 	dma_stat = inb(dma_base + 2);
-	if (dma_stat & 0x80)
-		printk(KERN_INFO "%s: simplex device: DMA forced\n", name);
+
+	return (dma_stat & 0x80) ? 1 : 0;
 }
 
 /**
@@ -91,7 +92,8 @@ unsigned long ide_pci_dma_base(ide_hwif_
 		dma_base = pci_resource_start(dev, baridx);
 
 		if (dma_base == 0) {
-			printk(KERN_ERR "%s: DMA base is invalid\n", d->name);
+			printk(KERN_ERR "%s %s: DMA base is invalid\n",
+				d->name, pci_name(dev));
 			return 0;
 		}
 	}
@@ -105,13 +107,16 @@ EXPORT_SYMBOL_GPL(ide_pci_dma_base);
 
 int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 dma_stat;
 
 	if (d->host_flags & (IDE_HFLAG_MMIO | IDE_HFLAG_CS5520))
 		goto out;
 
 	if (d->host_flags & IDE_HFLAG_CLEAR_SIMPLEX) {
-		ide_pci_clear_simplex(hwif->dma_base, d->name);
+		if (ide_pci_clear_simplex(hwif->dma_base, d->name))
+			printk(KERN_INFO "%s %s: simplex device: DMA forced\n",
+				d->name, pci_name(dev));
 		goto out;
 	}
 
@@ -127,7 +132,8 @@ int ide_pci_check_simplex(ide_hwif_t *hw
 	 */
 	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
 	if ((dma_stat & 0x80) && hwif->mate && hwif->mate->dma_base) {
-		printk(KERN_INFO "%s: simplex device: DMA disabled\n", d->name);
+		printk(KERN_INFO "%s %s: simplex device: DMA disabled\n",
+			d->name, pci_name(dev));
 		return -1;
 	}
 out:
@@ -149,8 +155,8 @@ int ide_pci_set_master(struct pci_dev *d
 
 		if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd) ||
 		    (pcicmd & PCI_COMMAND_MASTER) == 0) {
-			printk(KERN_ERR "%s: error updating PCICMD on %s\n",
-					name, pci_name(dev));
+			printk(KERN_ERR "%s %s: error updating PCICMD\n",
+				name, pci_name(dev));
 			return -EIO;
 		}
 	}
@@ -162,9 +168,9 @@ EXPORT_SYMBOL_GPL(ide_pci_set_master);
 
 void ide_setup_pci_noise(struct pci_dev *dev, const struct ide_port_info *d)
 {
-	printk(KERN_INFO "%s: IDE controller (0x%04x:0x%04x rev 0x%02x) at "
-			 " PCI slot %s\n", d->name, dev->vendor, dev->device,
-			 dev->revision, pci_name(dev));
+	printk(KERN_INFO "%s %s: IDE controller (0x%04x:0x%04x rev 0x%02x)\n",
+		d->name, pci_name(dev),
+		dev->vendor, dev->device, dev->revision);
 }
 EXPORT_SYMBOL_GPL(ide_setup_pci_noise);
 
@@ -189,11 +195,12 @@ static int ide_pci_enable(struct pci_dev
 	if (pci_enable_device(dev)) {
 		ret = pci_enable_device_io(dev);
 		if (ret < 0) {
-			printk(KERN_WARNING "%s: (ide_setup_pci_device:) "
-				"Could not enable device.\n", d->name);
+			printk(KERN_WARNING "%s %s: couldn't enable device\n",
+				d->name, pci_name(dev));
 			goto out;
 		}
-		printk(KERN_WARNING "%s: BIOS configuration fixed.\n", d->name);
+		printk(KERN_WARNING "%s %s: BIOS configuration fixed\n",
+			d->name, pci_name(dev));
 	}
 
 	/*
@@ -203,7 +210,8 @@ static int ide_pci_enable(struct pci_dev
 	 */
 	ret = pci_set_dma_mask(dev, DMA_32BIT_MASK);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: can't set dma mask\n", d->name);
+		printk(KERN_ERR "%s %s: can't set DMA mask\n",
+			d->name, pci_name(dev));
 		goto out;
 	}
 
@@ -221,7 +229,8 @@ static int ide_pci_enable(struct pci_dev
 
 	ret = pci_request_selected_regions(dev, bars, d->name);
 	if (ret < 0)
-		printk(KERN_ERR "%s: can't reserve resources\n", d->name);
+		printk(KERN_ERR "%s %s: can't reserve resources\n",
+			d->name, pci_name(dev));
 out:
 	return ret;
 }
@@ -247,15 +256,18 @@ static int ide_pci_configure(struct pci_
 	 */
 	if (ide_setup_pci_baseregs(dev, d->name) ||
 	    pci_write_config_word(dev, PCI_COMMAND, pcicmd | PCI_COMMAND_IO)) {
-		printk(KERN_INFO "%s: device disabled (BIOS)\n", d->name);
+		printk(KERN_INFO "%s %s: device disabled (BIOS)\n",
+			d->name, pci_name(dev));
 		return -ENODEV;
 	}
 	if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd)) {
-		printk(KERN_ERR "%s: error accessing PCI regs\n", d->name);
+		printk(KERN_ERR "%s %s: error accessing PCI regs\n",
+			d->name, pci_name(dev));
 		return -EIO;
 	}
 	if (!(pcicmd & PCI_COMMAND_IO)) {
-		printk(KERN_ERR "%s: unable to enable IDE controller\n", d->name);
+		printk(KERN_ERR "%s %s: unable to enable IDE controller\n",
+			d->name, pci_name(dev));
 		return -ENXIO;
 	}
 	return 0;
@@ -311,8 +323,9 @@ static int ide_hw_configure(struct pci_d
 	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
 		if (ide_pci_check_iomem(dev, d, 2 * port) ||
 		    ide_pci_check_iomem(dev, d, 2 * port + 1)) {
-			printk(KERN_ERR "%s: I/O baseregs (BIOS) are reported "
-					"as MEM for port %d!\n", d->name, port);
+			printk(KERN_ERR "%s %s: I/O baseregs (BIOS) are "
+				"reported as MEM for port %d!\n",
+				d->name, pci_name(dev), port);
 			return -EINVAL;
 		}
 
@@ -325,8 +338,8 @@ static int ide_hw_configure(struct pci_d
 	}
 
 	if (!base || !ctl) {
-		printk(KERN_ERR "%s: bad PCI BARs for port %d, skipping\n",
-				d->name, port);
+		printk(KERN_ERR "%s %s: bad PCI BARs for port %d, skipping\n",
+			d->name, pci_name(dev), port);
 		return -EINVAL;
 	}
 
@@ -414,14 +427,16 @@ static int ide_setup_pci_controller(stru
 
 	ret = pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: error accessing PCI regs\n", d->name);
+		printk(KERN_ERR "%s %s: error accessing PCI regs\n",
+			d->name, pci_name(dev));
 		goto out;
 	}
 	if (!(pcicmd & PCI_COMMAND_IO)) {	/* is device disabled? */
 		ret = ide_pci_configure(dev, d);
 		if (ret < 0)
 			goto out;
-		printk(KERN_INFO "%s: device enabled (Linux)\n", d->name);
+		printk(KERN_INFO "%s %s: device enabled (Linux)\n",
+			d->name, pci_name(dev));
 	}
 
 out:
@@ -460,7 +475,8 @@ void ide_pci_setup_ports(struct pci_dev 
 
 		if (e->reg && (pci_read_config_byte(dev, e->reg, &tmp) ||
 		    (tmp & e->mask) != e->val)) {
-			printk(KERN_INFO "%s: IDE port disabled\n", d->name);
+			printk(KERN_INFO "%s %s: IDE port disabled\n",
+				d->name, pci_name(dev));
 			continue;	/* port not enabled */
 		}
 
@@ -506,18 +522,15 @@ static int do_ide_setup_pci_device(struc
 	/* Is it an "IDE storage" device in non-PCI mode? */
 	if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE && (dev->class & 5) != 5) {
 		if (noisy)
-			printk(KERN_INFO "%s: not 100%% native mode: "
-				"will probe irqs later\n", d->name);
+			printk(KERN_INFO "%s %s: not 100%% native mode: will "
+				"probe irqs later\n", d->name, pci_name(dev));
 		pciirq = ret;
-	} else if (!pciirq) {
-		if (noisy)
-			printk(KERN_WARNING "%s: bad irq (%d): will probe later\n",
-				d->name, pciirq);
-		pciirq = 0;
-	} else {
-		if (noisy)
-			printk(KERN_INFO "%s: 100%% native mode on irq %d\n",
-				d->name, pciirq);
+	} else if (!pciirq && noisy) {
+		printk(KERN_WARNING "%s %s: bad irq (%d): will probe later\n",
+			d->name, pci_name(dev), pciirq);
+	} else if (noisy) {
+		printk(KERN_INFO "%s %s: 100%% native mode on irq %d\n",
+			d->name, pci_name(dev), pciirq);
 	}
 
 	ret = pciirq;

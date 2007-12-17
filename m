Return-Path: <linux-kernel-owner+w=401wt.eu-S933652AbXLQVWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbXLQVWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759223AbXLQVWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:22:38 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:46159 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758968AbXLQVWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:22:37 -0500
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2007 16:22:37 EST
Message-Id: <20071217211337.545932066@ldl.fc.hp.com>
References: <20071217210937.103111394@ldl.fc.hp.com>
User-Agent: quilt/0.45-1
Date: Mon, 17 Dec 2007 14:09:40 -0700
From: bjorn.helgaas@hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Cc: linux-pci@atrey.karlin.mff.cuni.cz
Subject: [patch 3/3] PCI: use dev_printk in x86 quirk messages
Content-Disposition: inline; filename=x86-pci-quirk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert quirk printks to dev_printk().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 arch/x86/kernel/quirks.c |   42 ++++++++++++++++++++++--------------------
 arch/x86/pci/fixup.c     |   22 +++++++++++-----------
 2 files changed, 33 insertions(+), 31 deletions(-)

Index: w/arch/x86/kernel/quirks.c
===================================================================
--- w.orig/arch/x86/kernel/quirks.c	2007-12-17 13:56:46.000000000 -0700
+++ w/arch/x86/kernel/quirks.c	2007-12-17 14:09:18.000000000 -0700
@@ -30,8 +30,8 @@
 	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
 
 	if (!(word & (1 << 13))) {
-		printk(KERN_INFO "Intel E7520/7320/7525 detected. "
-			"Disabling irq balancing and affinity\n");
+		dev_info(&dev->dev, "Intel E7520/7320/7525 detected; "
+			"disabling irq balancing and affinity\n");
 #ifdef CONFIG_IRQBALANCE
 		irqbalance_disable("");
 #endif
@@ -104,14 +104,16 @@
 	pci_read_config_dword(dev, 0xF0, &rcba);
 	rcba &= 0xFFFFC000;
 	if (rcba == 0) {
-		printk(KERN_DEBUG "RCBA disabled. Cannot force enable HPET\n");
+		dev_printk(KERN_DEBUG, &dev->dev, "RCBA disabled; "
+			"cannot force enable HPET\n");
 		return;
 	}
 
 	/* use bits 31:14, 16 kB aligned */
 	rcba_base = ioremap_nocache(rcba, 0x4000);
 	if (rcba_base == NULL) {
-		printk(KERN_DEBUG "ioremap failed. Cannot force enable HPET\n");
+		dev_printk(KERN_DEBUG, &dev->dev, "ioremap failed; "
+			"cannot force enable HPET\n");
 		return;
 	}
 
@@ -122,8 +124,8 @@
 		/* HPET is enabled in HPTC. Just not reported by BIOS */
 		val = val & 0x3;
 		force_hpet_address = 0xFED00000 | (val << 12);
-		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
-			       force_hpet_address);
+		dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
+			"0x%lx\n", force_hpet_address);
 		iounmap(rcba_base);
 		return;
 	}
@@ -142,11 +144,12 @@
 	if (err) {
 		force_hpet_address = 0;
 		iounmap(rcba_base);
-		printk(KERN_DEBUG "Failed to force enable HPET\n");
+		dev_printk(KERN_DEBUG, &dev->dev,
+			"Failed to force enable HPET\n");
 	} else {
 		force_hpet_resume_type = ICH_FORCE_HPET_RESUME;
-		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
-			       force_hpet_address);
+		dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
+			"0x%lx\n", force_hpet_address);
 	}
 }
 
@@ -206,8 +209,8 @@
 	if (val & 0x4) {
 		val &= 0x3;
 		force_hpet_address = 0xFED00000 | (val << 12);
-		printk(KERN_DEBUG "HPET at base address 0x%lx\n",
-			       force_hpet_address);
+		dev_printk(KERN_DEBUG, &dev->dev, "HPET at 0x%lx\n",
+			force_hpet_address);
 		return;
 	}
 
@@ -227,14 +230,14 @@
 		/* HPET is enabled in HPTC. Just not reported by BIOS */
 		val &= 0x3;
 		force_hpet_address = 0xFED00000 | (val << 12);
-		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
-			       force_hpet_address);
+		dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
+			"0x%lx\n", force_hpet_address);
 		cached_dev = dev;
 		force_hpet_resume_type = OLD_ICH_FORCE_HPET_RESUME;
 		return;
 	}
 
-	printk(KERN_DEBUG "Failed to force enable HPET\n");
+	dev_printk(KERN_DEBUG, &dev->dev, "Failed to force enable HPET\n");
 }
 
 /*
@@ -292,8 +295,8 @@
 	 */
 	if (val & 0x80) {
 		force_hpet_address = (val & ~0x3ff);
-		printk(KERN_DEBUG "HPET at base address 0x%lx\n",
-			       force_hpet_address);
+		dev_printk(KERN_DEBUG, &dev->dev, "HPET at 0x%lx\n",
+			force_hpet_address);
 		return;
 	}
 
@@ -307,14 +310,14 @@
 	pci_read_config_dword(dev, 0x68, &val);
 	if (val & 0x80) {
 		force_hpet_address = (val & ~0x3ff);
-		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
-			       force_hpet_address);
+		dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
+			"0x%lx\n", force_hpet_address);
 		cached_dev = dev;
 		force_hpet_resume_type = VT8237_FORCE_HPET_RESUME;
 		return;
 	}
 
-	printk(KERN_DEBUG "Failed to force enable HPET\n");
+	dev_printk(KERN_DEBUG, &dev->dev, "Failed to force enable HPET\n");
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8235,
@@ -342,7 +345,7 @@
 	pci_read_config_dword(dev, 0x44, &val);
 	force_hpet_address = val & 0xfffffffe;
 	force_hpet_resume_type = NVIDIA_FORCE_HPET_RESUME;
-	printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at 0x%lx\n",
 		force_hpet_address);
 	cached_dev = dev;
 	return;
Index: w/arch/x86/pci/fixup.c
===================================================================
--- w.orig/arch/x86/pci/fixup.c	2007-12-17 13:56:46.000000000 -0700
+++ w/arch/x86/pci/fixup.c	2007-12-17 14:09:18.000000000 -0700
@@ -17,7 +17,7 @@
 	int pxb, reg;
 	u8 busno, suba, subb;
 
-	printk(KERN_WARNING "PCI: Searching for i450NX host bridges on %s\n", pci_name(d));
+	dev_warn(&d->dev, "Searching for i450NX host bridges\n");
 	reg = 0xd0;
 	for(pxb=0; pxb<2; pxb++) {
 		pci_read_config_byte(d, reg++, &busno);
@@ -41,7 +41,7 @@
 	 */
 	u8 busno;
 	pci_read_config_byte(d, 0x4a, &busno);
-	printk(KERN_INFO "PCI: i440KX/GX host bridge %s: secondary bus %02x\n", pci_name(d), busno);
+	dev_info(&d->dev, "i440KX/GX host bridge; secondary bus %02x\n", busno);
 	pci_scan_bus_with_sysdata(busno);
 	pcibios_last_bus = -1;
 }
@@ -55,7 +55,7 @@
 	 */
 	int i;
 
-	printk(KERN_WARNING "PCI: Fixing base address flags for device %s\n", pci_name(d));
+	dev_warn(&d->dev, "Fixing base address flags\n");
 	for(i=0; i<4; i++)
 		d->resource[i].flags |= PCI_BASE_ADDRESS_SPACE_IO;
 }
@@ -68,7 +68,7 @@
 	 * Fix class to be PCI_CLASS_STORAGE_SCSI
 	 */
 	if (!d->class) {
-		printk(KERN_WARNING "PCI: fixing NCR 53C810 class code for %s\n", pci_name(d));
+		dev_warn(&d->dev, "Fixing NCR 53C810 class code\n");
 		d->class = PCI_CLASS_STORAGE_SCSI << 8;
 	}
 }
@@ -80,7 +80,7 @@
 	 *  SiS 5597 and 5598 chipsets require latency timer set to
 	 *  at most 32 to avoid lockups.
 	 */
-	DBG("PCI: Setting max latency to 32\n");
+	dev_dbg(&d->dev, "Setting max latency to 32\n");
 	pcibios_max_latency = 32;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_5597, pci_fixup_latency);
@@ -138,7 +138,7 @@
 
 	pci_read_config_byte(d, where, &v);
 	if (v & ~mask) {
-		printk(KERN_WARNING "Disabling VIA memory write queue (PCI ID %04x, rev %02x): [%02x] %02x & %02x -> %02x\n", \
+		dev_warn(&d->dev, "Disabling VIA memory write queue (PCI ID %04x, rev %02x): [%02x] %02x & %02x -> %02x\n", \
 			d->device, d->revision, where, v, mask, v & mask);
 		v &= mask;
 		pci_write_config_byte(d, where, v);
@@ -200,7 +200,7 @@
 	 * Apply fixup if needed, but don't touch disconnect state
 	 */
 	if ((val & 0x00FF0000) != 0x00010000) {
-		printk(KERN_WARNING "PCI: nForce2 C1 Halt Disconnect fixup\n");
+		dev_warn(&dev->dev, "nForce2 C1 Halt Disconnect fixup\n");
 		pci_write_config_dword(dev, 0x6c, (val & 0xFF00FFFF) | 0x00010000);
 	}
 }
@@ -348,7 +348,7 @@
 	pci_read_config_word(pdev, PCI_COMMAND, &config);
 	if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
 		pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
-		printk(KERN_DEBUG "Boot video device is %s\n", pci_name(pdev));
+		dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_video);
@@ -388,11 +388,11 @@
 		/* verify the change for status output */
 		pci_read_config_byte(dev, 0x50, &val);
 		if (val & 0x40)
-			printk(KERN_INFO "PCI: Detected MSI K8T Neo2-FIR, "
+			dev_info(&dev->dev, "Detected MSI K8T Neo2-FIR; "
 					"can't enable onboard soundcard!\n");
 		else
-			printk(KERN_INFO "PCI: Detected MSI K8T Neo2-FIR, "
-					"enabled onboard soundcard.\n");
+			dev_info(&dev->dev, "Detected MSI K8T Neo2-FIR; "
+					"enabled onboard soundcard\n");
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,

--

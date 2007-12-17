Return-Path: <linux-kernel-owner+w=401wt.eu-S1761947AbXLQVPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947AbXLQVPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbXLQVPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:15:00 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:31795 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbXLQVO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:14:58 -0500
Message-Id: <20071217211337.299669996@ldl.fc.hp.com>
References: <20071217210937.103111394@ldl.fc.hp.com>
User-Agent: quilt/0.45-1
Date: Mon, 17 Dec 2007 14:09:39 -0700
From: bjorn.helgaas@hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Cc: linux-pci@atrey.karlin.mff.cuni.cz
Subject: [patch 2/3] PCI: use dev_printk in quirk messages
Content-Disposition: inline; filename=pci-quirk-dev-printk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert quirk printks to dev_printk().

I made the MSI disable messages a little more consistent:

    - always use "disabled", not "deactivated"
    - specify "device MSI disabled" or "subordinate MSI disabled" when
      disabling MSI for only a specific device or subordinate bus

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pci/quirks.c          |  110 +++++++++++++++++++-----------------------
 drivers/usb/host/pci-quirks.c |   13 +---
 2 files changed, 56 insertions(+), 67 deletions(-)

Index: w/drivers/pci/quirks.c
===================================================================
--- w.orig/drivers/pci/quirks.c	2007-12-17 14:09:03.000000000 -0700
+++ w/drivers/pci/quirks.c	2007-12-17 14:09:13.000000000 -0700
@@ -47,7 +47,7 @@
 	while ((d = pci_get_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371SB_0, d))) {
 		pci_read_config_byte(d, 0x82, &dlc);
 		if (!(dlc & 1<<1)) {
-			printk(KERN_ERR "PCI: PIIX3: Enabling Passive Release on %s\n", pci_name(d));
+			dev_err(&d->dev, "PIIX3: Enabling Passive Release\n");
 			dlc |= 1<<1;
 			pci_write_config_byte(d, 0x82, dlc);
 		}
@@ -69,7 +69,7 @@
 {
 	if (!isa_dma_bridge_buggy) {
 		isa_dma_bridge_buggy=1;
-		printk(KERN_INFO "Activating ISA DMA hang workarounds.\n");
+		dev_info(&dev->dev, "Activating ISA DMA hang workarounds\n");
 	}
 }
 	/*
@@ -93,7 +93,7 @@
 static void __devinit quirk_nopcipci(struct pci_dev *dev)
 {
 	if ((pci_pci_problems & PCIPCI_FAIL)==0) {
-		printk(KERN_INFO "Disabling direct PCI/PCI transfers.\n");
+		dev_info(&dev->dev, "Disabling direct PCI/PCI transfers\n");
 		pci_pci_problems |= PCIPCI_FAIL;
 	}
 }
@@ -106,7 +106,7 @@
 	pci_read_config_byte(dev, 0x08, &rev);
 	if (rev == 0x13) {
 		/* Erratum 24 */
-		printk(KERN_INFO "Chipset erratum: Disabling direct PCI/AGP transfers.\n");
+		dev_info(&dev->dev, "Chipset erratum: Disabling direct PCI/AGP transfers\n");
 		pci_pci_problems |= PCIAGP_FAIL;
 	}
 }
@@ -118,7 +118,7 @@
 static void __devinit quirk_triton(struct pci_dev *dev)
 {
 	if ((pci_pci_problems&PCIPCI_TRITON)==0) {
-		printk(KERN_INFO "Limiting direct PCI/PCI transfers.\n");
+		dev_info(&dev->dev, "Limiting direct PCI/PCI transfers\n");
 		pci_pci_problems |= PCIPCI_TRITON;
 	}
 }
@@ -181,7 +181,7 @@
 	busarb &= ~(1<<5);
 	busarb |= (1<<4);
 	pci_write_config_byte(dev, 0x76, busarb);
-	printk(KERN_INFO "Applying VIA southbridge workaround.\n");
+	dev_info(&dev->dev, "Applying VIA southbridge workaround\n");
 exit:
 	pci_dev_put(p);
 }
@@ -199,7 +199,7 @@
 static void __devinit quirk_viaetbf(struct pci_dev *dev)
 {
 	if ((pci_pci_problems&PCIPCI_VIAETBF)==0) {
-		printk(KERN_INFO "Limiting direct PCI/PCI transfers.\n");
+		dev_info(&dev->dev, "Limiting direct PCI/PCI transfers\n");
 		pci_pci_problems |= PCIPCI_VIAETBF;
 	}
 }
@@ -208,7 +208,7 @@
 static void __devinit quirk_vsfx(struct pci_dev *dev)
 {
 	if ((pci_pci_problems&PCIPCI_VSFX)==0) {
-		printk(KERN_INFO "Limiting direct PCI/PCI transfers.\n");
+		dev_info(&dev->dev, "Limiting direct PCI/PCI transfers\n");
 		pci_pci_problems |= PCIPCI_VSFX;
 	}
 }
@@ -223,7 +223,7 @@
 static void __init quirk_alimagik(struct pci_dev *dev)
 {
 	if ((pci_pci_problems&PCIPCI_ALIMAGIK)==0) {
-		printk(KERN_INFO "Limiting direct PCI/PCI transfers.\n");
+		dev_info(&dev->dev, "Limiting direct PCI/PCI transfers\n");
 		pci_pci_problems |= PCIPCI_ALIMAGIK|PCIPCI_TRITON;
 	}
 }
@@ -237,7 +237,7 @@
 static void __devinit quirk_natoma(struct pci_dev *dev)
 {
 	if ((pci_pci_problems&PCIPCI_NATOMA)==0) {
-		printk(KERN_INFO "Limiting direct PCI/PCI transfers.\n");
+		dev_info(&dev->dev, "Limiting direct PCI/PCI transfers\n");
 		pci_pci_problems |= PCIPCI_NATOMA;
 	}
 }
@@ -293,7 +293,7 @@
 		pcibios_bus_to_resource(dev, res, &bus_region);
 
 		pci_claim_resource(dev, nr);
-		printk("PCI quirk: region %04x-%04x claimed by %s\n", region, region + size - 1, name);
+		dev_info(&dev->dev, "quirk: region %04x-%04x claimed by %s\n", region, region + size - 1, name);
 	}
 }	
 
@@ -303,7 +303,7 @@
  */
 static void __devinit quirk_ati_exploding_mce(struct pci_dev *dev)
 {
-	printk(KERN_INFO "ATI Northbridge, reserving I/O ports 0x3b0 to 0x3bb.\n");
+	dev_info(&dev->dev, "ATI Northbridge, reserving I/O ports 0x3b0 to 0x3bb\n");
 	/* Mae rhaid i ni beidio ag edrych ar y lleoliadiau I/O hyn */
 	request_region(0x3b0, 0x0C, "RadeonIGP");
 	request_region(0x3d3, 0x01, "RadeonIGP");
@@ -355,7 +355,7 @@
 	 * let's get enough confirmation reports first. 
 	 */
 	base &= -size;
-	printk("%s PIO at %04x-%04x\n", name, base, base + size - 1);
+	dev_info(&dev->dev, "%s PIO at %04x-%04x\n", name, base, base + size - 1);
 }
 
 static void piix4_mem_quirk(struct pci_dev *dev, const char *name, unsigned int port, unsigned int enable)
@@ -380,7 +380,7 @@
 	 * reserve it, but let's get enough confirmation reports first. 
 	 */
 	base &= -size;
-	printk("%s MMIO at %04x-%04x\n", name, base, base + size - 1);
+	dev_info(&dev->dev, "%s MMIO at %04x-%04x\n", name, base, base + size - 1);
 }
 
 /*
@@ -546,7 +546,7 @@
 	else
 		tmp = 0x1f; /* all known bits (4-0) routed to external APIC */
 		
-	printk(KERN_INFO "PCI: %sbling Via external APIC routing\n",
+	dev_info(&dev->dev, "%sbling VIA external APIC routing\n",
 	       tmp == 0 ? "Disa" : "Ena");
 
 	/* Offset 0x58: External APIC IRQ output control */
@@ -568,7 +568,7 @@
 
 	pci_read_config_byte(dev, 0x5B, &misc_control2);
 	if (!(misc_control2 & BYPASS_APIC_DEASSERT)) {
-		printk(KERN_INFO "PCI: Bypassing VIA 8237 APIC De-Assert Message\n");
+		dev_info(&dev->dev, "Bypassing VIA 8237 APIC De-Assert Message\n");
 		pci_write_config_byte(dev, 0x5B, misc_control2|BYPASS_APIC_DEASSERT);
 	}
 }
@@ -587,8 +587,8 @@
 static void __devinit quirk_amd_ioapic(struct pci_dev *dev)
 {
 	if (dev->revision >= 0x02) {
-		printk(KERN_WARNING "I/O APIC: AMD Erratum #22 may be present. In the event of instability try\n");
-		printk(KERN_WARNING "        : booting with the \"noapic\" option.\n");
+		dev_warn(&dev->dev, "I/O APIC: AMD Erratum #22 may be present. In the event of instability try\n");
+		dev_warn(&dev->dev, "        : booting with the \"noapic\" option\n");
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_VIPER_7410,	quirk_amd_ioapic );
@@ -612,7 +612,7 @@
                 return;
 
         if (dev->revision == AMD8131_revA0 || dev->revision == AMD8131_revB0) {
-                printk(KERN_INFO "Fixing up AMD8131 IOAPIC mode\n"); 
+                dev_info(&dev->dev, "Fixing up AMD8131 IOAPIC mode\n");
                 pci_read_config_byte( dev, AMD8131_MISC, &tmp);
                 tmp &= ~(1 << AMD8131_NIOAMODE_BIT);
                 pci_write_config_byte( dev, AMD8131_MISC, tmp);
@@ -629,8 +629,8 @@
 static void __init quirk_amd_8131_mmrbc(struct pci_dev *dev)
 {
 	if (dev->subordinate && dev->revision <= 0x12) {
-		printk(KERN_INFO "AMD8131 rev %x detected, disabling PCI-X "
-				"MMRBC\n", dev->revision);
+		dev_info(&dev->dev, "AMD8131 rev %x detected; "
+			"disabling PCI-X MMRBC\n", dev->revision);
 		dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MMRBC;
 	}
 }
@@ -737,8 +737,8 @@
 
 	pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &irq);
 	if (new_irq != irq) {
-		printk(KERN_INFO "PCI: VIA VLink IRQ fixup for %s, from %d to %d\n",
-			pci_name(dev), irq, new_irq);
+		dev_info(&dev->dev, "VIA VLink IRQ fixup, from %d to %d\n",
+			irq, new_irq);
 		udelay(15);	/* unknown if delay really needed */
 		pci_write_config_byte(dev, PCI_INTERRUPT_LINE, new_irq);
 	}
@@ -786,7 +786,7 @@
 	pci_read_config_dword(dev, 0x4C, &pcic);
 	if ((pcic&6)!=6) {
 		pcic |= 6;
-		printk(KERN_WARNING "BIOS failed to enable PCI standards compliance, fixing this error.\n");
+		dev_warn(&dev->dev, "BIOS failed to enable PCI standards compliance; fixing this error\n");
 		pci_write_config_dword(dev, 0x4C, pcic);
 		pci_read_config_dword(dev, 0x84, &pcic);
 		pcic |= (1<<23);	/* Required in this mode */
@@ -836,7 +836,7 @@
 	pci_read_config_byte(dev, 0x41, &reg);
 	if (reg & 2) {
 		reg &= ~2;
-		printk(KERN_INFO "PCI: Fixup for MediaGX/Geode Slave Disconnect Boundary (0x41=0x%02x)\n", reg);
+		dev_info(&dev->dev, "Fixup for MediaGX/Geode Slave Disconnect Boundary (0x41=0x%02x)\n", reg);
                 pci_write_config_byte(dev, 0x41, reg);
 	}
 }
@@ -858,7 +858,7 @@
 	if (config & (1<<6)) {
 		config &= ~(1<<6);
 		pci_write_config_word(pdev, 0x40, config);
-		printk(KERN_INFO "PCI: C0 revision 450NX. Disabling PCI restreaming.\n");
+		dev_info(&pdev->dev, "C0 revision 450NX. Disabling PCI restreaming\n");
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82454NX,	quirk_disable_pxb );
@@ -909,7 +909,7 @@
 	pci_read_config_byte(pdev, PCI_CLASS_PROG, &prog);
 
 	if (((prog & 1) && !(prog & 4)) || ((prog & 4) && !(prog & 1))) {
-		printk(KERN_INFO "PCI: IDE mode mismatch; forcing legacy mode\n");
+		dev_info(&pdev->dev, "IDE mode mismatch; forcing legacy mode\n");
 		prog &= ~5;
 		pdev->class &= ~5;
 		pci_write_config_byte(pdev, PCI_CLASS_PROG, prog);
@@ -1068,9 +1068,9 @@
 		pci_write_config_word(dev, 0xF2, val & (~0x8));
 		pci_read_config_word(dev, 0xF2, &val);
 		if (val & 0x8)
-			printk(KERN_INFO "PCI: i801 SMBus device continues to play 'hide and seek'! 0x%x\n", val);
+			dev_info(&dev->dev, "i801 SMBus device continues to play 'hide and seek'! 0x%x\n", val);
 		else
-			printk(KERN_INFO "PCI: Enabled i801 SMBus device\n");
+			dev_info(&dev->dev, "Enabled i801 SMBus device\n");
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801AA_0,	asus_hides_smbus_lpc );
@@ -1101,7 +1101,7 @@
 	val=readl(base + 0x3418); /* read the Function Disable register, dword mode only */
 	writel(val & 0xFFFFFFF7, base + 0x3418); /* enable the SMBus device */
 	iounmap(base);
-	printk(KERN_INFO "PCI: Enabled ICH6/i801 SMBus device\n");
+	dev_info(&dev->dev, "Enabled ICH6/i801 SMBus device\n");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH6_1,	asus_hides_smbus_lpc_ich6 );
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH6_1,	asus_hides_smbus_lpc_ich6 );
@@ -1114,7 +1114,7 @@
 	u8 val = 0;
 	pci_read_config_byte(dev, 0x77, &val);
 	if (val & 0x10) {
-		printk(KERN_INFO "Enabling SiS 96x SMBus.\n");
+		dev_info(&dev->dev, "Enabling SiS 96x SMBus\n");
 		pci_write_config_byte(dev, 0x77, val & ~0x10);
 	}
 }
@@ -1186,9 +1186,9 @@
 		pci_write_config_byte(dev, 0x50, val & (~0xc0));
 		pci_read_config_byte(dev, 0x50, &val);
 		if (val & 0xc0)
-			printk(KERN_INFO "PCI: onboard AC97/MC97 devices continue to play 'hide and seek'! 0x%x\n", val);
+			dev_info(&dev->dev, "Onboard AC97/MC97 devices continue to play 'hide and seek'! 0x%x\n", val);
 		else
-			printk(KERN_INFO "PCI: enabled onboard AC97/MC97 devices\n");
+			dev_info(&dev->dev, "Enabled onboard AC97/MC97 devices\n");
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237, asus_hides_ac97_lpc );
@@ -1309,11 +1309,8 @@
 static void __devinit quirk_pcie_pxh(struct pci_dev *dev)
 {
 	pci_msi_off(dev);
-
 	dev->no_msi = 1;
-
-	printk(KERN_WARNING "PCI: PXH quirk detected, "
-		"disabling MSI for SHPC device\n");
+	dev_warn(&dev->dev, "PXH quirk detected; SHPC device MSI disabled\n");
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_PXHD_0,	quirk_pcie_pxh);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_PXHD_1,	quirk_pcie_pxh);
@@ -1394,7 +1391,7 @@
 	case PCI_DEVICE_ID_NETMOS_9855:
 		if ((dev->class >> 8) == PCI_CLASS_COMMUNICATION_SERIAL &&
 		    num_parallel) {
-			printk(KERN_INFO "PCI: Netmos %04x (%u parallel, "
+			dev_info(&dev->dev, "Netmos %04x (%u parallel, "
 				"%u serial); changing class SERIAL to OTHER "
 				"(use parport_serial)\n",
 				dev->device, num_parallel, num_serial);
@@ -1446,15 +1443,14 @@
 	/* Convert from PCI bus to resource space.  */
 	csr = ioremap(pci_resource_start(dev, 0), 8);
 	if (!csr) {
-		printk(KERN_WARNING "PCI: Can't map %s e100 registers\n",
-			pci_name(dev));
+		dev_warn(&dev->dev, "Can't map e100 registers\n");
 		return;
 	}
 
 	cmd_hi = readb(csr + 3);
 	if (cmd_hi == 0) {
-		printk(KERN_WARNING "PCI: Firmware left %s e100 interrupts "
-			"enabled, disabling\n", pci_name(dev));
+		dev_warn(&dev->dev, "Firmware left e100 interrupts enabled; "
+			"disabling\n");
 		writeb(1, csr + 3);
 	}
 
@@ -1469,7 +1465,7 @@
 	 */
 
 	if (dev->class == PCI_CLASS_NOT_DEFINED) {
-		printk(KERN_INFO "NCR 53c810 rev 1 detected, setting PCI class.\n");
+		dev_info(&dev->dev, "NCR 53c810 rev 1 detected; setting PCI class\n");
 		dev->class = PCI_CLASS_STORAGE_SCSI;
 	}
 }
@@ -1552,7 +1548,7 @@
 	pci_read_config_word(dev, 0x40, &en1k);
 
 	if (en1k & 0x200) {
-		printk(KERN_INFO "PCI: Enable I/O Space to 1 KB Granularity\n");
+		dev_info(&dev->dev, "Enable I/O Space to 1KB granularity\n");
 
 		pci_read_config_byte(dev, PCI_IO_BASE, &io_base_lo);
 		pci_read_config_byte(dev, PCI_IO_LIMIT, &io_limit_lo);
@@ -1584,7 +1580,7 @@
 		iobl_adr_1k = iobl_adr | (res->start >> 8) | (res->end & 0xfc00);
 
 		if (iobl_adr != iobl_adr_1k) {
-			printk(KERN_INFO "PCI: Fixing P64H2 IOBL_ADR from 0x%x to 0x%x for 1 KB Granularity\n",
+			dev_info(&dev->dev, "Fixing P64H2 IOBL_ADR from 0x%x to 0x%x for 1KB granularity\n",
 				iobl_adr,iobl_adr_1k);
 			pci_write_config_word(dev, PCI_IO_BASE, iobl_adr_1k);
 		}
@@ -1602,9 +1598,8 @@
 	if (pci_read_config_byte(dev, 0xf41, &b) == 0) {
 		if (!(b & 0x20)) {
 			pci_write_config_byte(dev, 0xf41, b | 0x20);
-			printk(KERN_INFO
-			       "PCI: Linking AER extended capability on %s\n",
-			       pci_name(dev));
+			dev_info(&dev->dev,
+			       "Linking AER extended capability\n");
 		}
 	}
 }
@@ -1623,7 +1618,7 @@
 static void __init quirk_disable_all_msi(struct pci_dev *dev)
 {
 	pci_no_msi();
-	printk(KERN_WARNING "PCI: MSI quirk detected. MSI deactivated.\n");
+	dev_warn(&dev->dev, "MSI quirk detected; MSI disabled\n");
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
@@ -1634,9 +1629,8 @@
 static void __devinit quirk_disable_msi(struct pci_dev *dev)
 {
 	if (dev->subordinate) {
-		printk(KERN_WARNING "PCI: MSI quirk detected. "
-		       "PCI_BUS_FLAGS_NO_MSI set for %s subordinate bus.\n",
-		       pci_name(dev));
+		dev_warn(&dev->dev, "MSI quirk detected; "
+			"subordinate MSI disabled\n");
 		dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
 	}
 }
@@ -1655,9 +1649,9 @@
 		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
 					 &flags) == 0)
 		{
-			printk(KERN_INFO "PCI: Found %s HT MSI Mapping on %s\n",
+			dev_info(&dev->dev, "Found %s HT MSI Mapping\n",
 				flags & HT_MSI_FLAGS_ENABLE ?
-				"enabled" : "disabled", pci_name(dev));
+				"enabled" : "disabled");
 			return (flags & HT_MSI_FLAGS_ENABLE) != 0;
 		}
 
@@ -1671,9 +1665,8 @@
 static void __devinit quirk_msi_ht_cap(struct pci_dev *dev)
 {
 	if (dev->subordinate && !msi_ht_cap_enabled(dev)) {
-		printk(KERN_WARNING "PCI: MSI quirk detected. "
-		       "MSI disabled on chipset %s.\n",
-		       pci_name(dev));
+		dev_warn(&dev->dev, "MSI quirk detected; "
+			"subordinate MSI disabled\n");
 		dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
 	}
 }
@@ -1700,9 +1693,8 @@
 	if (!pdev)
 		return;
 	if (!msi_ht_cap_enabled(dev) && !msi_ht_cap_enabled(pdev)) {
-		printk(KERN_WARNING "PCI: MSI quirk detected. "
-		       "MSI disabled on chipset %s.\n",
-		       pci_name(dev));
+		dev_warn(&dev->dev, "MSI quirk detected; "
+			"subordinate MSI disabled\n");
 		dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
 	}
 	pci_dev_put(pdev);
Index: w/drivers/usb/host/pci-quirks.c
===================================================================
--- w.orig/drivers/usb/host/pci-quirks.c	2007-12-17 14:09:01.000000000 -0700
+++ w/drivers/usb/host/pci-quirks.c	2007-12-17 14:09:13.000000000 -0700
@@ -190,9 +190,8 @@
 			msleep(10);
 		}
 		if (wait_time <= 0)
-			printk(KERN_WARNING "%s %s: BIOS handoff "
-					"failed (BIOS bug ?) %08x\n",
-					pdev->dev.bus_id, "OHCI",
+			dev_warn(&pdev->dev, "OHCI: BIOS handoff failed"
+					" (BIOS bug?) %08x\n",
 					readl(base + OHCI_CONTROL));
 
 		/* reset controller, preserving RWC */
@@ -243,8 +242,7 @@
 		switch (cap & 0xff) {
 		case 1:			/* BIOS/SMM/... handoff support */
 			if ((cap & EHCI_USBLEGSUP_BIOS)) {
-				pr_debug("%s %s: BIOS handoff\n",
-						pdev->dev.bus_id, "EHCI");
+				dev_dbg(&pdev->dev, "EHCI: BIOS handoff\n");
 
 #if 0
 /* aleksey_gorelov@phoenix.com reports that some systems need SMI forced on,
@@ -285,9 +283,8 @@
 				/* well, possibly buggy BIOS... try to shut
 				 * it down, and hope nothing goes too wrong
 				 */
-				printk(KERN_WARNING "%s %s: BIOS handoff "
-						"failed (BIOS bug ?) %08x\n",
-					pdev->dev.bus_id, "EHCI", cap);
+				dev_warn(&pdev->dev, "EHCI: BIOS handoff failed"
+						" (BIOS bug?) %08x\n", cap);
 				pci_write_config_byte(pdev, offset + 2, 0);
 			}
 
@@ -306,17 +303,14 @@
 			cap = 0;
 			/* FALLTHROUGH */
 		default:
-			printk(KERN_WARNING "%s %s: unrecognized "
-					"capability %02x\n",
-					pdev->dev.bus_id, "EHCI",
-					cap & 0xff);
+			dev_warn(&pdev->dev, "EHCI: unrecognized capability "
+					"%02x\n", cap & 0xff);
 			break;
 		}
 		offset = (cap >> 8) & 0xff;
 	}
 	if (!count)
-		printk(KERN_DEBUG "%s %s: capability loop?\n",
-				pdev->dev.bus_id, "EHCI");
+		dev_printk(KERN_DEBUG, &pdev->dev, "EHCI: capability loop?\n");
 
 	/*
 	 * halt EHCI & disable its interrupts in any case

--

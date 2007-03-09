Return-Path: <linux-kernel-owner+w=401wt.eu-S1767336AbXCIQBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767336AbXCIQBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767335AbXCIQBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:01:36 -0500
Received: from havoc.gtf.org ([69.61.125.42]:33678 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767333AbXCIQBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:01:34 -0500
Date: Fri, 9 Mar 2007 11:01:28 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2.6.22] remove Intel combined mode quirk
Message-ID: <20070309160127.GA10226@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Discussed for 2.6.21, but pushed back because the current SATA code
had enough fun stuff to debug already.  Thus, just queued the following
for 2.6.22 in libata-dev.git#upstream.

The nasty ____request_resource hack is finally gone.

In practical terms, this usually means that some combined mode users
will have their SATA devices driven by the old-IDE driver rather than
libata (because old-IDE is often non-modular, and thus probes first).

But really, these same users will IMO cheer the removal of the
performance-killing split-driver configuration, so its a net win.
And the code is smaller and more clean, with one less special case
hack.

    libata/IDE: remove combined mode quirk
    
    Both old-IDE and libata should be able handle all controllers and
    devices found using normal resource reservation methods.
    
    This eliminates the awful, low-performing split-driver configuration
    where old-IDE drove the PATA portion of a PCI device, in PIO-only mode,
    and libata drove the SATA portion of the /same/ PCI device, in DMA mode.
    Typically vendors would ship SATA hard drive / PATA optical
    configuration, which would lend itself to slow (PIO-only) CD-ROM
    performance.
    
    For Intel users running in combined mode, it is now wholly dependent on
    your driver choice (potentially link order, if you compile both drivers
    in) whether old-IDE or libata will drive your hardware.
    
    In either case, you will get full performance from both SATA and PATA
    ports now, without having to pass a kernel command line parameter.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 arch/i386/defconfig                 |    1 
 arch/parisc/configs/c3000_defconfig |    1 
 arch/x86_64/defconfig               |    1 
 drivers/ata/Kconfig                 |    5 -
 drivers/ata/libata-sff.c            |   36 +----------
 drivers/pci/quirks.c                |  113 ------------------------------------
 include/linux/ioport.h              |    1 
 kernel/resource.c                   |   21 ------
 8 files changed, 6 insertions(+), 173 deletions(-)

diff --git a/arch/i386/defconfig b/arch/i386/defconfig
index 5ae1e0b..0b92a95 100644
--- a/arch/i386/defconfig
+++ b/arch/i386/defconfig
@@ -678,7 +678,6 @@ CONFIG_SATA_SIL=y
 CONFIG_SATA_VIA=y
 # CONFIG_SATA_VITESSE is not set
 # CONFIG_SATA_INIC162X is not set
-CONFIG_SATA_INTEL_COMBINED=y
 # CONFIG_PATA_ALI is not set
 # CONFIG_PATA_AMD is not set
 # CONFIG_PATA_ARTOP is not set
diff --git a/arch/parisc/configs/c3000_defconfig b/arch/parisc/configs/c3000_defconfig
index 782906b..eb2f9a3 100644
--- a/arch/parisc/configs/c3000_defconfig
+++ b/arch/parisc/configs/c3000_defconfig
@@ -435,7 +435,6 @@ CONFIG_SCSI_SATA_SIL=m
 # CONFIG_SCSI_SATA_ULI is not set
 CONFIG_SCSI_SATA_VIA=m
 # CONFIG_SCSI_SATA_VITESSE is not set
-CONFIG_SCSI_SATA_INTEL_COMBINED=y
 # CONFIG_SCSI_DMX3191D is not set
 # CONFIG_SCSI_FUTURE_DOMAIN is not set
 # CONFIG_SCSI_IPS is not set
diff --git a/arch/x86_64/defconfig b/arch/x86_64/defconfig
index 293a4a4..6fe4635 100644
--- a/arch/x86_64/defconfig
+++ b/arch/x86_64/defconfig
@@ -622,7 +622,6 @@ CONFIG_SATA_SIL=y
 CONFIG_SATA_VIA=y
 # CONFIG_SATA_VITESSE is not set
 # CONFIG_SATA_INIC162X is not set
-CONFIG_SATA_INTEL_COMBINED=y
 # CONFIG_PATA_ALI is not set
 # CONFIG_PATA_AMD is not set
 # CONFIG_PATA_ARTOP is not set
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 131a9f7..54ee50b 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -156,11 +156,6 @@ config SATA_INIC162X
 	help
 	  This option enables support for Initio 162x Serial ATA.
 
-config SATA_INTEL_COMBINED
-	bool
-	depends on IDE=y && !BLK_DEV_IDE_SATA && (SATA_AHCI || ATA_PIIX)
-	default y
-
 config SATA_ACPI
 	bool
 	depends on ACPI && PCI
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 066689c..0a19466 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -779,40 +779,16 @@ int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
 		/* Deal with combined mode hack. This side of the logic all
 		   goes away once the combined mode hack is killed in 2.6.21 */
 		if (!devm_request_region(dev, ATA_PRIMARY_CMD, 8, "libata")) {
-			struct resource *conflict, res;
-			res.start = ATA_PRIMARY_CMD;
-			res.end = ATA_PRIMARY_CMD + 8 - 1;
-			conflict = ____request_resource(&ioport_resource, &res);
-			while (conflict->child)
-				conflict = ____request_resource(conflict, &res);
-			if (!strcmp(conflict->name, "libata"))
-				legacy_mode |= ATA_PORT_PRIMARY;
-			else {
-				pcim_pin_device(pdev);
-				printk(KERN_WARNING "ata: 0x%0X IDE port busy\n" \
-						    "ata: conflict with %s\n",
-						    ATA_PRIMARY_CMD,
-						    conflict->name);
-			}
+			pcim_pin_device(pdev);
+			printk(KERN_WARNING "ata: 0x%0X IDE port busy\n",
+					    ATA_PRIMARY_CMD);
 		} else
 			legacy_mode |= ATA_PORT_PRIMARY;
 
 		if (!devm_request_region(dev, ATA_SECONDARY_CMD, 8, "libata")) {
-			struct resource *conflict, res;
-			res.start = ATA_SECONDARY_CMD;
-			res.end = ATA_SECONDARY_CMD + 8 - 1;
-			conflict = ____request_resource(&ioport_resource, &res);
-			while (conflict->child)
-				conflict = ____request_resource(conflict, &res);
-			if (!strcmp(conflict->name, "libata"))
-				legacy_mode |= ATA_PORT_SECONDARY;
-			else {
-				pcim_pin_device(pdev);
-				printk(KERN_WARNING "ata: 0x%X IDE port busy\n" \
-						    "ata: conflict with %s\n",
-						    ATA_SECONDARY_CMD,
-						    conflict->name);
-			}
+			pcim_pin_device(pdev);
+			printk(KERN_WARNING "ata: 0x%X IDE port busy\n",
+					    ATA_SECONDARY_CMD);
 		} else
 			legacy_mode |= ATA_PORT_SECONDARY;
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7f94fc0..75dedc7 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1307,119 +1307,6 @@ static void __init quirk_alder_ioapic(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_EESSC,	quirk_alder_ioapic );
 #endif
 
-enum ide_combined_type { COMBINED = 0, IDE = 1, LIBATA = 2 };
-/* Defaults to combined */
-static enum ide_combined_type combined_mode;
-
-static int __init combined_setup(char *str)
-{
-	if (!strncmp(str, "ide", 3))
-		combined_mode = IDE;
-	else if (!strncmp(str, "libata", 6))
-		combined_mode = LIBATA;
-	else /* "combined" or anything else defaults to old behavior */
-		combined_mode = COMBINED;
-
-	return 1;
-}
-__setup("combined_mode=", combined_setup);
-
-#ifdef CONFIG_SATA_INTEL_COMBINED
-static void __devinit quirk_intel_ide_combined(struct pci_dev *pdev)
-{
-	u8 prog, comb, tmp;
-	int ich = 0;
-
-	/*
-	 * Narrow down to Intel SATA PCI devices.
-	 */
-	switch (pdev->device) {
-	/* PCI ids taken from drivers/scsi/ata_piix.c */
-	case 0x24d1:
-	case 0x24df:
-	case 0x25a3:
-	case 0x25b0:
-		ich = 5;
-		break;
-	case 0x2651:
-	case 0x2652:
-	case 0x2653:
-	case 0x2680:	/* ESB2 */
-		ich = 6;
-		break;
-	case 0x27c0:
-	case 0x27c4:
-		ich = 7;
-		break;
-	case 0x2828:	/* ICH8M */
-		ich = 8;
-		break;
-	default:
-		/* we do not handle this PCI device */
-		return;
-	}
-
-	/*
-	 * Read combined mode register.
-	 */
-	pci_read_config_byte(pdev, 0x90, &tmp);	/* combined mode reg */
-
-	if (ich == 5) {
-		tmp &= 0x6;  /* interesting bits 2:1, PATA primary/secondary */
-		if (tmp == 0x4)		/* bits 10x */
-			comb = (1 << 0);	/* SATA port 0, PATA port 1 */
-		else if (tmp == 0x6)	/* bits 11x */
-			comb = (1 << 2);	/* PATA port 0, SATA port 1 */
-		else
-			return;			/* not in combined mode */
-	} else {
-		WARN_ON((ich != 6) && (ich != 7) && (ich != 8));
-		tmp &= 0x3;  /* interesting bits 1:0 */
-		if (tmp & (1 << 0))
-			comb = (1 << 2);	/* PATA port 0, SATA port 1 */
-		else if (tmp & (1 << 1))
-			comb = (1 << 0);	/* SATA port 0, PATA port 1 */
-		else
-			return;			/* not in combined mode */
-	}
-
-	/*
-	 * Read programming interface register.
-	 * (Tells us if it's legacy or native mode)
-	 */
-	pci_read_config_byte(pdev, PCI_CLASS_PROG, &prog);
-
-	/* if SATA port is in native mode, we're ok. */
-	if (prog & comb)
-		return;
-
-	/* Don't reserve any so the IDE driver can get them (but only if
-	 * combined_mode=ide).
-	 */
-	if (combined_mode == IDE)
-		return;
-
-	/* Grab them both for libata if combined_mode=libata. */
-	if (combined_mode == LIBATA) {
-		request_region(0x1f0, 8, "libata");	/* port 0 */
-		request_region(0x170, 8, "libata");	/* port 1 */
-		return;
-	}
-
-	/* SATA port is in legacy mode.  Reserve port so that
-	 * IDE driver does not attempt to use it.  If request_region
-	 * fails, it will be obvious at boot time, so we don't bother
-	 * checking return values.
-	 */
-	if (comb == (1 << 0))
-		request_region(0x1f0, 8, "libata");	/* port 0 */
-	else
-		request_region(0x170, 8, "libata");	/* port 1 */
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,    PCI_ANY_ID,	  quirk_intel_ide_combined );
-#endif /* CONFIG_SATA_INTEL_COMBINED */
-
-
 int pcie_mch_quirk;
 EXPORT_SYMBOL(pcie_mch_quirk);
 
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 6859a3b..71ea923 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -99,7 +99,6 @@ extern struct resource ioport_resource;
 extern struct resource iomem_resource;
 
 extern int request_resource(struct resource *root, struct resource *new);
-extern struct resource * ____request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern int allocate_resource(struct resource *root, struct resource *new,
diff --git a/kernel/resource.c b/kernel/resource.c
index bdb55a3..9bd14fd 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -213,27 +213,6 @@ int request_resource(struct resource *root, struct resource *new)
 EXPORT_SYMBOL(request_resource);
 
 /**
- * ____request_resource - reserve a resource, with resource conflict returned
- * @root: root resource descriptor
- * @new: resource descriptor desired by caller
- *
- * Returns:
- * On success, NULL is returned.
- * On error, a pointer to the conflicting resource is returned.
- */
-struct resource *____request_resource(struct resource *root, struct resource *new)
-{
-	struct resource *conflict;
-
-	write_lock(&resource_lock);
-	conflict = __request_resource(root, new);
-	write_unlock(&resource_lock);
-	return conflict;
-}
-
-EXPORT_SYMBOL(____request_resource);
-
-/**
  * release_resource - release a previously reserved resource
  * @old: resource pointer
  */

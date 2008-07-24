Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbYGXQgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbYGXQgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 12:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYGXQg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 12:36:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58862 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751623AbYGXQg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 12:36:27 -0400
Date: Thu, 24 Jul 2008 17:18:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jeff@garzik.org, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: [PATCH PROPOSAL] libata/pci: Move D3 hack handling from libata into
 PCI
Message-ID: <20080724171838.591f6a31@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Libata has some hacks to deal with certain controllers going silly in D3
state. The right way to handle this is to keep a PCI device flag for such
devices. That can then be generalised for no ATA devices with power
problems.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index fbe6057..c5f91e6 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -259,12 +259,6 @@ static int pacpi_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops	= &pacpi_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
-	if (pdev->vendor == PCI_VENDOR_ID_ATI) {
-		int rc = pcim_enable_device(pdev);
-		if (rc < 0)
-			return rc;
-		pcim_pin_device(pdev);
-	}
 	return ata_pci_sff_init_one(pdev, ppi, &pacpi_sht, NULL);
 }
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d00f0e0..1f70a9e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -572,6 +572,10 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 		if (!ret)
 			pci_update_current_state(dev);
 	}
+	/* This device is quirked not to be put into D3, so
+	   don't put it in D3 */
+	if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
+		return 0;
 
 	error = pci_raw_set_power_state(dev, state);
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 12d4893..11cc96d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -908,7 +908,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_CSB
 /*
  *	Intel 82801CAM ICH3-M datasheet says IDE modes must be the same
  */
-static void __init quirk_ide_samemode(struct pci_dev *pdev)
+static void __devinit quirk_ide_samemode(struct pci_dev *pdev)
 {
 	u8 prog;
 
@@ -923,6 +923,19 @@ static void __init quirk_ide_samemode(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_10, quirk_ide_samemode);
 
+/*
+ * Some ATA devices break if put into D3
+ */
+
+static void __devinit quirk_no_ata_d3(struct pci_dev *pdev)
+{
+	/* Quirk the legacy ATA devices only. The AHCI ones are ok */
+	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
+		pdev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_ANY_ID, quirk_no_ata_d3);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, PCI_ANY_ID, quirk_no_ata_d3);
+
 /* This was originally an Alpha specific thing, but it really fits here.
  * The i82375 PCI/EISA bridge appears as non-classified. Fix that.
  */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a6a088e..02ebeb5 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -124,6 +124,8 @@ enum pci_dev_flags {
 	 * generation too.
 	 */
 	PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG = (__force pci_dev_flags_t) 1,
+	/* Device configuration is irrevocably lost if disabled into D3 */
+	PCI_DEV_FLAGS_NO_D3 = (__force pci_dev_flags_t) 2,
 };
 
 typedef unsigned short __bitwise pci_bus_flags_t;

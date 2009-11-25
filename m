Return-Path: <linux-kernel-owner+w=401wt.eu-S934837AbZKYRNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934837AbZKYRNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934829AbZKYRNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:13:11 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:30269 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934821AbZKYRNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:13:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=nwun3PXjoCTHzdN4vos7ArgISH6oFHRkrqxb/xgSGIUeJAlHWg+TV5ELJNTDgATTaH
         pd4KwCUXzRgc2DOLyG2wJIPUEnHaxz0h8st4GvgLBCjYz1+5NbRHM2HQN4Zq4mrbtRzD
         YwY7RsLAVJJ/bTdtZwCQWWAxl9krVqBXNoj5w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:12:25 +0100
Message-Id: <20091125171225.5446.58040.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 83/86] pata_via: add via_fixup()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_via: add via_fixup()

Factor out common code from via_[re]init_one() to via_fixup().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_via.c |   53 +++++++++++++++++++++----------------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

Index: b/drivers/ata/pata_via.c
===================================================================
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -468,6 +468,27 @@ static void via_config_fifo(struct pci_d
 	}
 }
 
+static void via_fixup(struct pci_dev *pdev, const struct via_isa_bridge *config)
+{
+	u32 timing;
+
+	/* Initialise the FIFO for the enabled channels. */
+	via_config_fifo(pdev, config->flags);
+
+	if ((config->flags & VIA_UDMA) == VIA_UDMA_66) {
+		/* The 66 MHz devices require we enable the clock */
+		pci_read_config_dword(pdev, 0x50, &timing);
+		timing |= 0x80008;
+		pci_write_config_dword(pdev, 0x50, timing);
+	}
+	if (config->flags & VIA_BAD_CLK66) {
+		/* Disable the 66MHz clock on problem devices */
+		pci_read_config_dword(pdev, 0x50, &timing);
+		timing &= ~0x80008;
+		pci_write_config_dword(pdev, 0x50, timing);
+	}
+}
+
 /**
  *	via_init_one		-	discovery callback
  *	@pdev: PCI device
@@ -530,7 +551,6 @@ static int via_init_one(struct pci_dev *
 	const struct via_isa_bridge *config;
 	static int printed_version;
 	u8 enable;
-	u32 timing;
 	unsigned long flags = id->driver_data;
 	int rc;
 
@@ -568,9 +588,6 @@ static int via_init_one(struct pci_dev *
 			return -ENODEV;
 	}
 
-	/* Initialise the FIFO for the enabled channels. */
-	via_config_fifo(pdev, config->flags);
-
 	/* Clock set up */
 	switch(config->flags & VIA_UDMA) {
 		case VIA_UDMA_NONE:
@@ -584,10 +601,6 @@ static int via_init_one(struct pci_dev *
 			break;
 		case VIA_UDMA_66:
 			ppi[0] = &via_udma66_info;
-			/* The 66 MHz devices require we enable the clock */
-			pci_read_config_dword(pdev, 0x50, &timing);
-			timing |= 0x80008;
-			pci_write_config_dword(pdev, 0x50, timing);
 			break;
 		case VIA_UDMA_100:
 			ppi[0] = &via_udma100_info;
@@ -600,12 +613,7 @@ static int via_init_one(struct pci_dev *
 			return -ENODEV;
 	}
 
-	if (config->flags & VIA_BAD_CLK66) {
-		/* Disable the 66MHz clock on problem devices */
-		pci_read_config_dword(pdev, 0x50, &timing);
-		timing &= ~0x80008;
-		pci_write_config_dword(pdev, 0x50, timing);
-	}
+	via_fixup(pdev, config);
 
 	/* We have established the device type, now fire it up */
 	return ata_pci_sff_init_one(pdev, ppi, &via_sht, (void *)config);
@@ -624,29 +632,14 @@ static int via_init_one(struct pci_dev *
 
 static int via_reinit_one(struct pci_dev *pdev)
 {
-	u32 timing;
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	const struct via_isa_bridge *config = host->private_data;
 	int rc;
 
 	rc = ata_pci_device_do_resume(pdev);
 	if (rc)
 		return rc;
 
-	via_config_fifo(pdev, config->flags);
-
-	if ((config->flags & VIA_UDMA) == VIA_UDMA_66) {
-		/* The 66 MHz devices require we enable the clock */
-		pci_read_config_dword(pdev, 0x50, &timing);
-		timing |= 0x80008;
-		pci_write_config_dword(pdev, 0x50, timing);
-	}
-	if (config->flags & VIA_BAD_CLK66) {
-		/* Disable the 66MHz clock on problem devices */
-		pci_read_config_dword(pdev, 0x50, &timing);
-		timing &= ~0x80008;
-		pci_write_config_dword(pdev, 0x50, timing);
-	}
+	via_fixup(pdev, host->private_data);
 
 	ata_host_resume(host);
 	return 0;

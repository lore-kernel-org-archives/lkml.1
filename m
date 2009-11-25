Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbZKYRFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbZKYRFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759203AbZKYRFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:05:37 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53682 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759211AbZKYRFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:05:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vh+BxwMOOMg9SI+PvfswgYFIRhOAorIqLVxHRLRM6pzuFBqXwhHhwGo/G84FLh1lbv
         G2OPJbEI6P/VqeulL+MwiSEqui/w97Tg+znR439TQtQwP3z3zD87y8G0OGqiDHpi+IxM
         7Zzz0HRsV1PivuLwlR5GA7QWJdzNSBWZ/EZYo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:04:57 +0100
Message-Id: <20091125170457.5446.67239.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 22/86] pata_cmd64x: add cmd64x_fixup()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cmd64x: add cmd64x_fixup()

Factor out common code from cmd64x_[re]init_one() to cmd64x_fixup().

Remove stale comment and fix CodingStyle issue while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cmd64x.c |   41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -292,6 +292,22 @@ static struct ata_port_operations cmd648
 	.cable_detect	= cmd648_cable_detect,
 };
 
+static void cmd64x_fixup(struct pci_dev *pdev)
+{
+	u8 mrdmode;
+
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
+	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
+	mrdmode &= ~0x30;	/* IRQ set up */
+	mrdmode |= 0x02;	/* Memory read line enable */
+	pci_write_config_byte(pdev, MRDMODE, mrdmode);
+
+	/* PPC specific fixup copied from old driver */
+#ifdef CONFIG_PPC
+	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
+#endif
+}
+
 static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	u32 class_rev;
@@ -338,7 +354,6 @@ static int cmd64x_init_one(struct pci_de
 		}
 	};
 	const struct ata_port_info *ppi[] = { &cmd_info[id->driver_data], NULL };
-	u8 mrdmode;
 	int rc;
 
 	rc = pcim_enable_device(pdev);
@@ -360,18 +375,7 @@ static int cmd64x_init_one(struct pci_de
 			ppi[0] = &cmd_info[3];
 	}
 
-	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
-	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
-	mrdmode &= ~ 0x30;	/* IRQ set up */
-	mrdmode |= 0x02;	/* Memory read line enable */
-	pci_write_config_byte(pdev, MRDMODE, mrdmode);
-
-	/* Force PIO 0 here.. */
-
-	/* PPC specific fixup copied from old driver */
-#ifdef CONFIG_PPC
-	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
-#endif
+	cmd64x_fixup(pdev);
 
 	return ata_pci_sff_init_one(pdev, ppi, &cmd64x_sht, NULL);
 }
@@ -380,21 +384,14 @@ static int cmd64x_init_one(struct pci_de
 static int cmd64x_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	u8 mrdmode;
 	int rc;
 
 	rc = ata_pci_device_do_resume(pdev);
 	if (rc)
 		return rc;
 
-	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
-	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
-	mrdmode &= ~ 0x30;	/* IRQ set up */
-	mrdmode |= 0x02;	/* Memory read line enable */
-	pci_write_config_byte(pdev, MRDMODE, mrdmode);
-#ifdef CONFIG_PPC
-	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
-#endif
+	cmd64x_fixup(pdev);
+
 	ata_host_resume(host);
 	return 0;
 }

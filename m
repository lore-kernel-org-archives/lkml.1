Return-Path: <linux-kernel-owner+w=401wt.eu-S934792AbZKYRPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934792AbZKYRPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759410AbZKYRMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:12:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:30269 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759402AbZKYRML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:12:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=OZxYURHwwoM8V0L1YrhSB5nvPV3J7bCbp3bDoOQKrhgWscBTs3ViiqzSgMI2UPmA6n
         aHUlQvVIyXTqEs5kRDv0mfkHtMfmNBpn3autfIpcLYzwLPPVbVLoKnopxNHeW9Ys2Fcx
         2ncym0/bsNN5Y4Pp4E2CxA0E9a+XWPo8DBWzU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:11:31 +0100
Message-Id: <20091125171131.5446.99406.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 76/86] pata_sl82c105: add Power Management support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_sl82c105: add Power Management support

There shouldn't be any problems with it as IDE sl82c105 host driver
has been supporting Power Management for over year now.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sl82c105.c |   37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

Index: b/drivers/ata/pata_sl82c105.c
===================================================================
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -1,6 +1,7 @@
 /*
  * pata_sl82c105.c 	- SL82C105 PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
+ *			  (C) 2009 Bartlomiej Zolnierkiewicz
  *
  * Based in part on linux/drivers/ide/pci/sl82c105.c
  * 		SL82C105/Winbond 553 IDE driver
@@ -278,6 +279,14 @@ static int sl82c105_bridge_revision(stru
 	return bridge->revision;
 }
 
+static void sl82c105_fixup(struct pci_dev *pdev)
+{
+	u32 val;
+
+	pci_read_config_dword(pdev, 0x40, &val);
+	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
+	pci_write_config_dword(pdev, 0x40, val);
+}
 
 static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
@@ -295,7 +304,6 @@ static int sl82c105_init_one(struct pci_
 	/* for now use only the first port */
 	const struct ata_port_info *ppi[] = { &info_early,
 					       NULL };
-	u32 val;
 	int rev;
 	int rc;
 
@@ -312,13 +320,28 @@ static int sl82c105_init_one(struct pci_
 	else
 		ppi[0] = &info_dma;
 
-	pci_read_config_dword(dev, 0x40, &val);
-	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
-	pci_write_config_dword(dev, 0x40, val);
+	sl82c105_fixup(dev);
 
 	return ata_pci_sff_init_one(dev, ppi, &sl82c105_sht, NULL);
 }
 
+#ifdef CONFIG_PM
+static int sl82c105_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	sl82c105_fixup(pdev);
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 static const struct pci_device_id sl82c105[] = {
 	{ PCI_VDEVICE(WINBOND, PCI_DEVICE_ID_WINBOND_82C105), },
 
@@ -329,7 +352,11 @@ static struct pci_driver sl82c105_pci_dr
 	.name 		= DRV_NAME,
 	.id_table	= sl82c105,
 	.probe 		= sl82c105_init_one,
-	.remove		= ata_pci_remove_one
+	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend	= ata_pci_device_suspend,
+	.resume		= sl82c105_reinit_one,
+#endif
 };
 
 static int __init sl82c105_init(void)

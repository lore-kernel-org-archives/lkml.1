Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbYGFRjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbYGFRjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbYGFRfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:10 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:41596 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbYGFRey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=eivVzmsz2ofalUzS0I0SLtkyw8V+P5EIjnqXtevG/2GW5WOhkI8g4X/AQbXMQYfIA+
         gHOfpxqrcM2Betzd2pO1sgNLEsZFsjg4X3NvmqnoInElVlcBtr1t+/SQCHvtx27js8ph
         fIwqnOie8ErqRVmoYQsp5k3/oOGpDq2viMj2s=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:23 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/50] via82cxxx: convert to use ->host_priv
Content-Disposition: inline; filename=via82cxxx-convert-to-use-host_priv.patch
Message-ID: <4871023c.1ade660a.3458.6284@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/via82cxxx.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -113,7 +113,8 @@ struct via82cxxx_dev
 static void via_set_speed(ide_hwif_t *hwif, u8 dn, struct ide_timing *timing)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct via82cxxx_dev *vdev = pci_get_drvdata(dev);
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct via82cxxx_dev *vdev = host->host_priv;
 	u8 t;
 
 	if (~vdev->via_config->flags & VIA_BAD_AST) {
@@ -153,7 +154,8 @@ static void via_set_drive(ide_drive_t *d
 	ide_hwif_t *hwif = drive->hwif;
 	ide_drive_t *peer = hwif->drives + (~drive->dn & 1);
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct via82cxxx_dev *vdev = pci_get_drvdata(dev);
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct via82cxxx_dev *vdev = host->host_priv;
 	struct ide_timing t, p;
 	unsigned int T, UT;
 
@@ -266,19 +268,13 @@ static void __devinit via_cable_detect(s
 
 static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev, const char *name)
 {
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct via82cxxx_dev *vdev = host->host_priv;
 	struct pci_dev *isa = NULL;
-	struct via82cxxx_dev *vdev;
 	struct via_isa_bridge *via_config;
 	u8 t, v;
 	u32 u;
 
-	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-	if (!vdev) {
-		printk(KERN_ERR "VP_IDE: out of memory :(\n");
-		return -ENOMEM;
-	}
-	pci_set_drvdata(dev, vdev);
-
 	/*
 	 * Find the ISA bridge to see how good the IDE is.
 	 */
@@ -402,7 +398,8 @@ static int via_cable_override(struct pci
 static u8 __devinit via82cxxx_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	struct via82cxxx_dev *vdev = pci_get_drvdata(pdev);
+	struct ide_host *host = pci_get_drvdata(pdev);
+	struct via82cxxx_dev *vdev = host->host_priv;
 
 	if (via_cable_override(pdev))
 		return ATA_CBL_PATA40_SHORT;
@@ -436,6 +433,8 @@ static int __devinit via_init_one(struct
 {
 	struct pci_dev *isa = NULL;
 	struct via_isa_bridge *via_config;
+	struct via82cxxx_dev *vdev;
+	int rc;
 	u8 idx = id->driver_data;
 	struct ide_port_info d;
 
@@ -466,7 +465,17 @@ static int __devinit via_init_one(struct
 
 	d.udma_mask = via_config->udma_mask;
 
-	return ide_pci_init_one(dev, &d, NULL);
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev) {
+		printk(KERN_ERR "VP_IDE: out of memory :(\n");
+		return -ENOMEM;
+	}
+
+	rc = ide_pci_init_one(dev, &d, vdev);
+	if (rc)
+		kfree(vdev);
+
+	return rc;
 }
 
 static const struct pci_device_id via_pci_tbl[] = {

-- 


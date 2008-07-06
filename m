Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbYGFRwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbYGFRwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759462AbYGFRgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:13310 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbYGFRev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=PBwBbIcOHTfgU+1zQyhPo+w/aMvfcr77CzDk9FyNqsvFOmYKPPdAZhm70SsW7eCsbu
         RW05brSSaafCjI7nkiYgHCWfiGIsAruTMApoW1dcHtrJ1di/Y05JX+0KaKvZQlf7UIMT
         5zQteya42E4c5qZSMb01sHip6t1Gm7pcO+0mw=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:20 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/50] it821x: convert to use ->host_priv
Content-Disposition: inline; filename=it821x-convert-to-use-host_priv.patch
Message-ID: <48710239.1ade660a.3458.627e@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:

* Allocate both struct it821x_dev instances at once.

* Don't leak itdevs on ide_pci_init_one() failure.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/it821x.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -528,8 +528,9 @@ static struct ide_dma_ops it821x_pass_th
 static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct it821x_dev **itdevs = (struct it821x_dev **)pci_get_drvdata(dev);
-	struct it821x_dev *idev = itdevs[hwif->channel];
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct it821x_dev *itdevs = host->host_priv;
+	struct it821x_dev *idev = itdevs + hwif->channel;
 	u8 conf;
 
 	ide_set_hwifdata(hwif, idev);
@@ -642,23 +643,20 @@ static const struct ide_port_info it821x
 
 static int __devinit it821x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	struct it821x_dev *itdevs[2] = { NULL, NULL} , *itdev;
-	unsigned int i;
+	struct it821x_dev *itdevs;
+	int rc;
 
-	for (i = 0; i < 2; i++) {
-		itdev = kzalloc(sizeof(*itdev), GFP_KERNEL);
-		if (itdev == NULL) {
-			kfree(itdevs[0]);
-			printk(KERN_ERR "it821x: out of memory\n");
-			return -ENOMEM;
-		}
-
-		itdevs[i] = itdev;
+	itdevs = kzalloc(2 * sizeof(*itdevs), GFP_KERNEL);
+	if (itdevs == NULL) {
+		printk(KERN_ERR "it821x: out of memory\n");
+		return -ENOMEM;
 	}
 
-	pci_set_drvdata(dev, itdevs);
+	rc = ide_pci_init_one(dev, &it821x_chipsets[id->driver_data], itdevs);
+	if (rc)
+		kfree(itdevs);
 
-	return ide_pci_init_one(dev, &it821x_chipsets[id->driver_data], NULL);
+	return rc;
 }
 
 static const struct pci_device_id it821x_pci_tbl[] = {

-- 


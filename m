Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYGFRrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYGFRrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759228AbYGFRgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:13310 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759009AbYGFRfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=Y69nIuSLV1luwJvWmSEfyUFtlYsPt/a8Wfxodr9TCKdRH1yx3LIWLP8x0OvQEuLw+3
         bOoL7v3FgusfxYVVhd46CYMgKkMEZ9A23ksaUB2Ydrr0/LCaAgfRIn5FHdAnoR0Wr4zk
         nJELDG804tbrpQO1kQG6vWrwKd2wy37F5FrLc=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:51 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 41/50] siimage: add ->remove method and module_exit()
Content-Disposition: inline; filename=siimage-add-remove-method-and-module_exit.patch
Message-ID: <48710264.1ade660a.3458.62d8@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/siimage.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -800,6 +800,24 @@ static int __devinit siimage_init_one(st
 	return rc;
 }
 
+static void __devexit siimage_remove(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	void __iomem *ioaddr = host->host_priv;
+
+	ide_pci_remove(dev);
+
+	if (ioaddr) {
+		resource_size_t bar5 = pci_resource_start(dev, 5);
+		unsigned long barsize = pci_resource_len(dev, 5);
+
+		iounmap(ioaddr);
+		release_mem_region(bar5, barsize);
+	}
+
+	pci_disable_device(dev);
+}
+
 static const struct pci_device_id siimage_pci_tbl[] = {
 	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_SII_680),    0 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
@@ -814,6 +832,7 @@ static struct pci_driver driver = {
 	.name		= "SiI_IDE",
 	.id_table	= siimage_pci_tbl,
 	.probe		= siimage_init_one,
+	.remove		= siimage_remove,
 };
 
 static int __init siimage_ide_init(void)
@@ -821,7 +840,13 @@ static int __init siimage_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit siimage_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(siimage_ide_init);
+module_exit(siimage_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick, Alan Cox");
 MODULE_DESCRIPTION("PCI driver module for SiI IDE");

-- 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYGFRv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYGFRv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759303AbYGFRgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:24 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:49197 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591AbYGFRfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=xelM3O/sV3/QNh76T/fXecnR2gGjQp9iXNPPXWv07ZADF50GP48/6oLX2zUuH34C87
         BIgNk/uUL8/gEIM0l2gWWvbLSppGR5zjRtlLx2B2/H86qYellVSujCx1pyvslceBKc8S
         paO5Wt2PZsp6ujvjCTDXdmgK4qQCori34Y8Kc=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:36 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 26/50] cy82c693: add ->remove method and module_exit()
Content-Disposition: inline; filename=cy82c693-add-remove-method-and-module_exit.patch
Message-ID: <4871024c.1ade660a.3458.62a5@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the refcounting for dev2 while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cy82c693.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -420,11 +420,21 @@ static int __devinit cy82c693_init_one(s
 	    PCI_FUNC(dev->devfn) == 1) {
 		dev2 = pci_get_slot(dev->bus, dev->devfn + 1);
 		ret = ide_pci_init_two(dev, dev2, &cy82c693_chipset, NULL);
-		/* We leak pci refs here but thats ok - we can't be unloaded */
+		if (ret)
+			pci_dev_put(dev2);
 	}
 	return ret;
 }
 
+static void __devexit cy82c693_remove(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct pci_dev *dev2 = host->dev[1] ? to_pci_dev(host->dev[1]) : NULL;
+
+	ide_pci_remove(dev);
+	pci_dev_put(dev2);
+}
+
 static const struct pci_device_id cy82c693_pci_tbl[] = {
 	{ PCI_VDEVICE(CONTAQ, PCI_DEVICE_ID_CONTAQ_82C693), 0 },
 	{ 0, },
@@ -435,6 +445,7 @@ static struct pci_driver driver = {
 	.name		= "Cypress_IDE",
 	.id_table	= cy82c693_pci_tbl,
 	.probe		= cy82c693_init_one,
+	.remove		= cy82c693_remove,
 };
 
 static int __init cy82c693_ide_init(void)
@@ -442,7 +453,13 @@ static int __init cy82c693_ide_init(void
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit cy82c693_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(cy82c693_ide_init);
+module_exit(cy82c693_ide_exit);
 
 MODULE_AUTHOR("Andreas Krebs, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for the Cypress CY82C693 IDE");

-- 


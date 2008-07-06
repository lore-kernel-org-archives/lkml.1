Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbYGFRtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbYGFRtm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759301AbYGFRgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:18 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:50363 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637AbYGFRfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=Ys71BzPXY86wCNYvJWcyT21xDleiKYfD+e+HUkUmcq/DlMBu0L2uZOAbhNwHLo3+2+
         bhrbjQiBd7EfdY5QF8zL1R61jwZI7J625kwBbWx8Ox54tYDpgQYiXsdHjpZBrNUHOvPX
         Kcw+m9S6nth6NuWXDIMpZVjGiLyRwTYLRmSGc=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:39 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 29/50] hpt366: add ->remove method and module_exit()
Content-Disposition: inline; filename=hpt366-add-remove-method-and-module_exit.patch
Message-ID: <4871024f.1ade660a.3458.62ac@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/hpt366.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1627,6 +1627,17 @@ static int __devinit hpt366_init_one(str
 	return ret;
 }
 
+static void __devexit hpt366_remove(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	struct ide_info *info = host->host_priv;
+	struct pci_dev *dev2 = host->dev[1] ? to_pci_dev(host->dev[1]) : NULL;
+
+	ide_pci_remove(dev);
+	pci_dev_put(dev2);
+	kfree(info);
+}
+
 static const struct pci_device_id hpt366_pci_tbl[] __devinitconst = {
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT366),  0 },
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT372),  1 },
@@ -1642,6 +1653,7 @@ static struct pci_driver driver = {
 	.name		= "HPT366_IDE",
 	.id_table	= hpt366_pci_tbl,
 	.probe		= hpt366_init_one,
+	.remove		= hpt366_remove,
 };
 
 static int __init hpt366_ide_init(void)
@@ -1649,7 +1661,13 @@ static int __init hpt366_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit hpt366_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(hpt366_ide_init);
+module_exit(hpt366_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for Highpoint HPT366 IDE");

-- 


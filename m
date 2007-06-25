Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbXFYVvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbXFYVvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbXFYVvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:51:01 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59372 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbXFYVvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:51:00 -0400
Date: Mon, 25 Jun 2007 14:51:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: christopher.leech@intel.com, sam@ravnborg.org,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] IOATDMA: fix section mismatches
Message-Id: <20070625145147.c34cbfca.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Rename struct pci_driver data so that false section mismatch
warnings won't be produced.

Sam, ISTM that depending on variable names is the weakest & worst part of
modpost section checking.  Should __init_refok work here?  I got build
errors when I tried to use it, probably because the struct pci_driver
probe and remove methods are not marked "__init_refok".

WARNING: drivers/dma/ioatdma.o(.data+0x10): Section mismatch: reference to .init.text: (between 'ioat_pci_drv' and 'ioat_pci_tbl')
WARNING: drivers/dma/ioatdma.o(.data+0x14): Section mismatch: reference to .exit.text: (between 'ioat_pci_drv' and 'ioat_pci_tbl')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/dma/ioatdma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.22-rc6.orig/drivers/dma/ioatdma.c
+++ linux-2.6.22-rc6/drivers/dma/ioatdma.c
@@ -556,7 +556,7 @@ static struct pci_device_id ioat_pci_tbl
 	{ 0, }
 };
 
-static struct pci_driver ioat_pci_drv = {
+static struct pci_driver ioat_pci_driver = {
 	.name 	= "ioatdma",
 	.id_table = ioat_pci_tbl,
 	.probe	= ioat_probe,
@@ -699,7 +699,7 @@ static int __devinit ioat_probe(struct p
 	if (err)
 		goto err_set_dma_mask;
 
-	err = pci_request_regions(pdev, ioat_pci_drv.name);
+	err = pci_request_regions(pdev, ioat_pci_driver.name);
 	if (err)
 		goto err_request_regions;
 
@@ -828,14 +828,14 @@ static int __init ioat_init_module(void)
 	/* if forced, worst case is that rmmod hangs */
 	__unsafe(THIS_MODULE);
 
-	return pci_register_driver(&ioat_pci_drv);
+	return pci_register_driver(&ioat_pci_driver);
 }
 
 module_init(ioat_init_module);
 
 static void __exit ioat_exit_module(void)
 {
-	pci_unregister_driver(&ioat_pci_drv);
+	pci_unregister_driver(&ioat_pci_driver);
 }
 
 module_exit(ioat_exit_module);

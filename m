Return-Path: <linux-kernel-owner+w=401wt.eu-S933204AbXBWUml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbXBWUml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 15:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933205AbXBWUml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 15:42:41 -0500
Received: from palrel10.hp.com ([156.153.255.245]:44418 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933204AbXBWUmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 15:42:40 -0500
Date: Fri, 23 Feb 2007 14:42:39 -0600
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: akpm@osdl.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       gregkh@novell.com
Subject: [Patch 2/2] cciss: supercedes add shutdown support (replaces reboot notifier)
Message-ID: <20070223204239.GA10570@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 2/2

This patch supercedes yesterdays cciss-shutdown patch. The primary difference is
removing __devexit from cciss_remove_one. Instead of create another function I'd
rather use the code that was intended to perform the cleanup and cache flush. I've
tested as a loadable module and statically linked without error.
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
------------------------------------------------------------------------------------------
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 9d84ab3..b16f48c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3404,7 +3404,7 @@ #endif
 	return -1;
 }
 
-static void __devexit cciss_remove_one(struct pci_dev *pdev)
+static void cciss_remove_one(struct pci_dev *pdev)
 {
 	ctlr_info_t *tmp_ptr;
 	int i, j;
@@ -3428,9 +3428,10 @@ static void __devexit cciss_remove_one(s
 	memset(flush_buf, 0, 4);
 	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0, 0, 0, NULL,
 			      TYPE_CMD);
-	if (return_code != IO_OK) {
-		printk(KERN_WARNING "Error Flushing cache on controller %d\n",
-		       i);
+	if (return_code == IO_OK) {
+		printk(KERN_WARNING "Completed flushing cache on controller %d\n", i);
+	} else {
+		printk(KERN_WARNING "Error flushing cache on controller %d\n", i);
 	}
 	free_irq(hba[i]->intr[2], hba[i]);
 
@@ -3481,6 +3482,7 @@ static struct pci_driver cciss_pci_drive
 	.probe = cciss_init_one,
 	.remove = __devexit_p(cciss_remove_one),
 	.id_table = cciss_pci_device_id,	/* id_table */
+	.shutdown = cciss_remove_one,
 };
 
 /*

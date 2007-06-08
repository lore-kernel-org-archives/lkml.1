Return-Path: <linux-kernel-owner+w=401wt.eu-S938471AbXFHHgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938471AbXFHHgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967594AbXFHHXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:23:36 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58374 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967511AbXFHHXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:23:33 -0400
Message-Id: <20070608072223.130512000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:05 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, gbritton@alum.mit.edu,
       mike.miller@hp.com, mm-commits@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 38/54] cciss: fix pci_driver.shutdown while device is still active
Content-Disposition: inline; filename=cciss-fix-pci_driver.shutdown-while-device-is-still-active.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Gerald Britton <gbritton@alum.mit.edu>

Fix an Oops in the cciss driver caused by system shutdown while a
filesystem on a cciss device is still active.  The cciss_remove_one
function only properly removes the device if the device has been cleanly
released by its users, which is not the case when the pci_driver.shutdown
method is called.

This patch adds a new cciss_shutdown function to better match the pattern
used by various SCSI drivers: deactivate device interrupts and flush
caches.  It also alters the cciss_remove_one function to match and readds
the __devexit annotation that was removed when cciss_remove_one was serving
as the pci_driver.shutdown method.

Signed-off-by: Gerald Britton <gbritton@alum.mit.edu>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>


---
 drivers/block/cciss.c |   45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

--- linux-2.6.21.4.orig/drivers/block/cciss.c
+++ linux-2.6.21.4/drivers/block/cciss.c
@@ -3405,13 +3405,39 @@ static int __devinit cciss_init_one(stru
 	return -1;
 }
 
-static void cciss_remove_one(struct pci_dev *pdev)
+static void cciss_shutdown(struct pci_dev *pdev)
 {
 	ctlr_info_t *tmp_ptr;
-	int i, j;
+	int i;
 	char flush_buf[4];
 	int return_code;
 
+	tmp_ptr = pci_get_drvdata(pdev);
+	if (tmp_ptr == NULL)
+		return;
+	i = tmp_ptr->ctlr;
+	if (hba[i] == NULL)
+		return;
+
+	/* Turn board interrupts off  and send the flush cache command */
+	/* sendcmd will turn off interrupt, and send the flush...
+	 * To write all data in the battery backed cache to disks */
+	memset(flush_buf, 0, 4);
+	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0, 0, 0, NULL,
+			      TYPE_CMD);
+	if (return_code == IO_OK) {
+		printk(KERN_INFO "Completed flushing cache on controller %d\n", i);
+	} else {
+		printk(KERN_WARNING "Error flushing cache on controller %d\n", i);
+	}
+	free_irq(hba[i]->intr[2], hba[i]);
+}
+
+static void __devexit cciss_remove_one(struct pci_dev *pdev)
+{
+	ctlr_info_t *tmp_ptr;
+	int i, j;
+
 	if (pci_get_drvdata(pdev) == NULL) {
 		printk(KERN_ERR "cciss: Unable to remove device \n");
 		return;
@@ -3442,18 +3468,7 @@ static void cciss_remove_one(struct pci_
 
 	cciss_unregister_scsi(i);	/* unhook from SCSI subsystem */
 
-	/* Turn board interrupts off  and send the flush cache command */
-	/* sendcmd will turn off interrupt, and send the flush...
-	 * To write all data in the battery backed cache to disks */
-	memset(flush_buf, 0, 4);
-	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0, 0, 0, NULL,
-			      TYPE_CMD);
-	if (return_code == IO_OK) {
-		printk(KERN_INFO "Completed flushing cache on controller %d\n", i);
-	} else {
-		printk(KERN_WARNING "Error flushing cache on controller %d\n", i);
-	}
-	free_irq(hba[i]->intr[2], hba[i]);
+	cciss_shutdown(pdev);
 
 #ifdef CONFIG_PCI_MSI
 	if (hba[i]->msix_vector)
@@ -3486,7 +3501,7 @@ static struct pci_driver cciss_pci_drive
 	.probe = cciss_init_one,
 	.remove = __devexit_p(cciss_remove_one),
 	.id_table = cciss_pci_device_id,	/* id_table */
-	.shutdown = cciss_remove_one,
+	.shutdown = cciss_shutdown,
 };
 
 /*

-- 

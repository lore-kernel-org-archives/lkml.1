Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbZKLSsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbZKLSsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZKLSsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:48:10 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33363 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbZKLSsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:48:07 -0500
Subject: [PATCH 05/11] cciss: clean up code in cciss_shutdown
To: axboe@kernel.dk, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, achiang@hp.com,
       brace@beardog.cce.hp.com
Date: Thu, 12 Nov 2009 12:49:35 -0600
Message-ID: <20091112184935.23389.14125.stgit@beardog.cce.hp.com>
In-Reply-To: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
References: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: clean up code in cciss_shutdown.  Send the flush cache
command down with interrupts still enabled, and do not do DMA
from the stack.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   38 ++++++++++++++++++--------------------
 1 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 4321c94..f804542 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4376,30 +4376,28 @@ clean_no_release_regions:
 
 static void cciss_shutdown(struct pci_dev *pdev)
 {
-	ctlr_info_t *tmp_ptr;
-	int i;
-	char flush_buf[4];
+	ctlr_info_t *h;
+	char *flush_buf;
 	int return_code;
 
-	tmp_ptr = pci_get_drvdata(pdev);
-	if (tmp_ptr == NULL)
-		return;
-	i = tmp_ptr->ctlr;
-	if (hba[i] == NULL)
+	h = pci_get_drvdata(pdev);
+	flush_buf = kzalloc(4, GFP_KERNEL);
+	if (!flush_buf) {
+		printk(KERN_WARNING
+			"cciss:%d cache not flushed, out of memory.\n",
+			h->ctlr);
 		return;
-
-	/* Turn board interrupts off  and send the flush cache command */
-	/* sendcmd will turn off interrupt, and send the flush...
-	 * To write all data in the battery backed cache to disks */
-	memset(flush_buf, 0, 4);
-	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0,
-		CTLR_LUNID, TYPE_CMD);
-	if (return_code == IO_OK) {
-		printk(KERN_INFO "Completed flushing cache on controller %d\n", i);
-	} else {
-		printk(KERN_WARNING "Error flushing cache on controller %d\n", i);
 	}
-	free_irq(hba[i]->intr[2], hba[i]);
+	/* write all data in the battery backed cache to disk */
+	memset(flush_buf, 0, 4);
+	return_code = sendcmd_withirq(CCISS_CACHE_FLUSH, h->ctlr, flush_buf,
+		4, 0, CTLR_LUNID, TYPE_CMD);
+	kfree(flush_buf);
+	if (return_code != IO_OK)
+		printk(KERN_WARNING "cciss%d: Error flushing cache\n",
+			h->ctlr);
+	h->access.set_intr_mask(h, CCISS_INTR_OFF);
+	free_irq(h->intr[2], h);
 }
 
 static void __devexit cciss_remove_one(struct pci_dev *pdev)


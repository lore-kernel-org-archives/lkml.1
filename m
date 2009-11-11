Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZKKQuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZKKQuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbZKKQuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:50:13 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:27607 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176AbZKKQuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:50:09 -0500
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 14/17] hpsa: Flush cache with interrupts still enabled.
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
Date: Wed, 11 Nov 2009 10:51:34 -0600
Message-ID: <20091111165134.17754.56407.stgit@beardog.cce.hp.com>
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpsa: Flush cache with interrupts still enabled.  It's not
necessary to disable interrupts prior to flushing the cache
on driver unload.  Also, don't dma from the stack.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |   39 ++++++++++++++++++++++++++++++---------
 1 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e3b80fa..d171a55 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3581,24 +3581,45 @@ clean1:
 	return -1;
 }
 
+static void hpsa_flush_cache(struct ctlr_info *h)
+{
+	char *flush_buf;
+	struct CommandList *c;
+	int rc;
+
+	flush_buf = kzalloc(4, GFP_KERNEL);
+	if (!flush_buf)
+		return;
+
+	c = cmd_special_alloc(h);
+	if (!c) {
+		dev_warn(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
+		goto out_of_memory;
+	}
+	rc = fill_cmd(c, HPSA_CACHE_FLUSH, h, flush_buf, 4, 0,
+		RAID_CTLR_LUNID, TYPE_CMD);
+	if (rc == 0) {
+		hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_TODEVICE);
+		if (c->err_info->CommandStatus != 0)
+			dev_warn(&h->pdev->dev,
+				"error flushing cache on controller\n");
+	}
+	cmd_special_free(h, c);
+out_of_memory:
+	kfree(flush_buf);
+}
+
 static void hpsa_shutdown(struct pci_dev *pdev)
 {
 	struct ctlr_info *h;
-	char flush_buf[4];
-	int return_code;
 
 	h = pci_get_drvdata(pdev);
 	/* Turn board interrupts off  and send the flush cache command
 	 * sendcmd will turn off interrupt, and send the flush...
 	 * To write all data in the battery backed cache to disks
 	 */
-	memset(flush_buf, 0, 4);
-	return_code = sendcmd(HPSA_CACHE_FLUSH, h, flush_buf, 4, 0,
-				RAID_CTLR_LUNID, TYPE_CMD);
-	if (return_code != IO_OK) {
-		dev_warn(&pdev->dev, "error flushing cache on controller %d\n",
-		       h->ctlr);
-	}
+	hpsa_flush_cache(h);
+	h->access.set_intr_mask(h, HPSA_INTR_OFF);
 	free_irq(h->intr[2], h);
 #ifdef CONFIG_PCI_MSI
 	if (h->msix_vector)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZJVOkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZJVOkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbZJVOkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:40:22 -0400
Received: from bitbox.plus.com ([81.174.226.42]:46736 "EHLO pangolin.localnet"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755918AbZJVOkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:40:21 -0400
X-Greylist: delayed 1071 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Oct 2009 10:40:21 EDT
Date: Thu, 22 Oct 2009 15:22:28 +0100
To: ecashin@coraid.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] prevent AoE causing cache aliases
Message-ID: <20091022142228.GA18986@bitbox.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
From: phorton@bitbox.co.uk (Peter Horton)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents the AoE block driver from creating cache aliases of
page cache pages on machines with virtually indexed caches.

Building kernels on an AT91SAM9G20 board without this patch fails with
segmentation faults after a couple of passes.

Signed-off-by: Peter Horton <zero@colonel-panic.org>

Index: linux-2.6.31/drivers/block/aoe/aoecmd.c
===================================================================
--- linux-2.6.31.orig/drivers/block/aoe/aoecmd.c	2009-09-09 23:13:59.000000000 +0100
+++ linux-2.6.31/drivers/block/aoe/aoecmd.c	2009-10-22 10:24:50.000000000 +0100
@@ -735,6 +735,21 @@
 	part_stat_unlock();
 }
 
+/*
+ * Ensure we don't create aliases in VI caches
+ */
+static inline void
+killalias(struct bio *bio)
+{
+	struct bio_vec *bv;
+	int i;
+
+	if (bio_data_dir(bio) == READ)
+		__bio_for_each_segment(bv, bio, i, 0) {
+			flush_dcache_page(bv->bv_page);
+		}
+}
+
 void
 aoecmd_ata_rsp(struct sk_buff *skb)
 {
@@ -853,8 +868,12 @@
 
 	if (buf && --buf->nframesout == 0 && buf->resid == 0) {
 		diskstats(d->gd, buf->bio, jiffies - buf->stime, buf->sector);
-		n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
-		bio_endio(buf->bio, n);
+		if (buf->flags & BUFFL_FAIL)
+			bio_endio(buf->bio, -EIO);
+		else {
+			killalias(buf->bio);
+			bio_endio(buf->bio, 0);
+		}
 		mempool_free(buf, d->bufpool);
 	}
 

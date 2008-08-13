Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYHMMoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYHMMoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 08:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYHMMoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 08:44:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51717 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbYHMMoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:44:11 -0400
Subject: Re: [PATCH 11/7] Kill REQ_TYPE_FLUSH
From: David Woodhouse <dwmw2@infradead.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
       gilad@codefidence.com, matthew@wil.cx,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808131355170.27994@vixen.sonytel.be>
References: <1218299181.26926.88.camel@pmac.infradead.org>
	 <1218627594.2977.273.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0808131355170.27994@vixen.sonytel.be>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 13:43:22 +0100
Message-Id: <1218631402.2977.288.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-13 at 13:58 +0200, Geert Uytterhoeven wrote:
> Note that REQ_LB_OP_FLUSH is also never used.

That can be fixed...

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 681d5ac..8663f3f 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -32,6 +32,13 @@ struct mtd_blkcore_priv {
 	spinlock_t queue_lock;
 };
 
+static void blktrans_prepare_flush(struct request_queue *q,
+				   struct request *req)
+{
+	req->cmd_type = REQ_TYPE_LINUX_BLOCK;
+	req->cmd[0] = REQ_LB_OP_FLUSH;
+}
+
 static int blktrans_discard_request(struct request_queue *q,
 				    struct request *req)
 {
@@ -53,6 +60,14 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 	buf = req->buffer;
 
 	if (req->cmd_type == REQ_TYPE_LINUX_BLOCK &&
+	    req->cmd[0] == REQ_LB_OP_FLUSH) {
+		if (tr->flush)
+			return !tr->flush(dev);
+		else
+			return 1;
+	}
+
+	if (req->cmd_type == REQ_TYPE_LINUX_BLOCK &&
 	    req->cmd[0] == REQ_LB_OP_DISCARD)
 		return !tr->discard(dev, block, nsect);
 
@@ -383,6 +398,9 @@ int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
 		blk_queue_set_discard(tr->blkcore_priv->rq,
 				      blktrans_discard_request);
 
+	blk_queue_ordered(tr->blkcore_priv->rq, QUEUE_ORDERED_DRAIN_FLUSH,
+			  blktrans_prepare_flush);
+
 	tr->blkshift = ffs(tr->blksize) - 1;
 
 	tr->blkcore_priv->thread = kthread_run(mtd_blktrans_thread, tr,


>  Actually its definition in include/linux/blkdev.h has:
> 
> | enum {
> |       /*
> |        * just examples for now
>            ^^^^^^^^^^^^^^^^^^^^^
> |        */
> |       REQ_LB_OP_EJECT = 0x40,         /* eject request */
> |       REQ_LB_OP_FLUSH = 0x41,         /* flush device */
> | };
> 
> which makes me a bit reluctant to make this change.

That can be fixed too...

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 293a71a..7ef582f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -76,11 +75,8 @@ enum rq_cmd_type_bits {
  *
  */
 enum {
-	/*
-	 * just examples for now
-	 */
 	REQ_LB_OP_EJECT	= 0x40,		/* eject request */
-	REQ_LB_OP_FLUSH = 0x41,		/* flush device */
+	REQ_LB_OP_FLUSH = 0x41,		/* flush request */
 	REQ_LB_OP_DISCARD = 0x42,	/* discard sectors */
 };
 

> BTW, how to test all this flushing behavior, if there are no real
> users?

btrfs uses it.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation




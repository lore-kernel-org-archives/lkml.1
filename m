Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZGISK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZGISK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 14:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZGISKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 14:10:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64282 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbZGISKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 14:10:47 -0400
Message-ID: <4A563259.5000601@vlnb.net>
Date: Thu, 09 Jul 2009 22:09:29 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
CC: scst-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH]: Rename REQ_COPY_USER to more descriptive REQ_HAS_TAIL_SPACE_FOR_PADDING
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+GOgAP7qMA9KKnirXVpIMns6fusmfSSk0Dew3
 z8ci0e1vu2K8O3rnzAN2ngeVEgnEBTaWhQzsjLdjYCNK7kEQZg
 PirWXOqcWYvXdnFdALz9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently names of REQ_COPY_USER and __REQ_COPY_USER constants are confusing,
because they actually mean that the buffer for the corresponding requests
has space in the tail for padding in case of DMA padding restrictions.

This patch renames REQ_COPY_USER and __REQ_COPY_USER constants to more
descriptive names REQ_HAS_TAIL_SPACE_FOR_PADDING and __REQ_HAS_TAIL_SPACE_FOR_PADDING
correspondingly.

It's against 2.6.30.1, but if necessary, I can update it to any necessary
kernel version.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

 block/blk-map.c        |    6 +++---
 block/blk-merge.c      |    2 +-
 include/linux/blkdev.h |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -upkr linux-2.6.30.1/block/blk-map.c linux-2.6.30.1/block/blk-map.c
--- linux-2.6.30.1/block/blk-map.c	2009-06-10 07:05:27.000000000 +0400
+++ linux-2.6.30.1/block/blk-map.c	2009-07-08 21:18:53.000000000 +0400
@@ -154,7 +155,7 @@ int blk_rq_map_user(struct request_queue
 	}
 
 	if (!bio_flagged(bio, BIO_USER_MAPPED))
-		rq->cmd_flags |= REQ_COPY_USER;
+		rq->cmd_flags |= REQ_HAS_TAIL_SPACE_FOR_PADDING;
 
 	rq->buffer = rq->data = NULL;
 	return 0;
@@ -230,7 +231,7 @@ int blk_rq_map_user_iov(struct request_q
 	}
 
 	if (!bio_flagged(bio, BIO_USER_MAPPED))
-		rq->cmd_flags |= REQ_COPY_USER;
+		rq->cmd_flags |= REQ_HAS_TAIL_SPACE_FOR_PADDING;
 
 	blk_queue_bounce(q, &bio);
 	bio_get(bio);
@@ -309,7 +836,7 @@ int blk_rq_map_kern(struct request_queue
 		bio->bi_rw |= (1 << BIO_RW);
 
 	if (do_copy)
-		rq->cmd_flags |= REQ_COPY_USER;
+		rq->cmd_flags |= REQ_HAS_TAIL_SPACE_FOR_PADDING;
 
 	blk_rq_bio_prep(q, rq, bio);
 	blk_queue_bounce(q, &rq->bio);
diff -upkr linux-2.6.30.1/block/blk-merge.c linux-2.6.30.1/block/blk-merge.c
--- linux-2.6.30.1/block/blk-merge.c	2009-06-10 07:05:27.000000000 +0400
+++ linux-2.6.30.1/block/blk-merge.c	2009-07-08 21:18:53.000000000 +0400
@@ -198,7 +198,7 @@ new_segment:
 	} /* segments in rq */
 
 
-	if (unlikely(rq->cmd_flags & REQ_COPY_USER) &&
+	if ((rq->cmd_flags & REQ_HAS_TAIL_SPACE_FOR_PADDING) &&
 	    (rq->data_len & q->dma_pad_mask)) {
 		unsigned int pad_len = (q->dma_pad_mask & ~rq->data_len) + 1;
 
diff -upkr linux-2.6.30.1/include/linux/blkdev.h linux-2.6.30.1/include/linux/blkdev.h
--- linux-2.6.30.1/include/linux/blkdev.h	2009-06-10 07:05:27.000000000 +0400
+++ linux-2.6.30.1/include/linux/blkdev.h	2009-07-08 21:18:53.000000000 +0400
@@ -115,7 +115,7 @@ enum rq_flag_bits {
 	__REQ_RW_SYNC,		/* request is sync (sync write or read) */
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_RW_META,		/* metadata io request */
-	__REQ_COPY_USER,	/* contains copies of user pages */
+	__REQ_HAS_TAIL_SPACE_FOR_PADDING, /* has space for padding in the tail */
 	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
 	__REQ_NOIDLE,		/* Don't anticipate more IO after this one */
 	__REQ_IO_STAT,		/* account I/O stat */
@@ -143,7 +143,7 @@ enum rq_flag_bits {
 #define REQ_RW_SYNC	(1 << __REQ_RW_SYNC)
 #define REQ_ALLOCED	(1 << __REQ_ALLOCED)
 #define REQ_RW_META	(1 << __REQ_RW_META)
-#define REQ_COPY_USER	(1 << __REQ_COPY_USER)
+#define REQ_HAS_TAIL_SPACE_FOR_PADDING	(1 << __REQ_HAS_TAIL_SPACE_FOR_PADDING)
 #define REQ_INTEGRITY	(1 << __REQ_INTEGRITY)
 #define REQ_NOIDLE	(1 << __REQ_NOIDLE)
 #define REQ_IO_STAT	(1 << __REQ_IO_STAT)


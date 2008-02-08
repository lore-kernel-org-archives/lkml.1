Return-Path: <linux-kernel-owner+w=401wt.eu-S1762606AbYBHLjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606AbYBHLjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:39:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYBHLix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:38:53 -0500
Received: from brick.kernel.dk ([87.55.233.238]:4561 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbYBHLiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:38:52 -0500
Date: Fri, 8 Feb 2008 12:38:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com,
       npiggin@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@gmail.com>
Subject: Re: [patch] block layer: kmemcheck fixes
Message-ID: <20080208113847.GI15220@kernel.dk>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <1202375945-29525-5-git-send-email-jens.axboe@oracle.com> <20080207100738.GB7716@elte.hu> <20080207101727.GE15220@kernel.dk> <20080207102534.GB16735@elte.hu> <20080207103136.GG15220@kernel.dk> <20080207104901.GF16735@elte.hu> <alpine.LFD.1.00.0802070940230.2883@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802070940230.2883@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07 2008, Linus Torvalds wrote:
> 
> 
> On Thu, 7 Feb 2008, Ingo Molnar wrote:
> >  	INIT_HLIST_NODE(&rq->hash);
> >  	RB_CLEAR_NODE(&rq->rb_node);
> > -	rq->ioprio = 0;
> > -	rq->buffer = NULL;
> > -	rq->ref_count = 1;
> > -	rq->q = q;
> > -	rq->special = NULL;
> > -	rq->data_len = 0;
> > -	rq->data = NULL;
> > -	rq->nr_phys_segments = 0;
> > -	rq->sense = NULL;
> > -	rq->end_io = NULL;
> > -	rq->end_io_data = NULL;
> > -	rq->completion_data = NULL;
> > -	rq->next_rq = NULL;
> > +	rq->completion_data		= NULL;
> > +	/* rq->elevator_private			*/
> > +	/* rq->elevator_private2		*/
> > +	/* rq->rq_disk				*/
> > +	/* rq->start_time			*/
> > +	rq->nr_phys_segments		= 0;
> > +	/* rq->nr_hw_segments			*/
> > +	rq->ioprio			= 0;
> > +	rq->special			= NULL;
> > +	rq->buffer			= NULL;
> ...
> 
> Can we please just stop doing these one-by-one assignments, and just do 
> something like
> 
> 	memset(rq, 0, sizeof(*rq));
> 	rq->q = q;
> 	rq->ref_count = 1;
> 	INIT_HLIST_NODE(&rq->hash);
> 	RB_CLEAR_NODE(&rq->rb_node);
> 
> instead?
> 
> The memset() is likely faster and smaller than one-by-one assignments 
> anyway, even if the one-by-ones can avoid initializing some field or there 
> ends up being a double initialization..

Looked into this approach and we can't currently do that here, since
some members of the request are being set from blk_alloc_request() and
then from the io scheduler attaching private data to it. So we have to
preserve ->cmd_flags and ->elevator_private and ->elevator_private2 at
least. Now rq_init() is also used for stored requests, so we cannot just
rely on clearing at allocation time.

So I'd prefer being a little conservative here. The below reorders
rq_init() a bit and clears some more members to be on the safer side,
adding comments to why we cannot memset and an associated comment in
blkdev.h.

diff --git a/block/blk-core.c b/block/blk-core.c
index 4afb39c..fba4ca7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -102,27 +102,38 @@ struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev)
 }
 EXPORT_SYMBOL(blk_get_backing_dev_info);
 
+/*
+ * We can't just memset() the structure, since the allocation path
+ * already stored some information in the request.
+ */
 void rq_init(struct request_queue *q, struct request *rq)
 {
 	INIT_LIST_HEAD(&rq->queuelist);
 	INIT_LIST_HEAD(&rq->donelist);
-
-	rq->errors = 0;
+	rq->q = q;
+	rq->sector = rq->hard_sector = (sector_t) -1;
+	rq->nr_sectors = rq->hard_nr_sectors = 0;
+	rq->current_nr_sectors = rq->hard_cur_sectors = 0;
 	rq->bio = rq->biotail = NULL;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
+	rq->rq_disk = NULL;
+	rq->nr_phys_segments = 0;
+	rq->nr_hw_segments = 0;
 	rq->ioprio = 0;
+	rq->special = NULL;
 	rq->buffer = NULL;
+	rq->tag = -1;
+	rq->errors = 0;
 	rq->ref_count = 1;
-	rq->q = q;
-	rq->special = NULL;
+	rq->cmd_len = 0;
+	memset(rq->cmd, 0, sizeof(rq->cmd));
 	rq->data_len = 0;
+	rq->sense_len = 0;
 	rq->data = NULL;
-	rq->nr_phys_segments = 0;
 	rq->sense = NULL;
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
-	rq->completion_data = NULL;
 	rq->next_rq = NULL;
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 90392a9..e1888cc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -137,7 +137,9 @@ enum rq_flag_bits {
 #define BLK_MAX_CDB	16
 
 /*
- * try to put the fields that are referenced together in the same cacheline
+ * try to put the fields that are referenced together in the same cacheline.
+ * if you modify this structure, be sure to check block/blk-core.c:rq_init()
+ * as well!
  */
 struct request {
 	struct list_head queuelist;


-- 
Jens Axboe


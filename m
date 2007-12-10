Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbXLJNE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbXLJNE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 08:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXLJNEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 08:04:21 -0500
Received: from phunq.net ([64.81.85.152]:40055 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752500AbXLJNEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 08:04:21 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Date: Mon, 10 Dec 2007 05:04:15 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
References: <200712051603.02183.phillips@phunq.net> <200712100427.58288.phillips@phunq.net> <20071210123244.GG5008@kernel.dk>
In-Reply-To: <20071210123244.GG5008@kernel.dk>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PlTXHjxV0G/Ntae"
Message-Id: <200712100504.15865.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_PlTXHjxV0G/Ntae
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 10 December 2007 04:32, Jens Axboe wrote:
> I honestly don't know how to make this any clearer than I already did
> above.

Sure you do, you could cut out the rhetoric and save lots of bandwidth 
thereby.

Yes, the q = bdev_get_queue(bio->bi_bdev) needs to be repeated inside 
the submission loop, that was a flaw, thanks for the catch.

Regards,

Daniel

--Boundary-00=_PlTXHjxV0G/Ntae
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="bio.throttle-2.6.24-rc3-mm"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="bio.throttle-2.6.24-rc3-mm"

--- 2.6.24-rc3-mm.clean/block/ll_rw_blk.c	2007-12-04 14:45:25.000000000 -0800
+++ 2.6.24-rc3-mm/block/ll_rw_blk.c	2007-12-10 04:49:56.000000000 -0800
@@ -3210,9 +3210,9 @@ static inline int bio_check_eod(struct b
  */
 static inline void __generic_make_request(struct bio *bio)
 {
-	struct request_queue *q;
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	sector_t old_sector;
-	int ret, nr_sectors = bio_sectors(bio);
+	int nr_sectors = bio_sectors(bio);
 	dev_t old_dev;
 	int err = -EIO;
 
@@ -3221,6 +3221,13 @@ static inline void __generic_make_reques
 	if (bio_check_eod(bio, nr_sectors))
 		goto end_io;
 
+	if (q && q->metric && !bio->bi_queue) {
+		int need = bio->bi_throttle = q->metric(bio);
+		bio->bi_queue = q;
+		/* FIXME: potential race if atomic_sub is called in the middle of condition check */
+		wait_event(q->throttle_wait, atomic_read(&q->available) >= need);
+		atomic_sub(need, &q->available);
+	}
 	/*
 	 * Resolve the mapping until finished. (drivers are
 	 * still free to implement/resolve their own stacking
@@ -3231,10 +3238,9 @@ static inline void __generic_make_reques
 	 */
 	old_sector = -1;
 	old_dev = 0;
-	do {
+	while (1) {
 		char b[BDEVNAME_SIZE];
 
-		q = bdev_get_queue(bio->bi_bdev);
 		if (!q) {
 			printk(KERN_ERR
 			       "generic_make_request: Trying to access "
@@ -3282,8 +3288,10 @@ end_io:
 			goto end_io;
 		}
 
-		ret = q->make_request_fn(q, bio);
-	} while (ret);
+		if (!q->make_request_fn(q, bio))
+			return;
+		q = bdev_get_queue(bio->bi_bdev);
+	}
 }
 
 /*
--- 2.6.24-rc3-mm.clean/drivers/md/dm.c	2007-12-04 14:46:04.000000000 -0800
+++ 2.6.24-rc3-mm/drivers/md/dm.c	2007-12-04 23:31:41.000000000 -0800
@@ -889,6 +889,11 @@ static int dm_any_congested(void *conges
 	return r;
 }
 
+static unsigned dm_metric(struct bio *bio)
+{
+	return bio->bi_vcnt;
+}
+
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
@@ -967,6 +972,7 @@ out:
 
 static struct block_device_operations dm_blk_dops;
 
+#define DEFAULT_THROTTLE_CAPACITY 1000
 /*
  * Allocate and initialise a blank device with a given minor.
  */
@@ -1009,6 +1015,11 @@ static struct mapped_device *alloc_dev(i
 		goto bad1_free_minor;
 
 	md->queue->queuedata = md;
+	md->queue->metric = dm_metric;
+	/* A dm device constructor may change the throttle capacity */
+	atomic_set(&md->queue->available, md->queue->capacity = DEFAULT_THROTTLE_CAPACITY);
+	init_waitqueue_head(&md->queue->throttle_wait);
+
 	md->queue->backing_dev_info.congested_fn = dm_any_congested;
 	md->queue->backing_dev_info.congested_data = md;
 	blk_queue_make_request(md->queue, dm_request);
--- 2.6.24-rc3-mm.clean/fs/bio.c	2007-12-04 14:38:47.000000000 -0800
+++ 2.6.24-rc3-mm/fs/bio.c	2007-12-04 23:31:41.000000000 -0800
@@ -1007,6 +1007,13 @@ void bio_endio(struct bio *bio, int erro
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	if (bio->bi_throttle) {
+		struct request_queue *q = bio->bi_queue;
+		bio->bi_throttle = 0; /* or detect multiple endio and err? */
+		atomic_add(bio->bi_throttle, &q->available);
+		wake_up(&q->throttle_wait);
+	}
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
--- 2.6.24-rc3-mm.clean/include/linux/bio.h	2007-12-04 14:39:31.000000000 -0800
+++ 2.6.24-rc3-mm/include/linux/bio.h	2007-12-04 23:31:41.000000000 -0800
@@ -111,6 +111,9 @@ struct bio {
 	bio_end_io_t		*bi_end_io;
 	atomic_t		bi_cnt;		/* pin count */
 
+	struct request_queue	*bi_queue;	/* for throttling */
+	unsigned		bi_throttle;	/* throttle metric */
+
 	void			*bi_private;
 
 	bio_destructor_t	*bi_destructor;	/* destructor */
--- 2.6.24-rc3-mm.clean/include/linux/blkdev.h	2007-12-04 14:47:18.000000000 -0800
+++ 2.6.24-rc3-mm/include/linux/blkdev.h	2007-12-04 23:31:41.000000000 -0800
@@ -383,6 +383,10 @@ struct request_queue
 	struct work_struct	unplug_work;
 
 	struct backing_dev_info	backing_dev_info;
+	unsigned (*metric)(struct bio *bio);	/* bio throttle metric */
+	wait_queue_head_t	throttle_wait;
+	atomic_t		available;
+	unsigned		capacity;
 
 	/*
 	 * The queue owner gets to use this for whatever they like.

--Boundary-00=_PlTXHjxV0G/Ntae--

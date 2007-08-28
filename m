Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbXH1VIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbXH1VIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 17:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbXH1VIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 17:08:23 -0400
Received: from phunq.net ([64.81.85.152]:47715 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751571AbXH1VIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 17:08:22 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] Block device throttling [Re: Distributed storage.]
Date: Tue, 28 Aug 2007 14:08:04 -0700
User-Agent: KMail/1.9.5
Cc: Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708281027.59528.phillips@phunq.net> <20070828175403.GA28440@2ka.mipt.ru>
In-Reply-To: <20070828175403.GA28440@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708281408.06618.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 August 2007 10:54, Evgeniy Polyakov wrote:
> On Tue, Aug 28, 2007 at 10:27:59AM -0700, Daniel Phillips (phillips@phunq.net) wrote:
> > > We do not care about one cpu being able to increase its counter
> > > higher than the limit, such inaccuracy (maximum bios in flight
> > > thus can be more than limit, difference is equal to the number of
> > > CPUs - 1) is a price for removing atomic operation. I thought I
> > > pointed it in the original description, but might forget, that if
> > > it will be an issue, that atomic operations can be introduced
> > > there. Any uber-precise measurements in the case when we are
> > > close to the edge will not give us any benefit at all, since were
> > > are already in the grey area.
> >
> > This is not just inaccurate, it is suicide.  Keep leaking throttle
> > counts and eventually all of them will be gone.  No more IO
> > on that block device!
>
> First, because number of increased and decreased operations are the
> same, so it will dance around limit in both directions.

No.  Please go and read it the description of the race again.  A count
gets irretrievably lost because the write operation of the first
decrement is overwritten by the second. Data gets lost.  Atomic 
operations exist to prevent that sort of thing.  You either need to use 
them or have a deep understanding of SMP read and write ordering in 
order to preserve data integrity by some equivalent algorithm.

> Let's solve problems in order of their appearence. If bio structure
> will be allowed to grow, then the whole patches can be done better.

How about like the patch below.  This throttles any block driver by
implementing a throttle metric method so that each block driver can
keep track of its own resource consumption in units of its choosing.
As an (important) example, it implements a simple metric for device
mapper devices.  Other block devices will work as before, because
they do not define any metric.  Short, sweet and untested, which is
why I have not posted it until now.

This patch originally kept its accounting info in backing_dev_info,
however that structure seems to be in some and it is just a part of
struct queue anyway, so I lifted the throttle accounting up into
struct queue.  We should be able to report on the efficacy of this
patch in terms of deadlock prevention pretty soon.

--- 2.6.22.clean/block/ll_rw_blk.c	2007-07-08 16:32:17.000000000 -0700
+++ 2.6.22/block/ll_rw_blk.c	2007-08-24 12:07:16.000000000 -0700
@@ -3237,6 +3237,15 @@ end_io:
  */
 void generic_make_request(struct bio *bio)
 {
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+
+	if (q && q->metric) {
+		int need = bio->bi_reserved = q->metric(bio);
+		bio->queue = q;
+		wait_event_interruptible(q->throttle_wait, atomic_read(&q->available) >= need);
+		atomic_sub(&q->available, need);
+	}
+
 	if (current->bio_tail) {
 		/* make_request is active */
 		*(current->bio_tail) = bio;
--- 2.6.22.clean/drivers/md/dm.c	2007-07-08 16:32:17.000000000 -0700
+++ 2.6.22/drivers/md/dm.c	2007-08-24 12:14:23.000000000 -0700
@@ -880,6 +880,11 @@ static int dm_any_congested(void *conges
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
@@ -997,6 +1002,10 @@ static struct mapped_device *alloc_dev(i
 		goto bad1_free_minor;
 
 	md->queue->queuedata = md;
+	md->queue->metric = dm_metric;
+	atomic_set(&md->queue->available, md->queue->capacity = 1000);
+	init_waitqueue_head(&md->queue->throttle_wait);
+
 	md->queue->backing_dev_info.congested_fn = dm_any_congested;
 	md->queue->backing_dev_info.congested_data = md;
 	blk_queue_make_request(md->queue, dm_request);
--- 2.6.22.clean/fs/bio.c	2007-07-08 16:32:17.000000000 -0700
+++ 2.6.22/fs/bio.c	2007-08-24 12:10:41.000000000 -0700
@@ -1025,7 +1025,12 @@ void bio_endio(struct bio *bio, unsigned
 		bytes_done = bio->bi_size;
 	}
 
-	bio->bi_size -= bytes_done;
+	if (!(bio->bi_size -= bytes_done) && bio->bi_reserved) {
+		struct request_queue *q = bio->queue;
+		atomic_add(&q->available, bio->bi_reserved);
+		bio->bi_reserved = 0; /* just in case */
+		wake_up(&q->throttle_wait);
+	}
 	bio->bi_sector += (bytes_done >> 9);
 
 	if (bio->bi_end_io)
--- 2.6.22.clean/include/linux/bio.h	2007-07-08 16:32:17.000000000 -0700
+++ 2.6.22/include/linux/bio.h	2007-08-24 11:53:51.000000000 -0700
@@ -109,6 +109,9 @@ struct bio {
 	bio_end_io_t		*bi_end_io;
 	atomic_t		bi_cnt;		/* pin count */
 
+	struct request_queue	*queue;		/* for throttling */
+	unsigned		bi_reserved;	/* throttle metric */
+
 	void			*bi_private;
 
 	bio_destructor_t	*bi_destructor;	/* destructor */
--- 2.6.22.clean/include/linux/blkdev.h	2007-07-08 16:32:17.000000000 -0700
+++ 2.6.22/include/linux/blkdev.h	2007-08-24 12:04:14.000000000 -0700
@@ -395,6 +395,10 @@ struct request_queue
 	struct work_struct	unplug_work;
 
 	struct backing_dev_info	backing_dev_info;
+	unsigned (*metric)(struct bio *bio);	/* bio throttle metric */
+	wait_queue_head_t	throttle_wait;
+	atomic_t		available;
+	unsigned		capacity;
 
 	/*
 	 * The queue owner gets to use this for whatever they like.

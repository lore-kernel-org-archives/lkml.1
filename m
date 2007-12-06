Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbXLFAD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbXLFAD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 19:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXLFADS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 19:03:18 -0500
Received: from phunq.net ([64.81.85.152]:53555 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750954AbXLFADQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 19:03:16 -0500
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH] A clean approach to writeout throttling
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Date: Wed, 5 Dec 2007 16:03:01 -0800
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200712051603.02183.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good afternoon,

According to me, each line of code removed from the kernel is worth ten 
lines added.  If lines can be removed while at the same time improving 
performance, that is worth, ah, about 1,000 times more than lines 
added, correct?  Or maybe 1,000,000 times as much, if removing lines 
removes a deadlock at the same time, something like that.

Today's patch is a step towards removing many lines of code from 
mainline and also aims to improve write cache performance, eliminate a 
troublesome class of deadlocks, save kernel memory and make the kernel 
easier to read.

Background

We seriously began to tackle the issue of block writeout vm deadlock 
more than three years ago,  and by now we have acreted a creaky 
agglomeration of dirty page limits, dirty page balancing between block 
devices, and miscellaneous other hacks attempting to solve these 
deadlocks.  These bandaids as of 2.6.23 do not in themselves address 
the underlying problem, but they do add a lot of code to core kernel 
and they do impair write Linux's write cache performance.  This is a 
classic case of fixing symptoms instead of the cause of a problem.  The 
worst part of it?  The dirty page limit idea did not actually fix the 
deadlock it was supposed to, but instead generated a new class of 
deadlocks that are easier to trigger.

The basis of the writeout deadlock scenario is easy to see: a task 
requests a page of memory, but all pages are currently in use for 
caching among other things.  To recover memory, some disk-backed pages 
must be evicted.  Dirty pages must be written to disk before being 
evicted, so they are passed to the block layer for writeout.  If any 
code in the block writeout path needs to allocate memory to do its 
work, then we can deadlock because the  shortage of memory prevents the 
block layer from making progress to recover memory.

So far, I have just summarized what everybody knows.  This deadlock 
scenario has been present in Linux since day one, and has been solved 
for local block devices since very early on, by the simple expedient of 
providing a reserve of "memalloc" pages that a task may access only if 
it is in the call chain of a memory manager task engaged in writing out 
dirty pages.

What was not commonly known three years ago is that the memalloc reserve 
solution fails in some cases, all of which share the common attribute 
that the task trying to allocate memory for block writeout is not the 
same as the task that initiated the writeout.  In this case, 
the "PF_MEMALLOC" task flag strategy fails because the consumer of the 
memory is not in the call chain of the submitter, and thus does not 
inherit the flag.  Examples of such deadlock-prone use cases include:

   * Fancy virtual block devices with helper daemons
   * Network block device accessed locally
   * Swap over network
   * Remote block devices in general
   * Any block device with a user space component
   * Filesystems implemented in user space

To put it bluntly: without solving these deadlocks, Linux is pretty much 
useless in many modern storage roles.

When I started working on this problem years go, I went at it by 
tackling the nastiest, most icky manifestation of it first, namely the 
possibility that the network layer might be unable to allocate memory 
to receive a reply packet from a remote block device.  Unfortunately, 
the tricky details of the solution to this problem had the unintended 
effect of overshadowing the main issues, just because the details of 
the network receive deadlock are so deliciously obscure.  Ironically, 
we found that the network read readlock scenario does not occur in 
practice.  It is high time to draw attention back to the main issue.

The meta-mistake I made while tackling this problem was to focus 
mainly on the logistics of providing "writeout helper" tasks with 
access to memory reserves, and just assume that it would be easy to 
place limits on how deep the helpers would dip into the reserves, which 
restriction is obviously necessary to prevent deadlock.  This was so 
obvious in fact that I (we) did not get around to implementing it until 
quite recently.  Then it became abundantly clear that limiting resource 
requirements is actually the main ingredient of any correct solution, 
and that the various complexities of providing access to memory 
reserves do not amount to much more than an interesting side show.
We (Zumastor team) proved this to ourselves by removing the 
entire "PeterZ" patch set we were carrying (a distant descendant of my 
original network deadlock prevention patch) and lo!  No deadlocks.  It 
seems that throttling writeout traffic in an organized way amounts to 
powerful magic indeed.

So that is all by way of saying, today's patch to limit the amount of 
data in flight to a block device is an Important Patch.  We find that 
our own storage project needs very little more than this hundred lines 
of code or so to wave goodbye permanently to writeout deadlocks, and 
thereby make our storage software actually useful.  Extension to the 
other use cases listed above is Obvious[tm].

Theory

Terje Mathisen said "almost all programming can be viewed as an exercise 
in caching."  In fact, almost all of the Linux kernel can be viewed as 
an exercise in caching.  The main job of the kernel (granted, there are 
other side jobs) is to move data back and forth between disk and 
memory.  We can usefully define the from-memory-to-disk half of this 
task as "progress".  So the main reason for the kernel to exist at all 
is to make progress by writing dirty memory to disk.  OK?

With that definition in hand, we can see right away what must be done to 
guarantee progress: the part of the kernel that makes progress must be 
guaranteed to have enough resources to make progress.  Like a shark, 
when the kernel stops swimming it dies.  (Ok, that analogy is admittedly 
stupid but I still cannot get Linus's rabbits and bazookas out of my 
head, so retaliation is in order.)

To guarantee resources, we need to do two things:

   1) Provide a dedicated pool of resources

   2) Ensure that the consumer never requires more than its share of
        the dedicated resource pool in order to make progress

For the problem at hand a suitable resource pool already exists, namely 
the memalloc reserve.  However, examination of the attached patch will 
show  that it knows nothing about that particular form of dedicated 
reserve:  in fact any form of reserve, for example, Ingo's mempool, or 
any other will do.  The key item is (2) above: we require a sane way of 
ensuring that the consumer (the block writeout path) never exceeds its 
allotment of resources.  This we accomplish simply, by imposing a limit 
on the amount of data that can be in flight to any particular block 
device.

Practice

So here is the key idea of today's patch: it provides a simple mechanism 
for imposing a limit on the amount of data that can be in flight to any 
particular block device.

The limit on in-flight data is in fact expressed generically, as it is 
hard to set down any single rule to specify the amount of resources 
any particular bio transfer will require.  Instead, the block layer 
provides a method that a block driver may optionally fill in, to 
calculate the resource bound in units of the block driver's choosing.  
The block driver thus takes upon itself the task of translating its 
own, self-imposed bound into generic resource units that can be treated 
generically by the kernel.  In simple terms, the block driver looks at 
each bio and decides how many pages (at most) of memalloc reserve could 
be needed to fully service the transfer, and translates that 
requirement into generic units for use by the block layer. The block 
layer compares the generic units to a generic bound provided by the 
block driver at initialization time and decides whether to let the bio 
transfer in question proceed, or hold it back.

This idea is Simplicity itself.  Some not so obvious details follow.

For one thing, a block device these days may not be just a single 
device, but may be a stack of devices connected together by a generic 
mechanism such as device mapper, or a hardcoded stack such as 
multi-disk or network block device.  It is necessary to consider the 
resource requirements of the stack as a whole _before_ letting a 
transfer proceed into any layer of the stack, otherwise deadlock on 
many partially completed transfers becomes a possibility.  For this 
reason, the bio throttling is only implemented at the initial, highest 
level submission of the bio to the block layer and not for any recursive 
submission of the same bio to a lower level block device in a stack.

This in turn has rather far reaching implications: the top level device 
in a stack must take care of inspecting the entire stack in order to 
determine how to calculate its resource requirements, thus becoming
the boss device for the entire stack.  Though this intriguing idea could 
easily become the cause of endless design work and many thousands of 
lines of fancy code, today I sidestep the question entirely using 
the "just provide lots of reserve" strategy.  Horrifying as it may seem 
to some, this is precisely the strategy that Linux has used in the 
context of resource management in general, from the very beginning and 
likely continuing for quite some time into the future  My strongly held 
opinion in this matter is that we need to solve the real, underlying 
problems definitively with nice code before declaring the opening of 
fancy patch season.  So I am leaving further discussion of automatic 
resource discovery algorithms and the like out of this post.

Today's patch implements _only_ the inflight-data limiting, and does not 
include any code to provide access to reserves.  In practice, simply 
oring PF_MEMALLOC into the flags of each writeout helper daemon does 
the trick.  We also found that we had to disable or work around the 
code that enforces memory dirty limits (contestion_wait) which 
otherwise causes a whole new class of deadlocks, which are in fact 
easier to trigger than the deadlocks it attempts to fix.

Overhead.

This bio patch adds a small amount of overhead to the bio processing 
path, consisting of one new test in submit_bio (generic_make_request) 
and one new test in bio->bi_endio, just to see if thottling methods are 
present.  I do not think that the extra cpu consumed is measurable.  
There is also a slight increase in the size of struct bio to hold two 
new fields, one to reference the struct queue of the block device in 
question and another to remember how many units of resources were 
assigned to the bio in order that exactly that many may be released on 
completion.  In fact, total memory use due to struct bio is typically 
reduced by a not insignificant amount by limiting the number of bios 
concurrently in flight.  Provided of course that local block devices 
also adopt this mechanism, which in fact would be a Very Good Thing[1] 
for reasons I will not get into here.

That is enough for today, and arguably too much, because in the past, 
communicating these simple ideas has always seemed to founder on the 
intrusion of many peripherally related ideas, hijacking the discussion.  
Either that, or appear to be such an involved subject that nobody will 
risk anything more than a cosmetic reply.  Hopefully not this time.

Let me close with perhaps the most relevant remarks: the attached code 
has been in heavy testing and in production for months now.  Thus there 
is nothing theoretical when I say it works, and the patch speaks for 
itself in terms of obvious correctness.  What I hope to add to this in 
the not too distant future is the news that we have removed hundreds of 
lines of existing kernel code, maintaining stability and improving 
performance.

Regards,

Daniel


--- 2.6.24-rc3-mm.clean/block/ll_rw_blk.c	2007-12-04 14:45:25.000000000 -0800
+++ 2.6.24-rc3-mm/block/ll_rw_blk.c	2007-12-04 14:01:18.000000000 -0800
@@ -3210,7 +3210,7 @@ static inline int bio_check_eod(struct b
  */
 static inline void __generic_make_request(struct bio *bio)
 {
-	struct request_queue *q;
+	request_queue_t *q = bdev_get_queue(bio->bi_bdev);
 	sector_t old_sector;
 	int ret, nr_sectors = bio_sectors(bio);
 	dev_t old_dev;
@@ -3221,6 +3221,13 @@ static inline void __generic_make_reques
 	if (bio_check_eod(bio, nr_sectors))
 		goto end_io;
 
+	if (q && q->metric && !bio->bi_queue) {
+		int need = bio->bi_throttle = q->metric(bio);
+		bio->bi_queue = q;
+		/* FIXME: potential race if atomic_sub is called in the middle of condition check */
+		wait_event_interruptible(q->throttle_wait, atomic_read(&q->available) >= need);
+		atomic_sub(need, &q->available);
+	}
 	/*
 	 * Resolve the mapping until finished. (drivers are
 	 * still free to implement/resolve their own stacking
@@ -3234,7 +3241,6 @@ static inline void __generic_make_reques
 	do {
 		char b[BDEVNAME_SIZE];
 
-		q = bdev_get_queue(bio->bi_bdev);
 		if (!q) {
 			printk(KERN_ERR
 			       "generic_make_request: Trying to access "
--- 2.6.24-rc3-mm.clean/drivers/md/dm.c	2007-12-04 14:46:04.000000000 -0800
+++ 2.6.24-rc3-mm/drivers/md/dm.c	2007-12-04 15:26:16.000000000 -0800
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
+++ 2.6.24-rc3-mm/fs/bio.c	2007-12-04 14:14:15.000000000 -0800
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
+++ 2.6.24-rc3-mm/include/linux/bio.h	2007-12-04 13:56:51.000000000 -0800
@@ -111,6 +111,9 @@ struct bio {
 	bio_end_io_t		*bi_end_io;
 	atomic_t		bi_cnt;		/* pin count */
 
+	struct request_queue	*bi_queue;	/* for throttling */
+	unsigned		bi_throttle;	/* throttle metric */
+
 	void			*bi_private;
 
 	bio_destructor_t	*bi_destructor;	/* destructor */
--- 2.6.24-rc3-mm.clean/include/linux/blkdev.h	2007-12-04 14:47:18.000000000 -0800
+++ 2.6.24-rc3-mm/include/linux/blkdev.h	2007-12-04 13:56:51.000000000 -0800
@@ -383,6 +383,10 @@ struct request_queue
 	struct work_struct	unplug_work;
 
 	struct backing_dev_info	backing_dev_info;
+	unsigned (*metric)(struct bio *bio);	/* bio throttle metric */
+	wait_queue_head_t	throttle_wait;
+	atomic_t		available;
+	unsigned		capacity;
 
 	/*
 	 * The queue owner gets to use this for whatever they like.

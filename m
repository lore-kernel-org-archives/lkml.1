Return-Path: <linux-kernel-owner+w=401wt.eu-S1422954AbXDRMjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422954AbXDRMjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 08:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422969AbXDRMjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 08:39:06 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16633 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422968AbXDRMjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 08:39:04 -0400
Date: Wed, 18 Apr 2007 14:37:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, Brad Campbell <brad@wasp.net.au>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
Message-ID: <20070418123757.GC3796@kernel.dk>
References: <4621FAF0.7000705@wasp.net.au> <46220339.9080205@wasp.net.au> <4623FB29.1000603@redhat.com> <17956.22235.574867.179016@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17956.22235.574867.179016@notabene.brown>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17 2007, Neil Brown wrote:
> On Monday April 16, cebbert@redhat.com wrote:
> > 
> > cfq_dispatch_insert() was called with rq == 0. This one is getting really
> > annoying... and md is involved again (RAID0 this time.)
> 
> Yeah... weird.
> RAID0 is so light-weight and so different from RAID1 or RAID5 that I
> feel fairly safe concluding that the problem isn't in or near md.
> But that doesn't help you.

Well the fact is that we have 3-4 distinct reports of this oops, and all
of them are using md. No reports have been filed where md isn't managing
the disks. While this doesn't conclusively put the finger of blame on
md, it is still likely. It could bug a CFQ bug too of course, or (more
likely), some bad interaction between md and CFQ.

> This really feels like a locking problem.

Very much.

> The problem occurs when ->next_rq is NULL, but ->sort_list.rb_node is
> not NULL.  That happens plenty of times in the code (particularly as
> the first request is inserted) but always under ->queue_lock so it
> should never be visible to cfq_dispatch_insert..
> 
> Except that drivers/scsi/ide-scsi.c:idescsi_eh_reset calls
> elv_next_request which could ultimately call __cfq_dispatch_requests
> without taking ->queue_lock (that I can see).  But you probably aren't
> using ide-scsi (does anyone?).
> 
> Given that interrupts are always disabled when queue_lock is taken, it
> might be useful to add
>    WARN_ON(!irqs_disabled());
> every time ->next_rq is set.
> Something like the following.
> 
> It might show something useful.... if we are lucky.

I had something similar for generic_unplug_request() as well, but didn't
see/hear any reports of it being tried out. Here's a complete debugging
patch for this and other potential dangers.

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b6491c0..8f749aa 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -587,8 +587,11 @@ static void cfq_remove_request(struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
-	if (cfqq->next_rq == rq)
+	BUG_ON(!irqs_disabled());
+	if (cfqq->next_rq == rq) {
 		cfqq->next_rq = cfq_find_next_rq(cfqq->cfqd, cfqq, rq);
+		BUG_ON(!cfqq->next_rq && !RB_EMPTY_ROOT(&cfqq->sort_list));
+	}
 
 	list_del_init(&rq->queuelist);
 	cfq_del_rq_rb(rq);
@@ -1637,6 +1640,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	/*
 	 * check if this request is a better next-serve candidate)) {
 	 */
+	BUG_ON(!irqs_disabled());
 	cfqq->next_rq = cfq_choose_req(cfqd, cfqq->next_rq, rq);
 	BUG_ON(!cfqq->next_rq);
 
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 3de0695..c16863e 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1602,6 +1602,8 @@ EXPORT_SYMBOL(__generic_unplug_device);
  **/
 void generic_unplug_device(request_queue_t *q)
 {
+	BUG_ON(irqs_disabled());
+
 	spin_lock_irq(q->queue_lock);
 	__generic_unplug_device(q);
 	spin_unlock_irq(q->queue_lock);

-- 
Jens Axboe


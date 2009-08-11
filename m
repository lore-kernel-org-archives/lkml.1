Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbZHKMEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbZHKMEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZHKMEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:04:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbZHKMEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:04:34 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH-v2 2/2] Initialize mempool and elevator only for request-based dm devices
Date: Tue, 11 Aug 2009 14:35:11 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
References: <200908081026.01097.knikanth@suse.de> <200908101618.21060.knikanth@suse.de> <4A812680.7040804@ct.jp.nec.com>
In-Reply-To: <4A812680.7040804@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908111435.12020.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 August 2009 13:36:24 Kiyoshi Ueda wrote:
> Hi Nikanth,
>
> On 08/10/2009 07:48 PM +0900, Nikanth Karthikesan wrote:
> > Intialize the request_queue and elevator only when the device is marked
> > as a request-based device. This avoids unnecessary creation of mempool
> > for requests. Also we wrongly initialize the elevator even for bio-based
> > devices. As the /sys/block/dm-*/queue/scheduler is exported for
> > device-mapper devices, it is possible to confuse with scheduler options
> > for bio-based devices where scheduler is not at all used.
>
> Thank you for working on this.
> Actually, I had tried this delayed allocation thing before,
> but I chose the current implementation since I couldn't solve
> some problems, which your patch also has.
> Please see my comment below.
>

Thanks for the review & comments.

> > @@ -2203,6 +2199,25 @@ int dm_swap_table(struct mapped_device *md, struct
> > dm_table *table) goto out;
> >  	}
> >
> > +	/* new device is being marked as request-based */
> > +	if (!md->map && dm_table_request_based(table)) {
> > +		/* initialize queue for request-based dm */
> > +		r = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
> > +		if (r)
> > +			goto out;
>
> Generally, dm must not allocate memory during resume because
> it may cause a deadlock in no memory situation.
> However, there is no I/O on this device at this point,
> so the allocation should be ok for this special case.
> I think some comments are needed here to describe that.
>

Ok. This comment can be added.

> > +
> > +		/*
> > +		 * reinitialize make_request_fn as it was reset to the
> > +		 * default __make_request by blk_init_allocate_queue
> > +		 */
> > +		md->saved_make_request_fn = md->queue->make_request_fn;
> > +		blk_queue_make_request(md->queue, dm_request);
> > +
> > +		blk_queue_softirq_done(md->queue, dm_softirq_done);
> > +		blk_queue_prep_rq(md->queue, dm_prep_fn);
> > +		blk_queue_lld_busy(md->queue, dm_lld_busy);
> > +	}
> > +
> >  	__unbind(md);
> >  	r = __bind(md, table, &limits);
>
> The queue has been registered at the device creation time by
> add_disk() in alloc_dev().
> Since the queue is reconfigured (elevator is attached), you have to
> update the queue registration (e.g. unregister, then re-register).
> But it may not be easy.  At least, there is no exported interface to
> unregister/re-register queue.

Ah, yes. The scheduler attributes will not be exported in 
/sys/block/dm*/queue/iosched. Exporting elv_register_queue() and calling it 
here solves it. Something like..

@@ -2203,6 +2199,29 @@ int dm_swap_table(struct mapped_device *md, struct 
dm_table *table)
 		goto out;
 	}
 
+	/* new device is being marked as request-based */
+	if (!md->map && dm_table_request_based(table)) {
+		/* initialize queue for request-based dm */
+		r = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
+		if (r)
+			goto out;
+
+		r = elv_register_queue(md->queue);
+		/* if (r)
+		 *	 goto out; Better to ignore, just like add_disk does ;-)
+		 */
+		/*
+		 * reinitialize make_request_fn as it was reset to the
+		 * default __make_request by blk_init_allocate_queue
+		 */
+		md->saved_make_request_fn = md->queue->make_request_fn;
+		blk_queue_make_request(md->queue, dm_request);
+
+		blk_queue_softirq_done(md->queue, dm_softirq_done);
+		blk_queue_prep_rq(md->queue, dm_prep_fn);
+		blk_queue_lld_busy(md->queue, dm_lld_busy);
+	}
+
 	__unbind(md);
 	r = __bind(md, table, &limits);
 
I would post the v3 of the patches with this change. Do you see any problems 
in this?

This can also be solved by initializing the queue for new devices and then 
unregistering the elevator, if it is a bio-based device at table load time. 
Like...

diff --git a/block/elevator.c b/block/elevator.c
index 2d511f9..864dd29 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -939,9 +939,10 @@ static void __elv_unregister_queue(struct elevator_queue 
*e)
 
 void elv_unregister_queue(struct request_queue *q)
 {
-	if (q)
+	if (q && q->elevator)
 		__elv_unregister_queue(q->elevator);
 }
+EXPORT_SYMBOL(elv_unregister_queue);
 
 void elv_register(struct elevator_type *e)
 {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8a311ea..f6f77ea 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2203,7 +2203,28 @@ int dm_swap_table(struct mapped_device *md, struct 
dm_table *table)
 		goto out;
 	}
 
-	__unbind(md);
+	if (md->map)
+		__unbind(md);
+	else if (!dm_table_request_based(table)) {
+	/*
+	 * This is a new bio-based device, and doesnt use the elevator
+	 * and requests.
+	 */
+		struct request_queue *q;
+		q = md->queue;
+		if (q->elevator) {
+			struct request_list *rl = &q->rq;
+			elevator_exit(q->elevator);
+			elv_unregister_queue(q);
+			q->elevator = 0;
+			if (rl->rq_pool) {
+				mempool_destroy(rl->rq_pool);
+				rl->rq_pool = 0;
+			}
+		}
+
+	}
+
 	r = __bind(md, table, &limits);
 
 out:

But, I think, delaying the initialization, is the best solution.

Thanks
Nikanth

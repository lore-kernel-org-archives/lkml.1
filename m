Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYJPLyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYJPLyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbYJPLyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:54:15 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35020 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022AbYJPLyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:54:14 -0400
Date: Thu, 16 Oct 2008 13:53:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: lockdep vs rmmod loop
Message-ID: <20081016115328.GA19428@kernel.dk>
References: <20081013175732.GA16390@x200.localdomain> <1223985098.9557.3.camel@twins> <20081014151401.GF23968@x200.localdomain> <1224157746.28131.47.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224157746.28131.47.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16 2008, Peter Zijlstra wrote:
> On Tue, 2008-10-14 at 19:14 +0400, Alexey Dobriyan wrote:
> > On Tue, Oct 14, 2008 at 01:51:38PM +0200, Peter Zijlstra wrote:
> > > On Mon, 2008-10-13 at 21:57 +0400, Alexey Dobriyan wrote:
> > > > This exists for quite some time, IIRC.
> > > > 
> > > > 	# rmmod loop
> > > 
> > > I tried to reproduce with -git from today but failed.
> > > 
> > > v2.6.27-3976-g7591103
> > > 
> > > I build a x86_64 kernel with modular loop and lockdep enabled, then I
> > > did: modprobe loop; rmmod loop
> > > 
> > > Is there anything else to reproducing this?
> > 
> > No, modprobe,rmmod is enough here even with minimal debugging.
> 
> Yep can reproduce with your config.
> 
> Its:
> 
> static void wait_on_work(struct work_struct *work)
> {
> 	...
> 	lock_map_acquire(&work->lockdep_map);
> 	lock_map_release(&work->lockdep_map);
> 
> 
> that triggers this. Which would suggest the work-let wasn't properly
> initialized. Now on to figuring out where it came from.
> 
> Loop doesn't appear to have anything workqueue related in it, which
> suggests the block layer.
> 
> And indeed, it appears blk_queue_make_request() initializes
> q->unplug_work, and by modprobe loop; rmmod loop you never get to run
> that, therefore q->unplug_work gets canceled without ever having been
> initialized -> bang!
> 
> And indeed, the below patch fixes it:
> 
> ---
> Subject: block: move q->unplug_work initialization
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Oct 16 13:44:57 CEST 2008
> 
> modprobe loop; rmmod loop effectively creates a blk_queue and destroys it
> which results in q->unplug_work being canceled without it ever being
> initialized.
> 
> Therefore, move the initialization of q->unplug_work from 
> blk_queue_make_request() to blk_alloc_queue*().
> 
> Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  block/blk-core.c     |    1 +
>  block/blk-settings.c |    2 --
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-2.6/block/blk-core.c
> ===================================================================
> --- linux-2.6.orig/block/blk-core.c
> +++ linux-2.6/block/blk-core.c
> @@ -501,6 +501,7 @@ struct request_queue *blk_alloc_queue_no
>  	init_timer(&q->unplug_timer);
>  	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
>  	INIT_LIST_HEAD(&q->timeout_list);
> +	INIT_WORK(&q->unplug_work, blk_unplug_work);
>  
>  	kobject_init(&q->kobj, &blk_queue_ktype);
>  
> Index: linux-2.6/block/blk-settings.c
> ===================================================================
> --- linux-2.6.orig/block/blk-settings.c
> +++ linux-2.6/block/blk-settings.c
> @@ -141,8 +141,6 @@ void blk_queue_make_request(struct reque
>  	if (q->unplug_delay == 0)
>  		q->unplug_delay = 1;
>  
> -	INIT_WORK(&q->unplug_work, blk_unplug_work);
> -
>  	q->unplug_timer.function = blk_unplug_timeout;
>  	q->unplug_timer.data = (unsigned long)q;
>  
> 
> 

That looks good, applied!

-- 
Jens Axboe


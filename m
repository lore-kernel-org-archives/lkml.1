Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbZHFHFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbZHFHFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 03:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZHFHFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 03:05:47 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49201 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZHFHFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:05:46 -0400
Date: Thu, 6 Aug 2009 09:05:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 5/9] writeback: support > 1 flusher thread per bdi
Message-ID: <20090806070546.GH12579@kernel.dk>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <1248989044-21605-6-git-send-email-jens.axboe@oracle.com> <20090805195504.GD27505@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805195504.GD27505@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05 2009, Jan Kara wrote:
> > +static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
> > +{
> > +	if (work) {
> > +		work->seen = bdi->wb_mask;
> > +		BUG_ON(!work->seen);
> > +		atomic_set(&work->pending, bdi->wb_cnt);
>   I guess the idea here is that every writeback thread has to acknowledge
> the work. But what if some thread decides to die after the work is queued
> but before it manages to acknowledge it? We would end up waiting
> indefinitely...

The writeback thread checks for race added work on exit, so it should be
fine. Additionally, only the default thread will exit and that one will
always have it's count and mask be valid (since we auto-fork it again,
if needed).

> 
> > +		BUG_ON(!bdi->wb_cnt);
> > +
> > +		/*
> > +		 * Make sure stores are seen before it appears on the list
> > +		 */
> > +		smp_mb();
> > +
> > +		spin_lock(&bdi->wb_lock);
> > +		list_add_tail_rcu(&work->list, &bdi->work_list);
> > +		spin_unlock(&bdi->wb_lock);
> > +	}
> > +
> >  	/*
> > -	 * This only happens the first time someone kicks this bdi, so put
> > -	 * it out-of-line.
> > +	 * If the default thread isn't there, make sure we add it. When
> > +	 * it gets created and wakes up, we'll run this work.
> >  	 */
> > -	if (unlikely(!bdi->wb.task))
> > +	if (unlikely(list_empty_careful(&bdi->wb_list)))
> >  		wake_up_process(default_backing_dev_info.wb.task);
> > +	else
> > +		bdi_sched_work(bdi, work);
> > +}
> > +
> > +/*
> > + * Used for on-stack allocated work items. The caller needs to wait until
> > + * the wb threads have acked the work before it's safe to continue.
> > + */
> > +static void bdi_wait_on_work_clear(struct bdi_work *work)
> > +{
> > +	wait_on_bit(&work->state, 0, bdi_sched_wait, TASK_UNINTERRUPTIBLE);
> > +}
>   I still feel the rules for releasing / cleaning up work are too
> complicated.
>   1) I believe we can bear one more "int" for flags in the struct bdi_work
> so that you don't have to hide them in sb_data.

Sure, but there's little reason to do that I think, since it's only used
internally. Let me put it another way, why add an extra int if we can
avoid it?

>   2) I'd introduce a flag with the meaning: free the work when you are
> done. Obviusly this flag makes sence only with dynamically allocated work
> structure. There would be no "on stack" flag.
>   3) I'd create a function:
> bdi_wait_work_submitted()
>   which you'd have to call whenever you didn't set the flag and want to
> free the work (either explicitely, or via returning from a function which
> has the structure on stack).
>   It would do:
> bdi_wait_on_work_clear(work);
> call_rcu(&work->rcu_head, bdi_work_free);
> 
>   wb_work_complete() would just depending on the flag setting either
> completely do away with the work struct or just do bdi_work_clear().
> 
>   IMO that would make the code easier to check and also less prone to
> errors (currently you have to think twice when you have to wait for the rcu
> period, call bdi_work_free, etc.).

Didn't we go over all that last time, too?

-- 
Jens Axboe


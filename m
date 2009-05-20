Return-Path: <linux-kernel-owner+w=401wt.eu-S1759752AbZETLdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752AbZETLdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759588AbZETLcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:32:35 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50494 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759582AbZETLcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:32:33 -0400
Date: Wed, 20 May 2009 13:32:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 02/11] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090520113234.GT11363@kernel.dk>
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com> <1242649192-16263-3-git-send-email-jens.axboe@oracle.com> <20090520111850.GB3760@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520111850.GB3760@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20 2009, Jan Kara wrote:
>   Hi Jens,
> 
>   a few comments here. Mainly, I still don't think the sys_sync() is
> working right - see comments below.

Thanks! I took the liberty of killing some of the code in between, to
make it easier to see.

> > +void bdi_writeback_all(struct super_block *sb, long nr_pages)
> > +{
> > +	struct backing_dev_info *bdi;
> > +
> > +	rcu_read_lock();
> > +
> > +restart:
> > +	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
>   Isn't the RCU list here a bit overengineering? AFAICS we use the list
> only here and if I'm grepping right, generic_sync_sb_inodes() is currently
> only used for data integrity sync (after your patches) from fs-writeback.c
> and by UBIFS to do equivalent of writeback_inodes(). So simple spinlock
> guarding the list should be just fine. Or am I missing something?

Sure, we could. But it's really not that much of a difference,
implementation wise.

> > @@ -591,13 +711,10 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
> >  void generic_sync_sb_inodes(struct super_block *sb,
> >  				struct writeback_control *wbc)
> >  {
> > -	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
> > -	struct backing_dev_info *bdi;
> > -
> > -	rcu_read_lock();
> > -	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list)
> > -		generic_sync_bdi_inodes(bdi, wbc, sb, is_blkdev_sb);
> > -	rcu_read_unlock();
> > +	if (wbc->bdi)
> > +		bdi_start_writeback(wbc->bdi, sb, 0);
> > +	else
> > +		bdi_writeback_all(sb, 0);
>   It does not work like this. The way you call writeback here, you never
> endup calling __writeback_single_inode() with WB_SYNC_ALL set in wbc (your
> writeback routines always call inode writeback with WB_SYNC_NONE). And
> that is required for proper data integrity sync... So you have to somehow
> propagate this down to the writeback thread.

Good point, we need to pass down sync mode too. Not a big problem, we
can just add that to bdi_work as well.

>   Alternatively, what probably makes a lot of sence, is to separate data
> integrity sync path from just data writeback. In the first case we care
> more about correctness, in the second case we care more about performance
> and overall throughput.

Yep agree, that would clean it up as well. I'll include that in the next
revision, I think I'll post it on friday.

>   BTW your patch also significantly changes one thing: With your patch data
> integrity sync is done by flusher threads while previously is was done from
> the context of the thread calling sync(). I'm undecided whether it is a
> good or bad thing but it definitely deserves a comment in the changelog.

I'll look at the implications of this again, perhaps it'll be better to
just switch it back for now.

> > +static int bdi_forker_task(void *ptr)
> > +{
> > +	struct backing_dev_info *bdi, *me = ptr;
> > +
> > +	for (;;) {
> > +		DEFINE_WAIT(wait);
> > +
> > +		/*
> > +		 * Should never trigger on the default bdi
> > +		 */
> > +		WARN_ON(bdi_has_dirty_io(me));
> > +
> > +		prepare_to_wait(&me->wait, &wait, TASK_INTERRUPTIBLE);
> > +		smp_mb();
>   Wouldn't the code look simpler like:
> 	spin_lock_bh(&bdi_lock);
> 	if (list_empty(&bdi_pending_list)) {
> 		spin_unlock_bh(&bdi_lock);
> 		schedule();
> 	} else {
> 		bdi = list_entry(bdi_pending_list.next,
> 				 struct backing_dev_info, bdi_list);
> 		list_del_init(&bdi->bdi_list);
> 		spin_unlock_bh(&bdi_lock);
> 		if (bdi->task)
> 			continue;
> 		... do work ...
> 	}

Not a bad suggestion, I'll fiddle it around a bit.

> 
> > +		if (list_empty(&bdi_pending_list))
> > +			schedule();
> > +		else {
> > +repeat:
> > +			bdi = NULL;
> > +
> > +			spin_lock_bh(&bdi_lock);
> > +			if (!list_empty(&bdi_pending_list)) {
> > +				bdi = list_entry(bdi_pending_list.next,
> > +						 struct backing_dev_info,
> > +						 bdi_list);
> > +				list_del_init(&bdi->bdi_list);
> > +			}
> > +			spin_unlock_bh(&bdi_lock);
> > +
> > +			/*
> > +			 * If no bdi or bdi already got setup, continue
> > +			 */
> > +			if (!bdi || bdi->task)
> > +				continue;
> > +
> > +			bdi->task = kthread_run(bdi_start_fn, bdi, "bdi-%s",
> > +						dev_name(bdi->dev));
> > +			/*
> > +			 * If task creation fails, then readd the bdi to
> > +			 * the pending list and force writeout of the bdi
> > +			 * from this forker thread. That will free some memory
> > +			 * and we can try again.
> > +			 */
> > +			if (!bdi->task) {
> > +				struct writeback_control wbc = {
> > +					.bdi			= bdi,
> > +					.sync_mode		= WB_SYNC_NONE,
> > +					.older_than_this	= NULL,
> > +					.range_cyclic		= 1,
> > +				};
> > +
> > +				/*
> > +				 * Add this 'bdi' to the back, so we get
> > +				 * a chance to flush other bdi's to free
> > +				 * memory.
> > +				 */
> > +				spin_lock_bh(&bdi_lock);
> > +				list_add_tail(&bdi->bdi_list,
> > +						&bdi_pending_list);
> > +				spin_unlock_bh(&bdi_lock);
> > +
> > +				wbc.nr_to_write = 1024;
> > +				generic_sync_bdi_inodes(NULL, &wbc);
> > +				goto repeat;
> > +			}
> > +		}
> > +
> > +		finish_wait(&me->wait, &wait);
> > +	}
> > +
> > +	return 0;

Thanks for your review Jan, always helpful!

-- 
Jens Axboe


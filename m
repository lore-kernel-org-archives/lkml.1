Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbZEYJ61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbZEYJ61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbZEYJ6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:58:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbZEYJ6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:58:16 -0400
Date: Mon, 25 May 2009 11:58:16 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 04/12] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090525095816.GC23546@duck.suse.cz>
References: <1243236887-3931-1-git-send-email-jens.axboe@oracle.com> <1243236887-3931-5-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243236887-3931-5-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Jens,

  I've noticed a few more things:

On Mon 25-05-09 09:34:39, Jens Axboe wrote:
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 1137408..7cb4d02 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -19,6 +19,8 @@
>  #include <linux/sched.h>
>  #include <linux/fs.h>
>  #include <linux/mm.h>
> +#include <linux/kthread.h>
> +#include <linux/freezer.h>
>  #include <linux/writeback.h>
>  #include <linux/blkdev.h>
>  #include <linux/backing-dev.h>
> @@ -61,10 +63,193 @@ int writeback_in_progress(struct backing_dev_info *bdi)
>   */
>  static void writeback_release(struct backing_dev_info *bdi)
>  {
> -	BUG_ON(!writeback_in_progress(bdi));
> +	WARN_ON_ONCE(!writeback_in_progress(bdi));
> +	bdi->wb_arg.nr_pages = 0;
> +	bdi->wb_arg.sb = NULL;
>  	clear_bit(BDI_pdflush, &bdi->state);
>  }
>  
> +int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
> +			 long nr_pages, enum writeback_sync_modes sync_mode)
> +{
> +	/*
> +	 * This only happens the first time someone kicks this bdi, so put
> +	 * it out-of-line.
> +	 */
> +	if (unlikely(!bdi->task)) {
> +		bdi_add_default_flusher_task(bdi);
> +		return 1;
> +	}
> +
> +	if (writeback_acquire(bdi)) {
> +		bdi->wb_arg.nr_pages = nr_pages;
> +		bdi->wb_arg.sb = sb;
> +		bdi->wb_arg.sync_mode = sync_mode;
> +		/*
> +		 * make above store seen before the task is woken
> +		 */
> +		smp_mb();
> +		wake_up(&bdi->wait);
> +	}
  Hmm, wouldn't the interface be more useful if we could just pass down the
whole writeback_control to the flusher threads?
  Maybe a real question is, what should be the role of flusher threads?
Should they be just threads for kupdate / pdflush style writeout or do we
expect them to be used also for other cases when we need to submit IO to
the BDI?

> +
> +	return 0;
> +}
> +
> +/*
> + * The maximum number of pages to writeout in a single bdi flush/kupdate
> + * operation.  We do this so we don't hold I_SYNC against an inode for
> + * enormous amounts of time, which would block a userspace task which has
> + * been forced to throttle against that inode.  Also, the code reevaluates
> + * the dirty each time it has written this many pages.
> + */
> +#define MAX_WRITEBACK_PAGES     1024
> +
> +/*
> + * Periodic writeback of "old" data.
> + *
> + * Define "old": the first time one of an inode's pages is dirtied, we mark the
> + * dirtying-time in the inode's address_space.  So this periodic writeback code
> + * just walks the superblock inode list, writing back any inodes which are
> + * older than a specific point in time.
> + *
> + * Try to run once per dirty_writeback_interval.  But if a writeback event
> + * takes longer than a dirty_writeback_interval interval, then leave a
> + * one-second gap.
> + *
> + * older_than_this takes precedence over nr_to_write.  So we'll only write back
> + * all dirty pages if they are all attached to "old" mappings.
> + */
> +static void bdi_kupdated(struct backing_dev_info *bdi)
> +{
> +	unsigned long oldest_jif;
> +	long nr_to_write;
> +	struct writeback_control wbc = {
> +		.bdi			= bdi,
> +		.sync_mode		= WB_SYNC_NONE,
> +		.older_than_this	= &oldest_jif,
> +		.nr_to_write		= 0,
> +		.for_kupdate		= 1,
> +		.range_cyclic		= 1,
> +	};
> +
> +	sync_supers();
  Hmm, so each BDI flusher thread is going to sync all the superblocks?
Isn't there a better way? I suppose we *should* be able to somehow go
from a BDI to a superblock (or maybe a list of those) so that we can write
per-fs metadata not bound to inodes.

> +
> +	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval * 10);
> +
> +	nr_to_write = global_page_state(NR_FILE_DIRTY) +
> +			global_page_state(NR_UNSTABLE_NFS) +
> +			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
> +
> +	while (nr_to_write > 0) {
> +		wbc.more_io = 0;
> +		wbc.encountered_congestion = 0;
> +		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
> +		generic_sync_bdi_inodes(NULL, &wbc);
> +		if (wbc.nr_to_write > 0)
> +			break;	/* All the old data is written */
> +		nr_to_write -= MAX_WRITEBACK_PAGES;
> +	}
> +}
> +
> +static inline bool over_bground_thresh(void)
> +{
> +	unsigned long background_thresh, dirty_thresh;
> +
> +	get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
> +
> +	return (global_page_state(NR_FILE_DIRTY) +
> +		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
> +}
> +
> +static void bdi_pdflush(struct backing_dev_info *bdi)
> +{
> +	struct writeback_control wbc = {
> +		.bdi			= bdi,
> +		.sync_mode		= bdi->wb_arg.sync_mode,
> +		.older_than_this	= NULL,
> +		.range_cyclic		= 1,
> +	};
> +	long nr_pages = bdi->wb_arg.nr_pages;
> +
> +	for (;;) {
> +		if (wbc.sync_mode == WB_SYNC_NONE && nr_pages <= 0 &&
> +		    !over_bground_thresh())
> +			break;
> +
> +		wbc.more_io = 0;
> +		wbc.encountered_congestion = 0;
> +		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
> +		wbc.pages_skipped = 0;
> +		generic_sync_bdi_inodes(bdi->wb_arg.sb, &wbc);
> +		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> +		/*
> +		 * If we ran out of stuff to write, bail unless more_io got set
> +		 */
> +		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> +			if (wbc.more_io)
> +				continue;
> +			break;
> +		}
> +	}
> +}
> +
> +/*
> + * Handle writeback of dirty data for the device backed by this bdi. Also
> + * wakes up periodically and does kupdated style flushing.
> + */
> +int bdi_writeback_task(struct backing_dev_info *bdi)
> +{
> +	while (!kthread_should_stop()) {
> +		unsigned long wait_jiffies;
> +		DEFINE_WAIT(wait);
> +
> +		prepare_to_wait(&bdi->wait, &wait, TASK_INTERRUPTIBLE);
> +		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
> +		schedule_timeout(wait_jiffies);
> +		try_to_freeze();
> +
> +		/*
> +		 * We get here in two cases:
> +		 *
> +		 *  schedule_timeout() returned because the dirty writeback
> +		 *  interval has elapsed. If that happens, we will be able
> +		 *  to acquire the writeback lock and will proceed to do
> +		 *  kupdated style writeout.
> +		 *
> +		 *  Someone called bdi_start_writeback(), which will acquire
> +		 *  the writeback lock. This means our writeback_acquire()
> +		 *  below will fail and we call into bdi_pdflush() for
> +		 *  pdflush style writeout.
> +		 *
> +		 */
> +		if (writeback_acquire(bdi))
> +			bdi_kupdated(bdi);
> +		else
> +			bdi_pdflush(bdi);
> +
> +		writeback_release(bdi);
> +		finish_wait(&bdi->wait, &wait);
> +	}
  Hmm, what does protect this thread from racing with umount? Note that old
flusher threads took s_umount semaphore and also elevated sb->s_count.
If everything is fine, we should have a comment somewhere around here what
stops umount from removing things under us or why it does not matter...
  Maybe this is the reason of the oopses Yanmin saw.

  BTW, one more difference here: Previously, if pdflush saw congestion on
the device, it did congestion_wait() and retried. Now it end's up waiting
whole dirty_writeback_interval so it should result in a bursty writeback on
a slow disk, couldn't it?

> +
> +	return 0;
> +}
> +
> +void bdi_writeback_all(struct super_block *sb, long nr_pages,
> +		       enum writeback_sync_modes sync_mode)
> +{
> +	struct backing_dev_info *bdi, *tmp;
> +
> +	mutex_lock(&bdi_lock);
> +
> +	list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
> +		if (!bdi_has_dirty_io(bdi))
> +			continue;
> +		bdi_start_writeback(bdi, sb, nr_pages, sync_mode);
> +	}
> +
> +	mutex_unlock(&bdi_lock);
> +}
> +
>  /**
>   *	__mark_inode_dirty -	internal function
>   *	@inode: inode to mark
...
> @@ -591,13 +718,10 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
>  void generic_sync_sb_inodes(struct super_block *sb,
>  				struct writeback_control *wbc)
>  {
> -	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
> -	struct backing_dev_info *bdi;
> -
> -	mutex_lock(&bdi_lock);
> -	list_for_each_entry(bdi, &bdi_list, bdi_list)
> -		generic_sync_bdi_inodes(bdi, wbc, sb, is_blkdev_sb);
> -	mutex_unlock(&bdi_lock);
> +	if (wbc->bdi)
> +		generic_sync_bdi_inodes(sb, wbc);
> +	else
> +		bdi_writeback_all(sb, wbc->nr_to_write, wbc->sync_mode);
  Hmm, you write in the changelog that bdi_writeback_all() writes inline
now but AFAICS it still happens through the writeback threads. Which, on a
second though probably *is* what we want because we want writeback to go in
parallel on all devices we have.

...
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 7c44314..54a4a65 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -36,15 +36,6 @@
>  #include <linux/pagevec.h>
>  
>  /*
> - * The maximum number of pages to writeout in a single bdflush/kupdate
> - * operation.  We do this so we don't hold I_SYNC against an inode for
> - * enormous amounts of time, which would block a userspace task which has
> - * been forced to throttle against that inode.  Also, the code reevaluates
> - * the dirty each time it has written this many pages.
> - */
> -#define MAX_WRITEBACK_PAGES	1024
> -
> -/*
>   * After a CPU has dirtied this many pages, balance_dirty_pages_ratelimited
>   * will look to see if it needs to force writeback or throttling.
>   */
> @@ -117,8 +108,6 @@ EXPORT_SYMBOL(laptop_mode);
>  /* End of sysctl-exported parameters */
>  
>  
> -static void background_writeout(unsigned long _min_pages);
> -
>  /*
>   * Scale the writeback cache size proportional to the relative writeout speeds.
>   *
> @@ -539,7 +528,7 @@ static void balance_dirty_pages(struct address_space *mapping)
>  		 * been flushed to permanent storage.
>  		 */
>  		if (bdi_nr_reclaimable) {
> -			writeback_inodes(&wbc);
> +			generic_sync_bdi_inodes(NULL, &wbc);
>  			pages_written += write_chunk - wbc.nr_to_write;
>  			get_dirty_limits(&background_thresh, &dirty_thresh,
>  				       &bdi_thresh, bdi);
> @@ -590,7 +579,7 @@ static void balance_dirty_pages(struct address_space *mapping)
>  			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
>  					  + global_page_state(NR_UNSTABLE_NFS)
>  					  > background_thresh)))
> -		pdflush_operation(background_writeout, 0);
> +		bdi_start_writeback(bdi, NULL, 0, WB_SYNC_NONE);
>  }
>  
>  void set_page_dirty_balance(struct page *page, int page_mkwrite)
> @@ -675,152 +664,36 @@ void throttle_vm_writeout(gfp_t gfp_mask)
>  }
>  
>  /*
> - * writeback at least _min_pages, and keep writing until the amount of dirty
> - * memory is less than the background threshold, or until we're all clean.
> - */
> -static void background_writeout(unsigned long _min_pages)
> -{
> -	long min_pages = _min_pages;
> -	struct writeback_control wbc = {
> -		.bdi		= NULL,
> -		.sync_mode	= WB_SYNC_NONE,
> -		.older_than_this = NULL,
> -		.nr_to_write	= 0,
> -		.nonblocking	= 1,
> -		.range_cyclic	= 1,
> -	};
> -
> -	for ( ; ; ) {
> -		unsigned long background_thresh;
> -		unsigned long dirty_thresh;
> -
> -		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
> -		if (global_page_state(NR_FILE_DIRTY) +
> -			global_page_state(NR_UNSTABLE_NFS) < background_thresh
> -				&& min_pages <= 0)
> -			break;
> -		wbc.more_io = 0;
> -		wbc.encountered_congestion = 0;
> -		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
> -		wbc.pages_skipped = 0;
> -		writeback_inodes(&wbc);
> -		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> -		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> -			/* Wrote less than expected */
> -			if (wbc.encountered_congestion || wbc.more_io)
> -				congestion_wait(WRITE, HZ/10);
> -			else
> -				break;
> -		}
> -	}
> -}
> -
> -/*
>   * Start writeback of `nr_pages' pages.  If `nr_pages' is zero, write back
>   * the whole world.  Returns 0 if a pdflush thread was dispatched.  Returns
>   * -1 if all pdflush threads were busy.
>   */
> -int wakeup_pdflush(long nr_pages)
> +void wakeup_flusher_threads(long nr_pages)
>  {
>  	if (nr_pages == 0)
>  		nr_pages = global_page_state(NR_FILE_DIRTY) +
>  				global_page_state(NR_UNSTABLE_NFS);
> -	return pdflush_operation(background_writeout, nr_pages);
> +	bdi_writeback_all(NULL, nr_pages, WB_SYNC_NONE);
> +	return;
>  }
...
> -
> -static void laptop_flush(unsigned long unused)
> -{
> -	sys_sync();
> -}
> -
>  static void laptop_timer_fn(unsigned long unused)
>  {
> -	pdflush_operation(laptop_flush, 0);
> +	wakeup_flusher_threads(0);
>  }
>  
>  /*
  Here you significantly change the behavior of laptop mode - previously it
reliably synced all the data to disk once the "laptop writeout timeout"
elapsed. The idea is that we want to write all the dirty data we have so
that the drive can go to sleep for a longer period.
  Now you changed that to asynchronous WB_SYNC_NONE writeback of some
number of pages.  In particular if the disk gets congested, we'll just stop
doing writeback which probably isn't what we want for laptop mode...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

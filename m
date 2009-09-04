Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbZIDKyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbZIDKyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 06:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZIDKyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 06:54:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:37599 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbZIDKyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 06:54:06 -0400
Date: Fri, 4 Sep 2009 12:54:03 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 3/8] writeback: switch to per-bdi threads for flushing
	data
Message-ID: <20090904105403.GD19857@duck.suse.cz>
References: <1252050406-22467-1-git-send-email-jens.axboe@oracle.com> <1252050406-22467-4-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252050406-22467-4-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 04-09-09 09:46:41, Jens Axboe wrote:
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 45ad4bb..93aa9a7 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
...
> +static void wb_start_writeback(struct bdi_writeback *wb, struct bdi_work *work)
> +{
> +	/*
> +	 * If we failed allocating the bdi work item, wake up the wb thread
> +	 * always. As a safety precaution, it'll flush out everything
> +	 */
> +	if (!wb_has_dirty_io(wb) && work)
> +		wb_clear_pending(wb, work);
> +	else if (wb->task)
> +		wake_up_process(wb->task);
> +}
>  
> -		inode->i_state |= flags;
> +static void bdi_sched_work(struct backing_dev_info *bdi, struct bdi_work *work)
> +{
> +	wb_start_writeback(&bdi->wb, work);
> +}
  wb_start_writeback gets called only from bdi_sched_work() that gets
called only from bdi_queue_work(). I think it might be easier to read if we
put everything in bdi_queue_work().
  Also it's not quite clear to me, why wb_start_writeback() wakes up process
even if wb_has_dirty_io() == 0.

> +/*
> + * For WB_SYNC_NONE writeback, the caller does not have the sb pinned
> + * before calling writeback. So make sure that we do pin it, so it doesn't
> + * go away while we are writing inodes from it.
  Maybe add here a comment that the function returns 0 if the sb pinned and
1 if it isn't (which seems slightly counterintuitive to me).

> + */
> +static int pin_sb_for_writeback(struct writeback_control *wbc,
> +				   struct inode *inode)
>  {
> +	struct super_block *sb = inode->i_sb;
> +
> +	/*
> +	 * Caller must already hold the ref for this
> +	 */
> +	if (wbc->sync_mode == WB_SYNC_ALL) {
> +		WARN_ON(!rwsem_is_locked(&sb->s_umount));
> +		return 0;
> +	}
> +
> +	spin_lock(&sb_lock);
> +	sb->s_count++;
> +	if (down_read_trylock(&sb->s_umount)) {
> +		if (sb->s_root) {
> +			spin_unlock(&sb_lock);
> +			return 0;
> +		}
> +		/*
> +		 * umounted, drop rwsem again and fall through to failure
> +		 */
> +		up_read(&sb->s_umount);
> +	}
> +
> +	__put_super_and_need_restart(sb);
  Here, you should be safe to do just sb->s_count-- since you didn't drop
sb_lock in the mean time. Other

> +	spin_unlock(&sb_lock);
> +	return 1;
> +}
> +
> +static void unpin_sb_for_writeback(struct writeback_control *wbc,
> +				   struct inode *inode)
> +{
> +	struct super_block *sb = inode->i_sb;
> +
> +	if (wbc->sync_mode == WB_SYNC_ALL)
> +		return;
> +
> +	up_read(&sb->s_umount);
> +	spin_lock(&sb_lock);
> +	__put_super_and_need_restart(sb);
> +	spin_unlock(&sb_lock);
  Above three lines should be just:
  put_super(sb);

> +}
> +
> +static void writeback_inodes_wb(struct bdi_writeback *wb,
> +				struct writeback_control *wbc)
> +{
> +	struct super_block *sb = wbc->sb;
>  	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
>  	const unsigned long start = jiffies;	/* livelock avoidance */
>  
>  	spin_lock(&inode_lock);
>  
> -	if (!wbc->for_kupdate || list_empty(&bdi->b_io))
> -		queue_io(bdi, wbc->older_than_this);
> +	if (!wbc->for_kupdate || list_empty(&wb->b_io))
> +		queue_io(wb, wbc->older_than_this);
>  
> -	while (!list_empty(&bdi->b_io)) {
> -		struct inode *inode = list_entry(bdi->b_io.prev,
> +	while (!list_empty(&wb->b_io)) {
> +		struct inode *inode = list_entry(wb->b_io.prev,
>  						struct inode, i_list);
>  		long pages_skipped;
>  
> @@ -491,7 +559,7 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
>  			continue;
>  		}
>  
> -		if (!bdi_cap_writeback_dirty(bdi)) {
> +		if (!bdi_cap_writeback_dirty(wb->bdi)) {
>  			redirty_tail(inode);
>  			if (is_blkdev_sb) {
>  				/*
> @@ -513,7 +581,7 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
>  			continue;
>  		}
>  
> -		if (wbc->nonblocking && bdi_write_congested(bdi)) {
> +		if (wbc->nonblocking && bdi_write_congested(wb->bdi)) {
>  			wbc->encountered_congestion = 1;
>  			if (!is_blkdev_sb)
>  				break;		/* Skip a congested fs */
> @@ -521,13 +589,6 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
>  			continue;		/* Skip a congested blockdev */
>  		}
>  
> -		if (wbc->bdi && bdi != wbc->bdi) {
> -			if (!is_blkdev_sb)
> -				break;		/* fs has the wrong queue */
> -			requeue_io(inode);
> -			continue;		/* blockdev has wrong queue */
> -		}
> -
>  		/*
>  		 * Was this inode dirtied after sync_sb_inodes was called?
>  		 * This keeps sync from extra jobs and livelock.
> @@ -535,16 +596,16 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
>  		if (inode_dirtied_after(inode, start))
>  			break;
>  
> -		/* Is another pdflush already flushing this queue? */
> -		if (current_is_pdflush() && !writeback_acquire(bdi))
> -			break;
> +		if (pin_sb_for_writeback(wbc, inode)) {
> +			requeue_io(inode);
> +			continue;
> +		}
>  
>  		BUG_ON(inode->i_state & (I_FREEING | I_CLEAR));
>  		__iget(inode);
>  		pages_skipped = wbc->pages_skipped;
>  		writeback_single_inode(inode, wbc);
> -		if (current_is_pdflush())
> -			writeback_release(bdi);
> +		unpin_sb_for_writeback(wbc, inode);
>  		if (wbc->pages_skipped != pages_skipped) {
>  			/*
>  			 * writeback is not making progress due to locked
  This looks safe now. Good.


>  /*
> - * Write out a superblock's list of dirty inodes.  A wait will be performed
> - * upon no inodes, all inodes or the final one, depending upon sync_mode.
> - *
> - * If older_than_this is non-NULL, then only write out inodes which
> - * had their first dirtying at a time earlier than *older_than_this.
> - *
> - * If we're a pdlfush thread, then implement pdflush collision avoidance
> - * against the entire list.
> + * The maximum number of pages to writeout in a single bdi flush/kupdate
> + * operation.  We do this so we don't hold I_SYNC against an inode for
> + * enormous amounts of time, which would block a userspace task which has
> + * been forced to throttle against that inode.  Also, the code reevaluates
> + * the dirty each time it has written this many pages.
> + */
> +#define MAX_WRITEBACK_PAGES     1024
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
> +/*
> + * Explicit flushing or periodic writeback of "old" data.
>   *
> - * If `bdi' is non-zero then we're being asked to writeback a specific queue.
> - * This function assumes that the blockdev superblock's inodes are backed by
> - * a variety of queues, so all inodes are searched.  For other superblocks,
> - * assume that all inodes are backed by the same queue.
> + * Define "old": the first time one of an inode's pages is dirtied, we mark the
> + * dirtying-time in the inode's address_space.  So this periodic writeback code
> + * just walks the superblock inode list, writing back any inodes which are
> + * older than a specific point in time.
>   *
> - * FIXME: this linear search could get expensive with many fileystems.  But
> - * how to fix?  We need to go from an address_space to all inodes which share
> - * a queue with that address_space.  (Easy: have a global "dirty superblocks"
> - * list).
> + * Try to run once per dirty_writeback_interval.  But if a writeback event
> + * takes longer than a dirty_writeback_interval interval, then leave a
> + * one-second gap.
>   *
> - * The inodes to be written are parked on bdi->b_io.  They are moved back onto
> - * bdi->b_dirty as they are selected for writing.  This way, none can be missed
> - * on the writer throttling path, and we get decent balancing between many
> - * throttled threads: we don't want them all piling up on inode_sync_wait.
> + * older_than_this takes precedence over nr_to_write.  So we'll only write back
> + * all dirty pages if they are all attached to "old" mappings.
>   */
> -static void generic_sync_sb_inodes(struct super_block *sb,
> -				   struct writeback_control *wbc)
> +static long wb_writeback(struct bdi_writeback *wb, long nr_pages,
> +			 struct super_block *sb,
> +			 enum writeback_sync_modes sync_mode, int for_kupdate)
>  {
> -	struct backing_dev_info *bdi;
> +	struct writeback_control wbc = {
> +		.bdi			= wb->bdi,
> +		.sb			= sb,
> +		.sync_mode		= sync_mode,
> +		.older_than_this	= NULL,
> +		.for_kupdate		= for_kupdate,
> +		.range_cyclic		= 1,
> +	};
> +	unsigned long oldest_jif;
> +	long wrote = 0;
>  
> -	if (!wbc->bdi) {
> -		mutex_lock(&bdi_lock);
> -		list_for_each_entry(bdi, &bdi_list, bdi_list)
> -			generic_sync_bdi_inodes(bdi, wbc, sb);
> -		mutex_unlock(&bdi_lock);
> -	} else
> -		generic_sync_bdi_inodes(wbc->bdi, wbc, sb);
> +	if (wbc.for_kupdate) {
> +		wbc.older_than_this = &oldest_jif;
> +		oldest_jif = jiffies -
> +				msecs_to_jiffies(dirty_expire_interval * 10);
> +	}
>  
> -	if (wbc->sync_mode == WB_SYNC_ALL) {
> -		struct inode *inode, *old_inode = NULL;
> +	for (;;) {
> +		if (sync_mode == WB_SYNC_NONE && nr_pages <= 0 &&
> +		    !over_bground_thresh())
> +			break;
  I don't understand this - why should this function care about
over_bground_thresh? As I understand it, it should just do what it was
told. For example when someone asks to write-out 20 pages from some
superblock, we may effectively end up writing everyting from the superblock
if the system happens to have another superblock with more than
background_thresh of dirty pages...
  I guess you try to join pdflush-like and kupdate-like writeback here.
Then you might want to have conditions like
if (!for_kupdate && nr_pages <= 0 && sync_mode == WB_SYNC_NONE)
	break;
if (for_kupdate && nr_pages <= 0 && !over_bground_thresh())
	break;

> -		spin_lock(&inode_lock);
> +		wbc.more_io = 0;
> +		wbc.encountered_congestion = 0;
> +		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
> +		wbc.pages_skipped = 0;
> +		writeback_inodes_wb(wb, &wbc);
> +		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> +		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
>  
>  		/*
> -		 * Data integrity sync. Must wait for all pages under writeback,
> -		 * because there may have been pages dirtied before our sync
> -		 * call, but which had writeout started before we write it out.
> -		 * In which case, the inode may not be on the dirty list, but
> -		 * we still have to wait for that writeout.
> +		 * If we ran out of stuff to write, bail unless more_io got set
>  		 */
> -		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> -			struct address_space *mapping;
> -
> -			if (inode->i_state &
> -					(I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
> -				continue;
> -			mapping = inode->i_mapping;
> -			if (mapping->nrpages == 0)
> +		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> +			if (wbc.more_io && !wbc.for_kupdate)
>  				continue;
> -			__iget(inode);
> -			spin_unlock(&inode_lock);
> +			break;
> +		}
> +	}
> +
> +	return wrote;
> +}
> +
> +/*
> + * Retrieve work items and do the writeback they describe
> + */
> +long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
  Why is here force_wait parameter? I don't see it being set anywhere...

> +{
> +	struct backing_dev_info *bdi = wb->bdi;
> +	struct bdi_work *work;
> +	long nr_pages, wrote = 0;
> +
> +	while ((work = get_next_work_item(bdi, wb)) != NULL) {
> +		enum writeback_sync_modes sync_mode;
> +
> +		nr_pages = work->nr_pages;
> +
> +		/*
> +		 * Override sync mode, in case we must wait for completion
> +		 */
> +		if (force_wait)
> +			work->sync_mode = sync_mode = WB_SYNC_ALL;
> +		else
> +			sync_mode = work->sync_mode;
> +
> +		/*
> +		 * If this isn't a data integrity operation, just notify
> +		 * that we have seen this work and we are now starting it.
> +		 */
> +		if (sync_mode == WB_SYNC_NONE)
> +			wb_clear_pending(wb, work);
> +
> +		wrote += wb_writeback(wb, nr_pages, work->sb, sync_mode, 0);
> +
> +		/*
> +		 * This is a data integrity writeback, so only do the
> +		 * notification when we have completed the work.
> +		 */
> +		if (sync_mode == WB_SYNC_ALL)
> +			wb_clear_pending(wb, work);
> +	}
> +
> +	/*
> +	 * Check for periodic writeback, kupdated() style
> +	 */
> +	if (!wrote) {
  Hmm, but who guarantees that old inodes get flushed from dirty list
when someone just periodically submits some work? And similarly who
guarantees we drop below background threshold? I think the logic
here needs some rethinking...

> +		nr_pages = global_page_state(NR_FILE_DIRTY) +
> +				global_page_state(NR_UNSTABLE_NFS) +
> +				(inodes_stat.nr_inodes - inodes_stat.nr_unused);
> +
> +		wrote = wb_writeback(wb, nr_pages, NULL, WB_SYNC_NONE, 1);
> +	}
> +
> +	return wrote;
> +}
> +
> +/*
> + * Handle writeback of dirty data for the device backed by this bdi. Also
> + * wakes up periodically and does kupdated style flushing.
> + */
> +int bdi_writeback_task(struct bdi_writeback *wb)
> +{
> +	unsigned long last_active = jiffies;
> +	unsigned long wait_jiffies = -1UL;
> +	long pages_written;
> +
> +	while (!kthread_should_stop()) {
> +		pages_written = wb_do_writeback(wb, 0);
> +
> +		if (pages_written)
> +			last_active = jiffies;
> +		else if (wait_jiffies != -1UL) {
> +			unsigned long max_idle;
> +
>  			/*
> -			 * We hold a reference to 'inode' so it couldn't have
> -			 * been removed from s_inodes list while we dropped the
> -			 * inode_lock.  We cannot iput the inode now as we can
> -			 * be holding the last reference and we cannot iput it
> -			 * under inode_lock. So we keep the reference and iput
> -			 * it later.
> +			 * Longest period of inactivity that we tolerate. If we
> +			 * see dirty data again later, the task will get
> +			 * recreated automatically.
>  			 */
> -			iput(old_inode);
> -			old_inode = inode;
> +			max_idle = max(5UL * 60 * HZ, wait_jiffies);
> +			if (time_after(jiffies, max_idle + last_active))
> +				break;
> +		}
> +
> +		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule_timeout(wait_jiffies);
> +		try_to_freeze();
> +	}
>  
> -			filemap_fdatawait(mapping);
> +	return 0;
> +}
>  
> -			cond_resched();
> +/*
> + * Schedule writeback for all backing devices. Expensive! If this is a data
> + * integrity operation, writeback will be complete when this returns. If
> + * we are simply called for WB_SYNC_NONE, then writeback will merely be
> + * scheduled to run.
> + */
> +static void bdi_writeback_all(struct writeback_control *wbc)
> +{
> +	const bool must_wait = wbc->sync_mode == WB_SYNC_ALL;
> +	struct backing_dev_info *bdi;
> +	struct bdi_work *work;
> +	LIST_HEAD(list);
> +
> +restart:
> +	spin_lock(&bdi_lock);
> +
> +	list_for_each_entry(bdi, &bdi_list, bdi_list) {
> +		struct bdi_work *work;
> +
> +		if (!bdi_has_dirty_io(bdi))
> +			continue;
>  
> -			spin_lock(&inode_lock);
> +		/*
> +		 * If work allocation fails, do the writes inline. We drop
> +		 * the lock and restart the list writeout. This should be OK,
> +		 * since this happens rarely and because the writeout should
> +		 * eventually make more free memory available.
> +		 */
> +		work = bdi_alloc_work(wbc);
> +		if (!work) {
> +			struct writeback_control __wbc = *wbc;
> +
> +			/*
> +			 * Not a data integrity writeout, just continue
> +			 */
> +			if (!must_wait)
> +				continue;
> +
> +			spin_unlock(&bdi_lock);
> +			__wbc = *wbc;
> +			__wbc.bdi = bdi;
> +			writeback_inodes_wbc(&__wbc);
> +			goto restart;
>  		}
> -		spin_unlock(&inode_lock);
> -		iput(old_inode);
> +		if (must_wait)
> +			list_add_tail(&work->wait_list, &list);
> +
> +		bdi_queue_work(bdi, work);
> +	}
> +
> +	spin_unlock(&bdi_lock);
> +
> +	/*
> +	 * If this is for WB_SYNC_ALL, wait for pending work to complete
> +	 * before returning.
> +	 */
> +	while (!list_empty(&list)) {
> +		work = list_entry(list.next, struct bdi_work, wait_list);
> +		list_del(&work->wait_list);
> +		bdi_wait_on_work_clear(work);
> +		call_rcu(&work->rcu_head, bdi_work_free);
>  	}
>  }
...
> @@ -715,6 +1112,7 @@ restart:
>  long writeback_inodes_sb(struct super_block *sb)
>  {
>  	struct writeback_control wbc = {
> +		.sb		= sb,
>  		.sync_mode	= WB_SYNC_NONE,
>  		.range_start	= 0,
>  		.range_end	= LLONG_MAX,
> @@ -727,7 +1125,7 @@ long writeback_inodes_sb(struct super_block *sb)
>  			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
>  
>  	wbc.nr_to_write = nr_to_write;
> -	generic_sync_sb_inodes(sb, &wbc);
> +	bdi_writeback_all(&wbc);
>  	return nr_to_write - wbc.nr_to_write;
>  }
>  EXPORT_SYMBOL(writeback_inodes_sb);
> @@ -742,6 +1140,7 @@ EXPORT_SYMBOL(writeback_inodes_sb);
>  long sync_inodes_sb(struct super_block *sb)
>  {
>  	struct writeback_control wbc = {
> +		.sb		= sb,
>  		.sync_mode	= WB_SYNC_ALL,
>  		.range_start	= 0,
>  		.range_end	= LLONG_MAX,
> @@ -749,7 +1148,8 @@ long sync_inodes_sb(struct super_block *sb)
>  	long nr_to_write = LONG_MAX; /* doesn't actually matter */
>  
>  	wbc.nr_to_write = nr_to_write;
> -	generic_sync_sb_inodes(sb, &wbc);
> +	bdi_writeback_all(&wbc);
> +	wait_sb_inodes(&wbc);
>  	return nr_to_write - wbc.nr_to_write;
>  }
>  EXPORT_SYMBOL(sync_inodes_sb);
  So to writeback or sync inodes in a single superblock, you effectively
scan all the dirty inodes in the system just to find out which ones are on
your superblock? I don't think that's very efficient.

> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index 928cd54..ac1d2ba 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
...
> +#define BDI_MAX_FLUSHERS	32
> +
  This isn't used anywhere...

> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index f8341b6..2c287d9 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
...
> @@ -593,8 +582,15 @@ static void balance_dirty_pages(struct address_space *mapping)
>  	if ((laptop_mode && pages_written) ||
>  			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
>  					  + global_page_state(NR_UNSTABLE_NFS)
> -					  > background_thresh)))
> -		pdflush_operation(background_writeout, 0);
> +					  > background_thresh))) {
> +		struct writeback_control wbc = {
> +			.bdi		= bdi,
> +			.sync_mode	= WB_SYNC_NONE,
> +		};
  Shouldn't we set nr_pages here? I see that with your old code it wasn't
needed because of that over_bground check but that will probably get
changed.

> +
> +
> +		bdi_start_writeback(&wbc);
> +	}
>  }
>  

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

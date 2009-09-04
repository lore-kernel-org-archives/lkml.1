Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZIDL7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZIDL7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 07:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZIDL65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 07:58:57 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51938 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319AbZIDL64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 07:58:56 -0400
Date: Fri, 4 Sep 2009 13:58:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] writeback: switch to per-bdi threads for flushing
	data
Message-ID: <20090904115858.GT18599@kernel.dk>
References: <1252050406-22467-1-git-send-email-jens.axboe@oracle.com> <1252050406-22467-4-git-send-email-jens.axboe@oracle.com> <20090904105403.GD19857@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904105403.GD19857@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04 2009, Jan Kara wrote:
> On Fri 04-09-09 09:46:41, Jens Axboe wrote:
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 45ad4bb..93aa9a7 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> ...
> > +static void wb_start_writeback(struct bdi_writeback *wb, struct bdi_work *work)
> > +{
> > +	/*
> > +	 * If we failed allocating the bdi work item, wake up the wb thread
> > +	 * always. As a safety precaution, it'll flush out everything
> > +	 */
> > +	if (!wb_has_dirty_io(wb) && work)
> > +		wb_clear_pending(wb, work);
> > +	else if (wb->task)
> > +		wake_up_process(wb->task);
> > +}
> >  
> > -		inode->i_state |= flags;
> > +static void bdi_sched_work(struct backing_dev_info *bdi, struct bdi_work *work)
> > +{
> > +	wb_start_writeback(&bdi->wb, work);
> > +}
>   wb_start_writeback gets called only from bdi_sched_work() that gets
> called only from bdi_queue_work(). I think it might be easier to read if we
> put everything in bdi_queue_work().
>   Also it's not quite clear to me, why wb_start_writeback() wakes up process
> even if wb_has_dirty_io() == 0.

Indeed, mostly left-overs from the more complicated multi thread
support. I folded everything into bdi_queue_work() now.

Not sure why the wakeup statement looks as odd as it does, I changed it
as below now:

        if (!wb_has_dirty_io(wb)) {
                if (work)
                        wb_clear_pending(wb, work);
        } else if (wb->task)
                wake_up_process(wb->task);

so that we only wake the thread if it has dirty IO.

> > +/*
> > + * For WB_SYNC_NONE writeback, the caller does not have the sb pinned
> > + * before calling writeback. So make sure that we do pin it, so it doesn't
> > + * go away while we are writing inodes from it.
>   Maybe add here a comment that the function returns 0 if the sb pinned and
> 1 if it isn't (which seems slightly counterintuitive to me).

0 on success is the usual calling convention, so I think that is fine. I
have added a comment about the return value.

> > + */
> > +static int pin_sb_for_writeback(struct writeback_control *wbc,
> > +				   struct inode *inode)
> >  {
> > +	struct super_block *sb = inode->i_sb;
> > +
> > +	/*
> > +	 * Caller must already hold the ref for this
> > +	 */
> > +	if (wbc->sync_mode == WB_SYNC_ALL) {
> > +		WARN_ON(!rwsem_is_locked(&sb->s_umount));
> > +		return 0;
> > +	}
> > +
> > +	spin_lock(&sb_lock);
> > +	sb->s_count++;
> > +	if (down_read_trylock(&sb->s_umount)) {
> > +		if (sb->s_root) {
> > +			spin_unlock(&sb_lock);
> > +			return 0;
> > +		}
> > +		/*
> > +		 * umounted, drop rwsem again and fall through to failure
> > +		 */
> > +		up_read(&sb->s_umount);
> > +	}
> > +
> > +	__put_super_and_need_restart(sb);
>   Here, you should be safe to do just sb->s_count-- since you didn't drop
> sb_lock in the mean time. Other

Indeed, thanks!

> > +	spin_unlock(&sb_lock);
> > +	return 1;
> > +}
> > +
> > +static void unpin_sb_for_writeback(struct writeback_control *wbc,
> > +				   struct inode *inode)
> > +{
> > +	struct super_block *sb = inode->i_sb;
> > +
> > +	if (wbc->sync_mode == WB_SYNC_ALL)
> > +		return;
> > +
> > +	up_read(&sb->s_umount);
> > +	spin_lock(&sb_lock);
> > +	__put_super_and_need_restart(sb);
> > +	spin_unlock(&sb_lock);
>   Above three lines should be just:
>   put_super(sb);

Just trying to avoid making put_super() non-static, but I've made that
change now too.

> > @@ -535,16 +596,16 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
> >  		if (inode_dirtied_after(inode, start))
> >  			break;
> >  
> > -		/* Is another pdflush already flushing this queue? */
> > -		if (current_is_pdflush() && !writeback_acquire(bdi))
> > -			break;
> > +		if (pin_sb_for_writeback(wbc, inode)) {
> > +			requeue_io(inode);
> > +			continue;
> > +		}
> >  
> >  		BUG_ON(inode->i_state & (I_FREEING | I_CLEAR));
> >  		__iget(inode);
> >  		pages_skipped = wbc->pages_skipped;
> >  		writeback_single_inode(inode, wbc);
> > -		if (current_is_pdflush())
> > -			writeback_release(bdi);
> > +		unpin_sb_for_writeback(wbc, inode);
> >  		if (wbc->pages_skipped != pages_skipped) {
> >  			/*
> >  			 * writeback is not making progress due to locked
>   This looks safe now. Good.

I'm relieved you're happy with that now, thanks! :-)

> >  /*
> > - * Write out a superblock's list of dirty inodes.  A wait will be performed
> > - * upon no inodes, all inodes or the final one, depending upon sync_mode.
> > - *
> > - * If older_than_this is non-NULL, then only write out inodes which
> > - * had their first dirtying at a time earlier than *older_than_this.
> > - *
> > - * If we're a pdlfush thread, then implement pdflush collision avoidance
> > - * against the entire list.
> > + * The maximum number of pages to writeout in a single bdi flush/kupdate
> > + * operation.  We do this so we don't hold I_SYNC against an inode for
> > + * enormous amounts of time, which would block a userspace task which has
> > + * been forced to throttle against that inode.  Also, the code reevaluates
> > + * the dirty each time it has written this many pages.
> > + */
> > +#define MAX_WRITEBACK_PAGES     1024
> > +
> > +static inline bool over_bground_thresh(void)
> > +{
> > +	unsigned long background_thresh, dirty_thresh;
> > +
> > +	get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
> > +
> > +	return (global_page_state(NR_FILE_DIRTY) +
> > +		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
> > +}
> > +
> > +/*
> > + * Explicit flushing or periodic writeback of "old" data.
> >   *
> > - * If `bdi' is non-zero then we're being asked to writeback a specific queue.
> > - * This function assumes that the blockdev superblock's inodes are backed by
> > - * a variety of queues, so all inodes are searched.  For other superblocks,
> > - * assume that all inodes are backed by the same queue.
> > + * Define "old": the first time one of an inode's pages is dirtied, we mark the
> > + * dirtying-time in the inode's address_space.  So this periodic writeback code
> > + * just walks the superblock inode list, writing back any inodes which are
> > + * older than a specific point in time.
> >   *
> > - * FIXME: this linear search could get expensive with many fileystems.  But
> > - * how to fix?  We need to go from an address_space to all inodes which share
> > - * a queue with that address_space.  (Easy: have a global "dirty superblocks"
> > - * list).
> > + * Try to run once per dirty_writeback_interval.  But if a writeback event
> > + * takes longer than a dirty_writeback_interval interval, then leave a
> > + * one-second gap.
> >   *
> > - * The inodes to be written are parked on bdi->b_io.  They are moved back onto
> > - * bdi->b_dirty as they are selected for writing.  This way, none can be missed
> > - * on the writer throttling path, and we get decent balancing between many
> > - * throttled threads: we don't want them all piling up on inode_sync_wait.
> > + * older_than_this takes precedence over nr_to_write.  So we'll only write back
> > + * all dirty pages if they are all attached to "old" mappings.
> >   */
> > -static void generic_sync_sb_inodes(struct super_block *sb,
> > -				   struct writeback_control *wbc)
> > +static long wb_writeback(struct bdi_writeback *wb, long nr_pages,
> > +			 struct super_block *sb,
> > +			 enum writeback_sync_modes sync_mode, int for_kupdate)
> >  {
> > -	struct backing_dev_info *bdi;
> > +	struct writeback_control wbc = {
> > +		.bdi			= wb->bdi,
> > +		.sb			= sb,
> > +		.sync_mode		= sync_mode,
> > +		.older_than_this	= NULL,
> > +		.for_kupdate		= for_kupdate,
> > +		.range_cyclic		= 1,
> > +	};
> > +	unsigned long oldest_jif;
> > +	long wrote = 0;
> >  
> > -	if (!wbc->bdi) {
> > -		mutex_lock(&bdi_lock);
> > -		list_for_each_entry(bdi, &bdi_list, bdi_list)
> > -			generic_sync_bdi_inodes(bdi, wbc, sb);
> > -		mutex_unlock(&bdi_lock);
> > -	} else
> > -		generic_sync_bdi_inodes(wbc->bdi, wbc, sb);
> > +	if (wbc.for_kupdate) {
> > +		wbc.older_than_this = &oldest_jif;
> > +		oldest_jif = jiffies -
> > +				msecs_to_jiffies(dirty_expire_interval * 10);
> > +	}
> >  
> > -	if (wbc->sync_mode == WB_SYNC_ALL) {
> > -		struct inode *inode, *old_inode = NULL;
> > +	for (;;) {
> > +		if (sync_mode == WB_SYNC_NONE && nr_pages <= 0 &&
> > +		    !over_bground_thresh())
> > +			break;
>   I don't understand this - why should this function care about
> over_bground_thresh? As I understand it, it should just do what it was
> told. For example when someone asks to write-out 20 pages from some
> superblock, we may effectively end up writing everyting from the superblock
> if the system happens to have another superblock with more than
> background_thresh of dirty pages...
>   I guess you try to join pdflush-like and kupdate-like writeback here.
> Then you might want to have conditions like
> if (!for_kupdate && nr_pages <= 0 && sync_mode == WB_SYNC_NONE)
> 	break;
> if (for_kupdate && nr_pages <= 0 && !over_bground_thresh())
> 	break;

Good spotting, yes that looks correct!

> 
> > -		spin_lock(&inode_lock);
> > +		wbc.more_io = 0;
> > +		wbc.encountered_congestion = 0;
> > +		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
> > +		wbc.pages_skipped = 0;
> > +		writeback_inodes_wb(wb, &wbc);
> > +		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> > +		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> >  
> >  		/*
> > -		 * Data integrity sync. Must wait for all pages under writeback,
> > -		 * because there may have been pages dirtied before our sync
> > -		 * call, but which had writeout started before we write it out.
> > -		 * In which case, the inode may not be on the dirty list, but
> > -		 * we still have to wait for that writeout.
> > +		 * If we ran out of stuff to write, bail unless more_io got set
> >  		 */
> > -		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> > -			struct address_space *mapping;
> > -
> > -			if (inode->i_state &
> > -					(I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
> > -				continue;
> > -			mapping = inode->i_mapping;
> > -			if (mapping->nrpages == 0)
> > +		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> > +			if (wbc.more_io && !wbc.for_kupdate)
> >  				continue;
> > -			__iget(inode);
> > -			spin_unlock(&inode_lock);
> > +			break;
> > +		}
> > +	}
> > +
> > +	return wrote;
> > +}
> > +
> > +/*
> > + * Retrieve work items and do the writeback they describe
> > + */
> > +long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
>   Why is here force_wait parameter? I don't see it being set anywhere...

It's used on thread exit, to ensure that we flush and wait any pending
IO before exiting the thread.

> > +{
> > +	struct backing_dev_info *bdi = wb->bdi;
> > +	struct bdi_work *work;
> > +	long nr_pages, wrote = 0;
> > +
> > +	while ((work = get_next_work_item(bdi, wb)) != NULL) {
> > +		enum writeback_sync_modes sync_mode;
> > +
> > +		nr_pages = work->nr_pages;
> > +
> > +		/*
> > +		 * Override sync mode, in case we must wait for completion
> > +		 */
> > +		if (force_wait)
> > +			work->sync_mode = sync_mode = WB_SYNC_ALL;
> > +		else
> > +			sync_mode = work->sync_mode;
> > +
> > +		/*
> > +		 * If this isn't a data integrity operation, just notify
> > +		 * that we have seen this work and we are now starting it.
> > +		 */
> > +		if (sync_mode == WB_SYNC_NONE)
> > +			wb_clear_pending(wb, work);
> > +
> > +		wrote += wb_writeback(wb, nr_pages, work->sb, sync_mode, 0);
> > +
> > +		/*
> > +		 * This is a data integrity writeback, so only do the
> > +		 * notification when we have completed the work.
> > +		 */
> > +		if (sync_mode == WB_SYNC_ALL)
> > +			wb_clear_pending(wb, work);
> > +	}
> > +
> > +	/*
> > +	 * Check for periodic writeback, kupdated() style
> > +	 */
> > +	if (!wrote) {
>   Hmm, but who guarantees that old inodes get flushed from dirty list
> when someone just periodically submits some work? And similarly who
> guarantees we drop below background threshold? I think the logic
> here needs some rethinking...

Good point, I guess it is possible to get into a situation where it
periodically does explicit work and thus never seems idle enough to
flush old data. I'll add a check for 'last periodic old sync' for that.

> > @@ -749,7 +1148,8 @@ long sync_inodes_sb(struct super_block *sb)
> >  	long nr_to_write = LONG_MAX; /* doesn't actually matter */
> >  
> >  	wbc.nr_to_write = nr_to_write;
> > -	generic_sync_sb_inodes(sb, &wbc);
> > +	bdi_writeback_all(&wbc);
> > +	wait_sb_inodes(&wbc);
> >  	return nr_to_write - wbc.nr_to_write;
> >  }
> >  EXPORT_SYMBOL(sync_inodes_sb);
>   So to writeback or sync inodes in a single superblock, you effectively
> scan all the dirty inodes in the system just to find out which ones are on
> your superblock? I don't think that's very efficient.

Yes I know, I'll provide some lookup functionality for that.

> > diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> > index 928cd54..ac1d2ba 100644
> > --- a/include/linux/backing-dev.h
> > +++ b/include/linux/backing-dev.h
> ...
> > +#define BDI_MAX_FLUSHERS	32
> > +
>   This isn't used anywhere...

Good catch, leftover as well. Killed.

> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index f8341b6..2c287d9 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> ...
> > @@ -593,8 +582,15 @@ static void balance_dirty_pages(struct address_space *mapping)
> >  	if ((laptop_mode && pages_written) ||
> >  			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
> >  					  + global_page_state(NR_UNSTABLE_NFS)
> > -					  > background_thresh)))
> > -		pdflush_operation(background_writeout, 0);
> > +					  > background_thresh))) {
> > +		struct writeback_control wbc = {
> > +			.bdi		= bdi,
> > +			.sync_mode	= WB_SYNC_NONE,
> > +		};
>   Shouldn't we set nr_pages here? I see that with your old code it wasn't
> needed because of that over_bground check but that will probably get
> changed.

Sure, we may as well set it explicitly to the total dirty count.

Thanks for your review Jan, I'll post a new round shortly...

-- 
Jens Axboe


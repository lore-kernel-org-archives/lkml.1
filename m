Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbZCaQvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbZCaQvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbZCaQup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:50:45 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48892 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961AbZCaQun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:50:43 -0400
Date: Tue, 31 Mar 2009 18:50:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de,
       hch@infradead.org, akpm@linux-foundation.org
Subject: Re: [PATCH 05/12] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090331165040.GR5178@kernel.dk>
References: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com> <1237749964-8343-6-git-send-email-jens.axboe@oracle.com> <20090331141140.GH20127@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331141140.GH20127@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31 2009, Jan Kara wrote:
> > This gets rid of pdflush for bdi writeout and kupdated style cleaning.
> > This is an experiment to see if we get better writeout behaviour with
> > per-bdi flushing. Some initial tests look pretty encouraging. A sample
> > ffsb workload that does random writes to files is about 8% faster here
> > on a simple SATA drive during the benchmark phase. File layout also seems
> > a LOT more smooth in vmstat:
> > 
> >  r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
> >  0  1      0 608848   2652 375372    0    0     0 71024  604    24  1 10 48 42
> >  0  1      0 549644   2712 433736    0    0     0 60692  505    27  1  8 48 44
> >  1  0      0 476928   2784 505192    0    0     4 29540  553    24  0  9 53 37
> >  0  1      0 457972   2808 524008    0    0     0 54876  331    16  0  4 38 58
> >  0  1      0 366128   2928 614284    0    0     4 92168  710    58  0 13 53 34
> >  0  1      0 295092   3000 684140    0    0     0 62924  572    23  0  9 53 37
> >  0  1      0 236592   3064 741704    0    0     4 58256  523    17  0  8 48 44
> >  0  1      0 165608   3132 811464    0    0     0 57460  560    21  0  8 54 38
> >  0  1      0 102952   3200 873164    0    0     4 74748  540    29  1 10 48 41
> >  0  1      0  48604   3252 926472    0    0     0 53248  469    29  0  7 47 45
> > 
> > where vanilla tends to fluctuate a lot in the creation phase:
> > 
> >  r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
> >  1  1      0 678716   5792 303380    0    0     0 74064  565    50  1 11 52 36
> >  1  0      0 662488   5864 319396    0    0     4   352  302   329  0  2 47 51
> >  0  1      0 599312   5924 381468    0    0     0 78164  516    55  0  9 51 40
> >  0  1      0 519952   6008 459516    0    0     4 78156  622    56  1 11 52 37
> >  1  1      0 436640   6092 541632    0    0     0 82244  622    54  0 11 48 41
> >  0  1      0 436640   6092 541660    0    0     0     8  152    39  0  0 51 49
> >  0  1      0 332224   6200 644252    0    0     4 102800  728    46  1 13 49 36
> >  1  0      0 274492   6260 701056    0    0     4 12328  459    49  0  7 50 43
> >  0  1      0 211220   6324 763356    0    0     0 106940  515    37  1 10 51 39
> >  1  0      0 160412   6376 813468    0    0     0  8224  415    43  0  6 49 45
> >  1  1      0  85980   6452 886556    0    0     4 113516  575    39  1 11 54 34
> >  0  2      0  85968   6452 886620    0    0     0  1640  158   211  0  0 46 54
> > 
> > So apart from seemingly behaving better for buffered writeout, this also
> > allows us to potentially have more than one bdi thread flushing out data.
> > This may be useful for NUMA type setups.
> > 
> > A 10 disk test with btrfs performs 26% faster with per-bdi flushing. Other
> > tests pending.
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>   Two comments below...
> 
>   <snip>
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 45d2739..21de5ac 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -19,6 +19,8 @@
> >  #include <linux/sched.h>
> >  #include <linux/fs.h>
> >  #include <linux/mm.h>
> > +#include <linux/kthread.h>
> > +#include <linux/freezer.h>
> >  #include <linux/writeback.h>
> >  #include <linux/blkdev.h>
> >  #include <linux/backing-dev.h>
> > @@ -61,10 +63,180 @@ int writeback_in_progress(struct backing_dev_info *bdi)
> >   */
> >  static void writeback_release(struct backing_dev_info *bdi)
> >  {
> > -	BUG_ON(!writeback_in_progress(bdi));
> > +	WARN_ON_ONCE(!writeback_in_progress(bdi));
> > +	bdi->wb_arg.nr_pages = 0;
> > +	bdi->wb_arg.sb = NULL;
> >  	clear_bit(BDI_pdflush, &bdi->state);
> >  }
> >  
> > +int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
> > +			 long nr_pages)
> > +{
> > +	/*
> > +	 * This only happens the first time someone kicks this bdi, so put
> > +	 * it out-of-line.
> > +	 */
> > +	if (unlikely(!bdi->task)) {
> > +		bdi_add_flusher_task(bdi);
> > +		return 1;
> > +	}
> > +
> > +	if (writeback_acquire(bdi)) {
> > +		bdi->wb_arg.nr_pages = nr_pages;
> > +		bdi->wb_arg.sb = sb;
> > +		/*
> > +		 * make above store seen before the task is woken
> > +		 */
> > +		smp_mb();
> > +		wake_up(&bdi->wait);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * The maximum number of pages to writeout in a single bdi flush/kupdate
> > + * operation.  We do this so we don't hold I_SYNC against an inode for
> > + * enormous amounts of time, which would block a userspace task which has
> > + * been forced to throttle against that inode.  Also, the code reevaluates
> > + * the dirty each time it has written this many pages.
> > + */
> > +#define MAX_WRITEBACK_PAGES     1024
> > +
> > +/*
> > + * Periodic writeback of "old" data.
> > + *
> > + * Define "old": the first time one of an inode's pages is dirtied, we mark the
> > + * dirtying-time in the inode's address_space.  So this periodic writeback code
> > + * just walks the superblock inode list, writing back any inodes which are
> > + * older than a specific point in time.
> > + *
> > + * Try to run once per dirty_writeback_interval.  But if a writeback event
> > + * takes longer than a dirty_writeback_interval interval, then leave a
> > + * one-second gap.
> > + *
> > + * older_than_this takes precedence over nr_to_write.  So we'll only write back
> > + * all dirty pages if they are all attached to "old" mappings.
> > + */
> > +static void bdi_kupdated(struct backing_dev_info *bdi)
> > +{
> > +	long nr_to_write;
> > +	struct writeback_control wbc = {
> > +		.bdi		= bdi,
> > +		.sync_mode	= WB_SYNC_NONE,
> > +		.nr_to_write	= 0,
> > +		.for_kupdate	= 1,
> > +		.range_cyclic	= 1,
> > +	};
> > +
> > +	sync_supers();
> > +
> > +	nr_to_write = global_page_state(NR_FILE_DIRTY) +
> > +			global_page_state(NR_UNSTABLE_NFS) +
> > +			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
> > +
> > +	while (nr_to_write > 0) {
> > +		wbc.more_io = 0;
> > +		wbc.encountered_congestion = 0;
> > +		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
> > +		generic_sync_bdi_inodes(NULL, &wbc);
> > +		if (wbc.nr_to_write > 0)
> > +			break;	/* All the old data is written */
> > +		nr_to_write -= MAX_WRITEBACK_PAGES;
> > +	}
> > +}
> > +
> > +static void bdi_pdflush(struct backing_dev_info *bdi)
> > +{
> > +	struct writeback_control wbc = {
> > +		.bdi			= bdi,
> > +		.sync_mode		= WB_SYNC_NONE,
> > +		.older_than_this	= NULL,
> > +		.range_cyclic		= 1,
> > +	};
> > +	long nr_pages = bdi->wb_arg.nr_pages;
> > +
> > +	for (;;) {
> > +		unsigned long background_thresh, dirty_thresh;
> > +		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
> > +		if ((global_page_state(NR_FILE_DIRTY) +
> > +		    global_page_state(NR_UNSTABLE_NFS) < background_thresh) &&
> > +		    nr_pages <= 0)
> > +			break;
> > +
> > +		wbc.more_io = 0;
> > +		wbc.encountered_congestion = 0;
> > +		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
> > +		wbc.pages_skipped = 0;
> > +		generic_sync_bdi_inodes(bdi->wb_arg.sb, &wbc);
> > +		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> > +		/*
> > +		 * If we ran out of stuff to write, bail unless more_io got set
> > +		 */
> > +		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> > +			if (wbc.more_io)
> > +				continue;
> > +			break;
> > +		}
> > +	}
> > +}
> > +
> > +/*
> > + * Handle writeback of dirty data for the device backed by this bdi. Also
> > + * wakes up periodically and does kupdated style flushing.
> > + */
> > +int bdi_writeback_task(struct backing_dev_info *bdi)
> > +{
> > +	while (!kthread_should_stop()) {
> > +		DEFINE_WAIT(wait);
> > +
> > +		prepare_to_wait(&bdi->wait, &wait, TASK_INTERRUPTIBLE);
> > +		schedule_timeout(dirty_writeback_interval);
> > +		try_to_freeze();
> > +
> > +		/*
> > +		 * We get here in two cases:
> > +		 *
> > +		 *  schedule_timeout() returned because the dirty writeback
> > +		 *  interval has elapsed. If that happens, we will be able
> > +		 *  to acquire the writeback lock and will proceed to do
> > +		 *  kupdated style writeout.
> > +		 *
> > +		 *  Someone called bdi_start_writeback(), which will acquire
> > +		 *  the writeback lock. This means our writeback_acquire()
> > +		 *  below will fail and we call into bdi_pdflush() for
> > +		 *  pdflush style writeout.
> > +		 *
> > +		 */
> > +		if (writeback_acquire(bdi))
> > +			bdi_kupdated(bdi);
> > +		else
> > +			bdi_pdflush(bdi);
> > +
> > +		writeback_release(bdi);
> > +		finish_wait(&bdi->wait, &wait);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +void bdi_writeback_all(struct super_block *sb, long nr_pages)
> > +{
> > +	struct backing_dev_info *bdi;
> > +
> > +	rcu_read_lock();
> > +
> > +restart:
> > +	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
> > +		if (!bdi_has_dirty_io(bdi))
> > +			continue;
> > +		if (bdi_start_writeback(bdi, sb, nr_pages))
> > +			goto restart;
> > +	}
> > +
> > +	rcu_read_unlock();
> > +}
> > +
> >  /**
> >   *	__mark_inode_dirty -	internal function
> >   *	@inode: inode to mark
> > @@ -248,46 +420,6 @@ static void queue_io(struct backing_dev_info *bdi,
> >  	move_expired_inodes(&bdi->b_dirty, &bdi->b_io, older_than_this);
> >  }
> >  
> > -static int sb_on_inode_list(struct super_block *sb, struct list_head *list)
> > -{
> > -	struct inode *inode;
> > -	int ret = 0;
> > -
> > -	spin_lock(&inode_lock);
> > -	list_for_each_entry(inode, list, i_list) {
> > -		if (inode->i_sb == sb) {
> > -			ret = 1;
> > -			break;
> > -		}
> > -	}
> > -	spin_unlock(&inode_lock);
> > -	return ret;
> > -}
> > -
> > -int sb_has_dirty_inodes(struct super_block *sb)
> > -{
> > -	struct backing_dev_info *bdi;
> > -	int ret = 0;
> > -
> > -	/*
> > -	 * This is REALLY expensive right now, but it'll go away
> > -	 * when the bdi writeback is introduced
> > -	 */
> > -	rcu_read_lock();
> > -	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
> > -		if (sb_on_inode_list(sb, &bdi->b_dirty) ||
> > -		    sb_on_inode_list(sb, &bdi->b_io) ||
> > -		    sb_on_inode_list(sb, &bdi->b_more_io)) {
> > -			ret = 1;
> > -			break;
> > -		}
> > -	}
> > -	rcu_read_unlock();
> > -
> > -	return ret;
> > -}
> > -EXPORT_SYMBOL(sb_has_dirty_inodes);
> > -
> >  /*
> >   * Write a single inode's dirty pages and inode data out to disk.
> >   * If `wait' is set, wait on the writeout.
> > @@ -446,10 +578,11 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
> >  	return __sync_single_inode(inode, wbc);
> >  }
> >  
> > -static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
> > -				    struct writeback_control *wbc,
> > -				    int is_blkdev)
> > +void generic_sync_bdi_inodes(struct super_block *sb,
> > +			     struct writeback_control *wbc)
> >  {
> > +	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
> > +	struct backing_dev_info *bdi = wbc->bdi;
> >  	const unsigned long start = jiffies;	/* livelock avoidance */
> >  
> >  	spin_lock(&inode_lock);
> > @@ -461,9 +594,17 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
> >  						struct inode, i_list);
> >  		long pages_skipped;
> >  
> > +		/*
> > +		 * super block given and doesn't match, skip this inode
> > +		 */
> > +		if (sb && sb != inode->i_sb) {
> > +			redirty_tail(inode);
> > +			continue;
> > +		}
> > +
> >  		if (!bdi_cap_writeback_dirty(bdi)) {
> >  			redirty_tail(inode);
> > -			if (is_blkdev) {
> > +			if (is_blkdev_sb) {
> >  				/*
> >  				 * Dirty memory-backed blockdev: the ramdisk
> >  				 * driver does this.  Skip just this inode
> > @@ -485,33 +626,20 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
> >  
> >  		if (wbc->nonblocking && bdi_write_congested(bdi)) {
> >  			wbc->encountered_congestion = 1;
> > -			if (!is_blkdev)
> > +			if (!is_blkdev_sb)
> >  				break;		/* Skip a congested fs */
> >  			requeue_io(inode);
> >  			continue;		/* Skip a congested blockdev */
> >  		}
> >  
> > -		if (wbc->bdi && bdi != wbc->bdi) {
> > -			if (!is_blkdev)
> > -				break;		/* fs has the wrong queue */
> > -			requeue_io(inode);
> > -			continue;		/* blockdev has wrong queue */
> > -		}
> > -
> >  		/* Was this inode dirtied after sync_sb_inodes was called? */
> >  		if (time_after(inode->dirtied_when, start))
> >  			break;
> >  
> > -		/* Is another pdflush already flushing this queue? */
> > -		if (current_is_pdflush() && !writeback_acquire(bdi))
> > -			break;
> > -
> >  		BUG_ON(inode->i_state & I_FREEING);
> >  		__iget(inode);
> >  		pages_skipped = wbc->pages_skipped;
> >  		__writeback_single_inode(inode, wbc);
> > -		if (current_is_pdflush())
> > -			writeback_release(bdi);
> >  		if (wbc->pages_skipped != pages_skipped) {
> >  			/*
> >  			 * writeback is not making progress due to locked
> > @@ -550,11 +678,6 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
> >   * a variety of queues, so all inodes are searched.  For other superblocks,
> >   * assume that all inodes are backed by the same queue.
> >   *
> > - * FIXME: this linear search could get expensive with many fileystems.  But
> > - * how to fix?  We need to go from an address_space to all inodes which share
> > - * a queue with that address_space.  (Easy: have a global "dirty superblocks"
> > - * list).
> > - *
> >   * The inodes to be written are parked on bdi->b_io.  They are moved back onto
> >   * bdi->b_dirty as they are selected for writing.  This way, none can be missed
> >   * on the writer throttling path, and we get decent balancing between many
> > @@ -563,13 +686,10 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
> >  void generic_sync_sb_inodes(struct super_block *sb,
> >  				struct writeback_control *wbc)
> >  {
> > -	const int is_blkdev = sb_is_blkdev_sb(sb);
> > -	struct backing_dev_info *bdi;
> > -
> > -	rcu_read_lock();
> > -	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list)
> > -		generic_sync_bdi_inodes(bdi, wbc, is_blkdev);
> > -	rcu_read_unlock();
> > +	if (wbc->bdi)
> > +		bdi_start_writeback(wbc->bdi, sb, 0);
> > +	else
> > +		bdi_writeback_all(sb, 0);
>   Hmm, generic_sync_sb_inodes() is also used for calls like sys_sync()
> (i.e. data integrity sync). But bdi_start_writeback() (called also from
> bdi_writeback_all()) just skips the bdi if somebody is already writing
> it. But to ensure data integrity we have to wait for previous writer to
> finish (or interupt him somehow) and write it ourselves. Nasty for
> performance but needed for integrity...

Good point, thanks for your reviews Jan! It may indeed be a problem, if
the new caller is less retrictive than the one currently running. I
guess it's pretty easily fixable by doing a blocking wait on the
writeback bit for those cases, usable from
bdi_start_writeback_blocking() or something to that effect. I'll add
that for v3, it is going to be posted fairly soon.

> >  	/*
> > -	 * If any dirty inodes are left, throw away all mft data page cache
> > -	 * pages to allow a clean umount.  This should never happen any more
> > -	 * due to mft.c::ntfs_mft_writepage() cleaning all the dirty pages as
> > -	 * the underlying mft records are written out and cleaned.  If it does,
> > +	 * We should have no dirty inodes left, due to
> > +	 * mft.c::ntfs_mft_writepage() cleaning all the dirty pages as
> > +	 * the underlying mft records are written out and cleaned.
> >  	 * happen anyway, we want to know...
>   Obviously you've left one line here ;).

Oops indeed, thanks!

-- 
Jens Axboe


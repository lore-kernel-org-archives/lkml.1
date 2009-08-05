Return-Path: <linux-kernel-owner+w=401wt.eu-S964799AbZHEQfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799AbZHEQfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934643AbZHEQfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:35:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933270AbZHEQfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:35:37 -0400
Date: Wed, 5 Aug 2009 18:35:32 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 2/9] writeback: switch to per-bdi threads for flushing
	data
Message-ID: <20090805163532.GC27505@duck.suse.cz>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <1248989044-21605-3-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248989044-21605-3-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 30-07-09 23:23:57, Jens Axboe wrote:
> This gets rid of pdflush for bdi writeout and kupdated style cleaning.
> This is an experiment to see if we get better writeout behaviour with
> per-bdi flushing. Some initial tests look pretty encouraging. A sample
> ffsb workload that does random writes to files is about 8% faster here
> on a simple SATA drive during the benchmark phase. File layout also seems
> a LOT more smooth in vmstat:
> 
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
>  0  1      0 608848   2652 375372    0    0     0 71024  604    24  1 10 48 42
>  0  1      0 549644   2712 433736    0    0     0 60692  505    27  1  8 48 44
>  1  0      0 476928   2784 505192    0    0     4 29540  553    24  0  9 53 37
>  0  1      0 457972   2808 524008    0    0     0 54876  331    16  0  4 38 58
>  0  1      0 366128   2928 614284    0    0     4 92168  710    58  0 13 53 34
>  0  1      0 295092   3000 684140    0    0     0 62924  572    23  0  9 53 37
>  0  1      0 236592   3064 741704    0    0     4 58256  523    17  0  8 48 44
>  0  1      0 165608   3132 811464    0    0     0 57460  560    21  0  8 54 38
>  0  1      0 102952   3200 873164    0    0     4 74748  540    29  1 10 48 41
>  0  1      0  48604   3252 926472    0    0     0 53248  469    29  0  7 47 45
> 
> where vanilla tends to fluctuate a lot in the creation phase:
> 
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
>  1  1      0 678716   5792 303380    0    0     0 74064  565    50  1 11 52 36
>  1  0      0 662488   5864 319396    0    0     4   352  302   329  0  2 47 51
>  0  1      0 599312   5924 381468    0    0     0 78164  516    55  0  9 51 40
>  0  1      0 519952   6008 459516    0    0     4 78156  622    56  1 11 52 37
>  1  1      0 436640   6092 541632    0    0     0 82244  622    54  0 11 48 41
>  0  1      0 436640   6092 541660    0    0     0     8  152    39  0  0 51 49
>  0  1      0 332224   6200 644252    0    0     4 102800  728    46  1 13 49 36
>  1  0      0 274492   6260 701056    0    0     4 12328  459    49  0  7 50 43
>  0  1      0 211220   6324 763356    0    0     0 106940  515    37  1 10 51 39
>  1  0      0 160412   6376 813468    0    0     0  8224  415    43  0  6 49 45
>  1  1      0  85980   6452 886556    0    0     4 113516  575    39  1 11 54 34
>  0  2      0  85968   6452 886620    0    0     0  1640  158   211  0  0 46 54
> 
> So apart from seemingly behaving better for buffered writeout, this also
> allows us to potentially have more than one bdi thread flushing out data.
> This may be useful for NUMA type setups.
> 
> A 10 disk test with btrfs performs 26% faster with per-bdi flushing. Other
> tests pending. mmap heavy writing also improves considerably.
  Any update here?

> A separate thread is added to sync the super blocks. In the long term,
> adding sync_supers_bdi() functionality could get rid of this thread again.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
  <snip>

> @@ -466,11 +588,11 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  	return ret;
>  }
>  
> -static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
> -				    struct writeback_control *wbc,
> -				    struct super_block *sb,
> -				    int is_blkdev_sb)
> +void generic_sync_bdi_inodes(struct super_block *sb,
> +			     struct writeback_control *wbc)
>  {
  Jens, sorry about bitching about this again but you're silently changing
substantial locking assumptions without writing it *anywhere* and without
arguing it's safe.
  Originally, generic_sync_sb_inodes() from writeback path have been
called with
a) s_umount_sem held
b) sb->s_count elevated
  The second still seems to be true since, if I'm right, we pass here
non-NULL sb only from sync_filesystem() and that takes care of the
superblock reference. So that is just a matter of documenting this fact
before the function.
  But s_umount_sem is not held anymore so you should say why this cannot
interact badly with the umount / remount code. Looking at the code, if the
filesystem dirties some inode (usually a system file) while e.g.
invalidate_inodes() is running, you can happily start writeback on it while
put_super() is running and that is not expected. In my opinion, you should
make sure you don't touch inode in a filesystem which is currently being
remounted / umounted. Actually, it should not be too hard to do - when you
look at an inode from b_io list, you can (while still holding inode_lock
and before acquiring inode reference) do:
   down_read_trylock(&inode->i_sb->s_umount)
if it fails, you just leave the inode alone, otherwise you proceed and drop
the lock when you are done.

> +	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
> +	struct backing_dev_info *bdi = wbc->bdi;
>  	const unsigned long start = jiffies;	/* livelock avoidance */
>  
>  	spin_lock(&inode_lock);
> @@ -521,13 +643,6 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
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
> @@ -535,16 +650,10 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
>  		if (inode_dirtied_after(inode, start))
>  			break;
>  
> -		/* Is another pdflush already flushing this queue? */
> -		if (current_is_pdflush() && !writeback_acquire(bdi))
> -			break;
> -
>  		BUG_ON(inode->i_state & (I_FREEING | I_CLEAR));
>  		__iget(inode);
>  		pages_skipped = wbc->pages_skipped;
>  		writeback_single_inode(inode, wbc);
> -		if (current_is_pdflush())
> -			writeback_release(bdi);
>  		if (wbc->pages_skipped != pages_skipped) {
>  			/*
>  			 * writeback is not making progress due to locked
> @@ -583,11 +692,6 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
>   * a variety of queues, so all inodes are searched.  For other superblocks,
>   * assume that all inodes are backed by the same queue.
>   *
> - * FIXME: this linear search could get expensive with many fileystems.  But
> - * how to fix?  We need to go from an address_space to all inodes which share
> - * a queue with that address_space.  (Easy: have a global "dirty superblocks"
> - * list).
> - *
>   * The inodes to be written are parked on bdi->b_io.  They are moved back onto
>   * bdi->b_dirty as they are selected for writing.  This way, none can be missed
>   * on the writer throttling path, and we get decent balancing between many
  <snip>

> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index 928cd54..8860264 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
  <snip>

> @@ -77,10 +87,21 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
>  		const char *fmt, ...);
>  int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
>  void bdi_unregister(struct backing_dev_info *bdi);
> +void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
> +			 long nr_pages, enum writeback_sync_modes sync_mode);
> +int bdi_writeback_task(struct backing_dev_info *bdi);
> +void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc);
>  
> -extern struct mutex bdi_lock;
> +extern spinlock_t bdi_lock;
  It's slightly strange to make mutex from this spinlock in the first patch and
then return back to spinlock in the second one...

  <snip>

> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 6f163e0..b44f793 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
  <snip>

> +static int bdi_forker_task(void *ptr)
> +{
> +	struct backing_dev_info *me = ptr;
> +
> +	for (;;) {
> +		struct backing_dev_info *bdi, *tmp;
> +
> +		/*
> +		 * Temporary measure, we want to make sure we don't see
> +		 * dirty data on the default backing_dev_info
> +		 */
> +		if (bdi_has_dirty_io(me))
> +			bdi_flush_io(me);
> +
> +		spin_lock(&bdi_lock);
> +
> +		/*
> +		 * Check if any existing bdi's have dirty data without
> +		 * a thread registered. If so, set that up.
> +		 */
> +		list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
> +			if (bdi->task || !bdi_has_dirty_io(bdi))
> +				continue;
> +
> +			bdi_add_default_flusher_task(bdi);
> +		}
> +
> +		set_current_state(TASK_INTERRUPTIBLE);
> +
> +		if (list_empty(&bdi_pending_list)) {
> +			unsigned long wait;
> +
> +			spin_unlock(&bdi_lock);
> +			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
> +			schedule_timeout(wait);
> +			try_to_freeze();
> +			continue;
> +		}
> +
> +		__set_current_state(TASK_RUNNING);
> +
> +		/*
> +		 * This is our real job - check for pending entries in
> +		 * bdi_pending_list, and create the tasks that got added
> +		 */
> +		bdi = list_entry(bdi_pending_list.next, struct backing_dev_info,
> +				 bdi_list);
> +		list_del_init(&bdi->bdi_list);
> +		spin_unlock(&bdi_lock);
> +
> +		BUG_ON(bdi->task);
> +
> +		bdi->task = kthread_run(bdi_start_fn, bdi, "flush-%s",
> +					dev_name(bdi->dev));
> +		/*
> +		 * If task creation fails, then readd the bdi to
> +		 * the pending list and force writeout of the bdi
> +		 * from this forker thread. That will free some memory
> +		 * and we can try again.
> +		 */
> +		if (IS_ERR(bdi->task)) {
> +			bdi->task = NULL;
> +
> +			/*
> +			 * Add this 'bdi' to the back, so we get
> +			 * a chance to flush other bdi's to free
> +			 * memory.
> +			 */
> +			spin_lock(&bdi_lock);
> +			list_add_tail(&bdi->bdi_list, &bdi_pending_list);
> +			spin_unlock(&bdi_lock);
> +
> +			bdi_flush_io(bdi);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Add a new flusher task that gets created for any bdi
> + * that has dirty data pending writeout
> + */
> +static void bdi_add_default_flusher_task(struct backing_dev_info *bdi)
> +{
  This function seems to be called with bdi_lock already held so taking
bdi_lock in it does not look healthy ;) Also why not move it above the
bdi_forker_task() to save a forward declaration?

> +	/*
> +	 * Someone already marked this pending for task creation
> +	 */
> +	if (test_and_set_bit(BDI_pending, &bdi->state))
> +		return;
> +
> +	spin_lock(&bdi_lock);
> +	list_move_tail(&bdi->bdi_list, &bdi_pending_list);
> +	spin_unlock(&bdi_lock);
> +
> +	wake_up_process(default_backing_dev_info.task);
> +}
> +
>  int bdi_register(struct backing_dev_info *bdi, struct device *parent,
>  		const char *fmt, ...)
>  {

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

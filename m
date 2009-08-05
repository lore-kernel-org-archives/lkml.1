Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbZHETzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbZHETzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 15:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbZHETzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 15:55:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbZHETzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 15:55:08 -0400
Date: Wed, 5 Aug 2009 21:55:04 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 5/9] writeback: support > 1 flusher thread per bdi
Message-ID: <20090805195504.GD27505@duck.suse.cz>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <1248989044-21605-6-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248989044-21605-6-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 30-07-09 23:24:00, Jens Axboe wrote:
> Build on the bdi_writeback support by allowing registration of
> more than 1 flusher thread. File systems can call bdi_add_flusher_task(bdi)
> to add more flusher threads to the device. If they do so, they must also
> provide a super_operations function to return the suitable bdi_writeback
> struct from any given inode.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  fs/fs-writeback.c           |  436 +++++++++++++++++++++++++++++++++++--------
>  include/linux/backing-dev.h |   32 +++-
>  include/linux/fs.h          |    3 +
>  include/linux/writeback.h   |    1 +
>  mm/backing-dev.c            |  254 ++++++++++++++++++++-----
>  5 files changed, 593 insertions(+), 133 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 86fb2a9..8069483 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -38,77 +38,230 @@ static void generic_sync_wb_inodes(struct bdi_writeback *wb,
>   */
>  int nr_pdflush_threads;
>  
> -/**
> - * writeback_acquire - attempt to get exclusive writeback access to a device
> - * @bdi: the device's backing_dev_info structure
> - *
> - * It is a waste of resources to have more than one pdflush thread blocked on
> - * a single request queue.  Exclusion at the request_queue level is obtained
> - * via a flag in the request_queue's backing_dev_info.state.
> - *
> - * Non-request_queue-backed address_spaces will share default_backing_dev_info,
> - * unless they implement their own.  Which is somewhat inefficient, as this
> - * may prevent concurrent writeback against multiple devices.
> +static void generic_sync_wb_inodes(struct bdi_writeback *wb,
> +				   struct super_block *sb,
> +				   struct writeback_control *wbc);
> +
> +/*
> + * Work items for the bdi_writeback threads
>   */
> -static int writeback_acquire(struct bdi_writeback *wb)
> +struct bdi_work {
> +	struct list_head list;
> +	struct list_head wait_list;
> +	struct rcu_head rcu_head;
> +
> +	unsigned long seen;
> +	atomic_t pending;
> +
> +	unsigned long sb_data;
> +	unsigned long nr_pages;
> +	enum writeback_sync_modes sync_mode;
> +
> +	unsigned long state;
> +};
> +
> +static struct super_block *bdi_work_sb(struct bdi_work *work)
>  {
> -	struct backing_dev_info *bdi = wb->bdi;
> +	return (struct super_block *) (work->sb_data & ~1UL);
> +}
> +
> +static inline bool bdi_work_on_stack(struct bdi_work *work)
> +{
> +	return work->sb_data & 1UL;
> +}
> +
> +static inline void bdi_work_init(struct bdi_work *work, struct super_block *sb,
> +				 unsigned long nr_pages,
> +				 enum writeback_sync_modes sync_mode)
> +{
> +	INIT_RCU_HEAD(&work->rcu_head);
> +	work->sb_data = (unsigned long) sb;
> +	work->nr_pages = nr_pages;
> +	work->sync_mode = sync_mode;
> +	work->state = 1;
> +}
>  
> -	return !test_and_set_bit(wb->nr, &bdi->wb_active);
> +static inline void bdi_work_init_on_stack(struct bdi_work *work,
> +					  struct super_block *sb,
> +					  unsigned long nr_pages,
> +					  enum writeback_sync_modes sync_mode)
> +{
> +	bdi_work_init(work, sb, nr_pages, sync_mode);
> +	work->sb_data |= 1UL;
>  }
>  
>  /**
>   * writeback_in_progress - determine whether there is writeback in progress
>   * @bdi: the device's backing_dev_info structure.
>   *
> - * Determine whether there is writeback in progress against a backing device.
> + * Determine whether there is writeback waiting to be handled against a
> + * backing device.
>   */
>  int writeback_in_progress(struct backing_dev_info *bdi)
>  {
> -	return bdi->wb_active != 0;
> +	return !list_empty(&bdi->work_list);
>  }
>  
> -/**
> - * writeback_release - relinquish exclusive writeback access against a device.
> - * @bdi: the device's backing_dev_info structure
> - */
> -static void writeback_release(struct bdi_writeback *wb)
> +static void bdi_work_clear(struct bdi_work *work)
>  {
> -	struct backing_dev_info *bdi = wb->bdi;
> +	clear_bit(0, &work->state);
> +	smp_mb__after_clear_bit();
> +	wake_up_bit(&work->state, 0);
> +}
> +
> +static void bdi_work_free(struct rcu_head *head)
> +{
> +	struct bdi_work *work = container_of(head, struct bdi_work, rcu_head);
>  
> -	wb->nr_pages = 0;
> -	wb->sb = NULL;
> -	clear_bit(wb->nr, &bdi->wb_active);
> +	if (!bdi_work_on_stack(work))
> +		kfree(work);
> +	else
> +		bdi_work_clear(work);
>  }
>  
> -static void wb_start_writeback(struct bdi_writeback *wb, struct super_block *sb,
> -			       long nr_pages,
> -			       enum writeback_sync_modes sync_mode)
> +static void wb_work_complete(struct bdi_work *work)
>  {
> -	if (!wb_has_dirty_io(wb))
> -		return;
> +	const enum writeback_sync_modes sync_mode = work->sync_mode;
>  
> -	if (writeback_acquire(wb)) {
> -		wb->nr_pages = nr_pages;
> -		wb->sb = sb;
> -		wb->sync_mode = sync_mode;
> +	/*
> +	 * For allocated work, we can clear the done/seen bit right here.
> +	 * For on-stack work, we need to postpone both the clear and free
> +	 * to after the RCU grace period, since the stack could be invalidated
> +	 * as soon as bdi_work_clear() has done the wakeup.
> +	 */
> +	if (!bdi_work_on_stack(work))
> +		bdi_work_clear(work);
> +	if (sync_mode == WB_SYNC_NONE || bdi_work_on_stack(work))
> +		call_rcu(&work->rcu_head, bdi_work_free);
> +}
>  
> -		if (wb->task)
> -			wake_up_process(wb->task);
> +static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
> +{
> +	/*
> +	 * The caller has retrieved the work arguments from this work,
> +	 * drop our reference. If this is the last ref, delete and free it
> +	 */
> +	if (atomic_dec_and_test(&work->pending)) {
> +		struct backing_dev_info *bdi = wb->bdi;
> +
> +		spin_lock(&bdi->wb_lock);
> +		list_del_rcu(&work->list);
> +		spin_unlock(&bdi->wb_lock);
> +
> +		wb_work_complete(work);
>  	}
>  }
>  
> -void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
> -			 long nr_pages, enum writeback_sync_modes sync_mode)
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
> +
> +static void bdi_sched_work(struct backing_dev_info *bdi, struct bdi_work *work)
>  {
> +	if (!bdi_wblist_needs_lock(bdi))
> +		wb_start_writeback(&bdi->wb, work);
> +	else {
> +		struct bdi_writeback *wb;
> +		int idx;
> +
> +		idx = srcu_read_lock(&bdi->srcu);
> +
> +		list_for_each_entry_rcu(wb, &bdi->wb_list, list)
> +			wb_start_writeback(wb, work);
> +
> +		srcu_read_unlock(&bdi->srcu, idx);
> +	}
> +}
> +
> +static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
> +{
> +	if (work) {
> +		work->seen = bdi->wb_mask;
> +		BUG_ON(!work->seen);
> +		atomic_set(&work->pending, bdi->wb_cnt);
  I guess the idea here is that every writeback thread has to acknowledge
the work. But what if some thread decides to die after the work is queued
but before it manages to acknowledge it? We would end up waiting
indefinitely...

> +		BUG_ON(!bdi->wb_cnt);
> +
> +		/*
> +		 * Make sure stores are seen before it appears on the list
> +		 */
> +		smp_mb();
> +
> +		spin_lock(&bdi->wb_lock);
> +		list_add_tail_rcu(&work->list, &bdi->work_list);
> +		spin_unlock(&bdi->wb_lock);
> +	}
> +
>  	/*
> -	 * This only happens the first time someone kicks this bdi, so put
> -	 * it out-of-line.
> +	 * If the default thread isn't there, make sure we add it. When
> +	 * it gets created and wakes up, we'll run this work.
>  	 */
> -	if (unlikely(!bdi->wb.task))
> +	if (unlikely(list_empty_careful(&bdi->wb_list)))
>  		wake_up_process(default_backing_dev_info.wb.task);
> +	else
> +		bdi_sched_work(bdi, work);
> +}
> +
> +/*
> + * Used for on-stack allocated work items. The caller needs to wait until
> + * the wb threads have acked the work before it's safe to continue.
> + */
> +static void bdi_wait_on_work_clear(struct bdi_work *work)
> +{
> +	wait_on_bit(&work->state, 0, bdi_sched_wait, TASK_UNINTERRUPTIBLE);
> +}
  I still feel the rules for releasing / cleaning up work are too
complicated.
  1) I believe we can bear one more "int" for flags in the struct bdi_work
so that you don't have to hide them in sb_data.
  2) I'd introduce a flag with the meaning: free the work when you are
done. Obviusly this flag makes sence only with dynamically allocated work
structure. There would be no "on stack" flag.
  3) I'd create a function:
bdi_wait_work_submitted()
  which you'd have to call whenever you didn't set the flag and want to
free the work (either explicitely, or via returning from a function which
has the structure on stack).
  It would do:
bdi_wait_on_work_clear(work);
call_rcu(&work->rcu_head, bdi_work_free);

  wb_work_complete() would just depending on the flag setting either
completely do away with the work struct or just do bdi_work_clear().

  IMO that would make the code easier to check and also less prone to
errors (currently you have to think twice when you have to wait for the rcu
period, call bdi_work_free, etc.).


									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

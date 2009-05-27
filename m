Return-Path: <linux-kernel-owner+w=401wt.eu-S1763504AbZE0PPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763504AbZE0PPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760287AbZE0POy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:14:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:54619 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758598AbZE0POx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:14:53 -0400
Date: Wed, 27 May 2009 17:14:52 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 04/11] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090527151452.GI16006@duck.suse.cz>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com> <1243417312-7444-5-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243417312-7444-5-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  The patch set seems easier to read now. Thanks for cleaning it up.

> +void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc)
> +{
> +	struct backing_dev_info *bdi, *tmp;
> +
> +	mutex_lock(&bdi_lock);
> +
> +	list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
> +		if (!bdi_has_dirty_io(bdi))
> +			continue;
> +		bdi_start_writeback(bdi, sb, wbc->nr_to_write, wbc->sync_mode);
> +	}
> +
> +	mutex_unlock(&bdi_lock);
> +}
> +
  Looking at this function, I've realized that wbc->nr_to_write has a bit
silly meaning here. Each BDI will be kicked to write nr_to_write pages
which is not what it used to mean originally. I don't think it really matters
but we should have this in mind...

> @@ -591,13 +715,10 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
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
> +		bdi_writeback_all(sb, wbc);
  I guess this asynchronousness is just transient...

> +static int bdi_forker_task(void *ptr)
> +{
> +	struct backing_dev_info *me = ptr;
> +	DEFINE_WAIT(wait);
> +
> +	for (;;) {
> +		struct backing_dev_info *bdi, *tmp;
> +
> +		/*
> +		 * Do this periodically, like kupdated() did before.
> +		 */
> +		sync_supers();
  Ugh, this looks nasty. Moreover I'm afraid of forker_task() getting stuck
(and thus not being able to start new threads) in sync_supers() when some
fs is busy and other needs to create flusher thread...
  Why not just having a separate thread for this? I know we have lots of
kernel threads already but this one seems like a useful one... Or do you
plan getting rid of this completely sometime in the near future and sync
supers also from per-bdi thread (which would make a lot of sence to me)?

> +
> +		/*
> +		 * Temporary measure, we want to make sure we don't see
> +		 * dirty data on the default backing_dev_info
> +		 */
> +		if (bdi_has_dirty_io(me))
> +			bdi_flush_io(me);
> +
> +		prepare_to_wait(&me->wait, &wait, TASK_INTERRUPTIBLE);
> +
> +		mutex_lock(&bdi_lock);
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
> +		if (list_empty(&bdi_pending_list)) {
> +			unsigned long wait;
> +
> +			mutex_unlock(&bdi_lock);
> +			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
> +			schedule_timeout(wait);
> +			try_to_freeze();
> +			continue;
> +		}
> +
> +		/*
> +		 * This is our real job - check for pending entries in
> +		 * bdi_pending_list, and create the tasks that got added
> +		 */
> +		bdi = list_entry(bdi_pending_list.next, struct backing_dev_info,
> +				 bdi_list);
> +		list_del_init(&bdi->bdi_list);
> +		mutex_unlock(&bdi_lock);
> +
> +		BUG_ON(bdi->task);
> +
> +		bdi->task = kthread_run(bdi_start_fn, bdi, "bdi-%s",
> +					dev_name(bdi->dev));
> +		/*
> +		 * If task creation fails, then readd the bdi to
> +		 * the pending list and force writeout of the bdi
> +		 * from this forker thread. That will free some memory
> +		 * and we can try again.
> +		 */
> +		if (!bdi->task) {
> +			/*
> +			 * Add this 'bdi' to the back, so we get
> +			 * a chance to flush other bdi's to free
> +			 * memory.
> +			 */
> +			mutex_lock(&bdi_lock);
> +			list_add_tail(&bdi->bdi_list, &bdi_pending_list);
> +			mutex_unlock(&bdi_lock);
> +
> +			bdi_flush_io(bdi);
> +		}
> +	}
> +
> +	finish_wait(&me->wait, &wait);
> +	return 0;
> +}

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

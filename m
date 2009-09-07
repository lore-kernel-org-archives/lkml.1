Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbZIGShE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbZIGShE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 14:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZIGShD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 14:37:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:39872 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbZIGShB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 14:37:01 -0400
Date: Mon, 7 Sep 2009 20:36:59 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] writeback: switch to per-bdi threads for flushing
	data v2
Message-ID: <20090907183659.GB29103@duck.suse.cz>
References: <1252050406-22467-1-git-send-email-jens.axboe@oracle.com> <1252050406-22467-4-git-send-email-jens.axboe@oracle.com> <20090904105403.GD19857@duck.suse.cz> <20090904115858.GT18599@kernel.dk> <20090904120407.GV18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904120407.GV18599@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Jens,

  now I've found just two minor things (see below). Besides them the only
thing which is blocking my ack is a way to effectively lookup a BDI from a
superblock so that we can reasonably effectively fsync a superblock...

								Honza

On Fri 04-09-09 14:04:07, Jens Axboe wrote:
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 45ad4bb..c86492c 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> +static long wb_check_old_data_flush(struct bdi_writeback *wb)
> +{
> +	unsigned long expired;
> +	long nr_pages;
> +
> +	expired = wb->last_old_flush +
> +			msecs_to_jiffies(dirty_writeback_interval * 10);
> +	if (time_before(jiffies, expired))
> +		return 0;
> +
> +	nr_pages = global_page_state(NR_FILE_DIRTY) +
> +			global_page_state(NR_UNSTABLE_NFS) +
> +			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
> +
> +	return wb_writeback(wb, nr_pages, NULL, WB_SYNC_NONE, 1);
> +}
> +
> +/*
> + * Retrieve work items and do the writeback they describe
> + */
> +long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
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
> +	if (!wrote)
> +		wrote = wb_check_old_data_flush(wb);
  Why is here the !wrote check? It would feel safer if we just did
wrote += wb_check_old_data_flush(wb);
  Otherwise we cannot guarantee syncing of inodes every writeback_interval.

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
>  
> -			filemap_fdatawait(mapping);
> +	list_for_each_entry(bdi, &bdi_list, bdi_list) {
> +		struct bdi_work *work;
> +
> +		if (!bdi_has_dirty_io(bdi))
> +			continue;
> +
> +		/*
> +		 * If work allocation fails, do the writes inline. We drop
> +		 * the lock and restart the list writeout. This should be OK,
> +		 * since this happens rarely and because the writeout should
> +		 * eventually make more free memory available.
> +		 */
> +		work = bdi_alloc_work(wbc);
> +		if (!work) {
> +			struct writeback_control __wbc = *wbc;
>
> -			cond_resched();
> +			/*
> +			 * Not a data integrity writeout, just continue
> +			 */
> +			if (!must_wait)
> +				continue;
>  
> -			spin_lock(&inode_lock);
> +			spin_unlock(&bdi_lock);
> +			__wbc = *wbc;
  You initialize the variable twice...

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

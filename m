Return-Path: <linux-kernel-owner+w=401wt.eu-S1762043AbZE1J2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762043AbZE1J2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761880AbZE1J1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:27:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759115AbZE1J1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:27:43 -0400
Date: Thu, 28 May 2009 11:27:43 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 07/11] writeback: support > 1 flusher thread per bdi
Message-ID: <20090528092743.GD29199@duck.suse.cz>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com> <1243417312-7444-8-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243417312-7444-8-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-05-09 11:41:48, Jens Axboe wrote:
> Build on the bdi_writeback support by allowing registration of
> more than 1 flusher thread. File systems can call bdi_add_flusher_task(bdi)
> to add more flusher threads to the device. If they do so, they must also
> provide a super_operations function to return the suitable bdi_writeback
> struct from any given inode.
  Isn't this patch in fact doing two different things? Looking at the
changes it implements more flusher threads per BDI as you write above but
it also does all that sync-work handling which isn't quite trivial and
seems to be a separate thing...

> +static struct bdi_work *bdi_alloc_work(struct super_block *sb, long nr_pages,
> +				       enum writeback_sync_modes sync_mode)
> +{
> +	struct bdi_work *work;
> +
> +	work = kmalloc(sizeof(*work), GFP_ATOMIC);
  Why is this GFP_ATOMIC? Wouldn't GFP_NOFS be enough?
But for now, GFP_ATOMIC may be fine since it excercises more the
"allocation failed" path :).

> +	if (work)
> +		bdi_work_init(work, sb, nr_pages, sync_mode);
> +
> +	return work;
> +}
> +
> +void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
> +			 long nr_pages, enum writeback_sync_modes sync_mode)
> +{
> +	const bool must_wait = sync_mode == WB_SYNC_ALL;
> +	struct bdi_work work_stack, *work = NULL;
> +
> +	if (!must_wait)
> +		work = bdi_alloc_work(sb, nr_pages, sync_mode);
> +
> +	if (!work) {
> +		work = &work_stack;
> +		bdi_work_init_on_stack(work, sb, nr_pages, sync_mode);
>  	}
>  
> -	wb_start_writeback(&bdi->wb, sb, nr_pages, sync_mode);
> -	return 0;
> +	bdi_queue_work(bdi, work);
> +	bdi_start_work(bdi, work);
> +
> +	/*
> +	 * If the sync mode is WB_SYNC_ALL, block waiting for the work to
> +	 * complete. If not, we only need to wait for the work to be started,
> +	 * if we allocated it on-stack. We use the same mechanism, if the
> +	 * wait bit is set in the bdi_work struct, then threads will not
> +	 * clear pending until after they are done.
> +	 *
> +	 * Note that work == &work_stack if must_wait is true, so we don't
> +	 * need to do call_rcu() here ever, since the completion path will
> +	 * have done that for us.
> +	 */
> +	if (must_wait || work == &work_stack) {
> +		bdi_wait_on_work_clear(work);
> +		if (work != &work_stack)
> +			call_rcu(&work->rcu_head, bdi_work_free);
> +	}
>  }
  Looking into this, it seems a bit complex with all that on_stack, sync /
nosync thing. Wouldn't a simple refcounting scheme be more clear? Alloc /
init_work_on_stack gets a reference from bdi_work, queue_work gets another
reference passed later to flusher thread. We drop the reference when we
leave bdi_start_writeback() and when flusher thread is done with the work.
When refcount hits zero, work struct is freed (when work is on stack, we
just never drop the last reference)...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbZE1Mnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbZE1Mnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758300AbZE1Mnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:43:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:58974 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757300AbZE1Mnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:43:41 -0400
Date: Thu, 28 May 2009 14:43:40 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr
Subject: Re: [PATCH 07/11] writeback: support > 1 flusher thread per bdi
Message-ID: <20090528124339.GJ29199@duck.suse.cz>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com> <1243417312-7444-8-git-send-email-jens.axboe@oracle.com> <20090528092743.GD29199@duck.suse.cz> <20090528104022.GZ11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528104022.GZ11363@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 28-05-09 12:40:23, Jens Axboe wrote:
> On Thu, May 28 2009, Jan Kara wrote:
> > On Wed 27-05-09 11:41:48, Jens Axboe wrote:
> > > Build on the bdi_writeback support by allowing registration of
> > > more than 1 flusher thread. File systems can call bdi_add_flusher_task(bdi)
> > > to add more flusher threads to the device. If they do so, they must also
> > > provide a super_operations function to return the suitable bdi_writeback
> > > struct from any given inode.
> >   Isn't this patch in fact doing two different things? Looking at the
> > changes it implements more flusher threads per BDI as you write above but
> > it also does all that sync-work handling which isn't quite trivial and
> > seems to be a separate thing...
> 
> Yes, but the separated work is a pre-requisite for multi thread support.
> But I guess it would clean it up as a patchset if I added that with the
> previous patch, that would save me from having to add the
> writeback_acquire()/release changes. But I still have to do those, so
> perhaps not... Unless you feel strongly about it, I'd prefer to leave it
> as-is.
  OK.

> > > +static struct bdi_work *bdi_alloc_work(struct super_block *sb, long nr_pages,
> > > +				       enum writeback_sync_modes sync_mode)
> > > +{
> > > +	struct bdi_work *work;
> > > +
> > > +	work = kmalloc(sizeof(*work), GFP_ATOMIC);
> >   Why is this GFP_ATOMIC? Wouldn't GFP_NOFS be enough?
> > But for now, GFP_ATOMIC may be fine since it excercises more the
> > "allocation failed" path :).
> 
> GFP_NOFS/NOIO should be ok. I prefer GFP_ATOMIC since we never enter any
> reclaim, so better safe than sorry. We still have to handle failure
> either way, the rate of failure may be different though.
  Yes, it was mainly about the rate of failure since if the allocation
fails, we have to synchronously wait for writeout to complete...

> > > +	if (work)
> > > +		bdi_work_init(work, sb, nr_pages, sync_mode);
> > > +
> > > +	return work;
> > > +}
> > > +
> > > +void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
> > > +			 long nr_pages, enum writeback_sync_modes sync_mode)
> > > +{
> > > +	const bool must_wait = sync_mode == WB_SYNC_ALL;
> > > +	struct bdi_work work_stack, *work = NULL;
> > > +
> > > +	if (!must_wait)
> > > +		work = bdi_alloc_work(sb, nr_pages, sync_mode);
> > > +
> > > +	if (!work) {
> > > +		work = &work_stack;
> > > +		bdi_work_init_on_stack(work, sb, nr_pages, sync_mode);
> > >  	}
> > >  
> > > -	wb_start_writeback(&bdi->wb, sb, nr_pages, sync_mode);
> > > -	return 0;
> > > +	bdi_queue_work(bdi, work);
> > > +	bdi_start_work(bdi, work);
> > > +
> > > +	/*
> > > +	 * If the sync mode is WB_SYNC_ALL, block waiting for the work to
> > > +	 * complete. If not, we only need to wait for the work to be started,
> > > +	 * if we allocated it on-stack. We use the same mechanism, if the
> > > +	 * wait bit is set in the bdi_work struct, then threads will not
> > > +	 * clear pending until after they are done.
> > > +	 *
> > > +	 * Note that work == &work_stack if must_wait is true, so we don't
> > > +	 * need to do call_rcu() here ever, since the completion path will
> > > +	 * have done that for us.
> > > +	 */
> > > +	if (must_wait || work == &work_stack) {
> > > +		bdi_wait_on_work_clear(work);
> > > +		if (work != &work_stack)
> > > +			call_rcu(&work->rcu_head, bdi_work_free);
> > > +	}
> > >  }
> >   Looking into this, it seems a bit complex with all that on_stack, sync /
> > nosync thing. Wouldn't a simple refcounting scheme be more clear? Alloc /
> > init_work_on_stack gets a reference from bdi_work, queue_work gets another
> > reference passed later to flusher thread. We drop the reference when we
> > leave bdi_start_writeback() and when flusher thread is done with the work.
> > When refcount hits zero, work struct is freed (when work is on stack, we
> > just never drop the last reference)...
> 
> It wouldn't change the complexity of the stack vs non-stack at all,
> since you have to do the same checks for when it's safe to proceed. And
> having the single bit there with the hash bit wait queues makes that bit
> easier.
  I think it would be simpler. Look:
static void bdi_work_free(struct rcu_head *head)
{
	struct bdi_work *work = container_of(head, struct bdi_work, rcu_head);

	kfree(work);
}

static void bdi_put_work(struct bdi_work *work)
{
	if (!atomic_dec_and_test(&work->count, 1))
		call_rcu(&work->rcu_head, bdi_work_free);
}

static void wb_work_complete(struct bdi_work *work)
{
	bdi_work_clear(work);
	bdi_put_work(work);
}

void bdi_start_writeback(...)
{
	...
	if (must_wait || work == &work_stack)
		bdi_wait_on_work_clear(work);
	if (work != &work_stack)
		bdi_put_work(work);
}

  IMO much easier to read...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

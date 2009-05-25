Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbZEYMev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbZEYMev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbZEYMei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:34:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbZEYMeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:34:36 -0400
Date: Mon, 25 May 2009 14:34:35 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 04/12] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090525123434.GA5862@duck.suse.cz>
References: <1243236887-3931-1-git-send-email-jens.axboe@oracle.com> <1243236887-3931-5-git-send-email-jens.axboe@oracle.com> <20090525095816.GC23546@duck.suse.cz> <20090525103410.GT11363@kernel.dk> <20090525121049.GE23546@duck.suse.cz> <20090525121648.GW11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525121648.GW11363@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 25-05-09 14:16:48, Jens Axboe wrote:
> On Mon, May 25 2009, Jan Kara wrote:
> > On Mon 25-05-09 12:34:10, Jens Axboe wrote:
> > > On Mon, May 25 2009, Jan Kara wrote:
> > > >   Hi Jens,
> > > > 
> > > >   I've noticed a few more things:
> > > > 
> > > > On Mon 25-05-09 09:34:39, Jens Axboe wrote:
> > > > > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > > > > index 1137408..7cb4d02 100644
> > > > > --- a/fs/fs-writeback.c
> > > > > +++ b/fs/fs-writeback.c
> > > > > @@ -19,6 +19,8 @@
> > > > >  #include <linux/sched.h>
> > > > >  #include <linux/fs.h>
> > > > >  #include <linux/mm.h>
> > > > > +#include <linux/kthread.h>
> > > > > +#include <linux/freezer.h>
> > > > >  #include <linux/writeback.h>
> > > > >  #include <linux/blkdev.h>
> > > > >  #include <linux/backing-dev.h>
> > > > > @@ -61,10 +63,193 @@ int writeback_in_progress(struct backing_dev_info *bdi)
> > > > >   */
> > > > >  static void writeback_release(struct backing_dev_info *bdi)
> > > > >  {
> > > > > -	BUG_ON(!writeback_in_progress(bdi));
> > > > > +	WARN_ON_ONCE(!writeback_in_progress(bdi));
> > > > > +	bdi->wb_arg.nr_pages = 0;
> > > > > +	bdi->wb_arg.sb = NULL;
> > > > >  	clear_bit(BDI_pdflush, &bdi->state);
> > > > >  }
> > > > >  
> > > > > +int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
> > > > > +			 long nr_pages, enum writeback_sync_modes sync_mode)
> > > > > +{
> > > > > +	/*
> > > > > +	 * This only happens the first time someone kicks this bdi, so put
> > > > > +	 * it out-of-line.
> > > > > +	 */
> > > > > +	if (unlikely(!bdi->task)) {
> > > > > +		bdi_add_default_flusher_task(bdi);
> > > > > +		return 1;
> > > > > +	}
> > > > > +
> > > > > +	if (writeback_acquire(bdi)) {
> > > > > +		bdi->wb_arg.nr_pages = nr_pages;
> > > > > +		bdi->wb_arg.sb = sb;
> > > > > +		bdi->wb_arg.sync_mode = sync_mode;
> > > > > +		/*
> > > > > +		 * make above store seen before the task is woken
> > > > > +		 */
> > > > > +		smp_mb();
> > > > > +		wake_up(&bdi->wait);
> > > > > +	}
> > > >   Hmm, wouldn't the interface be more useful if we could just pass down the
> > > > whole writeback_control to the flusher threads?
> > > 
> > > Yeah, that's what the later patch does too, when support for > 1 thread
> > > has been added.
> >   Really? I cannot see it in the series. I see that later you introduce
> > struct bdi_work but it still contains just nr_pages, sb_data and sync_mode.
> > What I meant was we could include 'struct writeback_control' into the bdi
> > (or bdi_work later) and just pass it down so that caller can have more
> > finegrained control of what writeback the thread is going to perform
> > (like nonblocking, older_than_this, maybe something else).
> 
> Oh, I don't pass wbc down, but I do pass it async. The problem with
> passing down the wbc is that it is allocated on the stack. So if we do
> that, then we pretty much have to serialize on that. And I want to avoid
> that.
  I see. OK, let's leave it as it is for now. If we find it's really needed,
we should be able to handle this later (by copying the structure from the
stack into dynamically allocated memory or so).

> > > > >  void generic_sync_sb_inodes(struct super_block *sb,
> > > > >  				struct writeback_control *wbc)
> > > > >  {
> > > > > -	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
> > > > > -	struct backing_dev_info *bdi;
> > > > > -
> > > > > -	mutex_lock(&bdi_lock);
> > > > > -	list_for_each_entry(bdi, &bdi_list, bdi_list)
> > > > > -		generic_sync_bdi_inodes(bdi, wbc, sb, is_blkdev_sb);
> > > > > -	mutex_unlock(&bdi_lock);
> > > > > +	if (wbc->bdi)
> > > > > +		generic_sync_bdi_inodes(sb, wbc);
> > > > > +	else
> > > > > +		bdi_writeback_all(sb, wbc->nr_to_write, wbc->sync_mode);
> > > >   Hmm, you write in the changelog that bdi_writeback_all() writes inline
> > > > now but AFAICS it still happens through the writeback threads. Which, on a
> > > > second though probably *is* what we want because we want writeback to go in
> > > > parallel on all devices we have.
> > > 
> > > Note that this is patch 4, later it is sync. But yes, I think it should
> >   Ah, right. I missed that.
> > 
> > > be async as well, but we do need a way to wait on the submitted work to
> > > be processed in case of WB_SYNC_ALL.
> >   Yes, this is a bit complicated. You'd need some notification bdi_work is
> > processed.
> 
> It was actually not that hard, I already did it. So right now
> wb_writeback() does this:
> 
> while (work) {
>         get args;
>         clear pending;
>         do work;
> };
> 
> If we just modify that to:
> 
> while (work) {
>         get args;
>         if (sync_mode == WB_SYNC_NONE)
>                 clear pending;
>         do work;
>         if (sync_mode == WB_SYNC_ALL)
>                 clear_pending;
> };
> 
> We get notification when the work has actually been issued. Then we can
> easily control whether or not to make a piece of work sync or not.
  OK. That should work.

> > > > >   * Start writeback of `nr_pages' pages.  If `nr_pages' is zero, write back
> > > > >   * the whole world.  Returns 0 if a pdflush thread was dispatched.  Returns
> > > > >   * -1 if all pdflush threads were busy.
> > > > >   */
> > > > > -int wakeup_pdflush(long nr_pages)
> > > > > +void wakeup_flusher_threads(long nr_pages)
> > > > >  {
> > > > >  	if (nr_pages == 0)
> > > > >  		nr_pages = global_page_state(NR_FILE_DIRTY) +
> > > > >  				global_page_state(NR_UNSTABLE_NFS);
> > > > > -	return pdflush_operation(background_writeout, nr_pages);
> > > > > +	bdi_writeback_all(NULL, nr_pages, WB_SYNC_NONE);
> > > > > +	return;
> > > > >  }
> > > > ...
> > > > > -
> > > > > -static void laptop_flush(unsigned long unused)
> > > > > -{
> > > > > -	sys_sync();
> > > > > -}
> > > > > -
> > > > >  static void laptop_timer_fn(unsigned long unused)
> > > > >  {
> > > > > -	pdflush_operation(laptop_flush, 0);
> > > > > +	wakeup_flusher_threads(0);
> > > > >  }
> > > > >  
> > > > >  /*
> > > >   Here you significantly change the behavior of laptop mode - previously it
> > > > reliably synced all the data to disk once the "laptop writeout timeout"
> > > > elapsed. The idea is that we want to write all the dirty data we have so
> > > > that the drive can go to sleep for a longer period.
> > > Yeah I know, I wrote the original laptop mode implementation :-)
> >   Sorry, I wasn't aware of that.
> > 
> > > >   Now you changed that to asynchronous WB_SYNC_NONE writeback of some
> > > > number of pages.  In particular if the disk gets congested, we'll just stop
> > > > doing writeback which probably isn't what we want for laptop mode...
> > > 
> > > Congestion doesn't matter, we don't do nonblocking writeout from the
> > > threads at all. And it is sync later in the series.
> > > 
> > > I'll switch it back to async in general throughout the series, and add
> > > some way of making sure we actually have things submitted before doing
> > > the filemap_fdatawait() in generic_sync_sb_inodes(). I think that should
> > > fix it.
> >   OK, looking forward to your patches :)
> 
> Fiddling with it now, probably a v7 posting coming up tomorrow. And
> thanks again for your great and detailed reviews!

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

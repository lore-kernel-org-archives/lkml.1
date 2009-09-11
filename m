Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZIKHrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZIKHrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZIKHrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:47:21 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45125 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbZIKHrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:47:21 -0400
Date: Fri, 11 Sep 2009 09:47:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 2/8] writeback: move dirty inodes from super_block to
	backing_dev_info
Message-ID: <20090911074723.GF18599@kernel.dk>
References: <1251880967-1136-1-git-send-email-jens.axboe@oracle.com> <1251880967-1136-3-git-send-email-jens.axboe@oracle.com> <20090904025609.GC3658@infradead.org> <20090904065357.GP18599@kernel.dk> <20090904154305.GA10002@infradead.org> <20090906184358.GM18599@kernel.dk> <20090908184442.GB5956@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908184442.GB5956@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08 2009, Christoph Hellwig wrote:
> On Sun, Sep 06, 2009 at 08:43:59PM +0200, Jens Axboe wrote:
> > On Fri, Sep 04 2009, Christoph Hellwig wrote:
> > > On Fri, Sep 04, 2009 at 08:53:57AM +0200, Jens Axboe wrote:
> > > > > +	if (wbc->sync_mode == WB_SYNC_ALL)
> > > > > +		bdi_wait_on_work_clear(&work);
> > > > >  }
> > > > 
> > > > That doesn't work, you have to wait for on-stack work. So either we just
> > > > punt and not do anything for WB_SYNC_NONE if the allocation fails, or we
> > > > punt to stack and do the wait. Since it's a cleaning action and
> > > > allocation fails, falling back to the stack and waiting seems like the
> > > > most appropriate choice.
> > > 
> > > True, the wait needs to be unconditional.  Updated version below.
> > 
> > (did you forget that patch? it's not there).
> 
> Here we go, sorry:

I have applied this to a postmerge writeback branch. I made one change,
though:

> +	if (wbc->sync_mode != WB_SYNC_ALL) {
> +		struct bdi_work *w = bdi_alloc_work(wbc);
> +		if (w) {
> +			bdi_queue_work(wbc->bdi, w);
> +			return;
> +		}

We should make that bdi_queue_work() unconditional, if you want to make
sure that we current thread wakes up and actually flushes some old data
when allocation fails.

void bdi_start_writeback(struct writeback_control *wbc)
{
        /*
         * WB_SYNC_NONE is opportunistic writeback. If this allocation fails,
         * bdi_queue_work() will wake up the thread and flush old data. This
         * should ensure some amount of progress in freeing memory.
         */
        if (wbc->sync_mode != WB_SYNC_ALL) {
                struct bdi_work *w = bdi_alloc_work(wbc);

                bdi_queue_work(wbc->bdi, w);
        } else {
                struct bdi_work work;

                bdi_work_init(&work, wbc);
                work.state |= WS_ONSTACK;

                bdi_queue_work(wbc->bdi, &work);
                bdi_wait_on_work_clear(&work);
        }
}

-- 
Jens Axboe


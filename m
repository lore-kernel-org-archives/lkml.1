Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbZIXIdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbZIXIdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZIXIdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:33:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:48218 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZIXIdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:33:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,444,1249282800"; 
   d="scan'208";a="191123857"
Date: Thu, 24 Sep 2009 16:33:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Chris Mason <chris.mason@oracle.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090924083342.GA15918@localhost>
References: <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think> <1252428983.7746.140.camel@twins> <20090908172842.GC2975@think> <1252431974.7746.151.camel@twins> <1252432501.7746.156.camel@twins> <1252434746.7035.7.camel@laptop> <20090909142315.GA7949@duck.suse.cz> <1252597750.7205.82.camel@laptop> <20090914111721.GA24075@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914111721.GA24075@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 07:17:21PM +0800, Jan Kara wrote:
> On Thu 10-09-09 17:49:10, Peter Zijlstra wrote:
> > On Wed, 2009-09-09 at 16:23 +0200, Jan Kara wrote:
> > >   Well, what I imagined we could do is:
> > > Have a per-bdi variable 'pages_written' - that would reflect the amount of
> > > pages written to the bdi since boot (OK, we'd have to handle overflows but
> > > that's doable).
> > > 
> > > There will be a per-bdi variable 'pages_waited'. When a thread should sleep
> > > in balance_dirty_pages() because we are over limits, it kicks writeback thread
> > > and does:
> > >   to_wait =  max(pages_waited, pages_written) + sync_dirty_pages() (or
> > > whatever number we decide)
> > >   pages_waited = to_wait
> > >   sleep until pages_written reaches to_wait or we drop below dirty limits.
> > > 
> > > That will make sure each thread will sleep until writeback threads have done
> > > their duty for the writing thread.
> > > 
> > > If we make sure sleeping threads are properly ordered on the wait queue,
> > > we could always wakeup just the first one and thus avoid the herding
> > > effect. When we drop below dirty limits, we would just wakeup the whole
> > > waitqueue.
> > > 
> > > Does this sound reasonable?
> > 
> > That seems to go wrong when there's multiple tasks waiting on the same
> > bdi, you'd count each page for 1/n its weight.
> > 
> > Suppose pages_written = 1024, and 4 tasks block and compute their to
> > wait as pages_written + 256 = 1280, then we'd release all 4 of them
> > after 256 pages are written, instead of 4*256, which would be
> > pages_written = 2048.
>   Well, there's some locking needed of course. The intent is to stack
> demands as they come. So in case pages_written = 1024, pages_waited = 1024
> we would do:
> THREAD 1:
> 
> spin_lock
> to_wait = 1024 + 256
> pages_waited = 1280
> spin_unlock
> 
> THREAD 2:
> 
> spin_lock
> to_wait = 1280 + 256
> pages_waited = 1536
> spin_unlock
> 
>   So weight of each page will be kept. The fact that second thread
> effectively waits until the first thread has its demand satisfied looks
> strange at the first sight but we don't do better currently and I think
> it's fine - if they were two writer threads, then soon the thread released
> first will queue behind the thread still waiting so long term the behavior
> should be fair.

Yeah, FIFO queuing should be good enough.

I'd like to propose one more data structure for evaluation :)

- bdi->throttle_lock
- bdi->throttle_list    pages to sync for each waiting task, taken from sync_writeback_pages()
- bdi->throttle_pages   (counted down) pages to sync for the head task, shall be atomic_t

In balance_dirty_pages(), it would do

        nr_to_sync = sync_writeback_pages()
        if (list_empty(bdi->throttle_list))  # I'm the only task
                bdi->throttle_pages = nr_to_sync
        append nr_to_sync to bdi->throttle_list
        kick off background writeback
        wait
        remove itself from bdi->throttle_list and wait list
        set bdi->throttle_pages for new head task (or LONG_MAX)

In __bdi_writeout_inc(), it would do

        if (--bdi->throttle_pages <= 0)
                check and wake up head task

In wb_writeback(), it would do

        if (args->for_background && exiting)
                wake up all throttled tasks

To prevent wake up too many tasks at the same time, it can relax the
background threshold a bit, so that __bdi_writeout_inc() become the
only wake up point in normal cases.

        if (args->for_background && !list_empty(bdi->throttle_list) &&
                over background_thresh - background_thresh / 32)
                keep write pages;

Thanks,
Fengguang


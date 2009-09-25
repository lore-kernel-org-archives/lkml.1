Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbZIYBeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbZIYBeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 21:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZIYBeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 21:34:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:44436 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbZIYBeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 21:34:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,449,1249282800"; 
   d="scan'208";a="191464619"
Date: Fri, 25 Sep 2009 09:33:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090925013350.GD6190@localhost>
References: <1252428983.7746.140.camel@twins> <20090908172842.GC2975@think> <1252431974.7746.151.camel@twins> <1252432501.7746.156.camel@twins> <1252434746.7035.7.camel@laptop> <20090909142315.GA7949@duck.suse.cz> <1252597750.7205.82.camel@laptop> <20090914111721.GA24075@duck.suse.cz> <20090924083342.GA15918@localhost> <1253806696.18939.40.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253806696.18939.40.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 11:38:16PM +0800, Peter Zijlstra wrote:
> On Thu, 2009-09-24 at 16:33 +0800, Wu Fengguang wrote:
> 
> > Yeah, FIFO queuing should be good enough.
> > 
> > I'd like to propose one more data structure for evaluation :)
> > 
> > - bdi->throttle_lock
> > - bdi->throttle_list    pages to sync for each waiting task, taken from sync_writeback_pages()
> > - bdi->throttle_pages   (counted down) pages to sync for the head task, shall be atomic_t
> > 
> > In balance_dirty_pages(), it would do
> > 
> >         nr_to_sync = sync_writeback_pages()
> >         if (list_empty(bdi->throttle_list))  # I'm the only task
> >                 bdi->throttle_pages = nr_to_sync
> >         append nr_to_sync to bdi->throttle_list
> >         kick off background writeback
> >         wait
> >         remove itself from bdi->throttle_list and wait list
> >         set bdi->throttle_pages for new head task (or LONG_MAX)
> > 
> > In __bdi_writeout_inc(), it would do
> > 
> >         if (--bdi->throttle_pages <= 0)
> >                 check and wake up head task
> > 
> > In wb_writeback(), it would do
> > 
> >         if (args->for_background && exiting)
> >                 wake up all throttled tasks

> > To prevent wake up too many tasks at the same time, it can relax the
> > background threshold a bit, so that __bdi_writeout_inc() become the
> > only wake up point in normal cases.
> > 
> >         if (args->for_background && !list_empty(bdi->throttle_list) &&
> >                 over background_thresh - background_thresh / 32)
> >                 keep write pages;

I realized this last change is not necessary, because we already
have a big enough buffer area:

(dirty_thresh + background_thresh)/2  ==> background_thresh

> Right, something like that ought to work well, or at least sounds like
> worth a try ;-)

Thanks :)

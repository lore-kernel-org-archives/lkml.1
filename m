Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbZINLRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbZINLRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 07:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZINLRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 07:17:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:41207 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZINLRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 07:17:22 -0400
Date: Mon, 14 Sep 2009 13:17:21 +0200
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090914111721.GA24075@duck.suse.cz>
References: <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think> <1252428983.7746.140.camel@twins> <20090908172842.GC2975@think> <1252431974.7746.151.camel@twins> <1252432501.7746.156.camel@twins> <1252434746.7035.7.camel@laptop> <20090909142315.GA7949@duck.suse.cz> <1252597750.7205.82.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252597750.7205.82.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 10-09-09 17:49:10, Peter Zijlstra wrote:
> On Wed, 2009-09-09 at 16:23 +0200, Jan Kara wrote:
> >   Well, what I imagined we could do is:
> > Have a per-bdi variable 'pages_written' - that would reflect the amount of
> > pages written to the bdi since boot (OK, we'd have to handle overflows but
> > that's doable).
> > 
> > There will be a per-bdi variable 'pages_waited'. When a thread should sleep
> > in balance_dirty_pages() because we are over limits, it kicks writeback thread
> > and does:
> >   to_wait =  max(pages_waited, pages_written) + sync_dirty_pages() (or
> > whatever number we decide)
> >   pages_waited = to_wait
> >   sleep until pages_written reaches to_wait or we drop below dirty limits.
> > 
> > That will make sure each thread will sleep until writeback threads have done
> > their duty for the writing thread.
> > 
> > If we make sure sleeping threads are properly ordered on the wait queue,
> > we could always wakeup just the first one and thus avoid the herding
> > effect. When we drop below dirty limits, we would just wakeup the whole
> > waitqueue.
> > 
> > Does this sound reasonable?
> 
> That seems to go wrong when there's multiple tasks waiting on the same
> bdi, you'd count each page for 1/n its weight.
> 
> Suppose pages_written = 1024, and 4 tasks block and compute their to
> wait as pages_written + 256 = 1280, then we'd release all 4 of them
> after 256 pages are written, instead of 4*256, which would be
> pages_written = 2048.
  Well, there's some locking needed of course. The intent is to stack
demands as they come. So in case pages_written = 1024, pages_waited = 1024
we would do:
THREAD 1:

spin_lock
to_wait = 1024 + 256
pages_waited = 1280
spin_unlock

THREAD 2:

spin_lock
to_wait = 1280 + 256
pages_waited = 1536
spin_unlock

  So weight of each page will be kept. The fact that second thread
effectively waits until the first thread has its demand satisfied looks
strange at the first sight but we don't do better currently and I think
it's fine - if they were two writer threads, then soon the thread released
first will queue behind the thread still waiting so long term the behavior
should be fair.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

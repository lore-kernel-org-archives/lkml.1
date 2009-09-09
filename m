Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZIIOXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZIIOXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZIIOXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:23:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971AbZIIOXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:23:17 -0400
Date: Wed, 9 Sep 2009 16:23:15 +0200
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       "Theodore Ts'o" <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090909142315.GA7949@duck.suse.cz>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-9-git-send-email-jens.axboe@oracle.com> <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think> <1252428983.7746.140.camel@twins> <20090908172842.GC2975@think> <1252431974.7746.151.camel@twins> <1252432501.7746.156.camel@twins> <1252434746.7035.7.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252434746.7035.7.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 08-09-09 20:32:26, Peter Zijlstra wrote:
> On Tue, 2009-09-08 at 19:55 +0200, Peter Zijlstra wrote:
> > 
> > I think I'm somewhat confused here though..
> > 
> > There's kernel threads doing writeout, and there's apps getting stuck in
> > balance_dirty_pages().
> > 
> > If we want all writeout to be done by kernel threads (bdi/pd-flush like
> > things) then we still need to manage the actual apps and delay them.
> > 
> > As things stand now, we kick pdflush into action when dirty levels are
> > above the background level, and start writing out from the app task when
> > we hit the full dirty level.
> > 
> > Moving all writeout to a kernel thread sounds good from writing linear
> > stuff pov, but what do we make apps wait on then?
> 
> OK, so like said in the previous email, we could have these app tasks
> simply sleep on a waitqueue which gets periodic wakeups from
> __bdi_writeback_inc() every time the dirty threshold drops.
> 
> The woken tasks would then check their bdi dirty limit (its task
> dependent) against the current values and either go back to sleep or
> back to work.
  Well, what I imagined we could do is:
Have a per-bdi variable 'pages_written' - that would reflect the amount of
pages written to the bdi since boot (OK, we'd have to handle overflows but
that's doable).

There will be a per-bdi variable 'pages_waited'. When a thread should sleep
in balance_dirty_pages() because we are over limits, it kicks writeback thread
and does:
  to_wait =  max(pages_waited, pages_written) + sync_dirty_pages() (or
whatever number we decide)
  pages_waited = to_wait
  sleep until pages_written reaches to_wait or we drop below dirty limits.

That will make sure each thread will sleep until writeback threads have done
their duty for the writing thread.

If we make sure sleeping threads are properly ordered on the wait queue,
we could always wakeup just the first one and thus avoid the herding
effect. When we drop below dirty limits, we would just wakeup the whole
waitqueue.

Does this sound reasonable?

> The only problem would be the mass wakeups when lots of tasks are
> blocked on dirty, but I'm guessing there's no way around that anyway,
> and its better to have a limited number of writers than have everybody
> write something, which would result in massive write fragmentation.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

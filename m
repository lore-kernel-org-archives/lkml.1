Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbZIYGpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbZIYGpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 02:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZIYGpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 02:45:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:8411 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbZIYGpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 02:45:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,450,1249282800"; 
   d="scan'208";a="191532538"
Date: Fri, 25 Sep 2009 14:45:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090925064503.GA30450@localhost>
References: <20090922182832.28e7f73a.akpm@linux-foundation.org> <20090923014500.GA11076@localhost> <20090922185941.1118e011.akpm@linux-foundation.org> <20090923022622.GB11918@localhost> <20090922193622.42c00012.akpm@linux-foundation.org> <20090923140058.GA2794@think> <20090924031508.GD6456@localhost> <20090925001117.GA9464@discord.disaster> <20090925003820.GK2662@think> <20090925050413.GC9464@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925050413.GC9464@discord.disaster>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 01:04:13PM +0800, Dave Chinner wrote:
> On Thu, Sep 24, 2009 at 08:38:20PM -0400, Chris Mason wrote:
> > On Fri, Sep 25, 2009 at 10:11:17AM +1000, Dave Chinner wrote:
> > > On Thu, Sep 24, 2009 at 11:15:08AM +0800, Wu Fengguang wrote:
> > > > On Wed, Sep 23, 2009 at 10:00:58PM +0800, Chris Mason wrote:
> > > > > The only place that actually honors the congestion flag is pdflush.
> > > > > It's trivial to get pdflush backed up and make it sit down without
> > > > > making any progress because once the queue congests, pdflush goes away.
> > > > 
> > > > Right. I guess that's more or less intentional - to give lowest priority
> > > > to periodic/background writeback.
> > > 
> > > IMO, this is the wrong design. Background writeback should
> > > have higher CPU/scheduler priority than normal tasks. If there is
> > > sufficient dirty pages in the system for background writeback to
> > > be active, it should be running *now* to start as much IO as it can
> > > without being held up by other, lower priority tasks.
> > 
> > I'd say that an fsync from mutt or vi should be done at a higher prio
> > than a background streaming writer.
> 
> I don't think you caught everything I said - synchronous IO is
> un-throttled.

O_SYNC writes may be un-throttled in theory, however it seems to be
throttled in practice:

  generic_file_aio_write
    __generic_file_aio_write
      generic_file_buffered_write
        generic_perform_write
          balance_dirty_pages_ratelimited
    generic_write_sync

Do you mean some other code path?

> Background writeback should dump async IO to the elevator as fast as
> it can, then get the hell out of the way. If you've got a UP system,
> then the fsync can't be issued at the same time pdflush is running
> (same as right now), and if you've got a MP system then fsync can
> run at the same time.

I think you are right for system wide sync.

System wide sync seems to always wait for the queued bdi writeback
works to finish, which should be fine in terms of efficiency, except
that sync could end up do more works and even live lock.

> On the premise that sync IO is unthrottled and given that elevators
> queue and issue sync IO sperately to async writes, fsync latency
> would be entirely derived from the elevator queuing behaviour, not
> the CPU priority of pdflush.

It's not exactly CPU priority, but queue fullness priority.

fsync operations always use nonblocking=0, so in fact they _used to_
enjoy better priority than pdflush. Same is vmscan pageout, which
calls writepage directly. Both won't back off on congested bdi.

So when there comes fsync/pageout, they will always be served first.

> Look at it this way - it is the responsibility of pdflush to keep
> the elevator full of background IO. It is the responsibility of
> the elevator to ensure that background IO doesn't starve all other
> types of IO.

Agreed.

> If pdflush doesn't run because it can't get CPU time,
> then background IO does not get issued, and system performance
> suffers as a result.

pdflush is able to make 80% queue fullness, which should be enough
for efficient streaming IOs. Small random IOs may hurt a bit though.

Thanks,
Fengguang

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZIZBrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZIZBrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 21:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZIZBrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 21:47:49 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:58678 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750946AbZIZBrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 21:47:48 -0400
Date: Sat, 26 Sep 2009 11:47:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090926014715.GD9464@discord.disaster>
References: <20090923011758.GC6382@localhost> <20090922182832.28e7f73a.akpm@linux-foundation.org> <20090923014500.GA11076@localhost> <20090922185941.1118e011.akpm@linux-foundation.org> <20090923022622.GB11918@localhost> <20090922193622.42c00012.akpm@linux-foundation.org> <20090923140058.GA2794@think> <20090924031508.GD6456@localhost> <20090925001117.GA9464@discord.disaster> <20090925031920.GB10487@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090925031920.GB10487@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 11:19:20AM +0800, Wu Fengguang wrote:
> On Fri, Sep 25, 2009 at 08:11:17AM +0800, Dave Chinner wrote:
> > On Thu, Sep 24, 2009 at 11:15:08AM +0800, Wu Fengguang wrote:
> > > On Wed, Sep 23, 2009 at 10:00:58PM +0800, Chris Mason wrote:
> > > > The only place that actually honors the congestion flag is pdflush.
> > > > It's trivial to get pdflush backed up and make it sit down without
> > > > making any progress because once the queue congests, pdflush goes away.
> > > 
> > > Right. I guess that's more or less intentional - to give lowest priority
> > > to periodic/background writeback.
> > 
> > IMO, this is the wrong design. Background writeback should
> > have higher CPU/scheduler priority than normal tasks. If there is
> > sufficient dirty pages in the system for background writeback to
> > be active, it should be running *now* to start as much IO as it can
> > without being held up by other, lower priority tasks.
> > 
> > Cleaning pages is important to keeping the system running smoothly.
> > Given that IO takes time to clean pages, it is therefore important
> > to issue as much as possible as quickly as possible without delays
> > before going back to sleep. Delaying issue of the IO or doing
> > sub-optimal issue simply reduces performance of the system because
> > it takes longer to clean the same number of dirty pages.
> > 
> > > > Nothing stops other procs from keeping the queue congested forever.
> > > > This can only be fixed by making everyone wait for congestion, at which
> > > > point we might as well wait for requests.
> > > 
> > > Yes. That gives everyone somehow equal opportunity, this is a policy change
> > > that may lead to interesting effects, as well as present a challenge to
> > > get_request_wait(). That said, I'm not against the change to a wait queue
> > > in general.
> > 
> > If you block all threads doing _writebehind caching_ (synchronous IO
> > is self-throttling) to the same BDI on the same queue as the bdi
> > flusher then when congestion clears the higher priority background
> > flusher thread should run first and issue more IO.  This should
> > happen as a natural side-effect of our scheduling algorithms and it
> > gives preference to efficient background writeback over in-efficient
> > foreground writeback. Indeed, with this approach we can even avoid
> > foreground writeback altogether...
> 
> I don't see how balance_dirty_pages() writeout is less efficient than
> pdflush writeout.
> 
> They all called the same routines to do the job.
> balance_dirty_pages() sets nr_to_write=1536 at least for ext4 and xfs
> (unless memory is tight; btrfs is 1540), which is in fact 50% bigger
> than the 1024 pages used by pdflush.

Sure, but the prёblem now is that you are above the
bdi->dirty_exceeded threshold, foreground writeback tries to issue
1536 pages of IO every 8 pages that are dirtied. That means you'll
block just about every writing process in writeback at the same time
and they will all be blocked in congestion trying to write different
inodes....

> And it won't back off on congestion.

And that is, IMO, a major problem.

> The s_io/b_io queues are shared, so a balance_dirty_pages() will just
> continue from where the last sync thread exited. So it does not make
> much difference who initiates the IO. Did I missed something?

The current implementation uses the request queue to do that
blocking at IO submission time. This is based on the premise that if
we write a certain number of pages, we're guaranteed to have waited
long enough for that many pages to come clean. However, every other
thread doing writes and being throttled does the same thing.  This
leads to N IO submitters from at least N different inodes at the
same time. Which inode gets written when congestion clears is
anyone's guess - it's a thundering herd IIUC the congestion
implementation correctly.

The result is that we end up with N different sets of IO being
issued with potentially zero locality to each other, resulting in
much lower elevator sort/merge efficiency and hence we seek the disk
all over the place to service the different sets of IO.

OTOH, if there is only one submission thread, it doesn't jump
between inodes in the same way when congestion clears - if keeps
writing to the same inode, resulting in large related chunks of
sequential IOs being issued to the disk. This is more efficient than
the above foreground writeback because the elevator works better and
the disk seeks less.

As you can probably guess, I think foreground writeout is the wrong
architecture because of the behaviour it induces under heavy
multithreaded IO patterns. I agree that it works OK if continue
tweaking it to fix problems.

However, my concern is that if it isn't constantly observed, tweaked
and maintained, performance goes backwards as other code changes.
i.e. there is a significant maintenance burden and looking at the
problems once very couple of years (last big maintenance rounds were
2.6.15/16, 2.6.23/24, now 2.6.31/32) isn't good enough to prevent
performance form sliding backwards from release to release.

----

The rest of this is an idea I've been kicking around for a while
which is derived from IO throttling work I've done during a
past life.  I haven't had time to research and prototype it to see
if it performs any better under really heavy load, but I'm going to
throw it out anyway so that everyone can see a little bit more about
what I'm thinking.

My fundamental premise is that throttling does not require IO to be
issued from the thread to be throttled. The essence of write
throttling is waiting for more pages to be cleaned in a period of
time than has been dirtied. i.e.  What we are really waiting on is
pages to be cleaned.

Based on this observation, if we have a flusher thread working in
the background, we don't need to submit more IO when we need to
throttle as all we need to do is wait for a certain number of pages
to transition to the clean state.

If we take a leaf from XFS's book by doing work at IO completion
rather than submission we can keep a count of the number of pages
cleaned on the bdi. This can be used to implement a FIFO-like
throttle. If we add a simple ticket system to the bdi, when a
process needs to be throttled it can submit a ticket with the number
of pages it has dirtied to the bdi, and the bdi can then decide what
the page cleaned count needs to reach before the process can be
woken.

i.e. Take the following ascii art showing the bdi fllusher
thread running and issuing IO in the background:

bdi write thread:   +---X------Y---+-A-----ZB----+------C--------+
1st proc:		o............o
2nd proc:		       o............o
3rd proc:		                   o............o

When the 1st process comes in to be throttled, it samples the page
clean count and gets X. It submits a ticket to be woken at A (X +
some number of pages). If the flusher thread is not running, it gets
kicked.  Process 2 and 3 do the same at Y and Z to be woken at B and
C. At IO completion, the number of pages cleaned is counted and the
tickets that are now under the clean count are pulled from the queue
and the processes that own them are woken.

This avoids the thundering herd problem and applies throttling in
a deterministic, predictable fashion. And by relying on background
writeback, we only have one writeback path to optimise, not two
different paths that interchange unpredictably.

In essence, this mechanism replaces the complex path of IO
submission and congestion with a simple, deterministic counter and
queue system that probably doesn't even require any memory
allocation to implement. I think the simpler a thorttle mechanism
is the more likely it is to work effectively....

I know that words without code aren't going to convince anyone, but I
hope I've given you some food for thought about alternatives to what
we currently do. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

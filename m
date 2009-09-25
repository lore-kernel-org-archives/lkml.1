Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbZIYMGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbZIYMGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 08:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZIYMGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 08:06:46 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:27734 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZIYMGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 08:06:45 -0400
Date: Fri, 25 Sep 2009 08:06:08 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090925120608.GA15216@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Li, Shaohua" <shaohua.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
	"jens.axboe@oracle.com" <jens.axboe@oracle.com>
References: <20090922182832.28e7f73a.akpm@linux-foundation.org>
 <20090923014500.GA11076@localhost>
 <20090922185941.1118e011.akpm@linux-foundation.org>
 <20090923022622.GB11918@localhost>
 <20090922193622.42c00012.akpm@linux-foundation.org>
 <20090923140058.GA2794@think>
 <20090924031508.GD6456@localhost>
 <20090925001117.GA9464@discord.disaster>
 <20090925003820.GK2662@think>
 <20090925050413.GC9464@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925050413.GC9464@discord.disaster>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4ABCB23A.0025:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 03:04:13PM +1000, Dave Chinner wrote:
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
> un-throttled. Background writeback should dump async IO to the
> elevator as fast as it can, then get the hell out of the way. If
> you've got a UP system, then the fsync can't be issued at the same
> time pdflush is running (same as right now), and if you've got a MP
> system then fsync can run at the same time. On the premise that sync
> IO is unthrottled and given that elevators queue and issue sync IO
> sperately to async writes, fsync latency would be entirely derived
> from the elevator queuing behaviour, not the CPU priority of
> pdflush.

I think we've agreed for a long time on this in general.  The congestion
backoff comment was originally about IO priorities (I thought ;) so I
was trying to keep talking around IO priority and not CPU/scheduler
time.  When we get things tuned to the point that process scheduling
matters, I'll be a very happy boy.

The big change from the new code is that we will fill the queue
with async IO.

I think this is good, and I think the congestion backoff didn't really
consistently keep available requests in the queue all the time in a lot
of workloads.  But, its still a change, and so we need to keep an eye on
it as we look at performance reports during .32.

> 
> Look at it this way - it is the responsibility of pdflush to keep
> the elevator full of background IO. It is the responsibility of
> the elevator to ensure that background IO doesn't starve all other
> types of IO. If pdflush doesn't run because it can't get CPU time,
> then background IO does not get issued, and system performance
> suffers as a result.

Most of the time that pdflush didn't get to run in my benchmark it's
because pdflush chose to give up the CPU, not because it was starving.

-chris


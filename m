Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbXITVa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbXITVa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXITVas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:30:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41480 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754937AbXITVap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:30:45 -0400
Date: Thu, 20 Sep 2007 14:29:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Matthias Hensler <matthias@wspse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       richard kennedy <richard@rsk.demon.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
Message-Id: <20070920142927.d87ab5af.akpm@linux-foundation.org>
In-Reply-To: <46F2E103.8000907@redhat.com>
References: <46B10BB7.60900@redhat.com>
	<20070803113407.0b04d44e.akpm@linux-foundation.org>
	<20070804084426.GA20464@kobayashi-maru.wspse.de>
	<20070809095943.GA7763@kobayashi-maru.wspse.de>
	<20070809095534.25ae1c42.akpm@linux-foundation.org>
	<46F2E103.8000907@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 17:07:15 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> On 08/09/2007 12:55 PM, Andrew Morton wrote:
> > On Thu, 9 Aug 2007 11:59:43 +0200 Matthias Hensler <matthias@wspse.de> wrote:
> > 
> >> On Sat, Aug 04, 2007 at 10:44:26AM +0200, Matthias Hensler wrote:
> >>> On Fri, Aug 03, 2007 at 11:34:07AM -0700, Andrew Morton wrote:
> >>> [...]
> >>> I am also willing to try the patch posted by Richard.
> >> I want to give some update here:
> >>
> >> 1. We finally hit the problem on a third system, with a total different
> >>    setup and hardware. However, again high I/O load caused the problem
> >>    and the affected filesystems were mounted with noatime.
> >>
> >> 2. I installed a recompiled kernel with just the two line patch from
> >>    Richard Kennedy (http://lkml.org/lkml/2007/8/2/89). That system has 5
> >>    days uptime now and counting. I believe the patch fixed the problem.
> >>    However, I will continue running "vmstat 1" and the endless loop of
> >>    "cat /proc/meminfo", just in case I am wrong.
> >>
> > 
> > Did we ever see the /proc/meminfo and /proc/vmstat output during the stall?
> > 
> > If Richard's patch has indeed fixed it then this confirms that we're seeing
> > contention over the dirty-memory limits.  Richard's patch isn't really the
> > right one because it allows unlimited dirty-memory windup in some situations
> > (large number of disks with small writes, or when we perform queue congestion
> > avoidance).
> > 
> > As you're seeing this happening when multiple disks are being written to it is
> > possible that the per-device-dirty-threshold patches which recently went into
> > -mm (and which appear to have a bug) will fix it.
> > 
> > But I worry that the stall appears to persist *forever*.  That would indicate
> > that we have a dirty-memory accounting leak, or that for some reason the
> > system has decided to stop doing writeback to one or more queues (might be
> > caused by an error in a lower-level driver's queue congestion state management).
> > 
> > If it is the latter, then it could be that running "sync" will clear the
> > problem.  Temporarily, at least.  Because sync will ignore the queue congestion
> > state.
> > 
> 
> This is still a problem for people, and no fix is in sight until 2.6.24.

Any bugzilla urls or anything like that?

> Can we get some kind of band-aid, like making the endless 'for' loop in
> balance_dirty_pages() terminate after some number of iterations? Clearly
> if we haven't written "write_chunk" pages after a few tries, *and* we
> haven't encountered congestion, there's no point in trying forever...

Did my above questions get looked at?

Is anyone able to reproduce this?

Do we have a clue what's happening?

Is that function just spinning around, failing to start writeout against
any pages at all?  If so, how come?


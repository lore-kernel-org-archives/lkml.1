Return-Path: <linux-kernel-owner+w=401wt.eu-S933434AbZGPV0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434AbZGPV0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 17:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933425AbZGPV0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 17:26:08 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:1808 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933398AbZGPV0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 17:26:07 -0400
Date: Thu, 16 Jul 2009 17:26:03 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Noah Watkins <jayhawk@soe.ucsc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Message-ID: <20090716212603.GB27757@cs.fsu.edu>
References: <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <1247505941.7500.39.camel@twins> <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu> <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com> <20090715231109.GH14993@cs.fsu.edu> <4A5F448C.2050909@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5F448C.2050909@nortel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 09:17:32AM -0600, Chris Friesen wrote:

> If a high-priority task A makes a syscall that requires a lock currently
> held by a sleeping low-priority task C, and there is a medium priority B
> task that wants to run, the classic scenario for priority inversion has
> been achieved.

I think you don't really mean "sleeping" low-priority task C,
since then the priority inheritance would do no good.  I guess you
mean that C has been/is preempted by B (and for global SMP, there
is some other medicum priority task B' that is eligible to run on
A's processor).  That could be a priority inversion scenario.

BTW, if migration is allowed the probability of this kind of thing
(and hence the payoff for PIP) goes down rapidly with the number
of processors.

> I know of at least one example with millions of lines of code being
> ported to linux from another OS.  The scheduling requirements are fairly
> lax but deadlock due to priority inversion is a highly likely.  They
> compare PI and PP, see that PP requires up-front analysis, so they
> enable PI.
> 
> I suspect there are other similar cases where deadlock is the real
> issue, and hard realtime isn't a concern (but low latency may be
> desirable).  PI is simple to enable and doesn't require any thought on
> the part of the app writer.

I'm confused by your reference to deadlock.  Priority inheritance
does not prevent deadlock, even on a single processor.

> At least for POSIX, both PI and PP mutexes can suspend while the lock is
> held.  From the user's point of view, the only difference between the
> two is that PP bumps the lock holder's priority always, while PI bumps
> the priority only if/when necessary.

You are right that POSIX missed the point of priority ceilings,
by allowing suspension.

However, there is still a difference in context-switching
overhead.  Worst-case, you have twice as many context switches
per critical section with PIP as with PP.

In any case, for a multiprocessor, PP is not enough.  






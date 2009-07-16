Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbZGPWJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbZGPWJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933450AbZGPWJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:09:33 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:56996 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933444AbZGPWJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:09:33 -0400
Message-ID: <4A5FA4EF.6000506@nortel.com>
Date: Thu, 16 Jul 2009 16:08:47 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ted Baker <baker@cs.fsu.edu>
CC: Noah Watkins <jayhawk@soe.ucsc.edu>,
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
References: <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <1247505941.7500.39.camel@twins> <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu> <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com> <20090715231109.GH14993@cs.fsu.edu> <4A5F448C.2050909@nortel.com> <20090716212603.GB27757@cs.fsu.edu>
In-Reply-To: <20090716212603.GB27757@cs.fsu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2009 22:08:49.0488 (UTC) FILETIME=[FF18A500:01CA0661]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Baker wrote:
> On Thu, Jul 16, 2009 at 09:17:32AM -0600, Chris Friesen wrote:
> 
>> If a high-priority task A makes a syscall that requires a lock currently
>> held by a sleeping low-priority task C, and there is a medium priority B
>> task that wants to run, the classic scenario for priority inversion has
>> been achieved.
> 
> I think you don't really mean "sleeping" low-priority task C,
> since then the priority inheritance would do no good.  I guess you
> mean that C has been/is preempted by B (and for global SMP, there
> is some other medicum priority task B' that is eligible to run on
> A's processor).  That could be a priority inversion scenario.

My terminology is getting sloppy.  Yes, I meant preempted.

>> I suspect there are other similar cases where deadlock is the real
>> issue, and hard realtime isn't a concern (but low latency may be
>> desirable).  PI is simple to enable and doesn't require any thought on
>> the part of the app writer.
> 
> I'm confused by your reference to deadlock.  Priority inheritance
> does not prevent deadlock, even on a single processor.

Sloppy terminology again.  Priority inversion.  If all apps are
soft-realtime and B is a pure cpu hog (which can effectively happen on
heavily loaded server systems) then A will never get to run.

>> At least for POSIX, both PI and PP mutexes can suspend while the lock is
>> held.  From the user's point of view, the only difference between the
>> two is that PP bumps the lock holder's priority always, while PI bumps
>> the priority only if/when necessary.
> 
> You are right that POSIX missed the point of priority ceilings,
> by allowing suspension.

The vast majority of apps written for Linux are POSIX apps, so for this
discussion we need to bear that behaviour in mind.

> However, there is still a difference in context-switching
> overhead.  Worst-case, you have twice as many context switches
> per critical section with PIP as with PP.

On the other hand, with PI the uncontended case can be implemented as
atomic operations in userspace.  With PP we need to issue at least two
syscalls per lock/unlock cycle even in the uncontended case (to handle
the priority manipulations).

Chris


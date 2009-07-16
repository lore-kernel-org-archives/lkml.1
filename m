Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbZGPPRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbZGPPRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932413AbZGPPRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:17:45 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:61885 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404AbZGPPRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:17:44 -0400
Message-ID: <4A5F448C.2050909@nortel.com>
Date: Thu, 16 Jul 2009 09:17:32 -0600
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
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <1247505941.7500.39.camel@twins> <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu> <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com> <20090715231109.GH14993@cs.fsu.edu>
In-Reply-To: <20090715231109.GH14993@cs.fsu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2009 15:17:35.0342 (UTC) FILETIME=[8C28C0E0:01CA0628]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Baker wrote:
> On Mon, Jul 13, 2009 at 03:45:11PM -0600, Chris Friesen wrote:
> 
>> Given that the semantics of POSIX PI locking assumes certain scheduler
>> behaviours, is it actually abstraction inversion to have that same
>> dependency expressed in the kernel code that implements it?
> ...> 
>> The whole point of mutexes (and semaphores) within the linux kernel is
>> that it is possible to block while holding them.  I suspect you're going
>> to find it fairly difficult to convince people to spinlocks just to make
>> it possible to provide latency guarantees.
> 
> The abstraction inversion is when the kernel uses (internally)
> something as complex as a POSIX PI mutex.  So, I'm not arguing
> that the kernel does not need internal mutexes/semaphores that
> can be held while a task is suspended/blocked.  I'm just arguing
> that those internal mutexes/semaphores should not be PI ones.

This ties back to your other message with the comment about implementing
userspace PI behaviour via some simpler "loopholes".

If the application is already explicitly relying on PI pthread mutexes
(possibly because it hasn't got enough knowledge of itself to do PP or
to design the priorities in such a way that inversion isn't a problem)
then presumably priority inversion in the kernel itself will also be an
issue.

If a high-priority task makes a syscall that requires a lock currently
held by a sleeping low-priority task, and there is a medium priority
task that wants to run, the classic scenario for priority inversion has
been achieved.

>> On the other hand, PP requires code analysis to properly set the
>> ceilings for each individual mutex.
> 
> Indeed, this is difficult, but no more difficult than estimating
> worst-case blocking times, which requires more extensive code
> analysis and requires consideration of more cases with PI than PP.

I know of at least one example with millions of lines of code being
ported to linux from another OS.  The scheduling requirements are fairly
lax but deadlock due to priority inversion is a highly likely.  They
compare PI and PP, see that PP requires up-front analysis, so they
enable PI.

I suspect there are other similar cases where deadlock is the real
issue, and hard realtime isn't a concern (but low latency may be
desirable).  PI is simple to enable and doesn't require any thought on
the part of the app writer.


>> Certainly if you block waiting for I/O while holding a lock then it
>> impacts the ability to provide latency guarantees for others waiting for
>> that lock.  But this has nothing to do with PI vs PP or spinlocks, and
>> everything to do with how the lock is actually used.
> 
> My only point there was with respect to application-level use of
> POSIX mutexes, that if an application needs to suspend while
> holding a mutex (e.g., for I/O) then the application will have
> potentially unbounded priority inversion, and so is losing the
> benefit from priority inheritance.  So, if the only benefit of
> PRIO_INHERIT over PRIO_PROTECT is being able to suspend while
> holding a lock, there is no real benefit.  

At least for POSIX, both PI and PP mutexes can suspend while the lock is
held.  From the user's point of view, the only difference between the
two is that PP bumps the lock holder's priority always, while PI bumps
the priority only if/when necessary.

Chris

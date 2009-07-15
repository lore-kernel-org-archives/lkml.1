Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbZGOXjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbZGOXjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 19:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZGOXjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 19:39:43 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:5861 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752269AbZGOXjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 19:39:42 -0400
Date: Wed, 15 Jul 2009 19:11:09 -0400
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
Message-ID: <20090715231109.GH14993@cs.fsu.edu>
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <1247505941.7500.39.camel@twins> <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu> <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5BAAE7.5020906@nortel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 03:45:11PM -0600, Chris Friesen wrote:

> Given that the semantics of POSIX PI locking assumes certain scheduler
> behaviours, is it actually abstraction inversion to have that same
> dependency expressed in the kernel code that implements it?
...> 
> The whole point of mutexes (and semaphores) within the linux kernel is
> that it is possible to block while holding them.  I suspect you're going
> to find it fairly difficult to convince people to spinlocks just to make
> it possible to provide latency guarantees.

The abstraction inversion is when the kernel uses (internally)
something as complex as a POSIX PI mutex.  So, I'm not arguing
that the kernel does not need internal mutexes/semaphores that
can be held while a task is suspended/blocked.  I'm just arguing
that those internal mutexes/semaphores should not be PI ones.

> ...  the selling point for PI vs PP is that under PIP the
> priority of the lock holder is automatically boosted only if
> necessary, and only as high as necessary.

The putative benefit of this is disputed, as shown by Jim and
Bjorn's work with LITMUS-RT and others.  For difference to be
noted, there must be a lot of contention, and long critical
sections.  The benefit of less frequent priority boosting and
lower priorities can be balanced by more increased worst-case
number of context switches.

> On the other hand, PP requires code analysis to properly set the
> ceilings for each individual mutex.

Indeed, this is difficult, but no more difficult than estimating
worst-case blocking times, which requires more extensive code
analysis and requires consideration of more cases with PI than PP.

If determining the exact ceiling is too difficult.  one can simply
set the ceiling to the maximum priority used by the application.

Again, I don't think that either PP or PI is appropriate for use
in a (SMP) kernel. For non-blocking locks, the current
no-preeemption spinlock mechanism works.  For higher-level
(blocking) locks, I'm attracted to Jim Anderson's model of
non-preemptable critical sections, combined with FIFO queue
service.

> Certainly if you block waiting for I/O while holding a lock then it
> impacts the ability to provide latency guarantees for others waiting for
> that lock.  But this has nothing to do with PI vs PP or spinlocks, and
> everything to do with how the lock is actually used.

My only point there was with respect to application-level use of
POSIX mutexes, that if an application needs to suspend while
holding a mutex (e.g., for I/O) then the application will have
potentially unbounded priority inversion, and so is losing the
benefit from priority inheritance.  So, if the only benefit of
PRIO_INHERIT over PRIO_PROTECT is being able to suspend while
holding a lock, there is no real benefit.  

Ted

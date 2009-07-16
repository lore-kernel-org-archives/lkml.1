Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786AbZGPHRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbZGPHRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZGPHRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:17:30 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:49599 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZGPHR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:17:28 -0400
From: Henrik Austad <henrik@austad.us>
To: Ted Baker <baker@cs.fsu.edu>
Date: Thu, 16 Jul 2009 09:17:09 +0200
User-Agent: KMail/1.9.10
Cc: Chris Friesen <cfriesen@nortel.com>, Raistlin <raistlin@linux.it>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
References: <200907102350.47124.henrik@austad.us> <4A5CCD5A.80108@nortel.com> <20090715221410.GE14993@cs.fsu.edu>
In-Reply-To: <20090715221410.GE14993@cs.fsu.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907160917.10098.henrik@austad.us>
X-SA-Exim-Connect-IP: 2001:700:1:21:21d:e0ff:fe55:5a61
X-SA-Exim-Mail-From: henrik@austad.us
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on asterix.frsk.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 July 2009 00:14:11 Ted Baker wrote:
> On Tue, Jul 14, 2009 at 12:24:26PM -0600, Chris Friesen wrote:
> > > - that A's budget is not diminished.
> >
> > If we're running B with A's priority, presumably it will get some amount
> > of cpu time above and beyond what it would normally have gotten during a
> > particular scheduling interval.  Perhaps it would make sense to charge B
> > what it would normally have gotten, and charge the excess amount to A?
>
> First, why will B get any excess time, if is charged?

My understanding of PEP is that when B executes through the A-proxy, B will 
consume parts of A's resources until the lock is freed. This makes sense when 
A and B runs on different CPUs and B is moved (temporarily) to CPU#A. If B 
were to use it's own budget when running here, once A resumes execution and 
exhaustes its entire budget, you can have over-utilization on that CPU (and 
under-util on CPU#B).

> There will 
> certainly be excess time used in any context switch, including
> premptions and blocking/unblocking for locks, but that will come
> out of some task's budget. 

AFAIK, there are no such things as preemption-overhead charging to a task's 
budget in the kernel today. This time simply vanishes and must be compensated 
for when running a task through the acceptance-stage (say, only 95% util pr 
CPU or some such).

> Given the realities of the scheduler, 
> the front-end portion of the context-switch will be charged to the
> preempted or blocking task, and the back-end portion of the
> context-switch cost will be charged to the task to which the CPU
> is switched.  

> In a cross-processor proxy situation like the one 
> above we have four switches: (1) from A to C on processor #1; (2)
> from whatever else (call it D) that was running on processor #2 to
> B, when B receives A's priority; (3) from B back to D when B
> releasse the lock; (4) from C to A when A gets the lock.  A will
> naturally be charged for the front-end cost of (1) and the
> back-end cost of (4), and B will naturally be charged for the
> back-end cost of (2) and the front-end cost of (3).
>
> The budget of each task must be over-provisioned enough to
> allow for these additional costs.  This is messy, but seems
> unavoidable, and is an important reason for using scheduling
> policies that minimize context switches.
>
> Back to the original question, of who should be charged for
> the actual critical section.

That depends on where you want to run the tasks. If you want to migrate B to 
CPU#A, A should be charged. If you run B on CPU#B, then B should be charged 
(for the exact same reasoning A should be charged in the first case).

The beauty of PEP, is that enabling B to run is very easy. In the case where B 
runs on CPU#B, B must be updated statically so that the scheduler will 
trigger on the new priority. In PEP, this is done automatically when A is 
picked. One solution to this, would be to migrate A to CPU#B and insert A 
into the runqueue there. However, then you add more overhead by moving the 
task around instead of just 'borrowing' the task_struct.

> From the schedulability analysis point of view, B is getting
> higher priority time than it normally would be allowed to execute,
> potentially causing priority inversion (a.k.a. "interference" or
> "blocking") to a higher priority task D (which does not even share
> a need for the lock that B is holding) that would otherwise run on
> the same processor as B.  Without priority inheritance this kind
> of interferfence would not happen.  So, we are benefiting A at the
> expense of D. In the analysis, we can either allow for all such
> interference in a "blocking term" in the analysis for D, or we
> might call it "preemption" in the analysis of D and charge it to A
> (if A has higher priority than D).  Is the latter any better?  

If D has higher priority than A, then neither A nor B (with the locks held) 
should be allowed to run before D.

> I 
> think not, since we now have to inflate the nominal WCET of A to
> include all of the critical sections that block it.
>
> So, it seems most logical and simplest to leave the charges where
> they naturally occur, on B.  That is, if you allow priority
> inheritance, you allow tasks to sometimes run at higher priority
> than they originally were allocated, but not to execute more
> than originally budgeted.

Yes, no task should be allowed to run more than the budget, but that requires 
B to execute *only* on CPU#B. 

On the other hand, one could say that if you run PEP and B is executed on 
CPU#A, and A then exhausts its budget, you could blame A as well, as 
lock-contention is a common problem and it's not only the kernel's fault. Do 
we need perfect or best-effort lock-resolving?

> Ted

-- 
     henrik

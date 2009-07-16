Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbZGPH6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbZGPH6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZGPH6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:58:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbZGPH6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:58:47 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Peter Zijlstra <peterz@infradead.org>
To: Ted Baker <baker@cs.fsu.edu>
Cc: Chris Friesen <cfriesen@nortel.com>, Noah Watkins <jayhawk@soe.ucsc.edu>,
       Raistlin <raistlin@linux.it>, Douglas Niehaus <niehaus@ittc.ku.edu>,
       Henrik Austad <henrik@austad.us>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <20090715231109.GH14993@cs.fsu.edu>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	 <1247505941.7500.39.camel@twins>
	 <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>
	 <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com>
	 <20090715231109.GH14993@cs.fsu.edu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Jul 2009 09:58:32 +0200
Message-Id: <1247731113.15471.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 19:11 -0400, Ted Baker wrote:
> On Mon, Jul 13, 2009 at 03:45:11PM -0600, Chris Friesen wrote:
> 
> > Given that the semantics of POSIX PI locking assumes certain scheduler
> > behaviours, is it actually abstraction inversion to have that same
> > dependency expressed in the kernel code that implements it?
> ....> 
> > The whole point of mutexes (and semaphores) within the linux kernel is
> > that it is possible to block while holding them.  I suspect you're going
> > to find it fairly difficult to convince people to spinlocks just to make
> > it possible to provide latency guarantees.
> 
> The abstraction inversion is when the kernel uses (internally)
> something as complex as a POSIX PI mutex.  So, I'm not arguing
> that the kernel does not need internal mutexes/semaphores that
> can be held while a task is suspended/blocked.  I'm just arguing
> that those internal mutexes/semaphores should not be PI ones.
>
> > ...  the selling point for PI vs PP is that under PIP the
> > priority of the lock holder is automatically boosted only if
> > necessary, and only as high as necessary.
> 
> The putative benefit of this is disputed, as shown by Jim and
> Bjorn's work with LITMUS-RT and others.  For difference to be
> noted, there must be a lot of contention, and long critical
> sections.  The benefit of less frequent priority boosting and
> lower priorities can be balanced by more increased worst-case
> number of context switches.
> 
> > On the other hand, PP requires code analysis to properly set the
> > ceilings for each individual mutex.
> 
> Indeed, this is difficult, but no more difficult than estimating
> worst-case blocking times, which requires more extensive code
> analysis and requires consideration of more cases with PI than PP.
> 
> If determining the exact ceiling is too difficult.  one can simply
> set the ceiling to the maximum priority used by the application.
> 
> Again, I don't think that either PP or PI is appropriate for use
> in a (SMP) kernel. For non-blocking locks, the current
> no-preeemption spinlock mechanism works.  For higher-level
> (blocking) locks, I'm attracted to Jim Anderson's model of
> non-preemptable critical sections, combined with FIFO queue
> service.

Right, so there's two points here I think:

 A) making most locks preemptible
 B) adding PI to all preemptible locks

I think that we can all agree that if you do A, B makes heaps of sense,
right?

I just asked Thomas if he could remember any numbers on this, and he
said that keeping all the locks non-preemptible had at least an order
difference in max latencies [ so a 60us (A+B) would turn into 600us (!
A) ], this means a proportional decrease for the max freq of periodic
tasks.

This led to the conviction that the PI overheads are worth it, since
people actually want high freq tasks.

Of course, when the decreased period is still sufficient for the
application at hand, the non-preemptible case allows for better
analysis.



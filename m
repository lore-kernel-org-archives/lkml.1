Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZGPIzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZGPIzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZGPIzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:55:46 -0400
Received: from www.tglx.de ([62.245.132.106]:33640 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292AbZGPIzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:55:44 -0400
Date: Thu, 16 Jul 2009 10:52:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Ted Baker <baker@cs.fsu.edu>, Chris Friesen <cfriesen@nortel.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
In-Reply-To: <1247731113.15471.24.camel@twins>
Message-ID: <alpine.LFD.2.00.0907161000470.2777@localhost.localdomain>
References: <200907102350.47124.henrik@austad.us>  <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu>  <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>  <1247505941.7500.39.camel@twins>  <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>
  <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com>  <20090715231109.GH14993@cs.fsu.edu> <1247731113.15471.24.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Peter Zijlstra wrote:
> On Wed, 2009-07-15 at 19:11 -0400, Ted Baker wrote:
> > Again, I don't think that either PP or PI is appropriate for use
> > in a (SMP) kernel. For non-blocking locks, the current
> > no-preeemption spinlock mechanism works.  For higher-level
> > (blocking) locks, I'm attracted to Jim Anderson's model of
> > non-preemptable critical sections, combined with FIFO queue
> > service.
> 
> Right, so there's two points here I think:
> 
>  A) making most locks preemptible
>  B) adding PI to all preemptible locks
> 
> I think that we can all agree that if you do A, B makes heaps of sense,
> right?
> 
> I just asked Thomas if he could remember any numbers on this, and he
> said that keeping all the locks non-preemptible had at least an order
> difference in max latencies [ so a 60us (A+B) would turn into 600us (!
> A) ], this means a proportional decrease for the max freq of periodic
> tasks.

That are numbers from about 3 years ago. I need to redo the tests as
we did lot of lock breaks and shortening of preempt/irq disabled
sections since then, but when we started preempt-rt there was no real
choice as the limited number of developers simply did not allow to
analyse and fix all the long lasting critical sections. We were busy
enough to fix all the locking problems which were unearthed. :) Also
we did not have the tools to analyse the length of critical sections
back then. 

It's definitely worthwhile to revisit this, but that's going to be a
multi man years effort to distangle complex code pathes like the
network stack, disk i/o and other known sources of trouble. The next
challenge will be how to monitor the code base for regressions and
keeping thousands of developers aware of these requirements.

> This led to the conviction that the PI overheads are worth it, since
> people actually want high freq tasks.
>
> Of course, when the decreased period is still sufficient for the
> application at hand, the non-preemptible case allows for better
> analysis.

Agreed, but the real challenge of providing real time services in
Linux is the wide variety of use cases. We simply need to accept that
people want to use it from

  high frequency industrial control tasks while running a GUI, a
  webserver and a database on the same machine

to

  heavily threaded enterprise class Java applications which do not
  care that much about latencies but need the correctness guarantees

and of course everything in between.

I'm well aware that we try to create something which does everything
except of playing the National Anthem, but simply restricting the use
cases is not an option and would be exceptionally boring as well :)

Thanks,

	tglx

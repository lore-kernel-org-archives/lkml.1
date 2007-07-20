Return-Path: <linux-kernel-owner+w=401wt.eu-S933848AbXGTHXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848AbXGTHXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761793AbXGTHXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:23:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60917 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759613AbXGTHXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:23:11 -0400
Date: Fri, 20 Jul 2007 09:22:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jan Glauber <jang@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, vatsa@linux.vnet.ibm.com,
       mschwid2@linux.vnet.ibm.com, efault@gmx.de, dmitry.adamushko@gmail.com,
       anton@samba.org
Subject: Re: [PATCH] virtual sched_clock() for s390
Message-ID: <20070720072245.GA4020@elte.hu>
References: <1184842661.6546.14.camel@localhost.localdomain> <469F8342.7060000@goop.org> <20070719160025.GA31815@elte.hu> <18080.2390.42425.852087@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18080.2390.42425.852087@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> PowerPC's sched_clock() currently measures real time.  On POWER5 and 
> POWER6 machines we could change it to use a register called the "PURR" 
> (for Processor Utilization of Resources Register), which only measures 
> time spent while the partition is running.  But the PURR has another 
> function as well: it measures the distribution of dispatch cycles 
> between the two hardware threads on each core when running in SMT 
> mode.  That is, the cpu dispatches instructions from one thread or the 
> other (not both) on each CPU cycle, and each thread's PURR only gets 
> incremented on cycles where the cpu dispatches instructions for that 
> thread.  So the sum of the two threads' PURRs adds up to real time.
> 
> Do you think this makes the PURR more useful for CFS, or less?  To me 
> it looks like this would mean that CFS can make a more equitable 
> distribution of CPU time if, for example, you had 3 runnable tasks on 
> a 2-core x dual-threaded machine (4 virtual CPUs).

there's one complication: sched_clock() still needs to increase while 
the CPU (or thread) is idle, so that we can have a correct measurement 
of the CPU's utilization, for SMP load-balancing. CFS constructs another 
clock from sched_clock() [the rq->fair_clock] which does stop while the 
CPU is idle.

So perhaps a combination of the PURR and real-time might work as 
sched_clock(): when a hardware thread is in cpu_idle(), it should 
advance its sched clock with _half_ the rate of real-time [so that the 
sum of advance of all threads if they are all idle is equal to real 
time], and use the PURR if they are not idle. This would still correctly 
keep a meaningful load-average if the physical CPU is under-utilized.

If you do such a change you'll immediately see whether the approach is 
right: monitor the cpu_load[] values in /proc/sched_debug, they should 
match the intuitive 'load average' of that CPU (if divided by 1024), and 
check whether 'top' still works fine.

> BTW, what does "time spent running during sleep" mean?  Does it mean 
> "time that other tasks are running while this task is sleeping"?

yeah. It's "the amount of fair runtime i missed out on while others were 
running".

> > still, CFS needs time measurement across idle periods as well, for 
> > another purpose: to be able to do precise task statistics for /proc. 
> > (for top, ps, etc.) So it's still true that sched_clock() should 
> > include idle periods too.
> 
> As with s390, 64-bit PowerPC also uses CONFIG_VIRT_CPU_ACCOUNTING. 
> That affects how tsk->utime and tsk->stime are accumulated (we call 
> account_user_time and account_system_time directly rather than calling 
> update_process_times) as well as the system hardirq/softirq time, idle 
> time, and stolen time.

tsk->utime and tsk->stime is only used for a single purpose: to 
determine the 'split' factor of how to split up the precise total time 
between user and system time.

> When you say "precise task statistics for /proc", where are they 
> accumulated?  I don't see any changes to the way that tsk->utime and 
> ctime are computed.

we now use p->se.sum_exec_runtime that measures (in nanoseconds) the 
precise amount of time spent executing (sum of system and user time) - 
and ->stime and ->utime is used to determine the 'split'. [this allows 
us to gather ->stime and ->utime via low-resolution sampling, while 
keeping the 'total' precise. Accounting at every system entry point 
would be quite expensive on most platforms.]

	Ingo

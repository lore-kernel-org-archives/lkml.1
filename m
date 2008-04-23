Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbYDWHwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbYDWHwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 03:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYDWHvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 03:51:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45567 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbYDWHvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 03:51:52 -0400
Date: Wed, 23 Apr 2008 09:51:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Soft lockup regression from today's sched.git merge.
Message-ID: <20080423075140.GA20980@elte.hu>
References: <20080422.015931.70144614.davem@davemloft.net> <20080422091456.GC9939@elte.hu> <20080422.224212.32058127.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422.224212.32058127.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 22 Apr 2008 11:14:56 +0200
> 
> > thanks for reporting it. I havent seen this false positive happen in a 
> > long time - but then again, PC CPUs are a lot less idle than a 128-CPU 
> > Niagara2 :-/ I'm wondering what the best method would be to provoke a 
> > CPU to stay idle that long - to make sure this bug is fixed.
> 
> I looked more closely at this.
> 
> There is no way the patch in question can work properly.
> 
> The algorithm is, essentialy "if time - prev_cpu_time is large enough, 
> call __sync_cpu_clock()" which if fine, except that nothing ever sets 
> prev_cpu_time.

you are right - and this causes us to hit that global spinlock every 
time cpu_clock() is called. Note that only debugging code uses 
cpu_clock() though (softlockup watchdog, blktrace, etc.) - but you are 
right that the performance bug should be fixed - the patch below fixes 
the bogosity.

the second patch below makes time_sync_thresh available to architecture 
code - that way, if your platform has a guaranteed-synchronous 
sched_clock(), you can set that to a larger value (or just -1LL for 
infinite).

this problem cannot explain the softlockup bug though.

	Ingo

---------------------------->
Subject: sched: fix cpu clock
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Apr 23 09:24:06 CEST 2008

David Miller pointed it out that nothing in cpu_clock() sets
prev_cpu_time. This caused __sync_cpu_clock() to be called
all the time - against the intention of this code.

The result was that in practice we hit a global spinlock every
time cpu_clock() is called - which - even though cpu_clock()
is used for tracing and debugging, is suboptimal.

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1001,6 +1001,8 @@ unsigned long long notrace cpu_clock(int
 	if (unlikely(delta_time > time_sync_thresh))
 		time = __sync_cpu_clock(time, cpu);
 
+	per_cpu(prev_cpu_time, cpu) = time;
+
 	return time;
 }
 EXPORT_SYMBOL_GPL(cpu_clock);

Subject: sched: make clock sync tunable by architecture code
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Apr 23 09:31:35 CEST 2008

make time_sync_thresh tunable to architecture code.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 ++
 kernel/sched.c        |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -159,6 +159,8 @@ print_cfs_rq(struct seq_file *m, int cpu
 }
 #endif
 
+extern unsigned long long time_sync_thresh;
+
 /*
  * Task state bitmask. NOTE! These bits are also
  * encoded in fs/proc/array.c: get_task_state().
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -924,7 +924,7 @@ static inline u64 global_rt_runtime(void
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
-static const unsigned long long time_sync_thresh = 100000;
+unsigned long long time_sync_thresh = 100000;
 
 static DEFINE_PER_CPU(unsigned long long, time_offset);
 static DEFINE_PER_CPU(unsigned long long, prev_cpu_time);

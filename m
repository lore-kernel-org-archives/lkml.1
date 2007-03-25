Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbXCYMdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbXCYMdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbXCYMdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:33:22 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:57618 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbXCYMdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:33:21 -0400
Date: Sun, 25 Mar 2007 08:32:36 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] sched: accurate user accounting
In-reply-to: <200703252202.48022.kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Cc: Con Kolivas <kernel@kolivas.org>, malc <av1474@comtv.ru>,
       Ingo Molnar <mingo@elte.hu>, zwane@infradead.org,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Message-id: <200703250832.36818.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703251159.03616.kernel@kolivas.org>
 <200703252146.45721.kernel@kolivas.org> <200703252202.48022.kernel@kolivas.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 March 2007, Con Kolivas wrote:
>On Sunday 25 March 2007 21:46, Con Kolivas wrote:
>> On Sunday 25 March 2007 21:34, malc wrote:
>> > On Sun, 25 Mar 2007, Ingo Molnar wrote:
>> > > * Con Kolivas <kernel@kolivas.org> wrote:
>> > >> For an rsdl 0.33 patched kernel. Comments? Overhead worth it?
>> > >
>> > > we want to do this - and we should do this to the vanilla
>> > > scheduler first and check the results. I've back-merged the patch
>> > > to before RSDL and have tested it - find the patch below. Vale,
>> > > could you try this patch against a 2.6.21-rc4-ish kernel and
>> > > re-test your testcase?
>> >
>> > [..snip..]
>> >
>> > Compilation failed with:
>> > kernel/built-in.o(.sched.text+0x564): more undefined references to
>> > `__udivdi3' follow
>> >
>> > $ gcc --version | head -1
>> > gcc (GCC) 3.4.6
>> >
>> > $ cat /proc/cpuinfo | grep cpu
>> > cpu             : 7447A, altivec supported
>> >
>> > Can't say i really understand why 64bit arithmetics suddenly became
>> > an issue here.
>>
>> Probably due to use of:
>>
>> #define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
>> #define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
>>
>> Excuse our 64bit world while we strive to correct our 32bit blindness
>> and fix this bug.
>
>Please try this (akpm please don't include till we confirm it builds on
> ppc, sorry). For 2.6.21-rc4
>
>---
>Currently we only do cpu accounting to userspace based on what is
>actually happening precisely on each tick. The accuracy of that
>accounting gets progressively worse the lower HZ is. As we already keep
>accounting of nanosecond resolution we can accurately track user cpu,
>nice cpu and idle cpu if we move the accounting to update_cpu_clock with
>a nanosecond cpu_usage_stat entry. This increases overhead slightly but
>avoids the problem of tick aliasing errors making accounting unreliable.
>
>Signed-off-by: Con Kolivas <kernel@kolivas.org>
>Signed-off-by: Ingo Molnar <mingo@elte.hu>
>---
> include/linux/kernel_stat.h |    3 ++
> include/linux/sched.h       |    2 -
> kernel/sched.c              |   46
> +++++++++++++++++++++++++++++++++++++++++--- kernel/timer.c            
>  |    5 +---
> 4 files changed, 49 insertions(+), 7 deletions(-)
>
>Index: linux-2.6.21-rc4-acct/include/linux/kernel_stat.h
>===================================================================
>--- linux-2.6.21-rc4-acct.orig/include/linux/kernel_stat.h	2006-09-21
> 19:54:58.000000000 +1000 +++
> linux-2.6.21-rc4-acct/include/linux/kernel_stat.h	2007-03-25
> 21:51:49.000000000 +1000 @@ -16,11 +16,14 @@
>
> struct cpu_usage_stat {
> 	cputime64_t user;
>+	cputime64_t user_ns;
> 	cputime64_t nice;
>+	cputime64_t nice_ns;
> 	cputime64_t system;
> 	cputime64_t softirq;
> 	cputime64_t irq;
> 	cputime64_t idle;
>+	cputime64_t idle_ns;
> 	cputime64_t iowait;
> 	cputime64_t steal;
> };
>Index: linux-2.6.21-rc4-acct/include/linux/sched.h
>===================================================================
>--- linux-2.6.21-rc4-acct.orig/include/linux/sched.h	2007-03-21
> 12:53:00.000000000 +1100 +++
> linux-2.6.21-rc4-acct/include/linux/sched.h	2007-03-25
> 21:51:49.000000000 +1000 @@ -882,7 +882,7 @@ struct task_struct {
> 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
>
> 	unsigned long rt_priority;
>-	cputime_t utime, stime;
>+	cputime_t utime, utime_ns, stime;
> 	unsigned long nvcsw, nivcsw; /* context switch counts */
> 	struct timespec start_time;
> /* mm fault and swap info: this can arguably be seen as either
> mm-specific or thread-specific */ Index:
> linux-2.6.21-rc4-acct/kernel/sched.c
>===================================================================
This, hunk 1, did not apply as the #defines aren't there after applying 
0.33 to a 2.6.20.4 kernel tree.

>--- linux-2.6.21-rc4-acct.orig/kernel/sched.c	2007-03-21
> 12:53:00.000000000 +1100 +++
> linux-2.6.21-rc4-acct/kernel/sched.c	2007-03-25 21:58:27.000000000
> +1000 @@ -89,6 +89,7 @@ unsigned long long __attribute__((weak))
>  */
> #define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
> #define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
>+#define JIFFY_NS		JIFFIES_TO_NS(1)
>
> /*
>  * These are the 'tuning knobs' of the scheduler:
>@@ -3017,8 +3018,49 @@ EXPORT_PER_CPU_SYMBOL(kstat);
> static inline void
> update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long
> long now) {
>-	p->sched_time += now - p->last_ran;
>+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
>+	cputime64_t time_diff = now - p->last_ran;
>+
>+	p->sched_time += time_diff;
> 	p->last_ran = rq->most_recent_timestamp = now;
>+	if (p != rq->idle) {
>+		cputime_t utime_diff = time_diff;
>+
>+		if (TASK_NICE(p) > 0) {
>+			cpustat->nice_ns = cputime64_add(cpustat->nice_ns,
>+							 time_diff);
>+			if (cpustat->nice_ns > JIFFY_NS) {
>+				cpustat->nice_ns =
>+					cputime64_sub(cpustat->nice_ns,
>+					JIFFY_NS);
>+				cpustat->nice =
>+					cputime64_add(cpustat->nice, 1);
>+			}
>+		} else {
>+			cpustat->user_ns = cputime64_add(cpustat->user_ns,
>+							 time_diff);
>+			if (cpustat->user_ns > JIFFY_NS) {
>+				cpustat->user_ns =
>+					cputime64_sub(cpustat->user_ns,
>+					JIFFY_NS);
>+				cpustat ->user =
>+					cputime64_add(cpustat->user, 1);
>+			}
>+		}
>+		p->utime_ns = cputime_add(p->utime_ns, utime_diff);
>+		if (p->utime_ns > JIFFY_NS) {
>+			p->utime_ns = cputime_sub(p->utime_ns, JIFFY_NS);
>+			p->utime = cputime_add(p->utime,
>+					       jiffies_to_cputime(1));
>+		}
>+	} else {
>+		cpustat->idle_ns = cputime64_add(cpustat->idle_ns, time_diff);
>+		if (cpustat->idle_ns > JIFFY_NS) {
>+			cpustat->idle_ns = cputime64_sub(cpustat->idle_ns,
>+							 JIFFY_NS);
>+			cpustat->idle = cputime64_add(cpustat->idle, 1);
>+		}
>+	}
> }
>
> /*
>@@ -3104,8 +3146,6 @@ void account_system_time(struct task_str
> 		cpustat->system = cputime64_add(cpustat->system, tmp);
> 	else if (atomic_read(&rq->nr_iowait) > 0)
> 		cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
>-	else
>-		cpustat->idle = cputime64_add(cpustat->idle, tmp);
> 	/* Account for system time used */
> 	acct_update_integrals(p);
> }
>Index: linux-2.6.21-rc4-acct/kernel/timer.c
>===================================================================
>--- linux-2.6.21-rc4-acct.orig/kernel/timer.c	2007-03-21
> 12:53:00.000000000 +1100 +++
> linux-2.6.21-rc4-acct/kernel/timer.c	2007-03-25 21:51:49.000000000
> +1000 @@ -1196,10 +1196,9 @@ void update_process_times(int user_tick)
> int cpu = smp_processor_id();
>
> 	/* Note: this timer irq context must be accounted for as well. */
>-	if (user_tick)
>-		account_user_time(p, jiffies_to_cputime(1));
>-	else
>+	if (!user_tick)
> 		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
>+	/* User time is accounted for in update_cpu_clock in sched.c */
> 	run_local_timers();
> 	if (rcu_pending(cpu))
> 		rcu_check_callbacks(cpu, user_tick);

I'm playing again because the final 2.6.20.4 does NOT break amanda, where 
2.6.20.4-rc1 did.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
A classic is something that everyone wants to have read
and nobody wants to read.
		-- Mark Twain, "The Disappearance of Literature"

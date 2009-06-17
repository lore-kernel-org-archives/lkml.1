Return-Path: <linux-kernel-owner+w=401wt.eu-S933381AbZFQOIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbZFQOIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764950AbZFQOH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:07:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:50883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896AbZFQOH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:07:57 -0400
Date: Wed, 17 Jun 2009 14:06:48 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:sched/urgent] sched, x86: Fix cpufreq + sched_clock() TSC scaling
Message-ID: <tip-84599f8a59e77699f18f06948cea171a349a3f0f@git.kernel.org>
Git-Commit-ID: 84599f8a59e77699f18f06948cea171a349a3f0f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 14:06:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84599f8a59e77699f18f06948cea171a349a3f0f
Gitweb:     http://git.kernel.org/tip/84599f8a59e77699f18f06948cea171a349a3f0f
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 16 Jun 2009 12:34:17 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 16:03:54 +0200

sched, x86: Fix cpufreq + sched_clock() TSC scaling

For freqency dependent TSCs we only scale the cycles, we do not account
for the discrepancy in absolute value.

Our current formula is: time = cycles * mult

(where mult is a function of the cpu-speed on variable tsc machines)

Suppose our current cycle count is 10, and we have a multiplier of 5,
then our time value would end up being 50.

Now cpufreq comes along and changes the multiplier to say 3 or 7,
which would result in our time being resp. 30 or 70.

That means that we can observe random jumps in the time value due to
frequency changes in both fwd and bwd direction.

So what this patch does is change the formula to:

  time = cycles * frequency + offset

And we calculate offset so that time_before == time_after, thereby
ridding us of these jumps in time.

[ Impact: fix/reduce sched_clock() jumps across frequency changing events ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Chucked-on-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


---
 arch/x86/include/asm/timer.h |    6 +++++-
 arch/x86/kernel/tsc.c        |    8 ++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index bd37ed4..20ca9c4 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -45,12 +45,16 @@ extern int no_timer_check;
  */
 
 DECLARE_PER_CPU(unsigned long, cyc2ns);
+DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
 static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
-	return cyc * per_cpu(cyc2ns, smp_processor_id()) >> CYC2NS_SCALE_FACTOR;
+	int cpu = smp_processor_id();
+	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
+	ns += cyc * per_cpu(cyc2ns, cpu) >> CYC2NS_SCALE_FACTOR;
+	return ns;
 }
 
 static inline unsigned long long cycles_2_ns(unsigned long long cyc)
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 3e1c057..ef4dac5 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -589,22 +589,26 @@ EXPORT_SYMBOL(recalibrate_cpu_khz);
  */
 
 DEFINE_PER_CPU(unsigned long, cyc2ns);
+DEFINE_PER_CPU(unsigned long long, cyc2ns_offset);
 
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
-	unsigned long long tsc_now, ns_now;
+	unsigned long long tsc_now, ns_now, *offset;
 	unsigned long flags, *scale;
 
 	local_irq_save(flags);
 	sched_clock_idle_sleep_event();
 
 	scale = &per_cpu(cyc2ns, cpu);
+	offset = &per_cpu(cyc2ns_offset, cpu);
 
 	rdtscll(tsc_now);
 	ns_now = __cycles_2_ns(tsc_now);
 
-	if (cpu_khz)
+	if (cpu_khz) {
 		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+		*offset = ns_now - (tsc_now * *scale >> CYC2NS_SCALE_FACTOR);
+	}
 
 	sched_clock_idle_wakeup_event(0);
 	local_irq_restore(flags);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763561AbYB1UNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763561AbYB1UNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYB1UN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:13:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54999 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbYB1UN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:13:27 -0500
Date: Thu, 28 Feb 2008 21:13:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: printk timestamps jumping back and forth in 2.6.25-rc.
Message-ID: <20080228201315.GA30736@elte.hu>
References: <f19298770802280626g5ee17328ldedf7658a9f26f56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770802280626g5ee17328ldedf7658a9f26f56@mail.gmail.com>
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


* Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

>     fix CONFIG_PRINT_TIME's reliance on sched_clock() and use 
>     cpu_clock() instead.
> 
>     Reported-and-bisected-by: Stefano Brivio <stefano.brivio@polimi.it>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> which sound like "happy debugging, losers" to me. ;)

i hope not :)

> Anything else I can do?

yes, please test the patch below - does it fix the problem?

	Ingo

------------------>
Subject: sched: make cpu_clock() globally synchronous
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Feb 28 21:00:21 CET 2008

Alexey Zaytsev reported (and bisected) that the introduction of 
cpu_clock() in printk made the timestamps jump back and forth.

Make cpu_clock() more reliable while still keeping it fast when it's 
called frequently.

Bisected-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -710,11 +710,39 @@ static inline u64 global_rt_runtime(void
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
+static const unsigned long long time_sync_thresh = 100000;
+
+static DEFINE_PER_CPU(unsigned long long, time_offset);
+static DEFINE_PER_CPU(unsigned long long, prev_cpu_time);
+
 /*
- * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
- * clock constructed from sched_clock():
+ * Global lock which we take every now and then to synchronize
+ * the CPUs time. This method is not warp-safe, but it's good
+ * enough to synchronize slowly diverging time sources and thus
+ * it's good enough for tracing:
  */
-unsigned long long cpu_clock(int cpu)
+static DEFINE_SPINLOCK(time_sync_lock);
+static unsigned long long prev_global_time;
+
+static unsigned long long __sync_cpu_clock(cycles_t time, int cpu)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&time_sync_lock, flags);
+
+	if (time < prev_global_time) {
+		per_cpu(time_offset, cpu) += prev_global_time - time;
+		time = prev_global_time;
+	} else {
+		prev_global_time = time;
+	}
+
+	spin_unlock_irqrestore(&time_sync_lock, flags);
+
+	return time;
+}
+
+static unsigned long long __cpu_clock(int cpu)
 {
 	unsigned long long now;
 	unsigned long flags;
@@ -735,6 +763,24 @@ unsigned long long cpu_clock(int cpu)
 
 	return now;
 }
+
+/*
+ * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
+ * clock constructed from sched_clock():
+ */
+unsigned long long cpu_clock(int cpu)
+{
+	unsigned long long prev_cpu_time, time, delta_time;
+
+	prev_cpu_time = per_cpu(prev_cpu_time, cpu);
+	time = __cpu_clock(cpu) + per_cpu(time_offset, cpu);
+	delta_time = time-prev_cpu_time;
+
+	if (unlikely(delta_time > time_sync_thresh))
+		time = __sync_clock(time, cpu);
+
+	return time;
+}
 EXPORT_SYMBOL_GPL(cpu_clock);
 
 #ifndef prepare_arch_switch

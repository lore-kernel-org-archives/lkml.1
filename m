Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0CKJuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:50:08 -0500
Received: from mail.gmx.net ([213.165.64.20]:40902 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755437Ab0CKJuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:50:06 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19DsGA1G3RDdAsyXgBYvKymZkipr0Ci7qdHI/jIUX
	2AKaoYCOpTYOzm
Subject: Re: [patch 1/12] sched: ratelimit nohz
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1268300950.6785.27.camel@marge.simson.net>
References: <1268300950.6785.27.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 10:50:03 +0100
Message-Id: <1268301003.6785.28.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: ratelimit nohz

Entering nohz code on every micro-idle is costing ~10% throughput for netperf
TCP_RR when scheduling cross-cpu.  Rate limiting entry fixes this, but raises
ticks a bit.  On my Q6600, an idle box goes from ~85 interrupts/sec to 128.

The higher the context switch rate, the more nohz entry costs.  With this patch
and some cycle recovery patches in my tree, max cross cpu context switch rate is
improved by ~16%, a large portion of which of which is this ratelimiting.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 include/linux/sched.h    |    6 ++++++
 kernel/sched.c           |   12 ++++++++++++
 kernel/time/tick-sched.c |    3 +++
 3 files changed, 21 insertions(+)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -271,11 +271,17 @@ extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern int select_nohz_load_balancer(int cpu);
 extern int get_nohz_load_balancer(void);
+extern int nohz_ratelimit(int cpu);
 #else
 static inline int select_nohz_load_balancer(int cpu)
 {
 	return 0;
 }
+
+static inline int nohz_ratelimit(int cpu)
+{
+	return 0;
+}
 #endif
 
 /*
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -492,6 +492,7 @@ struct rq {
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 #ifdef CONFIG_NO_HZ
+	u64 nohz_stamp;
 	unsigned char in_nohz_recently;
 #endif
 	/* capture load from *all* tasks on this cpu: */
@@ -1228,6 +1229,17 @@ void wake_up_idle_cpu(int cpu)
 	if (!tsk_is_polling(rq->idle))
 		smp_send_reschedule(cpu);
 }
+
+int nohz_ratelimit(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	u64 diff = rq->clock - rq->nohz_stamp;
+
+	rq->nohz_stamp = rq->clock;
+
+	return diff < (NSEC_PER_SEC / HZ) >> 1;
+}
+
 #endif /* CONFIG_NO_HZ */
 
 static u64 sched_avg_period(void)
Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -262,6 +262,9 @@ void tick_nohz_stop_sched_tick(int inidl
 		goto end;
 	}
 
+	if (nohz_ratelimit(cpu))
+		goto end;
+
 	ts->idle_calls++;
 	/* Read jiffies and the time when jiffies were updated last */
 	do {



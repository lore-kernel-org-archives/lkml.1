Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab0CKSbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:31:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:40806 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab0CKSbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:31:38 -0500
Date: Thu, 11 Mar 2010 18:30:38 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268301003.6785.28.camel@marge.simson.net>
References: <1268301003.6785.28.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Rate-limit nohz
Message-ID: <tip-39c0cbe2150cbd848a25ba6cdb271d1ad46818ad@git.kernel.org>
Git-Commit-ID: 39c0cbe2150cbd848a25ba6cdb271d1ad46818ad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 18:30:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39c0cbe2150cbd848a25ba6cdb271d1ad46818ad
Gitweb:     http://git.kernel.org/tip/39c0cbe2150cbd848a25ba6cdb271d1ad46818ad
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 11 Mar 2010 17:17:13 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 18:32:49 +0100

sched: Rate-limit nohz

Entering nohz code on every micro-idle is costing ~10% throughput for netperf
TCP_RR when scheduling cross-cpu.  Rate limiting entry fixes this, but raises
ticks a bit.  On my Q6600, an idle box goes from ~85 interrupts/sec to 128.

The higher the context switch rate, the more nohz entry costs.  With this patch
and some cycle recovery patches in my tree, max cross cpu context switch rate is
improved by ~16%, a large portion of which of which is this ratelimiting.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301003.6785.28.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h    |    6 ++++++
 kernel/sched.c           |   12 ++++++++++++
 kernel/time/tick-sched.c |    3 +++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8cc863d..13efe7d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
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
diff --git a/kernel/sched.c b/kernel/sched.c
index a4aa071..60b1bbe 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
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
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f992762..f25735a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -262,6 +262,9 @@ void tick_nohz_stop_sched_tick(int inidle)
 		goto end;
 	}
 
+	if (nohz_ratelimit(cpu))
+		goto end;
+
 	ts->idle_calls++;
 	/* Read jiffies and the time when jiffies were updated last */
 	do {

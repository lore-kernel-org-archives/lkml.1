Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453Ab0AUPiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0AUPiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066Ab0AUPiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:38:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49824 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab0AUPit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:38:49 -0500
Date: Thu, 21 Jan 2010 16:38:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] perf fixes
Message-ID: <20100121153833.GA30774@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      perf timechart: Use tid not pid for COMM change

Luca Barbieri (1):
      hw-breakpoints, perf: Fix broken mmiotrace due to dr6 by reference change

Pekka Enberg (2):
      perf kmem: Increase "Hit" column length
      perf kmem: Print usage help for unknown commands

Peter Zijlstra (3):
      perf: Fix perf_event_do_pending() fallback callsite
      perf: Honour event state for aux stream data
      perf: Change the is_software_event() definition

Stephane Eranian (1):
      perf: x86: Add support for the ANY bit


 arch/x86/include/asm/perf_event.h |    1 +
 arch/x86/kernel/cpu/perf_event.c  |    7 +++++++
 arch/x86/mm/kmmio.c               |    7 ++++---
 include/linux/perf_event.h        |   11 ++++++++---
 kernel/perf_event.c               |    9 +++++++++
 kernel/timer.c                    |    3 +--
 tools/perf/builtin-kmem.c         |    7 ++++---
 tools/perf/builtin-timechart.c    |    2 +-
 8 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8d9f854..1380367 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -19,6 +19,7 @@
 #define MSR_ARCH_PERFMON_EVENTSEL1			     0x187
 
 #define ARCH_PERFMON_EVENTSEL0_ENABLE			  (1 << 22)
+#define ARCH_PERFMON_EVENTSEL_ANY			  (1 << 21)
 #define ARCH_PERFMON_EVENTSEL_INT			  (1 << 20)
 #define ARCH_PERFMON_EVENTSEL_OS			  (1 << 17)
 #define ARCH_PERFMON_EVENTSEL_USR			  (1 << 16)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index d616c06..8c1c070 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1343,6 +1343,13 @@ intel_pmu_enable_fixed(struct hw_perf_event *hwc, int __idx)
 		bits |= 0x2;
 	if (hwc->config & ARCH_PERFMON_EVENTSEL_OS)
 		bits |= 0x1;
+
+	/*
+	 * ANY bit is supported in v3 and up
+	 */
+	if (x86_pmu.version > 2 && hwc->config & ARCH_PERFMON_EVENTSEL_ANY)
+		bits |= 0x4;
+
 	bits <<= (idx * 4);
 	mask = 0xfULL << (idx * 4);
 
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index c0f6198..536fb68 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -538,14 +538,15 @@ static int
 kmmio_die_notifier(struct notifier_block *nb, unsigned long val, void *args)
 {
 	struct die_args *arg = args;
+	unsigned long* dr6_p = (unsigned long *)ERR_PTR(arg->err);
 
-	if (val == DIE_DEBUG && (arg->err & DR_STEP))
-		if (post_kmmio_handler(arg->err, arg->regs) == 1) {
+	if (val == DIE_DEBUG && (*dr6_p & DR_STEP))
+		if (post_kmmio_handler(*dr6_p, arg->regs) == 1) {
 			/*
 			 * Reset the BS bit in dr6 (pointed by args->err) to
 			 * denote completion of processing
 			 */
-			(*(unsigned long *)ERR_PTR(arg->err)) &= ~DR_STEP;
+			*dr6_p &= ~DR_STEP;
 			return NOTIFY_STOP;
 		}
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c66b34f..8fa7187 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -814,9 +814,14 @@ extern int perf_event_overflow(struct perf_event *event, int nmi,
  */
 static inline int is_software_event(struct perf_event *event)
 {
-	return (event->attr.type != PERF_TYPE_RAW) &&
-		(event->attr.type != PERF_TYPE_HARDWARE) &&
-		(event->attr.type != PERF_TYPE_HW_CACHE);
+	switch (event->attr.type) {
+	case PERF_TYPE_SOFTWARE:
+	case PERF_TYPE_TRACEPOINT:
+	/* for now the breakpoint stuff also works as software event */
+	case PERF_TYPE_BREAKPOINT:
+		return 1;
+	}
+	return 0;
 }
 
 extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 603c0d8..d27746b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3268,6 +3268,9 @@ static void perf_event_task_output(struct perf_event *event,
 
 static int perf_event_task_match(struct perf_event *event)
 {
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return 0;
+
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
@@ -3377,6 +3380,9 @@ static void perf_event_comm_output(struct perf_event *event,
 
 static int perf_event_comm_match(struct perf_event *event)
 {
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return 0;
+
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
@@ -3494,6 +3500,9 @@ static void perf_event_mmap_output(struct perf_event *event,
 static int perf_event_mmap_match(struct perf_event *event,
 				   struct perf_mmap_event *mmap_event)
 {
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return 0;
+
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 15533b7..c61a794 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1198,6 +1198,7 @@ void update_process_times(int user_tick)
 	run_local_timers();
 	rcu_check_callbacks(cpu, user_tick);
 	printk_tick();
+	perf_event_do_pending();
 	scheduler_tick();
 	run_posix_cpu_timers(p);
 }
@@ -1209,8 +1210,6 @@ static void run_timer_softirq(struct softirq_action *h)
 {
 	struct tvec_base *base = __get_cpu_var(tvec_bases);
 
-	perf_event_do_pending();
-
 	hrtimer_run_pending();
 
 	if (time_after_eq(jiffies, base->timer_jiffies))
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 7ceb741..93c67bf 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -375,7 +375,7 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 
 	printf("%.102s\n", graph_dotted_line);
 	printf(" %-34s |",  is_caller ? "Callsite": "Alloc Ptr");
-	printf(" Total_alloc/Per | Total_req/Per   | Hit   | Ping-pong | Frag\n");
+	printf(" Total_alloc/Per | Total_req/Per   | Hit      | Ping-pong | Frag\n");
 	printf("%.102s\n", graph_dotted_line);
 
 	next = rb_first(root);
@@ -401,7 +401,7 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 			snprintf(buf, sizeof(buf), "%#Lx", addr);
 		printf(" %-34s |", buf);
 
-		printf(" %9llu/%-5lu | %9llu/%-5lu | %6lu | %8lu | %6.3f%%\n",
+		printf(" %9llu/%-5lu | %9llu/%-5lu | %8lu | %8lu | %6.3f%%\n",
 		       (unsigned long long)data->bytes_alloc,
 		       (unsigned long)data->bytes_alloc / data->hit,
 		       (unsigned long long)data->bytes_req,
@@ -784,7 +784,8 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __used)
 			setup_sorting(&alloc_sort, default_sort_order);
 
 		return __cmd_kmem();
-	}
+	} else
+		usage_with_options(kmem_usage, kmem_options);
 
 	return 0;
 }
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index a589a43..3f8bbcf 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -280,7 +280,7 @@ static u64 cpus_pstate_state[MAX_CPUS];
 
 static int process_comm_event(event_t *event, struct perf_session *session __used)
 {
-	pid_set_comm(event->comm.pid, event->comm.comm);
+	pid_set_comm(event->comm.tid, event->comm.comm);
 	return 0;
 }
 

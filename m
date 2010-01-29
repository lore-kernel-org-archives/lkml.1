Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826Ab0A2JaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab0A2JaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817Ab0A2JaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:30:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:57516 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797Ab0A2JaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:30:05 -0500
Date: Fri, 29 Jan 2010 09:29:22 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Clean up event constraints code a bit
Message-ID: <tip-184f412c3341cd24fbd26604634a5800b83dbdc3@git.kernel.org>
Git-Commit-ID: 184f412c3341cd24fbd26604634a5800b83dbdc3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:29:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  184f412c3341cd24fbd26604634a5800b83dbdc3
Gitweb:     http://git.kernel.org/tip/184f412c3341cd24fbd26604634a5800b83dbdc3
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Jan 2010 08:39:39 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:44 +0100

perf, x86: Clean up event constraints code a bit

- Remove stray debug code
 - Improve ugly macros a bit
 - Remove some whitespace damage
 - (Also fix up some accumulated damage in perf_event.h)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c |   37 ++++++++-----------------------------
 include/linux/perf_event.h       |   24 +++++++++++-------------
 2 files changed, 19 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 66de282..fdbe248 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -93,24 +93,19 @@ struct cpu_hw_events {
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 };
 
-#define EVENT_CONSTRAINT(c, n, m) { 	\
+#define EVENT_CONSTRAINT(c, n, m) {	\
 	{ .idxmsk64[0] = (n) },		\
 	.code = (c),			\
 	.cmask = (m),			\
 	.weight = HWEIGHT64((u64)(n)),	\
 }
 
-#define INTEL_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
+#define INTEL_EVENT_CONSTRAINT(c, n)		EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
+#define FIXED_EVENT_CONSTRAINT(c, n)		EVENT_CONSTRAINT(c, n, INTEL_ARCH_FIXED_MASK)
 
-#define FIXED_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, n, INTEL_ARCH_FIXED_MASK)
+#define EVENT_CONSTRAINT_END			EVENT_CONSTRAINT(0, 0, 0)
 
-#define EVENT_CONSTRAINT_END \
-	EVENT_CONSTRAINT(0, 0, 0)
-
-#define for_each_event_constraint(e, c) \
-	for ((e) = (c); (e)->cmask; (e)++)
+#define for_each_event_constraint(e, c)		for ((e) = (c); (e)->cmask; (e)++)
 
 /*
  * struct x86_pmu - generic x86 pmu
@@ -1276,14 +1271,6 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 		if (test_bit(hwc->idx, used_mask))
 			break;
 
-#if 0
-		pr_debug("CPU%d fast config=0x%llx idx=%d assign=%c\n",
-			 smp_processor_id(),
-			 hwc->config,
-			 hwc->idx,
-			 assign ? 'y' : 'n');
-#endif
-
 		set_bit(hwc->idx, used_mask);
 		if (assign)
 			assign[i] = hwc->idx;
@@ -1333,14 +1320,6 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 			if (j == X86_PMC_IDX_MAX)
 				break;
 
-#if 0
-			pr_debug("CPU%d slow config=0x%llx idx=%d assign=%c\n",
-				smp_processor_id(),
-				hwc->config,
-				j,
-				assign ? 'y' : 'n');
-#endif
-
 			set_bit(j, used_mask);
 
 			if (assign)
@@ -2596,9 +2575,9 @@ static const struct pmu pmu = {
  * validate a single event group
  *
  * validation include:
- * 	- check events are compatible which each other
- * 	- events do not compete for the same counter
- * 	- number of events <= number of counters
+ *	- check events are compatible which each other
+ *	- events do not compete for the same counter
+ *	- number of events <= number of counters
  *
  * validation ensures the group can be loaded onto the
  * PMU if it was the only group available.
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 72b2615..953c177 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -290,7 +290,7 @@ struct perf_event_mmap_page {
 };
 
 #define PERF_RECORD_MISC_CPUMODE_MASK		(3 << 0)
-#define PERF_RECORD_MISC_CPUMODE_UNKNOWN		(0 << 0)
+#define PERF_RECORD_MISC_CPUMODE_UNKNOWN	(0 << 0)
 #define PERF_RECORD_MISC_KERNEL			(1 << 0)
 #define PERF_RECORD_MISC_USER			(2 << 0)
 #define PERF_RECORD_MISC_HYPERVISOR		(3 << 0)
@@ -356,8 +356,8 @@ enum perf_event_type {
 	 *	u64				stream_id;
 	 * };
 	 */
-	PERF_RECORD_THROTTLE		= 5,
-	PERF_RECORD_UNTHROTTLE		= 6,
+	PERF_RECORD_THROTTLE			= 5,
+	PERF_RECORD_UNTHROTTLE			= 6,
 
 	/*
 	 * struct {
@@ -371,10 +371,10 @@ enum perf_event_type {
 
 	/*
 	 * struct {
-	 * 	struct perf_event_header	header;
-	 * 	u32				pid, tid;
+	 *	struct perf_event_header	header;
+	 *	u32				pid, tid;
 	 *
-	 * 	struct read_format		values;
+	 *	struct read_format		values;
 	 * };
 	 */
 	PERF_RECORD_READ			= 8,
@@ -412,7 +412,7 @@ enum perf_event_type {
 	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
 	 * };
 	 */
-	PERF_RECORD_SAMPLE		= 9,
+	PERF_RECORD_SAMPLE			= 9,
 
 	PERF_RECORD_MAX,			/* non-ABI */
 };
@@ -752,8 +752,7 @@ extern int perf_max_events;
 extern const struct pmu *hw_perf_event_init(struct perf_event *event);
 
 extern void perf_event_task_sched_in(struct task_struct *task);
-extern void perf_event_task_sched_out(struct task_struct *task,
-					struct task_struct *next);
+extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
 extern void perf_event_task_tick(struct task_struct *task);
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
@@ -853,8 +852,7 @@ extern int sysctl_perf_event_mlock;
 extern int sysctl_perf_event_sample_rate;
 
 extern void perf_event_init(void);
-extern void perf_tp_event(int event_id, u64 addr, u64 count,
-				 void *record, int entry_size);
+extern void perf_tp_event(int event_id, u64 addr, u64 count, void *record, int entry_size);
 extern void perf_bp_event(struct perf_event *event, void *data);
 
 #ifndef perf_misc_flags
@@ -895,13 +893,13 @@ static inline void
 perf_sw_event(u32 event_id, u64 nr, int nmi,
 		     struct pt_regs *regs, u64 addr)			{ }
 static inline void
-perf_bp_event(struct perf_event *event, void *data)		{ }
+perf_bp_event(struct perf_event *event, void *data)			{ }
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 static inline void perf_event_comm(struct task_struct *tsk)		{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
-static inline int  perf_swevent_get_recursion_context(void)  { return -1; }
+static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }

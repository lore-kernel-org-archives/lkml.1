Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab0BVQvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 11:51:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38723 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab0BVQvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 11:51:07 -0500
Date: Mon, 22 Feb 2010 17:50:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] perf fixes
Message-ID: <20100222165052.GA14352@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

The reason i'm sending them post -rc8 is the fix for the Wine breakage from 
Frederic, which would be nice to see resolved in -final.

Thanks,

	Ingo

------------------>
Frederic Weisbecker (2):
      hw-breakpoints: Accept breakpoints on NULL address
      hw-breakpoint: Keep track of dr7 local enable bits

Masami Hiramatsu (1):
      perf probe: Init struct probe_point and set counter correctly

Peter Zijlstra (1):
      perf_events: Fix FORK events


 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/hw_breakpoint.c  |   30 +++++++-----------------------
 arch/x86/kernel/ptrace.c         |    7 +++++--
 kernel/perf_event.c              |   11 +++++------
 tools/perf/util/probe-event.c    |    3 +++
 5 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index fc801ba..b753ea5 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -450,6 +450,8 @@ struct thread_struct {
 	struct perf_event	*ptrace_bps[HBP_NUM];
 	/* Debug status used for traps, single steps, etc... */
 	unsigned long           debugreg6;
+	/* Keep track of the exact dr7 value set by the user */
+	unsigned long           ptrace_dr7;
 	/* Fault info: */
 	unsigned long		cr2;
 	unsigned long		trap_no;
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 05d5fec..bb6006e 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -212,25 +212,6 @@ static int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
 	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
 }
 
-/*
- * Store a breakpoint's encoded address, length, and type.
- */
-static int arch_store_info(struct perf_event *bp)
-{
-	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	/*
-	 * For kernel-addresses, either the address or symbol name can be
-	 * specified.
-	 */
-	if (info->name)
-		info->address = (unsigned long)
-				kallsyms_lookup_name(info->name);
-	if (info->address)
-		return 0;
-
-	return -EINVAL;
-}
-
 int arch_bp_generic_fields(int x86_len, int x86_type,
 			   int *gen_len, int *gen_type)
 {
@@ -362,10 +343,13 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp,
 		return ret;
 	}
 
-	ret = arch_store_info(bp);
-
-	if (ret < 0)
-		return ret;
+	/*
+	 * For kernel-addresses, either the address or symbol name can be
+	 * specified.
+	 */
+	if (info->name)
+		info->address = (unsigned long)
+				kallsyms_lookup_name(info->name);
 	/*
 	 * Check that the low-order bits of the address are appropriate
 	 * for the alignment implied by len.
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 017d937..0c1033d 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -702,7 +702,7 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 	} else if (n == 6) {
 		val = thread->debugreg6;
 	 } else if (n == 7) {
-		val = ptrace_get_dr7(thread->ptrace_bps);
+		val = thread->ptrace_dr7;
 	}
 	return val;
 }
@@ -778,8 +778,11 @@ int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
 			return rc;
 	}
 	/* All that's left is DR7 */
-	if (n == 7)
+	if (n == 7) {
 		rc = ptrace_write_dr7(tsk, val);
+		if (!rc)
+			thread->ptrace_dr7 = val;
+	}
 
 ret_path:
 	return rc;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2b19297..2ae7409 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3259,8 +3259,6 @@ static void perf_event_task_output(struct perf_event *event,
 	task_event->event_id.tid = perf_event_tid(event, task);
 	task_event->event_id.ptid = perf_event_tid(event, current);
 
-	task_event->event_id.time = perf_clock();
-
 	perf_output_put(&handle, task_event->event_id);
 
 	perf_output_end(&handle);
@@ -3268,7 +3266,7 @@ static void perf_event_task_output(struct perf_event *event,
 
 static int perf_event_task_match(struct perf_event *event)
 {
-	if (event->state != PERF_EVENT_STATE_ACTIVE)
+	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
@@ -3300,7 +3298,7 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_event_task_ctx(&cpuctx->ctx, task_event);
 	if (!ctx)
-		ctx = rcu_dereference(task_event->task->perf_event_ctxp);
+		ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
 		perf_event_task_ctx(ctx, task_event);
 	put_cpu_var(perf_cpu_context);
@@ -3331,6 +3329,7 @@ static void perf_event_task(struct task_struct *task,
 			/* .ppid */
 			/* .tid  */
 			/* .ptid */
+			.time = perf_clock(),
 		},
 	};
 
@@ -3380,7 +3379,7 @@ static void perf_event_comm_output(struct perf_event *event,
 
 static int perf_event_comm_match(struct perf_event *event)
 {
-	if (event->state != PERF_EVENT_STATE_ACTIVE)
+	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
@@ -3500,7 +3499,7 @@ static void perf_event_mmap_output(struct perf_event *event,
 static int perf_event_mmap_match(struct perf_event *event,
 				   struct perf_mmap_event *mmap_event)
 {
-	if (event->state != PERF_EVENT_STATE_ACTIVE)
+	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 29465d4..fde17b0 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -272,6 +272,7 @@ int synthesize_perf_probe_point(struct probe_point *pp)
 	int ret;
 
 	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
+	pp->found = 1;
 	if (!buf)
 		die("Failed to allocate memory by zalloc.");
 	if (pp->offset) {
@@ -294,6 +295,7 @@ int synthesize_perf_probe_point(struct probe_point *pp)
 error:
 		free(pp->probes[0]);
 		pp->probes[0] = NULL;
+		pp->found = 0;
 	}
 	return ret;
 }
@@ -455,6 +457,7 @@ void show_perf_probe_events(void)
 	struct strlist *rawlist;
 	struct str_node *ent;
 
+	memset(&pp, 0, sizeof(pp));
 	fd = open_kprobe_events(O_RDONLY, 0);
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 	close(fd);

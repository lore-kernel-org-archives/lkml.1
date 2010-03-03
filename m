Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0CCG4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:56:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:5060 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab0CCGzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:55:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rwOKxSQj6VnB3k1BBGVXXsvhoSvklIsznI/1l0ZWQ1Zwtdx6iab5rAmB86EQeQu+ZA
         piZkfxQEl3UaP3fWRyIu0kZRVCPTrI5revUcmSMrDpu68VhX4ouUjGOgalwEdaRuSbT9
         ieRBflt327OZfWAugCndscuNSp9WBHkPMI9L8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace events
Date: Wed,  3 Mar 2010 07:55:01 +0100
Message-Id: <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are taking a wrong regs snapshot when a trace event triggers.
Either we use get_irq_regs(), which gives us the interrupted
registers if we are in an interrupt, or we use task_pt_regs()
which gives us the state before we entered the kernel, assuming
we are lucky enough to be no kernel thread, in which case
task_pt_regs() returns the initial set of regs when the kernel
thread was started.

What we want is different. We need a hot snapshot of the regs,
so that we can get the instruction pointer to record in the
sample, the frame pointer for the callchain, and some other
things.

In order to achieve that, we introduce PERF_SAVE_REGS() that
takes a live snapshot of the regs we are interested in, and
we use it from perf_tp_event().

Comparison with perf record -e lock: -R -a -f -g
Before:

        perf  [kernel]                   [k] __do_softirq
               |
               --- __do_softirq
                  |
                  |--55.16%-- __open
                  |
                   --44.84%-- __write_nocancel

After:

            perf  [kernel]           [k] perf_tp_event
               |
               --- perf_tp_event
                  |
                  |--41.07%-- ftrace_profile_lock_acquire
                  |          lock_acquire
                  |          |
                  |          |--39.36%-- _raw_spin_lock
                  |          |          |
                  |          |          |--7.81%-- hrtimer_interrupt
                  |          |          |          smp_apic_timer_interrupt
                  |          |          |          apic_timer_interrupt

The old case was producing unreliable callchains. Now having
right frame and instruction pointers, we have the trace we
want. We can even think about implementing a "skip" field in
PERF_SAVE_REGS() to rewind to the caller "n" (here n would
be equal to 2 so that we start on lock_acquire()).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/include/asm/asm.h        |    1 +
 arch/x86/include/asm/perf_event.h |   25 +++++++++++++++++++++++++
 kernel/perf_event.c               |   19 ++++++++++++++-----
 3 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index b3ed1e1..d86e7dc 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -27,6 +27,7 @@
 #define _ASM_ADD	__ASM_SIZE(add)
 #define _ASM_SUB	__ASM_SIZE(sub)
 #define _ASM_XADD	__ASM_SIZE(xadd)
+#define _ASM_POP	__ASM_SIZE(pop)
 
 #define _ASM_AX		__ASM_REG(ax)
 #define _ASM_BX		__ASM_REG(bx)
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index befd172..a166fa5 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -122,6 +122,31 @@ union cpuid10_edx {
 extern void init_hw_perf_events(void);
 extern void perf_events_lapic_init(void);
 
+/*
+ * Take a snapshot of the regs. We only need a few of them:
+ * ip for PERF_SAMPLE_IP
+ * cs for user_mode() tests
+ * bp for callchains
+ * eflags, for future purposes, just in case
+ */
+#define PERF_SAVE_REGS(regs)				{\
+	memset((regs), 0, sizeof(*(regs)));		\
+	(regs)->cs = __KERNEL_CS;			\
+							\
+	asm volatile(					\
+		"call 1f\n"				\
+		"1:\n"					\
+		_ASM_POP " %[ip]\n"			\
+		_ASM_MOV "%%" _ASM_BP ", %[bp]\n"	\
+		"pushf\n"				\
+		_ASM_POP " %[flags]\n"			\
+		:  [ip]    "=m" ((regs)->ip),		\
+		   [bp]    "=m" ((regs)->bp),		\
+		   [flags] "=m" ((regs)->flags)		\
+		:: "memory"				\
+	);						\
+}
+
 #define PERF_EVENT_INDEX_OFFSET			0
 
 #else
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a661e79..f412be1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2807,6 +2807,16 @@ __weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 }
 
 /*
+ * Hot regs snapshot support -- arch specific
+ * This needs to be a macro because we want the current
+ * frame pointer.
+ */
+#ifndef PERF_SAVE_REGS
+#define PERF_SAVE_REGS(regs)	memset(regs, 0, sizeof(*regs));
+#endif
+
+
+/*
  * Output
  */
 static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
@@ -4337,6 +4347,8 @@ static const struct pmu perf_ops_task_clock = {
 void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 			  int entry_size)
 {
+	struct pt_regs regs;
+
 	struct perf_raw_record raw = {
 		.size = entry_size,
 		.data = record,
@@ -4347,14 +4359,11 @@ void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 		.raw = &raw,
 	};
 
-	struct pt_regs *regs = get_irq_regs();
-
-	if (!regs)
-		regs = task_pt_regs(current);
+	PERF_SAVE_REGS(&regs);
 
 	/* Trace events already protected against recursion */
 	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
-				&data, regs);
+				&data, &regs);
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
 
-- 
1.6.2.3


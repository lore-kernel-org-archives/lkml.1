Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0CEUzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:55:25 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:36566 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab0CEUzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:55:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JG9+OGPAmFcgkPgO6N9FuY8SBCnpjc9kKKEFx07KrZtz+pB/CP8LwN4qd9BC2/WgXL
         o0tyE9SWbxF2pODtdbB3UeN2Va35I7CCg5bbXVSvwfae1XtvOudvG+BTmUpjvJmiMjMt
         qJPNyntr1pKIM1g3MFQJGW9BC5AWizTF/sQ4o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Archs <linux-arch@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] perf: Introduce new perf_fetch_caller_regs() for hot regs snapshot
Date: Fri,  5 Mar 2010 21:55:16 +0100
Message-Id: <1267822517-5935-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <4B913A83.4040805@redhat.com>
References: <4B913A83.4040805@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Events that trigger overflows by interrupting a context can
use get_irq_regs() or task_pt_regs() to retrieve the state
when the event triggered. But this is not the case for some
other class of events like trace events as tracepoints are
executed in the same context than the code that triggered
the event.

It means we need a different api to capture the regs there,
namely we need a hot snapshot to get the most important
informations for perf: the instruction pointer to get the
event origin, the frame pointer for the callchain, the code
segment for user_mode() tests (we always use __KERNEL_CS as
trace events always occur from the kernel) and the eflags
for further purposes.

v2: rename perf_save_regs to perf_fetch_caller_regs as per
Masami's suggestion.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Archs <linux-arch@vger.kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |   12 ++++++++++
 arch/x86/kernel/dumpstack.h      |   15 +++++++++++++
 include/linux/perf_event.h       |   42 +++++++++++++++++++++++++++++++++++++-
 kernel/perf_event.c              |    5 ++++
 4 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 641ccb9..4c1f430 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1662,6 +1662,18 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	return entry;
 }
 
+void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip)
+{
+	regs->ip = ip;
+	/*
+	 * perf_arch_fetch_caller_regs adds another call, we need to increment
+	 * the skip level
+	 */
+	regs->bp = rewind_frame_pointer(skip + 1);
+	regs->cs = __KERNEL_CS;
+	local_save_flags(regs->flags);
+}
+
 void hw_perf_event_setup_online(int cpu)
 {
 	init_debug_store_on_cpu(cpu);
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
index 4fd1420..29e5f7c 100644
--- a/arch/x86/kernel/dumpstack.h
+++ b/arch/x86/kernel/dumpstack.h
@@ -29,4 +29,19 @@ struct stack_frame {
 	struct stack_frame *next_frame;
 	unsigned long return_address;
 };
+
+static inline unsigned long rewind_frame_pointer(int n)
+{
+	struct stack_frame *frame;
+
+	get_bp(frame);
+
+#ifdef CONFIG_FRAME_POINTER
+	while (n--)
+		frame = frame->next_frame;
 #endif
+
+	return (unsigned long)frame;
+}
+
+#endif /* DUMPSTACK_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 04f06b4..c859bee 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -452,6 +452,7 @@ enum perf_callchain_context {
 #include <linux/fs.h>
 #include <linux/pid_namespace.h>
 #include <linux/workqueue.h>
+#include <linux/ftrace.h>
 #include <asm/atomic.h>
 
 #define PERF_MAX_STACK_DEPTH		255
@@ -840,6 +841,44 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 		__perf_sw_event(event_id, nr, nmi, regs, addr);
 }
 
+extern void
+perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip);
+
+/*
+ * Take a snapshot of the regs. Skip ip and frame pointer to
+ * the nth caller. We only need a few of the regs:
+ * - ip for PERF_SAMPLE_IP
+ * - cs for user_mode() tests
+ * - bp for callchains
+ * - eflags, for future purposes, just in case
+ */
+static inline void perf_fetch_caller_regs(struct pt_regs *regs, int skip)
+{
+	unsigned long ip;
+
+	memset(regs, 0, sizeof(*regs));
+
+	switch (skip) {
+	case 1 :
+		ip = CALLER_ADDR0;
+		break;
+	case 2 :
+		ip = CALLER_ADDR1;
+		break;
+	case 3 :
+		ip = CALLER_ADDR2;
+		break;
+	case 4:
+		ip = CALLER_ADDR3;
+		break;
+	/* No need to support further for now */
+	default:
+		ip = 0;
+	}
+
+	return perf_arch_fetch_caller_regs(regs, ip, skip);
+}
+
 extern void __perf_event_mmap(struct vm_area_struct *vma);
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)
@@ -858,7 +897,8 @@ extern int sysctl_perf_event_mlock;
 extern int sysctl_perf_event_sample_rate;
 
 extern void perf_event_init(void);
-extern void perf_tp_event(int event_id, u64 addr, u64 count, void *record, int entry_size);
+extern void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
+			  int entry_size, struct pt_regs *regs);
 extern void perf_bp_event(struct perf_event *event, void *data);
 
 #ifndef perf_misc_flags
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a661e79..1c3059b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2806,6 +2806,11 @@ __weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	return NULL;
 }
 
+__weak
+void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip)
+{
+}
+
 /*
  * Output
  */
-- 
1.6.2.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZLFHfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZLFHfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbZLFHfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:35:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59919 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbZLFHfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:35:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=U/ry+TtXJcVb1xjjge2R9a79Oe8ZE75JOeo6ZyCuiYJ2UNt5DoB1TNsqADUJfjH5DJ
         M27kYrRestGi/7rYnVNjpKh79k3wZ+MnF298/FLkgF+J2/oi2izArMIHIlfk5NBpLjeP
         VODmQiu3EstxRV/3NswxOls9fvbXQnWUuqttI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 5/9] hw-breakpoints: Use overflow handler instead of the event callback
Date: Sun,  6 Dec 2009 08:34:54 +0100
Message-Id: <1260084898-11686-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
References: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct perf_event::event callback was called when a breakpoint
triggers. But this is a rather opaque callback, pretty
tied-only to the breakpoint API and not really integrated into perf
as it triggers even when we don't overflow.

We prefer to use overflow_handler() as it fits into the perf events
rules, being called only when we overflow.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/hw_breakpoint.c         |    5 ++---
 arch/x86/kernel/ptrace.c                |    9 ++++++---
 include/linux/hw_breakpoint.h           |   25 +++++++++++--------------
 include/linux/perf_event.h              |   13 +++++++------
 kernel/hw_breakpoint.c                  |   17 +++++------------
 kernel/perf_event.c                     |   24 +++++++++---------------
 kernel/trace/trace_ksym.c               |    5 +++--
 samples/hw_breakpoint/data_breakpoint.c |    7 +++++--
 8 files changed, 48 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index d42f65a..05d5fec 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -362,8 +362,7 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp,
 		return ret;
 	}
 
-	if (bp->callback)
-		ret = arch_store_info(bp);
+	ret = arch_store_info(bp);
 
 	if (ret < 0)
 		return ret;
@@ -519,7 +518,7 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 			break;
 		}
 
-		(bp->callback)(bp, args->regs);
+		perf_bp_event(bp, args->regs);
 
 		rcu_read_unlock();
 	}
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index dbb3955..b361d28 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -555,7 +555,9 @@ static int genregs_set(struct task_struct *target,
 	return ret;
 }
 
-static void ptrace_triggered(struct perf_event *bp, void *data)
+static void ptrace_triggered(struct perf_event *bp, int nmi,
+			     struct perf_sample_data *data,
+			     struct pt_regs *regs)
 {
 	int i;
 	struct thread_struct *thread = &(current->thread);
@@ -599,7 +601,7 @@ ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
 {
 	int err;
 	int gen_len, gen_type;
-	DEFINE_BREAKPOINT_ATTR(attr);
+	struct perf_event_attr attr;
 
 	/*
 	 * We shoud have at least an inactive breakpoint at this
@@ -721,9 +723,10 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 {
 	struct perf_event *bp;
 	struct thread_struct *t = &tsk->thread;
-	DEFINE_BREAKPOINT_ATTR(attr);
+	struct perf_event_attr attr;
 
 	if (!t->ptrace_bps[nr]) {
+		hw_breakpoint_init(&attr);
 		/*
 		 * Put stub len and type to register (reserve) an inactive but
 		 * correct bp
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index d33096e..4d14a38 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -20,19 +20,16 @@ enum {
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 
-/* As it's for in-kernel or ptrace use, we want it to be pinned */
-#define DEFINE_BREAKPOINT_ATTR(name)	\
-struct perf_event_attr name = {		\
-	.type = PERF_TYPE_BREAKPOINT,	\
-	.size = sizeof(name),		\
-	.pinned = 1,			\
-};
-
 static inline void hw_breakpoint_init(struct perf_event_attr *attr)
 {
 	attr->type = PERF_TYPE_BREAKPOINT;
 	attr->size = sizeof(*attr);
+	/*
+	 * As it's for in-kernel or ptrace use, we want it to be pinned
+	 * and to call its callback every hits.
+	 */
 	attr->pinned = 1;
+	attr->sample_period = 1;
 }
 
 static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
@@ -52,7 +49,7 @@ static inline int hw_breakpoint_len(struct perf_event *bp)
 
 extern struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_callback_t triggered,
+			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk);
 
 /* FIXME: only change from the attr, and don't unregister */
@@ -64,12 +61,12 @@ modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr);
  */
 extern struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
-				perf_callback_t triggered,
+				perf_overflow_handler_t	triggered,
 				int cpu);
 
 extern struct perf_event **
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_callback_t triggered);
+			    perf_overflow_handler_t triggered);
 
 extern int register_perf_hw_breakpoint(struct perf_event *bp);
 extern int __register_perf_hw_breakpoint(struct perf_event *bp);
@@ -90,18 +87,18 @@ static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
 
 static inline struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_callback_t triggered,
+			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk)	{ return NULL; }
 static inline struct perf_event *
 modify_user_hw_breakpoint(struct perf_event *bp,
 			  struct perf_event_attr *attr)	{ return NULL; }
 static inline struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
-				perf_callback_t triggered,
+				perf_overflow_handler_t	 triggered,
 				int cpu)		{ return NULL; }
 static inline struct perf_event **
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_callback_t triggered)	{ return NULL; }
+			    perf_overflow_handler_t triggered)	{ return NULL; }
 static inline int
 register_perf_hw_breakpoint(struct perf_event *bp)	{ return -ENOSYS; }
 static inline int
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 84bd28a..d2f2667 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -565,10 +565,13 @@ struct perf_pending_entry {
 	void (*func)(struct perf_pending_entry *);
 };
 
-typedef void (*perf_callback_t)(struct perf_event *, void *);
-
 struct perf_sample_data;
 
+typedef void (*perf_callback_t)(struct perf_event *, void *);
+typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
+					struct perf_sample_data *,
+					struct pt_regs *regs);
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -660,9 +663,7 @@ struct perf_event {
 	struct pid_namespace		*ns;
 	u64				id;
 
-	void (*overflow_handler)(struct perf_event *event,
-			int nmi, struct perf_sample_data *data,
-			struct pt_regs *regs);
+	perf_overflow_handler_t		overflow_handler;
 
 #ifdef CONFIG_EVENT_PROFILE
 	struct event_filter		*filter;
@@ -779,7 +780,7 @@ extern struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				int cpu,
 				pid_t pid,
-				perf_callback_t callback);
+				perf_overflow_handler_t callback);
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
 
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 2d10b01..b600fc2 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -259,7 +259,7 @@ void release_bp_slot(struct perf_event *bp)
 }
 
 
-int __register_perf_hw_breakpoint(struct perf_event *bp)
+int register_perf_hw_breakpoint(struct perf_event *bp)
 {
 	int ret;
 
@@ -276,19 +276,12 @@ int __register_perf_hw_breakpoint(struct perf_event *bp)
 	 * This is a quick hack that will be removed soon, once we remove
 	 * the tmp breakpoints from ptrace
 	 */
-	if (!bp->attr.disabled || bp->callback == perf_bp_event)
+	if (!bp->attr.disabled || !bp->overflow_handler)
 		ret = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
 
 	return ret;
 }
 
-int register_perf_hw_breakpoint(struct perf_event *bp)
-{
-	bp->callback = perf_bp_event;
-
-	return __register_perf_hw_breakpoint(bp);
-}
-
 /**
  * register_user_hw_breakpoint - register a hardware breakpoint for user space
  * @attr: breakpoint attributes
@@ -297,7 +290,7 @@ int register_perf_hw_breakpoint(struct perf_event *bp)
  */
 struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_callback_t triggered,
+			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk)
 {
 	return perf_event_create_kernel_counter(attr, -1, tsk->pid, triggered);
@@ -322,7 +315,7 @@ modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr)
 	unregister_hw_breakpoint(bp);
 
 	return perf_event_create_kernel_counter(attr, -1, bp->ctx->task->pid,
-						bp->callback);
+						bp->overflow_handler);
 }
 EXPORT_SYMBOL_GPL(modify_user_hw_breakpoint);
 
@@ -347,7 +340,7 @@ EXPORT_SYMBOL_GPL(unregister_hw_breakpoint);
  */
 struct perf_event **
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_callback_t triggered)
+			    perf_overflow_handler_t triggered)
 {
 	struct perf_event **cpu_events, **pevent, *bp;
 	long err;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 6b7ddba..fd43ff4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4286,15 +4286,8 @@ static void bp_perf_event_destroy(struct perf_event *event)
 static const struct pmu *bp_perf_event_init(struct perf_event *bp)
 {
 	int err;
-	/*
-	 * The breakpoint is already filled if we haven't created the counter
-	 * through perf syscall
-	 * FIXME: manage to get trigerred to NULL if it comes from syscalls
-	 */
-	if (!bp->callback)
-		err = register_perf_hw_breakpoint(bp);
-	else
-		err = __register_perf_hw_breakpoint(bp);
+
+	err = register_perf_hw_breakpoint(bp);
 	if (err)
 		return ERR_PTR(err);
 
@@ -4390,7 +4383,7 @@ perf_event_alloc(struct perf_event_attr *attr,
 		   struct perf_event_context *ctx,
 		   struct perf_event *group_leader,
 		   struct perf_event *parent_event,
-		   perf_callback_t callback,
+		   perf_overflow_handler_t overflow_handler,
 		   gfp_t gfpflags)
 {
 	const struct pmu *pmu;
@@ -4433,10 +4426,10 @@ perf_event_alloc(struct perf_event_attr *attr,
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
-	if (!callback && parent_event)
-		callback = parent_event->callback;
+	if (!overflow_handler && parent_event)
+		overflow_handler = parent_event->overflow_handler;
 	
-	event->callback	= callback;
+	event->overflow_handler	= overflow_handler;
 
 	if (attr->disabled)
 		event->state = PERF_EVENT_STATE_OFF;
@@ -4776,7 +4769,8 @@ err_put_context:
  */
 struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
-				 pid_t pid, perf_callback_t callback)
+				 pid_t pid,
+				 perf_overflow_handler_t overflow_handler)
 {
 	struct perf_event *event;
 	struct perf_event_context *ctx;
@@ -4793,7 +4787,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	}
 
 	event = perf_event_alloc(attr, cpu, ctx, NULL,
-				     NULL, callback, GFP_KERNEL);
+				 NULL, overflow_handler, GFP_KERNEL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err_put_context;
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index ddfa0fd..acb87d4 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -79,11 +79,12 @@ void ksym_collect_stats(unsigned long hbp_hit_addr)
 }
 #endif /* CONFIG_PROFILE_KSYM_TRACER */
 
-void ksym_hbp_handler(struct perf_event *hbp, void *data)
+void ksym_hbp_handler(struct perf_event *hbp, int nmi,
+		      struct perf_sample_data *data,
+		      struct pt_regs *regs)
 {
 	struct ring_buffer_event *event;
 	struct ksym_trace_entry *entry;
-	struct pt_regs *regs = data;
 	struct ring_buffer *buffer;
 	int pc;
 
diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
index 2952550..c69cbe9 100644
--- a/samples/hw_breakpoint/data_breakpoint.c
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -41,7 +41,9 @@ module_param_string(ksym, ksym_name, KSYM_NAME_LEN, S_IRUGO);
 MODULE_PARM_DESC(ksym, "Kernel symbol to monitor; this module will report any"
 			" write operations on the kernel symbol");
 
-static void sample_hbp_handler(struct perf_event *temp, void *data)
+static void sample_hbp_handler(struct perf_event *bp, int nmi,
+			       struct perf_sample_data *data,
+			       struct pt_regs *regs)
 {
 	printk(KERN_INFO "%s value is changed\n", ksym_name);
 	dump_stack();
@@ -51,8 +53,9 @@ static void sample_hbp_handler(struct perf_event *temp, void *data)
 static int __init hw_break_module_init(void)
 {
 	int ret;
-	DEFINE_BREAKPOINT_ATTR(attr);
+	struct perf_event_attr attr;
 
+	hw_breakpoint_init(&attr);
 	attr.bp_addr = kallsyms_lookup_name(ksym_name);
 	attr.bp_len = HW_BREAKPOINT_LEN_4;
 	attr.bp_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
-- 
1.6.2.3


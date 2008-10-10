Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYJJMew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYJJMew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 08:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYJJMeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 08:34:44 -0400
Received: from perso1.free.fr ([212.27.63.203]:49854 "EHLO perso1.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbYJJMen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 08:34:43 -0400
XPARM: thesermon.free.fr
XPARAM2: 193.50.29.42
Subject: [PATCH 6/6] tracing/fastboot: Print ktime of sched events when boot tracing
From: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 10 Oct 2008 14:34:50
To: Ingo Molnar <mingo@elte.hu>
Message-Id: <20081010123450.8D3E6D1BCF0@perso1.free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When we use the boot tracer, we want the sched events to be printed with the
same timestamp than initcall events.
So we have to create a new type of entry which contains sched event attributes
and the ktime of the creation of the entry.
Then the output is handled by the boot tracer.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Arjan van de Ven <arjan@infradead.org>
---
 kernel/trace/trace.c      |  107 ++++++++++++++++++++++++++++++++++++++++----
 kernel/trace/trace.h      |   22 +++++++++
 kernel/trace/trace_boot.c |   96 ++++++++++++++++++++++++++++++++--------
 3 files changed, 196 insertions(+), 29 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index acc21bb..4300521 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -622,7 +622,7 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	spin_unlock(&trace_cmdline_lock);
 }
 
-static char *trace_find_cmdline(int pid)
+char *trace_find_cmdline(int pid)
 {
 	char *cmdline = "<...>";
 	unsigned map;
@@ -774,12 +774,12 @@ __trace_special(void *__tr, void *__data,
 	ftrace_trace_special(__tr, __data, arg1, arg2, arg3, preempt_count());
 }
 
-void
-tracing_sched_switch_trace(struct trace_array *tr,
-			   struct trace_array_cpu *data,
-			   struct task_struct *prev,
-			   struct task_struct *next,
-			   unsigned long flags, int pc)
+static void
+__tracing_sched_switch_trace(struct trace_array *tr,
+			     struct trace_array_cpu *data,
+			     struct task_struct *prev,
+			     struct task_struct *next,
+			     unsigned long flags, int pc)
 {
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
@@ -803,13 +803,85 @@ tracing_sched_switch_trace(struct trace_array *tr,
 	ftrace_trace_stack(tr, data, flags, 5, pc);
 }
 
+static void
+__tracing_sched_switch_boot_trace(struct trace_array *tr,
+				  struct trace_array_cpu *data,
+				  struct task_struct *prev,
+				  struct task_struct *next,
+				  unsigned long flags, int pc)
+{
+	struct ring_buffer_event *event;
+	struct ctx_switch_boot_entry *entry;
+	unsigned long irq_flags;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					   &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type			= TRACE_CTX_BOOT;
+	entry->prev_pid			= prev->pid;
+	entry->prev_prio		= prev->prio;
+	entry->prev_state		= prev->state;
+	entry->next_pid			= next->pid;
+	entry->next_prio		= next->prio;
+	entry->next_state		= next->state;
+	entry->next_cpu	= task_cpu(next);
+	entry->time			= ktime_get();
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+}
+
 void
-tracing_sched_wakeup_trace(struct trace_array *tr,
+tracing_sched_switch_trace(struct trace_array *tr,
 			   struct trace_array_cpu *data,
-			   struct task_struct *wakee,
-			   struct task_struct *curr,
+			   struct task_struct *prev,
+			   struct task_struct *next,
 			   unsigned long flags, int pc)
 {
+	if (current_trace == &boot_tracer)
+		__tracing_sched_switch_boot_trace(tr, data, prev,
+						  next, flags, pc);
+	else
+		__tracing_sched_switch_trace(tr, data, prev, next, flags, pc);
+}
+
+static void
+__tracing_sched_wakeup_boot_trace(struct trace_array *tr,
+				  struct trace_array_cpu *data,
+				  struct task_struct *wakee,
+				  struct task_struct *curr,
+				  unsigned long flags, int pc)
+{
+	struct ring_buffer_event *event;
+	struct ctx_switch_boot_entry *entry;
+	unsigned long irq_flags;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					   &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type			= TRACE_WAKE_BOOT;
+	entry->prev_pid			= curr->pid;
+	entry->prev_prio		= curr->prio;
+	entry->prev_state		= curr->state;
+	entry->next_pid			= wakee->pid;
+	entry->next_prio		= wakee->prio;
+	entry->next_state		= wakee->state;
+	entry->next_cpu			= task_cpu(wakee);
+	entry->time			= ktime_get();
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+}
+
+static void
+__tracing_sched_wakeup_trace(struct trace_array *tr,
+			     struct trace_array_cpu *data,
+			     struct task_struct *wakee,
+			     struct task_struct *curr,
+			     unsigned long flags, int pc)
+{
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
 	unsigned long irq_flags;
@@ -835,6 +907,21 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 }
 
 void
+tracing_sched_wakeup_trace(struct trace_array *tr,
+			     struct trace_array_cpu *data,
+			     struct task_struct *wakee,
+			     struct task_struct *curr,
+			     unsigned long flags, int pc)
+{
+
+	if (current_trace == &boot_tracer)
+		__tracing_sched_wakeup_boot_trace(tr, data, wakee,
+						  curr, flags, pc);
+	else
+		__tracing_sched_wakeup_trace(tr, data, wakee, curr, flags, pc);
+}
+
+void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
 {
 	struct trace_array *tr = &global_trace;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d45a3cd..b7fe667 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,6 +22,8 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BOOT,
+	TRACE_CTX_BOOT,
+	TRACE_WAKE_BOOT,
 
 	__TRACE_LAST_TYPE
 };
@@ -66,6 +68,24 @@ struct ctx_switch_entry {
 };
 
 /*
+ * Context switch trace entry with ktime timestamp.
+ * It is required for the boot tracer which needs unified
+ * time measure between initcalls and sched events.
+ */
+
+struct ctx_switch_boot_entry {
+	struct trace_entry	ent;
+	unsigned int		prev_pid;
+	unsigned char		prev_prio;
+	unsigned char		prev_state;
+	unsigned int		next_pid;
+	unsigned char		next_prio;
+	unsigned char		next_state;
+	unsigned int		next_cpu;
+	ktime_t			time;
+};
+
+/*
  * Special (free-form) trace entry:
  */
 struct special_entry {
@@ -218,6 +238,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		IF_ASSIGN(var, ent, struct ctx_switch_boot_entry, 0);	\
 		__ftrace_bad_type();					\
 	} while (0)
 
@@ -392,6 +413,7 @@ extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt);
 extern long ns2usecs(cycle_t nsec);
 extern int trace_vprintk(unsigned long ip, const char *fmt, va_list args);
+extern char *trace_find_cmdline(int pid);
 
 extern unsigned long trace_flags;
 
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 6bbc879..11e6573 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -14,6 +14,7 @@
 
 static struct trace_array *boot_trace;
 static bool pre_initcalls_finished;
+static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
 
 /* Tells the boot tracer that the pre_smp_initcalls are finished.
  * So we are ready .
@@ -71,34 +72,91 @@ static enum print_line_t initcall_print_line(struct trace_iterator *iter)
 	struct timespec calltime = ktime_to_timespec(it->calltime);
 	struct timespec rettime = ktime_to_timespec(it->rettime);
 
-	if (entry->type == TRACE_BOOT) {
-		ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
-					  calltime.tv_sec,
-					  calltime.tv_nsec,
-					  it->func, it->caller);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-
-		ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
-					  "returned %d after %lld msecs\n",
-					  rettime.tv_sec,
-					  rettime.tv_nsec,
-					  it->func, it->result, it->duration);
-
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		return TRACE_TYPE_HANDLED;
-	}
+	ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
+				  calltime.tv_sec,
+				  calltime.tv_nsec,
+				  it->func, it->caller);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
+				  "returned %d after %lld msecs\n",
+				  rettime.tv_sec,
+				  rettime.tv_nsec,
+				  it->func, it->result, it->duration);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	return TRACE_TYPE_HANDLED;
+
+}
+
+static enum print_line_t sched_switch_print_line(struct trace_iterator *iter)
+{
+	int ret;
+	struct trace_entry *entry = iter->ent;
+	struct ctx_switch_boot_entry *field;
+	struct trace_seq *s = &iter->seq;
+	struct timespec time;
+	int S, T;
+	char *comm;
+
+	trace_assign_type(field, entry);
+	time = ktime_to_timespec(field->time);
+
+	comm = trace_find_cmdline(iter->ent->pid);
+
+	ret = trace_seq_printf(s, "[%5ld.%09ld] ",
+				  time.tv_sec,
+				  time.tv_nsec);
+
+	ret = trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	S = field->prev_state < sizeof(state_to_char) ?
+		state_to_char[field->prev_state] : 'X';
+	T = field->next_state < sizeof(state_to_char) ?
+		state_to_char[field->next_state] : 'X';
+	ret = trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c\n",
+			       field->prev_pid,
+			       field->prev_prio,
+			       S,
+			       entry->type == TRACE_CTX ? "==>" : "  +",
+			       field->next_cpu,
+			       field->next_pid,
+			       field->next_prio,
+			       T);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t boot_trace_print_line(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+
+	if (entry->type == TRACE_BOOT)
+		return initcall_print_line(iter);
+	if (entry->type == TRACE_CTX_BOOT || entry->type == TRACE_WAKE_BOOT)
+		return sched_switch_print_line(iter);
 	return TRACE_TYPE_UNHANDLED;
 }
 
+
 struct tracer boot_tracer __read_mostly =
 {
 	.name		= "initcall",
 	.init		= boot_trace_init,
 	.reset		= reset_boot_trace,
 	.ctrl_update	= boot_trace_ctrl_update,
-	.print_line	= initcall_print_line,
+	.print_line	= boot_trace_print_line,
 };
 
 void trace_boot(struct boot_trace *it, initcall_t fn)


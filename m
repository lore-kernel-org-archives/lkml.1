Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYKBVS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYKBVS7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYKBVSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:18:24 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:26423 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbYKBVSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:18:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=sTfyRGSqp+O3MH8E5vrRHgVEnSsrwpwdjhdvROVIb5+iCzPG36usc4kSYva3dySCJe
         hSguV2e3HK1NAcqw6KlTeyT8itPpGlPEUpH66nn7ej7xXszW+oBdjSUBBOuI2Cqoi5Pe
         /MIeDW2T8EWotX2kULUNy2tabCYaaj+Shgx3U=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, edwintorok@gmail.com
Subject: [PATCH] Add support for userspace stacktraces in tracing/iter_ctrl
Date: Sun,  2 Nov 2008 23:18:13 +0200
Message-Id: <1225660694-19765-2-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1225660694-19765-1-git-send-email-edwintorok@gmail.com>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usage example:
mount -t debugfs nodev /sys/kernel/debug
cd /sys/kernel/debug/tracing
echo userstacktrace >iter_ctrl
echo sched_switch >current_tracer
echo 1 >tracing_enabled
.... run application ...
echo 0 >tracing_enabled

Then read one of 'trace','latency_trace','trace_pipe'
It is recomended to compile your userspace programs with frame pointers
(at least glibc + the app you are tracing).

Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 Documentation/ftrace.txt     |    5 ++-
 arch/x86/kernel/stacktrace.c |   57 +++++++++++++++++++++++++
 include/linux/stacktrace.h   |    8 ++++
 kernel/trace/trace.c         |   93 ++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h         |    9 ++++
 5 files changed, 171 insertions(+), 1 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index ea5a827..b81618e 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -330,7 +330,7 @@ output. To see what is available, simply cat the file:
 
   cat /debug/tracing/iter_ctrl
   print-parent nosym-offset nosym-addr noverbose noraw nohex nobin \
- noblock nostacktrace nosched-tree
+ noblock nostacktrace nosched-tree nouserstacktrace
 
 To disable one of the options, echo in the option prepended with "no".
 
@@ -384,6 +384,9 @@ Here are the available options:
 		When a trace is recorded, so is the stack of functions.
 		This allows for back traces of trace sites.
 
+  userstacktrace - This option changes the trace.
+		   It records a stacktrace of the current userspace thread.
+
   sched-tree - TBD (any users??)
 
 
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index d1d850a..000a965 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -6,6 +6,7 @@
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
 #include <linux/module.h>
+#include <linux/uaccess.h>
 #include <asm/stacktrace.h>
 
 static void save_stack_warning(void *data, char *msg)
@@ -90,3 +91,59 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
+
+/* Userspace stacktrace - based on kernel/trace/trace_sysprof.c */
+
+struct stack_frame {
+	const void __user	*next_fp;
+	unsigned long		return_address;
+};
+
+static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
+{
+	int ret;
+
+	if (!access_ok(VERIFY_READ, fp, sizeof(*frame)))
+		return 0;
+
+	ret = 1;
+	pagefault_disable();
+	if (__copy_from_user_inatomic(frame, fp, sizeof(*frame)))
+		ret = 0;
+	pagefault_enable();
+
+	return ret;
+}
+
+void save_stack_trace_user(struct stack_trace *trace)
+{
+	/*
+	 * Trace user stack if we are not a kernel thread
+	 */
+	if (current->mm) {
+		const struct pt_regs *regs = task_pt_regs(current);
+		const void __user *fp = (const void __user *)regs->bp;
+
+		if (trace->nr_entries < trace->max_entries)
+			trace->entries[trace->nr_entries++] = regs->ip;
+
+		while (trace->nr_entries < trace->max_entries) {
+			struct stack_frame frame;
+			frame.next_fp = NULL;
+			frame.return_address = 0;
+			if (!copy_stack_frame(fp, &frame))
+				break;
+			if ((unsigned long)fp < regs->sp)
+				break;
+			if (frame.return_address)
+				trace->entries[trace->nr_entries++] =
+					frame.return_address;
+			if (fp == frame.next_fp)
+				break;
+			fp = frame.next_fp;
+		}
+	}
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX;
+}
+
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 6b8e54a..46704a5 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -18,9 +18,17 @@ extern void save_stack_trace_tsk(struct task_struct *tsk,
 				struct stack_trace *trace);
 
 extern void print_stack_trace(struct stack_trace *trace, int spaces);
+
+#ifdef CONFIG_X86
+extern void save_stack_trace_user(struct stack_trace *trace);
+#else
+# define save_stack_trace_user(trace)              do { } while (0)
+#endif
+
 #else
 # define save_stack_trace(trace)			do { } while (0)
 # define save_stack_trace_tsk(tsk, trace)		do { } while (0)
+# define save_stack_trace_user(trace)              do { } while (0)
 # define print_stack_trace(trace, spaces)		do { } while (0)
 #endif
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5b8c90d..bb965af 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -235,6 +235,7 @@ static const char *trace_options[] = {
 	"stacktrace",
 	"sched-tree",
 	"ftrace_printk",
+	"userstacktrace",
 	NULL
 };
 
@@ -762,6 +763,44 @@ void __trace_stack(struct trace_array *tr,
 	ftrace_trace_stack(tr, data, flags, skip, preempt_count());
 }
 
+static void ftrace_trace_userstack(struct trace_array *tr,
+		   struct trace_array_cpu *data,
+		   unsigned long flags, int pc)
+{
+	struct userstack_entry *entry;
+	struct stack_trace trace;
+	struct ring_buffer_event *event;
+	unsigned long irq_flags;
+
+	if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
+		return;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type		= TRACE_USER_STACK;
+
+	memset(&entry->caller, 0, sizeof(entry->caller));
+
+	trace.nr_entries	= 0;
+	trace.max_entries	= FTRACE_STACK_ENTRIES;
+	trace.skip		= 0;
+	trace.entries		= entry->caller;
+
+	save_stack_trace_user(&trace);
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+}
+
+void __trace_userstack(struct trace_array *tr,
+		   struct trace_array_cpu *data,
+		   unsigned long flags)
+{
+	ftrace_trace_userstack(tr, data, flags, preempt_count());
+}
+
 static void
 ftrace_trace_special(void *__tr, void *__data,
 		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
@@ -785,6 +824,7 @@ ftrace_trace_special(void *__tr, void *__data,
 	entry->arg3			= arg3;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 	ftrace_trace_stack(tr, data, irq_flags, 4, pc);
+	ftrace_trace_userstack(tr, data, irq_flags, pc);
 
 	trace_wake_up();
 }
@@ -823,6 +863,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
 	entry->next_cpu	= task_cpu(next);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 	ftrace_trace_stack(tr, data, flags, 5, pc);
+	ftrace_trace_userstack(tr, data, flags, pc);
 }
 
 void
@@ -852,6 +893,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	entry->next_cpu			= task_cpu(wakee);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 	ftrace_trace_stack(tr, data, flags, 6, pc);
+	ftrace_trace_userstack(tr, data, flags, pc);
 
 	trace_wake_up();
 }
@@ -1175,6 +1217,31 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 	return ret;
 }
 
+static int
+seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
+		unsigned long sym_flags)
+{
+	int ret = 1;
+	unsigned i;
+
+	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
+		unsigned long ip = entry->caller[i];
+
+		if (ip == ULONG_MAX || !ret)
+			break;
+		if (i)
+			ret = trace_seq_puts(s, " <- ");
+		if (!ip) {
+			ret = trace_seq_puts(s, "??");
+			continue;
+		}
+		if (ret /*&& (sym_flags & TRACE_ITER_SYM_ADDR)*/)
+			ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
+	}
+
+	return ret;
+}
+
 static void print_lat_help_header(struct seq_file *m)
 {
 	seq_puts(m, "#                  _------=> CPU#            \n");
@@ -1462,6 +1529,16 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
+	case TRACE_USER_STACK: {
+		struct userstack_entry *field;
+
+		trace_assign_type(field, entry);
+
+		seq_print_userip_objs(field, s, sym_flags);
+		if (entry->flags & TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
+	}
 	default:
 		trace_seq_printf(s, "Unknown type %d\n", entry->type);
 	}
@@ -1598,6 +1675,19 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
+	case TRACE_USER_STACK: {
+		struct userstack_entry *field;
+
+		trace_assign_type(field, entry);
+
+		ret = seq_print_userip_objs(field, s, sym_flags);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		ret = trace_seq_putc(s, '\n');
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		break;
+	}
 	}
 	return TRACE_TYPE_HANDLED;
 }
@@ -1657,6 +1747,7 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 		break;
 	}
 	case TRACE_SPECIAL:
+	case TRACE_USER_STACK:
 	case TRACE_STACK: {
 		struct special_entry *field;
 
@@ -1745,6 +1836,7 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 		break;
 	}
 	case TRACE_SPECIAL:
+	case TRACE_USER_STACK:
 	case TRACE_STACK: {
 		struct special_entry *field;
 
@@ -1799,6 +1891,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 		break;
 	}
 	case TRACE_SPECIAL:
+	case TRACE_USER_STACK:
 	case TRACE_STACK: {
 		struct special_entry *field;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8465ad0..4c81642 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,6 +22,7 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BOOT,
+	TRACE_USER_STACK,
 
 	__TRACE_LAST_TYPE
 };
@@ -38,6 +39,7 @@ struct trace_entry {
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
+	int			tgid;
 };
 
 /*
@@ -85,6 +87,11 @@ struct stack_entry {
 	unsigned long		caller[FTRACE_STACK_ENTRIES];
 };
 
+struct userstack_entry {
+	struct trace_entry	ent;
+	unsigned long		caller[FTRACE_STACK_ENTRIES];
+};
+
 /*
  * ftrace_printk entry:
  */
@@ -212,6 +219,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct ctx_switch_entry, 0);	\
 		IF_ASSIGN(var, ent, struct trace_field_cont, TRACE_CONT); \
 		IF_ASSIGN(var, ent, struct stack_entry, TRACE_STACK);	\
+		IF_ASSIGN(var, ent, struct userstack_entry, TRACE_USER_STACK);\
 		IF_ASSIGN(var, ent, struct print_entry, TRACE_PRINT);	\
 		IF_ASSIGN(var, ent, struct special_entry, 0);		\
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_rw,		\
@@ -415,6 +423,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_STACKTRACE		= 0x100,
 	TRACE_ITER_SCHED_TREE		= 0x200,
 	TRACE_ITER_PRINTK		= 0x400,
+	TRACE_ITER_USERSTACKTRACE       = 0x800
 };
 
 extern struct tracer nop_trace;
-- 
1.5.6.5


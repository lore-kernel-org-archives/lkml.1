Return-Path: <linux-kernel-owner+w=401wt.eu-S1760807AbYJLNNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbYJLNNk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYJLNMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:12:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:42853 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbYJLNMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=uByTHCM875fjE9gMwL5lQXzvnmrfo8py3M6UQCR//f9x5ff56ATxyBm/Dlt9BXXavH
         iLwfxki/y+Mj+IEgPYwIS3RoCmn+aHsN+f4xLRauxPsC4e5gk+Ec2kbmVsysbXOxofzI
         /X97oAnC71h1S6RCWkeoz/ODEiQod6qaJ7+u0=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu, srostedt@redhat.com
Cc: a.p.zijlstra@chello.nl, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH 1/4] Add support for userspace stacktraces in tracing/iter_ctrl
Date: Sun, 12 Oct 2008 16:12:01 +0300
Message-Id: <1223817124-27239-3-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
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

Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 Documentation/ftrace.txt     |    5 ++-
 arch/x86/kernel/stacktrace.c |   57 +++++++++++++++++++++++++++++++++++
 include/linux/stacktrace.h   |    8 +++++
 kernel/trace/trace.c         |   67 ++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h         |    2 +
 5 files changed, 138 insertions(+), 1 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index d330fe3..f39cb68 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -327,7 +327,7 @@ output. To see what is available, simply cat the file:
 
   cat /debug/tracing/iter_ctrl
   print-parent nosym-offset nosym-addr noverbose noraw nohex nobin \
- noblock nostacktrace nosched-tree
+ noblock nostacktrace nosched-tree nouserstacktrace
 
 To disable one of the options, echo in the option prepended with "no".
 
@@ -381,6 +381,9 @@ Here are the available options:
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
index d345d64..4c17453 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -212,6 +212,7 @@ static const char *trace_options[] = {
 	"stacktrace",
 	"sched-tree",
 	"ftrace_printk",
+	"userstacktrace",
 	NULL
 };
 
@@ -735,6 +736,28 @@ void __trace_stack(struct trace_array *tr,
 	ftrace_trace_stack(tr, data, flags, skip, preempt_count());
 }
 
+static void __trace_userstack(struct trace_array *tr,
+		   struct trace_array_cpu *data,
+		   unsigned long flags)
+{
+	struct trace_entry *entry;
+	struct stack_trace trace;
+
+	if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
+		return;
+
+	entry			= tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, flags);
+	entry->type		= TRACE_USER_STACK;
+
+	memset(&entry->field.stack, 0, sizeof(entry->field.stack));
+	trace.nr_entries	= 0;
+	trace.max_entries	= FTRACE_STACK_ENTRIES;
+	trace.skip		= 0;
+	trace.entries		= entry->field.stack.caller;
+	save_stack_trace_user(&trace);
+}
+
 static void
 ftrace_trace_special(void *__tr, void *__data,
 		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
@@ -758,6 +781,7 @@ ftrace_trace_special(void *__tr, void *__data,
 	entry->arg3			= arg3;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 	ftrace_trace_stack(tr, data, irq_flags, 4, pc);
+	__trace_userstack(tr, data, irq_flags);
 
 	trace_wake_up();
 }
@@ -1151,6 +1175,31 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 	return ret;
 }
 
+static int
+seq_print_userip_objs(const struct trace_entry *entry, struct trace_seq *s,
+		unsigned long sym_flags)
+{
+	int ret = 1;
+	unsigned i;
+
+	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
+		unsigned long ip = entry->field.stack.caller[i];
+
+		if (ip == ULONG_MAX || !ret)
+			break;
+		if (i)
+			ret = trace_seq_puts(s, " <- ");
+		if (!ip) {
+			ret = trace_seq_puts(s, "??");
+			continue;
+		}
+		if (sym_flags & TRACE_ITER_SYM_ADDR)
+			ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
+	}
+
+	return ret;
+}
+
 static void print_lat_help_header(struct seq_file *m)
 {
 	seq_puts(m, "#                  _------=> CPU#            \n");
@@ -1437,6 +1486,10 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
+	case TRACE_USER_STACK:
+		seq_print_userip_objs(entry, s, sym_flags);
+		trace_seq_putc(s, '\n');
+		break;
 	default:
 		trace_seq_printf(s, "Unknown type %d\n", entry->type);
 	}
@@ -1572,6 +1625,14 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 		if (entry->flags & TRACE_FLAG_CONT)
 			trace_seq_print_cont(s, iter);
 		break;
+	case TRACE_USER_STACK:
+		ret = seq_print_userip_objs(entry, s, sym_flags);
+		if (!ret)
+			return 0;
+		ret = trace_seq_putc(s, '\n');
+		if (!ret)
+			return 0;
+		break;
 	}
 	}
 	return TRACE_TYPE_HANDLED;
@@ -1632,6 +1693,7 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 		break;
 	}
 	case TRACE_SPECIAL:
+	case TRACE_USER_STACK:
 	case TRACE_STACK: {
 		struct special_entry *field;
 
@@ -1720,6 +1782,7 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 		break;
 	}
 	case TRACE_SPECIAL:
+	case TRACE_USER_STACK:
 	case TRACE_STACK: {
 		struct special_entry *field;
 
@@ -1774,6 +1837,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 		break;
 	}
 	case TRACE_SPECIAL:
+	case TRACE_USER_STACK:
 	case TRACE_STACK: {
 		struct special_entry *field;
 
@@ -3103,6 +3167,9 @@ void ftrace_dump(void)
 		atomic_inc(&global_trace.data[cpu]->disabled);
 	}
 
+	/* don't look at user memory in panic mode */
+	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
+
 	printk(KERN_TRACE "Dumping ftrace buffer:\n");
 
 	iter.tr = &global_trace;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f1f9957..3ad6343 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,6 +22,7 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BOOT,
+	TRACE_USER_STACK,
 
 	__TRACE_LAST_TYPE
 };
@@ -413,6 +414,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_STACKTRACE		= 0x100,
 	TRACE_ITER_SCHED_TREE		= 0x200,
 	TRACE_ITER_PRINTK		= 0x400,
+	TRACE_ITER_USERSTACKTRACE       = 0x800
 };
 
 extern struct tracer nop_trace;
-- 
1.5.6.5


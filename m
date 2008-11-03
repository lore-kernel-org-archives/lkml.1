Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYKCHsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYKCHsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 02:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYKCHsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 02:48:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37022 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbYKCHsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 02:48:07 -0500
Date: Mon, 3 Nov 2008 08:47:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081103074754.GB13727@elte.hu>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1225660694-19765-3-git-send-email-edwintorok@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> +		struct task_struct *task;
> +		/* we do the lookup on the thread group leader,
> +		 * since individual threads might have already quit! */

please use the customary comment style:

  /*
   * Comment .....
   * ...... goes here:
   */

> -		if (ret /*&& (sym_flags & TRACE_ITER_SYM_ADDR)*/)
> +		if (mm) {
> +			const struct vm_area_struct *vma = find_vma(mm, ip);
> +			if (vma) {
> +				file = vma->vm_file;
> +				vmstart = vma->vm_start;
> +			}
> +		}
> +		if (file) {
> +			ret = trace_seq_path(s, &file->f_path);
> +			if (ret)
> +				ret = trace_seq_printf(s, "[+0x%lx]",
> +						ip - vmstart);
> +		}
> +		if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
>  			ret = trace_seq_printf(s, " <" IP_FMT ">", ip);

the function is getting a bit large - would it make sense to split out 
this section into a helper inline function?

another small nit: i cleaned up the subject line and the commit log 
message for you - see the two patches below - could you please keep it 
for future (v3) submissions of these patches? It's just small 
formatting changes.

Your patches are a nice feature we want to have nevertheless - to be 
able to see where a user-space app is running has been one of the 
historically weak points of kernel instrumentation.

	Ingo

-------------->
Subject: tracing: add support for userspace stacktraces in tracing/iter_ctrl
From: Török Edwin <edwintorok@gmail.com>
Date: Sun, 2 Nov 2008 23:18:13 +0200

Impact: add new (default-off) tracing visualization feature

Usage example:

 mount -t debugfs nodev /sys/kernel/debug
 cd /sys/kernel/debug/tracing
 echo userstacktrace >iter_ctrl
 echo sched_switch >current_tracer
 echo 1 >tracing_enabled
 .... run application ...
 echo 0 >tracing_enabled

Then read one of 'trace','latency_trace','trace_pipe'.

To get the best output you can compile your userspace programs with
frame pointers (at least glibc + the app you are tracing).

Signed-off-by: Török Edwin <edwintorok@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/ftrace.txt     |    5 +-
 arch/x86/kernel/stacktrace.c |   57 ++++++++++++++++++++++++++
 include/linux/stacktrace.h   |    8 +++
 kernel/trace/trace.c         |   93 +++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h         |    9 ++++
 5 files changed, 171 insertions(+), 1 deletion(-)

Index: tip/Documentation/ftrace.txt
===================================================================
--- tip.orig/Documentation/ftrace.txt
+++ tip/Documentation/ftrace.txt
@@ -330,7 +330,7 @@ output. To see what is available, simply
 
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
 
 
Index: tip/arch/x86/kernel/stacktrace.c
===================================================================
--- tip.orig/arch/x86/kernel/stacktrace.c
+++ tip/arch/x86/kernel/stacktrace.c
@@ -6,6 +6,7 @@
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
 #include <linux/module.h>
+#include <linux/uaccess.h>
 #include <asm/stacktrace.h>
 
 static void save_stack_warning(void *data, char *msg)
@@ -90,3 +91,59 @@ void save_stack_trace_tsk(struct task_st
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
Index: tip/include/linux/stacktrace.h
===================================================================
--- tip.orig/include/linux/stacktrace.h
+++ tip/include/linux/stacktrace.h
@@ -18,9 +18,17 @@ extern void save_stack_trace_tsk(struct 
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
 
Index: tip/kernel/trace/trace.c
===================================================================
--- tip.orig/kernel/trace/trace.c
+++ tip/kernel/trace/trace.c
@@ -235,6 +235,7 @@ static const char *trace_options[] = {
 	"stacktrace",
 	"sched-tree",
 	"ftrace_printk",
+	"userstacktrace",
 	NULL
 };
 
@@ -762,6 +763,44 @@ void __trace_stack(struct trace_array *t
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
@@ -785,6 +824,7 @@ ftrace_trace_special(void *__tr, void *_
 	entry->arg3			= arg3;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 	ftrace_trace_stack(tr, data, irq_flags, 4, pc);
+	ftrace_trace_userstack(tr, data, irq_flags, pc);
 
 	trace_wake_up();
 }
@@ -823,6 +863,7 @@ tracing_sched_switch_trace(struct trace_
 	entry->next_cpu	= task_cpu(next);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 	ftrace_trace_stack(tr, data, flags, 5, pc);
+	ftrace_trace_userstack(tr, data, flags, pc);
 }
 
 void
@@ -852,6 +893,7 @@ tracing_sched_wakeup_trace(struct trace_
 	entry->next_cpu			= task_cpu(wakee);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 	ftrace_trace_stack(tr, data, flags, 6, pc);
+	ftrace_trace_userstack(tr, data, flags, pc);
 
 	trace_wake_up();
 }
@@ -1175,6 +1217,31 @@ seq_print_ip_sym(struct trace_seq *s, un
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
@@ -1462,6 +1529,16 @@ print_lat_fmt(struct trace_iterator *ite
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
@@ -1598,6 +1675,19 @@ static enum print_line_t print_trace_fmt
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
@@ -1657,6 +1747,7 @@ static enum print_line_t print_raw_fmt(s
 		break;
 	}
 	case TRACE_SPECIAL:
+	case TRACE_USER_STACK:
 	case TRACE_STACK: {
 		struct special_entry *field;
 
@@ -1745,6 +1836,7 @@ static enum print_line_t print_hex_fmt(s
 		break;
 	}
 	case TRACE_SPECIAL:
+	case TRACE_USER_STACK:
 	case TRACE_STACK: {
 		struct special_entry *field;
 
@@ -1799,6 +1891,7 @@ static enum print_line_t print_bin_fmt(s
 		break;
 	}
 	case TRACE_SPECIAL:
+	case TRACE_USER_STACK:
 	case TRACE_STACK: {
 		struct special_entry *field;
 
Index: tip/kernel/trace/trace.h
===================================================================
--- tip.orig/kernel/trace/trace.h
+++ tip/kernel/trace/trace.h
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

------------------->
Subject: tracing: identify which executable object the userspace address belongs to
From: Török Edwin <edwintorok@gmail.com>
Date: Sun, 2 Nov 2008 23:18:14 +0200

Impact: modify+improve the userstacktrace tracing visualization feature

Store thread group leader id, and use it to lookup the address in the
process's map. We could have looked up the address on thread's map,
but the thread might not exist by the time we are called. The process
might not exist either, but if you are reading trace_pipe, that is
unlikely.

Example usage:

 mount -t debugfs nodev /sys/kernel/debug
 cd /sys/kernel/debug/tracing
 echo userstacktrace >iter_ctrl
 echo sym-userobj >iter_ctrl
 echo sched_switch >current_tracer
 echo 1 >tracing_enabled
 cat trace_pipe >/tmp/trace&
 .... run application ...
 echo 0 >tracing_enabled
 cat /tmp/trace

You'll see stack entries like:

   /lib/libpthread-2.7.so[+0xd370]

You can convert them to function/line using:

   addr2line -fie /lib/libpthread-2.7.so 0xd370

Or:

   addr2line -fie /usr/lib/debug/libpthread-2.7.so 0xd370

For non-PIC/PIE executables this won't work:

   a.out[+0x73b]

You need to run the following: addr2line -fie a.out 0x40073b
(where 0x400000 is the default load address of a.out)

Signed-off-by: Török Edwin <edwintorok@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/ftrace.txt |   13 +++++++++++
 kernel/trace/trace.c     |   51 ++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace.h     |    3 +-
 3 files changed, 64 insertions(+), 3 deletions(-)

Index: tip/Documentation/ftrace.txt
===================================================================
--- tip.orig/Documentation/ftrace.txt
+++ tip/Documentation/ftrace.txt
@@ -330,7 +330,7 @@ output. To see what is available, simply
 
   cat /debug/tracing/iter_ctrl
   print-parent nosym-offset nosym-addr noverbose noraw nohex nobin \
- noblock nostacktrace nosched-tree nouserstacktrace
+ noblock nostacktrace nosched-tree nouserstacktrace nosym-userobj
 
 To disable one of the options, echo in the option prepended with "no".
 
@@ -387,6 +387,17 @@ Here are the available options:
   userstacktrace - This option changes the trace.
 		   It records a stacktrace of the current userspace thread.
 
+  sym-userobj - when user stacktrace are enabled, look up which object the
+		address belongs to, and print a relative address
+		This is especially useful when ASLR is on, otherwise you don't
+		get a chance to resolve the address to object/file/line after the app is no
+		longer running
+
+		The lookup is performed when you read trace,trace_pipe,latency_trace. Example:
+
+		a.out-1623  [000] 40874.465068: /root/a.out[+0x480] <-/root/a.out[+0
+x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]
+
   sched-tree - TBD (any users??)
 
 
Index: tip/kernel/trace/trace.c
===================================================================
--- tip.orig/kernel/trace/trace.c
+++ tip/kernel/trace/trace.c
@@ -236,6 +236,7 @@ static const char *trace_options[] = {
 	"sched-tree",
 	"ftrace_printk",
 	"userstacktrace",
+	"sym-userobj",
 	NULL
 };
 
@@ -382,6 +383,20 @@ trace_seq_putmem_hex(struct trace_seq *s
 	return trace_seq_putmem(s, hex, j);
 }
 
+static int
+trace_seq_path(struct trace_seq *s, struct path *path)
+{
+	int ret;
+	struct seq_file m;
+	m.count = s->len;
+	m.size = PAGE_SIZE;
+	m.buf = s->buffer;
+	ret = seq_path(&m, path, "\n");
+	if (ret)
+		s->len = m.count;
+	return ret;
+}
+
 static void
 trace_seq_reset(struct trace_seq *s)
 {
@@ -678,6 +693,7 @@ tracing_generic_entry_update(struct trac
 
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
+	entry->tgid               	= (tsk) ? tsk->tgid : 0;
 	entry->flags =
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
@@ -1221,11 +1237,26 @@ static int
 seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 		unsigned long sym_flags)
 {
+	struct mm_struct *mm = NULL;
 	int ret = 1;
 	unsigned i;
 
+	if (trace_flags & TRACE_ITER_SYM_USEROBJ) {
+		struct task_struct *task;
+		/* we do the lookup on the thread group leader,
+		 * since individual threads might have already quit! */
+		rcu_read_lock();
+		task = find_task_by_vpid(entry->ent.tgid);
+		rcu_read_unlock();
+
+		if (task)
+			mm = get_task_mm(task);
+	}
+
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 		unsigned long ip = entry->caller[i];
+		unsigned long vmstart = 0;
+		struct file *file = NULL;
 
 		if (ip == ULONG_MAX || !ret)
 			break;
@@ -1235,10 +1266,25 @@ seq_print_userip_objs(const struct users
 			ret = trace_seq_puts(s, "??");
 			continue;
 		}
-		if (ret /*&& (sym_flags & TRACE_ITER_SYM_ADDR)*/)
+		if (mm) {
+			const struct vm_area_struct *vma = find_vma(mm, ip);
+			if (vma) {
+				file = vma->vm_file;
+				vmstart = vma->vm_start;
+			}
+		}
+		if (file) {
+			ret = trace_seq_path(s, &file->f_path);
+			if (ret)
+				ret = trace_seq_printf(s, "[+0x%lx]",
+						ip - vmstart);
+		}
+		if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
 			ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
 	}
 
+	if (mm)
+		mmput(mm);
 	return ret;
 }
 
@@ -3239,6 +3285,9 @@ void ftrace_dump(void)
 		atomic_inc(&global_trace.data[cpu]->disabled);
 	}
 
+	/* don't look at user memory in panic mode */
+	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
+
 	printk(KERN_TRACE "Dumping ftrace buffer:\n");
 
 	iter.tr = &global_trace;
Index: tip/kernel/trace/trace.h
===================================================================
--- tip.orig/kernel/trace/trace.h
+++ tip/kernel/trace/trace.h
@@ -423,7 +423,8 @@ enum trace_iterator_flags {
 	TRACE_ITER_STACKTRACE		= 0x100,
 	TRACE_ITER_SCHED_TREE		= 0x200,
 	TRACE_ITER_PRINTK		= 0x400,
-	TRACE_ITER_USERSTACKTRACE       = 0x800
+	TRACE_ITER_USERSTACKTRACE       = 0x800,
+	TRACE_ITER_SYM_USEROBJ          = 0x1000
 };
 
 extern struct tracer nop_trace;

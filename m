Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbZCUBdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbZCUBdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 21:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbZCUBdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 21:33:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37112 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755514AbZCUBdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 21:33:01 -0400
Message-ID: <49C44400.6070804@redhat.com>
Date: Fri, 20 Mar 2009 21:33:52 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH -tip 3/5 V2] tracing: kprobe-tracer plugin supports arguments
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support probe arguments and add fetch functions.

changes from v1:
 - use __trace_bprintk().
 - check retval of probe_kernel_address().
 - fix defined() typo.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 Documentation/ftrace.txt    |   43 ++++--
 kernel/trace/trace_kprobe.c |  289 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 309 insertions(+), 23 deletions(-)


diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index a957adf..e539e0b 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -1329,17 +1329,30 @@ current_tracer, instead of that, just set probe points via
 /debug/tracing/kprobe_probes.

 Synopsis of kprobe_probes:
-  p SYMBOL[+offs|-offs]|MEMADDR	: set a probe
-  r SYMBOL[+0]				: set a return probe
+  p SYMBOL[+offs|-offs]|MEMADDR [FETCHARGS]	: set a probe
+  r SYMBOL[+0] [FETCHARGS]			: set a return probe
+
+ FETCHARGS:
+  rN	: Fetch Nth register (N >= 0)
+  sN	: Fetch Nth entry of stack (N >= 0)
+  mADDR	: Fetch memory at ADDR (ADDR should be in kernel)
+  aN	: Fetch function argument. (N >= 1)(*)
+  rv	: Fetch return value.(**)
+  rp	: Fetch return address.(**)
+
+  (*) aN may not correct on asmlinkaged functions and at function body.
+  (**) only for return probe.

 E.g.
-  echo p sys_open > /debug/tracing/kprobe_probes
+  echo p do_sys_open a1 a2 a3 a4 > /debug/tracing/kprobe_probes

- This sets a kprobe on the top of sys_open() function.
+ This sets a kprobe on the top of do_sys_open() function with recording
+1st to 4th arguments.

-  echo r sys_open >> /debug/tracing/kprobe_probes
+  echo r do_sys_open rv rp >> /debug/tracing/kprobe_probes

- This sets a kretprobe on the return point of sys_open() function.
+ This sets a kretprobe on the return point of do_sys_open() function with
+recording return value and return address.

   echo > /debug/tracing/kprobe_probes

@@ -1351,18 +1364,16 @@ E.g.
 #
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
-           <...>-5117  [003]   416.481638: sys_open: @sys_open+0
-           <...>-5117  [003]   416.481662: syscall_call: <-sys_open+0
-           <...>-5117  [003]   416.481739: sys_open: @sys_open+0
-           <...>-5117  [003]   416.481762: sysenter_do_call: <-sys_open+0
-           <...>-5117  [003]   416.481818: sys_open: @sys_open+0
-           <...>-5117  [003]   416.481842: sysenter_do_call: <-sys_open+0
-           <...>-5117  [003]   416.481882: sys_open: @sys_open+0
-           <...>-5117  [003]   416.481905: sysenter_do_call: <-sys_open+0
+           <...>-2376  [001]   262.389131: do_sys_open: @do_sys_open+0 0xffffff9c 0x98db83e 0x8880 0x0
+           <...>-2376  [001]   262.391166: sys_open: <-do_sys_open+0 0x5 0xc06e8ebb
+           <...>-2376  [001]   264.384876: do_sys_open: @do_sys_open+0 0xffffff9c 0x98db83e 0x8880 0x0
+           <...>-2376  [001]   264.386880: sys_open: <-do_sys_open+0 0x5 0xc06e8ebb
+           <...>-2084  [001]   265.380330: do_sys_open: @do_sys_open+0 0xffffff9c 0x804be3e 0x0 0x1b6
+           <...>-2084  [001]   265.380399: sys_open: <-do_sys_open+0 0x3 0xc06e8ebb

  @SYMBOL means that kernel hits a probe, and <-SYMBOL means kernel returns
-from SYMBOL(e.g. "sysenter_do_call: <-sys_open+0" means kernel returns from
-sys_open to sysenter_do_call).
+from SYMBOL(e.g. "sys_open: <-do_sys_open+0" means kernel returns from
+do_sys_open to sys_open).


 function graph tracer
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 2bc0a1a..def322f 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -27,15 +27,126 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
+#include <linux/ptrace.h>

 #include <linux/ftrace.h>
 #include "trace.h"

+/* TODO: Move these functions to arch/XXX/include/asm/debugger.h */
+#define STACK_MASK (THREAD_SIZE - 1)
+#define valid_stack_addr(regs, addr) \
+	(((addr) & ~STACK_MASK) == (kernel_trap_sp(regs) & ~STACK_MASK))
+
+#if defined(__i386__)
+#define MAX_REG_NUM 15
+#elif defined(__x86_64__)
+#define MAX_REG_NUM 21
+#else
+#define MAX_REG_NUM (sizeof(struct pt_regs)/sizeof(unsigned long))
+#endif
+
+static unsigned long fetch_register(struct pt_regs *regs, void *num)
+{
+	if (unlikely((unsigned)num > MAX_REG_NUM))
+		return 0;
+	return *((unsigned long *)regs + (unsigned)num);
+}
+
+static unsigned long fetch_stack(struct pt_regs *regs, void *num)
+{
+	unsigned long *addr = (unsigned long *)kernel_trap_sp(regs);
+	addr += (unsigned)num;
+	if (valid_stack_addr(regs, (unsigned long)addr))
+		return *addr;
+	else
+		return 0;
+}
+
+static unsigned long fetch_memory(struct pt_regs *regs, void *addr)
+{
+	unsigned long retval;
+	if (probe_kernel_address(addr, retval))
+		return 0;
+	return retval;
+}
+
+#if defined(__i386__)
+#define REGPARMS 3
+static unsigned long fetch_argument(struct pt_regs *regs, void *data)
+{
+	unsigned long n = (unsigned long)data;
+	if (n > REGPARMS) {
+		/*
+		 * The typical case: arg n is on the stack.
+		 * stack[0] = return address
+		 */
+		return fetch_stack(regs, (void *)(n - REGPARMS));
+	} else {
+		switch (n) {
+		case 1: return regs->ax;
+		case 2: return regs->dx;
+		case 3: return regs->cx;
+		}
+		return 0;
+	}
+}
+#elif defined(__x86_64__)
+#define REGPARMS 6
+static unsigned long fetch_argument(struct pt_regs *regs, void *data)
+{
+	unsigned long n = (unsigned long)data;
+	if (n > REGPARMS) {
+		/*
+		 * The typical case: arg n is on the stack.
+		 * stack[0] = return address
+		 */
+		return fetch_stack(regs, (void *)(n - REGPARMS));
+	} else {
+		switch (n) {
+		case 1: return regs->di;
+		case 2: return regs->si;
+		case 3: return regs->dx;
+		case 4: return regs->cx;
+		case 5: return regs->r8;
+		case 6: return regs->r9;
+		}
+		return 0;
+	}
+}
+#else
+/* currently, trace_kprobe only supports X86. */
+static unsigned long fetch_argument(struct pt_regs *regs, void *data)
+{
+	return fetch_stack(regs, data);
+}
+#endif
+
+static unsigned long fetch_retvalue(struct pt_regs *regs, void *dummy)
+{
+	return regs_return_value(regs);
+}
+
+static unsigned long fetch_ip(struct pt_regs *regs, void *dummy)
+{
+	return instruction_pointer(regs);
+}
+
+
 /**
  * kprobe_trace_core
  */
 #define TRACE_MAXARGS 6

+struct fetch_func {
+	unsigned long (*func)(struct pt_regs *, void *);
+	void *data;
+};
+
+static unsigned long call_fetch(struct fetch_func *f, struct pt_regs *regs)
+{
+	return f->func(regs, f->data);
+}
+
 struct trace_probe {
 	struct list_head	list;
 	union {
@@ -43,6 +154,8 @@ struct trace_probe {
 		struct kretprobe	rp;
 	};
 	const char		*symbol;	/* symbol name */
+	unsigned int		nr_args;
+	struct fetch_func	args[TRACE_MAXARGS];
 };

 static void kprobe_trace_record(unsigned long ip, struct trace_probe *tp,
@@ -152,17 +265,23 @@ static int create_trace_probe(int argc, char **argv)
 {
 	/*
 	 * Argument syntax:
-	 *  - Add kprobe: p SYMBOL[+OFFS|-OFFS]|ADDRESS
-	 *  - Add kretprobe: r SYMBOL[+0]
+	 *  - Add kprobe: p SYMBOL[+OFFS|-OFFS]|ADDRESS [FETCHARGS]
+	 *  - Add kretprobe: r SYMBOL[+0] [FETCHARGS]
+	 * Fetch args:
+	 *  aN	: fetch Nth of function argument. (N:1-)
+	 *  rN	: fetch Nth of register (pt_regs + N) (N:0-)
+	 *  sN	: fetch Nth of stack (N:0-)
+	 *  mADDR	: fetch memory at ADDR (ADDR should be in kernel)
 	 */
 	struct trace_probe *tp;
 	struct kprobe *kp;
 	char *tmp;
-	int ret = 0;
+	int i, ret = 0;
 	int is_return = 0;
 	char *symbol = NULL;
 	long offset = 0;
 	void *addr = NULL;
+	unsigned long param;

 	if (argc < 2)
 		return -EINVAL;
@@ -222,6 +341,63 @@ static int create_trace_probe(int argc, char **argv)
 	} else
 		kp->addr = addr;

+	/* parse arguments */
+	argc -= 2; argv += 2; ret = 0;
+	for (i = 0; i < argc && i < TRACE_MAXARGS; i++) {
+		tmp = argv[i];
+		switch (*tmp) {
+		case 'a':	/* argument */
+			ret = strict_strtoul(tmp + 1, 10, &param);
+			if (ret || param > PARAM_MAX_ARGS)
+				ret = -EINVAL;
+			else {
+				tp->args[i].func = fetch_argument;
+				tp->args[i].data = (void *)param;
+			}
+			break;
+		case 'r':	/* register||retval||retip */
+			if (isdigit(tmp[1])) {
+				ret = strict_strtoul(tmp + 1, 10, &param);
+				if (ret || param > PARAM_MAX_REGS)
+					ret = -EINVAL;
+				else {
+					tp->args[i].func = fetch_register;
+					tp->args[i].data = (void *)param;
+				}
+			} else if (is_return && tmp[1] == 'v') {
+				tp->args[i].func = fetch_retvalue;
+				tp->args[i].data = NULL;
+			} else if (is_return && tmp[1] == 'p') {
+				tp->args[i].func = fetch_ip;
+				tp->args[i].data = NULL;
+			} else
+				ret = -EINVAL;
+			break;
+		case 's':	/* stack */
+			ret = strict_strtoul(tmp + 1, 10, &param);
+			if (ret || param > PARAM_MAX_STACK)
+				ret = -EINVAL;
+			else {
+				tp->args[i].func = fetch_stack;
+				tp->args[i].data = (void *)param;
+			}
+			break;
+		case 'm':	/* memory */
+			ret = strict_strtoul(tmp + 1, 0, &param);
+			if (!ret) {
+				tp->args[i].func = fetch_memory;
+				tp->args[i].data = (void *)param;
+			}
+			break;
+		default:
+			/* TODO: support custom handler */
+			ret = -EINVAL;
+		}
+		if (ret)
+			goto error;
+	}
+	tp->nr_args = i;
+
 	ret = register_trace_probe(tp);
 	if (ret)
 		goto error;
@@ -281,18 +457,35 @@ static void probes_seq_stop(struct seq_file *m, void *v)
 static int probes_seq_show(struct seq_file *m, void *v)
 {
 	struct trace_probe *tp = v;
+	int i;

 	if (tp == NULL)
 		return 0;

 	if (tp->symbol)
-		seq_printf(m, "%c %s%+ld\n",
+		seq_printf(m, "%c %s%+ld ",
 			probe_is_return(tp) ? 'r' : 'p',
 			probe_symbol(tp), probe_offset(tp));
 	else
-		seq_printf(m, "%c 0x%p\n",
+		seq_printf(m, "%c 0x%p ",
 			probe_is_return(tp) ? 'r' : 'p',
 			probe_address(tp));
+
+	for (i = 0; i < tp->nr_args; i++) {
+		if (tp->args[i].func == fetch_argument)
+			seq_printf(m, " a%lu", (unsigned long)tp->args[i].data);
+		else if (tp->args[i].func == fetch_register)
+			seq_printf(m, " r%lu", (unsigned long)tp->args[i].data);
+		else if (tp->args[i].func == fetch_stack)
+			seq_printf(m, " s%lu", (unsigned long)tp->args[i].data);
+		else if (tp->args[i].func == fetch_memory)
+			seq_printf(m, " m0x%p", tp->args[i].data);
+		else if (tp->args[i].func == fetch_retvalue)
+			seq_printf(m, " rv");
+		else if (tp->args[i].func == fetch_ip)
+			seq_printf(m, " rp");
+	}
+	seq_printf(m, "\n");
 	return 0;
 }

@@ -383,13 +576,95 @@ static const struct file_operations kprobe_points_ops = {
 };

 /* event recording functions */
-static void kprobe_trace_record(unsigned long ip, struct trace_probe *tp,
-				struct pt_regs *regs)
+/* TODO: rewrite based on trace_vprintk(maybe, trace_vprintk_begin/end?) */
+static void kprobe_trace_printk_0(unsigned long ip, struct trace_probe *tp,
+				  struct pt_regs *regs)
 {
 	__trace_bprintk(ip, "%s%s%+ld\n",
 			probe_is_return(tp) ? "<-" : "@",
 			probe_symbol(tp), probe_offset(tp));
 }
+static void kprobe_trace_printk_1(unsigned long ip, struct trace_probe *tp,
+				  struct pt_regs *regs)
+{
+	__trace_bprintk(ip, "%s%s%+ld 0x%lx\n",
+			probe_is_return(tp) ? "<-" : "@",
+			probe_symbol(tp), probe_offset(tp),
+			call_fetch(&tp->args[0], regs));
+}
+static void kprobe_trace_printk_2(unsigned long ip, struct trace_probe *tp,
+				  struct pt_regs *regs)
+{
+	__trace_bprintk(ip, "%s%s%+ld 0x%lx 0x%lx\n",
+			probe_is_return(tp) ? "<-" : "@", probe_symbol(tp),
+			probe_offset(tp),
+			call_fetch(&tp->args[0], regs),
+			call_fetch(&tp->args[1], regs));
+}
+static void kprobe_trace_printk_3(unsigned long ip, struct trace_probe *tp,
+				  struct pt_regs *regs)
+{
+	__trace_bprintk(ip, "%s%s%+ld 0x%lx 0x%lx 0x%lx\n",
+			probe_is_return(tp) ? "<-" : "@", probe_symbol(tp),
+			probe_offset(tp),
+			call_fetch(&tp->args[0], regs),
+			call_fetch(&tp->args[1], regs),
+			call_fetch(&tp->args[2], regs));
+}
+static void kprobe_trace_printk_4(unsigned long ip, struct trace_probe *tp,
+				  struct pt_regs *regs)
+{
+	__trace_bprintk(ip, "%s%s%+ld 0x%lx 0x%lx 0x%lx 0x%lx\n",
+			probe_is_return(tp) ? "<-" : "@", probe_symbol(tp),
+			probe_offset(tp),
+			call_fetch(&tp->args[0], regs),
+			call_fetch(&tp->args[1], regs),
+			call_fetch(&tp->args[2], regs),
+			call_fetch(&tp->args[3], regs));
+}
+static void kprobe_trace_printk_5(unsigned long ip, struct trace_probe *tp,
+				  struct pt_regs *regs)
+{
+	__trace_bprintk(ip, "%s%s%+ld 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
+			probe_is_return(tp) ? "<-" : "@", probe_symbol(tp),
+			probe_offset(tp),
+			call_fetch(&tp->args[0], regs),
+			call_fetch(&tp->args[1], regs),
+			call_fetch(&tp->args[2], regs),
+			call_fetch(&tp->args[3], regs),
+			call_fetch(&tp->args[4], regs));
+}
+static void kprobe_trace_printk_6(unsigned long ip, struct trace_probe *tp,
+				  struct pt_regs *regs)
+{
+	__trace_bprintk(ip, "%s%s%+ld 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
+			probe_is_return(tp) ? "<-" : "@", probe_symbol(tp),
+			probe_offset(tp),
+			call_fetch(&tp->args[0], regs),
+			call_fetch(&tp->args[1], regs),
+			call_fetch(&tp->args[2], regs),
+			call_fetch(&tp->args[3], regs),
+			call_fetch(&tp->args[4], regs),
+			call_fetch(&tp->args[5], regs));
+}
+
+static void (*kprobe_trace_printk_n[TRACE_MAXARGS + 1])(unsigned long ip,
+							struct trace_probe *,
+							struct pt_regs *) = {
+	[0] = kprobe_trace_printk_0,
+	[1] = kprobe_trace_printk_1,
+	[2] = kprobe_trace_printk_2,
+	[3] = kprobe_trace_printk_3,
+	[4] = kprobe_trace_printk_4,
+	[5] = kprobe_trace_printk_5,
+	[6] = kprobe_trace_printk_6,
+};
+
+static void kprobe_trace_record(unsigned long ip, struct trace_probe *tp,
+				struct pt_regs *regs)
+{
+	kprobe_trace_printk_n[tp->nr_args](ip, tp, regs);
+}

 /* Make a debugfs interface for controling probe points */
 static __init int init_kprobe_trace(void)
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com



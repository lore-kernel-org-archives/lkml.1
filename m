Return-Path: <linux-kernel-owner+w=401wt.eu-S934635AbZDBR1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934635AbZDBR1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934206AbZDBRZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:25:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35413 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764548AbZDBRZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:25:04 -0400
Message-ID: <49D4F4F0.5030208@redhat.com>
Date: Thu, 02 Apr 2009 13:25:04 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org
Subject: [PATCH -tip 6/6 V4] tracing: kprobe-tracer plugin supports arguments
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support following probe arguments and add fetch functions on kprobe-tracer.
  %REG  : Fetch register REG
  sN    : Fetch Nth entry of stack (N >= 0)
  @ADDR : Fetch memory at ADDR (ADDR should be in kernel)
  @SYM[+|-offs] : Fetch memory at SYM +|- offs (SYM should be a data symbol)
  aN    : Fetch function argument. (N >= 0)
  rv    : Fetch return value.
  ra    : Fetch return address.
  +|-offs(FETCHARG) : fetch memory at FETCHARG +|- offs address.

changes from v3.1:
 - remove arch-dep code.
 - aN start with a0 instead of a1.
 - include symbol value fetching support.
 - support name based register fetching. (and remove rN)
 - support recursive indirect memory fetching.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 Documentation/ftrace.txt    |   47 +++--
 kernel/trace/trace_kprobe.c |  431 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 441 insertions(+), 37 deletions(-)


diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index fd0833b..c593780 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -1329,17 +1329,34 @@ current_tracer, instead of that, just set probe points via
 /debug/tracing/kprobe_probes.

 Synopsis of kprobe_probes:
-  p SYMBOL[+offs|-offs]|MEMADDR	: set a probe
-  r SYMBOL[+0]				: set a return probe
+  p SYMBOL[+offs|-offs]|MEMADDR [FETCHARGS]	: set a probe
+  r SYMBOL[+0] [FETCHARGS]			: set a return probe
+
+ FETCHARGS:
+  %REG	: Fetch register REG
+  sN	: Fetch Nth entry of stack (N >= 0)
+  @ADDR	: Fetch memory at ADDR (ADDR should be in kernel)
+  @SYM[+|-offs]	: Fetch memory at SYM +|- offs (SYM should be a data symbol)
+  aN	: Fetch function argument. (N >= 0)(*)
+  rv	: Fetch return value.(**)
+  ra	: Fetch return address.(**)
+  +|-offs(FETCHARG) : fetch memory at FETCHARG +|- offs address.(***)
+
+  (*) aN may not correct on asmlinkaged functions and at the middle of
+      function body.
+  (**) only for return probe.
+  (***) this is useful for fetching a field of data structures.

 E.g.
-  echo p sys_open > /debug/tracing/kprobe_probes
+  echo p do_sys_open a0 a1 a2 a3 > /debug/tracing/kprobe_probes

- This sets a kprobe on the top of sys_open() function.
+ This sets a kprobe on the top of do_sys_open() function with recording
+1st to 4th arguments.

-  echo r sys_open >> /debug/tracing/kprobe_probes
+  echo r do_sys_open rv ra >> /debug/tracing/kprobe_probes

- This sets a kretprobe on the return point of sys_open() function.
+ This sets a kretprobe on the return point of do_sys_open() function with
+recording return value and return address.

   echo > /debug/tracing/kprobe_probes

@@ -1351,18 +1368,16 @@ E.g.
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
index 8263b5f..df71c6c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -27,10 +27,134 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
+#include <linux/ptrace.h>

 #include <linux/ftrace.h>
 #include "trace.h"

+/* currently, trace_kprobe only supports X86. */
+
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
+/* fetch handlers */
+static unsigned long fetch_register(struct pt_regs *regs, void *offset)
+{
+	return get_register(regs, (unsigned)((unsigned long)offset));
+}
+
+static unsigned long fetch_stack(struct pt_regs *regs, void *num)
+{
+	return get_stack_nth(regs, (unsigned)((unsigned long)num));
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
+static unsigned long fetch_argument(struct pt_regs *regs, void *num)
+{
+	return get_argument_nth(regs, (unsigned)((unsigned long)num));
+}
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
+/* Memory fetching by symbol */
+struct symbol_cache {
+	char *symbol;
+	long offset;
+	unsigned long addr;
+};
+
+static unsigned long update_symbol_cache(struct symbol_cache *sc)
+{
+	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
+	if (sc->addr)
+		sc->addr += sc->offset;
+	return sc->addr;
+}
+
+static void free_symbol_cache(struct symbol_cache *sc)
+{
+	kfree(sc->symbol);
+	kfree(sc);
+}
+
+static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
+{
+	struct symbol_cache *sc;
+	if (!sym || strlen(sym) == 0)
+		return NULL;
+	sc = kzalloc(sizeof(struct symbol_cache), GFP_KERNEL);
+	if (!sc)
+		return NULL;
+
+	sc->symbol = kstrdup(sym, GFP_KERNEL);
+	if (!sc->symbol) {
+		kfree(sc);
+		return NULL;
+	}
+	sc->offset = offset;
+
+	update_symbol_cache(sc);
+	return sc;
+}
+
+static unsigned long fetch_symbol(struct pt_regs *regs, void *data)
+{
+	struct symbol_cache *sc = data;
+	if (sc->addr)
+		return fetch_memory(regs, (void *)sc->addr);
+	else
+		return 0;
+}
+
+/* Special indirect memory access interface */
+struct indirect_fetch_data {
+	struct fetch_func orig;
+	long offset;
+};
+
+static unsigned long fetch_indirect(struct pt_regs *regs, void *data)
+{
+	struct indirect_fetch_data *ind = data;
+	unsigned long addr;
+	addr = call_fetch(&ind->orig, regs);
+	if (addr) {
+		addr += ind->offset;
+		return fetch_memory(regs, (void *)addr);
+	} else
+		return 0;
+}
+
+static void free_indirect_fetch_data(struct indirect_fetch_data *data)
+{
+	if (data->orig.func == fetch_indirect)
+		free_indirect_fetch_data(data->orig.data);
+	else if (data->orig.func == fetch_symbol)
+		free_symbol_cache(data->orig.data);
+	kfree(data);
+}
+
 /**
  * kprobe_trace_core
  */
@@ -43,6 +167,8 @@ struct trace_probe {
 		struct kretprobe	rp;
 	};
 	const char		*symbol;	/* symbol name */
+	unsigned int		nr_args;
+	struct fetch_func	args[TRACE_MAXARGS];
 };

 static void kprobe_trace_record(unsigned long ip, struct trace_probe *tp,
@@ -111,6 +237,13 @@ static struct trace_probe *alloc_trace_probe(const char *symbol)

 static void free_trace_probe(struct trace_probe *tp)
 {
+	int i;
+	for (i = 0; i < tp->nr_args; i++)
+		if (tp->args[i].func == fetch_symbol)
+			free_symbol_cache(tp->args[i].data);
+		else if (tp->args[i].func == fetch_indirect)
+			free_indirect_fetch_data(tp->args[i].data);
+
 	kfree(tp->symbol);
 	kfree(tp);
 }
@@ -150,17 +283,158 @@ static void unregister_trace_probe(struct trace_probe *tp)
 	list_del(&tp->list);
 }

+/* Split symbol and offset. */
+static int split_symbol_offset(char *symbol, long *offset)
+{
+	char *tmp;
+	int ret;
+
+	if (!offset)
+		return -EINVAL;
+
+	tmp = strchr(symbol, '+');
+	if (!tmp)
+		tmp = strchr(symbol, '-');
+
+	if (tmp) {
+		/* skip sign because strict_strtol doesn't accept '+' */
+		ret = strict_strtol(tmp + 1, 0, offset);
+		if (ret)
+			return ret;
+		if (*tmp == '-')
+			*offset = -(*offset);
+		*tmp = '\0';
+	} else
+		*offset = 0;
+	return 0;
+}
+
+#define PARAM_MAX_ARGS 16
+#define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
+
+static int parse_trace_arg(char *arg, struct fetch_func *ff, int is_return)
+{
+	int ret = 0;
+	unsigned long param;
+	long offset;
+	char *tmp;
+
+	switch (arg[0]) {
+	case 'a':	/* argument */
+		ret = strict_strtoul(arg + 1, 10, &param);
+		if (ret || param > PARAM_MAX_ARGS)
+			ret = -EINVAL;
+		else {
+			ff->func = fetch_argument;
+			ff->data = (void *)param;
+		}
+		break;
+	case 'r':	/* retval or retaddr */
+		if (is_return && arg[1] == 'v') {
+			ff->func = fetch_retvalue;
+			ff->data = NULL;
+		} else if (is_return && arg[1] == 'a') {
+			ff->func = fetch_ip;
+			ff->data = NULL;
+		} else
+			ret = -EINVAL;
+		break;
+	case '%':	/* named register */
+		ret = query_register_offset(arg + 1);
+		if (ret >= 0) {
+			ff->func = fetch_register;
+			ff->data = (void *)(unsigned long)ret;
+			ret = 0;
+		}
+		break;
+	case 's':	/* stack */
+		ret = strict_strtoul(arg + 1, 10, &param);
+		if (ret || param > PARAM_MAX_STACK)
+			ret = -EINVAL;
+		else {
+			ff->func = fetch_stack;
+			ff->data = (void *)param;
+		}
+		break;
+	case '@':	/* memory or symbol */
+		if (isdigit(arg[1])) {
+			ret = strict_strtoul(arg + 1, 0, &param);
+			if (ret)
+				break;
+			ff->func = fetch_memory;
+			ff->data = (void *)param;
+		} else {
+			ret = split_symbol_offset(arg + 1, &offset);
+			if (ret)
+				break;
+			ff->data = alloc_symbol_cache(arg + 1,
+							      offset);
+			if (ff->data)
+				ff->func = fetch_symbol;
+			else
+				ret = -EINVAL;
+		}
+		break;
+	case '+':	/* indirect memory */
+	case '-':
+		tmp = strchr(arg, '(');
+		if (!tmp) {
+			ret = -EINVAL;
+			break;
+		}
+		*tmp = '\0';
+		ret = strict_strtol(arg + 1, 0, &offset);
+		if (ret)
+			break;
+		if (arg[0] == '-')
+			offset = -offset;
+		arg = tmp + 1;
+		tmp = strrchr(arg, ')');
+		if (tmp) {
+			struct indirect_fetch_data *id;
+			*tmp = '\0';
+			id = kzalloc(sizeof(struct indirect_fetch_data),
+				     GFP_KERNEL);
+			if (!id)
+				return -ENOMEM;
+			id->offset = offset;
+			ret = parse_trace_arg(arg, &id->orig, is_return);
+			if (ret)
+				kfree(id);
+			else {
+				ff->func = fetch_indirect;
+				ff->data = (void *)id;
+			}
+		} else
+			ret = -EINVAL;
+		break;
+	default:
+		/* TODO: support custom handler */
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
 static int create_trace_probe(int argc, char **argv)
 {
 	/*
 	 * Argument syntax:
-	 *  - Add kprobe: p SYMBOL[+OFFS|-OFFS]|ADDRESS
-	 *  - Add kretprobe: r SYMBOL[+0]
+	 *  - Add kprobe: p SYMBOL[+OFFS|-OFFS]|ADDRESS [FETCHARGS]
+	 *  - Add kretprobe: r SYMBOL[+0] [FETCHARGS]
+	 * Fetch args:
+	 *  aN	: fetch Nth of function argument. (N:0-)
+	 *  rv	: fetch return value
+	 *  ra	: fetch return address
+	 *  sN	: fetch Nth of stack (N:0-)
+	 *  @ADDR	: fetch memory at ADDR (ADDR should be in kernel)
+	 *  @SYM[+|-offs] : fetch memory at SYM +|- offs (SYM is a data symbol)
+	 *  %REG	: fetch register REG
+	 * Indirect memory fetch:
+	 *  +|-offs(ARG) : fetch memory at ARG +|- offs address.
 	 */
 	struct trace_probe *tp;
 	struct kprobe *kp;
-	char *tmp;
-	int ret = 0;
+	int i, ret = 0;
 	int is_return = 0;
 	char *symbol = NULL;
 	long offset = 0;
@@ -187,19 +461,9 @@ static int create_trace_probe(int argc, char **argv)
 		/* a symbol specified */
 		symbol = argv[1];
 		/* TODO: support .init module functions */
-		tmp = strchr(symbol, '+');
-		if (!tmp)
-			tmp = strchr(symbol, '-');
-
-		if (tmp) {
-			/* skip sign because strict_strtol doesn't accept '+' */
-			ret = strict_strtol(tmp + 1, 0, &offset);
-			if (ret)
-				return ret;
-			if (*tmp == '-')
-				offset = -offset;
-			*tmp = '\0';
-		}
+		ret = split_symbol_offset(symbol, &offset);
+		if (ret)
+			return ret;
 		if (offset && is_return)
 			return -EINVAL;
 	}
@@ -224,6 +488,15 @@ static int create_trace_probe(int argc, char **argv)
 	} else
 		kp->addr = addr;

+	/* parse arguments */
+	argc -= 2; argv += 2; ret = 0;
+	for (i = 0; i < argc && i < TRACE_MAXARGS; i++) {
+		ret = parse_trace_arg(argv[i], &tp->args[i], is_return);
+		if (ret)
+			goto error;
+	}
+	tp->nr_args = i;
+
 	ret = register_trace_probe(tp);
 	if (ret)
 		goto error;
@@ -265,21 +538,55 @@ static void probes_seq_stop(struct seq_file *m, void *v)
 	mutex_unlock(&probe_lock);
 }

+static void arg_seq_print(struct seq_file *m, struct fetch_func *ff)
+{
+	if (ff->func == fetch_argument)
+		seq_printf(m, "a%lu", (unsigned long)ff->data);
+	else if (ff->func == fetch_register) {
+		const char *name;
+		name = query_register_name((unsigned)((long)ff->data));
+		seq_printf(m, "%%%s", name);
+	} else if (ff->func == fetch_stack)
+		seq_printf(m, "s%lu", (unsigned long)ff->data);
+	else if (ff->func == fetch_memory)
+		seq_printf(m, "@0x%p", ff->data);
+	else if (ff->func == fetch_symbol) {
+		struct symbol_cache *sc = ff->data;
+		seq_printf(m, "@%s%+ld", sc->symbol, sc->offset);
+	} else if (ff->func == fetch_retvalue)
+		seq_printf(m, "rv");
+	else if (ff->func == fetch_ip)
+		seq_printf(m, "ra");
+	else if (ff->func == fetch_indirect) {
+		struct indirect_fetch_data *id = ff->data;
+		seq_printf(m, "%+ld(", id->offset);
+		arg_seq_print(m, &id->orig);
+		seq_printf(m, ")");
+	}
+}
+
 static int probes_seq_show(struct seq_file *m, void *v)
 {
 	struct trace_probe *tp = v;
+	int i;

 	if (tp == NULL)
 		return 0;

 	if (tp->symbol)
-		seq_printf(m, "%c %s%+ld\n",
+		seq_printf(m, "%c %s%+ld",
 			probe_is_return(tp) ? 'r' : 'p',
 			probe_symbol(tp), probe_offset(tp));
 	else
-		seq_printf(m, "%c 0x%p\n",
+		seq_printf(m, "%c 0x%p",
 			probe_is_return(tp) ? 'r' : 'p',
 			probe_address(tp));
+
+	for (i = 0; i < tp->nr_args; i++) {
+		seq_printf(m, " ");
+		arg_seq_print(m, &tp->args[i]);
+	}
+	seq_printf(m, "\n");
 	return 0;
 }

@@ -370,13 +677,95 @@ static const struct file_operations kprobe_points_ops = {
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
+						       struct trace_probe *,
+						       struct pt_regs *) = {
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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbZEWA11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbZEWA11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 20:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbZEWA0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 20:26:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32910 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758588AbZEWA0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 20:26:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v7 6/6] tracing: add kprobe-based event tracer
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 22 May 2009 20:28:49 -0400
Message-ID: <20090523002849.8948.60482.stgit@localhost.localdomain>
In-Reply-To: <20090523002830.8948.51194.stgit@localhost.localdomain>
References: <20090523002830.8948.51194.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kprobes based event tracer on ftrace.

This tracer is similar to the events tracer which is based on Tracepoint
infrastructure. Instead of Tracepoint, this tracer is based on kprobes(kprobe
and kretprobe). It probes anywhere where kprobes can probe(this means, all
functions body except for __kprobes functions).

This tracer supports following probe arguments for each probe.

  %REG  : Fetch register REG
  sN    : Fetch Nth entry of stack (N >= 0)
  @ADDR : Fetch memory at ADDR (ADDR should be in kernel)
  @SYM[+|-offs] : Fetch memory at SYM +|- offs (SYM should be a data symbol)
  aN    : Fetch function argument. (N >= 0)
  rv    : Fetch return value.
  ra    : Fetch return address.
  +|-offs(FETCHARG) : fetch memory at FETCHARG +|- offs address.

Changes from v5:
 - Add __kprobes to functions which will be invoked by kprobes.
 - Merge tracer-core patch and trace-argument support patch.
 - Add kprobe_trace_entry and kretprobe_trace_entry for recording kprobe
   events.
 - Support common arguments filtering via
   tracing/events/ftrace/kprobe(or kretprobe)/filter.
 - Add a selftest.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 Documentation/trace/kprobes.txt  |   81 +++
 kernel/trace/Kconfig             |    9 
 kernel/trace/Makefile            |    1 
 kernel/trace/trace.h             |   22 +
 kernel/trace/trace_event_types.h |   20 +
 kernel/trace/trace_kprobe.c      |  903 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 1036 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/trace/kprobes.txt
 create mode 100644 kernel/trace/trace_kprobe.c

diff --git a/Documentation/trace/kprobes.txt b/Documentation/trace/kprobes.txt
new file mode 100644
index 0000000..d7c3092
--- /dev/null
+++ b/Documentation/trace/kprobes.txt
@@ -0,0 +1,81 @@
+                         Kprobe-based Event Tracer
+                         =========================
+
+                 Documentation is written by Masami Hiramatsu
+
+
+Overview
+--------
+This tracer is similar to the events tracer which is based on Tracepoint
+infrastructure. Instead of Tracepoint, this tracer is based on kprobes(kprobe
+and kretprobe). It probes anywhere where kprobes can probe(this means, all
+functions body except for __kprobes functions).
+
+Unlike the function tracer, this tracer can probe instructions inside of
+kernel functions. It allows you to check which instruction has been executed.
+
+Unlike the Tracepoint based events tracer, this tracer can add new probe points
+on the fly.
+
+Similar to the events tracer, this tracer doesn't need to be activated via
+current_tracer, instead of that, just set probe points via
+/debug/tracing/kprobe_events.
+
+
+Synopsis of kprobe_events
+-------------------------
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
+
+
+Usage examples
+--------------
+
+  echo p do_sys_open a0 a1 a2 a3 > /debug/tracing/kprobe_events
+
+ This sets a kprobe on the top of do_sys_open() function with recording
+1st to 4th arguments.
+
+  echo r do_sys_open rv ra >> /debug/tracing/kprobe_events
+
+ This sets a kretprobe on the return point of do_sys_open() function with
+recording return value and return address.
+
+  echo > /debug/tracing/kprobe_events
+
+ This clears all probe points. and you can see the traced information via
+/debug/tracing/trace.
+
+  cat /debug/tracing/trace
+# tracer: nop
+#
+#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
+#              | |       |          |         |
+           <...>-1447  [001] 1038282.286875: do_sys_open+0x0/0xd6: 0x3 0x7fffd1ec4440 0x8000 0x0
+           <...>-1447  [001] 1038282.286878: sys_openat+0xc/0xe <-do_sys_open: 0xfffffffffffffffe 0xffffffff81367a3a
+           <...>-1447  [001] 1038282.286885: do_sys_open+0x0/0xd6: 0xffffff9c 0x40413c 0x8000 0x1b6
+           <...>-1447  [001] 1038282.286915: sys_open+0x1b/0x1d <-do_sys_open: 0x3 0xffffffff81367a3a
+           <...>-1447  [001] 1038282.286969: do_sys_open+0x0/0xd6: 0xffffff9c 0x4041c6 0x98800 0x10
+           <...>-1447  [001] 1038282.286976: sys_open+0x1b/0x1d <-do_sys_open: 0x3 0xffffffff81367a3a
+
+
+ Each line shows when the kernel hits a probe, and <- SYMBOL means kernel
+returns from SYMBOL(e.g. "sys_open+0x1b/0x1d <- do_sys_open" means kernel
+returns from do_sys_open to sys_open+0x1b).
+
+
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index f61be30..8927864 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -398,6 +398,15 @@ config BLK_DEV_IO_TRACE
 
 	  If unsure, say N.
 
+config KPROBE_TRACER
+	depends on KPROBES
+	depends on X86
+	bool "Trace kprobes"
+	select TRACING
+	help
+	  This tracer probes everywhere where kprobes can probe it, and
+	  records various registers and memories specified by user.
+
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FUNCTION_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 848e5ce..01ac95b 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -52,5 +52,6 @@ obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_EVENT_TRACING) += trace_mm.o
+obj-$(CONFIG_KPROBE_TRACER) += trace_kprobe.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6e735d4..5d7849b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -40,6 +40,8 @@ enum trace_type {
 	TRACE_KMEM_FREE,
 	TRACE_POWER,
 	TRACE_BLK,
+	TRACE_KPROBE,
+	TRACE_KRETPROBE,
 
 	__TRACE_LAST_TYPE,
 };
@@ -207,6 +209,22 @@ struct syscall_trace_exit {
 	unsigned long		ret;
 };
 
+#define TRACE_KPROBE_ARGS 6
+
+struct kprobe_trace_entry {
+	struct trace_entry	ent;
+	unsigned long		ip;
+	int			nargs;
+	unsigned long		args[TRACE_KPROBE_ARGS];
+};
+
+struct kretprobe_trace_entry {
+	struct trace_entry	ent;
+	unsigned long		func;
+	unsigned long		ret_ip;
+	int			nargs;
+	unsigned long		args[TRACE_KPROBE_ARGS];
+};
 
 /*
  * trace_flag_type is an enumeration that holds different
@@ -323,6 +341,10 @@ extern void __ftrace_bad_type(void);
 			  TRACE_SYSCALL_ENTER);				\
 		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
 			  TRACE_SYSCALL_EXIT);				\
+		IF_ASSIGN(var, ent, struct kprobe_trace_entry,		\
+			  TRACE_KPROBE);				\
+		IF_ASSIGN(var, ent, struct kretprobe_trace_entry,	\
+			  TRACE_KRETPROBE);				\
 		__ftrace_bad_type();					\
 	} while (0)
 
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index 5e32e37..3be3e32 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -172,4 +172,24 @@ TRACE_EVENT_FORMAT(kmem_free, TRACE_KMEM_FREE, kmemtrace_free_entry, ignore,
 	TP_RAW_FMT("type:%u call_site:%lx ptr:%p")
 );
 
+TRACE_EVENT_FORMAT(kprobe, TRACE_KPROBE, kprobe_trace_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(unsigned long, ip, ip)
+		TRACE_FIELD(int, nargs, nargs)
+		TRACE_FIELD_SPECIAL(unsigned long args[TRACE_KPROBE_ARGS],
+				    args, TRACE_KPROBE_ARGS, args)
+	),
+	TP_RAW_FMT("%08lx: args:0x%lx ...")
+);
+
+TRACE_EVENT_FORMAT(kretprobe, TRACE_KRETPROBE, kretprobe_trace_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(unsigned long, func, func)
+		TRACE_FIELD(unsigned long, ret_ip, ret_ip)
+		TRACE_FIELD(int, nargs, nargs)
+		TRACE_FIELD_SPECIAL(unsigned long args[TRACE_KPROBE_ARGS],
+				    args, TRACE_KPROBE_ARGS, args)
+	),
+	TP_RAW_FMT("%08lx <- %08lx: args:0x%lx ...")
+);
 #undef TRACE_SYSTEM
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
new file mode 100644
index 0000000..ecca548
--- /dev/null
+++ b/kernel/trace/trace_kprobe.c
@@ -0,0 +1,903 @@
+/*
+ * kprobe based kernel tracer
+ *
+ * Created by Masami Hiramatsu <mhiramat@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/kprobes.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/debugfs.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/ptrace.h>
+
+#include "trace.h"
+#include "trace_output.h"
+
+/* currently, trace_kprobe only supports X86. */
+
+struct fetch_func {
+	unsigned long (*func)(struct pt_regs *, void *);
+	void *data;
+};
+
+static __kprobes unsigned long call_fetch(struct fetch_func *f,
+					  struct pt_regs *regs)
+{
+	return f->func(regs, f->data);
+}
+
+/* fetch handlers */
+static __kprobes unsigned long fetch_register(struct pt_regs *regs,
+					      void *offset)
+{
+	return get_register(regs, (unsigned)((unsigned long)offset));
+}
+
+static __kprobes unsigned long fetch_stack(struct pt_regs *regs,
+					   void *num)
+{
+	return get_kernel_stack_nth(regs, (unsigned)((unsigned long)num));
+}
+
+static __kprobes unsigned long fetch_memory(struct pt_regs *regs, void *addr)
+{
+	unsigned long retval;
+	if (probe_kernel_address(addr, retval))
+		return 0;
+	return retval;
+}
+
+static __kprobes unsigned long fetch_argument(struct pt_regs *regs, void *num)
+{
+	return get_argument_nth(regs, (unsigned)((unsigned long)num));
+}
+
+static __kprobes unsigned long fetch_retvalue(struct pt_regs *regs,
+					      void *dummy)
+{
+	return regs_return_value(regs);
+}
+
+static __kprobes unsigned long fetch_ip(struct pt_regs *regs, void *dummy)
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
+static __kprobes unsigned long fetch_symbol(struct pt_regs *regs, void *data)
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
+static __kprobes unsigned long fetch_indirect(struct pt_regs *regs, void *data)
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
+static __kprobes void free_indirect_fetch_data(struct indirect_fetch_data *data)
+{
+	if (data->orig.func == fetch_indirect)
+		free_indirect_fetch_data(data->orig.data);
+	else if (data->orig.func == fetch_symbol)
+		free_symbol_cache(data->orig.data);
+	kfree(data);
+}
+
+/**
+ * kprobe_trace_core
+ */
+
+struct trace_probe {
+	struct list_head	list;
+	union {
+		struct kprobe		kp;
+		struct kretprobe	rp;
+	};
+	const char		*symbol;	/* symbol name */
+	unsigned int		nr_args;
+	struct fetch_func	args[TRACE_KPROBE_ARGS];
+};
+
+static int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs);
+static int kretprobe_trace_func(struct kretprobe_instance *ri,
+				struct pt_regs *regs);
+
+static __kprobes int probe_is_return(struct trace_probe *tp)
+{
+	return (tp->rp.handler == kretprobe_trace_func);
+}
+
+static __kprobes const char *probe_symbol(struct trace_probe *tp)
+{
+	return tp->symbol ? tp->symbol : "unknown";
+}
+
+static __kprobes long probe_offset(struct trace_probe *tp)
+{
+	return (probe_is_return(tp)) ? tp->rp.kp.offset : tp->kp.offset;
+}
+
+static __kprobes void *probe_address(struct trace_probe *tp)
+{
+	return (probe_is_return(tp)) ? tp->rp.kp.addr : tp->kp.addr;
+}
+
+static int trace_arg_string(char *buf, size_t n, struct fetch_func *ff)
+{
+	int ret = -EINVAL;
+	if (ff->func == fetch_argument)
+		ret = snprintf(buf, n, "a%lu", (unsigned long)ff->data);
+	else if (ff->func == fetch_register) {
+		const char *name;
+		name = query_register_name((unsigned)((long)ff->data));
+		ret = snprintf(buf, n, "%%%s", name);
+	} else if (ff->func == fetch_stack)
+		ret = snprintf(buf, n, "s%lu", (unsigned long)ff->data);
+	else if (ff->func == fetch_memory)
+		ret = snprintf(buf, n, "@0x%p", ff->data);
+	else if (ff->func == fetch_symbol) {
+		struct symbol_cache *sc = ff->data;
+		ret = snprintf(buf, n, "@%s%+ld", sc->symbol, sc->offset);
+	} else if (ff->func == fetch_retvalue)
+		ret = snprintf(buf, n, "rv");
+	else if (ff->func == fetch_ip)
+		ret = snprintf(buf, n, "ra");
+	else if (ff->func == fetch_indirect) {
+		struct indirect_fetch_data *id = ff->data;
+		ret = snprintf(buf, n, "%+ld(", id->offset);
+		if (ret > n)
+			goto end;
+		n -= ret;
+		ret = trace_arg_string(buf, n, &id->orig);
+		if (ret > n)
+			goto end;
+		n -= ret;
+		ret = snprintf(buf, n, ")");
+	}
+end:
+	if (ret > n)
+		return -ENOSPC;
+	return 0;
+}
+
+
+static DEFINE_MUTEX(probe_lock);
+static LIST_HEAD(probe_list);
+
+static struct trace_probe *alloc_trace_probe(const char *symbol)
+{
+	struct trace_probe *tp;
+
+	tp = kzalloc(sizeof(struct trace_probe), GFP_KERNEL);
+	if (!tp)
+		return ERR_PTR(-ENOMEM);
+
+	if (symbol) {
+		tp->symbol = kstrdup(symbol, GFP_KERNEL);
+		if (!tp->symbol) {
+			kfree(tp);
+			return ERR_PTR(-ENOMEM);
+		}
+	}
+
+	INIT_LIST_HEAD(&tp->list);
+	return tp;
+}
+
+static void free_trace_probe(struct trace_probe *tp)
+{
+	int i;
+	for (i = 0; i < tp->nr_args; i++)
+		if (tp->args[i].func == fetch_symbol)
+			free_symbol_cache(tp->args[i].data);
+		else if (tp->args[i].func == fetch_indirect)
+			free_indirect_fetch_data(tp->args[i].data);
+
+	kfree(tp->symbol);
+	kfree(tp);
+}
+
+static int register_trace_probe(struct trace_probe *tp)
+{
+	int ret;
+
+	mutex_lock(&probe_lock);
+	list_add_tail(&tp->list, &probe_list);
+
+	if (probe_is_return(tp))
+		ret = register_kretprobe(&tp->rp);
+	else
+		ret = register_kprobe(&tp->kp);
+
+	if (ret) {
+		pr_warning("Could not insert probe(%d)\n", ret);
+		if (ret == -EILSEQ) {
+			pr_warning("Probing address(0x%p) is not an "
+				   "instruction boundary.\n",
+				   probe_address(tp));
+			ret = -EINVAL;
+		}
+		list_del(&tp->list);
+	}
+	mutex_unlock(&probe_lock);
+	return ret;
+}
+
+static void unregister_trace_probe(struct trace_probe *tp)
+{
+	if (probe_is_return(tp))
+		unregister_kretprobe(&tp->rp);
+	else
+		unregister_kprobe(&tp->kp);
+	list_del(&tp->list);
+}
+
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
+#define MAX_ARGSTR_LEN 63
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
+static int create_trace_probe(int argc, char **argv)
+{
+	/*
+	 * Argument syntax:
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
+	 */
+	struct trace_probe *tp;
+	struct kprobe *kp;
+	int i, ret = 0;
+	int is_return = 0;
+	char *symbol = NULL;
+	long offset = 0;
+	void *addr = NULL;
+
+	if (argc < 2)
+		return -EINVAL;
+
+	if (argv[0][0] == 'p')
+		is_return = 0;
+	else if (argv[0][0] == 'r')
+		is_return = 1;
+	else
+		return -EINVAL;
+
+	if (isdigit(argv[1][0])) {
+		if (is_return)
+			return -EINVAL;
+		/* an address specified */
+		ret = strict_strtoul(&argv[0][2], 0, (unsigned long *)&addr);
+		if (ret)
+			return ret;
+	} else {
+		/* a symbol specified */
+		symbol = argv[1];
+		/* TODO: support .init module functions */
+		ret = split_symbol_offset(symbol, &offset);
+		if (ret)
+			return ret;
+		if (offset && is_return)
+			return -EINVAL;
+	}
+
+	/* setup a probe */
+	tp = alloc_trace_probe(symbol);
+	if (IS_ERR(tp))
+		return PTR_ERR(tp);
+
+	if (is_return) {
+		kp = &tp->rp.kp;
+		tp->rp.handler = kretprobe_trace_func;
+	} else {
+		kp = &tp->kp;
+		tp->kp.pre_handler = kprobe_trace_func;
+	}
+
+	if (tp->symbol) {
+		/* TODO: check offset is collect by using insn_decoder */
+		kp->symbol_name = tp->symbol;
+		kp->offset = offset;
+	} else
+		kp->addr = addr;
+
+	/* parse arguments */
+	argc -= 2; argv += 2; ret = 0;
+	for (i = 0; i < argc && i < TRACE_KPROBE_ARGS; i++) {
+		if (strlen(argv[i]) > MAX_ARGSTR_LEN) {
+			pr_info("Argument%d(%s) is too long.\n", i, argv[i]);
+			ret = -ENOSPC;
+			goto error;
+		}
+		ret = parse_trace_arg(argv[i], &tp->args[i], is_return);
+		if (ret)
+			goto error;
+	}
+	tp->nr_args = i;
+
+	ret = register_trace_probe(tp);
+	if (ret)
+		goto error;
+	return 0;
+
+error:
+	free_trace_probe(tp);
+	return ret;
+}
+
+static void cleanup_all_probes(void)
+{
+	struct trace_probe *tp;
+	mutex_lock(&probe_lock);
+	/* TODO: Use batch unregistration */
+	while (!list_empty(&probe_list)) {
+		tp = list_entry(probe_list.next, struct trace_probe, list);
+		unregister_trace_probe(tp);
+		free_trace_probe(tp);
+	}
+	mutex_unlock(&probe_lock);
+}
+
+
+/* Probes listing interfaces */
+static void *probes_seq_start(struct seq_file *m, loff_t *pos)
+{
+	mutex_lock(&probe_lock);
+	return seq_list_start(&probe_list, *pos);
+}
+
+static void *probes_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	return seq_list_next(v, &probe_list, pos);
+}
+
+static void probes_seq_stop(struct seq_file *m, void *v)
+{
+	mutex_unlock(&probe_lock);
+}
+
+static int probes_seq_show(struct seq_file *m, void *v)
+{
+	struct trace_probe *tp = v;
+	int i, ret;
+	char buf[MAX_ARGSTR_LEN + 1];
+
+	if (tp == NULL)
+		return 0;
+
+	if (tp->symbol)
+		seq_printf(m, "%c %s%+ld",
+			probe_is_return(tp) ? 'r' : 'p',
+			probe_symbol(tp), probe_offset(tp));
+	else
+		seq_printf(m, "%c 0x%p",
+			probe_is_return(tp) ? 'r' : 'p',
+			probe_address(tp));
+
+	for (i = 0; i < tp->nr_args; i++) {
+		ret = trace_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
+		if (ret) {
+			pr_warning("Argument%d is too long.\n", i);
+			break;
+		}
+		seq_printf(m, " %s", buf);
+	}
+	seq_printf(m, "\n");
+	return 0;
+}
+
+static const struct seq_operations probes_seq_op = {
+	.start  = probes_seq_start,
+	.next   = probes_seq_next,
+	.stop   = probes_seq_stop,
+	.show   = probes_seq_show
+};
+
+static int probes_open(struct inode *inode, struct file *file)
+{
+	if ((file->f_mode & FMODE_WRITE) &&
+	    !(file->f_flags & O_APPEND))
+		cleanup_all_probes();
+
+	return seq_open(file, &probes_seq_op);
+}
+
+static int command_trace_probe(const char *buf)
+{
+	char **argv;
+	int argc = 0, ret = 0;
+
+	argv = argv_split(GFP_KERNEL, buf, &argc);
+	if (!argv)
+		return -ENOMEM;
+
+	if (argc)
+		ret = create_trace_probe(argc, argv);
+
+	argv_free(argv);
+	return ret;
+}
+
+#define WRITE_BUFSIZE 128
+
+static ssize_t probes_write(struct file *file, const char __user *buffer,
+			    size_t count, loff_t *ppos)
+{
+	char *kbuf, *tmp;
+	int ret;
+	size_t done;
+	size_t size;
+
+	if (!count || count < 0)
+		return 0;
+
+	kbuf = kmalloc(WRITE_BUFSIZE, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	ret = done = 0;
+	do {
+		size = count - done;
+		if (size > WRITE_BUFSIZE)
+			size = WRITE_BUFSIZE;
+		if (copy_from_user(kbuf, buffer + done, size)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		kbuf[size] = '\0';
+		tmp = strchr(kbuf, '\n');
+		if (!tmp) {
+			pr_warning("Line length is too long: "
+				   "Should be less than %d.", WRITE_BUFSIZE);
+			ret = -EINVAL;
+			goto out;
+		}
+		*tmp = '\0';
+		size = tmp - kbuf + 1;
+		done += size;
+		/* Remove comments */
+		tmp = strchr(kbuf, '#');
+		if (tmp)
+			*tmp = '\0';
+
+		ret = command_trace_probe(kbuf);
+		if (ret)
+			goto out;
+
+	} while (done < count);
+	ret = done;
+out:
+	kfree(kbuf);
+	return ret;
+}
+
+static const struct file_operations kprobe_events_ops = {
+	.owner          = THIS_MODULE,
+	.open           = probes_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+	.write		= probes_write,
+};
+
+/* Kprobe handler */
+static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
+{
+	struct trace_probe *tp = container_of(kp, struct trace_probe, kp);
+	struct kprobe_trace_entry *entry;
+	struct ring_buffer_event *event;
+	int size, i, pc;
+	unsigned long irq_flags;
+	struct ftrace_event_call *call = &event_kprobe;
+
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
+	size = sizeof(struct kprobe_trace_entry) -
+	       (sizeof(unsigned long) * (TRACE_KPROBE_ARGS - tp->nr_args));
+
+	event = trace_current_buffer_lock_reserve(TRACE_KPROBE, size,
+						  irq_flags, pc);
+	if (!event)
+		return 0;
+
+	entry = ring_buffer_event_data(event);
+	entry->nargs = tp->nr_args;
+	entry->ip = (unsigned long)kp->addr;
+	for (i = 0; i < tp->nr_args; i++)
+		entry->args[i] = call_fetch(&tp->args[i], regs);
+
+	if (!filter_current_check_discard(call, entry, event))
+		trace_nowake_buffer_unlock_commit(event, irq_flags, pc);
+	return 0;
+}
+
+/* Kretprobe handler */
+static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
+					  struct pt_regs *regs)
+{
+	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
+	struct kretprobe_trace_entry *entry;
+	struct ring_buffer_event *event;
+	int size, i, pc;
+	unsigned long irq_flags;
+	struct ftrace_event_call *call = &event_kretprobe;
+
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
+	size = sizeof(struct kretprobe_trace_entry) -
+	       (sizeof(unsigned long) * (TRACE_KPROBE_ARGS - tp->nr_args));
+
+	event = trace_current_buffer_lock_reserve(TRACE_KRETPROBE, size,
+						  irq_flags, pc);
+	if (!event)
+		return 0;
+
+	entry = ring_buffer_event_data(event);
+	entry->nargs = tp->nr_args;
+	entry->func = (unsigned long)probe_address(tp);
+	entry->ret_ip = (unsigned long)ri->ret_addr;
+	for (i = 0; i < tp->nr_args; i++)
+		entry->args[i] = call_fetch(&tp->args[i], regs);
+
+	if (!filter_current_check_discard(call, entry, event))
+		trace_nowake_buffer_unlock_commit(event, irq_flags, pc);
+
+	return 0;
+}
+
+/* Event entry printers */
+enum print_line_t
+print_kprobe_event(struct trace_iterator *iter, int flags)
+{
+	struct kprobe_trace_entry *field;
+	struct trace_seq *s = &iter->seq;
+	int i;
+
+	trace_assign_type(field, iter->ent);
+
+	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
+		goto partial;
+
+	if (!trace_seq_puts(s, ":"))
+		goto partial;
+
+	for (i = 0; i < field->nargs; i++)
+		if (!trace_seq_printf(s, " 0x%lx", field->args[i]))
+			goto partial;
+
+	if (!trace_seq_puts(s, "\n"))
+		goto partial;
+
+	return TRACE_TYPE_HANDLED;
+partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+enum print_line_t
+print_kretprobe_event(struct trace_iterator *iter, int flags)
+{
+	struct kretprobe_trace_entry *field;
+	struct trace_seq *s = &iter->seq;
+	int i;
+
+	trace_assign_type(field, iter->ent);
+
+	if (!seq_print_ip_sym(s, field->ret_ip, flags | TRACE_ITER_SYM_OFFSET))
+		goto partial;
+
+	if (!trace_seq_puts(s, " <- "))
+		goto partial;
+
+	if (!seq_print_ip_sym(s, field->func, flags & ~TRACE_ITER_SYM_OFFSET))
+		goto partial;
+
+	if (!trace_seq_puts(s, ":"))
+		goto partial;
+
+	for (i = 0; i < field->nargs; i++)
+		if (!trace_seq_printf(s, " 0x%lx", field->args[i]))
+			goto partial;
+
+	if (!trace_seq_puts(s, "\n"))
+		goto partial;
+
+	return TRACE_TYPE_HANDLED;
+partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static struct trace_event kprobe_trace_event = {
+	.type	 	= TRACE_KPROBE,
+	.trace		= print_kprobe_event,
+};
+
+static struct trace_event kretprobe_trace_event = {
+	.type	 	= TRACE_KRETPROBE,
+	.trace		= print_kretprobe_event,
+};
+
+/* Make a debugfs interface for controling probe points */
+static __init int init_kprobe_trace(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+	int ret;
+
+	ret = register_ftrace_event(&kprobe_trace_event);
+	if (!ret) {
+		pr_warning("Could not register kprobe_trace_event type.\n");
+		return 0;
+	}
+	ret = register_ftrace_event(&kretprobe_trace_event);
+	if (!ret) {
+		pr_warning("Could not register kretprobe_trace_event type.\n");
+		return 0;
+	}
+
+	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
+
+	entry = debugfs_create_file("kprobe_events", 0644, d_tracer,
+				    NULL, &kprobe_events_ops);
+
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'kprobe_events' entry\n");
+	return 0;
+}
+fs_initcall(init_kprobe_trace);
+
+
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+
+static int kprobe_trace_selftest_target(int a1, int a2, int a3,
+					int a4, int a5, int a6)
+{
+	return a1 + a2 + a3 + a4 + a5 + a6;
+}
+
+static __init int kprobe_trace_self_tests_init(void)
+{
+	int ret;
+	int (*target)(int, int, int, int, int, int);
+	target = kprobe_trace_selftest_target;
+
+	pr_info("Testing kprobe tracing: ");
+
+	ret = command_trace_probe("p kprobe_trace_selftest_target "
+				  "a1 a2 a3 a4 a5 a6");
+	if (WARN_ON_ONCE(ret))
+		pr_warning("error enabling function entry\n");
+
+	ret = command_trace_probe("r kprobe_trace_selftest_target "
+				  "ra rv");
+	if (WARN_ON_ONCE(ret))
+		pr_warning("error enabling function return\n");
+
+	ret = target(1, 2, 3, 4, 5, 6);
+
+	cleanup_all_probes();
+
+	pr_cont("OK\n");
+	return 0;
+}
+
+late_initcall(kprobe_trace_self_tests_init);
+
+#endif


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

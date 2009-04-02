Return-Path: <linux-kernel-owner+w=401wt.eu-S934537AbZDBR04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934537AbZDBR04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934178AbZDBRYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:24:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43081 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934175AbZDBRYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:24:48 -0400
Message-ID: <49D4F4ED.6000906@redhat.com>
Date: Thu, 02 Apr 2009 13:25:01 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Jim Keniston <jkenisto@us.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>, kvm@vger.kernel.org
Subject: [PATCH -tip 5/6 V4] tracing: kprobe-tracer plugin core
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kprobes based event tracer on ftrace.

This tracer is similar to the events tracer which is based on Tracepoint
infrastructure. Instead of Tracepoint, this tracer is based on kprobes(kprobe
and kretprobe). It probes anywhere where kprobes can probe(this means, all
functions body except for __kprobes functions).

changes from v3:
  - warn if the probe address is not an instruction boundary.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 Documentation/ftrace.txt    |   55 ++++++
 kernel/trace/Kconfig        |    9 +
 kernel/trace/Makefile       |    1
 kernel/trace/trace_kprobe.c |  400 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 465 insertions(+), 0 deletions(-)
 create mode 100644 kernel/trace/trace_kprobe.c


diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index fd9a3e6..fd0833b 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -1310,6 +1310,61 @@ dereference in a kernel module:
 [...]


+kprobe-based event tracer
+---------------------------
+
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
+/debug/tracing/kprobe_probes.
+
+Synopsis of kprobe_probes:
+  p SYMBOL[+offs|-offs]|MEMADDR	: set a probe
+  r SYMBOL[+0]				: set a return probe
+
+E.g.
+  echo p sys_open > /debug/tracing/kprobe_probes
+
+ This sets a kprobe on the top of sys_open() function.
+
+  echo r sys_open >> /debug/tracing/kprobe_probes
+
+ This sets a kretprobe on the return point of sys_open() function.
+
+  echo > /debug/tracing/kprobe_probes
+
+ This clears all probe points. and you can see the traced information via
+/debug/tracing/trace.
+
+  cat /debug/tracing/trace
+# tracer: nop
+#
+#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
+#              | |       |          |         |
+           <...>-5117  [003]   416.481638: sys_open: @sys_open+0
+           <...>-5117  [003]   416.481662: syscall_call: <-sys_open+0
+           <...>-5117  [003]   416.481739: sys_open: @sys_open+0
+           <...>-5117  [003]   416.481762: sysenter_do_call: <-sys_open+0
+           <...>-5117  [003]   416.481818: sys_open: @sys_open+0
+           <...>-5117  [003]   416.481842: sysenter_do_call: <-sys_open+0
+           <...>-5117  [003]   416.481882: sys_open: @sys_open+0
+           <...>-5117  [003]   416.481905: sysenter_do_call: <-sys_open+0
+
+ @SYMBOL means that kernel hits a probe, and <-SYMBOL means kernel returns
+from SYMBOL(e.g. "sysenter_do_call: <-sys_open+0" means kernel returns from
+sys_open to sysenter_do_call).
+
+
 function graph tracer
 ---------------------------

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8a4d729..becd8ed 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -357,6 +357,15 @@ config BLK_DEV_IO_TRACE

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
index 2630f51..f39a26b 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -46,5 +46,6 @@ obj-$(CONFIG_EVENT_TRACER) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
 obj-$(CONFIG_EVENT_TRACER) += trace_events_filter.o
+obj-$(CONFIG_KPROBE_TRACER) += trace_kprobe.o

 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
new file mode 100644
index 0000000..8263b5f
--- /dev/null
+++ b/kernel/trace/trace_kprobe.c
@@ -0,0 +1,400 @@
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
+
+#include <linux/ftrace.h>
+#include "trace.h"
+
+/**
+ * kprobe_trace_core
+ */
+#define TRACE_MAXARGS 6
+
+struct trace_probe {
+	struct list_head	list;
+	union {
+		struct kprobe		kp;
+		struct kretprobe	rp;
+	};
+	const char		*symbol;	/* symbol name */
+};
+
+static void kprobe_trace_record(unsigned long ip, struct trace_probe *tp,
+				struct pt_regs *regs);
+
+static int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
+{
+	struct trace_probe *tp = container_of(kp, struct trace_probe, kp);
+
+	kprobe_trace_record(instruction_pointer(regs), tp, regs);
+	return 0;
+}
+
+static int kretprobe_trace_func(struct kretprobe_instance *ri,
+				struct pt_regs *regs)
+{
+	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
+
+	kprobe_trace_record((unsigned long)ri->ret_addr, tp, regs);
+	return 0;
+}
+
+static int probe_is_return(struct trace_probe *tp)
+{
+	return (tp->rp.handler == kretprobe_trace_func);
+}
+
+static const char *probe_symbol(struct trace_probe *tp)
+{
+	return tp->symbol ? tp->symbol : "unknown";
+}
+
+static long probe_offset(struct trace_probe *tp)
+{
+	return (probe_is_return(tp)) ? tp->rp.kp.offset : tp->kp.offset;
+}
+
+static void *probe_address(struct trace_probe *tp)
+{
+	return (probe_is_return(tp)) ? tp->rp.kp.addr : tp->kp.addr;
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
+static int create_trace_probe(int argc, char **argv)
+{
+	/*
+	 * Argument syntax:
+	 *  - Add kprobe: p SYMBOL[+OFFS|-OFFS]|ADDRESS
+	 *  - Add kretprobe: r SYMBOL[+0]
+	 */
+	struct trace_probe *tp;
+	struct kprobe *kp;
+	char *tmp;
+	int ret = 0;
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
+		tmp = strchr(symbol, '+');
+		if (!tmp)
+			tmp = strchr(symbol, '-');
+
+		if (tmp) {
+			/* skip sign because strict_strtol doesn't accept '+' */
+			ret = strict_strtol(tmp + 1, 0, &offset);
+			if (ret)
+				return ret;
+			if (*tmp == '-')
+				offset = -offset;
+			*tmp = '\0';
+		}
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
+
+	if (tp == NULL)
+		return 0;
+
+	if (tp->symbol)
+		seq_printf(m, "%c %s%+ld\n",
+			probe_is_return(tp) ? 'r' : 'p',
+			probe_symbol(tp), probe_offset(tp));
+	else
+		seq_printf(m, "%c 0x%p\n",
+			probe_is_return(tp) ? 'r' : 'p',
+			probe_address(tp));
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
+
+#define WRITE_BUFSIZE 128
+
+ssize_t probes_write(struct file *file, const char __user *buffer,
+		     size_t count, loff_t *ppos)
+{
+	char *kbuf, *tmp;
+	char **argv = NULL;
+	int argc = 0;
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
+
+		argv = argv_split(GFP_KERNEL, kbuf, &argc);
+		if (!argv) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		if (argc)
+			ret = create_trace_probe(argc, argv);
+
+		argv_free(argv);
+		if (ret < 0)
+			goto out;
+
+	} while (done < count);
+	ret = done;
+out:
+	kfree(kbuf);
+	return ret;
+}
+
+static const struct file_operations kprobe_points_ops = {
+	.owner          = THIS_MODULE,
+	.open           = probes_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+	.write		= probes_write,
+};
+
+/* event recording functions */
+static void kprobe_trace_record(unsigned long ip, struct trace_probe *tp,
+				struct pt_regs *regs)
+{
+	__trace_bprintk(ip, "%s%s%+ld\n",
+			probe_is_return(tp) ? "<-" : "@",
+			probe_symbol(tp), probe_offset(tp));
+}
+
+/* Make a debugfs interface for controling probe points */
+static __init int init_kprobe_trace(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
+
+	entry = debugfs_create_file("kprobe_probes", 0644, d_tracer,
+				    NULL, &kprobe_points_ops);
+
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'kprobe_probess' entry\n");
+	return 0;
+}
+fs_initcall(init_kprobe_trace);
+
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


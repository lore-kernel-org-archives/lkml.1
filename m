Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbXKMBDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbXKMBDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 20:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbXKMBCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 20:02:35 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47510 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759186AbXKMBCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 20:02:33 -0500
Subject: [patch 3/3]  Trace samples
From: "David J. Wilder" <dwilder@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: systemtap@sources.redhat.com
Content-Type: text/plain
Date: Mon, 12 Nov 2007 17:02:22 -0800
Message-Id: <1194915748.913.20.camel@lc4eb748232119.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trace example - Adds the trace example to samples/

Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 samples/Kconfig            |    6 +
 samples/Makefile           |    1 +
 samples/trace/Makefile     |    4 +
 samples/trace/fork_trace.c |  132 ++++++++++++++++++++++++++
 samples/trace/sem_watch.c  |  224 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 367 insertions(+), 0 deletions(-)

diff --git a/samples/Kconfig b/samples/Kconfig
index 57bb223..fa3c453 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -13,4 +13,10 @@ config SAMPLE_MARKERS
 	help
 	  This build markers example modules.
 
+config SAMPLE_TRACE
+	tristate "Build trace example -- loadable modules only"
+	depends on TRACE && KPROBES && m
+	help
+	  This builds a trace example module.
+
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index 5a4f0b6..8f6d05b 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,3 +1,4 @@
 # Makefile for Linux samples code
 
 obj-$(CONFIG_SAMPLES)	+= markers/
+obj-$(CONFIG_SAMPLES)	+= trace/
diff --git a/samples/trace/Makefile b/samples/trace/Makefile
new file mode 100644
index 0000000..0168641
--- /dev/null
+++ b/samples/trace/Makefile
@@ -0,0 +1,4 @@
+# builds the trace example kernel modules;
+# then to use (as root):  insmod <fork_trace.ko> or <sem_watch.ko>
+
+obj-$(CONFIG_SAMPLE_TRACE) := fork_trace.o sem_watch.o
diff --git a/samples/trace/fork_trace.c b/samples/trace/fork_trace.c
new file mode 100644
index 0000000..71c04c7
--- /dev/null
+++ b/samples/trace/fork_trace.c
@@ -0,0 +1,132 @@
+/*
+ * An example of using trace in a kprobes module
+ *
+ * Copyright (C) 2007 IBM Inc.
+ *
+ * David Wilder <dwilder@us.ibm.com>
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
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * -------
+ * This module creates a trace channel and places a kprobe
+ * on the function do_fork(). The value of current->pid is written to
+ * the trace channel each time the kprobe is hit..
+ *
+ * How to run the example:
+ * $ mount -t debugfs /debug
+ * $ insmod fork_trace.ko
+ *
+ * To view the data produced by the module:
+ * $ cat /debug/trace_example/do_fork/trace0
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+#include <linux/trace.h>
+
+#define USE_GLOBAL_BUFFERS 1
+#define USE_FLIGHT 1
+
+#define PROBE_POINT "do_fork"
+
+static struct kprobe kp;
+static struct trace_info *kprobes_trace;
+
+#ifdef USE_GLOBAL_BUFFERS
+static DEFINE_SPINLOCK(trace_lock);
+#endif
+
+/*
+ * Send formatted trace data to trace channel.
+ * @note Preemption must be disabled to use this.
+ */
+static void trace_printf(struct trace_info *trace, const char *format, ...)
+{
+	va_list ap, aq;
+	char *record;
+	unsigned long flags;
+	int len;
+
+	if (!trace)
+		return;
+
+#ifdef USE_GLOBAL_BUFFERS
+	spin_lock_irqsave(&trace_lock, flags);
+#endif
+	if (trace_running(trace)) {
+		va_start(ap, format);
+		va_copy(aq, ap);
+		len = vsnprintf(NULL, 0, format, aq);
+		va_end(aq);
+		record = relay_reserve(trace->rchan, ++len);
+		if (record)
+			vsnprintf(record, len, format, ap);
+		va_end(ap);
+	}
+#ifdef USE_GLOBAL_BUFFERS
+	spin_unlock_irqrestore(&trace_lock, flags);
+#endif
+}
+
+static int handler_pre(struct kprobe *p, struct pt_regs *regs)
+{
+	rcu_read_lock();
+	trace_printf(kprobes_trace, "%d\n", current->pid);
+	rcu_read_unlock();
+	return 0;
+}
+
+int init_module(void)
+{
+	int ret;
+	u32 flags = 0;
+
+#ifdef USE_GLOBAL_BUFFERS
+	flags |= TRACE_GLOBAL_CHANNEL;
+#endif
+
+#ifdef USE_FLIGHT
+	flags |= TRACE_FLIGHT_CHANNEL;
+#endif
+
+	/* setup the trace */
+	kprobes_trace = trace_setup("trace_example", PROBE_POINT,
+				     1024, 8, flags);
+	if (IS_ERR(kprobes_trace))
+		return PTR_ERR(kprobes_trace);
+
+	trace_start(kprobes_trace);
+
+	/* setup the kprobe */
+	kp.pre_handler = handler_pre;
+	kp.post_handler = NULL;
+	kp.fault_handler = NULL;
+	kp.symbol_name = PROBE_POINT;
+	ret = register_kprobe(&kp);
+	if (ret) {
+		printk(KERN_ERR "fork_trace: register_kprobe failed\n");
+		return ret;
+	}
+	return 0;
+}
+
+void cleanup_module(void)
+{
+	unregister_kprobe(&kp);
+	trace_stop(kprobes_trace);
+	trace_cleanup(kprobes_trace);
+}
+MODULE_LICENSE("GPL");
diff --git a/samples/trace/sem_watch.c b/samples/trace/sem_watch.c
new file mode 100644
index 0000000..279aeb9
--- /dev/null
+++ b/samples/trace/sem_watch.c
@@ -0,0 +1,224 @@
+/*
+ * An example of using trace with marker probes
+ *
+ * Copyright (C) 2007 IBM Inc.
+ *
+ * David Wilder <dwilder@us.ibm.com>
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
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * -------
+ * This example show how trace may be used to collect marker probe data.
+ * For this example to work a series of markers must be placed in
+ * lib/semaphore-sleepers.c. The markers record the execution of semaphore
+ * primitives.  An example patch that places these markers can be
+ * found in the lkml archive.  The data generated by this code can be used
+ * to analyze semaphore contention.
+ *
+ * How to run the example:
+ * $ mount -t debugfs /debug
+ * $ modprobe sem_watch
+ *
+ * To start the recording of trace data:
+ *   echo start > /debug/trace_example/sem_watch/state
+ *
+ * Generate a test load and stop the trace:
+ *   echo stop > /debug/trace_example/sem_watch/state
+ *
+ * Collect the data from the per-cpu trace buffers, sorting chronologically:
+ *   sort --field-separator=: --key=2.1 /debug/trace_example/sem_watch/trace*
+ *
+ * Verify that no data was lost by examining the dropped file:
+ *   cat /debug/trace_example/sem_watch/dropped
+ *
+ * To collect a larger amount of data the trace buffers can be read
+ * continuously using something like:
+ *
+ *	echo start > /debug/trace_example/sem_watch/state
+ *	while [ 1 ] ; do
+ *		sort --field-separator=: --key=2.1 <.....>/trace*
+ *	done
+ *	echo stop > /debug/trace_example/sem_watch/state
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ktime.h>
+#include <linux/marker.h>
+#include <linux/trace.h>
+
+#define modname "sem_watch"
+
+void probe_sem_generic(const struct marker *, void *, const char *, ...);
+
+static struct trace_info *sem_trace;
+
+struct probe_data {
+	const char *name;
+	const char *format;
+	marker_probe_func *probe_func;
+};
+
+/* marker probes array */
+static struct probe_data probes[] =
+{
+	{ .name = "sem_up",
+	  .format = "%p",
+	  .probe_func = probe_sem_generic },
+
+	{ .name = "sem_down",
+	  .format = "%p",
+	  .probe_func = probe_sem_generic },
+
+	{ .name = "sem_down_sched",
+	  .format = "%p",
+	  .probe_func = probe_sem_generic },
+
+	{ .name = "sem_down_resume",
+	  .format = "%p",
+	  .probe_func = probe_sem_generic },
+
+	{ .name = "sem_down_intr",
+	  .format = "%p",
+	  .probe_func = probe_sem_generic },
+
+	{ .name = "sem_down_intr_sched",
+	  .format = "%p",
+	  .probe_func = probe_sem_generic },
+
+	{ .name = "sem_down_intr_fail",
+	  .format = "%p",
+	  .probe_func = probe_sem_generic },
+
+	{ .name = "sem_down_intr_resume",
+	  .format = "%p",
+	  .probe_func = probe_sem_generic }
+};
+
+#define NPROBES ARRAY_SIZE(probes)
+
+inline s64 get_time(void)
+{
+	struct timespec ts;
+	ktime_get_real_ts(&ts);
+	return (s64) ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
+}
+
+/**
+ * This probe function is called each time one of the semaphore markers is
+ * hit. Using the trace channel, we log a time stamp, the semaphore primitive
+ * (the probe name), address of the semaphore, pid and command name.
+ * For simplicity of the example, all log data is converter to ASCII.
+ * Logging binary data would be much more efficient, but requires a
+ * corresponding user program to interpret the data.
+ */
+void probe_sem_generic(const struct marker *mdata, void *private,
+			const char *format, ...)
+{
+	int len;
+	va_list ap;
+	char *record;
+	void *semaddr;
+	s64 tstamp;
+	struct probe_data *pd = (struct probe_data *) mdata->private;
+
+	if (!sem_trace)
+		return;
+
+	if (!trace_running(sem_trace))
+		return;
+
+	va_start(ap, format);
+	semaddr =  va_arg(ap, void *);
+	va_end(ap);
+
+	tstamp = get_time();
+
+	/**
+	 * Log format  :time-stamp:probe-name:semaddr:pid:command-name
+	 */
+	len = snprintf(NULL, 0, ":%lld:%s:%p:%d:%s\n",
+	tstamp, pd->name, semaddr, current->pid, current->comm);
+
+	record = relay_reserve(sem_trace->rchan, ++len);
+	if (record)
+		snprintf(record, len, ":%lld:%s:%p:%d:%s\n",
+		tstamp, pd->name, semaddr, current->pid, current->comm);
+}
+
+static void clean_up(void)
+{
+	int i;
+
+	/* Deregister marker probes */
+	for (i = 0; i < NPROBES; i++)
+		marker_probe_unregister(probes[i].name);
+
+	synchronize_sched();    /* Wait for probes to finish */
+
+	/* Shut down the trace */
+	trace_stop(sem_trace);
+	trace_cleanup(sem_trace);
+}
+
+/**
+ * Initialize module
+ */
+static int __init sem_watch_init(void)
+{
+	int i, result;
+
+	/* Setup the trace using per-cpu buffering  */
+	sem_trace = trace_setup("trace_example", modname, 2048, 8, 0);
+	if (IS_ERR(sem_trace))
+		return PTR_ERR(sem_trace);
+
+
+	/* Register and arm marker probes */
+	for (i = 0; i < NPROBES; i++) {
+		result = marker_probe_register(probes[i].name, probes[i].format,
+					probes[i].probe_func, &probes[i]);
+		if (result) {
+			printk(KERN_INFO "Unable to register probe %s\n",
+				probes[i].name);
+			break;
+		}
+
+		result = marker_arm(probes[i].name);
+		if (result) {
+			printk(KERN_INFO "Unable to arm probe %s\n",
+				probes[i].name);
+			break;
+		}
+	}
+
+	if (result)
+		clean_up();
+
+	return result;
+}
+
+/**
+ * Exit module
+ */
+static void __exit sem_watch_exit(void)
+{
+	clean_up();
+}
+
+module_init(sem_watch_init);
+module_exit(sem_watch_exit);
+
+MODULE_LICENSE("GPL");



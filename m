Return-Path: <linux-kernel-owner+w=401wt.eu-S1763777AbXIMXnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763777AbXIMXnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760116AbXIMXnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:43:21 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41416 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337AbXIMXnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:43:19 -0400
Message-ID: <46E9CB14.7060000@us.ibm.com>
Date: Thu, 13 Sep 2007 16:43:16 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, SystemTAP <systemtap@sources.redhat.com>
CC: akpm@linux-foundation.org
Subject: [PATCH 1/2] Trace code and documentation
Content-Type: multipart/mixed;
 boundary="------------040002040107010203060601"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040002040107010203060601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------040002040107010203060601
Content-Type: text/x-patch;
 name="trace.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="trace.patch"

Trace - Provides tracing primitives

Tom Zanussi <zanussi@us.ibm.com>
Martin Hunt <hunt@redhat.com>
David Wilder <dwilder@us.ibm.com>

---
 Documentation/trace.txt |  297 ++++++++++++++++++++++++
 include/linux/trace.h   |   99 ++++++++
 lib/Kconfig             |   10 +
 lib/Makefile            |    2 +
 lib/trace.c             |  575 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 983 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace.txt b/Documentation/trace.txt
new file mode 100644
index 0000000..57a5c71
--- /dev/null
+++ b/Documentation/trace.txt
@@ -0,0 +1,297 @@
+Trace Setup and Control
+=======================
+In the kernel, the trace interface provides a simple mechanism for
+starting and managing data channels (traces) to user space.  The
+trace interface builds on the relay interface.  For a complete
+description of the relay interface, please see:
+Documentation/filesystems/relay.txt.
+
+The trace interface provides a single layer in a complete tracing
+application.  Trace provides a kernel API that can be used for the setup
+and control of tracing channels.  User of trace must provide a data layer
+responsible for formatting and writing data into the trace channels.
+
+A layered approach to tracing
+=============================
+A complete kernel tracing application consists of a data provider and
+a data consumer.  Both provider and consumer contain three layers; each
+layer works in tandem with the corresponding layer in the opposite side.
+The layers are represented in the following diagram.
+
+Provider Data layer
+	Formats raw trace data and provides data-related service.
+	For example, adding timestamps used by consumer to sort data.
+
+Provider Control layer
+	Provided by the trace interface, this layer creates trace channels
+	and informs the data layer and consumer of the current state
+	of the trace channels.
+
+Provider Buffering layer
+	Provided by relay. This layer buffers data in the
+	kernel for consumption by the consumer's buffer
+	layer.
+
+Provider (in-kernel facility)
+-----------------------------------------------------------------------------
+Consumer (user application)
+
+
+Consumer Buffer layer
+	Reads/consumes data from the provider's data buffers.
+
+Consumer Control layer
+	Communicates to the provider's control layer to control the state
+	of the trace channels.
+
+Consumer Data layer
+	Sorts and formats data as provided by the provider's data layer.
+
+The provider is coded as a kernel facility.  The consumer is coded as
+a user application.
+
+
+Trace - Features
+================
+Trace exploits services and features provided by relay.  These features
+are:
+- The creation and destruction of relay channels.
+- Buffer management.  Overwrite or non-overwrite modes can be selected
+  as well as global or per-CPU buffering.
+
+Overwrite mode can be called "flight recorder mode".  Flight recorder
+mode is selected by setting the TRACE_FLIGHT_CHANNEL flag when
+creating trace channels.  In flight mode when a tracing buffer is
+full, the oldest records in the buffer will be discarded to make room
+as new records arrive.	In the default non-overwrite mode, new records
+may be written only if the buffer has room.  In either case, to
+prevent data loss, a user space reader must keep the buffers
+drained. Trace provides a means to detect the number of records that
+have been dropped due to a buffer-full condition (non-overwrite mode
+only).
+
+When per-CPU buffers are used, relay creates one debugfs file for each
+running CPU.  The user-space consumer of the data is responsible for
+reading the per-CPU buffers and collating the records presumably using
+a time stamp or sequence number included in the trace records.	The
+use of global buffers eliminates this extra work of sequencing
+records; however the provider's data layer must hold a lock when
+writing records.  The lock prevents writers running on different CPUs
+from overwriting each other's data.  However, buffering may be slower
+because writes to the buffer are serialized. Global buffering is
+selected by setting the TRACE_GLOBAL_CHANNEL flag when creating trace
+channels.
+
+Trace User Interface
+===================
+When a trace channel is created and started, the following
+directories and files are created in the root of the mounted debugfs.
+
+/debug (root of the debugfs)
+	/<trace-root-dir>
+		/<trace-name>
+			trace0 ... traceN  Per-CPU trace data, one
+					   file per CPU.
+
+			state		   Start or stop tracing by
+					   by writing the strings
+					   "start" or "stop" to this
+					   file. Read the file to get the
+					   current state.
+
+			dropped		   The number of records dropped
+					   due to a full-buffer condition,
+					   for non-TRACE_FLIGHT_CHANNELs
+					   only.
+
+			rewind		   Trigger a rewind by writing
+					   to this file.  i.e. start
+					   next read at the beginning
+					   again. Only available for
+					   TRACE_FLIGHT_CHANNELS.
+
+
+			nr_sub		   Number of sub-buffers
+					   in the channel.
+
+			sub_size	   Size of sub-buffers in
+					   the channnel.
+
+Trace data is gathered from the trace[0...N] files using one of the
+available interfaces provided by relay.
+
+When using the READ(2) interface, as data is read it is marked as
+consumed by the relay subsystem.  Therefore, subsequent reads will
+only return unconsumed data.
+
+Trace Kernel API
+===============
+An overview of the trace Kernel API is now given. More details of the
+API can be found in linux/trace.h.
+
+The steps a kernel data provider takes to utilize the trace interface are:
+1) Set up a trace channel - trace_setup()
+2) Start the trace channel - trace_start()
+3) Write one or more trace records into the channel (using the relay API).
+
+   Important: When writing a trace record the provider must insure that
+   preemption is disabled and that trace state is  set to "running". a
+   typical function used to write records into a trace channel should
+   follow the following semantics:
+
+	rcu_read_lock();	    // disables preemption
+	if (trace_running(trace)){
+		relay_write(....); // use any available relay data
+		function
+	}
+	rcu_read_unlock();	   // enables preemption
+
+4) Stop and start tracing as desired - trace_start()/trace_stop()
+5) Destroy the trace channel and underlying relay channel -
+trace_cleanup().
+
+Trace Example
+===========
+
+This small sample module creates a trace channel. It places a kprobe
+on the function do_fork(). The value of current->pid is writen to
+the trace channel.
+
+You can build the kernel module fork_trace.ko using the following
+Makefile:
+------------------------------------CUT-------------------------------------
+obj-m := fork_trace.o
+KDIR := /lib/modules/$(shell uname -r)/build
+PWD := $(shell pwd)
+default:
+	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
+clean:
+	rm -f *.mod.c *.ko *.o
+----------------------------------CUT--------------------------------------
+
+/* fork_trace.c - An example of using trace in a kprobes module */
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
+struct trace_info *kprobes_trace;
+
+#ifdef USE_GLOBAL_BUFFERS
+static DEFINE_SPINLOCK(trace_lock);
+#endif
+
+#define TRACE_PRINTF_TMPBUF_SIZE (1024)
+static char trace_tmpbuf[NR_CPUS][TRACE_PRINTF_TMPBUF_SIZE];
+
+void trace_printf(struct trace_info *trace, const char *format, ...)
+{
+	va_list args;
+	void *buf;
+	char *record;
+	int len=0;
+
+	if (!trace)
+		return;
+
+	buf = trace_tmpbuf[smp_processor_id()];
+
+#ifdef USE_GLOBAL_BUFFERS
+	spin_lock(&trace_lock);
+#endif
+
+	rcu_read_lock();
+	if (trace_running(trace)){
+		va_start(args, format);
+		len += vsnprintf(buf+len, TRACE_PRINTF_TMPBUF_SIZE,
+				 format, args);
+		va_end(args);
+
+		if ((record = relay_reserve(trace->rchan, len)))
+			memcpy(record, buf, len);
+	}
+	rcu_read_unlock();
+
+#ifdef USE_GLOBAL_BUFFERS
+	spin_unlock(&trace_lock);
+#endif
+}
+
+
+int handler_pre(struct kprobe *p, struct pt_regs *regs)
+{
+	trace_printf(kprobes_trace,"%d\n", current->pid);
+	return 0;
+}
+
+
+int init_module(void)
+{
+	u32 flags=0;
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
+	kprobes_trace = trace_setup("trace_example",PROBE_POINT,
+				     1024,8,flags);
+	if (!kprobes_trace)
+		return -1;
+
+	trace_start(kprobes_trace);
+
+	/* setup the kprobe */
+	kp.pre_handler = handler_pre;
+	kp.post_handler = NULL;
+	kp.fault_handler = NULL;
+	kp.symbol_name = PROBE_POINT;
+	if (register_kprobe(&kp) < 0) {
+		printk("fork_trace: register_kprobe failed\n");
+		return -1;
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
+
+MODULE_LICENSE("GPL");
+-----------------------------CUT-----------------------------------
+How to run the example:
+$ mount -t debugfs /debug
+$ make
+$ insmod fork_trace.ko
+
+To view the data produced by the module:
+$ cat /debug/trace_example/do_fork/trace0
+
+Remove the module.
+$ rmmod fork_trace
+
+The function trace_cleanup() is called when the module
+is removed.  This will cause the TRACE channel to be destroyed and the
+corresponding files to disappear from the debug file system.
+
+Credits
+=======
+Trace is adapted from blktrace authored by Jens Axboe (axboe@suse.de).
+
+Major contributions were made by:
+Tom Zanussi <zanussi@us.ibm.com>
+Martin Hunt <hunt@redhat.com>
+David Wilder <dwilder@us.ibm.com>
diff --git a/include/linux/trace.h b/include/linux/trace.h
new file mode 100644
index 0000000..6dff7d0
--- /dev/null
+++ b/include/linux/trace.h
@@ -0,0 +1,99 @@
+/*
+ * TRACE defines and function prototypes
+ *
+ * Copyright (C) 2006 IBM Inc.
+ *
+ *	Tom Zanussi <zanussi@us.ibm.com>
+ *	Martin Hunt <hunt@redhat.com>
+ *	David Wilder <dwilder@us.ibm.com>
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
+ */
+#ifndef _LINUX_TRACE_H
+#define _LINUX_TRACE_H
+
+#include <linux/relay.h>
+
+/*
+ * TRACE channel flags
+ */
+#define TRACE_GLOBAL_CHANNEL	0x01
+#define TRACE_FLIGHT_CHANNEL	0x02
+#define TRACE_DISABLE_STATE	0x04
+
+enum trace_state {
+	TRACE_SETUP,
+	TRACE_RUNNING,
+	TRACE_STOPPED,
+};
+
+#define TRACE_ROOT_NAME_SIZE	64	/* Max root dir identifier */
+#define TRACE_NAME_SIZE		64	/* Max trace identifier */
+
+/*
+ * Global root user information
+ */
+struct trace_root {
+	struct list_head list;
+	char name[TRACE_ROOT_NAME_SIZE];
+	struct dentry *root;
+	unsigned int users;
+};
+
+/*
+ * Client information
+ */
+struct trace_info {
+	struct mutex state_mutex;
+	enum trace_state state;
+	struct dentry *state_file;
+	struct rchan *rchan;
+	struct dentry *dir;
+	struct dentry *dropped_file;
+	struct dentry *reset_consumed_file;
+	struct dentry *nr_sub_file;
+	struct dentry *sub_size_file;
+	atomic_t dropped;
+	struct trace_root *root;
+	void *private_data;
+	unsigned int flags;
+	unsigned int buf_size;
+	unsigned int buf_nr;
+};
+
+#ifdef CONFIG_TRACE
+static inline int trace_running(struct trace_info *trace)
+{
+	return trace->state == TRACE_RUNNING;
+}
+struct trace_info *trace_setup(const char *root, const char *name,
+			       u32 buf_size, u32 buf_nr, u32 flags);
+int trace_start(struct trace_info *trace);
+int trace_stop(struct trace_info *trace);
+void trace_cleanup(struct trace_info *trace);
+#else
+static inline struct trace_info *trace_setup(const char *root,
+					     const char *name,u32 buf_size,
+					     u32 buf_nr, u32 flags)
+{
+	return NULL;
+}
+static inline int trace_start(struct trace_info *trace) { return -EINVAL; }
+static inline int trace_stop(struct trace_info *trace) { return -EINVAL; }
+static inline int trace_running(struct trace_info *trace) { return 0; }
+static inline void trace_cleanup(struct trace_info *trace) {}
+#endif
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index ba3d104..6d9fffa 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -141,4 +141,14 @@ config HAS_DMA
 config CHECK_SIGNATURE
 	bool
 
+config TRACE
+	bool "Trace setup and control"
+	select RELAY
+	select DEBUG_FS
+	help
+	  This option provides support for the setup, teardown and control
+	  of tracing channels from kernel code.  It also provides trace
+	  information and control to userspace via a set of debugfs control
+	  files.  If unsure, say N.
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 1e1e8c2..857d7af 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -69,6 +69,8 @@ lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 obj-$(CONFIG_PROFILE_LIKELY) += likely_prof.o
 
+obj-$(CONFIG_TRACE) += trace.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/trace.c b/lib/trace.c
new file mode 100644
index 0000000..17c9053
--- /dev/null
+++ b/lib/trace.c
@@ -0,0 +1,575 @@
+/*
+ * Based on blktrace code, Copyright (C) 2006 Jens Axboe <axboe@suse.de>
+ * Moved to utt.c by Tom Zanussi <zanussi@us.ibm.com>, 2006
+ * Additional contributions by:
+ * Martin Hunt <hunt@redhat.com>, 2007
+ * David Wilder <dwilder@us.ibm.com>, 2007
+ * Renamed to trace <dwilder.ibm.com>, 2007
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
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/mutex.h>
+#include <linux/debugfs.h>
+#include <linux/trace.h>
+
+static LIST_HEAD(trace_roots);
+static DEFINE_MUTEX(trace_mutex);
+
+static int state_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t state_read(struct file *filp, char __user *buffer,
+			  size_t count, loff_t *ppos)
+{
+	struct trace_info *trace = filp->private_data;
+	char *buf = "trace not started\n";
+
+	if (trace->state == TRACE_STOPPED)
+		buf = "stopped\n";
+	else if (trace->state == TRACE_RUNNING)
+		buf = "running\n";
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+
+static ssize_t state_write(struct file *filp, const char __user *buffer,
+			   size_t count, loff_t *ppos)
+{
+	struct trace_info *trace = filp->private_data;
+	char buf[16] = { '\0' };
+	int ret;
+
+	if (trace->flags & TRACE_DISABLE_STATE)
+		return -EINVAL;
+	
+	if (count > sizeof(buf) - 1)
+		return -EINVAL;
+
+	if (copy_from_user(buf, buffer, count))
+		return -EFAULT;
+
+	buf[count] = '\0';
+	
+	if (strncmp(buf, "start", strlen("start")) == 0 ) {
+		ret = trace_start(trace);
+		if (ret)
+			return ret;
+	} else if (strncmp(buffer, "stop", strlen("stop")) == 0)
+		trace_stop(trace);
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+
+static struct file_operations state_fops = {
+	.owner	= THIS_MODULE,
+	.open	= state_open,
+	.read	= state_read,
+	.write	= state_write,
+};
+
+
+static void remove_root(struct trace_info *trace)
+{
+	if (trace->root->root && simple_empty(trace->root->root)) {
+		debugfs_remove(trace->root->root);
+		list_del(&trace->root->list);
+		kfree(trace->root);
+		trace->root = NULL;
+	}
+}
+
+
+static void remove_tree(struct trace_info *trace)
+{
+	mutex_lock(&trace_mutex);
+
+	debugfs_remove(trace->dir);
+
+	if (--trace->root->users == 0)
+		remove_root(trace);
+
+	mutex_unlock(&trace_mutex);
+}
+
+
+/*
+ * Creates the trace_root if it's not found.
+ */
+static struct trace_root *lookup_root(const char *root)
+{
+	struct list_head *pos;
+	struct trace_root *r;
+
+	list_for_each(pos, &trace_roots) {
+		r = list_entry(pos, struct trace_root, list);
+		if (!strcmp(r->name, root))
+			return r;
+	}
+
+	r = kzalloc(sizeof(struct trace_root), GFP_KERNEL);
+	if (!r)
+		return NULL;
+
+	strlcpy(r->name, root, sizeof(r->name));
+
+	r->root = debugfs_create_dir(root, NULL);
+	if (r->root)
+		list_add(&r->list, &trace_roots);
+
+	return r;
+}
+
+
+static struct dentry *create_tree(struct trace_info *trace, const char *root,
+				  const char *name)
+{
+	struct dentry *dir = NULL;
+
+	if (root == NULL || name == NULL)
+		return NULL;
+	
+	mutex_lock(&trace_mutex);
+
+	trace->root = lookup_root(root);
+	if (!trace->root)
+		goto err;
+
+	dir = debugfs_create_dir(name, trace->root->root);
+	if (dir)
+		trace->root->users++;
+	else
+		remove_root(trace);
+
+err:
+	mutex_unlock(&trace_mutex);
+
+	return dir;
+}
+
+
+static int dropped_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+
+	return 0;
+}
+
+
+static ssize_t dropped_read(struct file *filp, char __user *buffer,
+			    size_t count, loff_t *ppos)
+{
+	struct trace_info *trace = filp->private_data;
+	char buf[16];
+
+	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&trace->dropped));
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+
+static struct file_operations dropped_fops = {
+	.owner	= THIS_MODULE,
+	.open	= dropped_open,
+	.read	= dropped_read,
+};
+
+static int reset_consumed_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t reset_consumed_write(struct file *filp,
+				    const char __user *buffer,
+				    size_t count, loff_t *ppos)
+{
+	int ret=count;
+	struct trace_info *trace = filp->private_data;
+
+	mutex_lock(&trace->state_mutex);
+	switch (trace->state){
+	case TRACE_RUNNING:
+		trace->state = TRACE_STOPPED;
+		synchronize_rcu();
+		relay_flush(trace->rchan);
+		relay_reset_consumed(trace->rchan);
+		trace->state = TRACE_RUNNING;
+		break;
+	case TRACE_STOPPED:
+		relay_reset_consumed(trace->rchan);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	mutex_unlock(&trace->state_mutex);
+	return ret;
+}
+
+struct file_operations reset_consumed_fops = {
+	.owner	= THIS_MODULE,
+	.open	= reset_consumed_open,
+	.write	= reset_consumed_write
+};
+
+static int sub_size_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t sub_size_read(struct file *filp, char __user *buffer,
+			     size_t count, loff_t *ppos)
+{
+	struct trace_info *trace = filp->private_data;
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "%u\n",
+		 (unsigned int)trace->rchan->subbuf_size);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+struct file_operations sub_size_fops = {
+	.owner	= THIS_MODULE,
+	.open	= sub_size_open,
+	.read	= sub_size_read,
+};
+
+static int nr_sub_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t nr_sub_read(struct file *filp, char __user *buffer,
+			   size_t count, loff_t *ppos)
+{
+	struct trace_info *trace = filp->private_data;
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "%u\n",
+		 (unsigned int)trace->rchan->n_subbufs);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+struct file_operations nr_sub_fops = {
+	.owner	= THIS_MODULE,
+	.open	= nr_sub_open,
+	.read	= nr_sub_read,
+};
+
+/*
+ * Keep track of how many times we encountered a full subbuffer, to aid
+ * the user space app in telling how many lost events there were.
+ */
+static int subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
+				 void *prev_subbuf, size_t prev_padding)
+{
+	struct trace_info *trace = buf->chan->private_data;
+	
+	if (trace->flags & TRACE_FLIGHT_CHANNEL)
+		return 1;
+	
+	if (!relay_buf_full(buf))
+		return 1;
+
+	atomic_inc(&trace->dropped);
+
+	return 0;
+}
+
+
+static int remove_buf_file_callback(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+
+	return 0;
+}
+
+
+static struct dentry *create_buf_file_callback(const char *filename,
+					       struct dentry *parent, int mode,
+					       struct rchan_buf *buf,
+					       int *is_global)
+{
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+
+static struct dentry *create_global_buf_file_callback(const char *filename,
+						      struct dentry *parent,
+						      int mode,
+						      struct rchan_buf *buf,
+						      int *is_global)
+{
+	*is_global = 1;
+
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+
+static struct rchan_callbacks relay_callbacks = {
+	.subbuf_start		= subbuf_start_callback,
+	.create_buf_file	= create_buf_file_callback,
+	.remove_buf_file	= remove_buf_file_callback,
+};
+static struct rchan_callbacks relay_callbacks_global = {
+	.subbuf_start		= subbuf_start_callback,
+	.create_buf_file	= create_global_buf_file_callback,
+	.remove_buf_file	= remove_buf_file_callback,
+};
+
+
+static void remove_controls(struct trace_info *trace)
+{
+	if (trace->state_file)
+		debugfs_remove(trace->state_file);
+	if (trace->dropped_file)
+		debugfs_remove(trace->dropped_file);
+	if (trace->reset_consumed_file)
+		debugfs_remove(trace->reset_consumed_file);
+	if (trace->nr_sub_file)
+		debugfs_remove(trace->nr_sub_file);
+	if (trace->sub_size_file)
+		debugfs_remove(trace->sub_size_file);
+	if (trace->dir)
+		remove_tree(trace);
+}
+
+/*
+ * Setup controls for tracing.
+ */
+static struct trace_info *setup_controls(const char *root,
+					 const char *name, u32 flags)
+{
+	struct trace_info *trace = NULL;
+
+	trace = kzalloc(sizeof(*trace), GFP_KERNEL);
+	if (!trace)
+		goto err;
+
+	trace->dir = create_tree(trace, root, name);
+	if (!trace->dir)
+		goto err;
+
+	trace->state_file = debugfs_create_file("state", 0444, trace->dir,
+						trace, &state_fops);
+	if (!trace->state_file)
+		goto err;
+
+	if (!flags & TRACE_FLIGHT_CHANNEL) {
+		trace->dropped_file = debugfs_create_file("dropped", 0444,
+							  trace->dir, trace,
+							  &dropped_fops);
+		if (!trace->dropped_file)
+			goto err;
+	}
+
+	if (flags & TRACE_FLIGHT_CHANNEL) {
+		trace->reset_consumed_file = debugfs_create_file("rewind",
+								 0444, 
+								 trace->dir,
+								 trace,
+								 &reset_consumed_fops);
+		if (!trace->reset_consumed_file)
+			goto err;
+	}
+
+	trace->nr_sub_file = debugfs_create_file("nr_sub", 0444,
+						 trace->dir, trace,
+						 &nr_sub_fops);
+	if (!trace->nr_sub_file)
+		goto err;
+
+	trace->sub_size_file = debugfs_create_file("sub_size", 0444,
+						   trace->dir, trace,
+						   &sub_size_fops);
+	if (!trace->sub_size_file)
+		goto err;
+
+	return trace;
+err:
+	if (trace) {
+		remove_controls(trace);
+		kfree(trace);
+	}
+
+	return NULL;
+}
+
+
+static int trace_setup_channel(struct trace_info *trace, u32 buf_size,
+				u32 buf_nr, u32 flags)
+{
+	if (!buf_size || !buf_nr)
+		return -EINVAL;
+
+	if (flags & TRACE_GLOBAL_CHANNEL)
+		trace->rchan = relay_open("trace", trace->dir, buf_size,
+					  buf_nr, &relay_callbacks_global,
+					  trace);
+	else
+		trace->rchan = relay_open("trace", trace->dir, buf_size,
+					  buf_nr, &relay_callbacks, trace);
+	
+	if (!trace->rchan)
+		return -ENOMEM;
+
+	trace->flags = flags;
+	trace->state = TRACE_SETUP;
+
+	return 0;
+}
+
+
+/**
+ *	trace_setup: create a new trace trace handle
+ *
+ *	@root: The root directory name in the root of the debugfs
+ *	       to place trace directories. Created as needed.
+ *	@name: Trace directory name, created in @root
+ *	@buf_size: size of the relay sub-buffers
+ *	@buf_nr: number of relay sub-buffers
+ *	@flags: Option selection (see GTSC channel flags definitions)
+ *		default values when flags=0 are: use per-CPU buffering,
+ *		use non-overwrite mode. See Documentation/trace.txt for details.
+ *
+ *	returns a trace_info handle or NULL, if setup failed.
+ */
+struct trace_info *trace_setup(const char *root, const char *name,
+			       u32 buf_size, u32 buf_nr, u32 flags)
+{
+	struct trace_info *trace = NULL;
+
+	trace = setup_controls(root, name, flags);
+	if (!trace)
+		return NULL;
+
+	trace->buf_size = buf_size;
+	trace->buf_nr = buf_nr;
+	trace->flags = flags;
+	mutex_init(&trace->state_mutex);
+	trace->state = TRACE_SETUP;
+
+	return trace;
+}
+EXPORT_SYMBOL_GPL(trace_setup);
+
+
+/**
+ *	trace_start: start tracing
+ *
+ *	@trace: trace handle to start.
+ *
+ *	returns 0 if successful.
+ */
+int trace_start(struct trace_info *trace)
+{
+	/*
+	 * For starting a trace, we can transition from a setup or stopped
+	 * trace.
+	 */
+	if (trace->state == TRACE_RUNNING)
+		return -EINVAL;
+
+	mutex_lock(&trace->state_mutex);
+	if (trace->state == TRACE_SETUP) {
+		int ret;
+
+		ret = trace_setup_channel(trace, trace->buf_size,
+					  trace->buf_nr, trace->flags);
+		if (ret){
+			mutex_unlock(&trace->state_mutex);
+			return ret;
+		}
+	}
+
+	trace->state = TRACE_RUNNING;
+	mutex_unlock(&trace->state_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(trace_start);
+
+/**
+ *	trace_stop: stop tracing
+ *
+ *	@trace: trace handle to stop.
+ *
+ */
+int trace_stop(struct trace_info *trace)
+{
+	int ret = -EINVAL;
+
+	/*
+	 * For stopping a trace, the state must be running
+	 */
+	mutex_lock(&trace->state_mutex);
+	if (trace->state == TRACE_RUNNING) {
+		trace->state = TRACE_STOPPED;
+		/*
+		 * wait for all cpus to see the change in
+		 * state before continuing 
+		 */
+		synchronize_sched();
+		relay_flush(trace->rchan);
+		ret = 0;
+	}
+	mutex_unlock(&trace->state_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(trace_stop);
+
+/**
+ *	trace_cleanup_channel: destroys the trace channel only
+ *
+ *	@trace: trace handle to cleanup
+ */
+static void trace_cleanup_channel(struct trace_info *trace)
+{
+	trace_stop(trace);
+	if (trace->rchan)
+		relay_close(trace->rchan);
+	trace->rchan = NULL;
+}
+
+/**
+ *	trace_cleanup: destroys the trace channel, control files and dir
+ *
+ *	@trace: trace handle to cleanup
+ */
+void trace_cleanup(struct trace_info *trace)
+{
+	trace_cleanup_channel(trace);
+	remove_controls(trace);
+	kfree(trace);
+}
+EXPORT_SYMBOL_GPL(trace_cleanup);

--------------040002040107010203060601--

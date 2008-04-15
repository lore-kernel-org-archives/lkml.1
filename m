Return-Path: <linux-kernel-owner+w=401wt.eu-S1764250AbYDOL1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764250AbYDOL1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 07:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbYDOL1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 07:27:24 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:56743 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647AbYDOL1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:27:23 -0400
Date: Tue, 15 Apr 2008 16:56:03 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: dwilder@us.ibm.com, mathieu.desnoyers@polymtl.ca, hunt@redhat.com
Subject: [RFC Patch 1/1] debugfs_printk and debugfs_dump interface
Message-ID: <20080415112603.GA5770@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20080415111459.GB5295@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415111459.GB5295@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces two new interfaces called debugfs_printk and 
debugfs_dump which can be used to print to the debugfs mount directly.
It uses the 'trace' infrastructure underneath and is a patch over it.
A sample file is also created to demonstrate its ease of use.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 include/linux/trace.h          |   54 ++++++++++++
 lib/trace.c                    |  183 +++++++++++++++++++++++++++++++++++++++--
 samples/trace/Makefile         |    2 
 samples/trace/fork_new_trace.c |   98 +++++++++++++++++++++
 4 files changed, 331 insertions(+), 6 deletions(-)

Index: linux-2.6.25-rc8-mm1/include/linux/trace.h
===================================================================
--- linux-2.6.25-rc8-mm1.orig/include/linux/trace.h
+++ linux-2.6.25-rc8-mm1/include/linux/trace.h
@@ -39,10 +39,30 @@ enum trace_state {
 	TRACE_STOPPED,
 };
 
+enum trace_dir_state {
+	TRACE_PARENT_DIR_ABSENT,
+	TRACE_PARENT_DIR_EXISTS,
+	TRACE_DIR_EXISTS
+};
+
 #define TRACE_ROOT_NAME_SIZE	64	/* Max root dir identifier */
 #define TRACE_NAME_SIZE		64	/* Max trace identifier */
 
 /*
+ * Buffers for use by debugfs_printk
+ */
+#define DEFAULT_TRACE_BUF_SIZE 4096
+#define DEFAULT_TRACE_SUB_BUF_NR 40
+
+struct debugfs_printk_data {
+	char *parent_dir;
+	char *dir;
+	int exists;
+	int buf_size;
+	int sub_buf_size;
+};
+
+/*
  * Global root user information
  */
 struct trace_root {
@@ -73,6 +93,17 @@ struct trace_info {
 	unsigned int buf_nr;
 };
 
+/*
+ * Information about every trace directory
+ */
+struct trace_dir {
+	struct list_head trace_dir_list;
+	char trace_dir_name[TRACE_NAME_SIZE];
+	struct dentry *trace_root;
+	struct dentry *trace_dir;
+	struct trace_info *ti;
+};
+
 #ifdef CONFIG_TRACE
 static inline int trace_running(struct trace_info *trace)
 {
@@ -83,6 +114,12 @@ struct trace_info *trace_setup(const cha
 int trace_start(struct trace_info *trace);
 int trace_stop(struct trace_info *trace);
 void trace_cleanup(struct trace_info *trace);
+int trace_exists(const char *parent_dir, const char *dir,
+					struct trace_info **ti);
+void trace_cleanup_all(const char *parent_dir);
+int debugfs_printk(struct debugfs_printk_data *dpk, char *format, ...);
+int debugfs_dump(struct debugfs_printk_data *dpk, const void *output,
+							const int output_len);
 #else
 static inline struct trace_info *trace_setup(const char *root,
 					     const char *name, u32 buf_size,
@@ -94,6 +131,23 @@ static inline int trace_start(struct tra
 static inline int trace_stop(struct trace_info *trace) { return -EINVAL; }
 static inline int trace_running(struct trace_info *trace) { return 0; }
 static inline void trace_cleanup(struct trace_info *trace) {}
+static inline int trace_exists(const char *parent_dir, const char *dir,
+				struct trace_info **ti)
+{
+	return -EINVAL;
+}
+static inline void trace_cleanup_all(const char *parent_dir) {}
+static inline int debugfs_printk(struct debugfs_printk_data *dpk, char *format,
+				...)
+{
+	return -EINVAL;
+}
+int debugfs_dump(struct debugfs_printk_data *dpk, const void *output,
+							const int output_len)
+{
+	return -EINVAL;
+}
+
 #endif
 
 #endif
Index: linux-2.6.25-rc8-mm1/lib/trace.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/lib/trace.c
+++ linux-2.6.25-rc8-mm1/lib/trace.c
@@ -29,6 +29,7 @@
 #include <linux/trace.h>
 
 static LIST_HEAD(trace_roots);
+static LIST_HEAD(trace_dirs);
 static DEFINE_MUTEX(trace_mutex);
 
 static int state_open(struct inode *inode, struct file *filp)
@@ -99,9 +100,19 @@ static void remove_root(struct trace_inf
 
 static void remove_tree(struct trace_info *trace)
 {
+	struct list_head *pos, *temp;
+	struct trace_dir *dr = NULL;
+
 	mutex_lock(&trace_mutex);
 	debugfs_remove(trace->dir);
 
+	list_for_each_safe(pos, temp, &trace_dirs) {
+		dr = list_entry(pos, struct trace_dir, trace_dir_list);
+		if (dr->ti == trace) {
+			list_del(pos);
+			kfree(dr);
+		}
+	}
 	if (trace->root) {
 		if (--trace->root->users == 0)
 			remove_root(trace);
@@ -142,11 +153,16 @@ static struct trace_root *lookup_root(co
 static struct dentry *create_tree(struct trace_info *trace, const char *root,
 				  const char *name)
 {
-	struct dentry *dir = NULL;
+	struct trace_dir *temp;
 
 	if (root == NULL || name == NULL)
 		return ERR_PTR(-EINVAL);
 
+	temp = kzalloc(sizeof(struct trace_dir), GFP_KERNEL);
+	if (!temp)
+		return ERR_PTR(-ENOMEM);
+	strncpy(temp->trace_dir_name, name, strlen(name));
+
 	mutex_lock(&trace_mutex);
 
 	trace->root = lookup_root(root);
@@ -155,16 +171,49 @@ static struct dentry *create_tree(struct
 		goto err;
 	}
 
-	dir = debugfs_create_dir(name, trace->root->root);
-	if (IS_ERR(dir))
+	temp->trace_root = trace->root->root;
+	temp->trace_dir = debugfs_create_dir(name, trace->root->root);
+
+	if (IS_ERR(temp->trace_dir))
 		remove_root(trace);
-	else
+	else {
 		trace->root->users++;
+		temp->ti = trace;
+		list_add_tail(&temp->trace_dir_list, &trace_dirs);
+	}
 
 err:
 	mutex_unlock(&trace_mutex);
-	return dir;
+	return temp->trace_dir;
+}
+
+int trace_exists(const char *parent_dir, const char *dir,
+					struct trace_info **ti)
+{
+	struct list_head *pos;
+	struct trace_root *r;
+	struct trace_dir *temp;
+	int ret = TRACE_PARENT_DIR_ABSENT;
+
+	list_for_each(pos, &trace_roots) {
+		r = list_entry(pos, struct trace_root, list);
+		if (!strcmp(parent_dir, r->name))
+			goto search_dir;
+	}
+	return ret;
+
+ search_dir:
+	list_for_each(pos, &trace_dirs) {
+		temp = list_entry(pos, struct trace_dir, trace_dir_list);
+
+		if (!strcmp(dir, temp->trace_dir_name)) {
+			*ti = temp->ti;
+			return TRACE_DIR_EXISTS;
+		}
+	}
+	return TRACE_PARENT_DIR_EXISTS;
 }
+EXPORT_SYMBOL_GPL(trace_exists);
 
 static int dropped_open(struct inode *inode, struct file *filp)
 {
@@ -561,3 +610,127 @@ void trace_cleanup(struct trace_info *tr
 	kfree(trace);
 }
 EXPORT_SYMBOL_GPL(trace_cleanup);
+
+/**
+ *	trace_cleanup_all - Removes all trace_info/directories created under a
+ *			    parent_dir
+ *	@parent_dir: Name of the parent directory
+ */
+void trace_cleanup_all(const char *parent_dir)
+{
+	struct list_head *pos, *pos_temp;
+	struct trace_dir *temp;
+
+	list_for_each_safe(pos, pos_temp, &trace_dirs) {
+		temp = list_entry(pos, struct trace_dir, trace_dir_list);
+		if (!strcmp(parent_dir, temp->trace_root->d_iname))
+			trace_cleanup(temp->ti);
+	}
+}
+EXPORT_SYMBOL_GPL(trace_cleanup_all);
+
+/*
+ * Send formatted trace data to trace channel.
+ */
+static int trace_printf_(struct trace_info *trace, const char *format,
+								va_list ap)
+{
+	va_list aq;
+	char *record;
+	int len;
+	int ret = 0;
+
+	if (trace_running(trace)) {
+		va_copy(aq, ap);
+		len = vsnprintf(NULL, 0, format, aq);
+		va_end(aq);
+		record = relay_reserve(trace->rchan, ++len);
+		if (record)
+			ret = vsnprintf(record, len, format, ap);
+	}
+	return ret;
+}
+
+static inline struct trace_info *init_trace_interface(struct
+						debugfs_printk_data * dpk)
+{
+	struct trace_info *ti;
+
+	dpk->exists = trace_exists(dpk->parent_dir, dpk->dir, &ti);
+
+	switch (dpk->exists) {
+
+	case TRACE_PARENT_DIR_EXISTS:
+	case TRACE_PARENT_DIR_ABSENT:
+		if (!dpk->buf_size)
+			dpk->buf_size = DEFAULT_TRACE_BUF_SIZE;
+		if (!dpk->sub_buf_size)
+			dpk->sub_buf_size = DEFAULT_TRACE_SUB_BUF_NR;
+		ti = trace_setup(dpk->parent_dir, dpk->dir,
+			dpk->buf_size, dpk->sub_buf_size, TRACE_FLIGHT_CHANNEL);
+		printk(KERN_INFO "Trace interface %s setup\n",
+							ti->dir->d_iname);
+		if (IS_ERR(ti)) {
+			printk(KERN_ERR "Trace interface could not be "
+							"initialised\n");
+			return PTR_ERR(ti);
+		}
+		/* Fall through */
+	case TRACE_DIR_EXISTS:
+		if (ti->state != TRACE_RUNNING)
+			trace_start(ti);
+	}
+	return ti;
+}
+
+/*
+ * debugfs_printk - A function to write into the debugfs mount 'directly'
+ * using 'trace' infrastructure
+ * @dpk - Structure containing info such as parent_dir and directory
+ * @format - String containing format string specifiers
+ */
+int debugfs_printk(struct debugfs_printk_data *dpk, char *format, ...)
+{
+	int ret;
+	struct trace_info *ti;
+	va_list(ap);
+
+	va_start(ap, format);
+
+	ti = init_trace_interface(dpk);
+
+	/* Now do the actual printing */
+	rcu_read_lock();
+	ret = trace_printf_(ti, format, ap);
+	rcu_read_unlock();
+
+	va_end(ap);
+	return ret;
+}
+EXPORT_SYMBOL(debugfs_printk);
+
+/*
+ * @output - Data that needs to be output
+ * @output_len - Length of the output data
+ */
+int debugfs_dump(struct debugfs_printk_data *dpk, const void *output,
+							const int output_len)
+{
+	struct trace_info *ti;
+	char *record;
+	int ret = 0;
+
+	ti = init_trace_interface(dpk);
+
+	/* Now do the actual printing */
+	rcu_read_lock();
+	record = relay_reserve(ti->rchan, output_len);
+	if (record)
+		memcpy(record, output, output_len);
+	else
+		ret = -ENOMEM;
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL(debugfs_dump);
Index: linux-2.6.25-rc8-mm1/samples/trace/fork_new_trace.c
===================================================================
--- /dev/null
+++ linux-2.6.25-rc8-mm1/samples/trace/fork_new_trace.c
@@ -0,0 +1,98 @@
+/*
+ * An example of using trace in a kprobes module
+ *
+ * Copyright (C) 2008 IBM Inc.
+ *
+ * K.Prasad <prasad@linux.vnet.ibm.com>
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
+ * $ insmod fork_new_trace.ko
+ *
+ * To view the data produced by the module:
+ * $ cat /debug/trace_new_example/do_fork/trace0
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+#include <linux/trace.h>
+
+#define SAMPLE_PARENT_DIR "trace_new_example"
+#define PROBE_POINT "do_fork"
+
+static struct kprobe kp;
+static struct debugfs_printk_data *dpk;
+
+static int handler_pre(struct kprobe *p, struct pt_regs *regs)
+{
+	debugfs_printk(dpk, "%d\n", current->pid);
+	return 0;
+}
+
+int init_module(void)
+{
+	int ret = 0;
+	int len_parent_dir, len_dir;
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
+
+	len_parent_dir = strlen(SAMPLE_PARENT_DIR) + 1;
+	/* Initialising len_dir to the larger of the two dir names */
+	len_dir = strlen("kprobe_struct") + 1;
+
+	dpk = kzalloc(sizeof(*dpk), GFP_KERNEL);
+	if (!dpk)
+		ret = 1;
+
+	dpk->parent_dir = SAMPLE_PARENT_DIR;
+
+	/* Let's do a binary dump of struct kprobe using debugfs_dump */
+	dpk->dir = "kprobes_struct";
+	debugfs_dump(dpk, &kp, sizeof(kp));
+
+	/* Now change the directory to collect fork pid data */
+	dpk->dir = PROBE_POINT;
+
+	if (ret)
+		printk(KERN_ERR "Unable to find required free memory. "
+				"Trace new sample module loading aborted");
+	return ret;
+}
+
+void cleanup_module(void)
+{
+	unregister_kprobe(&kp);
+
+	/* Just a single cleanup call passing the parent dir string */
+	trace_cleanup_all(SAMPLE_PARENT_DIR);
+}
+MODULE_LICENSE("GPL");
Index: linux-2.6.25-rc8-mm1/samples/trace/Makefile
===================================================================
--- linux-2.6.25-rc8-mm1.orig/samples/trace/Makefile
+++ linux-2.6.25-rc8-mm1/samples/trace/Makefile
@@ -1,4 +1,4 @@
 # builds the trace example kernel modules;
 # then to use (as root):  insmod <fork_trace.ko>
 
-obj-$(CONFIG_SAMPLE_TRACE) := fork_trace.o
+obj-$(CONFIG_SAMPLE_TRACE) := fork_trace.o fork_new_trace.o

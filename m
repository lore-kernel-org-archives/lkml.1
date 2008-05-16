Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYEPRFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYEPRFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYEPRFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:05:06 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:46409 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYEPRFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:05:03 -0400
Date: Fri, 16 May 2008 22:34:29 +0530
To: "kernel list" <linux-kernel@vger.kernel.org>
Subject: [RFC Patch 1/1] trace_printk and trace_dump interface - v2
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
Organization: IBM
Cc: dwilder@us.ibm.com, akpm@linux-foundation.org,
       "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.ua9axd2a03j166@prasadkr_t60p.in.ibm.com>
Content-Transfer-Encoding: 8BIT
Message-ID: <op.ua9a1r0y03j166@prasadkr_t60p.in.ibm.com>
In-Reply-To: <op.ua9axd2a03j166@prasadkr_t60p.in.ibm.com>
User-Agent: Opera Mail/9.26 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces two new interfaces called trace_printk and
trace_dump which can be used to print to the debugfs mount directly.
It uses the 'trace' infrastructure underneath and is a patch over it.
A sample file is also created to demonstrate its ease of use.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
  Documentation/trace.txt        |   22 ++++
  include/linux/trace.h          |   57 +++++++++++
  lib/trace.c                    |  204  
+++++++++++++++++++++++++++++++++++++++--
  samples/trace/Makefile         |    2
  samples/trace/fork_new_trace.c |   99 +++++++++++++++++++
  5 files changed, 378 insertions(+), 6 deletions(-)

Index: linux-blktrace-many/include/linux/trace.h
===================================================================
--- linux-blktrace-many.orig/include/linux/trace.h
+++ linux-blktrace-many/include/linux/trace.h
@@ -39,10 +39,22 @@ enum trace_state {
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
+ * Buffers for use by trace_printk
+ */
+#define DEFAULT_TRACE_BUF_SIZE 4096
+#define DEFAULT_TRACE_SUB_BUF_NR 40
+
+/*
   * Global root user information
   */
  struct trace_root {
@@ -71,6 +83,28 @@ struct trace_info {
  	unsigned int flags;
  	unsigned int buf_size;
  	unsigned int buf_nr;
+	spinlock_t trace_lock;
+};
+
+struct trace_printk_data {
+	char *parent_dir;
+	char *dir;
+	int exists;
+	int buf_size;
+	int sub_buf_size;
+	unsigned long flags;
+	struct trace_info *ti;
+};
+
+/*
+ * Information about every trace directory
+ */
+struct trace_dir {
+	struct list_head trace_dir_list;
+	char trace_dir_name[TRACE_NAME_SIZE];
+	struct dentry *trace_root;
+	struct dentry *trace_dir;
+	struct trace_info *ti;
  };

  #ifdef CONFIG_TRACE
@@ -83,6 +117,12 @@ struct trace_info *trace_setup(const cha
  int trace_start(struct trace_info *trace);
  int trace_stop(struct trace_info *trace);
  void trace_cleanup(struct trace_info *trace);
+int trace_exists(const char *parent_dir, const char *dir,
+					struct trace_info **ti);
+void trace_cleanup_all(const char *parent_dir);
+int trace_printk(struct trace_printk_data *dpk, char *format, ...);
+int trace_dump(struct trace_printk_data *dpk, const void *output,
+							const int output_len);
  #else
  static inline struct trace_info *trace_setup(const char *root,
  					     const char *name, u32 buf_size,
@@ -94,6 +134,23 @@ static inline int trace_start(struct tra
  static inline int trace_stop(struct trace_info *trace) { return -EINVAL; }
  static inline int trace_running(struct trace_info *trace) { return 0; }
  static inline void trace_cleanup(struct trace_info *trace) {}
+static inline int trace_exists(const char *parent_dir, const char *dir,
+				struct trace_info **ti)
+{
+	return -EINVAL;
+}
+static inline void trace_cleanup_all(const char *parent_dir) {}
+static inline int trace_printk(struct trace_printk_data *dpk, char  
*format,
+				...)
+{
+	return -EINVAL;
+}
+int trace_dump(struct trace_printk_data *dpk, const void *output,
+							const int output_len)
+{
+	return -EINVAL;
+}
+
  #endif

  #endif
Index: linux-blktrace-many/lib/trace.c
===================================================================
--- linux-blktrace-many.orig/lib/trace.c
+++ linux-blktrace-many/lib/trace.c
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
+ 			kfree(dr);
+		}
+	}
  	if (trace->root) {
  		if (--trace->root->users == 0)
  			remove_root(trace);
@@ -142,11 +153,17 @@ static struct trace_root *lookup_root(co
  static struct dentry *create_tree(struct trace_info *trace, const char  
*root,
  				  const char *name)
  {
-	struct dentry *dir = NULL;
+	struct trace_dir *temp;

  	if (root == NULL || name == NULL)
  		return ERR_PTR(-EINVAL);

+	temp = kzalloc(sizeof(struct trace_dir), GFP_KERNEL);
+	if ((temp == NULL) || (strlen(name) > TRACE_NAME_SIZE))
+		return ERR_PTR(-ENOMEM);
+
+	strlcpy(temp->trace_dir_name, name, sizeof(temp->trace_dir_name));
+
  	mutex_lock(&trace_mutex);

  	trace->root = lookup_root(root);
@@ -155,17 +172,49 @@ static struct dentry *create_tree(struct
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
  }

+int trace_exists(const char *parent_dir, const char *dir,
+					struct trace_info **ti)
+{
+	struct list_head *pos;
+	struct trace_root *r;
+	struct trace_dir *temp;
+
+	list_for_each(pos, &trace_roots) {
+		r = list_entry(pos, struct trace_root, list);
+		if (!strcmp(parent_dir, r->name))
+			goto search_dir;
+	}
+	return TRACE_PARENT_DIR_ABSENT;
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
+}
+EXPORT_SYMBOL_GPL(trace_exists);
+
  static int dropped_open(struct inode *inode, struct file *filp)
  {
  	filp->private_data = inode->i_private;
@@ -561,3 +610,148 @@ void trace_cleanup(struct trace_info *tr
  	kfree(trace);
  }
  EXPORT_SYMBOL_GPL(trace_cleanup);
+
+/**
+ *	trace_cleanup_all - Removes all trace directories under a parent_dir
+ *	@parent_dir: Name of the parent directory
+ */
+void trace_cleanup_all(const char *parent_dir)
+{
+	struct list_head *pos, *pos_temp;
+	struct trace_dir *temp;
+
+	list_for_each_safe(pos, pos_temp, &trace_dirs) {
+		temp = list_entry(pos, struct trace_dir, trace_dir_list);
+		if (!strncmp(parent_dir, temp->trace_root->d_iname, strlen(parent_dir)))
+			trace_cleanup(temp->ti);
+	}
+}
+EXPORT_SYMBOL_GPL(trace_cleanup_all);
+
+/*
+ * Send formatted trace data to trace channel.
+ */
+static int trace_printf(struct trace_info *trace, const char *format,
+								va_list ap)
+{
+	va_list aq;
+	char *record;
+	int len, ret = 0;
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
+static inline int init_trace_interface(struct trace_printk_data *tpk)
+{
+	int ret = 0;
+	tpk->exists = trace_exists(tpk->parent_dir, tpk->dir, &tpk->ti);
+
+	switch(tpk->exists) {
+
+	case TRACE_PARENT_DIR_EXISTS:
+	case TRACE_PARENT_DIR_ABSENT:
+		if(!tpk->buf_size)
+			tpk->buf_size = DEFAULT_TRACE_BUF_SIZE;
+		if(!tpk->sub_buf_size)
+			tpk->sub_buf_size = DEFAULT_TRACE_SUB_BUF_NR;
+		tpk->ti = trace_setup(tpk->parent_dir, tpk->dir,
+				tpk->buf_size, tpk->sub_buf_size, tpk->flags);
+		printk(KERN_INFO "Trace interface %s setup\n",
+							tpk->ti->dir->d_iname);
+		if (IS_ERR(tpk->ti)) {
+			printk(KERN_ERR "Error initialising %s interface\n",
+							tpk->ti->dir->d_iname);
+			return -EPERM;
+		}
+	/* Fall through */
+	case TRACE_DIR_EXISTS:
+		if (tpk->ti->state == TRACE_SETUP)
+			ret = trace_start(tpk->ti);
+		else
+			ret = -EPERM;
+	}
+
+	return 0;
+}
+
+/**
+ * trace_printk - Output a string to debugfs mount 'directly' using  
'trace'
+ * @tpk: Structure containing info such as parent_dir and directory
+ * @format: String containing format string specifiers
+ * @ap: List of arguments
+ */
+int trace_printk(struct trace_printk_data *tpk, char *format, ...)
+{
+	int ret = 0;
+	va_list(ap);
+	unsigned long flags = 0;
+
+	va_start(ap, format);
+
+	ret = init_trace_interface(tpk);
+	if (unlikely(ret))
+		return ret;
+
+	/* Now do the actual printing */
+	/* Take an RCU Lock over the trace_info state */
+	rcu_read_lock();
+	/* Take a spinlock for the global buffer used by relay */
+	if (tpk->flags & TRACE_GLOBAL_CHANNEL)
+		spin_lock_irqsave(&tpk->ti->trace_lock, flags);
+	ret = trace_printf(tpk->ti, format, ap);
+	if (tpk->flags & TRACE_GLOBAL_CHANNEL)
+		spin_unlock_irqrestore(&tpk->ti->trace_lock, flags);
+	rcu_read_unlock();
+
+	va_end(ap);
+	return ret;
+}
+EXPORT_SYMBOL(trace_printk);
+
+/**
+ * trace_dump - Output binary into debugfs mount 'directly' using 'trace'
+ * @tpk: Structure containing info such as parent_dir and directory
+ * @output: Data that needs to be output
+ * @output_len: Length of the output data
+ */
+int trace_dump(struct trace_printk_data *tpk, const void *output,
+							const int output_len)
+{
+	char *record;
+	unsigned long flags = 0;
+	int ret = 0;
+
+	ret = init_trace_interface(tpk);
+	if (unlikely(ret))
+		return ret;
+
+	/* Now do the actual printing */
+	rcu_read_lock();
+	/* Take a spinlock for the global buffer used by relay */
+	if (tpk->flags & TRACE_GLOBAL_CHANNEL)
+		spin_lock_irqsave(&tpk->ti->trace_lock, flags);
+	record = relay_reserve(tpk->ti->rchan, output_len);
+
+	if (record && trace_running(tpk->ti))
+		memcpy(record, output, output_len);
+	else {
+		if(record)
+			ret = -EPERM;
+		else
+			ret = -ENOMEM;
+	}
+	if (tpk->flags & TRACE_GLOBAL_CHANNEL)
+		spin_unlock_irqrestore(&tpk->ti->trace_lock, flags);
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL(trace_dump);
Index: linux-blktrace-many/samples/trace/fork_new_trace.c
===================================================================
--- /dev/null
+++ linux-blktrace-many/samples/trace/fork_new_trace.c
@@ -0,0 +1,99 @@
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
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301   
USA
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
+ * $ cat /debug/trace_example/do_fork/trace0
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
+static struct trace_printk_data *tpk;
+
+static int handler_pre(struct kprobe *p, struct pt_regs *regs)
+{
+	trace_printk(tpk, "%d\n", current->pid);
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
+	tpk = kzalloc(sizeof(*tpk), GFP_KERNEL);
+	if(!tpk)
+		ret = 1;
+
+	tpk->parent_dir = SAMPLE_PARENT_DIR;
+
+	/* Let's do a binary dump of struct kprobe using trace_dump */
+	tpk->dir = "kprobes_struct";
+	tpk->flags = TRACE_GLOBAL_CHANNEL;
+	trace_dump(tpk, &kp, sizeof(kp));
+
+	/* Now change the directory to collect fork pid data */
+	tpk->dir = PROBE_POINT;
+
+	if(ret)
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
Index: linux-blktrace-many/samples/trace/Makefile
===================================================================
--- linux-blktrace-many.orig/samples/trace/Makefile
+++ linux-blktrace-many/samples/trace/Makefile
@@ -1,4 +1,4 @@
  # builds the trace example kernel modules;
  # then to use (as root):  insmod <fork_trace.ko>

-obj-$(CONFIG_SAMPLE_TRACE) := fork_trace.o
+obj-$(CONFIG_SAMPLE_TRACE) := fork_trace.o fork_new_trace.o
Index: linux-blktrace-many/Documentation/trace.txt
===================================================================
--- linux-blktrace-many.orig/Documentation/trace.txt
+++ linux-blktrace-many/Documentation/trace.txt
@@ -150,6 +150,28 @@ The steps a kernel data provider takes t
  5) Destroy the trace channel and underlying relay channel -
     trace_cleanup().

+Alternatively the user may choose to make use of two new interfaces --
+trace_printk() and trace_dump() -- to setup trace interface and
+trace_cleanup_all() to tear-down the same.
+
+Steps to use:
+1) Create and populate an instance of trace_printk_data structure. The  
fields
+   parent_dir and dir are mandatory. The fields buf_size, sub_buf_size  
and flags
+   are optional and will take default values if not populated. The field
+   'exists' and ti are for the trace infrastructure to use. The pointer  
to the
+   'struct trace_info' i.e. ti may be used to perform fine granular  
operations
+   such as determine the state of the 'trace', stop individual traces,  
etc.
+2) Default values for buf_size and sub_buf_size are 4096, 40 respectively.
+3) Use trace_dump() to output binary data which may be acted upon by a
+   high-level program (say dumping a structure). trace_printk() can be  
used
+   for string output. Pass a pointer to the instance of trace_printk_data
+   structure to these functions along with other parameters. The output  
from
+   these functions can be found at
+   <debugfs_mount>/<parent_dir>/<dir>/trace<0..n>.
+4) trace_cleanup_all() for a given parent directory will cleanup and  
remove all
+   trace directories created under the specified directory.
+5) Sample code for the same can be found in samples/trace/fork_new_trace.c
+
  Kernel Configuration
  --------------------
  To use trace, configure your kernel with CONFIG_TRACE=y. Trace depends on

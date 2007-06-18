Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbXFRE55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbXFRE55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 00:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbXFRE5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 00:57:35 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:44553 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbXFRE5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 00:57:33 -0400
Message-ID: <4676108B.9030203@us.ibm.com>
Date: Sun, 17 Jun 2007 21:56:43 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0.7 (X11/20050923)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: systemtap@sources.redhat.com
Subject: [RFC] Generic Trace Setup and Control (GTSC) kernel API (2/3)
Content-Type: multipart/mixed;
 boundary="------------050007080004070807090903"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050007080004070807090903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


-- 
David Wilder
IBM Linux Technology Center
Beaverton, Oregon, USA 
dwilder@us.ibm.com
(503)578-3789


--------------050007080004070807090903
Content-Type: text/x-patch;
 name="gtsc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gtsc.patch"

This patch introduces the Generic Trace Setup and Control (GTSC) API.
In the kernel, GTSC provides a simple API for starting and managing
data channels to user space.  GTSC builds on the relay interface.
The documentation for the GTSC is provided in a separate patch.

Signed-off-by: David Wilder <dwilder@us.ibm.com>

 include/linux/gtsc.h |  124 ++++++++++++++++
 lib/Kconfig          |    9 ++
 lib/Makefile         |    2 +
 lib/gtsc.c           |  385 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 520 insertions(+), 0 deletions(-)

diff --git a/include/linux/gtsc.h b/include/linux/gtsc.h
new file mode 100644
index 0000000..224aa16
--- /dev/null
+++ b/include/linux/gtsc.h
@@ -0,0 +1,124 @@
+/*
+ * gtsc.h - GTSC defines and function prototypes
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
+#ifndef _LINUX_GTSC_H
+#define _LINUX_GTSC_H
+
+#include <linux/relay.h>
+
+/*
+ * GTSC channel flags
+ */
+#define GTSC_GLOBAL	0x01
+#define GTSC_FLIGHT	0x02
+
+enum {
+	Gtsc_trace_setup = 1,
+	Gtsc_trace_running,
+	Gtsc_trace_stopped,
+};
+
+#define GTSC_TRACE_ROOT_NAME_SIZE	64	/* Max root dir identifier */
+#define GTSC_TRACE_NAME_SIZE		64	/* Max trace identifier */
+
+/*
+ * Global root user information
+ */
+struct gtsc_root {
+	struct list_head list;
+	char gtsc_name[GTSC_TRACE_ROOT_NAME_SIZE];
+	struct dentry *gtsc_root;
+	unsigned int gtsc_users;
+};
+
+/*
+ * Client information
+ */
+struct gtsc_trace {
+	int trace_state;
+	struct dentry *state_file;
+	struct rchan *rchan;
+	struct dentry *dir;
+	struct dentry *dropped_file;
+	atomic_t dropped;
+	struct gtsc_root *root;
+	void *private_data;
+	unsigned int flags;
+	unsigned int buf_size;
+	unsigned int buf_nr;
+};
+
+static inline int gtsc_trace_running(struct gtsc_trace *gtsc)
+{
+	return gtsc->trace_state == Gtsc_trace_running;
+}
+
+#if defined(CONFIG_GTSC)
+
+/**
+ *	gtsc_trace_setup: create a new gtsc trace handle
+ *
+ *	@root: The root directory name in the root of the debugfs
+ *	       to place trace directories. Created as needed.
+ *	@name: Trace directory name, created in @root
+ *	@buf_size: size of the relay sub-buffers
+ *	@buf_nr: number of relay sub-buffers
+ *	@flags: Option selection (see GTSC channel flags definitions)
+ *		default values when flags=0 are: use per-CPU buffering,
+ *		use non-overwrite mode. See Documentation/gtsc.txt for details.
+ *
+ *	returns a gtsc_trace handle or NULL, if setup failed.
+ */
+extern struct gtsc_trace *gtsc_trace_setup(char *root, char *name, u32 buf_size,
+					 u32 buf_nr, u32 flags);
+
+/**
+ *	gtsc_trace_startstop: start or stop tracing.
+ *
+ *	@gtsc: gtsc trace handle to start or stop.
+ *	@start: set to 1 to start tracing set to 0 to stop.
+ *
+ *	returns 0 if successful.
+ */
+extern int gtsc_trace_startstop(struct gtsc_trace *gtsc, int start);
+
+/**
+ *	gtsc_trace_cleanup: destroys the gtsc channel.
+ *
+ *	@gtsc: gtsc trace handle to cleanup
+ */
+extern void gtsc_trace_cleanup(struct gtsc_trace *gtsc);
+
+/**
+ *	gtsc_timestamp: returns a time stamp.
+ */
+extern unsigned long long  gtsc_timestamp(void);
+
+#else /* !CONFIG_GTSC */
+#define gtsc_trace_setup(root, name, buf_size, buf_nr, flags)	(NULL)
+#define gtsc_trace_startstop(gtsc, start)	(-EINVAL)
+#define gtsc_trace_cleanup(gtsc)		do { } while (0)
+#define gtsc_timestamp(void) 			(unsigned long long) (0)
+#endif /* CONFIG_GTSC */
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 2e7ae6b..d6e048f 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -124,4 +124,13 @@ config HAS_DMA
 	depends on !NO_DMA
 	default y
 
+config GTSC
+	bool "Generic Trace Setup and Control"
+	select RELAY
+	select DEBUG_FS
+	help
+	This option enables support for the GTSC. 
+
+	If unsure, say N.
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index c8c8e20..dcbdb5e 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -62,6 +62,8 @@ obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
+obj-$(CONFIG_GTSC) += gtsc.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/gtsc.c b/lib/gtsc.c
new file mode 100644
index 0000000..c376006
--- /dev/null
+++ b/lib/gtsc.c
@@ -0,0 +1,385 @@
+/*
+ * Based on blktrace code, Copyright (C) 2006 Jens Axboe <axboe@suse.de>
+ * Moved to utt.c by Tom Zanussi <zanussi@us.ibm.com>, 2006
+ * Additional contributions by:
+ * Martin Hunt <hunt@redhat.com>, 2007
+ * David Wilder <dwilder@us.ibm.com>, 2007
+ * Renamed to gtsc <dwilder.ibm.com>, 2007
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
+#include <linux/gtsc.h>
+
+static LIST_HEAD(gtsc_roots);
+static DEFINE_MUTEX(gtsc_mutex);
+
+static int gtsc_state_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t gtsc_state_read(struct file *filp, char __user *buffer,
+                               size_t count, loff_t *ppos)
+{
+	struct gtsc_trace *gtsc = filp->private_data;
+	char *buf = "trace not started\n";
+
+	if (gtsc->trace_state == Gtsc_trace_stopped)
+		buf = "stopped\n";
+	else if (gtsc->trace_state == Gtsc_trace_running)
+		buf = "running\n";
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+
+static ssize_t gtsc_state_write(struct file *filp, const char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	struct gtsc_trace *gtsc = filp->private_data;
+	char buf[16];
+	int ret;
+
+	memset(buf, 0, sizeof(buf));
+
+	if (count > sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(buf, buffer, count))
+		return -EFAULT;
+
+	if (strncmp(buf, "start", strlen("start")) == 0 ) {
+		ret = gtsc_trace_startstop(gtsc, 1);
+		if (ret)
+			return ret;
+	} else if (strncmp(buffer, "stop", strlen("stop")) == 0) {
+		ret = gtsc_trace_startstop(gtsc, 0);
+		if (ret)
+			return ret;
+	} else
+		return -EINVAL;
+
+	return count;
+}
+
+
+static struct file_operations gtsc_state_fops = {
+	.owner =	THIS_MODULE,
+	.open =		gtsc_state_open,
+	.read =		gtsc_state_read,
+	.write =	gtsc_state_write,
+};
+
+
+static void gtsc_remove_root(struct gtsc_trace *gtsc)
+{
+	if (gtsc->root->gtsc_root && simple_empty(gtsc->root->gtsc_root)) {
+		debugfs_remove(gtsc->root->gtsc_root);
+		list_del(&gtsc->root->list);
+		kfree(gtsc->root);
+		gtsc->root = NULL;
+	}
+}
+
+
+static void gtsc_remove_tree(struct gtsc_trace *gtsc)
+{
+	mutex_lock(&gtsc_mutex);
+
+	debugfs_remove(gtsc->dir);
+
+	if (--gtsc->root->gtsc_users == 0)
+		gtsc_remove_root(gtsc);
+
+	mutex_unlock(&gtsc_mutex);
+}
+
+
+static struct gtsc_root *gtsc_lookup_root(const char *root)
+{
+	struct list_head *pos;
+	struct gtsc_root *r;
+
+	list_for_each(pos, &gtsc_roots) {
+		r = list_entry(pos, struct gtsc_root, list);
+		if (!strcmp(r->gtsc_name, root))
+			return r;
+	}
+
+	r = kzalloc(sizeof(struct gtsc_root), GFP_KERNEL);
+	if (!r)
+		return NULL;
+
+	strlcpy(r->gtsc_name, root, sizeof(r->gtsc_name));
+
+	r->gtsc_root = debugfs_create_dir(root, NULL);
+	if (r->gtsc_root)
+		list_add(&r->list, &gtsc_roots);
+
+	return r;
+}
+
+
+static struct dentry *gtsc_create_tree(struct gtsc_trace *gtsc,
+				       const char *root,
+				       const char *name)
+{
+	struct dentry *dir = NULL;
+
+	if (root == NULL || name == NULL)
+		return NULL;
+	
+	mutex_lock(&gtsc_mutex);
+
+	gtsc->root = gtsc_lookup_root(root);
+	if (!gtsc->root)
+		goto err;
+
+	dir = debugfs_create_dir(name, gtsc->root->gtsc_root);
+	if (dir)
+		gtsc->root->gtsc_users++;
+	else
+		gtsc_remove_root(gtsc);
+
+err:
+	mutex_unlock(&gtsc_mutex);
+	return dir;
+}
+
+
+static int gtsc_dropped_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+	return 0;
+}
+
+
+static ssize_t gtsc_dropped_read(struct file *filp, char __user *buffer,
+				 size_t count, loff_t *ppos)
+{
+	struct gtsc_trace *gtsc = filp->private_data;
+	char buf[16];
+
+	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&gtsc->dropped));
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+
+static struct file_operations gtsc_dropped_fops = {
+	.owner =	THIS_MODULE,
+	.open =		gtsc_dropped_open,
+	.read =		gtsc_dropped_read,
+};
+
+
+/*
+ * Keep track of how many times we encountered a full subbuffer, to aid
+ * the user space app in telling how many lost events there were.
+ */
+static int gtsc_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
+				      void *prev_subbuf, size_t prev_padding)
+{
+	struct gtsc_trace *gtsc = buf->chan->private_data;
+	
+	if (gtsc->flags & GTSC_FLIGHT)
+		return 1;
+	
+	if (!relay_buf_full(buf))
+		return 1;
+
+	atomic_inc(&gtsc->dropped);
+	return 0;
+}
+
+
+static int gtsc_remove_buf_file_callback(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+	return 0;
+}
+
+
+static struct dentry *gtsc_create_buf_file_callback(const char *filename,
+						   struct dentry *parent,
+						   int mode,
+						   struct rchan_buf *buf,
+						   int *is_global)
+{
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+
+static struct dentry *gtsc_create_global_buf_file_callback(const char *filename,
+							  struct dentry *parent,
+							  int mode,
+							  struct rchan_buf *buf,
+							  int *is_global)
+{
+	*is_global = 1;
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+
+static struct rchan_callbacks gtsc_relay_callbacks = {
+	.subbuf_start		= gtsc_subbuf_start_callback,
+	.create_buf_file	= gtsc_create_buf_file_callback,
+	.remove_buf_file	= gtsc_remove_buf_file_callback,
+};
+static struct rchan_callbacks gtsc_relay_callbacks_global = {
+	.subbuf_start		= gtsc_subbuf_start_callback,
+	.create_buf_file	= gtsc_create_global_buf_file_callback,
+	.remove_buf_file	= gtsc_remove_buf_file_callback,
+};
+
+
+void gtsc_trace_remove_controls(struct gtsc_trace *gtsc)
+{
+	if (gtsc->state_file)
+		debugfs_remove(gtsc->state_file);
+	if (gtsc->dropped_file)
+		debugfs_remove(gtsc->dropped_file);
+	if (gtsc->dir)
+		gtsc_remove_tree(gtsc);
+}
+
+/*
+ * Setup controls for tracing.
+ */
+struct gtsc_trace *gtsc_trace_setup_controls(char *root, char *name)
+{
+	struct gtsc_trace *gtsc = NULL;
+
+	gtsc = kzalloc(sizeof(*gtsc), GFP_KERNEL);
+	if (!gtsc)
+		goto err;
+
+	gtsc->dir = gtsc_create_tree(gtsc, root, name);
+	if (!gtsc->dir)
+		goto err;
+
+	gtsc->state_file = debugfs_create_file("state", 0444, gtsc->dir, gtsc,
+					       &gtsc_state_fops);
+	if (!gtsc->state_file)
+		goto err;
+
+	gtsc->dropped_file = debugfs_create_file("dropped", 0444, gtsc->dir,
+						 gtsc, &gtsc_dropped_fops);
+	if (!gtsc->dropped_file)
+		goto err;
+
+	return gtsc;
+err:
+	if (gtsc) {
+		gtsc_trace_remove_controls(gtsc);
+		kfree(gtsc);
+	}
+
+	return NULL;
+}
+
+
+int gtsc_trace_setup_channel(struct gtsc_trace *gtsc, u32 buf_size, u32 buf_nr,
+			     u32 flags)
+{
+	if (!buf_size || !buf_nr)
+		return -EINVAL;
+
+	if (flags & GTSC_GLOBAL)
+		gtsc->rchan = relay_open("trace", gtsc->dir, buf_size, buf_nr,
+					 &gtsc_relay_callbacks_global, gtsc);
+	else
+		gtsc->rchan = relay_open("trace", gtsc->dir, buf_size, buf_nr,
+					 &gtsc_relay_callbacks, gtsc);
+
+	if (!gtsc->rchan)
+		return -ENOMEM;
+
+	gtsc->flags = flags;
+	gtsc->trace_state = Gtsc_trace_setup;
+
+	return 0;
+}
+
+
+struct gtsc_trace *gtsc_trace_setup(char *root, char *name, u32 buf_size,
+				    u32 buf_nr, u32 flags)
+{
+	struct gtsc_trace *gtsc = NULL;
+
+	gtsc = gtsc_trace_setup_controls(root, name);
+	if (!gtsc)
+		return NULL;
+
+	gtsc->buf_size = buf_size;
+	gtsc->buf_nr = buf_nr;
+	gtsc->flags = flags;
+	gtsc->trace_state = Gtsc_trace_setup;
+
+	return gtsc;
+}
+EXPORT_SYMBOL_GPL(gtsc_trace_setup);
+
+
+int gtsc_trace_startstop(struct gtsc_trace *gtsc, int start)
+{
+	int ret = -EINVAL;
+	/*
+	 * For starting a trace, we can transition from a setup or stopped
+	 * trace. For stopping a trace, the state must be running
+	 */
+	if (start) {
+		if (gtsc->trace_state == Gtsc_trace_setup) {
+			ret = gtsc_trace_setup_channel(gtsc, gtsc->buf_size,
+						       gtsc->buf_nr,
+						       gtsc->flags);
+			if (ret)
+				return ret;
+		}
+		gtsc->trace_state = Gtsc_trace_running;
+	} else {
+		if (gtsc->trace_state == Gtsc_trace_running) {
+			gtsc->trace_state = Gtsc_trace_stopped;
+			relay_flush(gtsc->rchan);
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gtsc_trace_startstop);
+
+
+void gtsc_trace_cleanup(struct gtsc_trace *gtsc)
+{
+	if (gtsc->rchan)
+		relay_close(gtsc->rchan);
+	gtsc_trace_remove_controls(gtsc);
+	kfree(gtsc);
+}
+EXPORT_SYMBOL_GPL(gtsc_trace_cleanup);
+
+unsigned long long gtsc_timestamp(void)
+{
+	return sched_clock();
+}
+EXPORT_SYMBOL_GPL(gtsc_timestamp);

--------------050007080004070807090903--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYJOCdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYJOCdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 22:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYJOCdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 22:33:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51749 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbYJOCdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 22:33:37 -0400
From: "Takashi NISHIIE" <t-nishiie@np.css.fujitsu.com>
To: <ltt-dev@lists.casi.polymtl.ca>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] Lists all registered markers/tracepoints on the system
Date: Wed, 15 Oct 2008 11:33:31 +0900
Message-ID: <014001c92e6e$69f84b90$3de8e2b0$@css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AckubmNIk+um6uTQRmKWjtjKQzP/bg==
Content-Language: ja
x-cr-hashedpuzzle: BYVt BsIo CD// Ca57 DZCG Ek+e F6Gw JHb6 Jk5W KGcU PZGP PqHC QUvP Urc+ ViIL VjK7;2;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAdAB0AC0AZABlAHYAQABsAGkAcwB0AHMALgBjAGEAcwBpAC4AcABvAGwAeQBtAHQAbAAuAGMAYQA=;Sosha1_v1;7;{F919A534-6F00-4437-B141-95B220721E23};dAAtAG4AaQBzAGgAaQBpAGUAQABuAHAALgBjAHMAcwAuAGYAdQBqAGkAdABzAHUALgBjAG8AbQA=;Wed, 15 Oct 2008 02:33:20 GMT;WwBQAEEAVABDAEgAXQAgAEwAaQBzAHQAcwAgAGEAbABsACAAcgBlAGcAaQBzAHQAZQByAGUAZAAgAG0AYQByAGsAZQByAHMALwB0AHIAYQBjAGUAcABvAGkAbgB0AHMAIABvAG4AIAB0AGgAZQAgAHMAeQBzAHQAZQBtAA==
x-cr-puzzleid: {F919A534-6F00-4437-B141-95B220721E23}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

 I propose the marker/tracepoint debugfs interface. (like kprobe
debugfs interface style.)
 The list of registered marker/tracepoint is visible under the 
/debug/markers/ directory and /debug/tracepoint/ directory 
(assuming debugfs is mounted at /debug).

/debug/markers/list: Lists all registered markers on the system

# cat /debug/markers/list
core_marker_id : (c05060bc,f6b993a0)
core_marker_format : (c05060bc,f6b993bc)

/debug/tracepoint/list: Lists all registered markers on the system

# cat /debug/tracepoint/list
ipc_sem_create:TPPROTO(long id, int flags) : f89f0024
timer_update_time:TPPROTO(struct timespec *_xtime, struct timespec 
*_wall_to_monotonic) : f8a1310c
sched_process_fork:TPPROTO(struct task_struct *parent, struct 
task_struct *child) : f8a131ce

/debug/markers/debug: Turn debug ON/OFF (default 0:OFF)
/debug/tracepoint/debug: Turn debug ON/OFF (default 0:OFF)

TODO:
 switch marker/tracepoint list to one file per marker/tracepoint
 (for LTTng).

---

Signed-off-by: Takashi NISHIIE <t-nishiie@np.css.fujitsu.com>

diff --git a/kernel/marker.c b/kernel/marker.c
index 36a23f8..9f958a3 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -28,12 +28,15 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <linux/user_marker.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <asm/uaccess.h>
 
 extern struct marker __start___markers[];
 extern struct marker __stop___markers[];
 
 /* Set to 1 to enable marker debug output */
-static const int marker_debug;
+static int marker_debug;
 
 /*
  * markers_mutex nests inside module_mutex. Markers mutex protects the
builtin
@@ -1179,3 +1182,162 @@ int is_marker_enabled(const char *name)
 	return entry && !!entry->refcount;
 }
 #endif
+
+#ifdef CONFIG_DEBUG_FS
+
+static struct dentry *debugfs_marker_dir;
+static struct dentry *debugfs_debug_file;
+static struct dentry *debugfs_list_file;
+
+static void report_marker(struct seq_file *pi, struct marker_entry *entry)
+{
+	int i;
+
+	if (!entry)
+		return;
+
+	if (!entry->ptype) {
+		seq_printf(pi, "%s :", entry->name);
+		seq_printf(pi, " (%p,%p)",
+			entry->single.func,
+			entry->single.probe_private);
+		seq_printf(pi, "\n");
+	} else {
+		seq_printf(pi, "%s :", entry->name);
+		for (i = 0; entry->multi[i].func; i++)
+			seq_printf(pi, " (%p,%p)",
+				entry->multi[i].func,
+				entry->multi[i].probe_private);
+		seq_printf(pi, "\n");
+	}
+}
+
+static void *marker_list_seq_start(struct seq_file *f, loff_t *pos)
+{
+	return (*pos < MARKER_TABLE_SIZE) ? pos : NULL;
+}
+
+static void *marker_list_seq_next(struct seq_file *f, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos >= MARKER_TABLE_SIZE)
+		return NULL;
+	return pos;
+}
+
+static void marker_list_seq_stop(struct seq_file *f, void *v)
+{
+	/* Nothing to do */
+}
+
+static int show_marker_list(struct seq_file *pi, void *v)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *entry;
+	unsigned int i = *(loff_t *) v;
+
+	head = &marker_table[i];
+	preempt_disable();
+	hlist_for_each_entry_rcu(entry, node, head, hlist) {
+		report_marker(pi, entry);
+	}
+	preempt_enable();
+	return 0;
+}
+
+static struct seq_operations marker_list_seq_ops = {
+	.start = marker_list_seq_start,
+	.next  = marker_list_seq_next,
+	.stop  = marker_list_seq_stop,
+	.show  = show_marker_list
+};
+
+static int marker_list_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &marker_list_seq_ops);
+}
+
+static struct file_operations debugfs_list_operations = {
+	.open           = marker_list_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
+
+static ssize_t read_debug_file_bool(struct file *file,
+	       char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[3];
+
+	if (marker_debug)
+		buf[0] = '1';
+	else
+		buf[0] = '0';
+	buf[1] = '\n';
+	buf[2] = 0x00;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t write_debug_file_bool(struct file *file,
+	       const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int buf_size;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	switch (buf[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		marker_debug = 1;
+		break;
+	case 'n':
+	case 'N':
+	case '0':
+		marker_debug = 0;
+		break;
+	}
+
+	return count;
+}
+
+static struct file_operations fops_debug = {
+	.read =         read_debug_file_bool,
+	.write =        write_debug_file_bool,
+};
+
+static int __init debugfs_marker_init(void)
+{
+	unsigned int value = 0;
+
+	debugfs_marker_dir = debugfs_create_dir("markers", NULL);
+	if (!debugfs_marker_dir)
+		return -ENOMEM;
+
+	debugfs_list_file = debugfs_create_file("list", 0444,
debugfs_marker_dir,
+					NULL, &debugfs_list_operations);
+	if (!debugfs_list_file) {
+		debugfs_remove(debugfs_marker_dir);
+		debugfs_marker_dir = NULL;
+		return -ENOMEM;
+	}
+
+	debugfs_debug_file = debugfs_create_file("debug", 0600,
debugfs_marker_dir,
+					&value, &fops_debug);
+	if (!debugfs_debug_file) {
+		debugfs_remove(debugfs_marker_dir);
+		debugfs_marker_dir = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+late_initcall(debugfs_marker_init);
+#endif /* CONFIG_DEBUG_FS */
+
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index f9121f8..594a6fa 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -25,12 +25,15 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/immediate.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <asm/uaccess.h>
 
 extern struct tracepoint __start___tracepoints[];
 extern struct tracepoint __stop___tracepoints[];
 
 /* Set to 1 to enable tracepoint debug output */
-static const int tracepoint_debug;
+static int tracepoint_debug;
 
 /*
  * tracepoints_mutex nests inside module_mutex. Tracepoints mutex protects
the
@@ -478,3 +481,151 @@ void tracepoint_iter_reset(struct tracepoint_iter
*iter)
 	iter->tracepoint = NULL;
 }
 EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
+
+#ifdef CONFIG_DEBUG_FS
+
+static struct dentry *debugfs_tracepoint_dir;
+static struct dentry *debugfs_debug_file;
+static struct dentry *debugfs_list_file;
+
+static void report_tracepoint(struct seq_file *pi, struct tracepoint_entry
*entry)
+{
+	int i;
+
+	if (!entry)
+		return;
+
+	seq_printf(pi, "%s :", entry->name);
+	for (i = 0; entry->funcs[i]; i++)
+		seq_printf(pi, " %p", entry->funcs[i]);
+	seq_printf(pi, "\n");
+}
+
+static void *tracepoint_list_seq_start(struct seq_file *f, loff_t *pos)
+{
+	return (*pos < TRACEPOINT_TABLE_SIZE) ? pos : NULL;
+}
+
+static void *tracepoint_list_seq_next(struct seq_file *f, void *v, loff_t
*pos)
+{
+	(*pos)++;
+	if (*pos >= TRACEPOINT_TABLE_SIZE)
+		return NULL;
+	return pos;
+}
+
+static void tracepoint_list_seq_stop(struct seq_file *f, void *v)
+{
+	/* Nothing to do */
+}
+
+static int show_tracepoint_list(struct seq_file *pi, void *v)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct tracepoint_entry *entry;
+	unsigned int i = *(loff_t *) v;
+
+	head = &tracepoint_table[i];
+	preempt_disable();
+	hlist_for_each_entry_rcu(entry, node, head, hlist) {
+		report_tracepoint(pi, entry);
+	}
+	preempt_enable();
+	return 0;
+}
+
+static struct seq_operations tracepoint_list_seq_ops = {
+	.start = tracepoint_list_seq_start,
+	.next  = tracepoint_list_seq_next,
+	.stop  = tracepoint_list_seq_stop,
+	.show  = show_tracepoint_list
+};
+
+static int tracepoint_list_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &tracepoint_list_seq_ops);
+}
+
+static struct file_operations debugfs_list_operations = {
+	.open           = tracepoint_list_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
+static ssize_t read_debug_file_bool(struct file *file,
+	       char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[3];
+
+	if (tracepoint_debug)
+		buf[0] = '1';
+	else
+		buf[0] = '0';
+	buf[1] = '\n';
+	buf[2] = 0x00;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t write_debug_file_bool(struct file *file,
+	       const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int buf_size;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	switch (buf[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		tracepoint_debug = 1;
+		break;
+	case 'n':
+	case 'N':
+	case '0':
+		tracepoint_debug = 0;
+		break;
+	}
+
+	return count;
+}
+
+static struct file_operations fops_debug = {
+	.read =         read_debug_file_bool,
+	.write =        write_debug_file_bool,
+};
+
+static int debugfs_tracepoint_init(void)
+{
+	unsigned int value = 0;
+
+	debugfs_tracepoint_dir = debugfs_create_dir("tracepoint", NULL);
+	if (!debugfs_tracepoint_dir)
+		return -ENOMEM;
+
+	debugfs_list_file = debugfs_create_file("list", 0444,
debugfs_tracepoint_dir,
+					NULL, &debugfs_list_operations);
+	if (!debugfs_list_file) {
+		debugfs_remove(debugfs_tracepoint_dir);
+		debugfs_tracepoint_dir = NULL;
+		return -ENOMEM;
+	}
+
+	debugfs_debug_file = debugfs_create_file("debug", 0600,
debugfs_tracepoint_dir,
+					&value, &fops_debug);
+	if (!debugfs_debug_file) {
+		debugfs_remove(debugfs_tracepoint_dir);
+		debugfs_tracepoint_dir = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+late_initcall(debugfs_tracepoint_init);
+#endif /* CONFIG_DEBUG_FS */
+

Regards,Takashi
---
Takashi NISHIIE



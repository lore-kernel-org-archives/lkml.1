Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbZB0JBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbZB0JBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbZB0JBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:01:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:24533 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbZB0JBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:01:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=x6S8AosD+rzQq3umLCVho85x5phtwovlRrlEDhx0g+ZWExuHBzlgKCQsm0Wngaw21j
         zCG2QXJqx6JtS8xQ0rgUjr/zSNoc3TgRkLUhA2lC5vbwwbLzneogeO0ju3OEajFk3JPT
         VY6pFVTtmofVXA42nF4ezzdOns5V4wtHRd9YM=
Subject: [PATCH 1/4] zedtrace base code
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 27 Feb 2009 03:00:51 -0600
Message-Id: <1235725251.8512.87.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The base Zed tracer.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/Kconfig                  |   45 ++
 kernel/trace/Makefile                 |    1 +
 kernel/trace/trace_binary/Makefile    |    3 +
 kernel/trace/trace_binary/zed.c       |  971 +++++++++++++++++++++++++++++++++
 kernel/trace/trace_binary/zed.h       |  236 ++++++++
 kernel/trace/trace_binary/zed_sched.c |  201 +++++++
 kernel/trace/trace_binary/zed_sched.h |   73 +++
 7 files changed, 1530 insertions(+), 0 deletions(-)
 create mode 100644 kernel/trace/trace_binary/Makefile
 create mode 100644 kernel/trace/trace_binary/zed.c
 create mode 100644 kernel/trace/trace_binary/zed.h
 create mode 100644 kernel/trace/trace_binary/zed_sched.c
 create mode 100644 kernel/trace/trace_binary/zed_sched.h

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 58a93fb..016dfe2 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -47,6 +47,51 @@ config TRACING
 
 menu "Tracers"
 
+config ZEDTRACE
+	bool "Zed Kernel Tracer"
+	select RELAY
+	select TRACING
+	help
+	  Say Y here for a low-overhead general-purpose kernel tracing
+	  option that allows you to selectively trace any/all
+	  tracepoints currently defined in the kernel, with generic
+	  kernel or userspace filtering, as desired.  Trace events
+	  from different subsystems e.g. sched/block/workqueue appear
+	  together seamlessly in the trace output, allowing
+	  interactions between subsystems to be identified and
+	  providing an overall view of system-wide activity.
+
+	  All trace events are self-describing; there are a number of
+	  userspace tools available in the zedtrace tarball that take
+	  advantage of this and make all of the events and event
+	  fields available to general-purpose language interpreters as
+	  native types and event handler funtions.  For instance, the
+	  'zedperl' event interpreter allows the full power of Perl to
+	  be used to aggregate and analyze either a saved set of
+	  per-cpu trace files or or a live trace stream in real-time.
+	  There are also simpler utilities that can be used to do the
+	  same thing but that simply print the data in a generic way.
+	  In any case, because the data is self-describing, these
+	  tools don't need to be recompiled when new events are added
+	  to the kernel.  Users can also trivially write their own
+	  front-ends to display and/or aggregate/analyze the trace
+	  stream in custom ways by plugging in to the modular Zed
+	  architecture; interpreters for other languages such as
+	  Python, Ruby, etc. are expected soon.
+
+	  Because Zed is based on the best-of-breed blktrace-derived
+	  UTT userspace tracing library, users can trace not only to
+	  local disk but over the network in several different ways,
+	  and as mentioned can also do 'live tracing' using the
+	  combined per-cpu data stream.
+
+	  See kernel/trace/trace_binary/zedtrace.h for the current set
+	  of event definitions, which can be used as examples for
+	  adding your own.
+
+	  See http://utt.sourceforge.net/zedtrace.html for userspace
+	  tools, examples and further documentation.
+
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
 	depends on HAVE_FUNCTION_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 349d5a9..0bd6edc 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -33,5 +33,6 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += trace_functions_graph.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
 obj-$(CONFIG_HW_BRANCH_TRACER) += trace_hw_branches.o
 obj-$(CONFIG_POWER_TRACER) += trace_power.o
+obj-$(CONFIG_ZEDTRACE) += trace_binary/
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_binary/Makefile b/kernel/trace/trace_binary/Makefile
new file mode 100644
index 0000000..558e17a
--- /dev/null
+++ b/kernel/trace/trace_binary/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_ZEDTRACE) += zedtrace.o
+
+zedtrace-objs := zed.o zed_sched.o
diff --git a/kernel/trace/trace_binary/zed.c b/kernel/trace/trace_binary/zed.c
new file mode 100644
index 0000000..171d2e5
--- /dev/null
+++ b/kernel/trace/trace_binary/zed.c
@@ -0,0 +1,971 @@
+/*
+ * zedtrace - generic kernel tracer
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2008-2009 - Tom Zanussi <tzanussi@gmail.com>
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/jhash.h>
+#include <linux/vmalloc.h>
+#include <linux/debugfs.h>
+#include <trace/sched.h>
+#include "zed.h"
+
+/* globals */
+
+struct rchan *zed_channel;
+unsigned int zed_tracing;
+u32 *zed_trace_sequence;
+
+static struct dentry *tree_root;
+static DEFINE_MUTEX(tree_mutex);
+static unsigned int root_users;
+
+static int buf_size = 262144;
+static int buf_nr = 4;
+atomic_t zed_dropped;
+
+/* forward declarations */
+
+static int destroy_trace_controls(void);
+static int create_trace_controls(void);
+static int create_channel(void);
+static int destroy_channel(void);
+static int start_trace(void);
+static int stop_trace(void);
+static int zed_enable_tracepoints(void);
+static void zed_disable_tracepoints(void);
+
+/* relay channel/control files will appear in /sys/kernel/debug/zed/trace */
+#define APP_DIR		"zed"
+static struct dentry *dir;
+
+/* trace flag generator */
+EVENTS(DEFINE_TRACE_FLAG, SEMICOLON);
+
+/* array of runtime zed event descriptions */
+struct zed_event *zed_events[MAX_EVENTS];
+
+/* channel-management control files */
+static struct dentry	*buf_size_file;
+static struct dentry	*buf_nr_file;
+static struct dentry	*create_file;
+static struct dentry	*destroy_file;
+static struct dentry	*start_file;
+static struct dentry	*stop_file;
+static struct dentry	*dropped_file;
+
+/*
+ * event descriptions
+ */
+
+/* zed event desc files appear in sys/kernel/debug/zed/trace/events */
+#define ZED_EVENT_DESC_DIR		"events"
+static struct dentry *zed_event_desc_dir;
+static struct dentry *all_file;
+
+#define SUBSYS_TABLE_SIZE	256
+static struct hlist_head subsys_table[SUBSYS_TABLE_SIZE];
+
+/**
+ *	zed_event_desc_open() - zed event file open fileop
+ */
+static int zed_event_desc_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+
+	return 0;
+}
+
+/**
+ *	zed_event_desc_read() - zed event file read fileop
+ */
+static ssize_t zed_event_desc_read(struct file *filp, char __user *buffer,
+				   size_t count, loff_t *ppos)
+{
+	struct zed_field *field;
+	char *page;
+	ssize_t length = 0;
+	struct zed_event *event = filp->private_data;
+
+	if (count > PAGE_SIZE)
+		count = PAGE_SIZE;
+
+	page = (char *)__get_free_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+
+	length += sprintf(page, "%s\t%u\t%d\t%s\n", event->name, event->id,
+			  event->size,
+			  *event->trace_flags ? "enabled" : "disabled");
+	list_for_each_entry_reverse(field, &event->field_list, link) {
+		length += sprintf(page + length, "\t%s\t%s\t%d\t%d\n",
+				  field->name, field->type, field->offset,
+				  field->size);
+	}
+
+	if (length >= 0)
+		length = simple_read_from_buffer(buffer, count, ppos, page,
+						 length + 1);
+
+	free_page((unsigned long)page);
+
+	return length;
+}
+
+static ssize_t zed_event_desc_write(struct file *filp,
+				    const char __user *buffer,
+				    size_t count, loff_t *ppos)
+{
+	struct zed_event *event = filp->private_data;
+	char buf[32], *tmp;
+	int enable;
+
+	if (count > sizeof(buf))
+		return -EINVAL;
+
+	memset(buf, 0, sizeof(buf));
+
+	if (copy_from_user(buf, buffer, count))
+		return -EFAULT;
+
+	enable = simple_strtol(buf, &tmp, 10);
+	if (tmp == buf)
+		return -EINVAL;
+
+	if (enable)
+		*event->trace_flags = 1;
+	else
+		*event->trace_flags = 0;
+
+	return count;
+}
+
+/*
+ *	zed event description file operations
+ */
+static const struct file_operations zed_event_desc_fops = {
+	.owner =	THIS_MODULE,
+	.open =		zed_event_desc_open,
+	.read =		zed_event_desc_read,
+	.write =	zed_event_desc_write,
+};
+
+/**
+ *	register_zed_field() - add a field to a run-time event description
+ */
+static void register_zed_field(struct zed_event *event, char *field_name,
+			       char *field_type, int field_offset,
+			       int field_size)
+{
+	struct zed_field *field;
+
+	field = kmalloc(sizeof(struct zed_field), GFP_KERNEL);
+	strcpy(field->name, field_name);
+	strcpy(field->type, field_type);
+	field->offset = field_offset;
+	field->size = field_size;
+	list_add(&field->link, &event->field_list);
+}
+
+static void subsys_enable_all(char *subsys, int enable)
+{
+	struct zed_event *event;
+	int i;
+
+	for (i = 0; i < MAX_EVENTS; i++) {
+		event = zed_events[i];
+		if (!event)
+			break;
+		if (!strcmp(event->subsys_name, subsys))
+			*event->trace_flags = enable;
+	}
+}
+
+static void enable_all(int enable)
+{
+	struct zed_event *event;
+	int i;
+
+	for (i = 0; i < MAX_EVENTS; i++) {
+		event = zed_events[i];
+		if (!event)
+			break;
+		*event->trace_flags = enable;
+	}
+}
+
+static int all_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t all_write(struct file *filp, const char __user *buffer,
+			 size_t count, loff_t *ppos)
+{
+	char *subsys = filp->private_data;
+	char buf[32], *tmp;
+	int enable;
+
+	if (count > sizeof(buf))
+		return -EINVAL;
+
+	memset(buf, 0, sizeof(buf));
+
+	if (copy_from_user(buf, buffer, count))
+		return -EFAULT;
+
+	enable = simple_strtol(buf, &tmp, 10);
+	if (tmp == buf)
+		return -EINVAL;
+
+	if (enable) {
+		if (subsys)
+			subsys_enable_all(subsys, 1);
+		else
+			enable_all(1);
+	} else {
+		if (subsys)
+			subsys_enable_all(subsys, 0);
+		else
+			enable_all(0);
+	}
+
+	return count;
+}
+
+static const struct file_operations all_fops = {
+	.owner =	THIS_MODULE,
+	.open =		all_open,
+	.write =	all_write,
+};
+
+static struct zed_subsys *find_subsys(char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct zed_subsys *s;
+	u32 hash = jhash(name, strlen(name), 0);
+
+	head = &subsys_table[hash & (SUBSYS_TABLE_SIZE - 1)];
+	hlist_for_each_entry(s, node, head, hlist) {
+		if (!strcmp(name, s->name))
+			return s;
+	}
+	return NULL;
+}
+
+static struct zed_subsys *add_subsys(char *name, struct dentry *parent)
+{
+	struct hlist_head *head;
+	struct zed_subsys *s;
+	u32 hash = jhash(name, strlen(name), 0);
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	s->name = kmalloc(strlen(name) + 1, GFP_KERNEL);
+	strncpy(s->name, name, strlen(name) + 1);
+	head = &subsys_table[hash & (SUBSYS_TABLE_SIZE - 1)];
+	hlist_add_head(&s->hlist, head);
+
+	s->dir = debugfs_create_dir(name, parent);
+	if (!s->dir)
+		goto fail;
+	s->all_file = debugfs_create_file("all", 0, s->dir, s->name,
+					  &all_fops);
+	if (!s->all_file) {
+		printk(KERN_ERR "Couldn't create %s control file 'all'.\n",
+		       s->name);
+		goto fail;
+	}
+	return s;
+fail:
+	if (s->dir)
+		debugfs_remove(s->dir);
+	kfree(s->name);
+	kfree(s);
+
+	return NULL;
+}
+
+static int remove_subsys(char *name)
+{
+	struct zed_subsys *s = find_subsys(name);
+
+	if (!s)
+		return -ENOENT;
+
+	hlist_del(&s->hlist);
+	kfree(s->name);
+	kfree(s);
+
+	return 0;
+}
+
+/**
+ *	register_zed_event() - create an event description file for an event
+ */
+static struct zed_event *register_zed_event(char *subsys_name,
+					    char *event_name,
+					    enum zed_event_id event_id,
+					    int event_size,
+					    int *trace_flags)
+{
+	struct zed_subsys *subsys;
+	struct zed_event *event;
+
+	subsys = find_subsys(subsys_name);
+	if (!subsys) {
+		subsys = add_subsys(subsys_name, zed_event_desc_dir);
+		if (!subsys) {
+			printk(KERN_ERR "Couldn't create zed subsys %s\n",
+			       subsys_name);
+			return NULL;
+		}
+	}
+
+	event = zed_events[event_id] = kmalloc(sizeof(struct zed_event),
+					       GFP_KERNEL);
+	INIT_LIST_HEAD(&event->field_list);
+	event->id = (unsigned char)event_id;
+	strcpy(event->name, event_name);
+	event->size = event_size;
+	event->trace_flags = trace_flags;
+	event->subsys_name = subsys->name;
+
+	register_zed_field(event, "magic", "u32",
+			   offsetof(struct zed_header, magic),
+			   (int)sizeof(u32));
+	register_zed_field(event, "id", "u16",
+			   offsetof(struct zed_header, id),
+			   (int)sizeof(u16));
+	register_zed_field(event, "cpu", "u32",
+			   offsetof(struct zed_header, cpu),
+			   (int)sizeof(u32));
+	register_zed_field(event, "time", "timestamp",
+			   offsetof(struct zed_header, time),
+			   (int)sizeof(u64));
+	register_zed_field(event, "sequence", "u32",
+			   offsetof(struct zed_header, sequence),
+			   (int)sizeof(u32));
+
+	event->desc_file = debugfs_create_file(event->name, 0,
+					       subsys->dir,
+					       event, &zed_event_desc_fops);
+	if (!event->desc_file) {
+		printk(KERN_ERR "Couldn't create zed event desc file %s.\n",
+		       event->name);
+		remove_subsys(subsys_name);
+		return NULL;
+	}
+	return event;
+}
+
+/**
+ *	register_zed_events - create event description files for all events
+ */
+static int register_zed_events(void)
+{
+	zed_event_desc_dir = debugfs_create_dir(ZED_EVENT_DESC_DIR, dir);
+	if (!zed_event_desc_dir) {
+		printk(KERN_ERR "Couldn't create zed event desc dir.\n");
+		return -ENOMEM;
+	}
+
+	all_file = debugfs_create_file("all", 0,
+				       zed_event_desc_dir,
+				       NULL, &all_fops);
+	if (!all_file) {
+		printk(KERN_ERR "Couldn't create control file 'all'.\n");
+		goto fail;
+	}
+
+	EVENTS(REGISTER_EVENT, SEMICOLON);
+
+	return 0;
+fail:
+	if (zed_event_desc_dir)
+		debugfs_remove(zed_event_desc_dir);
+
+	return -ENOMEM;
+}
+
+/**
+ *	unregister_zed_event() - remove an event description file for an event
+ */
+static void unregister_zed_event(struct zed_event *event)
+{
+	struct zed_field *field;
+	struct list_head *entry, *tmp;
+
+	list_for_each_safe(entry, tmp, &event->field_list) {
+		field = list_entry(entry, struct zed_field, link);
+		kfree(field);
+	}
+
+	debugfs_remove(event->desc_file);
+
+	kfree(event);
+}
+
+/**
+ *	unregister_zed_events - remove event description files for all events
+ */
+static void unregister_zed_events(void)
+{
+	int i;
+
+	for (i = 0; i < MAX_EVENTS; i++) {
+		if (!zed_events[i])
+			break;
+		unregister_zed_event(zed_events[i]);
+	}
+
+	debugfs_remove(zed_event_desc_dir);
+}
+
+/* channel setup/teardown */
+
+void remove_root(void)
+{
+	if (tree_root) {
+		debugfs_remove(tree_root);
+		tree_root = NULL;
+	}
+}
+
+void remove_tree(struct dentry *dir)
+{
+	mutex_lock(&tree_mutex);
+	debugfs_remove(dir);
+	if (--root_users == 0)
+		remove_root();
+	mutex_unlock(&tree_mutex);
+}
+
+struct dentry *create_tree(const char *app_name, const char *channel_name)
+{
+	struct dentry *dir = NULL;
+	int created = 0;
+
+	mutex_lock(&tree_mutex);
+
+	if (!tree_root) {
+		tree_root = debugfs_create_dir(app_name, NULL);
+		if (!tree_root)
+			goto err;
+		created = 1;
+	}
+
+	dir = debugfs_create_dir(channel_name, tree_root);
+	if (dir)
+		root_users++;
+	else {
+		/* Delete root only if we created it */
+		if (created)
+			remove_root();
+	}
+err:
+	mutex_unlock(&tree_mutex);
+	return dir;
+}
+
+/*
+ * relay callback implementations
+ */
+
+static int subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
+				 void *prev_subbuf, size_t prev_padding)
+{
+	if (!relay_buf_full(buf))
+		return 1;
+
+	atomic_inc(&zed_dropped);
+
+	return 0;
+}
+
+static int remove_buf_file_callback(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+
+	return 0;
+}
+
+static struct dentry *create_buf_file_callback(const char *filename,
+					       struct dentry *parent,
+					       int mode,
+					       struct rchan_buf *buf,
+					       int *is_global)
+{
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+static struct rchan_callbacks relay_callbacks = {
+	.subbuf_start		= subbuf_start_callback,
+	.create_buf_file	= create_buf_file_callback,
+	.remove_buf_file	= remove_buf_file_callback,
+};
+
+/*
+ * Control files
+ */
+
+static ssize_t buf_size_read(struct file *filp, char __user *buffer,
+			     size_t count, loff_t *ppos)
+{
+	char buf[16];
+
+	snprintf(buf, sizeof(buf), "%d\n", buf_size);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static ssize_t buf_size_write(struct file *filp, const char __user *buffer,
+			      size_t count, loff_t *ppos)
+{
+	char buf[16];
+	char *tmp;
+	size_t size;
+
+	if (count > sizeof(buf))
+		return -EINVAL;
+
+	memset(buf, 0, sizeof(buf));
+
+	if (copy_from_user(buf, buffer, count))
+		return -EFAULT;
+
+	size = simple_strtol(buf, &tmp, 10);
+	if (tmp == buf)
+		return -EINVAL;
+
+	buf_size = size;
+
+	return count;
+}
+
+static const struct file_operations buf_size_fops = {
+	.owner =	THIS_MODULE,
+	.read =		buf_size_read,
+	.write =	buf_size_write,
+};
+
+static ssize_t buf_nr_read(struct file *filp, char __user *buffer,
+			   size_t count, loff_t *ppos)
+{
+	char buf[16];
+
+	snprintf(buf, sizeof(buf), "%d\n", buf_nr);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static ssize_t buf_nr_write(struct file *filp, const char __user *buffer,
+			    size_t count, loff_t *ppos)
+{
+	char buf[16];
+	char *tmp;
+	size_t n;
+
+	if (count > sizeof(buf))
+		return -EINVAL;
+
+	memset(buf, 0, sizeof(buf));
+
+	if (copy_from_user(buf, buffer, count))
+		return -EFAULT;
+
+	n = simple_strtol(buf, &tmp, 10);
+	if (tmp == buf)
+		return -EINVAL;
+
+	buf_nr = n;
+
+	return count;
+}
+
+static const struct file_operations buf_nr_fops = {
+	.owner =	THIS_MODULE,
+	.read =		buf_nr_read,
+	.write =	buf_nr_write,
+};
+
+static ssize_t create_read(struct file *filp, char __user *buffer,
+			   size_t count, loff_t *ppos)
+{
+	char buf[16];
+
+	snprintf(buf, sizeof(buf), "%d\n", !!zed_channel);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static ssize_t create_write(struct file *filp, const char __user *buffer,
+			    size_t count, loff_t *ppos)
+{
+	int err = create_channel();
+
+	if (err)
+		return err;
+
+	return count;
+}
+
+static const struct file_operations create_fops = {
+	.owner =	THIS_MODULE,
+	.read =		create_read,
+	.write =	create_write,
+};
+
+static ssize_t destroy_read(struct file *filp, char __user *buffer,
+			    size_t count, loff_t *ppos)
+{
+	char buf[16];
+
+	snprintf(buf, sizeof(buf), "%d\n", !zed_channel);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static ssize_t destroy_write(struct file *filp, const char __user *buffer,
+			     size_t count, loff_t *ppos)
+{
+	int err = destroy_channel();
+
+	if (err)
+		return err;
+
+	return count;
+}
+
+static const struct file_operations destroy_fops = {
+	.owner =	THIS_MODULE,
+	.read =		destroy_read,
+	.write =	destroy_write,
+};
+
+static ssize_t start_read(struct file *filp, char __user *buffer,
+			  size_t count, loff_t *ppos)
+{
+	char buf[16];
+
+	snprintf(buf, sizeof(buf), "%d\n", !!zed_tracing);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static ssize_t start_write(struct file *filp, const char __user *buffer,
+			   size_t count, loff_t *ppos)
+{
+	int err = start_trace();
+
+	if (err)
+		return err;
+
+	return count;
+}
+
+static const struct file_operations start_fops = {
+	.owner =	THIS_MODULE,
+	.read =		start_read,
+	.write =	start_write,
+};
+
+static ssize_t stop_read(struct file *filp, char __user *buffer,
+			 size_t count, loff_t *ppos)
+{
+	char buf[16];
+
+	snprintf(buf, sizeof(buf), "%d\n", !zed_tracing);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static ssize_t stop_write(struct file *filp, const char __user *buffer,
+			  size_t count, loff_t *ppos)
+{
+	int err = stop_trace();
+
+	if (err)
+		return err;
+
+	return count;
+}
+
+static const struct file_operations stop_fops = {
+	.owner =	THIS_MODULE,
+	.read =		stop_read,
+	.write =	stop_write,
+};
+
+static ssize_t dropped_read(struct file *filp, char __user *buffer,
+			    size_t count, loff_t *ppos)
+{
+	char buf[16];
+
+	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&zed_dropped));
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static const struct file_operations dropped_fops = {
+	.owner =	THIS_MODULE,
+	.read =		dropped_read,
+};
+
+static int destroy_trace_controls(void)
+{
+	if (zed_channel)
+		return -EBUSY;
+
+	if (buf_size_file) {
+		debugfs_remove(buf_size_file);
+		buf_size_file = NULL;
+	}
+
+	if (buf_nr_file) {
+		debugfs_remove(buf_nr_file);
+		buf_nr_file = NULL;
+	}
+
+	if (create_file) {
+		debugfs_remove(create_file);
+		create_file = NULL;
+	}
+
+	if (destroy_file) {
+		debugfs_remove(destroy_file);
+		destroy_file = NULL;
+	}
+
+	if (start_file) {
+		debugfs_remove(start_file);
+		start_file = NULL;
+	}
+
+	if (stop_file) {
+		debugfs_remove(stop_file);
+		stop_file = NULL;
+	}
+
+	if (dropped_file) {
+		debugfs_remove(dropped_file);
+		dropped_file = NULL;
+	}
+
+	if (dir)
+		remove_tree(dir);
+
+	return 0;
+}
+
+static int create_trace_controls(void)
+{
+	int ret = -ENOENT;
+	dir = create_tree("zed", "trace");
+	if (!dir)
+		goto err;
+
+	atomic_set(&zed_dropped, 0);
+
+	ret = -EIO;
+	buf_size_file = debugfs_create_file("buf_size", 0, dir,
+					    NULL, &buf_size_fops);
+	if (!buf_size_file) {
+		printk(KERN_ERR "Couldn't create control file 'buf_size'.\n");
+		goto err;
+	}
+
+	buf_nr_file = debugfs_create_file("buf_nr", 0, dir,
+					     NULL, &buf_nr_fops);
+	if (!buf_nr_file) {
+		printk(KERN_ERR "Couldn't create control file 'buf_nr'.\n");
+		goto err;
+	}
+
+	create_file = debugfs_create_file("create", 0, dir,
+					  NULL, &create_fops);
+	if (!create_file) {
+		printk(KERN_ERR "Couldn't create control file 'create'.\n");
+		goto err;
+	}
+
+	destroy_file = debugfs_create_file("destroy", 0, dir,
+					   NULL, &destroy_fops);
+	if (!destroy_file) {
+		printk(KERN_ERR "Couldn't create control file 'destroy'.\n");
+		goto err;
+	}
+
+	start_file = debugfs_create_file("start", 0, dir,
+					 NULL, &start_fops);
+	if (!start_file) {
+		printk(KERN_ERR "Couldn't create control file 'start'.\n");
+		goto err;
+	}
+
+	stop_file = debugfs_create_file("stop", 0, dir,
+					NULL, &stop_fops);
+	if (!stop_file) {
+		printk(KERN_ERR "Couldn't create control file 'stop'.\n");
+		goto err;
+	}
+
+	dropped_file = debugfs_create_file("dropped", 0444, dir, NULL,
+					   &dropped_fops);
+	if (!dropped_file)
+		goto err;
+
+	return 0;
+err:
+	return destroy_trace_controls();
+}
+
+/*
+ * Trace control
+ */
+
+static int start_trace(void)
+{
+	if (zed_tracing)
+		return -EINVAL;
+
+	if (!zed_channel)
+		return -EINVAL;
+
+	if (zed_enable_tracepoints() == 0)
+		zed_tracing = 1;
+
+	return 0;
+}
+
+static int stop_trace(void)
+{
+	if (!zed_tracing)
+		return -EINVAL;
+
+	if (!zed_channel)
+		return -EINVAL;
+
+	zed_tracing = 0;
+
+	zed_disable_tracepoints();
+
+	relay_flush(zed_channel);
+
+	return 0;
+}
+
+static int destroy_channel(void)
+{
+	if (!zed_channel)
+		return -EINVAL;
+
+	relay_close(zed_channel);
+	zed_channel = NULL;
+
+	if (zed_trace_sequence) {
+		free_percpu(zed_trace_sequence);
+		zed_trace_sequence = NULL;
+	}
+
+	return 0;
+}
+
+static int create_channel(void)
+{
+	if (zed_channel)
+		return -EINVAL;
+
+	if (zed_trace_sequence)
+		return -EINVAL;
+
+	zed_channel = relay_open("trace", dir, buf_size, buf_nr,
+				 &relay_callbacks, NULL);
+	if (!zed_channel)
+		return -ENOMEM;
+
+	zed_trace_sequence = alloc_percpu(u32);
+	if (!zed_trace_sequence) {
+		destroy_channel();
+		return -ENOMEM;
+	}
+
+	atomic_set(&zed_dropped, 0);
+
+	return 0;
+}
+
+static int zed_enable_tracepoints(void)
+{
+	if (zed_enable_sched_tracepoints()) {
+		printk(KERN_ERR "Couldn't register sched tracepoints.\n");
+		goto fail;
+	}
+	return 0;
+fail:
+	return -1;
+}
+
+static void zed_disable_tracepoints(void)
+{
+	zed_disable_sched_tracepoints();
+}
+
+static void zed_init_subsystems(void)
+{
+	zed_sched_init();
+}
+
+/**
+ *	module init - creates channel management control files
+ *
+ *	Returns 0 on success, negative otherwise.
+ */
+static int init(void)
+{
+	int ret = 0;
+
+	ret = create_trace_controls();
+	if (ret) {
+		printk(KERN_ERR "Unable to create trace controls\n");
+		goto err;
+	}
+
+	register_zed_events();
+
+	zed_init_subsystems();
+
+	return ret;
+err:
+	destroy_trace_controls();
+	return ret;
+}
+
+static void cleanup(void)
+{
+	unregister_zed_events();
+}
+
+module_init(init);
+module_exit(cleanup);
+MODULE_LICENSE("GPL");
+
diff --git a/kernel/trace/trace_binary/zed.h b/kernel/trace/trace_binary/zed.h
new file mode 100644
index 0000000..3cbef4b
--- /dev/null
+++ b/kernel/trace/trace_binary/zed.h
@@ -0,0 +1,236 @@
+/*
+ * zedtrace definitions and declarations
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2008-2009 Tom Zanussi <tzanussi@gmail.com>
+ * Event generation macros inspired by a posting of Christopher Elstchka.
+ */
+
+#ifndef _LINUX_ZEDTRACE_H
+#define _LINUX_ZEDTRACE_H
+
+#include <linux/relay.h>
+
+#include <linux/seq_file.h>
+#include <linux/cpufreq.h>
+#include <linux/clocksource.h>
+#include <asm/div64.h>
+
+/*
+ * To define and log an event:
+ *
+ * - add a subsys, XXX_trace entry to the EVENTS() macro
+ * - add a #define subsys_XXX_trace_fields definition in subsys.h
+ * - add ZED_TRACEPOINT_ENTER/EXIT, assign fields, reg/unreg in subsys.c
+ *
+ * Basically, just follow the example of existing events - it's easy.
+ */
+
+/*
+ * event definitions.  TODO: split these up into the separate subsys files.
+ */
+
+#define EVENTS(EVENT, sep)	       \
+	EVENT(sched, kthread_stop_trace) sep \
+	EVENT(sched, kthread_stop_ret_trace) sep \
+	EVENT(sched, wait_task_trace) sep \
+	EVENT(sched, wakeup_trace) sep \
+	EVENT(sched, wakeup_new_trace) sep \
+	EVENT(sched, switch_trace) sep \
+	EVENT(sched, migrate_task_trace) sep \
+	EVENT(sched, process_free_trace) sep \
+	EVENT(sched, process_exit_trace) sep \
+	EVENT(sched, process_wait_trace) sep \
+	EVENT(sched, process_fork_trace) sep \
+	EVENT(sched, signal_send_trace) sep \
+
+#include "zed_sched.h"
+
+/* magic or'ed with version, last byte of magic should be 00 */
+#define ZED_TRACE_MAGIC		0x26F82100
+#define ZED_TRACE_VERSION	0x21
+
+/*
+ * external declarations, for the macros and reserve functions
+ */
+
+#define MAX_EVENTS 1024
+#define MAX_ZED_EVENT_SIZE 4096
+#define MAX_EVENT_NAME 256
+#define MAX_FIELD_NAME 32
+#define MAX_FIELD_TYPE 64
+
+/*
+ * event definition structs
+ */
+
+struct zed_subsys {
+	struct hlist_node hlist;
+	char *name;
+	struct dentry *dir;
+	struct dentry *all_file;
+};
+
+struct zed_field {
+	struct list_head link;
+	char name[MAX_FIELD_NAME];
+	char type[MAX_FIELD_TYPE];
+	int offset;
+	int size;
+};
+
+struct zed_event {
+	struct dentry *desc_file;
+	unsigned char id;
+	char name[MAX_EVENT_NAME];
+	char *subsys_name;
+	int size;
+	int *trace_flags;
+	struct list_head field_list;
+};
+
+/*
+ * zed trace, common part of each trace record
+ */
+struct zed_header {
+	u32 magic;	/* MAGIC << 8 | version */
+	u16 id;		/* event id */
+	u32 cpu;	/* on what cpu did it happen */
+	u64 time;	/* in nanoseconds */
+	u32 sequence;	/* for debugging, utp */
+};
+
+extern struct rchan *zed_channel;
+extern struct zed_event *zed_events[MAX_EVENTS];
+extern u32 *zed_trace_sequence;
+extern unsigned int zed_tracing;
+
+/*
+ * event definition macros
+ */
+
+#define DECLARE_FIELD(subsys, event_name, field, type) type field;
+
+#define DECLARE_EVENT(subsys, event_name)	\
+	struct subsys##_##event_name##_struct {	\
+		u32 magic;			\
+		u16 id;							\
+		u32 cpu;						\
+		u64 time;						\
+		u32 sequence;						\
+		subsys##_##event_name##_fields(subsys, event_name,	\
+					       DECLARE_FIELD)		\
+	}
+
+#define REGISTER_FIELD(subsys, event_name, field, type)	\
+	register_zed_field(event, #field, #type, \
+	   offsetof(struct subsys##_##event_name##_struct, field),\
+	   sizeof(((struct subsys##_##event_name##_struct *)0)->field));
+
+#define REGISTER_EVENT(subsys, event_name)	\
+	{					\
+		struct zed_event *event = register_zed_event(#subsys,\
+		     #event_name, subsys##_##event_name, \
+		     sizeof(struct subsys##_##event_name##_struct), \
+		     &trace_##subsys##_##event_name); \
+		subsys##_##event_name##_fields(subsys, event_name,	\
+					       REGISTER_FIELD);	  \
+	}
+
+#define DEFINE_TRACE_FLAG(subsys, event_name) \
+	int trace_##subsys##_##event_name
+#define EXTERN_TRACE_FLAG(subsys, event_name) \
+	extern int trace_##subsys##_##event_name
+
+#define EVENT_ID(subsys, event_name) subsys##_##event_name
+
+#define ID_EVENTS(events) \
+	enum zed_event_id { \
+		events \
+	}
+
+#define COMMA ,
+#define SEMICOLON ;
+
+ID_EVENTS(EVENTS(EVENT_ID, COMMA));
+
+EVENTS(DECLARE_EVENT, SEMICOLON);
+
+/*
+ * Macros to generate boilerplate tracepoint entry/exit code.
+*/
+
+#define ZED_TRACEPOINT_ENTER(name, proto)			\
+	static void name##_tracepoint(proto)			\
+	{							\
+		unsigned long zed_flags;			\
+		unsigned long var_len = 0;			\
+		struct name##_trace_struct *zed_event;		\
+		if (!zed_tracing)				\
+			return;					\
+		if (!trace_##name##_trace)			\
+			return;					\
+		local_irq_save(zed_flags);			\
+		zed_event = zed_reserve(name##_trace, var_len);	\
+		if (!zed_event)				\
+			goto exit;			\
+
+#define ZED_TRACEPOINT_ENTER_VAR(name, proto)		\
+	static void name##_tracepoint(proto)			\
+	{							\
+		unsigned long zed_flags;			\
+		unsigned long var_len = 0;			\
+		struct name##_trace_struct *zed_event;		\
+		if (!zed_tracing)				\
+			return;					\
+		if (!trace_##name##_trace)			\
+			return;					\
+		local_irq_save(zed_flags);			\
+
+#define ZED_RESERVE_VAR(name, var)		\
+	var_len = var;							\
+	zed_event = zed_reserve(name##_trace, var_len);			\
+	if (!zed_event)							\
+		goto exit;						\
+
+#define ZED_TRACEPOINT_EXIT(name)					\
+	exit:								\
+	local_irq_restore(zed_flags);					\
+	}								\
+
+/**
+ *	zed_reserve() - reserve a slot large enough for event_id
+ *	@event_id: auto-generated event id (see documentation)
+ *
+ *	Returns a pointer to the reserved event, or NULL if not possible.
+ */
+static inline void *zed_reserve(enum zed_event_id event_id, int var_len)
+{
+	struct zed_header *h;
+
+	h = relay_reserve(zed_channel, zed_events[event_id]->size + var_len);
+	if (h) {
+		h->magic = ZED_TRACE_MAGIC | ZED_TRACE_VERSION;
+		h->id = (u16)event_id;
+		h->cpu = smp_processor_id();
+		h->time = sched_clock();
+		h->sequence = ++(*per_cpu_ptr(zed_trace_sequence, h->cpu));
+	}
+
+	return h;
+}
+
+#endif /* _LINUX_ZEDTRACE_H */
diff --git a/kernel/trace/trace_binary/zed_sched.c b/kernel/trace/trace_binary/zed_sched.c
new file mode 100644
index 0000000..8eba079
--- /dev/null
+++ b/kernel/trace/trace_binary/zed_sched.c
@@ -0,0 +1,201 @@
+/*
+ * zedtrace "sched" subsys event definitions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2008-2009 Tom Zanussi <tzanussi@gmail.com>
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/jhash.h>
+#include <linux/vmalloc.h>
+#include <linux/debugfs.h>
+#include <trace/sched.h>
+#include <trace/block.h>
+#include "zed.h"
+
+EVENTS(EXTERN_TRACE_FLAG, SEMICOLON);
+
+ZED_TRACEPOINT_ENTER(sched_kthread_stop,
+		     TPPROTO(struct task_struct *p))
+{
+	zed_event->pid = p->pid;
+}
+ZED_TRACEPOINT_EXIT(sched_kthread_stop)
+
+ZED_TRACEPOINT_ENTER(sched_kthread_stop_ret,
+		     TPPROTO(int ret))
+{
+	zed_event->ret = ret;
+}
+ZED_TRACEPOINT_EXIT(sched_kthread_stop_ret)
+
+ZED_TRACEPOINT_ENTER(sched_wait_task,
+		     TPPROTO(struct rq *__rq, struct task_struct *p))
+{
+	zed_event->wait_pid = p->pid;
+}
+ZED_TRACEPOINT_EXIT(sched_wait_task)
+
+ZED_TRACEPOINT_ENTER(sched_wakeup,
+		     TPPROTO(struct rq *__rq, struct task_struct *p,
+			     int success))
+{
+	zed_event->wakeup_pid = p->pid;
+	zed_event->success = success;
+}
+ZED_TRACEPOINT_EXIT(sched_wakeup)
+
+ZED_TRACEPOINT_ENTER(sched_wakeup_new,
+		     TPPROTO(struct rq *__rq, struct task_struct *p,
+			     int success))
+{
+	zed_event->wakeup_pid = p->pid;
+	zed_event->success = success;
+}
+ZED_TRACEPOINT_EXIT(sched_wakeup_new)
+
+ZED_TRACEPOINT_ENTER(sched_switch,
+		     TPPROTO(struct rq *__rq, struct task_struct *prev,
+			     struct task_struct *next))
+{
+	zed_event->prev_pid = prev->pid;
+	zed_event->next_pid = next->pid;
+}
+ZED_TRACEPOINT_EXIT(sched_switch)
+
+ZED_TRACEPOINT_ENTER(sched_migrate_task,
+	     TPPROTO(struct task_struct *p, int orig_cpu, int dest_cpu))
+{
+	zed_event->pid = p->pid;
+	zed_event->orig_cpu = orig_cpu;
+	zed_event->dest_cpu = dest_cpu;
+}
+ZED_TRACEPOINT_EXIT(sched_migrate_task)
+
+ZED_TRACEPOINT_ENTER(sched_process_free,
+	     TPPROTO(struct task_struct *p))
+{
+	zed_event->pid = p->pid;
+}
+ZED_TRACEPOINT_EXIT(sched_process_free)
+
+ZED_TRACEPOINT_ENTER(sched_process_exit,
+	     TPPROTO(struct task_struct *p))
+{
+	zed_event->pid = p->pid;
+}
+ZED_TRACEPOINT_EXIT(sched_process_exit)
+
+ZED_TRACEPOINT_ENTER(sched_process_wait,
+	     TPPROTO(struct pid *pid))
+{
+	zed_event->pid = pid_nr(pid);
+}
+ZED_TRACEPOINT_EXIT(sched_process_wait)
+
+ZED_TRACEPOINT_ENTER(sched_process_fork,
+	     TPPROTO(struct task_struct *parent, struct task_struct *child))
+{
+	zed_event->parent_pid = parent->pid;
+	zed_event->child_pid = child->pid;
+}
+ZED_TRACEPOINT_EXIT(sched_process_fork)
+
+ZED_TRACEPOINT_ENTER(sched_signal_send,
+	     TPPROTO(int sig, struct task_struct *p))
+{
+	zed_event->sig = sig;
+	zed_event->pid = p->pid;
+}
+ZED_TRACEPOINT_EXIT(sched_signal_send)
+
+int zed_enable_sched_tracepoints(void)
+{
+	if (register_trace_sched_kthread_stop(sched_kthread_stop_tracepoint)) {
+		printk(KERN_ERR "Couldn't register kthread_stop tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_sched_kthread_stop_ret(sched_kthread_stop_ret_tracepoint)) {
+		printk(KERN_ERR "Couldn't register sched_kthread_stop_ret tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_sched_wait_task(sched_wait_task_tracepoint)) {
+		printk(KERN_ERR "Couldn't register sched_wait_task tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_sched_wakeup(sched_wakeup_tracepoint)) {
+		printk(KERN_ERR "Couldn't register sched_wakeup tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_sched_wakeup_new(sched_wakeup_new_tracepoint)) {
+		printk(KERN_ERR "Couldn't register sched_wakeup_new tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_sched_switch(sched_switch_tracepoint)) {
+		printk(KERN_ERR "Couldn't register sched_switch tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_sched_migrate_task(sched_migrate_task_tracepoint)) {
+		printk(KERN_ERR "Couldn't register sched_migrate_task tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_sched_process_free(sched_process_free_tracepoint)) {
+		printk(KERN_ERR "Couldn't register sched_process_free tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_sched_process_exit(sched_process_exit_tracepoint)) {
+		printk(KERN_ERR "Couldn't register sched_process_exit tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_sched_process_wait(sched_process_wait_tracepoint)) {
+		printk(KERN_ERR "Couldn't register sched_process_wait tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_sched_process_fork(sched_process_fork_tracepoint)) {
+		printk(KERN_ERR "Couldn't register sched_process_fork tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_sched_signal_send(sched_signal_send_tracepoint)) {
+		printk(KERN_ERR "Couldn't register sched_signal_send tracepoint.\n");
+		goto fail;
+	}
+
+	return 0;
+fail:
+	return -1;
+}
+
+void zed_disable_sched_tracepoints(void)
+{
+	unregister_trace_sched_kthread_stop(sched_kthread_stop_tracepoint);
+	unregister_trace_sched_kthread_stop_ret(sched_kthread_stop_ret_tracepoint);
+	unregister_trace_sched_wait_task(sched_wait_task_tracepoint);
+	unregister_trace_sched_wakeup(sched_wakeup_tracepoint);
+	unregister_trace_sched_wakeup_new(sched_wakeup_new_tracepoint);
+	unregister_trace_sched_switch(sched_switch_tracepoint);
+	unregister_trace_sched_migrate_task(sched_migrate_task_tracepoint);
+	unregister_trace_sched_process_free(sched_process_free_tracepoint);
+	unregister_trace_sched_process_exit(sched_process_exit_tracepoint);
+	unregister_trace_sched_process_wait(sched_process_wait_tracepoint);
+	unregister_trace_sched_process_fork(sched_process_fork_tracepoint);
+	unregister_trace_sched_signal_send(sched_signal_send_tracepoint);
+}
+
+void zed_sched_init(void)
+{
+}
+
diff --git a/kernel/trace/trace_binary/zed_sched.h b/kernel/trace/trace_binary/zed_sched.h
new file mode 100644
index 0000000..7bdecd8
--- /dev/null
+++ b/kernel/trace/trace_binary/zed_sched.h
@@ -0,0 +1,73 @@
+/*
+ * zedtrace "sched" subsys event declarations
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2008-2009 Tom Zanussi <tzanussi@gmail.com>
+ */
+
+/* convention: name[0] of u8 = var data, name[0] of char = string */
+
+#ifndef _ZED_SCHED_H
+#define _ZED_SCHED_H
+
+#define sched_kthread_stop_trace_fields(subsys, event_name, FIELD) \
+	FIELD(subsys, event_name, pid, pid_t)			\
+
+#define sched_kthread_stop_ret_trace_fields(subsys, event_name, FIELD) \
+	FIELD(subsys, event_name, ret, int)			\
+
+#define sched_wait_task_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, wait_pid, pid_t)	\
+
+#define sched_wakeup_trace_fields(subsys, event_name, FIELD)		\
+	FIELD(subsys, event_name, wakeup_pid, pid_t);			\
+	FIELD(subsys, event_name, success, int);			\
+
+#define sched_wakeup_new_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, wakeup_pid, pid_t)	\
+	FIELD(subsys, event_name, success, int)	\
+
+#define sched_switch_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, prev_pid, pid_t)	\
+	FIELD(subsys, event_name, next_pid, pid_t)	\
+
+#define sched_migrate_task_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, pid, pid_t)	\
+	FIELD(subsys, event_name, orig_cpu, int)	\
+	FIELD(subsys, event_name, dest_cpu, int)	\
+
+#define sched_process_free_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, pid, pid_t)	\
+
+#define sched_process_exit_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, pid, pid_t)	\
+
+#define sched_process_wait_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, pid, pid_t)	\
+
+#define sched_process_fork_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, parent_pid, pid_t)	\
+	FIELD(subsys, event_name, child_pid, pid_t)	\
+
+#define sched_signal_send_trace_fields(subsys, event_name, FIELD)	\
+	FIELD(subsys, event_name, sig, int)	\
+	FIELD(subsys, event_name, pid, pid_t)	\
+
+extern void zed_sched_init(void);
+extern int zed_enable_sched_tracepoints(void);
+extern void zed_disable_sched_tracepoints(void);
+
+#endif /* _ZED_SCHED_H */
-- 
1.5.6.3




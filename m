Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbYLaDBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbYLaDBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 22:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbYLaC7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 21:59:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55421 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755542AbYLaC7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 21:59:36 -0500
Message-ID: <495ADF5D.4040009@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 10:56:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] ftrace: trace markers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: enable ftrace to trace markers

create <debugfs-dir>/tracing/tracing_markers.

Use binary printk for trace markers.

Active a tracing marker:
	echo -n '<marker name>' > tracing_markers
	echo -n '<marker name>:<format>' > tracing_markers
Deactive a tracing marker:
	echo -n '!<marker name>' > tracing_markers
Show all active and dead tracing markers:
	cat tracing_markers

A dead tracing markers is a tracing marker which have been deactived,
but tracing buffer may still have log information about this tracing marker,
so we must keep this tracing marker which we call it "(dead)".

example:
echo events > current_tracer

# active a marker in kernel/marker.c:add_marker():
echo -n 'core_marker_format:name %s format %s' > tracing_markers

# trigger marker "core_marker_format":
echo -n "test_name:test_fmt" > tracing_markers # will call add_marker()
echo -n "XXXXXXX:YYYYYYYY" > tracing_markers   # will call add_marker()

cat trace
...
<...>-24693 [001] 4154504421.945769: 0: core_marker_format:name test_name format test_fmt
...
<...>-24693 [001] 4154504567.229737: 0: core_marker_format:name XXXXXXX format YYYYYYYY
...

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 trace.c         |    7 +
 trace.h         |    3
 trace_bprintk.c |  239 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 249 insertions(+)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 085cc8a..d0b9fa1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2950,6 +2950,13 @@ static __init int tracer_init_debugfs(void)
 	if (!entry)
 		pr_warning("Could not create debugfs "
 			   "'trace_bprintk_formats' entry\n");
+#if CONFIG_MARKERS
+	entry = debugfs_create_file("tracing_markers", 0644, d_tracer,
+				    NULL, &trace_markers_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'tracing_markers' entry\n");
+#endif
 #endif
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c50826d..f04ae8b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -130,6 +130,9 @@ struct bprintk_entry {
 #ifdef CONFIG_TRACE_BPRINTK
 extern struct file_operations trace_bprintk_fmt_fops;
 extern int trace_bprintk_enable;
+#ifdef CONFIG_MARKERS
+extern struct file_operations trace_markers_fops;
+#endif
 #endif
 
 #define TRACE_OLD_SIZE		88
diff --git a/kernel/trace/trace_bprintk.c b/kernel/trace/trace_bprintk.c
index cbe89dd..0838580 100644
--- a/kernel/trace/trace_bprintk.c
+++ b/kernel/trace/trace_bprintk.c
@@ -20,6 +20,7 @@
 #include "trace.h"
 
 static inline void shrink_trace_bprintk_fmt(void);
+static inline void shrink_tracing_markers(void);
 
 /* binary printk basic */
 static DEFINE_MUTEX(btrace_mutex);
@@ -49,6 +50,7 @@ static void put_btrace_metadata(void)
 
 	if (!btrace_metadata_count) {
 		shrink_trace_bprintk_fmt();
+		shrink_tracing_markers();
 	}
 	unlock_btrace();
 }
@@ -235,6 +237,243 @@ struct file_operations trace_bprintk_fmt_fops = {
 	.release	= fmt_release,
 };
 
+#ifdef CONFIG_MARKERS
+/*
+ * Use binary printk for trace markers.
+ *
+ * Active a tracing marker:
+ *	echo -n '<marker name>' > tracing_markers
+ *	echo -n '<marker name>:<format>' > tracing_markers
+ * Deactive a tracing marker:
+ *	echo -n '!<marker name>' > tracing_markers
+ * Show all active and dead tracing markers:
+ *	cat tracing_markers
+ *
+ * A dead tracing markers is a tracing marker which have been deactived,
+ * but tracing buffer may still have log information about this tracing marker,
+ * so we must keep this tracing marker which we call it "(dead)".
+ */
+
+/* enum for struct marker_bprintk_struct.fmt_state */
+enum {
+	MARKER_FMT_OK,
+	MARKER_FMT_LACK,
+	MARKER_FMT_INVALID,
+};
+
+/* enum for struct marker_bprintk_struct.state */
+enum {
+	MARKER_STATE_COMING,
+	MARKER_STATE_LIVING,
+	MARKER_STATE_GOING,
+	MARKER_STATE_DEAD,
+};
+
+static LIST_HEAD(marker_list);
+
+#define MARKER_PRIVATE_STRUCT_LEN 128
+struct marker_bprintk_struct {
+	struct list_head list;
+	char *fmt;
+	int state;
+
+	/* the next two field may be modified by marker_bprintk_probe() */
+	char fmt_state;
+	/*
+	 * Field 'name' contains: "name:fmt\0" when or "name:\0"
+	 * Combining name and format as "name:fmt\0" helps us reuse
+	 * trace_vbprintk().
+	 */
+	char name[0];
+};
+#define MARKER_NAME_FMT_LEN						\
+(MARKER_PRIVATE_STRUCT_LEN - offsetof(struct marker_bprintk_struct, name))
+
+static void marker_bprintk_probe(void *probe_private, void *call_private,
+		const char *fmt, va_list *args)
+{
+	struct marker_bprintk_struct *p = probe_private;
+
+	if (p->fmt_state == MARKER_FMT_LACK) {
+		int flen = strlen(fmt);
+		if (p->fmt - p->name + flen < MARKER_NAME_FMT_LEN) {
+			memcpy(p->fmt, fmt, flen + 1);
+			p->fmt_state = MARKER_FMT_OK;
+		} else
+			p->fmt_state = MARKER_FMT_INVALID;
+	}
+
+	if (p->fmt_state == MARKER_FMT_OK)
+		trace_vbprintk(0, p->name, *args);
+}
+
+static ssize_t marker_write(struct file *file, const char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	char buf[MARKER_NAME_FMT_LEN];
+	char *name, *fmt = NULL, *colon = NULL;
+	int nlen;
+	int found = 0;
+	int ret;
+	struct marker_bprintk_struct *m;
+
+	if (count >= sizeof(buf))
+		return -E2BIG;
+
+	if (copy_from_user(buf, user_buf, count))
+		return -EFAULT;
+
+	buf[count] = 0;
+	if (buf[0] == '!') {
+		nlen = count - 1;
+		name = buf + 1;
+	} else {
+		name = buf;
+		nlen = count;
+		colon = strchr(buf, ':');
+		if (colon) {
+			nlen = colon - buf;
+			fmt = colon + 1;
+		} else if (count >= sizeof(buf) / 2)
+			return -E2BIG;
+	}
+
+	lock_btrace();
+	list_for_each_entry(m, &marker_list, list) {
+		if (!strncmp(m->name, name, nlen) && m->name[nlen] == ':') {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!(buf[0] == '!') && !found) {
+		m = kmalloc(MARKER_PRIVATE_STRUCT_LEN, GFP_KERNEL);
+		if (!m) {
+			ret = -ENOMEM;
+			goto out_locked;
+		}
+
+		memcpy(m->name, buf, count + 1);
+		if (fmt) {
+			m->fmt_state = MARKER_FMT_OK;
+			*colon = 0; /* buf is "name\0fmt\0" now */
+		} else {
+			m->name[nlen] = ':';
+			m->name[nlen + 1] = 0;
+			m->fmt_state = MARKER_FMT_LACK;
+		}
+		m->fmt = m->name + nlen + 1;
+		list_add_tail(&m->list, &marker_list);
+		m->state = MARKER_STATE_COMING;
+		unlock_btrace();
+
+		ret = marker_probe_register(name, fmt, marker_bprintk_probe, m);
+
+		lock_btrace();
+		if (ret) {
+			list_del(&m->list);
+			kfree(m);
+		} else {
+			m->state = MARKER_STATE_LIVING;
+			ret = count;
+		}
+	} else if (buf[0] == '!' && found && m->state == MARKER_STATE_LIVING) {
+		m->state = MARKER_STATE_GOING;
+		unlock_btrace();
+
+		marker_probe_unregister(name, marker_bprintk_probe, m);
+		marker_synchronize_unregister();
+
+		lock_btrace();
+		m->state = MARKER_STATE_DEAD;
+		if (!btrace_metadata_count) {
+			list_del(&m->list);
+			kfree(m);
+		}
+		ret = count;
+	} else
+		ret = -EINVAL;
+out_locked:
+	unlock_btrace();
+	return ret;
+}
+
+static inline void shrink_tracing_markers(void)
+{
+	struct marker_bprintk_struct *pos, *next;
+	list_for_each_entry_safe(pos, next, &marker_list, list) {
+		if (pos->state == MARKER_STATE_DEAD) {
+			list_del(&pos->list);
+			kfree(pos);
+		}
+	}
+}
+
+static void *marker_start(struct seq_file *m, loff_t *pos)
+{
+	lock_btrace();
+	return seq_list_start(&marker_list, *pos);
+}
+
+static void *marker_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	return seq_list_next(p, &marker_list, pos);
+}
+
+static void marker_stop(struct seq_file *m, void *p)
+{
+	unlock_btrace();
+}
+
+static int marker_show(struct seq_file *m, void *p)
+{
+	struct marker_bprintk_struct *marker_private = list_entry(p,
+			struct marker_bprintk_struct, list);
+	const char *name_fmt = marker_private->name;
+	if (marker_private->state == MARKER_STATE_DEAD)
+		seq_puts(m, "(dead) ");
+	seq_printf(m, "addr=%p marker name:fmt=%s\n", name_fmt, name_fmt);
+	return 0;
+}
+
+static struct seq_operations trace_markers_seq_ops = {
+	.start		= marker_start,
+	.next		= marker_next,
+	.stop		= marker_stop,
+	.show		= marker_show,
+};
+
+static int marker_open(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+	if (file->f_mode & FMODE_READ) {
+		ret = seq_open(file, &trace_markers_seq_ops);
+		if (!ret)
+			get_btrace_metadata();
+	}
+	return ret;
+}
+
+static int marker_release(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+	if (file->f_mode & FMODE_READ) {
+		put_btrace_metadata();
+		ret = seq_release(inode, file);
+	}
+	return ret;
+}
+
+struct file_operations trace_markers_fops = {
+	.open		= marker_open,
+	.read		= seq_read,
+	.write		= marker_write,
+	.release	= marker_release,
+};
+#else
+static inline void shrink_tracing_markers(void) {}
+#endif /* CONFIG_MARKERS */
+
 /* events tracer */
 int trace_bprintk_enable;
 










Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268AbZLVLcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbZLVLcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZLVLcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:32:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZLVLcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:32:21 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: jbaron@redhat.com, mingo@elte.hu
Cc: rostedt@goodmis.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
       Jiri Olsa <jolsa@redhat.com>
Subject: [RFC PATCH] dynamic debug - adding ring buffer storage support
Date: Tue, 22 Dec 2009 12:32:06 +0100
Message-Id: <1261481526-17630-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

as I use dynamic debug sometimes, I thought it could be useful having
the possibility to store the output somewhere else than dmesg.

The attached patch implements support for storing dynamic debug
messages to the ring buffer.

The dynamic debug allows simple addition of new flags,
so I added 'r' flag for ring buffer storage.

I used the ring buffer implementation from trace framework.

hopefuly this could be any use for others as well...
plz let me know what you think,

jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 Documentation/dynamic-debug-howto.txt |   33 ++-
 include/linux/dynamic_debug.h         |   37 ++-
 lib/Kconfig.debug                     |    9 +
 lib/Makefile                          |    1 +
 lib/dynamic_debug.c                   |   15 +
 lib/dynamic_debug_rb.c                |  501 +++++++++++++++++++++++++++++++++
 6 files changed, 588 insertions(+), 8 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 674c566..aa05764 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -208,9 +208,34 @@ The flags are:
 p
     Causes a printk() message to be emitted to dmesg
 
-Note the regexp ^[-+=][scp]+$ matches a flags specification.
+r
+    Causes messages to be emitted to the ring buffer
+    (see 'Ring buffer output' section)
+
+Note the regexp ^[-+=][pr]+$ matches a flags specification.
 Note also that there is no convenient syntax to remove all
-the flags at once, you need to use "-psc".
+the flags at once, you need to use "-pr".
+
+Ring buffer output
+==================
+
+The ring buffer output ('r' flag) is enabled by config option
+CONFIG_DYNAMIC_DEBUG_RB. Having this option set 3 files are
+created under the '<debugfs>/dynamic_debug' directory:
+
+'trace'      - displays the current content of the ring buffer
+
+'trace_pipe' - displays and consumes all the current content of
+               the ring buffer.
+
+'rb_size_kb' - displays/set the ring buffer size in kB
+
+
+The 'trace_pipe' works in a similar manner like in the tracing
+framework. You can use 'cat trace_pipe' as a blocking reader
+for the messages.
+
+The ring buffer output can be enabled together with dmesg output.
 
 Examples
 ========
@@ -238,3 +263,7 @@ nullarbor:~ # echo -n 'func svc_process -p' >
 // enable messages for NFS calls READ, READLINK, READDIR and READDIR+.
 nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
 				<debugfs>/dynamic_debug/control
+
+// enable all compiled messages output to ring buffer and dmesg
+nullarbor:~ # echo -n '+pr' >
+				<debugfs>/dynamic_debug/control
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index f8c2e17..79701ac 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -31,6 +31,7 @@ struct _ddebug {
  	 * writes commands to <debugfs>/dynamic_debug/ddebug
 	 */
 #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using the format */
+#define _DPRINTK_FLAGS_RB      (1<<1)  /* store message to the ring buffer */
 #define _DPRINTK_FLAGS_DEFAULT 0
 	unsigned int flags:8;
 } __attribute__((aligned(8)));
@@ -50,15 +51,32 @@ extern int ddebug_remove_module(char *mod_name);
 					__ret = 1;			     \
 	__ret; })
 
+#ifdef CONFIG_DYNAMIC_DEBUG_RB
+struct dentry;
+extern int dynamic_debug_rb_init(struct dentry *dir);
+extern int dynamic_debug_rb_store(const char *fmt, ...);
+#else
+static inline int dynamic_debug_rb_store(const char *fmt, ...)
+{
+	return 0;
+}
+#endif
+
 #define dynamic_pr_debug(fmt, ...) do {					\
 	static struct _ddebug descriptor				\
 	__used								\
 	__attribute__((section("__verbose"), aligned(8))) =		\
 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, DEBUG_HASH,	\
 		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
-	if (__dynamic_dbg_enabled(descriptor))				\
-		printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);		\
-	} while (0)
+	if (__dynamic_dbg_enabled(descriptor)) {			\
+		if (descriptor.flags & _DPRINTK_FLAGS_PRINT)		\
+			printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);	\
+		if (descriptor.flags & _DPRINTK_FLAGS_RB)		\
+			dynamic_debug_rb_store(KBUILD_MODNAME ":"	\
+						pr_fmt(fmt),		\
+						##__VA_ARGS__);		\
+	}								\
+} while (0)
 
 
 #define dynamic_dev_dbg(dev, fmt, ...) do {				\
@@ -67,9 +85,16 @@ extern int ddebug_remove_module(char *mod_name);
 	__attribute__((section("__verbose"), aligned(8))) =		\
 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, DEBUG_HASH,	\
 		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
-	if (__dynamic_dbg_enabled(descriptor))				\
-		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
-	} while (0)
+	if (__dynamic_dbg_enabled(descriptor)) {			\
+		if (descriptor.flags & _DPRINTK_FLAGS_PRINT)		\
+			dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);\
+		if (descriptor.flags & _DPRINTK_FLAGS_RB)		\
+			dynamic_debug_rb_store("%s %s: " fmt,		\
+					dev_driver_string(dev),		\
+					dev_name(dev),			\
+					##__VA_ARGS__);			\
+	}								\
+} while (0)
 
 #else
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9943601..eb0fdee 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1056,6 +1056,15 @@ config DYNAMIC_DEBUG
 
 	  See Documentation/dynamic-debug-howto.txt for additional information.
 
+config DYNAMIC_DEBUG_RB
+	bool "Use ring buffer for output"
+	default n
+	depends on DYNAMIC_DEBUG
+	help
+	  Enables the support for storing DYNAMIC_DEBUG messages into the
+	  ring buffer. The ring_buffer is accesable by 'trace' or 'trace_pipe'
+	  files (see Documentation/dynamic-debug-howto.txt).
+
 config DMA_API_DEBUG
 	bool "Enable debugging of DMA-API usage"
 	depends on HAVE_DMA_API_DEBUG
diff --git a/lib/Makefile b/lib/Makefile
index 347ad8d..80ad152 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -88,6 +88,7 @@ obj-$(CONFIG_HAVE_LMB) += lmb.o
 obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
 
 obj-$(CONFIG_DYNAMIC_DEBUG) += dynamic_debug.o
+obj-$(CONFIG_DYNAMIC_DEBUG_RB) += dynamic_debug_rb.o
 
 obj-$(CONFIG_NLATTR) += nlattr.o
 
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index f935029..4c322f2 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -79,6 +79,10 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 	BUG_ON(maxlen < 4);
 	if (dp->flags & _DPRINTK_FLAGS_PRINT)
 		*p++ = 'p';
+#ifdef CONFIG_DYNAMIC_DEBUG_RB
+	if (dp->flags & _DPRINTK_FLAGS_RB)
+		*p++ = 'r';
+#endif
 	if (p == buf)
 		*p++ = '-';
 	*p = '\0';
@@ -398,6 +402,11 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		case 'p':
 			flags |= _DPRINTK_FLAGS_PRINT;
 			break;
+#ifdef CONFIG_DYNAMIC_DEBUG_RB
+		case 'r':
+			flags |= _DPRINTK_FLAGS_RB;
+			break;
+#endif
 		default:
 			return -EINVAL;
 		}
@@ -758,6 +767,12 @@ static int __init dynamic_debug_init(void)
 		}
 		ret = ddebug_add_module(iter_start, n, modname);
 	}
+
+#ifdef CONFIG_DYNAMIC_DEBUG_RB
+	if (!ret)
+		ret = dynamic_debug_rb_init(dir);
+#endif
+
 out_free:
 	if (ret) {
 		ddebug_remove_all_tables();
diff --git a/lib/dynamic_debug_rb.c b/lib/dynamic_debug_rb.c
new file mode 100644
index 0000000..95c8638
--- /dev/null
+++ b/lib/dynamic_debug_rb.c
@@ -0,0 +1,501 @@
+/*
+ * lib/dynamic_debug_rb.c
+ *
+ * This file provide ring buffer storage for the dynamic
+ * debug messages. The ring buffer implementation from
+ * kernel/trace/ring_buffer.c is used.
+ *
+ * Copyright (C) 2009 Jiri Olsa <jolsa@redhat.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ring_buffer.h>
+#include <linux/debugfs.h>
+#include <linux/trace_seq.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+
+#define DDEBUG_RB_FLAGS	(RB_FL_OVERWRITE)
+#define DDEBUG_RB_SIZE	(1000)
+
+static struct ring_buffer *rb;
+static DEFINE_MUTEX(rb_lock);
+static unsigned long rb_size_kb = DDEBUG_RB_SIZE;
+
+#define DDEBUG_TRACE_SSIZE (500)
+static char *trace_str;
+
+enum {
+	DDEBUG_TRACE_ITER_READ,
+	DDEBUG_TRACE_ITER_CONS,
+};
+
+struct ddebug_trace_iter {
+	int type;
+	int cpu;
+
+	union {
+		struct {
+			struct ring_buffer_iter *rb_iter[NR_CPUS];
+			loff_t	pos;
+		} read;
+
+		struct trace_seq seq;
+	};
+};
+
+struct ddebug_trace_entry {
+	int len;
+	char data[0];
+};
+
+int dynamic_debug_rb_store(const char *fmt, ...)
+{
+	va_list args;
+	struct ring_buffer_event *event;
+	struct ddebug_trace_entry *entry;
+	char *str;
+	int rc;
+
+	/*
+	 * This code should be reentrant for multiple CPUs,
+	 * all we care about are interrupts.
+	 */
+	preempt_disable();
+	str = per_cpu_ptr(trace_str, raw_smp_processor_id());
+
+	va_start(args, fmt);
+	rc = snprintf(str, DDEBUG_TRACE_SSIZE, fmt, args);
+	va_end(args);
+
+	if (!rc)
+		goto out;
+
+	if (rc > DDEBUG_TRACE_SSIZE)
+		rc = DDEBUG_TRACE_SSIZE;
+
+	event = ring_buffer_lock_reserve(rb, rc + sizeof(*entry));
+	if (event == NULL)
+		goto out;
+
+	entry = ring_buffer_event_data(event);
+	entry->len = rc;
+	memcpy(entry->data, str, rc);
+
+	ring_buffer_unlock_commit(rb, event);
+
+out:
+	preempt_enable();
+	return 0;
+}
+EXPORT_SYMBOL(dynamic_debug_rb_store);
+
+static int dynamic_debug_rb_resize(unsigned long size)
+{
+	unsigned long val;
+
+	size <<= 10;
+
+	if (!size ||
+	    (size == rb_size_kb))
+		return -EINVAL;
+
+	if (!mutex_trylock(&rb_lock))
+		return -EBUSY;
+
+	val = ring_buffer_resize(rb, size);
+	mutex_unlock(&rb_lock);
+
+	if (val < 0)
+		return -EINVAL;
+
+	rb_size_kb = size;
+	return 0;
+}
+
+static struct ring_buffer_event *next_event(struct ddebug_trace_iter *iter,
+					    int *cpu_ret)
+{
+	struct ring_buffer_event *event = NULL;
+	struct ring_buffer_event *event_next = NULL;
+	int cpu, cpu_next = -1;
+	u64 ts, ts_next = -1;
+
+	for_each_cpu(cpu, cpu_possible_mask) {
+
+		if (iter->type == DDEBUG_TRACE_ITER_READ) {
+			struct ring_buffer_iter *rb_iter;
+
+			rb_iter = iter->read.rb_iter[cpu];
+			event = ring_buffer_iter_peek(rb_iter, &ts);
+		} else
+			event = ring_buffer_peek(rb, cpu, &ts);
+
+		if (event && (!event_next || ts < ts_next)) {
+			event_next = event;
+			cpu_next   = cpu;
+			ts_next    = ts;
+		}
+	}
+
+	*cpu_ret = cpu_next;
+	return event_next;
+}
+
+static void *s_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct ddebug_trace_iter *iter = m->private;
+	void *data;
+	int cpu;
+
+	(*pos)++;
+
+	do {
+		data = next_event(iter, &cpu);
+
+		if (data)
+			ring_buffer_read(iter->read.rb_iter[cpu], NULL);
+
+		iter->read.pos++;
+
+	} while (data && iter->read.pos < *pos);
+
+	return data;
+}
+
+static void *s_start(struct seq_file *m, loff_t *pos)
+{
+	struct ddebug_trace_iter *iter = m->private;
+
+	mutex_lock(&rb_lock);
+
+	if (*pos != iter->read.pos) {
+		struct ring_buffer_iter *rb_iter;
+		int cpu;
+
+		for_each_cpu(cpu, cpu_possible_mask) {
+			rb_iter = iter->read.rb_iter[cpu];
+			if (!rb_iter)
+				continue;
+
+			ring_buffer_iter_reset(rb_iter);
+		}
+	}
+
+	if (iter->read.pos == -1)
+		iter->read.pos++;
+
+	return s_next(m, NULL, pos);
+}
+
+static void s_stop(struct seq_file *m, void *p)
+{
+	mutex_unlock(&rb_lock);
+}
+
+static int s_show(struct seq_file *m, void *p)
+{
+	struct ring_buffer_event *event = p;
+
+	if (event) {
+		struct ddebug_trace_entry *entry;
+
+		entry = ring_buffer_event_data(event);
+		seq_write(m, entry->data, entry->len);
+	}
+
+	return 0;
+}
+
+static const struct seq_operations ddebug_trace_seqops = {
+	.start = s_start,
+	.next = s_next,
+	.show = s_show,
+	.stop = s_stop
+};
+
+static void trace_iter_free(struct ddebug_trace_iter *iter)
+{
+	int cpu;
+
+	if (iter->type == DDEBUG_TRACE_ITER_READ) {
+		for_each_cpu(cpu, cpu_possible_mask) {
+			struct ring_buffer_iter *rb_iter;
+
+			rb_iter = iter->read.rb_iter[cpu];
+			if (rb_iter)
+				ring_buffer_read_finish(rb_iter);
+		}
+	}
+
+	kfree(iter);
+}
+
+static struct ddebug_trace_iter *trace_iter_alloc(int type)
+{
+	struct ddebug_trace_iter *iter;
+	int cpu;
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (iter == NULL)
+		return NULL;
+
+	iter->type = type;
+
+	if (type == DDEBUG_TRACE_ITER_CONS)
+		return iter;
+
+	iter->read.pos = -1;
+
+	for_each_cpu(cpu, cpu_possible_mask) {
+		struct ring_buffer_iter *rb_iter;
+
+		rb_iter = ring_buffer_read_start(rb, cpu);
+		if (!rb_iter) {
+			trace_iter_free(iter);
+			return NULL;
+		}
+
+		iter->read.rb_iter[cpu] = rb_iter;
+		ring_buffer_iter_reset(rb_iter);
+	}
+
+	return iter;
+}
+
+static int check_write(struct file *file)
+{
+	if ((file->f_mode & FMODE_WRITE) &&
+	    (file->f_flags & O_TRUNC)) {
+
+		if (!mutex_trylock(&rb_lock))
+			return -EBUSY;
+
+		ring_buffer_reset(rb);
+		mutex_unlock(&rb_lock);
+	}
+
+	return 0;
+}
+
+static int trace_open(struct inode *inode, struct file *file)
+{
+	struct ddebug_trace_iter *iter;
+	int err;
+
+	if (check_write(file))
+		return -EBUSY;
+
+	iter = trace_iter_alloc(DDEBUG_TRACE_ITER_READ);
+	if (!iter)
+		return -ENOMEM;
+
+	err = seq_open(file, &ddebug_trace_seqops);
+	if (err)
+		trace_iter_free(iter);
+	else
+		((struct seq_file *) file->private_data)->private = iter;
+
+	return err;
+}
+
+static int trace_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = (struct seq_file *)file->private_data;
+	struct ddebug_trace_iter *iter = m->private;
+
+	seq_release(inode, file);
+	trace_iter_free(iter);
+	return 0;
+}
+
+static int trace_pipe_open(struct inode *inode, struct file *file)
+{
+	struct ddebug_trace_iter *iter;
+
+	if (check_write(file))
+		return -EBUSY;
+
+	iter = trace_iter_alloc(DDEBUG_TRACE_ITER_CONS);
+	if (!iter)
+		return -ENOMEM;
+
+	file->private_data = iter;
+	return 0;
+}
+
+static int trace_wait(struct file *file)
+{
+	while (ring_buffer_empty(rb)) {
+		if ((file->f_flags & O_NONBLOCK))
+			return -EAGAIN;
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(HZ / 10);
+
+		if (signal_pending(current))
+			return -EINTR;
+	}
+
+	return 0;
+}
+
+static ssize_t trace_pipe_read(struct file *file, char __user *buf,
+			       size_t size, loff_t *ppos)
+{
+	struct ddebug_trace_iter *iter = file->private_data;
+	struct ring_buffer_event *event;
+	ssize_t sret;
+	int cpu;
+	u64 ts;
+
+	sret = trace_seq_to_user(&iter->seq, buf, size);
+	if (sret != -EBUSY)
+		return sret;
+
+	trace_seq_init(&iter->seq);
+
+	mutex_lock(&rb_lock);
+
+wait:
+	sret = trace_wait(file);
+	if (sret < 0)
+		goto out;
+
+	if (size >= PAGE_SIZE)
+		size = PAGE_SIZE - 1;
+
+	while ((event = next_event(iter, &cpu))) {
+		struct ddebug_trace_entry *entry;
+
+		entry = ring_buffer_event_data(event);
+
+		if (!trace_seq_putmem(&iter->seq, entry->data, entry->len))
+			break;
+
+		ring_buffer_consume(rb, cpu, &ts);
+	}
+
+	sret = trace_seq_to_user(&iter->seq, buf, size);
+	if (sret == -EBUSY)
+		goto wait;
+
+out:
+	mutex_unlock(&rb_lock);
+	return sret;
+}
+
+static ssize_t rb_size_kb_write(struct file *filp, const char __user *ubuf,
+				size_t cnt, loff_t *ppos)
+{
+	unsigned long val;
+	char buf[64];
+	int ret;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	ret = dynamic_debug_rb_resize(val);
+	if (ret < 0)
+		return ret;
+
+	return cnt;
+}
+
+static ssize_t rb_size_kb_read(struct file *file, char __user *ubuf,
+			       size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+	int r;
+
+	r = sprintf(buf, "%lu\n", rb_size_kb);
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static int trace_pipe_release(struct inode *inode, struct file *file)
+{
+	struct ddebug_trace_iter *iter = file->private_data;
+	trace_iter_free(iter);
+	return 0;
+}
+
+static const struct file_operations trace_fops = {
+	.owner = THIS_MODULE,
+	.open = trace_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = trace_release,
+};
+
+static const struct file_operations trace_pipe_fops = {
+	.owner = THIS_MODULE,
+	.open = trace_pipe_open,
+	.read = trace_pipe_read,
+	.release = trace_pipe_release,
+};
+
+static const struct file_operations rb_size_kb_fops = {
+	.owner = THIS_MODULE,
+	.read  = rb_size_kb_read,
+	.write = rb_size_kb_write,
+};
+
+int __init dynamic_debug_rb_init(struct dentry *dir)
+{
+	struct dentry *file_trace;
+	struct dentry *file_trace_pipe;
+	struct dentry *file_rb_size_kb;
+
+	rb = ring_buffer_alloc(rb_size_kb,
+			       DDEBUG_RB_FLAGS);
+	if (!rb) {
+		printk(KERN_ERR "failed to allocate ring buffer!\n");
+		return -ENOMEM;
+	}
+
+	file_trace = debugfs_create_file("trace", 0644, dir, NULL,
+					 &trace_fops);
+	if (!file_trace) {
+		printk(KERN_ERR "failed to create 'trace' file!\n");
+		goto out_free_rb;
+	}
+
+	file_trace_pipe = debugfs_create_file("trace_pipe", 0644, dir, NULL,
+					      &trace_pipe_fops);
+	if (!file_trace_pipe) {
+		printk(KERN_ERR "failed to create 'trace_pipe' file!\n");
+		goto out_free_trace;
+	}
+
+	file_rb_size_kb = debugfs_create_file("rb_size_kb", 0644, dir, NULL,
+					      &rb_size_kb_fops);
+	if (!file_rb_size_kb) {
+		printk(KERN_ERR "failed to create 'rb_size_kb' file!\n");
+		goto out_free_trace_pipe;
+	}
+
+	trace_str = __alloc_percpu(DDEBUG_TRACE_SSIZE,
+				   cache_line_size());
+	if (trace_str)
+		return 0;
+
+out_free_trace_pipe:
+	debugfs_remove(file_trace_pipe);
+
+out_free_trace:
+	debugfs_remove(file_trace);
+
+out_free_rb:
+	ring_buffer_free(rb);
+	return -ENOMEM;
+}

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYKKUqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYKKUqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYKKUqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:46:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51675 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYKKUqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:46:24 -0500
Message-Id: <20081111204622.567160839@goodmis.org>
References: <20081111204555.890501283@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 11 Nov 2008 15:45:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] ring-buffer: buffer record on/off switch
Content-Disposition: inline; filename=0001-ring-buffer-buffer-record-on-off-switch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: enable/disable ring buffer recording API added

Several kernel developers have requested that there be a way to stop
recording into the ring buffers with a simple switch that can also
be enabled from userspace. This patch addes a new kernel API to the
ring buffers called:

 tracing_on()
 tracing_off()

When tracing_off() is called, all ring buffers will not be able to record
into their buffers.

tracing_on() will enable the ring buffers again.

These two act like an on/off switch. That is, there is no counting of the
number of times tracing_off or tracing_on has been called.

A new file is added to the debugfs/tracing directory called

  tracing_on

This allows for userspace applications to also flip the switch.

  echo 0 > debugfs/tracing/tracing_on

disables the tracing.

  echo 1 > /debugfs/tracing/tracing_on

enables it.

Note, this does not disable or enable any tracers. It only sets or clears
a flag that needs to be set in order for the ring buffers to write to
their buffers. It is a global flag, and affects all ring buffers.

The buffers start out with tracing_on enabled.

There are now three flags that control recording into the buffers:

 tracing_on: which affects all ring buffer tracers.

 buffer->record_disabled: which affects an allocated buffer, which may be set
     if an anomaly is detected, and tracing is disabled.

 cpu_buffer->record_disabled: which is set by tracing_stop() or if an
     anomaly is detected. tracing_start can not reenable this if
     an anomaly occurred.

The userspace debugfs/tracing/tracing_enabled is implemented with
tracing_stop() but the user space code can not enable it if the kernel
called tracing_stop().

Userspace can enable the tracing_on even if the kernel disabled it.
It is just a switch used to stop tracing if a condition was hit.
tracing_on is not for protecting critical areas in the kernel nor is
it for stopping tracing if an anomaly occurred. This is because userspace
can reenable it at any time.

Side effect: With this patch, I discovered a dead variable in ftrace.c
  called tracing_on. This patch removes it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ring_buffer.h |    3 +
 kernel/trace/ftrace.c       |    8 +---
 kernel/trace/ring_buffer.c  |   99 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+), 6 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 536b0ca..e097c2e 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -120,6 +120,9 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
 u64 ring_buffer_time_stamp(int cpu);
 void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
 
+void tracing_on(void);
+void tracing_off(void);
+
 enum ring_buffer_flags {
 	RB_FL_OVERWRITE		= 1 << 0,
 };
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f03fe74..beb21a5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -212,7 +212,6 @@ enum {
 };
 
 static int ftrace_filtered;
-static int tracing_on;
 
 static LIST_HEAD(ftrace_new_addrs);
 
@@ -533,13 +532,10 @@ static int __ftrace_modify_code(void *data)
 {
 	int *command = data;
 
-	if (*command & FTRACE_ENABLE_CALLS) {
+	if (*command & FTRACE_ENABLE_CALLS)
 		ftrace_replace_code(1);
-		tracing_on = 1;
-	} else if (*command & FTRACE_DISABLE_CALLS) {
+	else if (*command & FTRACE_DISABLE_CALLS)
 		ftrace_replace_code(0);
-		tracing_on = 0;
-	}
 
 	if (*command & FTRACE_UPDATE_TRACE_FUNC)
 		ftrace_update_ftrace_func(ftrace_trace_function);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a6b8f9d..0a4f5c3 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -18,6 +18,33 @@
 
 #include "trace.h"
 
+/* Global flag to disable all recording to ring buffers */
+static int ring_buffers_off __read_mostly;
+
+/**
+ * tracing_on - enable all tracing buffers
+ *
+ * This function enables all tracing buffers that may have been
+ * disabled with tracing_off.
+ */
+void tracing_on(void)
+{
+	ring_buffers_off = 0;
+}
+
+/**
+ * tracing_off - turn off all tracing buffers
+ *
+ * This function stops all tracing buffers from recording data.
+ * It does not disable any overhead the tracers themselves may
+ * be causing. This function simply causes all recording to
+ * the ring buffers to fail.
+ */
+void tracing_off(void)
+{
+	ring_buffers_off = 1;
+}
+
 /* Up this if you want to test the TIME_EXTENTS and normalization */
 #define DEBUG_SHIFT 0
 
@@ -1169,6 +1196,9 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer,
 	struct ring_buffer_event *event;
 	int cpu, resched;
 
+	if (ring_buffers_off)
+		return NULL;
+
 	if (atomic_read(&buffer->record_disabled))
 		return NULL;
 
@@ -1278,6 +1308,9 @@ int ring_buffer_write(struct ring_buffer *buffer,
 	int ret = -EBUSY;
 	int cpu, resched;
 
+	if (ring_buffers_off)
+		return -EBUSY;
+
 	if (atomic_read(&buffer->record_disabled))
 		return -EBUSY;
 
@@ -2103,3 +2136,69 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	return 0;
 }
 
+static ssize_t
+rb_simple_read(struct file *filp, char __user *ubuf,
+	       size_t cnt, loff_t *ppos)
+{
+	int *p = filp->private_data;
+	char buf[64];
+	int r;
+
+	/* !ring_buffers_off == tracing_on */
+	r = sprintf(buf, "%d\n", !*p);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
+rb_simple_write(struct file *filp, const char __user *ubuf,
+		size_t cnt, loff_t *ppos)
+{
+	int *p = filp->private_data;
+	char buf[64];
+	long val;
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
+	/* !ring_buffers_off == tracing_on */
+	*p = !val;
+
+	(*ppos)++;
+
+	return cnt;
+}
+
+static struct file_operations rb_simple_fops = {
+	.open		= tracing_open_generic,
+	.read		= rb_simple_read,
+	.write		= rb_simple_write,
+};
+
+
+static __init int rb_init_debugfs(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+
+	entry = debugfs_create_file("tracing_on", 0644, d_tracer,
+				    &ring_buffers_off, &rb_simple_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'tracing_on' entry\n");
+
+	return 0;
+}
+
+fs_initcall(rb_init_debugfs);
-- 
1.5.6.5

-- 

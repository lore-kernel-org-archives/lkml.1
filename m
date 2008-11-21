Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbYKUUcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbYKUUcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 15:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbYKUUbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 15:31:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33669 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbYKUUbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 15:31:03 -0500
Message-Id: <20081121203100.648463116@goodmis.org>
References: <20081121202932.281682721@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Nov 2008 15:29:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Fleming <mjf@gentoo.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Sam Ravnborg <sam@ravnborg.org>, Jim Radford <radford@galvanix.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] ring-buffer: add tracing_off_permanent
Content-Disposition: inline; filename=0003-ring-buffer-add-tracing_off_permanent.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: feature to permanently disable ring buffer

This patch adds a API to the ring buffer code that will permanently
disable the ring buffer from ever recording. This should only be
called when some serious anomaly is detected, and the system
may be in an unstable state. When that happens, shutting down the
recording to the ring buffers may be appropriate.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ring_buffer.h |    1 +
 kernel/trace/ring_buffer.c  |   79 ++++++++++++++++++++++++++++++++++++-------
 2 files changed, 67 insertions(+), 13 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index e097c2e..3bb87a7 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -122,6 +122,7 @@ void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
 
 void tracing_on(void);
 void tracing_off(void);
+void tracing_off_permanent(void);
 
 enum ring_buffer_flags {
 	RB_FL_OVERWRITE		= 1 << 0,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 85ced14..e206951 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -18,8 +18,46 @@
 
 #include "trace.h"
 
-/* Global flag to disable all recording to ring buffers */
-static int ring_buffers_off __read_mostly;
+/*
+ * A fast way to enable or disable all ring buffers is to
+ * call tracing_on or tracing_off. Turning off the ring buffers
+ * prevents all ring buffers from being recorded to.
+ * Turning this switch on, makes it OK to write to the
+ * ring buffer, if the ring buffer is enabled itself.
+ *
+ * There's three layers that must be on in order to write
+ * to the ring buffer.
+ *
+ * 1) This global flag must be set.
+ * 2) The ring buffer must be enabled for recording.
+ * 3) The per cpu buffer must be enabled for recording.
+ *
+ * In case of an anomaly, this global flag has a bit set that
+ * will permantly disable all ring buffers.
+ */
+
+/*
+ * Global flag to disable all recording to ring buffers
+ *  This has two bits: ON, DISABLED
+ *
+ *  ON   DISABLED
+ * ---- ----------
+ *   0      0        : ring buffers are off
+ *   1      0        : ring buffers are on
+ *   X      1        : ring buffers are permanently disabled
+ */
+
+enum {
+	RB_BUFFERS_ON_BIT	= 0,
+	RB_BUFFERS_DISABLED_BIT	= 1,
+};
+
+enum {
+	RB_BUFFERS_ON		= 1 << RB_BUFFERS_ON_BIT,
+	RB_BUFFERS_DISABLED	= 1 << RB_BUFFERS_DISABLED_BIT,
+};
+
+static long ring_buffer_flags __read_mostly = RB_BUFFERS_ON;
 
 /**
  * tracing_on - enable all tracing buffers
@@ -29,7 +67,7 @@ static int ring_buffers_off __read_mostly;
  */
 void tracing_on(void)
 {
-	ring_buffers_off = 0;
+	set_bit(RB_BUFFERS_ON_BIT, &ring_buffer_flags);
 }
 
 /**
@@ -42,7 +80,18 @@ void tracing_on(void)
  */
 void tracing_off(void)
 {
-	ring_buffers_off = 1;
+	clear_bit(RB_BUFFERS_ON_BIT, &ring_buffer_flags);
+}
+
+/**
+ * tracing_off_permanent - permanently disable ring buffers
+ *
+ * This function, once called, will disable all ring buffers
+ * permanenty.
+ */
+void tracing_off_permanent(void)
+{
+	set_bit(RB_BUFFERS_DISABLED_BIT, &ring_buffer_flags);
 }
 
 #include "trace.h"
@@ -1185,7 +1234,7 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer,
 	struct ring_buffer_event *event;
 	int cpu, resched;
 
-	if (ring_buffers_off)
+	if (ring_buffer_flags != RB_BUFFERS_ON)
 		return NULL;
 
 	if (atomic_read(&buffer->record_disabled))
@@ -1297,7 +1346,7 @@ int ring_buffer_write(struct ring_buffer *buffer,
 	int ret = -EBUSY;
 	int cpu, resched;
 
-	if (ring_buffers_off)
+	if (ring_buffer_flags != RB_BUFFERS_ON)
 		return -EBUSY;
 
 	if (atomic_read(&buffer->record_disabled))
@@ -2178,12 +2227,14 @@ static ssize_t
 rb_simple_read(struct file *filp, char __user *ubuf,
 	       size_t cnt, loff_t *ppos)
 {
-	int *p = filp->private_data;
+	long *p = filp->private_data;
 	char buf[64];
 	int r;
 
-	/* !ring_buffers_off == tracing_on */
-	r = sprintf(buf, "%d\n", !*p);
+	if (test_bit(RB_BUFFERS_DISABLED_BIT, p))
+		r = sprintf(buf, "permanently disabled\n");
+	else
+		r = sprintf(buf, "%d\n", test_bit(RB_BUFFERS_ON_BIT, p));
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
@@ -2192,7 +2243,7 @@ static ssize_t
 rb_simple_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
-	int *p = filp->private_data;
+	long *p = filp->private_data;
 	char buf[64];
 	long val;
 	int ret;
@@ -2209,8 +2260,10 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 	if (ret < 0)
 		return ret;
 
-	/* !ring_buffers_off == tracing_on */
-	*p = !val;
+	if (val)
+		set_bit(RB_BUFFERS_ON_BIT, p);
+	else
+		clear_bit(RB_BUFFERS_ON_BIT, p);
 
 	(*ppos)++;
 
@@ -2232,7 +2285,7 @@ static __init int rb_init_debugfs(void)
 	d_tracer = tracing_init_dentry();
 
 	entry = debugfs_create_file("tracing_on", 0644, d_tracer,
-				    &ring_buffers_off, &rb_simple_fops);
+				    &ring_buffer_flags, &rb_simple_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs 'tracing_on' entry\n");
 
-- 
1.5.6.5

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbZLCS7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbZLCS7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbZLCS73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:59:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541AbZLCS73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:59:29 -0500
Date: Thu, 3 Dec 2009 19:59:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes for v2.6.33
Message-ID: <20091203185923.GA25434@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

These are the tracing fixes that spilled over from the last -rc cycle of 
v2.6.32.

 Thanks,

	Ingo

------------------>
Carsten Emde (1):
      tracing: Fix trace_marker output

Johannes Berg (1):
      tracing: Fix event format export

Roel Kluin (1):
      tracing: Fix return value of tracing_stats_read()


 include/trace/ftrace.h |    2 +-
 kernel/trace/trace.c   |   41 +++++++++++++++--------------------------
 2 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index cc0d966..dacb8ef 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -159,7 +159,7 @@
 #undef __get_str
 
 #undef TP_printk
-#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
+#define TP_printk(fmt, args...) "\"%s\", %s\n", fmt, __stringify(args)
 
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b20d3ec..12b49ca 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1361,10 +1361,11 @@ int trace_array_vprintk(struct trace_array *tr,
 	pause_graph_tracing();
 	raw_local_irq_save(irq_flags);
 	__raw_spin_lock(&trace_buf_lock);
-	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
-
-	len = min(len, TRACE_BUF_SIZE-1);
-	trace_buf[len] = 0;
+	if (args == NULL) {
+		strncpy(trace_buf, fmt, TRACE_BUF_SIZE);
+		len = strlen(trace_buf);
+	} else
+		len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
 
 	size = sizeof(*entry) + len + 1;
 	buffer = tr->buffer;
@@ -1373,10 +1374,10 @@ int trace_array_vprintk(struct trace_array *tr,
 	if (!event)
 		goto out_unlock;
 	entry = ring_buffer_event_data(event);
-	entry->ip			= ip;
+	entry->ip = ip;
 
 	memcpy(&entry->buf, trace_buf, len);
-	entry->buf[len] = 0;
+	entry->buf[len] = '\0';
 	if (!filter_check_discard(call, entry, buffer, event))
 		ring_buffer_unlock_commit(buffer, event);
 
@@ -3319,22 +3320,11 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
-static int mark_printk(const char *fmt, ...)
-{
-	int ret;
-	va_list args;
-	va_start(args, fmt);
-	ret = trace_vprintk(0, fmt, args);
-	va_end(args);
-	return ret;
-}
-
 static ssize_t
 tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
 {
 	char *buf;
-	char *end;
 
 	if (tracing_disabled)
 		return -EINVAL;
@@ -3342,7 +3332,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	if (cnt > TRACE_BUF_SIZE)
 		cnt = TRACE_BUF_SIZE;
 
-	buf = kmalloc(cnt + 1, GFP_KERNEL);
+	buf = kmalloc(cnt + 2, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
 
@@ -3350,14 +3340,13 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 		kfree(buf);
 		return -EFAULT;
 	}
+	if (buf[cnt-1] != '\n') {
+		buf[cnt] = '\n';
+		buf[cnt+1] = '\0';
+	} else
+		buf[cnt] = '\0';
 
-	/* Cut from the first nil or newline. */
-	buf[cnt] = '\0';
-	end = strchr(buf, '\n');
-	if (end)
-		*end = '\0';
-
-	cnt = mark_printk("%s\n", buf);
+	cnt = trace_vprintk(0, buf, NULL);
 	kfree(buf);
 	*fpos += cnt;
 
@@ -3730,7 +3719,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
-		return ENOMEM;
+		return -ENOMEM;
 
 	trace_seq_init(s);
 

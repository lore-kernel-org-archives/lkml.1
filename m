Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbYD0TeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbYD0TeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762250AbYD0TeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:34:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:46065 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762197AbYD0TeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=q5IOuu8/ByhcxOQhNjp9DtF0MyvBiCgnFyrjPJuXHqoKKGENoLA2lW4+72pET7nA9efYNAUfCi7wDASlqBJqyQdtVTzx5bcFanyHCbJhZ3Yio+mQUaUHeRSW/haGyYzHaQojWtEy8R3/APeMroX7y4IoHlVH+1fQMxqJuK7Rbso=
Date: Sun, 27 Apr 2008 22:33:59 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Paalanen <pq@iki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Pavel Roskin <proski@gnu.org>
Subject: [PATCH 1/5] ftrace: add readpos to struct trace_seq; add
 trace_seq_to_user()
Message-ID: <20080427223359.1408aef4@daedalus.pq.iki.fi>
In-Reply-To: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
References: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c69153a56ddcdc09a2135a4d9cbf95ab4bdd08a0 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sat, 26 Apr 2008 21:58:39 +0300
Subject: [PATCH] ftrace: add readpos to struct trace_seq; add trace_seq_to_user()

Refactor code from tracing_read_pipe() and create trace_seq_to_user().
Moved trace_seq_reset() call before iter->trace->read() call so that
when all leftover data is returned, trace_seq is reset automatically.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---

Steven,

do you approve this?


 kernel/trace/trace.c |   73 ++++++++++++++++++++++++-------------------------
 kernel/trace/trace.h |    3 ++
 2 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 04366ae..06c85b3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -403,6 +403,26 @@ static void
 trace_seq_reset(struct trace_seq *s)
 {
 	s->len = 0;
+	s->readpos = 0;
+}
+
+ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
+{
+	int len;
+	int ret;
+
+	if (s->len <= s->readpos)
+		return -EBUSY;
+
+	len = s->len - s->readpos;
+	if (cnt > len)
+		cnt = len;
+	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
+	if (ret)
+		return -EFAULT;
+
+	s->readpos += len;
+	return cnt;
 }
 
 static void
@@ -2406,46 +2426,32 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 	struct trace_iterator *iter = filp->private_data;
 	struct trace_array_cpu *data;
 	static cpumask_t mask;
-	static int start;
 	unsigned long flags;
 #ifdef CONFIG_FTRACE
 	int ftrace_save;
 #endif
-	int read = 0;
 	int cpu;
-	int len;
-	int ret;
+	ssize_t sret;
 
 	/* return any leftover data */
-	if (iter->seq.len > start) {
-		len = iter->seq.len - start;
-		if (cnt > len)
-			cnt = len;
-		ret = copy_to_user(ubuf, iter->seq.buffer + start, cnt);
-		if (ret)
-			cnt = -EFAULT;
-
-		start += len;
+	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
+	if (sret != -EBUSY)
+		return sret;
+	sret = 0;
 
-		return cnt;
-	}
+	trace_seq_reset(&iter->seq);
 
 	mutex_lock(&trace_types_lock);
 	if (iter->trace->read) {
-		ret = iter->trace->read(iter, filp, ubuf, cnt, ppos);
-		if (ret) {
-			read = ret;
+		sret = iter->trace->read(iter, filp, ubuf, cnt, ppos);
+		if (sret)
 			goto out;
-		}
 	}
 
-	trace_seq_reset(&iter->seq);
-	start = 0;
-
 	while (trace_empty(iter)) {
 
 		if ((filp->f_flags & O_NONBLOCK)) {
-			read = -EAGAIN;
+			sret = -EAGAIN;
 			goto out;
 		}
 
@@ -2471,7 +2477,7 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 		iter->tr->waiter = NULL;
 
 		if (signal_pending(current)) {
-			read = -EINTR;
+			sret = -EINTR;
 			goto out;
 		}
 
@@ -2541,6 +2547,7 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 	}
 
 	while (find_next_entry_inc(iter) != NULL) {
+		int ret;
 		int len = iter->seq.len;
 
 		ret = print_trace_line(iter);
@@ -2571,24 +2578,16 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 	local_irq_restore(flags);
 
 	/* Now copy what we have to the user */
-	read = iter->seq.len;
-	if (read > cnt)
-		read = cnt;
-
-	ret = copy_to_user(ubuf, iter->seq.buffer, read);
-
-	if (read < iter->seq.len)
-		start = read;
-	else
+	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
+	if (iter->seq.readpos >= iter->seq.len)
 		trace_seq_reset(&iter->seq);
-
-	if (ret)
-		read = -EFAULT;
+	if (sret == -EBUSY)
+		sret = 0;
 
 out:
 	mutex_unlock(&trace_types_lock);
 
-	return read;
+	return sret;
 }
 
 static ssize_t
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a151c87..3e15c23 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -160,6 +160,7 @@ struct tracer {
 struct trace_seq {
 	unsigned char		buffer[PAGE_SIZE];
 	unsigned int		len;
+	unsigned int		readpos;
 };
 
 /*
@@ -303,6 +304,8 @@ extern int trace_selftest_startup_sysprof(struct tracer *trace,
 
 extern void *head_page(struct trace_array_cpu *data);
 extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
+extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
+				 size_t cnt);
 extern long ns2usecs(cycle_t nsec);
 
 extern unsigned long trace_flags;
-- 
1.5.3.7


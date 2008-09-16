Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbYIPTHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbYIPTHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYIPTGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:06:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:47024 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbYIPTGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:06:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=YA3TdK/73aflYjeZYr38D/o+CqcvTLy4B4j0dcjRf4hByfGwmIOSNLpFPMBaSRDYAL
         MOPwEhO5dRXhB04277CIYEYXyC7oKqejcrK4s5rZnnpgh0UUDjFpXmypZgH5icDoG99j
         cbWFXzqb0seVTsoZaFQ/jMwEA0dReIF0npNmY=
Date: Tue, 16 Sep 2008 22:06:42 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       Pavel Roskin <proski@gnu.org>
Subject: [PATCH 7/7] ftrace: inject markers via trace_marker file.
Message-ID: <20080916220642.52ba5bdb@daedalus.pq.iki.fi>
In-Reply-To: <20080916215416.16aee2dd@daedalus.pq.iki.fi>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	<20080828214256.296e34ec@daedalus.pq.iki.fi>
	<c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	<20080904203058.7e57729e@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
	<20080915224707.76b2cca0@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
	<20080916215416.16aee2dd@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9be308e4ea3af69cebb29930757d6457f762866d Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 14 Sep 2008 22:34:35 +0300
Subject: [PATCH] ftrace: inject markers via trace_marker file.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Allow a user to inject a marker (TRACE_PRINT entry) into the trace ring
buffer. The related file operations are derived from code by Frédéric
Weisbecker <fweisbec@gmail.com>.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 Documentation/tracers/mmiotrace.txt |    5 +-
 kernel/trace/trace.c                |   76 ++++++++++++++++++++++++++++++++--
 kernel/trace/trace.h                |    4 ++
 3 files changed, 77 insertions(+), 8 deletions(-)

diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/tracers/mmiotrace.txt
index a4afb56..5bbbe20 100644
--- a/Documentation/tracers/mmiotrace.txt
+++ b/Documentation/tracers/mmiotrace.txt
@@ -36,7 +36,7 @@ $ mount -t debugfs debugfs /debug
 $ echo mmiotrace > /debug/tracing/current_tracer
 $ cat /debug/tracing/trace_pipe > mydump.txt &
 Start X or whatever.
-$ echo "X is up" > /debug/tracing/marker
+$ echo "X is up" > /debug/tracing/trace_marker
 $ echo none > /debug/tracing/current_tracer
 Check for lost events.
 
@@ -59,9 +59,8 @@ The 'cat' process should stay running (sleeping) in the background.
 Load the driver you want to trace and use it. Mmiotrace will only catch MMIO
 accesses to areas that are ioremapped while mmiotrace is active.
 
-[Unimplemented feature:]
 During tracing you can place comments (markers) into the trace by
-$ echo "X is up" > /debug/tracing/marker
+$ echo "X is up" > /debug/tracing/trace_marker
 This makes it easier to see which part of the (huge) trace corresponds to
 which action. It is recommended to place descriptive markers about what you
 do.
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7e7154f..eee1fd9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2879,6 +2879,66 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static int tracing_open_mark(struct inode *inode, struct file *filp)
+{
+	int ret;
+
+	ret = tracing_open_generic(inode, filp);
+	if (ret)
+		return ret;
+
+	if (current_trace == &no_tracer)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int mark_printk(const char *fmt, ...)
+{
+	int ret;
+	va_list args;
+	va_start(args, fmt);
+	ret = trace_vprintk(0, fmt, args);
+	va_end(args);
+	return ret;
+}
+
+static ssize_t
+tracing_mark_write(struct file *filp, const char __user *ubuf,
+					size_t cnt, loff_t *fpos)
+{
+	char *buf;
+	char *end;
+	struct trace_array *tr = &global_trace;
+
+	if (current_trace == &no_tracer || !tr->ctrl || tracing_disabled)
+		return -EINVAL;
+
+	if (cnt > TRACE_BUF_SIZE)
+		cnt = TRACE_BUF_SIZE;
+
+	buf = kmalloc(cnt + 1, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, ubuf, cnt)) {
+		kfree(buf);
+		return -EFAULT;
+	}
+
+	/* Cut from the first nil or newline. */
+	buf[cnt] = '\0';
+	end = strchr(buf, '\n');
+	if (end)
+		*end = '\0';
+
+	cnt = mark_printk("%s\n", buf);
+	kfree(buf);
+	*fpos += cnt;
+
+	return cnt;
+}
+
 static struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -2910,6 +2970,11 @@ static struct file_operations tracing_entries_fops = {
 	.write		= tracing_entries_write,
 };
 
+static struct file_operations tracing_mark_fops = {
+	.open		= tracing_open_mark,
+	.write		= tracing_mark_write,
+};
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 static ssize_t
@@ -3027,6 +3092,12 @@ static __init void tracer_init_debugfs(void)
 		pr_warning("Could not create debugfs "
 			   "'trace_entries' entry\n");
 
+	entry = debugfs_create_file("trace_marker", 0220, d_tracer,
+				    NULL, &tracing_mark_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'trace_marker' entry\n");
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 				    &ftrace_update_tot_cnt,
@@ -3040,11 +3111,6 @@ static __init void tracer_init_debugfs(void)
 #endif
 }
 
-#define TRACE_BUF_SIZE 1024
-#define TRACE_PRINT_BUF_SIZE \
-	(sizeof(struct trace_field) - offsetof(struct trace_field, print.buf))
-#define TRACE_CONT_BUF_SIZE sizeof(struct trace_field)
-
 int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 {
 	static DEFINE_SPINLOCK(trace_buf_lock);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 648433d..42f65d0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -124,6 +124,10 @@ struct trace_entry {
 };
 
 #define TRACE_ENTRY_SIZE	sizeof(struct trace_entry)
+#define TRACE_BUF_SIZE		1024
+#define TRACE_PRINT_BUF_SIZE \
+	(sizeof(struct trace_field) - offsetof(struct trace_field, print.buf))
+#define TRACE_CONT_BUF_SIZE	sizeof(struct trace_field)
 
 /*
  * The CPU trace array - it consists of thousands of trace entries
-- 
1.5.6.4


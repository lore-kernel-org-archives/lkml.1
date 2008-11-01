Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbYKAS54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbYKAS54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 14:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYKAS5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 14:57:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:44173 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYKAS5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 14:57:48 -0400
Subject: Re: [PATCH] ftrace: ftrace_dump_on_oops=[tracer]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811011441210.13362@gandalf.stny.rr.com>
References: <1225544744.21456.38.camel@lappy.programming.kicks-ass.net>
	 <alpine.DEB.1.10.0811011441210.13362@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Sat, 01 Nov 2008 19:57:37 +0100
Message-Id: <1225565857.21456.51.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-01 at 14:43 -0400, Steven Rostedt wrote:
> On Sat, 1 Nov 2008, Peter Zijlstra wrote:
> 
> > seems useful to debug crashes that happen before I read userspace.
> 
> Hmm, I think it might be better to separate this from the dump_on_oops.
> How about a ftrace_default_tracer parameter?
> 
> If one is defined, it is activated as soon as it is initialized. This way 
> we decouple the dump_on_oops, which we may not always want, and a way to 
> start tracers before the switch to user space.

Like so?

---
Subject: ftrace: enable setting an ftrace tracer on boot

In order to facilitate early boot trouble, allow one to specify a tracer
on the kernel boot line.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d2c115b..4d694fd 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -765,6 +765,14 @@ and is between 256 and 4096 characters. It is defined in the file
 			parameter will force ia64_sal_cache_flush to call
 			ia64_pal_cache_flush instead of SAL_CACHE_FLUSH.
 
+	ftrace=[tracer]
+			[ftrace] will set and start the specified tracer
+			as early as possible in order to facilitate early
+			boot debugging.
+
+	ftrace_dump_on_oops
+			[ftrace] will dump the trace buffers on oops.
+
 	gamecon.map[2|3]=
 			[HW,JOY] Multisystem joystick and NES/SNES/PSX pad
 			support via parallel port (up to 5 devices per port)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5b8c90d..a85187a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -79,6 +79,15 @@ static int tracing_disabled = 1;
  */
 int ftrace_dump_on_oops;
 
+static int tracing_set_tracer(char *buf);
+
+static int __init set_ftrace(char *str)
+{
+	tracing_set_tracer(str);
+	return 1;
+}
+__setup("ftrace", set_ftrace);
+
 static int __init set_ftrace_dump_on_oops(char *str)
 {
 	ftrace_dump_on_oops = 1;
@@ -2394,29 +2403,11 @@ tracing_set_trace_read(struct file *filp, char __user *ubuf,
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
-static ssize_t
-tracing_set_trace_write(struct file *filp, const char __user *ubuf,
-			size_t cnt, loff_t *ppos)
+static int tracing_set_tracer(char *buf)
 {
 	struct trace_array *tr = &global_trace;
 	struct tracer *t;
-	char buf[max_tracer_type_len+1];
-	int i;
-	size_t ret;
-
-	ret = cnt;
-
-	if (cnt > max_tracer_type_len)
-		cnt = max_tracer_type_len;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	/* strip ending whitespace. */
-	for (i = cnt - 1; i > 0 && isspace(buf[i]); i--)
-		buf[i] = 0;
+	int ret = 0;
 
 	mutex_lock(&trace_types_lock);
 	for (t = trace_types; t; t = t->next) {
@@ -2440,6 +2431,33 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
  out:
 	mutex_unlock(&trace_types_lock);
 
+	return ret;
+}
+
+static ssize_t
+tracing_set_trace_write(struct file *filp, const char __user *ubuf,
+			size_t cnt, loff_t *ppos)
+{
+	char buf[max_tracer_type_len+1];
+	int i;
+	size_t ret;
+
+	if (cnt > max_tracer_type_len)
+		cnt = max_tracer_type_len;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	/* strip ending whitespace. */
+	for (i = cnt - 1; i > 0 && isspace(buf[i]); i--)
+		buf[i] = 0;
+
+	ret = tracing_set_tracer(buf);
+	if (!ret)
+		ret = cnt;
+
 	if (ret > 0)
 		filp->f_pos += ret;
 



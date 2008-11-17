Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbYKQSX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbYKQSX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYKQSXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:23:50 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:37602 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbYKQSXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:23:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iru63ZTcaV5RLhjQq0KxkiRcVjsz5T/lWN0e91OAdpq72UEncKrDOCVShyvGR+xd7x
         2V4HDQZCSLkwTB0UAGuMlfhTOBPa6wQ8C8473WwlFK+pFuQur1bMv11EoKyNKmMPO6IC
         iq5rpvOES9wJ8Y5RP2t8XhPN4VQXnYAE6+R6Q=
Message-ID: <4921B6AE.5090608@gmail.com>
Date: Mon, 17 Nov 2008 19:23:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing/ftrace: implement a set_flag callback for
 tracers
References: <4920D402.3000803@gmail.com> <20081117084524.GB28786@elte.hu>
In-Reply-To: <20081117084524.GB28786@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> i've got some syntactic nits:
> 

> 
> magic constant '3' needs a comment at least.
> 

> 
> how about making a dummy empty trace_opts for all tracers (set by 
> plugin init if the init function finds a NULL there) - that way the 
> 'if (trace_opts)' can go away and you can just iterate away on that 
> array of options.

 
> one tab too much. Also, the condition can be avoided by creating a 
> dummy ->set_flag() that just returns 0.
> 


> 
> variable should be one line higher, to not break the upside down 
> christmas tree layout. [ :-) ]
> 

> 
> please look at the file you modify and try to clone the micro-style it 
> follows. For example in this file it would be more standard to use 
> vertical alignment for structure definitions:
> 

> ditto - here the new field deviates from he existing style.
> 
> also note how the 'int set);' line is unnecessarily broken to a 
> separate line - it could be in the same line where the set_flag field 
> begins.
> 

> 
> spurious looking newline insertion.
> 
> 	Ingo

Ok. That's fixed in the patch below. I hope I haven't missed something.
--
>From 93a0793dad5bb7937ccba6f4f4a8cc13ad18d2f9 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 17 Nov 2008 18:28:19 +0100
Subject: [PATCH 1/3][V2] tracing/ftrace: implement a set_flag callback for tracers

Impact: give a way to send specific messages to tracers

The current implementation of tracing uses some flags to control the output
of general tracers. But we have no way to implement custom flags handling for
a specific tracer.
This patch proposes a new callback for the struct tracer which called set_flag
and a structure that represents a 32 bits variable flag.

A tracer can implement a struct tracer_flags on which it puts the initial value
of the flag integer. Than it can place a range of flags with their name and their
flag mask on the flag integer. The structure that implement a single flag is called
struct tracer_opt.

These custom flags will be available through the trace_options file like the general
tracing flags. Changing their value is done like the other general flags.
For example if you have a flag that calls "foo", you can activate it by writing
"foo" or "nofoo" on trace_options.

Note that the set_flag callback is optional and is only needed if you want the flags
changing to be signaled to your tracer and let it to accept or refuse their assignment.

V2: Some arrangements in coding style....

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++---
 kernel/trace/trace.h |   26 ++++++++++++++
 2 files changed, 112 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4a90462..cd123e2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -43,6 +43,20 @@
 unsigned long __read_mostly	tracing_max_latency = (cycle_t)ULONG_MAX;
 unsigned long __read_mostly	tracing_thresh;
 
+/* For tracers that don't implement custom flags */
+static struct tracer_opt dummy_tracer_opt[] = {
+	{ }
+};
+
+static struct tracer_flags dummy_tracer_flags = {
+	.val = 0,
+	.opts = dummy_tracer_opt
+};
+
+static int dummy_set_flag(u32 old_flags, u32 bit, int set)
+{
+	return 0;
+}
 
 /*
  * Kill all tracing for good (never come back).
@@ -531,6 +545,14 @@ int register_tracer(struct tracer *type)
 		}
 	}
 
+	if (!type->set_flag)
+		type->set_flag = &dummy_set_flag;
+	if (!type->flags)
+		type->flags = &dummy_tracer_flags;
+	else
+		if (!type->flags->opts)
+			type->flags->opts = dummy_tracer_opt;
+
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 	if (type->selftest) {
 		struct tracer *saved_tracer = current_trace;
@@ -2428,10 +2450,13 @@ static ssize_t
 tracing_trace_options_read(struct file *filp, char __user *ubuf,
 		       size_t cnt, loff_t *ppos)
 {
+	int i;
 	char *buf;
 	int r = 0;
 	int len = 0;
-	int i;
+	u32 tracer_flags = current_trace->flags->val;
+	struct tracer_opt *trace_opts = current_trace->flags->opts;
+
 
 	/* calulate max size */
 	for (i = 0; trace_options[i]; i++) {
@@ -2439,6 +2464,15 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 		len += 3; /* "no" and space */
 	}
 
+	/*
+	 * Increase the size with names of options specific
+	 * of the current tracer.
+	 */
+	for (i = 0; trace_opts[i].name; i++) {
+		len += strlen(trace_opts[i].name);
+		len += 3; /* "no" and space */
+	}
+
 	/* +2 for \n and \0 */
 	buf = kmalloc(len + 2, GFP_KERNEL);
 	if (!buf)
@@ -2451,6 +2485,15 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 			r += sprintf(buf + r, "no%s ", trace_options[i]);
 	}
 
+	for (i = 0; trace_opts[i].name; i++) {
+		if (tracer_flags & trace_opts[i].bit)
+			r += sprintf(buf + r, "%s ",
+				trace_opts[i].name);
+		else
+			r += sprintf(buf + r, "no%s ",
+				trace_opts[i].name);
+	}
+
 	r += sprintf(buf + r, "\n");
 	WARN_ON(r >= len + 2);
 
@@ -2461,6 +2504,40 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 	return r;
 }
 
+/* Try to assign a tracer specific option */
+static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
+{
+	struct tracer_flags *trace_flags = trace->flags;
+	struct tracer_opt *opts = NULL;
+	int ret = 0, i = 0;
+	int len;
+
+	for (i = 0; trace_flags->opts[i].name; i++) {
+		opts = &trace_flags->opts[i];
+		len = strlen(opts->name);
+
+		if (strncmp(cmp, opts->name, len) == 0) {
+			ret = trace->set_flag(trace_flags->val,
+				opts->bit, !neg);
+			break;
+		}
+	}
+	/* Not found */
+	if (!trace_flags->opts[i].name)
+		return -EINVAL;
+
+	/* Refused to handle */
+	if (ret)
+		return ret;
+
+	if (neg)
+		trace_flags->val &= ~opts->bit;
+	else
+		trace_flags->val |= opts->bit;
+
+	return 0;
+}
+
 static ssize_t
 tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 			size_t cnt, loff_t *ppos)
@@ -2468,6 +2545,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 	char buf[64];
 	char *cmp = buf;
 	int neg = 0;
+	int ret;
 	int i;
 
 	if (cnt >= sizeof(buf))
@@ -2494,11 +2572,13 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 			break;
 		}
 	}
-	/*
-	 * If no option could be set, return an error:
-	 */
-	if (!trace_options[i])
-		return -EINVAL;
+
+	/* If no option could be set, test the specific tracer options */
+	if (!trace_options[i]) {
+		ret = set_tracer_option(current_trace, cmp, neg);
+		if (ret)
+			return ret;
+	}
 
 	filp->f_pos += cnt;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 790ea8c..23c8b67 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -259,6 +259,29 @@ enum print_line_t {
 	TRACE_TYPE_UNHANDLED	= 2	/* Relay to other output functions */
 };
 
+
+/*
+ * An option specific to a tracer. This is a boolean value.
+ * The bit is the bit index that sets its value on the
+ * flags value in struct tracer_flags.
+ */
+struct tracer_opt {
+	const char 	*name; /* Will appear on the trace_options file */
+	u32 		bit; /* Mask assigned in val field in tracer_flags */
+};
+
+/*
+ * The set of specific options for a tracer. Your tracer
+ * have to set the initial value of the flags val.
+ */
+struct tracer_flags {
+	u32			val;
+	struct tracer_opt 	*opts;
+};
+
+/* Makes more easy to define a tracer opt */
+#define TRACER_OPT(s, b)	.name = #s, .bit = b
+
 /*
  * A specific tracer, represented by methods that operate on a trace array:
  */
@@ -279,8 +302,11 @@ struct tracer {
 					    struct trace_array *tr);
 #endif
 	enum print_line_t	(*print_line)(struct trace_iterator *iter);
+	/* If you handled the flag setting, return 0 */
+	int			(*set_flag)(u32 old_flags, u32 bit, int set);
 	struct tracer		*next;
 	int			print_max;
+	struct tracer_flags 	*flags;
 };
 
 struct trace_seq {
-- 
1.5.2.5


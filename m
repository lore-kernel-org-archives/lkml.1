Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYKQCQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYKQCQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 21:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYKQCQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 21:16:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:35528 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbYKQCQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 21:16:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=K3QCtONOOI7CBcO+PnjhTXBuNqL/cgrBmq0wgWe6x/GV3d765lY/3wUp9BuY4yYz4C
         nkJC4eLWe9NAsuGw1BPFmf+6iELbCv41jrNI760fN7YnHAESMcuvh99745iCjPgHN2JG
         NZG8U8Vi1TULqsvCxKxS6F3vwmlE9oUfKt8V4=
Message-ID: <4920D402.3000803@gmail.com>
Date: Mon, 17 Nov 2008 03:16:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing/ftrace: implement a set_flag callback for tracers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++---
 kernel/trace/trace.h |   28 +++++++++++++++++
 2 files changed, 103 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 396fda0..8c4eb80 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2432,6 +2432,9 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 	int r = 0;
 	int len = 0;
 	int i;
+	u32 tracer_flags = 0;
+	struct tracer_opt *trace_opts = NULL;
+
 
 	/* calulate max size */
 	for (i = 0; trace_options[i]; i++) {
@@ -2439,6 +2442,22 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 		len += 3; /* "no" and space */
 	}
 
+	if (current_trace->flags) {
+		trace_opts = current_trace->flags->opts;
+		tracer_flags = current_trace->flags->val;
+	}
+
+	/*
+	 * Increase the size with names of options specific
+	 * of the current tracer.
+	 */
+	if (trace_opts) {
+		for (i = 0; trace_opts[i].name; i++) {
+			len += strlen(trace_opts[i].name);
+			len += 3;
+		}
+	}
+
 	/* +2 for \n and \0 */
 	buf = kmalloc(len + 2, GFP_KERNEL);
 	if (!buf)
@@ -2451,6 +2470,16 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 			r += sprintf(buf + r, "no%s ", trace_options[i]);
 	}
 
+	if (trace_opts) {
+		for (i = 0; trace_opts[i].name; i++) {
+			if (tracer_flags & trace_opts[i].bit)
+				r += sprintf(buf + r, "%s ",
+					trace_opts[i].name);
+			else
+				r += sprintf(buf + r, "no%s ",
+					trace_opts[i].name);
+		}
+	}
 	r += sprintf(buf + r, "\n");
 	WARN_ON(r >= len + 2);
 
@@ -2461,6 +2490,44 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
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
+	if (!trace_flags || !trace_flags->opts)
+		return -EINVAL;
+
+	for (i = 0; trace_flags->opts[i].name; i++) {
+		opts = &trace_flags->opts[i];
+		len = strlen(opts->name);
+
+		if (strncmp(cmp, opts->name, len) == 0) {
+			if (trace->set_flag)
+					ret = trace->set_flag(trace_flags->val,
+							opts->bit, !neg);
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
@@ -2469,6 +2536,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 	char *cmp = buf;
 	int neg = 0;
 	int i;
+	int ret;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -2494,11 +2562,13 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
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
index cdbd5cc..fc06485 100644
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
+	const char *name; /* Will appear on the trace_options file */
+	u32 bit; /* The mask assigned in val field in tracer_flags */
+};
+
+/*
+ * The set of specific options for a tracer. Your tracer
+ * have to set the initial value of the flags val.
+ */
+struct tracer_flags {
+	u32	val;
+	struct tracer_opt *opts;
+};
+
+/* Makes more easy to define a tracer opt */
+#define TRACER_OPT(s, b) .name = #s, .bit = b
+
 /*
  * A specific tracer, represented by methods that operate on a trace array:
  */
@@ -280,8 +303,12 @@ struct tracer {
 					    struct trace_array *tr);
 #endif
 	enum print_line_t	(*print_line)(struct trace_iterator *iter);
+	/* If you handled the flag setting, return 0 */
+	int			(*set_flag)(u32 old_flags, u32 bit,
+							int set);
 	struct tracer		*next;
 	int			print_max;
+	struct tracer_flags *flags;
 };
 
 struct trace_seq {
@@ -484,6 +511,7 @@ enum trace_iterator_flags {
 #define TRACE_ITER_SYM_MASK \
 	(TRACE_ITER_PRINT_PARENT|TRACE_ITER_SYM_OFFSET|TRACE_ITER_SYM_ADDR)
 
+
 extern struct tracer nop_trace;
 
 /**
-- 
1.5.2.5

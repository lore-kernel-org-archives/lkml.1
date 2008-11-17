Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYKQDAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYKQDAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 22:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYKQC7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 21:59:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:64341 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbYKQC7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 21:59:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qOM9MnoGr3BRyK+NXztXO4t62eHe92z0ZVWjedTSrDJvB2HQDD0pvEnKQtUpRH2Q0M
         rzKpU1MWVYJkAnWVpXLxU8yjaEc4Cr7Lve3vDneAbQmYKStKwFa5VXakWfs6flX8DLmC
         hFfynNummjh+7oPoxNJ7qjQ+PITpPq7tgRcQw=
Message-ID: <4920DE25.6050802@gmail.com>
Date: Mon, 17 Nov 2008 03:59:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Steven Noonan <steven@uplinklabs.net>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing/ftrace: make nop tracer using tracer flags
References: <4920D494.1010108@gmail.com> <f488382f0811161836n30ed40a7tcc9a32dac4b1c3ba@mail.gmail.com>
In-Reply-To: <f488382f0811161836n30ed40a7tcc9a32dac4b1c3ba@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Noonan a écrit :
> I'd like these #defines and structs moved to just after the #includes,
> for cleanliness.

You're right I just corrected it in this V2.

 
> Other than the change noted above, I think it looks good.
> 
> Acked-by: Steven Noonan <steven@uplinklabs.net>

Thanks!

Here is the V2:
--

>From 6611913ca6ab732277b187283dba2144af4c9548 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 17 Nov 2008 03:53:33 +0100
Subject: [PATCH 2/3][V2] tracing/ftrace: make nop tracer using tracer flags

Impact: give an example on how to use specific tracer flags

This patch propose to use the nop tracer to provide an
example for using the tracer's custom flags implementation.

(V2: replace structures and defines just after the headers includes for
cleanliness).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Steven Noonan <steven@uplinklabs.net>
---
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index 0e77415..c917789 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -12,6 +12,23 @@
 
 #include "trace.h"
 
+#define TRACE_NOP_OPT_ACCEPT	0x1
+#define TRACE_NOP_OPT_REFUSE	0x2
+/* Options for the tracer (see trace_options file) */
+static struct tracer_opt nop_opts[] = {
+	/* Option that will be accepted by set_flag callback */
+	{ TRACER_OPT(test_nop_accept, TRACE_NOP_OPT_ACCEPT) },
+	/* Option that will be refused by set_flag callback */
+	{ TRACER_OPT(test_nop_refuse, TRACE_NOP_OPT_REFUSE) },
+	{ } /* Always set a last empty entry */
+};
+
+static struct tracer_flags nop_flags = {
+	/* You can check your flags value here when you want. */
+	.val = 0, /* By default: all flags disabled */
+	.opts = nop_opts
+};
+
 static struct trace_array	*ctx_trace;
 
 static void start_nop_trace(struct trace_array *tr)
@@ -41,6 +58,35 @@ static void nop_trace_reset(struct trace_array *tr)
 	stop_nop_trace(tr);
 }
 
+/* It only serves as a signal handler and a callback to
+ * accept or refuse tthe setting of a flag.
+ * If you don't implement it, then the flag setting will be
+ * automatically accepted.
+ */
+static int nop_set_flag(u32 old_flags, u32 bit, int set)
+{
+	/*
+	 * Note that you don't need to update nop_flags.val yourself.
+	 * The tracing Api will do it automatically if you return 0
+	 */
+	if (bit == TRACE_NOP_OPT_ACCEPT) {
+		printk(KERN_DEBUG "nop_test_accept flag set to %d: we accept."
+			" Now cat trace_options to see the result\n",
+			set);
+		return 0;
+	}
+
+	if (bit == TRACE_NOP_OPT_REFUSE) {
+		printk(KERN_DEBUG "nop_test_refuse flag set to %d: we refuse."
+			"Now cat trace_options to see the result\n",
+			set);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+
 struct tracer nop_trace __read_mostly =
 {
 	.name		= "nop",
@@ -49,5 +95,7 @@ struct tracer nop_trace __read_mostly =
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_nop,
 #endif
+	.flags		= &nop_flags,
+	.set_flag	= nop_set_flag
 };
 
-- 
1.5.2.5




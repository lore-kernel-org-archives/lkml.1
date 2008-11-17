Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYKQS0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYKQS0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYKQS0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:26:37 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:19949 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYKQS0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:26:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=URNDp5YZD3XO7fz0Ng8/XL7DGbkrdE1hLB0NmTAnYARPgE4NzOVtkXv9MuvtqzaAKp
         leGg4qMEvjjg9a8w0Set6pC/V8CuTZIhDIhnGw5CX9T8YP8JwGSvaf8KLaGIyCS5hY1Q
         Uv5ePsGhCelbS6xXFGmKbJ/p8BHa4FMfOD+RE=
Message-ID: <4921B756.5010805@gmail.com>
Date: Mon, 17 Nov 2008 19:26:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing/ftrace: make nop tracer using tracer flags
References: <4920D494.1010108@gmail.com> <20081117084638.GC28786@elte.hu>
In-Reply-To: <20081117084638.GC28786@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
>> +#define TRACE_NOP_OPT_ACCEPT	0x1
>> +#define TRACE_NOP_OPT_REFUSE	0x2
> 
> please use C enums not CPP defines.
> 
> 	Ingo

Fixed in the V3 below:

--
>From adc63c6d8f79927740058a50679a94a1c31c30e2 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 17 Nov 2008 16:19:35 +0100
Subject: [PATCH 2/3][V3] tracing/ftrace: make nop tracer using tracer flags

Impact: give an example on how to use specific tracer flags

This patch propose to use the nop tracer to provide an
example for using the tracer's custom flags implementation.

V3: replace defines by enum values.
V2: replace structures and defines just after the headers includes for
cleanliness.

Acked-by: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_nop.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index 0e77415..b9767ac 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -12,6 +12,27 @@
 
 #include "trace.h"
 
+/* Our two options */
+enum {
+	TRACE_NOP_OPT_ACCEPT = 0x1,
+	TRACE_NOP_OPT_REFUSE = 0x2
+};
+
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
@@ -41,6 +62,35 @@ static void nop_trace_reset(struct trace_array *tr)
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
@@ -49,5 +99,7 @@ struct tracer nop_trace __read_mostly =
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_nop,
 #endif
+	.flags		= &nop_flags,
+	.set_flag	= nop_set_flag
 };
 
-- 
1.5.2.5



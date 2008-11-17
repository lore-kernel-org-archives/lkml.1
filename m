Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYKQCTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYKQCTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 21:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbYKQCTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 21:19:08 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:7725 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbYKQCTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 21:19:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=SP9yUnKzq67ULFwhIIwjmjOywhyrnPt6oODwoE/y34ualRXAcUyYvzm8Zi43LTjJ83
         lQyDPMME2Bih+NUXsHL2JMZCtaVNcinHm4qXPhFffXoYefNKGVko7i1MtUBsmfzhChoS
         FYptjmR+UfvWf6KZbumzHYzLTI1bcxehbjUSo=
Message-ID: <4920D494.1010108@gmail.com>
Date: Mon, 17 Nov 2008 03:19:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing/ftrace: make nop tracer using tracer flags
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: give an example on how to use specific tracer flags

This patch propose to use the nop tracer to provide an
example for using the tracer's custom flags implementation.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_nop.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index 0e77415..1d8b4f8 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -41,6 +41,52 @@ static void nop_trace_reset(struct trace_array *tr)
 	stop_nop_trace(tr);
 }
 
+#define TRACE_NOP_OPT_ACCEPT	0x1
+#define TRACE_NOP_OPT_REFUSE	0x2
+/* Options for the tracer (see trace_options file) */
+static struct tracer_opt nop_opts[] = {
+	/* Option that will be accepted by set_flag callback */
+	{ TRACER_OPT(test_nop_accept, TRACE_NOP_OPT_ACCEPT) },
+	/* Option that will be refused by set_flag callback */
+	{ TRACER_OPT(test_nop_refuse, TRACE_NOP_OPT_REFUSE) },
+	{ } /* Always set the last empty entry */
+};
+
+static struct tracer_flags nop_flags = {
+	/* You can check your flags value here when you want. */
+	.val = 0, /* By default: all flags disabled */
+	.opts = nop_opts
+};
+
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

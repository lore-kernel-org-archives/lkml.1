Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733Ab0AZWSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0AZWSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004Ab0AZWSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:18:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab0AZWRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:17:16 -0500
X-Authority-Analysis: v=1.0 c=1 a=BNFEW_brtSYA:10 a=7mOBRU54AAAA:8 a=meVymXHHAAAA:8 a=4OQQ3ftBGnegng1VfFsA:9 a=bq6KfvGCHQ8Qdur-x8oA:7 a=f1Whe7zA5Cs5Ec3sLk_oq-hjt3IA:4 a=DHQQ7jDAcw4A:10 a=WeOa-AV5lc8A:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100126221713.432062340@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 17:09:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 5/5] tracing/documentation: Cover new frame pointer semantics
References: <20100126220923.534282809@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-documentation-Cover-new-frame-pointer-semant.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

Update the graph tracer examples to cover the new frame pointer semantics
(in terms of passing it along).  Move the HAVE_FUNCTION_GRAPH_FP_TEST docs
out of the Kconfig, into the right place, and expand on the details.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
LKML-Reference: <1264165967-18938-1-git-send-email-vapier@gentoo.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace-design.txt |   26 +++++++++++++++++++++++---
 kernel/trace/Kconfig                  |    4 +---
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 239f14b..6a5a579 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -1,5 +1,6 @@
 		function tracer guts
 		====================
+		By Mike Frysinger
 
 Introduction
 ------------
@@ -173,14 +174,16 @@ void ftrace_graph_caller(void)
 
 	unsigned long *frompc = &...;
 	unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;
-	prepare_ftrace_return(frompc, selfpc);
+	/* passing frame pointer up is optional -- see below */
+	prepare_ftrace_return(frompc, selfpc, frame_pointer);
 
 	/* restore all state needed by the ABI */
 }
 #endif
 
-For information on how to implement prepare_ftrace_return(), simply look at
-the x86 version.  The only architecture-specific piece in it is the setup of
+For information on how to implement prepare_ftrace_return(), simply look at the
+x86 version (the frame pointer passing is optional; see the next section for
+more information).  The only architecture-specific piece in it is the setup of
 the fault recovery table (the asm(...) code).  The rest should be the same
 across architectures.
 
@@ -205,6 +208,23 @@ void return_to_handler(void)
 #endif
 
 
+HAVE_FUNCTION_GRAPH_FP_TEST
+---------------------------
+
+An arch may pass in a unique value (frame pointer) to both the entering and
+exiting of a function.  On exit, the value is compared and if it does not
+match, then it will panic the kernel.  This is largely a sanity check for bad
+code generation with gcc.  If gcc for your port sanely updates the frame
+pointer under different opitmization levels, then ignore this option.
+
+However, adding support for it isn't terribly difficult.  In your assembly code
+that calls prepare_ftrace_return(), pass the frame pointer as the 3rd argument.
+Then in the C version of that function, do what the x86 port does and pass it
+along to ftrace_push_return_trace() instead of a stub value of 0.
+
+Similarly, when you call ftrace_return_to_handler(), pass it the frame pointer.
+
+
 HAVE_FTRACE_NMI_ENTER
 ---------------------
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 6c22d8a..60e2ce0 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -27,9 +27,7 @@ config HAVE_FUNCTION_GRAPH_TRACER
 config HAVE_FUNCTION_GRAPH_FP_TEST
 	bool
 	help
-	 An arch may pass in a unique value (frame pointer) to both the
-	 entering and exiting of a function. On exit, the value is compared
-	 and if it does not match, then it will panic the kernel.
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	bool
-- 
1.6.5



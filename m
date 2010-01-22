Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743Ab0AVNMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab0AVNMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 08:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701Ab0AVNMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 08:12:17 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54392 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab0AVNMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 08:12:16 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] ftrace: cover new frame pointer semantics
Date: Fri, 22 Jan 2010 08:12:47 -0500
Message-Id: <1264165967-18938-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the graph tracer examples to cover the new frame pointer semantics
(in terms of passing it along).  Move the HAVE_FUNCTION_GRAPH_FP_TEST docs
out of the Kconfig, into the right place, and expand on the details.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
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
1.6.6.1


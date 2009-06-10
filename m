Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbZFJItR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbZFJItR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbZFJIsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:48:53 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45415 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbZFJIsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:48:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ftrace: document basic ftracer/ftracer graph needs
Date: Wed, 10 Jun 2009 04:48:42 -0400
Message-Id: <1244623722-6325-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244623722-6325-1-git-send-email-vapier@gentoo.org>
References: <1244623722-6325-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While implementing ftracer and ftracer graph support, I found the exact
arch implementation details to be a bit lacking (and my x86 foo ain't
great).  So after pounding out support for the Blackfin arch, document
the requirements.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Documentation/trace/ftrace.txt |    7 ++++++
 kernel/trace/Kconfig           |   43 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 5ad2ded..e9f0527 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -27,6 +27,13 @@ disabled, and more (ftrace allows for tracer plugins, which
 means that the list of tracers can always grow).
 
 
+Implementation Details
+----------------------
+
+See kernel/trace/Kconfig for details about different options and
+the required architecture pieces.
+
+
 The File System
 ---------------
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 417d198..be936c9 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -14,9 +14,46 @@ config HAVE_FTRACE_NMI_ENTER
 
 config HAVE_FUNCTION_TRACER
 	bool
+	help
+	  Implement support for the _mcount() function (or whatever your
+	  toolchain names it), and the ftrace_stub function (which only
+	  does a return).
+
+	  The _mcount() function should check the function pointer
+	  ftrace_trace_function to see if it is set to ftrace_stub.  If
+	  it is, there is nothing for you to do -- return.  If it isn't,
+	  then call it the same way the _mcount() function normally calls
+	  __mcount_internal() -- the first argument is the "frompc" while
+	  the second argument is the "selfpc" (adjusted to remove the size
+	  of the embedded _mcount() call).
+
+	  For example, if the function foo() calls bar(), when the bar()
+	  function calls _mcount(), the arguments to the tracer are:
+	    "frompc" - the address bar() will use to return to foo()
+	    "selfpc" - the address bar() (with _mcount() size adjustment)
 
 config HAVE_FUNCTION_GRAPH_TRACER
 	bool
+	help
+	  Update your _mcount() function to check the function pointers
+	  ftrace_graph_return (compare to ftrace_stub) and ftrace_graph_entry
+	  (compare to ftrace_graph_entry_stub).  If either of those are not
+	  set to the relevant stub function, call the arch-specific function
+	  ftrace_graph_caller which in turn calls the arch-specific function
+	  prepare_ftrace_return.
+
+	  The arguments to prepare_ftrace_return() are slightly different.
+	  The first argument will instead be a pointer to the "frompc" --
+	  typically located in the stack.  This allows the function to
+	  hijack the return address temporarily to have it point to the
+	  arch-specific function return_to_handler().  For exact details of
+	  how to implement prepare_ftrace_return(), consult an existing port.
+	  It is fairly straight forward C code.
+
+	  The return_to_handler() function is simple as well.  Have it call
+	  the common ftrace_return_to_handler() function.  The return value
+	  is the original return address, so restore this to the right place
+	  and return.
 
 config HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	bool
@@ -25,11 +62,17 @@ config HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	 variable at the mcount call site. Otherwise, this variable
 	 is tested by the called function.
 
+	 It is of course optional for arches, but does improve performance
+	 a bit as it prevents constant state saving and call overhead when
+	 the function tracer is actually disabled.
+
 config HAVE_DYNAMIC_FTRACE
 	bool
 
 config HAVE_FTRACE_MCOUNT_RECORD
 	bool
+	help
+	  See scripts/recordmcount.pl for more info.
 
 config HAVE_HW_BRANCH_TRACER
 	bool
-- 
1.6.3.1


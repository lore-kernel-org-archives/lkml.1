Return-Path: <linux-kernel-owner+w=401wt.eu-S1760014AbZIQHs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014AbZIQHs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759298AbZIQHsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:48:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:48517 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383AbZIQHsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:48:22 -0400
Date: Thu, 17 Sep 2009 07:47:58 GMT
From: tip-bot for Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, vapier@gentoo.org,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, vapier@gentoo.org,
       tglx@linutronix.de
In-Reply-To: <1252973415-21264-1-git-send-email-vapier@gentoo.org>
References: <1252973415-21264-1-git-send-email-vapier@gentoo.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] ftrace: document function and function graph implementation
Message-ID: <tip-555f386c98cc93890f48fdea098936755270304b@git.kernel.org>
Git-Commit-ID: 555f386c98cc93890f48fdea098936755270304b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 07:47:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  555f386c98cc93890f48fdea098936755270304b
Gitweb:     http://git.kernel.org/tip/555f386c98cc93890f48fdea098936755270304b
Author:     Mike Frysinger <vapier@gentoo.org>
AuthorDate: Mon, 14 Sep 2009 20:10:15 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 14 Sep 2009 21:43:15 -0400

ftrace: document function and function graph implementation

While implementing function tracer and function tracer graph support,
I found the exact arch implementation details to be a bit lacking
(and my x86 foo ain't great).  So after pounding out support for
the Blackfin arch, start documenting the requirements/details.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
LKML-Reference: <1252973415-21264-1-git-send-email-vapier@gentoo.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 Documentation/trace/ftrace-design.txt |  233 +++++++++++++++++++++++++++++++++
 Documentation/trace/ftrace.txt        |    6 +
 kernel/trace/Kconfig                  |   16 ++-
 3 files changed, 252 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
new file mode 100644
index 0000000..7003e10
--- /dev/null
+++ b/Documentation/trace/ftrace-design.txt
@@ -0,0 +1,233 @@
+		function tracer guts
+		====================
+
+Introduction
+------------
+
+Here we will cover the architecture pieces that the common function tracing
+code relies on for proper functioning.  Things are broken down into increasing
+complexity so that you can start simple and at least get basic functionality.
+
+Note that this focuses on architecture implementation details only.  If you
+want more explanation of a feature in terms of common code, review the common
+ftrace.txt file.
+
+
+Prerequisites
+-------------
+
+Ftrace relies on these features being implemented:
+ STACKTRACE_SUPPORT - implement save_stack_trace()
+ TRACE_IRQFLAGS_SUPPORT - implement include/asm/irqflags.h
+
+
+HAVE_FUNCTION_TRACER
+--------------------
+
+You will need to implement the mcount and the ftrace_stub functions.
+
+The exact mcount symbol name will depend on your toolchain.  Some call it
+"mcount", "_mcount", or even "__mcount".  You can probably figure it out by
+running something like:
+	$ echo 'main(){}' | gcc -x c -S -o - - -pg | grep mcount
+	        call    mcount
+We'll make the assumption below that the symbol is "mcount" just to keep things
+nice and simple in the examples.
+
+Keep in mind that the ABI that is in effect inside of the mcount function is
+*highly* architecture/toolchain specific.  We cannot help you in this regard,
+sorry.  Dig up some old documentation and/or find someone more familiar than
+you to bang ideas off of.  Typically, register usage (argument/scratch/etc...)
+is a major issue at this point, especially in relation to the location of the
+mcount call (before/after function prologue).  You might also want to look at
+how glibc has implemented the mcount function for your architecture.  It might
+be (semi-)relevant.
+
+The mcount function should check the function pointer ftrace_trace_function
+to see if it is set to ftrace_stub.  If it is, there is nothing for you to do,
+so return immediately.  If it isn't, then call that function in the same way
+the mcount function normally calls __mcount_internal -- the first argument is
+the "frompc" while the second argument is the "selfpc" (adjusted to remove the
+size of the mcount call that is embedded in the function).
+
+For example, if the function foo() calls bar(), when the bar() function calls
+mcount(), the arguments mcount() will pass to the tracer are:
+	"frompc" - the address bar() will use to return to foo()
+	"selfpc" - the address bar() (with _mcount() size adjustment)
+
+Also keep in mind that this mcount function will be called *a lot*, so
+optimizing for the default case of no tracer will help the smooth running of
+your system when tracing is disabled.  So the start of the mcount function is
+typically the bare min with checking things before returning.  That also means
+the code flow should usually kept linear (i.e. no branching in the nop case).
+This is of course an optimization and not a hard requirement.
+
+Here is some pseudo code that should help (these functions should actually be
+implemented in assembly):
+
+void ftrace_stub(void)
+{
+	return;
+}
+
+void mcount(void)
+{
+	/* save any bare state needed in order to do initial checking */
+
+	extern void (*ftrace_trace_function)(unsigned long, unsigned long);
+	if (ftrace_trace_function != ftrace_stub)
+		goto do_trace;
+
+	/* restore any bare state */
+
+	return;
+
+do_trace:
+
+	/* save all state needed by the ABI (see paragraph above) */
+
+	unsigned long frompc = ...;
+	unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;
+	ftrace_trace_function(frompc, selfpc);
+
+	/* restore all state needed by the ABI */
+}
+
+Don't forget to export mcount for modules !
+extern void mcount(void);
+EXPORT_SYMBOL(mcount);
+
+
+HAVE_FUNCTION_TRACE_MCOUNT_TEST
+-------------------------------
+
+This is an optional optimization for the normal case when tracing is turned off
+in the system.  If you do not enable this Kconfig option, the common ftrace
+code will take care of doing the checking for you.
+
+To support this feature, you only need to check the function_trace_stop
+variable in the mcount function.  If it is non-zero, there is no tracing to be
+done at all, so you can return.
+
+This additional pseudo code would simply be:
+void mcount(void)
+{
+	/* save any bare state needed in order to do initial checking */
+
++	if (function_trace_stop)
++		return;
+
+	extern void (*ftrace_trace_function)(unsigned long, unsigned long);
+	if (ftrace_trace_function != ftrace_stub)
+...
+
+
+HAVE_FUNCTION_GRAPH_TRACER
+--------------------------
+
+Deep breath ... time to do some real work.  Here you will need to update the
+mcount function to check ftrace graph function pointers, as well as implement
+some functions to save (hijack) and restore the return address.
+
+The mcount function should check the function pointers ftrace_graph_return
+(compare to ftrace_stub) and ftrace_graph_entry (compare to
+ftrace_graph_entry_stub).  If either of those are not set to the relevant stub
+function, call the arch-specific function ftrace_graph_caller which in turn
+calls the arch-specific function prepare_ftrace_return.  Neither of these
+function names are strictly required, but you should use them anyways to stay
+consistent across the architecture ports -- easier to compare & contrast
+things.
+
+The arguments to prepare_ftrace_return are slightly different than what are
+passed to ftrace_trace_function.  The second argument "selfpc" is the same,
+but the first argument should be a pointer to the "frompc".  Typically this is
+located on the stack.  This allows the function to hijack the return address
+temporarily to have it point to the arch-specific function return_to_handler.
+That function will simply call the common ftrace_return_to_handler function and
+that will return the original return address with which, you can return to the
+original call site.
+
+Here is the updated mcount pseudo code:
+void mcount(void)
+{
+...
+	if (ftrace_trace_function != ftrace_stub)
+		goto do_trace;
+
++#ifdef CONFIG_FUNCTION_GRAPH_TRACER
++	extern void (*ftrace_graph_return)(...);
++	extern void (*ftrace_graph_entry)(...);
++	if (ftrace_graph_return != ftrace_stub ||
++	    ftrace_graph_entry != ftrace_graph_entry_stub)
++		ftrace_graph_caller();
++#endif
+
+	/* restore any bare state */
+...
+
+Here is the pseudo code for the new ftrace_graph_caller assembly function:
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+void ftrace_graph_caller(void)
+{
+	/* save all state needed by the ABI */
+
+	unsigned long *frompc = &...;
+	unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;
+	prepare_ftrace_return(frompc, selfpc);
+
+	/* restore all state needed by the ABI */
+}
+#endif
+
+For information on how to implement prepare_ftrace_return(), simply look at
+the x86 version.  The only architecture-specific piece in it is the setup of
+the fault recovery table (the asm(...) code).  The rest should be the same
+across architectures.
+
+Here is the pseudo code for the new return_to_handler assembly function.  Note
+that the ABI that applies here is different from what applies to the mcount
+code.  Since you are returning from a function (after the epilogue), you might
+be able to skimp on things saved/restored (usually just registers used to pass
+return values).
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+void return_to_handler(void)
+{
+	/* save all state needed by the ABI (see paragraph above) */
+
+	void (*original_return_point)(void) = ftrace_return_to_handler();
+
+	/* restore all state needed by the ABI */
+
+	/* this is usually either a return or a jump */
+	original_return_point();
+}
+#endif
+
+
+HAVE_FTRACE_NMI_ENTER
+---------------------
+
+If you can't trace NMI functions, then skip this option.
+
+<details to be filled>
+
+
+HAVE_FTRACE_SYSCALLS
+---------------------
+
+<details to be filled>
+
+
+HAVE_FTRACE_MCOUNT_RECORD
+-------------------------
+
+See scripts/recordmcount.pl for more info.
+
+<details to be filled>
+
+
+HAVE_DYNAMIC_FTRACE
+---------------------
+
+<details to be filled>
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 355d0f1..1b6292b 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -26,6 +26,12 @@ disabled, and more (ftrace allows for tracer plugins, which
 means that the list of tracers can always grow).
 
 
+Implementation Details
+----------------------
+
+See ftrace-design.txt for details for arch porters and such.
+
+
 The File System
 ---------------
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index aa002ce..e716346 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -11,12 +11,18 @@ config NOP_TRACER
 
 config HAVE_FTRACE_NMI_ENTER
 	bool
+	help
+	  See Documentation/trace/ftrace-implementation.txt
 
 config HAVE_FUNCTION_TRACER
 	bool
+	help
+	  See Documentation/trace/ftrace-implementation.txt
 
 config HAVE_FUNCTION_GRAPH_TRACER
 	bool
+	help
+	  See Documentation/trace/ftrace-implementation.txt
 
 config HAVE_FUNCTION_GRAPH_FP_TEST
 	bool
@@ -28,21 +34,25 @@ config HAVE_FUNCTION_GRAPH_FP_TEST
 config HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	bool
 	help
-	 This gets selected when the arch tests the function_trace_stop
-	 variable at the mcount call site. Otherwise, this variable
-	 is tested by the called function.
+	  See Documentation/trace/ftrace-implementation.txt
 
 config HAVE_DYNAMIC_FTRACE
 	bool
+	help
+	  See Documentation/trace/ftrace-implementation.txt
 
 config HAVE_FTRACE_MCOUNT_RECORD
 	bool
+	help
+	  See Documentation/trace/ftrace-implementation.txt
 
 config HAVE_HW_BRANCH_TRACER
 	bool
 
 config HAVE_SYSCALL_TRACEPOINTS
 	bool
+	help
+	  See Documentation/trace/ftrace-implementation.txt
 
 config TRACER_MAX_TRACE
 	bool

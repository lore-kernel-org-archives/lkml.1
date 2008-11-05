Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbYKEVfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbYKEVfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYKEVeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:34:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54519 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbYKEVeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:34:09 -0500
Message-Id: <20081105213406.455467795@goodmis.org>
References: <20081105212428.148612398@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 05 Nov 2008 16:24:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] ftrace: add quick function trace stop
Content-Disposition: inline; filename=0001-ftrace-add-quick-function-trace-stop.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: quick start and stop of function tracer

This patch adds a way to disable the function tracer quickly without
the need to run kstop_machine. It adds a new variable called
function_trace_stop which will stop the calls to functions from mcount
when set.  This is just an on/off switch and does not handle recursion
like preempt_disable().

It's main purpose is to help other tracers/debuggers start and stop tracing
fuctions without the need to call kstop_machine.

The config option HAVE_FUNCTION_TRACE_MCOUNT_TEST is added for archs
that implement the testing of the function_trace_stop in the mcount
arch dependent code. Otherwise, the test is done in the C code.

x86 is the only arch at the moment that supports this.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/Kconfig           |    1 +
 arch/x86/kernel/entry_32.S |    6 +++++
 arch/x86/kernel/entry_64.S |    5 ++++
 include/linux/ftrace.h     |   30 ++++++++++++++++++++++++++++
 kernel/trace/Kconfig       |    7 ++++++
 kernel/trace/ftrace.c      |   47 ++++++++++++++++++++++++++++++++++---------
 6 files changed, 86 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b47b3a6..d5dbfe0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -29,6 +29,7 @@ config X86
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
+	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 28b597e..9134de8 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1157,6 +1157,9 @@ ENTRY(mcount)
 END(mcount)
 
 ENTRY(ftrace_caller)
+	cmpl $0, function_trace_stop
+	jne  ftrace_stub
+
 	pushl %eax
 	pushl %ecx
 	pushl %edx
@@ -1180,6 +1183,9 @@ END(ftrace_caller)
 #else /* ! CONFIG_DYNAMIC_FTRACE */
 
 ENTRY(mcount)
+	cmpl $0, function_trace_stop
+	jne  ftrace_stub
+
 	cmpl $ftrace_stub, ftrace_trace_function
 	jnz trace
 .globl ftrace_stub
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index ddeeb10..983d85a 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -68,6 +68,8 @@ ENTRY(mcount)
 END(mcount)
 
 ENTRY(ftrace_caller)
+	cmpl $0, function_trace_stop
+	jne  ftrace_stub
 
 	/* taken from glibc */
 	subq $0x38, %rsp
@@ -103,6 +105,9 @@ END(ftrace_caller)
 
 #else /* ! CONFIG_DYNAMIC_FTRACE */
 ENTRY(mcount)
+	cmpl $0, function_trace_stop
+	jne  ftrace_stub
+
 	cmpq $ftrace_stub, ftrace_trace_function
 	jnz trace
 .globl ftrace_stub
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 0ead706..6eb966d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -23,6 +23,34 @@ struct ftrace_ops {
 	struct ftrace_ops *next;
 };
 
+extern int function_trace_stop;
+
+/**
+ * ftrace_stop - stop function tracer.
+ *
+ * A quick way to stop the function tracer. Note this an on off switch,
+ * it is not something that is recursive like preempt_disable.
+ * This does not disable the calling of mcount, it only stops the
+ * calling of functions from mcount.
+ */
+static inline void ftrace_stop(void)
+{
+	function_trace_stop = 1;
+}
+
+/**
+ * ftrace_start - start the function tracer.
+ *
+ * This function is the inverse of ftrace_stop. This does not enable
+ * the function tracing if the function tracer is disabled. This only
+ * sets the function tracer flag to continue calling the functions
+ * from mcount.
+ */
+static inline void ftrace_start(void)
+{
+	function_trace_stop = 0;
+}
+
 /*
  * The ftrace_ops must be a static and should also
  * be read_mostly.  These functions do modify read_mostly variables
@@ -41,6 +69,8 @@ extern void ftrace_stub(unsigned long a0, unsigned long a1);
 # define unregister_ftrace_function(ops) do { } while (0)
 # define clear_ftrace_function(ops) do { } while (0)
 static inline void ftrace_kill(void) { }
+static inline void ftrace_stop(void) { }
+static inline void ftrace_start(void) { }
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 33dbefd..fc4febc 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -9,6 +9,13 @@ config NOP_TRACER
 config HAVE_FUNCTION_TRACER
 	bool
 
+config HAVE_FUNCTION_TRACE_MCOUNT_TEST
+	bool
+	help
+	 This gets selected when the arch tests the function_trace_stop
+	 variable at the mcount call site. Otherwise, this variable
+	 is tested by the called function.
+
 config HAVE_DYNAMIC_FTRACE
 	bool
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4a39d24..896c71f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -47,6 +47,9 @@
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
 
+/* Quick disabling of function tracer. */
+int function_trace_stop;
+
 /*
  * ftrace_disabled is set when an anomaly is discovered.
  * ftrace_disabled is much stronger than ftrace_enabled.
@@ -63,6 +66,7 @@ static struct ftrace_ops ftrace_list_end __read_mostly =
 
 static struct ftrace_ops *ftrace_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
+ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 
 static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
 {
@@ -88,8 +92,23 @@ static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
 void clear_ftrace_function(void)
 {
 	ftrace_trace_function = ftrace_stub;
+	__ftrace_trace_function = ftrace_stub;
 }
 
+#ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
+/*
+ * For those archs that do not test ftrace_trace_stop in their
+ * mcount call site, we need to do it from C.
+ */
+static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip)
+{
+	if (function_trace_stop)
+		return;
+
+	__ftrace_trace_function(ip, parent_ip);
+}
+#endif
+
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
 	/* should not be called from interrupt context */
@@ -110,10 +129,18 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 		 * For one func, simply call it directly.
 		 * For more than one func, call the chain.
 		 */
+#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 		if (ops->next == &ftrace_list_end)
 			ftrace_trace_function = ops->func;
 		else
 			ftrace_trace_function = ftrace_list_func;
+#else
+		if (ops->next == &ftrace_list_end)
+			__ftrace_trace_function = ops->func;
+		else
+			__ftrace_trace_function = ftrace_list_func;
+		ftrace_trace_function = ftrace_test_stop_func;
+#endif
 	}
 
 	spin_unlock(&ftrace_lock);
@@ -526,7 +553,7 @@ static void ftrace_run_update_code(int command)
 }
 
 static ftrace_func_t saved_ftrace_func;
-static int ftrace_start;
+static int ftrace_start_up;
 static DEFINE_MUTEX(ftrace_start_lock);
 
 static void ftrace_startup(void)
@@ -537,8 +564,8 @@ static void ftrace_startup(void)
 		return;
 
 	mutex_lock(&ftrace_start_lock);
-	ftrace_start++;
-	if (ftrace_start == 1)
+	ftrace_start_up++;
+	if (ftrace_start_up == 1)
 		command |= FTRACE_ENABLE_CALLS;
 
 	if (saved_ftrace_func != ftrace_trace_function) {
@@ -562,8 +589,8 @@ static void ftrace_shutdown(void)
 		return;
 
 	mutex_lock(&ftrace_start_lock);
-	ftrace_start--;
-	if (!ftrace_start)
+	ftrace_start_up--;
+	if (!ftrace_start_up)
 		command |= FTRACE_DISABLE_CALLS;
 
 	if (saved_ftrace_func != ftrace_trace_function) {
@@ -589,8 +616,8 @@ static void ftrace_startup_sysctl(void)
 	mutex_lock(&ftrace_start_lock);
 	/* Force update next time */
 	saved_ftrace_func = NULL;
-	/* ftrace_start is true if we want ftrace running */
-	if (ftrace_start)
+	/* ftrace_start_up is true if we want ftrace running */
+	if (ftrace_start_up)
 		command |= FTRACE_ENABLE_CALLS;
 
 	ftrace_run_update_code(command);
@@ -605,8 +632,8 @@ static void ftrace_shutdown_sysctl(void)
 		return;
 
 	mutex_lock(&ftrace_start_lock);
-	/* ftrace_start is true if ftrace is running */
-	if (ftrace_start)
+	/* ftrace_start_up is true if ftrace is running */
+	if (ftrace_start_up)
 		command |= FTRACE_DISABLE_CALLS;
 
 	ftrace_run_update_code(command);
@@ -1186,7 +1213,7 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 
 	mutex_lock(&ftrace_sysctl_lock);
 	mutex_lock(&ftrace_start_lock);
-	if (iter->filtered && ftrace_start && ftrace_enabled)
+	if (iter->filtered && ftrace_start_up && ftrace_enabled)
 		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
 	mutex_unlock(&ftrace_start_lock);
 	mutex_unlock(&ftrace_sysctl_lock);
-- 
1.5.6.5

-- 

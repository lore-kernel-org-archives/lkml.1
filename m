Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbYLFCkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbYLFCkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 21:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbYLFCkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 21:40:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:9535 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbYLFCkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 21:40:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=dlXH5E1psnlo9iVtALOeX4t4IThSfj2umIHhlUfqwxOu9OU+UhdavKiw+tIOvC32Jw
         oxhxLz4OuOBejcvfF9UEwkJnbkI/jRJIxcI8QVtbH+R4XqKyP8uQmHqebgV4ycFi/uVm
         wAqK41iC/YrPWOEk2Cfd1ZgY2G/F1nWl3OZp4=
Message-ID: <4939E600.804@gmail.com>
Date: Sat, 06 Dec 2008 03:40:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing/function-graph-tracer: introduce __notrace_funcgraph
 to filter special functions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: trace more functions

When the function graph tracer is configured, three more files are not traced to prevent
only four functions to be traced. And this impacts the normal function tracer too.

arch/x86/kernel/process_64/32.c:

I had crashes when I let this file traced. After some debugging, I saw that 
the "current" task point was changed inside__swtich_to(), ie: "write_pda(pcurrent, next_p);" 
inside process_64.c 
Since the tracer store the original return address of the function inside current, we had crashes.
Only __switch_to() has to be traced.

kernel/module.c and kernel/extable.c:

Because of a function used internally by the function graph tracer: __kernel_text_address()

To let the other functions inside these files to be traced, this patch introduces the 
__notrace_funcgraph function prefix which is __notrace if function graph tracer is 
configured and nothing if not.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 5ee1ba6..3d82c15 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -15,12 +15,6 @@ CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
-ifdef CONFIG_FUNCTION_GRAPH_TRACER
-# Don't trace __switch_to() but let it for function tracer
-CFLAGS_REMOVE_process_32.o = -pg
-CFLAGS_REMOVE_process_64.o = -pg
-endif
-
 #
 # vsyscalls (which work on the user stack) should have
 # no stack-protector checks:
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 0a1302f..24c2276 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -38,6 +38,7 @@
 #include <linux/percpu.h>
 #include <linux/prctl.h>
 #include <linux/dmi.h>
+#include <linux/ftrace.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -548,7 +549,8 @@ __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
  * the task-switch, and shows up in ret_from_fork in entry.S,
  * for example.
  */
-struct task_struct * __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
+__notrace_funcgraph struct task_struct *
+__switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread,
 				 *next = &next_p->thread;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3180e79..c99a376 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -40,6 +40,7 @@
 #include <linux/prctl.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/ftrace.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -563,8 +564,9 @@ static inline void __switch_to_xtra(struct task_struct *prev_p,
  * - could test fs/gs bitsliced
  *
  * Kprobes not supported here. Set the probe on schedule instead.
+ * Function graph tracer not supported too.
  */
-struct task_struct *
+__notrace_funcgraph struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread;
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index b9b4d0a..449fa8e 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -369,6 +369,14 @@ struct ftrace_graph_ret {
 };
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+/*
+ * Sometimes we don't want to trace a function with the function
+ * graph tracer but we want them to keep traced by the usual function
+ * tracer if the function graph tracer is not configured.
+ */
+#define __notrace_funcgraph		notrace
+
 #define FTRACE_RETFUNC_DEPTH 50
 #define FTRACE_RETSTACK_ALLOC_SIZE 32
 /* Type of the callback handlers for tracing function graph*/
@@ -394,6 +402,9 @@ static inline int task_curr_ret_stack(struct task_struct *t)
 	return t->curr_ret_stack;
 }
 #else
+
+#define __notrace_funcgraph
+
 static inline void ftrace_graph_init_task(struct task_struct *t) { }
 static inline void ftrace_graph_exit_task(struct task_struct *t) { }
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 86e2d82..6a212b8 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -20,10 +20,6 @@ CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
 endif
-ifdef CONFIG_FUNCTION_GRAPH_TRACER
-CFLAGS_REMOVE_extable.o = -pg # For __kernel_text_address()
-CFLAGS_REMOVE_module.o = -pg # For __module_text_address()
-endif
 
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
diff --git a/kernel/extable.c b/kernel/extable.c
index adf0cc9..e136ed8 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -17,6 +17,7 @@
 */
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/ftrace.h>
 #include <asm/uaccess.h>
 #include <asm/sections.h>
 
@@ -40,7 +41,7 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
 	return e;
 }
 
-int core_kernel_text(unsigned long addr)
+__notrace_funcgraph int core_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_stext &&
 	    addr <= (unsigned long)_etext)
@@ -53,7 +54,7 @@ int core_kernel_text(unsigned long addr)
 	return 0;
 }
 
-int __kernel_text_address(unsigned long addr)
+__notrace_funcgraph int __kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
 		return 1;
diff --git a/kernel/module.c b/kernel/module.c
index f5cd963..9712c52 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2705,7 +2705,7 @@ int is_module_address(unsigned long addr)
 
 
 /* Is this a valid kernel address? */
-struct module *__module_text_address(unsigned long addr)
+__notrace_funcgraph struct module *__module_text_address(unsigned long addr)
 {
 	struct module *mod;
 
-- 
1.5.6.3


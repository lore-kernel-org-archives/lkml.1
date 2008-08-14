Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbYHNTuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbYHNTuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbYHNTtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:49:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51486 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbYHNTtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:49:04 -0400
Message-Id: <20080814194859.634951545@goodmis.org>
References: <20080814194506.233473381@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 14 Aug 2008 15:45:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, Bruce Duncan <bwduncan@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 2/6] ftrace: mcount call site on boot nops core
Content-Disposition: inline; filename=ftrace-convert-recorded-mcount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the infrastructure to the converting the mcount call sites
recorded by the __mcount_loc section into nops on boot. It also allows
for using these sites to enable tracing as normal. When the __mcount_loc
section is used, the "ftraced" kernel thread is disabled.

This uses the current infrastructure to record the mcount call sites
as well as convert them to nops. The mcount function is kept as a stub
on boot up and not converted to the ftrace_record_ip function. We use the
ftrace_record_ip to only record from the table.

This patch does not handle modules. That comes with a later patch.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/asm-x86/ftrace.h |   10 +++
 include/linux/ftrace.h   |    6 +
 init/main.c              |    3 
 kernel/trace/ftrace.c    |  148 +++++++++++++++++++++++++++++++++--------------
 4 files changed, 124 insertions(+), 43 deletions(-)

Index: linux-tip.git/include/asm-x86/ftrace.h
===================================================================
--- linux-tip.git.orig/include/asm-x86/ftrace.h	2008-08-14 13:55:12.000000000 -0400
+++ linux-tip.git/include/asm-x86/ftrace.h	2008-08-14 13:59:19.000000000 -0400
@@ -7,6 +7,16 @@
 
 #ifndef __ASSEMBLY__
 extern void mcount(void);
+
+static inline unsigned long ftrace_call_adjust(unsigned long addr)
+{
+	/*
+	 * call mcount is "e8 <4 byte offset>"
+	 * The addr points to the 4 byte offset and the caller of this
+	 * function wants the pointer to e8. Simply subtract one.
+	 */
+	return addr - 1;
+}
 #endif
 
 #endif /* CONFIG_FTRACE */
Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-08-14 13:55:12.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-08-14 13:59:19.000000000 -0400
@@ -141,4 +141,10 @@ static inline void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
 #endif
 
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+extern void ftrace_init(void);
+#else
+static inline void ftrace_init(void) { }
+#endif
+
 #endif /* _LINUX_FTRACE_H */
Index: linux-tip.git/init/main.c
===================================================================
--- linux-tip.git.orig/init/main.c	2008-08-14 13:55:13.000000000 -0400
+++ linux-tip.git/init/main.c	2008-08-14 13:59:19.000000000 -0400
@@ -62,6 +62,7 @@
 #include <linux/signal.h>
 #include <linux/idr.h>
 #include <linux/kmemcheck.h>
+#include <linux/ftrace.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -820,6 +821,8 @@ asmlinkage void __init start_kernel(void
 
 	acpi_early_init(); /* before LAPIC and SMP init */
 
+	ftrace_init();
+
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }
Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-08-14 13:55:13.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-08-14 13:59:19.000000000 -0400
@@ -799,47 +799,7 @@ static int ftrace_update_code(void)
 	return 1;
 }
 
-static int ftraced(void *ignore)
-{
-	unsigned long usecs;
-
-	while (!kthread_should_stop()) {
-
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		/* check once a second */
-		schedule_timeout(HZ);
-
-		if (unlikely(ftrace_disabled))
-			continue;
-
-		mutex_lock(&ftrace_sysctl_lock);
-		mutex_lock(&ftraced_lock);
-		if (!ftraced_suspend && !ftraced_stop &&
-		    ftrace_update_code()) {
-			usecs = nsecs_to_usecs(ftrace_update_time);
-			if (ftrace_update_tot_cnt > 100000) {
-				ftrace_update_tot_cnt = 0;
-				pr_info("hm, dftrace overflow: %lu change%s"
-					" (%lu total) in %lu usec%s\n",
-					ftrace_update_cnt,
-					ftrace_update_cnt != 1 ? "s" : "",
-					ftrace_update_tot_cnt,
-					usecs, usecs != 1 ? "s" : "");
-				ftrace_disabled = 1;
-				WARN_ON_ONCE(1);
-			}
-		}
-		mutex_unlock(&ftraced_lock);
-		mutex_unlock(&ftrace_sysctl_lock);
-
-		ftrace_shutdown_replenish();
-	}
-	__set_current_state(TASK_RUNNING);
-	return 0;
-}
-
-static int __init ftrace_dyn_table_alloc(void)
+static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
 {
 	struct ftrace_page *pg;
 	int cnt;
@@ -866,7 +826,9 @@ static int __init ftrace_dyn_table_alloc
 
 	pg = ftrace_pages = ftrace_pages_start;
 
-	cnt = NR_TO_INIT / ENTRIES_PER_PAGE;
+	cnt = num_to_init / ENTRIES_PER_PAGE;
+	pr_info("ftrace: allocating %ld hash entries in %d pages\n",
+		num_to_init, cnt);
 
 	for (i = 0; i < cnt; i++) {
 		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
@@ -1563,6 +1525,104 @@ static __init int ftrace_init_debugfs(vo
 
 fs_initcall(ftrace_init_debugfs);
 
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+static int ftrace_convert_nops(unsigned long *start,
+			       unsigned long *end)
+{
+	unsigned long *p;
+	unsigned long addr;
+	unsigned long flags;
+
+	p = start;
+	while (p < end) {
+		addr = ftrace_call_adjust(*p++);
+		ftrace_record_ip(addr);
+		ftrace_shutdown_replenish();
+	}
+
+	/* p is ignored */
+	local_irq_save(flags);
+	__ftrace_update_code(p);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+extern unsigned long __start_mcount_loc[];
+extern unsigned long __stop_mcount_loc[];
+
+void __init ftrace_init(void)
+{
+	unsigned long count, addr, flags;
+	int ret;
+
+	/* Keep the ftrace pointer to the stub */
+	addr = (unsigned long)ftrace_stub;
+
+	local_irq_save(flags);
+	ftrace_dyn_arch_init(&addr);
+	local_irq_restore(flags);
+
+	/* ftrace_dyn_arch_init places the return code in addr */
+	if (addr)
+		goto failed;
+
+	count = __stop_mcount_loc - __start_mcount_loc;
+
+	ret = ftrace_dyn_table_alloc(count);
+	if (ret)
+		goto failed;
+
+	last_ftrace_enabled = ftrace_enabled = 1;
+
+	ret = ftrace_convert_nops(__start_mcount_loc,
+				  __stop_mcount_loc);
+
+	return;
+ failed:
+	ftrace_disabled = 1;
+}
+#else /* CONFIG_FTRACE_MCOUNT_RECORD */
+static int ftraced(void *ignore)
+{
+	unsigned long usecs;
+
+	while (!kthread_should_stop()) {
+
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		/* check once a second */
+		schedule_timeout(HZ);
+
+		if (unlikely(ftrace_disabled))
+			continue;
+
+		mutex_lock(&ftrace_sysctl_lock);
+		mutex_lock(&ftraced_lock);
+		if (!ftraced_suspend && !ftraced_stop &&
+		    ftrace_update_code()) {
+			usecs = nsecs_to_usecs(ftrace_update_time);
+			if (ftrace_update_tot_cnt > 100000) {
+				ftrace_update_tot_cnt = 0;
+				pr_info("hm, dftrace overflow: %lu change%s"
+					" (%lu total) in %lu usec%s\n",
+					ftrace_update_cnt,
+					ftrace_update_cnt != 1 ? "s" : "",
+					ftrace_update_tot_cnt,
+					usecs, usecs != 1 ? "s" : "");
+				ftrace_disabled = 1;
+				WARN_ON_ONCE(1);
+			}
+		}
+		mutex_unlock(&ftraced_lock);
+		mutex_unlock(&ftrace_sysctl_lock);
+
+		ftrace_shutdown_replenish();
+	}
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+
 static int __init ftrace_dynamic_init(void)
 {
 	struct task_struct *p;
@@ -1579,7 +1639,7 @@ static int __init ftrace_dynamic_init(vo
 		goto failed;
 	}
 
-	ret = ftrace_dyn_table_alloc();
+	ret = ftrace_dyn_table_alloc(NR_TO_INIT);
 	if (ret)
 		goto failed;
 
@@ -1600,6 +1660,8 @@ static int __init ftrace_dynamic_init(vo
 }
 
 core_initcall(ftrace_dynamic_init);
+#endif /* CONFIG_FTRACE_MCOUNT_RECORD */
+
 #else
 # define ftrace_startup()		do { } while (0)
 # define ftrace_shutdown()		do { } while (0)

-- 

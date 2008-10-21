Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYJUQnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYJUQnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYJUQnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:43:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55978 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYJUQnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:43:06 -0400
Message-Id: <20081021164302.399002797@goodmis.org>
References: <20081021164018.889518687@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 21 Oct 2008 12:40:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] ftrace: make dynamic ftrace more robust
Content-Disposition: inline; filename=ftrace-more-robust-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up some of the ftrace code as well as adds some
more sanity checks. If any of the sanity checks fail, a warning will
be printed and ftrace will be disabled.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |   15 ++++++++++-----
 include/linux/ftrace.h   |    7 ++++++-
 include/linux/init.h     |   10 +++++-----
 kernel/trace/ftrace.c    |   35 +++++++++++++++++++++++++++++++----
 4 files changed, 52 insertions(+), 15 deletions(-)

Index: linux-compile.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/ftrace.c	2008-10-20 19:39:54.000000000 -0400
+++ linux-compile.git/arch/x86/kernel/ftrace.c	2008-10-20 19:42:02.000000000 -0400
@@ -66,19 +66,24 @@ ftrace_modify_code(unsigned long ip, uns
 	/*
 	 * Note: Due to modules and __init, code can
 	 *  disappear and change, we need to protect against faulting
-	 *  as well as code changing.
+	 *  as well as code changing. We do this by using the
+	 *  __copy_*_user functions.
 	 *
 	 * No real locking needed, this code is run through
 	 * kstop_machine, or before SMP starts.
 	 */
+
+	/* read the text we want to modify */
 	if (__copy_from_user_inatomic(replaced, (char __user *)ip, MCOUNT_INSN_SIZE))
-		return 1;
+		return FTRACE_CODE_FAILED_READ;
 
+	/* Make sure it is what we expect it to be */
 	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
-		return 2;
+		return FTRACE_CODE_FAILED_CMP;
 
-	WARN_ON_ONCE(__copy_to_user_inatomic((char __user *)ip, new_code,
-				    MCOUNT_INSN_SIZE));
+	/* replace the text with the new text */
+	if (__copy_to_user_inatomic((char __user *)ip, new_code, MCOUNT_INSN_SIZE))
+		return FTRACE_CODE_FAILED_WRITE;
 
 	sync_core();
 
Index: linux-compile.git/include/linux/ftrace.h
===================================================================
--- linux-compile.git.orig/include/linux/ftrace.h	2008-10-20 19:39:54.000000000 -0400
+++ linux-compile.git/include/linux/ftrace.h	2008-10-20 19:47:23.000000000 -0400
@@ -232,6 +232,11 @@ static inline void start_boot_trace(void
 static inline void stop_boot_trace(void) { }
 #endif
 
-
+enum {
+	FTRACE_CODE_MODIFIED,
+	FTRACE_CODE_FAILED_READ,
+	FTRACE_CODE_FAILED_CMP,
+	FTRACE_CODE_FAILED_WRITE,
+};
 
 #endif /* _LINUX_FTRACE_H */
Index: linux-compile.git/include/linux/init.h
===================================================================
--- linux-compile.git.orig/include/linux/init.h	2008-10-20 19:39:54.000000000 -0400
+++ linux-compile.git/include/linux/init.h	2008-10-20 19:40:06.000000000 -0400
@@ -75,15 +75,15 @@
 
 
 #ifdef MODULE
-#define __exitused
+#define __exitused  notrace
 #else
-#define __exitused  __used
+#define __exitused  __used  notrace
 #endif
 
 #define __exit          __section(.exit.text) __exitused __cold
 
 /* Used for HOTPLUG */
-#define __devinit        __section(.devinit.text) __cold
+#define __devinit        __section(.devinit.text) __cold notrace
 #define __devinitdata    __section(.devinit.data)
 #define __devinitconst   __section(.devinit.rodata)
 #define __devexit        __section(.devexit.text) __exitused __cold
@@ -91,7 +91,7 @@
 #define __devexitconst   __section(.devexit.rodata)
 
 /* Used for HOTPLUG_CPU */
-#define __cpuinit        __section(.cpuinit.text) __cold
+#define __cpuinit        __section(.cpuinit.text) __cold notrace
 #define __cpuinitdata    __section(.cpuinit.data)
 #define __cpuinitconst   __section(.cpuinit.rodata)
 #define __cpuexit        __section(.cpuexit.text) __exitused __cold
@@ -99,7 +99,7 @@
 #define __cpuexitconst   __section(.cpuexit.rodata)
 
 /* Used for MEMORY_HOTPLUG */
-#define __meminit        __section(.meminit.text) __cold
+#define __meminit        __section(.meminit.text) __cold notrace
 #define __meminitdata    __section(.meminit.data)
 #define __meminitconst   __section(.meminit.rodata)
 #define __memexit        __section(.memexit.text) __exitused __cold
Index: linux-compile.git/kernel/trace/ftrace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/ftrace.c	2008-10-20 19:39:54.000000000 -0400
+++ linux-compile.git/kernel/trace/ftrace.c	2008-10-20 19:46:00.000000000 -0400
@@ -318,6 +318,14 @@ static inline void ftrace_del_hash(struc
 
 static void ftrace_free_rec(struct dyn_ftrace *rec)
 {
+	/*
+	 * No locking, only called from kstop_machine, or
+	 * from module unloading with module locks and interrupts
+	 * disabled to prevent kstop machine from running.
+	 */
+
+	WARN_ON(rec->flags & FTRACE_FL_FREE);
+
 	rec->ip = (unsigned long)ftrace_free_records;
 	ftrace_free_records = rec;
 	rec->flags |= FTRACE_FL_FREE;
@@ -346,7 +354,6 @@ void ftrace_release(void *start, unsigne
 		}
 	}
 	spin_unlock(&ftrace_lock);
-
 }
 
 static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
@@ -556,9 +563,12 @@ static void ftrace_replace_code(int enab
 
 			failed = __ftrace_replace_code(rec, old, new, enable);
 			if (failed && (rec->flags & FTRACE_FL_CONVERTED)) {
+				/* kprobes can cause this failure */
 				rec->flags |= FTRACE_FL_FAILED;
 				if ((system_state == SYSTEM_BOOTING) ||
 				    !core_kernel_text(rec->ip)) {
+					/* kprobes was not the fault */
+					ftrace_kill_atomic();
 					ftrace_del_hash(rec);
 					ftrace_free_rec(rec);
 				}
@@ -601,12 +611,12 @@ ftrace_code_disable(struct dyn_ftrace *r
 	failed = ftrace_modify_code(ip, call, nop);
 	if (failed) {
 		switch (failed) {
-		case 1:
+		case FTRACE_CODE_FAILED_READ:
 			WARN_ON_ONCE(1);
 			pr_info("ftrace faulted on modifying ");
 			print_ip_sym(ip);
 			break;
-		case 2:
+		case FTRACE_CODE_FAILED_CMP:
 			WARN_ON_ONCE(1);
 			pr_info("ftrace failed to modify ");
 			print_ip_sym(ip);
@@ -615,7 +625,18 @@ ftrace_code_disable(struct dyn_ftrace *r
 			print_ip_ins(" replace: ", nop);
 			printk(KERN_CONT "\n");
 			break;
+		case FTRACE_CODE_FAILED_WRITE:
+			WARN_ON_ONCE(1);
+			pr_info("ftrace failed to write ");
+			print_ip_sym(ip);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			pr_info("ftrace unkown error ");
+			print_ip_sym(ip);
+			break;
 		}
+		ftrace_kill_atomic();
 
 		rec->flags |= FTRACE_FL_FAILED;
 		return 0;
@@ -789,6 +810,11 @@ static int __ftrace_update_code(void *ig
 
 	/* No locks needed, the machine is stopped! */
 	for (i = 0; i < FTRACE_HASHSIZE; i++) {
+
+		/* If something went wrong, bail without enabling anything */
+		if (unlikely(ftrace_disabled))
+			return;
+
 		INIT_HLIST_HEAD(&temp_list);
 		head = &ftrace_hash[i];
 
@@ -796,7 +822,8 @@ static int __ftrace_update_code(void *ig
 		hlist_for_each_entry_safe(p, t, n, head, node) {
 			/* Skip over failed records which have not been
 			 * freed. */
-			if (p->flags & FTRACE_FL_FAILED)
+			if (p->flags & FTRACE_FL_FAILED ||
+			    p->flags & FTRACE_FL_FREE)
 				continue;
 
 			/* Unconverted records are always at the head of the

-- 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab0BLWn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:43:26 -0500
Received: from mail.windriver.com ([147.11.1.11]:45142 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab0BLWnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:43:19 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/8] x86, kgdb, init: Add early and late debug states
Date: Fri, 12 Feb 2010 16:39:23 -0600
Message-Id: <1266014369-29547-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014369-29547-1-git-send-email-jason.wessel@windriver.com>
References: <1266014369-29547-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:43:07.0640 (UTC) FILETIME=[BF02F780:01CAAC34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel debugger can operate well before mm_init(), but the x86
hardware breakpoint code which uses the perf api requires that the
kernel allocators are initialized.

This means the kernel debug core needs to provide an optional arch
specific call back to allow the initialization functions to run after
the kernel has been further initialized.

The kdb shell already had a similar restriction with an early
initialization and late initialization.  The kdb_init() was moved into
the debug core's version of the late init which is called
dbg_late_init();

CC: kgdb-bugreport@lists.sourceforge.net
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c    |   17 ++++++++++-------
 include/linux/kgdb.h      |   14 ++++++++++++++
 init/main.c               |    4 ++--
 kernel/debug/debug_core.c |   16 ++++++++++++++++
 4 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 3b762bc..896874a 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -596,14 +596,15 @@ static struct notifier_block kgdb_notifier = {
  */
 int kgdb_arch_init(void)
 {
+	return register_die_notifier(&kgdb_notifier);
+}
+
+void kgdb_arch_late(void)
+{
 	int i, cpu;
-	int ret;
 	struct perf_event_attr attr;
 	struct perf_event **pevent;
 
-	ret = register_die_notifier(&kgdb_notifier);
-	if (ret != 0)
-		return ret;
 	/*
 	 * Pre-allocate the hw breakpoint structions in the non-atomic
 	 * portion of kgdb because this operation requires mutexs to
@@ -615,12 +616,15 @@ int kgdb_arch_init(void)
 	attr.bp_type = HW_BREAKPOINT_W;
 	attr.disabled = 1;
 	for (i = 0; i < 4; i++) {
+		if (breakinfo[i].pev)
+			continue;
 		breakinfo[i].pev = register_wide_hw_breakpoint(&attr, NULL);
 		if (IS_ERR(breakinfo[i].pev)) {
-			printk(KERN_ERR "kgdb: Could not allocate hw breakpoints\n");
+			printk(KERN_ERR "kgdb: Could not allocate hw"
+			       "breakpoints\nDisabling the kernel debugger\n");
 			breakinfo[i].pev = NULL;
 			kgdb_arch_exit();
-			return -1;
+			return;
 		}
 		for_each_online_cpu(cpu) {
 			pevent = per_cpu_ptr(breakinfo[i].pev, cpu);
@@ -631,7 +635,6 @@ int kgdb_arch_init(void)
 			}
 		}
 	}
-	return ret;
 }
 
 /**
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 2d9b738..6a7c05c 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -208,6 +208,17 @@ extern int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr);
 extern int kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle);
 
 /**
+ *	kgdb_arch_late - Perform any architecture specific initalization.
+ *
+ *	This function will handle the late initalization of any
+ *	architecture specific callbacks.  This is an optional function for
+ *	handling things like late initialization of hw breakpoints.  The
+ *	default implementation does nothing.
+ */
+extern void kgdb_arch_late(void);
+
+
+/**
  * struct kgdb_arch - Describe architecture specific values.
  * @gdb_bpt_instr: The instruction to trigger a breakpoint.
  * @flags: Flags for the breakpoint, currently just %KGDB_HW_BREAKPOINT.
@@ -303,6 +314,8 @@ struct dbg_kms_ops {
 #define in_dbg_master() \
 	(raw_smp_processor_id() == atomic_read(&kgdb_active))
 
+extern bool dbg_is_early;
+extern void __init dbg_late_init(void);
 extern struct dbg_kms_ops *dbg_kms_ops;
 extern int dbg_kms_ops_register(struct dbg_kms_ops *ops);
 extern int dbg_kms_ops_unregister(struct dbg_kms_ops *ops);
@@ -313,6 +326,7 @@ extern int dbg_kms_ops_unregister(struct dbg_kms_ops *ops);
 	if (!in_dbg_master()) \
 		mutex_unlock(x)
 #else /* ! CONFIG_KGDB */
+#define dbg_late_init()
 #define in_dbg_master() (0)
 
 static inline int dbg_kms_ops_register(struct dbg_kms_ops *ops)
diff --git a/init/main.c b/init/main.c
index 9d415a1..1839e3f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -63,7 +63,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
-#include <linux/kdb.h>
+#include <linux/kgdb.h>
 #include <linux/ftrace.h>
 #include <linux/async.h>
 #include <linux/kmemcheck.h>
@@ -660,7 +660,7 @@ asmlinkage void __init start_kernel(void)
 	key_init();
 	radix_tree_init();
 	security_init();
-	kdb_init(KDB_INIT_FULL);
+	dbg_late_init();
 	vfs_caches_init(totalram_pages);
 	signals_init();
 	/* rootfs populating might need page-writeback */
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index bcd6286..48e0e65 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -78,6 +78,8 @@ static DEFINE_SPINLOCK(kgdb_registration_lock);
 static int kgdb_con_registered;
 /* determine if kgdb console output should be used */
 static int kgdb_use_con;
+/* Flag for alternate operations for early debugging */
+bool dbg_is_early = true;
 /* Next cpu to become the master debug core */
 int dbg_switch_cpu;
 
@@ -776,11 +778,17 @@ static struct notifier_block kgdb_panic_event_nb = {
        .notifier_call  = kgdb_panic_event,
 };
 
+void __weak kgdb_arch_late(void)
+{
+}
+
 static void kgdb_register_callbacks(void)
 {
 	if (!kgdb_io_module_registered) {
 		kgdb_io_module_registered = 1;
 		kgdb_arch_init();
+		if (!dbg_is_early)
+			kgdb_arch_late();
 		atomic_notifier_chain_register(&panic_notifier_list,
 					       &kgdb_panic_event_nb);
 #ifdef CONFIG_MAGIC_SYSRQ
@@ -793,6 +801,14 @@ static void kgdb_register_callbacks(void)
 	}
 }
 
+void __init dbg_late_init(void)
+{
+	dbg_is_early = false;
+	if (kgdb_io_module_registered)
+		kgdb_arch_late();
+	kdb_init(KDB_INIT_FULL);
+}
+
 struct dbg_kms_ops *dbg_kms_ops;
 EXPORT_SYMBOL_GPL(dbg_kms_ops);
 
-- 
1.6.4.rc1


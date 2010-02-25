Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933964Ab0BYVXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:23:01 -0500
Received: from mail.windriver.com ([147.11.1.11]:63535 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933823Ab0BYVWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:22:30 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 19/28] mips,kgdb: kdb low level trap catch and stack trace
Date: Thu, 25 Feb 2010 15:21:24 -0600
Message-Id: <1267132893-23624-20-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Feb 2010 21:21:56.0930 (UTC) FILETIME=[8F365A20:01CAB660]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only way the debugger can handle a trap in inside rcu_lock,
notify_die, or atomic_notifier_call_chain without a recursive fault is
to have a low level "first opportunity handler" do_trap_or_bp() handler.

Generally this will be something the vast majority of folks will not
need, but for those who need it, it is added as a kernel .config
option called KGDB_LOW_LEVEL_TRAP.

Also added was a die notification for oops such that kdb can catch an
oops for analysis.

There appeared to be no obvious way to pass the struct pt_regs from
the original exception back to the stack back tracer, so a special
case was added to show_stack() for when kdb is active because you
generally desire to generally look at the back trace of the original
exception.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/include/asm/kgdb.h |    2 ++
 arch/mips/kernel/kgdb.c      |   22 +++++++++++++++++++++-
 arch/mips/kernel/traps.c     |   13 +++++++++++++
 lib/Kconfig.kgdb             |    2 +-
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/kgdb.h b/arch/mips/include/asm/kgdb.h
index 48223b0..19002d6 100644
--- a/arch/mips/include/asm/kgdb.h
+++ b/arch/mips/include/asm/kgdb.h
@@ -38,6 +38,8 @@ extern int kgdb_early_setup;
 extern void *saved_vectors[32];
 extern void handle_exception(struct pt_regs *regs);
 extern void breakinst(void);
+extern int kgdb_ll_trap(int cmd, const char *str,
+			struct pt_regs *regs, long err, int trap, int sig);
 
 #endif				/* __KERNEL__ */
 
diff --git a/arch/mips/kernel/kgdb.c b/arch/mips/kernel/kgdb.c
index 6ed4c83..9b78ff6 100644
--- a/arch/mips/kernel/kgdb.c
+++ b/arch/mips/kernel/kgdb.c
@@ -203,7 +203,7 @@ static int kgdb_mips_notify(struct notifier_block *self, unsigned long cmd,
 	if (atomic_read(&kgdb_active) != -1)
 		kgdb_nmicallback(smp_processor_id(), regs);
 
-	if (kgdb_handle_exception(trap, compute_signal(trap), 0, regs))
+	if (kgdb_handle_exception(trap, compute_signal(trap), cmd, regs))
 		return NOTIFY_DONE;
 
 	if (atomic_read(&kgdb_setting_breakpoint))
@@ -217,6 +217,26 @@ static int kgdb_mips_notify(struct notifier_block *self, unsigned long cmd,
 	return NOTIFY_STOP;
 }
 
+#ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
+int kgdb_ll_trap(int cmd, const char *str,
+		 struct pt_regs *regs, long err, int trap, int sig)
+{
+	struct die_args args = {
+		.regs	= regs,
+		.str	= str,
+		.err	= err,
+		.trapnr	= trap,
+		.signr	= sig,
+
+	};
+
+	if (!kgdb_io_module_registered)
+		return NOTIFY_DONE;
+
+	return kgdb_mips_notify(NULL, cmd, &args);
+}
+#endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
+
 static struct notifier_block kgdb_notifier = {
 	.notifier_call = kgdb_mips_notify,
 };
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 31b204b..241b0d1 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -26,6 +26,7 @@
 #include <linux/kgdb.h>
 #include <linux/kdebug.h>
 #include <linux/notifier.h>
+#include <linux/kdb.h>
 
 #include <asm/bootinfo.h>
 #include <asm/branch.h>
@@ -184,6 +185,11 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 			regs.regs[29] = task->thread.reg29;
 			regs.regs[31] = 0;
 			regs.cp0_epc = task->thread.reg31;
+#ifdef CONFIG_KGDB_KDB
+		} else if (atomic_read(&kgdb_active) != -1 &&
+			   kdb_current_regs) {
+			memcpy(&regs, kdb_current_regs, sizeof(regs));
+#endif /* CONFIG_KGDB_KDB */
 		} else {
 			prepare_frametrace(&regs);
 		}
@@ -358,6 +364,8 @@ void __noreturn die(const char * str, const struct pt_regs * regs)
 	unsigned long dvpret = dvpe();
 #endif /* CONFIG_MIPS_MT_SMTC */
 
+	notify_die(DIE_OOPS, str, (struct pt_regs *)regs, SIGSEGV, 0, 0);
+
 	console_verbose();
 	spin_lock_irq(&die_lock);
 	bust_spinlocks(1);
@@ -698,6 +706,11 @@ static void do_trap_or_bp(struct pt_regs *regs, unsigned int code,
 	siginfo_t info;
 	char b[40];
 
+#ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
+	if (kgdb_ll_trap(DIE_TRAP, str, regs, code, 0, 0) == NOTIFY_STOP)
+		return;
+#endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
+
 	if (notify_die(DIE_TRAP, str, regs, code, 0, 0) == NOTIFY_STOP)
 		return;
 
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 0a0e049..8711264 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -59,7 +59,7 @@ config KGDB_TESTS_BOOT_STRING
 
 config KGDB_LOW_LEVEL_TRAP
        bool "KGDB: Allow debugging with traps in notifiers"
-       depends on X86
+       depends on X86 || MIPS
        default n
        help
          This will add an extra call back to kgdb for the breakpoint
-- 
1.6.4.rc1


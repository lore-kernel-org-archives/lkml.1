Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab0BLWiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:38:14 -0500
Received: from mail.windriver.com ([147.11.1.11]:44203 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab0BLWgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:36:53 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 18/28] powerpc,kgdb: Introduce low level trap catching
Date: Fri, 12 Feb 2010 16:35:33 -0600
Message-Id: <1266014143-29444-19-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:36:19.0864 (UTC) FILETIME=[CBF54980:01CAAC33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only way the debugger can handle a trap in inside rcu_lock,
notify_die, or atomic_notifier_call_chain without a recursive fault is
to have a low level "first opportunity handler" low level
program_check_exception() handler.

The other change here is to make sure that kgdb_handle_exception() is
called with correct parameters when catching an oops, because kdb
needs to know if the entry was an oops, single step, or breakpoint
exception.

CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/powerpc/kernel/kgdb.c  |    7 +++++--
 arch/powerpc/kernel/traps.c |    7 +++++++
 lib/Kconfig.kgdb            |    2 +-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 7aafcc5..c06fe55 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -20,6 +20,7 @@
 #include <linux/smp.h>
 #include <linux/signal.h>
 #include <linux/ptrace.h>
+#include <linux/kdebug.h>
 #include <asm/current.h>
 #include <asm/processor.h>
 #include <asm/machdep.h>
@@ -115,7 +116,9 @@ void kgdb_roundup_cpus(unsigned long flags)
 /* KGDB functions to use existing PowerPC64 hooks. */
 static int kgdb_debugger(struct pt_regs *regs)
 {
-	return kgdb_handle_exception(0, computeSignal(TRAP(regs)), 0, regs);
+	if (kgdb_handle_exception(1, computeSignal(TRAP(regs)), DIE_OOPS, regs))
+		return 0;
+	return 1;
 }
 
 static int kgdb_handle_breakpoint(struct pt_regs *regs)
@@ -123,7 +126,7 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
 	if (user_mode(regs))
 		return 0;
 
-	if (kgdb_handle_exception(0, SIGTRAP, 0, regs) != 0)
+	if (kgdb_handle_exception(1, SIGTRAP, 0, regs) != 0)
 		return 0;
 
 	if (*(u32 *) (regs->nip) == *(u32 *) (&arch_kgdb_ops.gdb_bpt_instr))
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index d069ff8..379104a 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -809,12 +809,19 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 		return;
 	}
 	if (reason & REASON_TRAP) {
+
+#ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
+		if (debugger_bpt(regs))
+			return;
+#endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
 		/* trap exception */
 		if (notify_die(DIE_BPT, "breakpoint", regs, 5, 5, SIGTRAP)
 				== NOTIFY_STOP)
 			return;
+#ifndef CONFIG_KGDB_LOW_LEVEL_TRAP
 		if (debugger_bpt(regs))
 			return;
+#endif /* ! CONFIG_KGDB_LOW_LEVEL_TRAP */
 
 		if (!(regs->msr & MSR_PR) &&  /* not user-mode */
 		    report_bug(regs->nip, regs) == BUG_TRAP_TYPE_WARN) {
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 0a0e049..2b1601b 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -59,7 +59,7 @@ config KGDB_TESTS_BOOT_STRING
 
 config KGDB_LOW_LEVEL_TRAP
        bool "KGDB: Allow debugging with traps in notifiers"
-       depends on X86
+       depends on X86 || PPC
        default n
        help
          This will add an extra call back to kgdb for the breakpoint
-- 
1.6.4.rc1


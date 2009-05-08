Return-Path: <linux-kernel-owner+w=401wt.eu-S1764406AbZEHV0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764406AbZEHV0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762172AbZEHVXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:23:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:44765 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966AbZEHVXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:23:36 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 09/13] RFC ONLY - powerpc,kgdb: Introduce low level trap catching
Date: Fri,  8 May 2009 16:23:16 -0500
Message-Id: <1241817800-9320-10-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241817800-9320-9-git-send-email-jason.wessel@windriver.com>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-2-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-3-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-4-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-5-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-6-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-7-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-8-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-9-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 08 May 2009 21:23:31.0075 (UTC) FILETIME=[3C4AFD30:01C9D023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a RFC patch.  The work to possibly merge kdb and kgdb is being
evaluated and this patch is considered only a proof of concept or
prototype.

The only way the debugger can handle a trap in inside rcu_lock,
notify_die, or atomic_notifier_call_chain without a recursive fault is
to have a low level "first opportunity handler" low level
program_check_exception() handler.

The other change here is to make sure that kgdb_handle_exception() is
called with correct parameters when catching an oops, because kdb
needs to know if the entry was an oops, single step, or breakpoint
exception.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/powerpc/kernel/kgdb.c  |    7 +++++--
 arch/powerpc/kernel/traps.c |    7 +++++++
 lib/Kconfig.kgdb            |    2 +-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index e8207a3..d0ef25c 100644
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
index 678fbff..ae409df 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -812,12 +812,19 @@ void __kprobes program_check_exception(struct pt_regs *regs)
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
index 617f797..a2f63be 100644
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
1.6.3.rc0.1.gf800


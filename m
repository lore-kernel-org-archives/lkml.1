Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZLWVVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZLWVVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbZLWVV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:21:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:45138 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbZLWVUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:48 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 21/37] powerpc,kgdb: Introduce low level trap catching
Date: Wed, 23 Dec 2009 15:19:34 -0600
Message-Id: <1261603190-5036-22-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-21-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-13-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-17-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-18-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-19-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-20-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-21-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:21.0395 (UTC) FILETIME=[BBD4DE30:01CA8415]
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
index 2172c69..64cc65d 100644
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911Ab0BYVWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:22:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:63530 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933803Ab0BYVW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:22:29 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 18/28] powerpc,kgdb: Introduce low level trap catching
Date: Thu, 25 Feb 2010 15:21:23 -0600
Message-Id: <1267132893-23624-19-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Feb 2010 21:21:56.0008 (UTC) FILETIME=[8EA9AA80:01CAB660]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only way the debugger can handle a trap in inside rcu_lock,
notify_die, or atomic_notifier_call_chain without a recursive fault is
to allow the kernel debugger to handle the exception first in
program_check_exception().

The other change here is to make sure that kgdb_handle_exception() is
called with correct parameters when catching an oops, because kdb
needs to know if the entry was an oops, single step, or breakpoint
exception.

[benh@kernel.crashing.org: move debugger_bpt instead of #ifdef]

CC: Paul Mackerras <paulus@samba.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/kernel/kgdb.c  |    6 ++++--
 arch/powerpc/kernel/traps.c |    7 +++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 7aafcc5..8ee7b6e 100644
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
@@ -115,7 +116,8 @@ void kgdb_roundup_cpus(unsigned long flags)
 /* KGDB functions to use existing PowerPC64 hooks. */
 static int kgdb_debugger(struct pt_regs *regs)
 {
-	return kgdb_handle_exception(0, computeSignal(TRAP(regs)), 0, regs);
+	return !kgdb_handle_exception(1, computeSignal(TRAP(regs)),
+				      DIE_OOPS, regs);
 }
 
 static int kgdb_handle_breakpoint(struct pt_regs *regs)
@@ -123,7 +125,7 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
 	if (user_mode(regs))
 		return 0;
 
-	if (kgdb_handle_exception(0, SIGTRAP, 0, regs) != 0)
+	if (kgdb_handle_exception(1, SIGTRAP, 0, regs) != 0)
 		return 0;
 
 	if (*(u32 *) (regs->nip) == *(u32 *) (&arch_kgdb_ops.gdb_bpt_instr))
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index d069ff8..9b72f08 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -809,12 +809,15 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 		return;
 	}
 	if (reason & REASON_TRAP) {
+		/* Debugger is first in line to stop recursive faults in
+		 * rcu_lock, notify_die, or atomic_notifier_call_chain */
+		if (debugger_bpt(regs))
+			return;
+
 		/* trap exception */
 		if (notify_die(DIE_BPT, "breakpoint", regs, 5, 5, SIGTRAP)
 				== NOTIFY_STOP)
 			return;
-		if (debugger_bpt(regs))
-			return;
 
 		if (!(regs->msr & MSR_PR) &&  /* not user-mode */
 		    report_bug(regs->nip, regs) == BUG_TRAP_TYPE_WARN) {
-- 
1.6.4.rc1


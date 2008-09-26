Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYIZSHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYIZSHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYIZSGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:06:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:37244 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbYIZSGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:06:14 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 2/5] kgdb, x86, arm, mips, powerpc: ignore user space single stepping
Date: Fri, 26 Sep 2008 13:05:17 -0500
Message-Id: <1222452320-16281-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.90.g436ed.dirty
In-Reply-To: <1222452320-16281-2-git-send-email-jason.wessel@windriver.com>
References: <1222452320-16281-1-git-send-email-jason.wessel@windriver.com>
 <1222452320-16281-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 26 Sep 2008 18:05:36.0737 (UTC) FILETIME=[7A1ACD10:01C92002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the x86 arch, user space single step exceptions should be ignored
if they occur in the kernel space, such as ptrace stepping through a
system call.

First check if it is kgdb that is executing a single step, then ensure
it is not an accidental traversal into the user space, while in kgdb,
any other time the TIF_SINGLESTEP is set, kgdb should ignore the
exception.

On x86, arm, mips and powerpc, the kgdb_contthread usage was
inconsistent with the way single stepping is implemented in the kgdb
core.  The arch specific stub should always set the
kgdb_cpu_doing_single_step correctly if it is single stepping.  This
allows kgdb to correctly process an instruction steps if ptrace
happens to be requesting an instruction step over a system call.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/arm/kernel/kgdb.c     |    2 --
 arch/mips/kernel/kgdb.c    |    3 +--
 arch/powerpc/kernel/kgdb.c |    5 ++---
 arch/x86/kernel/kgdb.c     |   18 +++++++++++-------
 kernel/kgdb.c              |    8 ++++----
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index aaffaec..ba8ccfe 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -111,8 +111,6 @@ int kgdb_arch_handle_exception(int exception_vector, int signo,
 	case 'D':
 	case 'k':
 	case 'c':
-		kgdb_contthread = NULL;
-
 		/*
 		 * Try to read optional parameter, pc unchanged if no parm.
 		 * If this was a compiled breakpoint, we need to move
diff --git a/arch/mips/kernel/kgdb.c b/arch/mips/kernel/kgdb.c
index 8f6d58e..6e152c8 100644
--- a/arch/mips/kernel/kgdb.c
+++ b/arch/mips/kernel/kgdb.c
@@ -236,8 +236,7 @@ int kgdb_arch_handle_exception(int vector, int signo, int err_code,
 
 		atomic_set(&kgdb_cpu_doing_single_step, -1);
 		if (remcom_in_buffer[0] == 's')
-			if (kgdb_contthread)
-				atomic_set(&kgdb_cpu_doing_single_step, cpu);
+			atomic_set(&kgdb_cpu_doing_single_step, cpu);
 
 		return 0;
 	}
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index b4fdf2f..fe8f71d 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -347,9 +347,8 @@ int kgdb_arch_handle_exception(int vector, int signo, int err_code,
 			linux_regs->msr |= MSR_SE;
 #endif
 			kgdb_single_step = 1;
-			if (kgdb_contthread)
-				atomic_set(&kgdb_cpu_doing_single_step,
-					   raw_smp_processor_id());
+			atomic_set(&kgdb_cpu_doing_single_step,
+				   raw_smp_processor_id());
 		}
 		return 0;
 	}
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index f47f0eb..00f7896 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -378,10 +378,8 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 		if (remcomInBuffer[0] == 's') {
 			linux_regs->flags |= X86_EFLAGS_TF;
 			kgdb_single_step = 1;
-			if (kgdb_contthread) {
-				atomic_set(&kgdb_cpu_doing_single_step,
-					   raw_smp_processor_id());
-			}
+			atomic_set(&kgdb_cpu_doing_single_step,
+				   raw_smp_processor_id());
 		}
 
 		get_debugreg(dr6, 6);
@@ -466,9 +464,15 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 
 	case DIE_DEBUG:
 		if (atomic_read(&kgdb_cpu_doing_single_step) ==
-			raw_smp_processor_id() &&
-			user_mode(regs))
-			return single_step_cont(regs, args);
+		    raw_smp_processor_id()) {
+			if (user_mode(regs))
+				return single_step_cont(regs, args);
+			break;
+		} else if (test_thread_flag(TIF_SINGLESTEP))
+			/* This means a user thread is single stepping
+			 * a system call which should be ignored
+			 */
+			return NOTIFY_DONE;
 		/* fall through */
 	default:
 		if (user_mode(regs))
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 949806a..25d955d 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1462,7 +1462,7 @@ acquirelock:
 	 * Get the passive CPU lock which will hold all the non-primary
 	 * CPU in a spin state while the debugger is active
 	 */
-	if (!kgdb_single_step || !kgdb_contthread) {
+	if (!kgdb_single_step) {
 		for (i = 0; i < NR_CPUS; i++)
 			atomic_set(&passive_cpu_wait[i], 1);
 	}
@@ -1475,7 +1475,7 @@ acquirelock:
 
 #ifdef CONFIG_SMP
 	/* Signal the other CPUs to enter kgdb_wait() */
-	if ((!kgdb_single_step || !kgdb_contthread) && kgdb_do_roundup)
+	if ((!kgdb_single_step) && kgdb_do_roundup)
 		kgdb_roundup_cpus(flags);
 #endif
 
@@ -1494,7 +1494,7 @@ acquirelock:
 	kgdb_post_primary_code(ks->linux_regs, ks->ex_vector, ks->err_code);
 	kgdb_deactivate_sw_breakpoints();
 	kgdb_single_step = 0;
-	kgdb_contthread = NULL;
+	kgdb_contthread = current;
 	exception_level = 0;
 
 	/* Talk to debugger with gdbserial protocol */
@@ -1508,7 +1508,7 @@ acquirelock:
 	kgdb_info[ks->cpu].task = NULL;
 	atomic_set(&cpu_in_kgdb[ks->cpu], 0);
 
-	if (!kgdb_single_step || !kgdb_contthread) {
+	if (!kgdb_single_step) {
 		for (i = NR_CPUS-1; i >= 0; i--)
 			atomic_set(&passive_cpu_wait[i], 0);
 		/*
-- 
1.6.0.90.g436ed.dirty


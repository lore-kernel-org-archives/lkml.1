Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbXCJIRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbXCJIRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933537AbXCJIRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:17:47 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:34938 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933534AbXCJIRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:17:46 -0500
Date: Sat, 10 Mar 2007 03:17:43 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, mbligh@google.com, linux-kernel@vger.kernel.org,
       wli@holomorphy.com, sparclinux@vger.kernel.org
Subject: [PATCH] Fix sparc TIF_USEDFPU flag atomicity
Message-ID: <20070310081743.GC23144@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparc TIF_USEDFPU flag atomicity

Non atomic update of TIF can be very dangerous, except at thread structure
creation time. Here I standardize the TIF_USEDFPU usage of the sparc arch.
This fix addresses the issue with *_ti_thread_flag().

Applies on 2.6.20.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/sparc/kernel/process.c
+++ b/arch/sparc/kernel/process.c
@@ -348,7 +348,7 @@ void exit_thread(void)
 #ifndef CONFIG_SMP
 	if(last_task_used_math == current) {
 #else
-	if(current_thread_info()->flags & _TIF_USEDFPU) {
+	if(test_ti_thread_flag(current_thread_info(), TIF_USEDFPU)) {
 #endif
 		/* Keep process from leaving FPU in a bogon state. */
 		put_psr(get_psr() | PSR_EF);
@@ -357,7 +357,7 @@ void exit_thread(void)
 #ifndef CONFIG_SMP
 		last_task_used_math = NULL;
 #else
-		current_thread_info()->flags &= ~_TIF_USEDFPU;
+		clear_ti_thread_flag(current_thread_info(), TIF_USEDFPU);
 #endif
 	}
 }
@@ -371,7 +371,7 @@ void flush_thread(void)
 #ifndef CONFIG_SMP
 	if(last_task_used_math == current) {
 #else
-	if(current_thread_info()->flags & _TIF_USEDFPU) {
+	if(test_ti_thread_flag(current_thread_info(), TIF_USEDFPU)) {
 #endif
 		/* Clean the fpu. */
 		put_psr(get_psr() | PSR_EF);
@@ -380,7 +380,7 @@ void flush_thread(void)
 #ifndef CONFIG_SMP
 		last_task_used_math = NULL;
 #else
-		current_thread_info()->flags &= ~_TIF_USEDFPU;
+		clear_ti_thread_flag(current_thread_info(), TIF_USEDFPU);
 #endif
 	}
 
@@ -466,13 +466,13 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 #ifndef CONFIG_SMP
 	if(last_task_used_math == current) {
 #else
-	if(current_thread_info()->flags & _TIF_USEDFPU) {
+	if(test_ti_thread_flag(current_thread_info(), TIF_USEDFPU)) {
 #endif
 		put_psr(get_psr() | PSR_EF);
 		fpsave(&p->thread.float_regs[0], &p->thread.fsr,
 		       &p->thread.fpqueue[0], &p->thread.fpqdepth);
 #ifdef CONFIG_SMP
-		current_thread_info()->flags &= ~_TIF_USEDFPU;
+		clear_ti_thread_flag(current_thread_info(), TIF_USEDFPU);
 #endif
 	}
 
@@ -609,13 +609,14 @@ int dump_fpu (struct pt_regs * regs, elf_fpregset_t * fpregs)
 		return 1;
 	}
 #ifdef CONFIG_SMP
-	if (current_thread_info()->flags & _TIF_USEDFPU) {
+	if (test_ti_thread_flag(current_thread_info(), TIF_USEDFPU)) {
 		put_psr(get_psr() | PSR_EF);
 		fpsave(&current->thread.float_regs[0], &current->thread.fsr,
 		       &current->thread.fpqueue[0], &current->thread.fpqdepth);
 		if (regs != NULL) {
 			regs->psr &= ~(PSR_EF);
-			current_thread_info()->flags &= ~(_TIF_USEDFPU);
+			clear_ti_thread_flag(current_thread_info(),
+				TIF_USEDFPU);
 		}
 	}
 #else
diff --git a/arch/sparc/kernel/traps.c b/arch/sparc/kernel/traps.c
index 6a70d21..8ec8d08 100644
--- a/arch/sparc/kernel/traps.c
+++ b/arch/sparc/kernel/traps.c
@@ -259,7 +259,7 @@ void do_fpd_trap(struct pt_regs *regs, unsigned long pc, unsigned long npc,
 	} else {
 		fpload(&current->thread.float_regs[0], &current->thread.fsr);
 	}
-	current_thread_info()->flags |= _TIF_USEDFPU;
+	set_ti_thread_flag(current_thread_info(), TIF_USEDFPU);
 #endif
 }
 
@@ -290,7 +290,7 @@ void do_fpe_trap(struct pt_regs *regs, unsigned long pc, unsigned long npc,
 #ifndef CONFIG_SMP
 	if(!fpt) {
 #else
-        if(!(task_thread_info(fpt)->flags & _TIF_USEDFPU)) {
+        if(!test_ti_thread_flag(task_thread_info(fpt), TIF_USEDFPU)) {
 #endif
 		fpsave(&fake_regs[0], &fake_fsr, &fake_queue[0], &fake_depth);
 		regs->psr &= ~PSR_EF;
@@ -333,7 +333,7 @@ void do_fpe_trap(struct pt_regs *regs, unsigned long pc, unsigned long npc,
 	/* nope, better SIGFPE the offending process... */
 	       
 #ifdef CONFIG_SMP
-	task_thread_info(fpt)->flags &= ~_TIF_USEDFPU;
+	clear_tsk_thread_flag(fpt, TIF_USEDFPU);
 #endif
 	if(psr & PSR_PS) {
 		/* The first fsr store/load we tried trapped,
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

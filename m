Return-Path: <linux-kernel-owner+w=401wt.eu-S1030844AbXCIDMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030844AbXCIDMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992917AbXCIDMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:12:31 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:55529 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030844AbXCIDM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:12:29 -0500
Date: Thu, 8 Mar 2007 22:12:27 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, mbligh@google.com, linux-kernel@vger.kernel.org,
       wli@holomorphy.com, sparclinux@vger.kernel.org
Subject: [PATCH] Fix sparc TIF_USEDFPU flag atomicity
Message-ID: <20070309031227.GC9462@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 22:10:05 up 34 days, 17:17,  6 users,  load average: 1.30, 1.38, 1.34
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparc TIF_USEDFPU flag atomicity

Non atomic update of TIF can be very dangerous, except at thread structure
creation time. Here I standardize the TIF_USEDFPU usage of the sparc arch.

Applies on 2.6.20.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/sparc/kernel/process.c
+++ b/arch/sparc/kernel/process.c
@@ -348,7 +348,7 @@ void exit_thread(void)
 #ifndef CONFIG_SMP
 	if(last_task_used_math == current) {
 #else
-	if(current_thread_info()->flags & _TIF_USEDFPU) {
+	if(test_tsk_thread_flag(current, TIF_USEDFPU)) {
 #endif
 		/* Keep process from leaving FPU in a bogon state. */
 		put_psr(get_psr() | PSR_EF);
@@ -357,7 +357,7 @@ void exit_thread(void)
 #ifndef CONFIG_SMP
 		last_task_used_math = NULL;
 #else
-		current_thread_info()->flags &= ~_TIF_USEDFPU;
+		clear_tsk_thread_flag(current, TIF_USEDFPU);
 #endif
 	}
 }
@@ -371,7 +371,7 @@ void flush_thread(void)
 #ifndef CONFIG_SMP
 	if(last_task_used_math == current) {
 #else
-	if(current_thread_info()->flags & _TIF_USEDFPU) {
+	if(test_tsk_thread_flag(current, TIF_USEDFPU)) {
 #endif
 		/* Clean the fpu. */
 		put_psr(get_psr() | PSR_EF);
@@ -380,7 +380,7 @@ void flush_thread(void)
 #ifndef CONFIG_SMP
 		last_task_used_math = NULL;
 #else
-		current_thread_info()->flags &= ~_TIF_USEDFPU;
+		clear_tsk_thread_flag(current, TIF_USEDFPU);
 #endif
 	}
 
@@ -466,13 +466,13 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 #ifndef CONFIG_SMP
 	if(last_task_used_math == current) {
 #else
-	if(current_thread_info()->flags & _TIF_USEDFPU) {
+	if(test_tsk_thread_flag(current, TIF_USEDFPU)) {
 #endif
 		put_psr(get_psr() | PSR_EF);
 		fpsave(&p->thread.float_regs[0], &p->thread.fsr,
 		       &p->thread.fpqueue[0], &p->thread.fpqdepth);
 #ifdef CONFIG_SMP
-		current_thread_info()->flags &= ~_TIF_USEDFPU;
+		clear_tsk_thread_flag(current, TIF_USEDFPU);
 #endif
 	}
 
@@ -609,13 +609,13 @@ int dump_fpu (struct pt_regs * regs, elf_fpregset_t * fpregs)
 		return 1;
 	}
 #ifdef CONFIG_SMP
-	if (current_thread_info()->flags & _TIF_USEDFPU) {
+	if (test_tsk_thread_flag(current, TIF_USEDFPU)) {
 		put_psr(get_psr() | PSR_EF);
 		fpsave(&current->thread.float_regs[0], &current->thread.fsr,
 		       &current->thread.fpqueue[0], &current->thread.fpqdepth);
 		if (regs != NULL) {
 			regs->psr &= ~(PSR_EF);
-			current_thread_info()->flags &= ~(_TIF_USEDFPU);
+			clear_tsk_thread_flag(current, TIF_USEDFPU);
 		}
 	}
 #else
diff --git a/arch/sparc/kernel/traps.c b/arch/sparc/kernel/traps.c
index 6a70d21..7a7ad05 100644
--- a/arch/sparc/kernel/traps.c
+++ b/arch/sparc/kernel/traps.c
@@ -259,7 +259,7 @@ void do_fpd_trap(struct pt_regs *regs, unsigned long pc, unsigned long npc,
 	} else {
 		fpload(&current->thread.float_regs[0], &current->thread.fsr);
 	}
-	current_thread_info()->flags |= _TIF_USEDFPU;
+	set_tsk_thread_flag(current, TIF_USEDFPU);
 #endif
 }
 
@@ -290,7 +290,7 @@ void do_fpe_trap(struct pt_regs *regs, unsigned long pc, unsigned long npc,
 #ifndef CONFIG_SMP
 	if(!fpt) {
 #else
-        if(!(task_thread_info(fpt)->flags & _TIF_USEDFPU)) {
+        if(!test_tsk_thread_flag(fpt, TIF_USEDFPU)) {
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

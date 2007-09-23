Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbXIWKRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbXIWKRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 06:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbXIWKQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 06:16:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:50291 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbXIWKQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 06:16:54 -0400
Date: Sun, 23 Sep 2007 10:16:53 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux 2.6.20.20
Message-ID: <20070923101653.GA26153@hera.kernel.org>
References: <20070923101556.GA23231@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070923101556.GA23231@hera.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


diff --git a/Makefile b/Makefile
index 6bb9f2e..15b82c6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 20
-EXTRAVERSION = .19
+EXTRAVERSION = .20
 NAME = Homicidal Dwarf Hamster
 
 # *DOCUMENTATION*
diff --git a/arch/x86_64/ia32/ia32entry.S b/arch/x86_64/ia32/ia32entry.S
index b4aa875..824fe53 100644
--- a/arch/x86_64/ia32/ia32entry.S
+++ b/arch/x86_64/ia32/ia32entry.S
@@ -38,6 +38,18 @@
 	movq	%rax,R8(%rsp)
 	.endm
 
+	.macro LOAD_ARGS32 offset
+	movl \offset(%rsp),%r11d
+	movl \offset+8(%rsp),%r10d
+	movl \offset+16(%rsp),%r9d
+	movl \offset+24(%rsp),%r8d
+	movl \offset+40(%rsp),%ecx
+	movl \offset+48(%rsp),%edx
+	movl \offset+56(%rsp),%esi
+	movl \offset+64(%rsp),%edi
+	movl \offset+72(%rsp),%eax
+	.endm
+	
 	.macro CFI_STARTPROC32 simple
 	CFI_STARTPROC	\simple
 	CFI_UNDEFINED	r8
@@ -152,7 +164,7 @@ sysenter_tracesys:
 	movq	$-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
-	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	movl	%ebp, %ebp
 	/* no need to do an access_ok check here because rbp has been
@@ -255,7 +267,7 @@ cstar_tracesys:
 	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
-	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	movl RSP-ARGOFFSET(%rsp), %r8d
 	/* no need to do an access_ok check here because r8 has been
@@ -333,7 +345,7 @@ ia32_tracesys:
 	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
-	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	jmp ia32_do_syscall
 END(ia32_syscall)
diff --git a/arch/x86_64/kernel/ptrace.c b/arch/x86_64/kernel/ptrace.c
index addc14a..e086073 100644
--- a/arch/x86_64/kernel/ptrace.c
+++ b/arch/x86_64/kernel/ptrace.c
@@ -224,10 +224,6 @@ static int putreg(struct task_struct *child,
 {
 	unsigned long tmp; 
 	
-	/* Some code in the 64bit emulation may not be 64bit clean.
-	   Don't take any chances. */
-	if (test_tsk_thread_flag(child, TIF_IA32))
-		value &= 0xffffffff;
 	switch (regno) {
 		case offsetof(struct user_regs_struct,fs):
 			if (value && (value & 3) != 3)
diff --git a/kernel/sys.c b/kernel/sys.c
index 6e2101d..475ddbb 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1916,6 +1916,16 @@ asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
 	if (retval)
 		return retval;
 
+	if (resource == RLIMIT_CPU && new_rlim.rlim_cur == 0) {
+		/*
+		 * The caller is asking for an immediate RLIMIT_CPU
+		 * expiry.  But we use the zero value to mean "it was
+		 * never set".  So let's cheat and make it one second
+		 * instead
+		 */
+		new_rlim.rlim_cur = 1;
+	}
+
 	task_lock(current->group_leader);
 	*old_rlim = new_rlim;
 	task_unlock(current->group_leader);
@@ -1937,15 +1947,6 @@ asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
 		unsigned long rlim_cur = new_rlim.rlim_cur;
 		cputime_t cputime;
 
-		if (rlim_cur == 0) {
-			/*
-			 * The caller is asking for an immediate RLIMIT_CPU
-			 * expiry.  But we use the zero value to mean "it was
-			 * never set".  So let's cheat and make it one second
-			 * instead
-			 */
-			rlim_cur = 1;
-		}
 		cputime = secs_to_cputime(rlim_cur);
 		read_lock(&tasklist_lock);
 		spin_lock_irq(&current->sighand->siglock);

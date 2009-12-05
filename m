Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZLEUQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZLEUQX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZLEUQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:16:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41316 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbZLEUQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:16:18 -0500
Date: Sat, 05 Dec 2009 19:08:51 +0000
To: linux-arch@vger.kernel.org
Subject: [RFC][PATCH 17/18] sparc_brk() is not needed anymore
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NGzzv-0008Rx-51@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


the checks it's doing are duplicated in sys_brk() and failing
them early makes no sense, AFAICT.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/kernel/sys_sparc_32.c |    9 ---------
 arch/sparc/kernel/sys_sparc_64.c |   12 ------------
 arch/sparc/kernel/systbls.h      |    1 -
 arch/sparc/kernel/systbls_32.S   |    2 +-
 arch/sparc/kernel/systbls_64.S   |    4 ++--
 5 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_32.c b/arch/sparc/kernel/sys_sparc_32.c
index 36f6f26..997bdd0 100644
--- a/arch/sparc/kernel/sys_sparc_32.c
+++ b/arch/sparc/kernel/sys_sparc_32.c
@@ -79,15 +79,6 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsi
 	}
 }
 
-asmlinkage unsigned long sparc_brk(unsigned long brk)
-{
-	if(ARCH_SUN4C) {
-		if ((brk & 0xe0000000) != (current->mm->brk & 0xe0000000))
-			return current->mm->brk;
-	}
-	return sys_brk(brk);
-}
-
 /*
  * sys_pipe() is the normal C calling standard for creating
  * a pipe. It's not the way unix traditionally does this, though.
diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 8f9cd58..cfa0e19 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -403,18 +403,6 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 	}
 }
 
-SYSCALL_DEFINE1(sparc_brk, unsigned long, brk)
-{
-	/* People could try to be nasty and use ta 0x6d in 32bit programs */
-	if (test_thread_flag(TIF_32BIT) && brk >= STACK_TOP32)
-		return current->mm->brk;
-
-	if (unlikely(straddles_64bit_va_hole(current->mm->brk, brk)))
-		return current->mm->brk;
-
-	return sys_brk(brk);
-}
-                                                                
 /*
  * sys_pipe() is the normal C calling standard for creating
  * a pipe. It's not the way unix traditionally does this, though.
diff --git a/arch/sparc/kernel/systbls.h b/arch/sparc/kernel/systbls.h
index a63c5d2..d2f999a 100644
--- a/arch/sparc/kernel/systbls.h
+++ b/arch/sparc/kernel/systbls.h
@@ -9,7 +9,6 @@
 struct new_utsname;
 
 extern asmlinkage unsigned long sys_getpagesize(void);
-extern asmlinkage unsigned long sparc_brk(unsigned long brk);
 extern asmlinkage long sparc_pipe(struct pt_regs *regs);
 extern asmlinkage long sys_ipc(unsigned int call, int first,
 			       unsigned long second,
diff --git a/arch/sparc/kernel/systbls_32.S b/arch/sparc/kernel/systbls_32.S
index 81822a8..14f950a 100644
--- a/arch/sparc/kernel/systbls_32.S
+++ b/arch/sparc/kernel/systbls_32.S
@@ -19,7 +19,7 @@ sys_call_table:
 /*0*/	.long sys_restart_syscall, sys_exit, sys_fork, sys_read, sys_write
 /*5*/	.long sys_open, sys_close, sys_wait4, sys_creat, sys_link
 /*10*/  .long sys_unlink, sunos_execv, sys_chdir, sys_chown16, sys_mknod
-/*15*/	.long sys_chmod, sys_lchown16, sparc_brk, sys_nis_syscall, sys_lseek
+/*15*/	.long sys_chmod, sys_lchown16, sys_brk, sys_nis_syscall, sys_lseek
 /*20*/	.long sys_getpid, sys_capget, sys_capset, sys_setuid16, sys_getuid16
 /*25*/	.long sys_vmsplice, sys_ptrace, sys_alarm, sys_sigaltstack, sys_pause
 /*30*/	.long sys_utime, sys_lchown, sys_fchown, sys_access, sys_nice
diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
index 009825f..f63c871 100644
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -21,7 +21,7 @@ sys_call_table32:
 /*0*/	.word sys_restart_syscall, sys32_exit, sys_fork, sys_read, sys_write
 /*5*/	.word sys32_open, sys_close, sys32_wait4, sys32_creat, sys_link
 /*10*/  .word sys_unlink, sunos_execv, sys_chdir, sys_chown16, sys32_mknod
-/*15*/	.word sys_chmod, sys_lchown16, sys_sparc_brk, sys32_perfctr, sys32_lseek
+/*15*/	.word sys_chmod, sys_lchown16, sys_brk, sys32_perfctr, sys32_lseek
 /*20*/	.word sys_getpid, sys_capget, sys_capset, sys_setuid16, sys_getuid16
 /*25*/	.word sys32_vmsplice, compat_sys_ptrace, sys_alarm, sys32_sigaltstack, sys_pause
 /*30*/	.word compat_sys_utime, sys_lchown, sys_fchown, sys32_access, sys32_nice
@@ -96,7 +96,7 @@ sys_call_table:
 /*0*/	.word sys_restart_syscall, sparc_exit, sys_fork, sys_read, sys_write
 /*5*/	.word sys_open, sys_close, sys_wait4, sys_creat, sys_link
 /*10*/  .word sys_unlink, sys_nis_syscall, sys_chdir, sys_chown, sys_mknod
-/*15*/	.word sys_chmod, sys_lchown, sys_sparc_brk, sys_perfctr, sys_lseek
+/*15*/	.word sys_chmod, sys_lchown, sys_brk, sys_perfctr, sys_lseek
 /*20*/	.word sys_getpid, sys_capget, sys_capset, sys_setuid, sys_getuid
 /*25*/	.word sys_vmsplice, sys_ptrace, sys_alarm, sys_sigaltstack, sys_nis_syscall
 /*30*/	.word sys_utime, sys_nis_syscall, sys_nis_syscall, sys_access, sys_nice
-- 
1.5.6.5



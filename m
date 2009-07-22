Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZGVJJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZGVJJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbZGVJJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:09:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59699 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563AbZGVJJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:09:28 -0400
Date: Wed, 22 Jul 2009 05:08:42 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, mingo@elte.hu,
       Amerigo Wang <amwang@redhat.com>
Message-Id: <20090722091100.6621.80645.sendpatchset@localhost.localdomain>
In-Reply-To: <20090722091051.6621.15184.sendpatchset@localhost.localdomain>
References: <20090722091051.6621.15184.sendpatchset@localhost.localdomain>
Subject: [Patch 2/2] xtensa: use generic sys_pipe()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As suggested by Al, we can use the generic sys_pipe() instead of xtensa_pipe()
for xtensa.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk> 
CC: Linus Torvalds <torvalds@linux-foundation.org>

---
diff --git a/arch/xtensa/include/asm/syscall.h b/arch/xtensa/include/asm/syscall.h
index 05cebf8..76a1fb8 100644
--- a/arch/xtensa/include/asm/syscall.h
+++ b/arch/xtensa/include/asm/syscall.h
@@ -12,7 +12,6 @@ struct pt_regs;
 struct sigaction;
 asmlinkage long xtensa_execve(char*, char**, char**, struct pt_regs*);
 asmlinkage long xtensa_clone(unsigned long, unsigned long, struct pt_regs*);
-asmlinkage long xtensa_pipe(int __user *);
 asmlinkage long xtensa_mmap2(unsigned long, unsigned long, unsigned long,
     			     unsigned long, unsigned long, unsigned long);
 asmlinkage long xtensa_ptrace(long, long, long, long);
diff --git a/arch/xtensa/include/asm/unistd.h b/arch/xtensa/include/asm/unistd.h
index c092c8f..b6880c8 100644
--- a/arch/xtensa/include/asm/unistd.h
+++ b/arch/xtensa/include/asm/unistd.h
@@ -94,7 +94,7 @@ __SYSCALL( 35, sys_readlink, 3)
 #define __NR_mknod 				 36
 __SYSCALL( 36, sys_mknod, 3)
 #define __NR_pipe 				 37
-__SYSCALL( 37, xtensa_pipe, 1)
+__SYSCALL(37, sys_pipe, 1)
 #define __NR_unlink 				 38
 __SYSCALL( 38, sys_unlink, 1)
 #define __NR_rmdir 				 39
diff --git a/arch/xtensa/kernel/syscall.c b/arch/xtensa/kernel/syscall.c
index ac15ecb..c7279be 100644
--- a/arch/xtensa/kernel/syscall.c
+++ b/arch/xtensa/kernel/syscall.c
@@ -39,24 +39,6 @@ syscall_t sys_call_table[__NR_syscall_count] /* FIXME __cacheline_aligned */= {
 #include <asm/unistd.h>
 };
 
-/*
- * xtensa_pipe() is the normal C calling standard for creating a pipe. It's not
- * the way unix traditional does this, though.
- */
-
-asmlinkage long xtensa_pipe(int __user *userfds)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe_flags(fd, 0);
-	if (!error) {
-		if (copy_to_user(userfds, fd, 2 * sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 
 asmlinkage long xtensa_mmap2(unsigned long addr, unsigned long len,
    			     unsigned long prot, unsigned long flags,

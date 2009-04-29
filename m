Return-Path: <linux-kernel-owner+w=401wt.eu-S933108AbZD3Puj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbZD3Puj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932462AbZD3Pmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52797 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391AbZD3PmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:05 -0400
Message-Id: <aa2b98fe12635da73f5d5f91e99006702780cb24.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 29 Apr 2009 16:25:19 +0200
Subject: [PATCH 18/27] microblaze: use generic syscalls.h
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX1+XZlSl+mtpFCZEPFq8/cfpH4js7bv5Bp0OBQm
 HjAEdQnVCgLu/Jr/a/eTu1JZl3uuxBo61s4MZErgsQdtVMFiR+
 frd0ZTZIlV1n3+wpWB7ew==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prototypes in syscalls.h all make sense for
microblaze, but for some of them, the actual implementation
in sys_microblaze.c needs to be adapted.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/include/asm/syscalls.h  |   48 +++++-------------------------
 arch/microblaze/kernel/sys_microblaze.c |   12 ++++----
 2 files changed, 14 insertions(+), 46 deletions(-)
 rewrite arch/microblaze/include/asm/syscalls.h (94%)

diff --git a/arch/microblaze/include/asm/syscalls.h b/arch/microblaze/include/asm/syscalls.h
dissimilarity index 94%
index fc5a412..720761c 100644
--- a/arch/microblaze/include/asm/syscalls.h
+++ b/arch/microblaze/include/asm/syscalls.h
@@ -1,40 +1,8 @@
-#ifndef __ASM_MICROBLAZE_SYSCALLS_H
-#define __ASM_MICROBLAZE_SYSCALLS_H
-#ifdef __KERNEL__
-
-#include <linux/compiler.h>
-#include <linux/linkage.h>
-#include <linux/types.h>
-#include <linux/signal.h>
-
-/* FIXME will be removed */
-asmlinkage int sys_ipc(uint call, int first, int second,
-				int third, void *ptr, long fifth);
-
-struct pt_regs;
-asmlinkage int sys_vfork(struct pt_regs *regs);
-asmlinkage int sys_clone(int flags, unsigned long stack, struct pt_regs *regs);
-asmlinkage int sys_execve(char __user *filenamei, char __user *__user *argv,
-			char __user *__user *envp, struct pt_regs *regs);
-
-asmlinkage unsigned long sys_mmap2(unsigned long addr, size_t len,
-			unsigned long prot, unsigned long flags,
-			unsigned long fd, unsigned long pgoff);
-
-asmlinkage unsigned long sys_mmap(unsigned long addr, size_t len,
-			unsigned long prot, unsigned long flags,
-			unsigned long fd, off_t offset);
-
-/* from signal.c */
-asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize,
-		struct pt_regs *regs);
-
-asmlinkage long sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
-		struct pt_regs *regs);
-
-asmlinkage long sys_rt_sigaction(int sig, const struct sigaction __user * act, struct sigaction __user * oact, size_t sigsetsize);
-
-asmlinkage long sys_rt_sigreturn(struct pt_regs *regs);
-
-#endif /* __KERNEL__ */
-#endif /* __ASM_MICROBLAZE_SYSCALLS_H */
+#ifndef __ASM_MICROBLAZE_SYSCALLS_H
+
+asmlinkage long sys_clone(int flags, unsigned long stack, struct pt_regs *regs);
+#define sys_clone sys_clone
+
+#include <asm-generic/syscalls.h>
+
+#endif /* __ASM_MICROBLAZE_SYSCALLS_H */
diff --git a/arch/microblaze/kernel/sys_microblaze.c b/arch/microblaze/kernel/sys_microblaze.c
index ba0568c..57ce1b2 100644
--- a/arch/microblaze/kernel/sys_microblaze.c
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -39,7 +39,7 @@
  *
  * This is really horribly ugly. This will be remove with new toolchain.
  */
-asmlinkage int
+asmlinkage long
 sys_ipc(uint call, int first, int second, int third, void *ptr, long fifth)
 {
 	int version, ret;
@@ -134,20 +134,20 @@ sys_ipc(uint call, int first, int second, int third, void *ptr, long fifth)
 	return -EINVAL;
 }
 
-asmlinkage int sys_vfork(struct pt_regs *regs)
+asmlinkage long sys_vfork(struct pt_regs *regs)
 {
 	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->r1,
 						regs, 0, NULL, NULL);
 }
 
-asmlinkage int sys_clone(int flags, unsigned long stack, struct pt_regs *regs)
+asmlinkage long sys_clone(int flags, unsigned long stack, struct pt_regs *regs)
 {
 	if (!stack)
 		stack = regs->r1;
 	return do_fork(flags, stack, regs, 0, NULL, NULL);
 }
 
-asmlinkage int sys_execve(char __user *filenamei, char __user *__user *argv,
+asmlinkage long sys_execve(char __user *filenamei, char __user *__user *argv,
 			char __user *__user *envp, struct pt_regs *regs)
 {
 	int error;
@@ -163,7 +163,7 @@ out:
 	return error;
 }
 
-asmlinkage unsigned long
+asmlinkage long
 sys_mmap2(unsigned long addr, size_t len,
 	unsigned long prot, unsigned long flags,
 	unsigned long fd, unsigned long pgoff)
@@ -189,7 +189,7 @@ out:
 	return ret;
 }
 
-asmlinkage unsigned long sys_mmap(unsigned long addr, size_t len,
+asmlinkage long sys_mmap(unsigned long addr, size_t len,
 			unsigned long prot, unsigned long flags,
 			unsigned long fd, off_t offset)
 {
-- 
1.5.6.3



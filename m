Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZFRR4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZFRR4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZFRRz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:55:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57236 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbZFRRzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:55:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 06/11] microblaze: use generic syscalls.h
Date: Thu, 18 Jun 2009 19:55:30 +0200
Message-Id: <04afd994c44273e930df9a769f820786eae5b840.1245347640.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1245345894.git.arnd@arndb.de>
References: <cover.1245345894.git.arnd@arndb.de>
In-Reply-To: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
References: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18mJFUe7DouUfirhKUfa0fyXO1EMqd1uUmFUnn
 jSLzCcrOQsNZAH+/CJstXuymPukboF1JrrEpGR5V14UrrWBqTk
 obxLo2rSJXWSBnBApPnsA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prototypes in syscalls.h all make sense for
microblaze, but for some of them, the actual implementation
in sys_microblaze.c needs to be adapted.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/include/asm/syscalls.h  |   49 +++++--------------------------
 arch/microblaze/kernel/sys_microblaze.c |   12 ++++----
 2 files changed, 14 insertions(+), 47 deletions(-)
 rewrite arch/microblaze/include/asm/syscalls.h (94%)

diff --git a/arch/microblaze/include/asm/syscalls.h b/arch/microblaze/include/asm/syscalls.h
dissimilarity index 94%
index ea23843..720761c 100644
--- a/arch/microblaze/include/asm/syscalls.h
+++ b/arch/microblaze/include/asm/syscalls.h
@@ -1,41 +1,8 @@
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
-asmlinkage long sys_rt_sigaction(int sig, const struct sigaction __user *act,
-		struct sigaction __user *oact, size_t sigsetsize);
-
-asmlinkage int sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
-		struct pt_regs *regs);
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
index d668518..61080a2 100644
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
 	return ret;
 }
 
-asmlinkage int microblaze_vfork(struct pt_regs *regs)
+asmlinkage long microblaze_vfork(struct pt_regs *regs)
 {
 	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->r1,
 						regs, 0, NULL, NULL);
 }
 
-asmlinkage int microblaze_clone(int flags, unsigned long stack, struct pt_regs *regs)
+asmlinkage long microblaze_clone(int flags, unsigned long stack, struct pt_regs *regs)
 {
 	if (!stack)
 		stack = regs->r1;
 	return do_fork(flags, stack, regs, 0, NULL, NULL);
 }
 
-asmlinkage int microblaze_execve(char __user *filenamei, char __user *__user *argv,
+asmlinkage long microblaze_execve(char __user *filenamei, char __user *__user *argv,
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
1.6.3.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbYGUAD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbYGUAD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbYGUAC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:02:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58533 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbYGUAC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:02:56 -0400
Subject: [PATCH 3/22] arm: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, rmk@arm.linux.org.uk
In-Reply-To: <1216592879.3679.24.camel@jaswinder.satnam>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <1216592798.3679.22.camel@jaswinder.satnam>
	 <1216592879.3679.24.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 04:00:35 +0530
Message-Id: <1216593035.3679.27.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Declaring arch-dependent syscalls for arm architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/arm/kernel/signal.c          |    1 +
 arch/arm/kernel/sys_oabi-compat.c |    3 --
 include/asm-arm/syscalls.h        |   73 +++++++++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index ef2f86a..64e23ed 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -11,6 +11,7 @@
 #include <linux/signal.h>
 #include <linux/personality.h>
 #include <linux/freezer.h>
+#include <linux/syscalls.h>
 
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 96ab5f5..a1e6fa4 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -354,9 +354,6 @@ asmlinkage long sys_oabi_semop(int semid, struct oabi_sembuf __user *tsops,
 	return sys_oabi_semtimedop(semid, tsops, nsops, NULL);
 }
 
-extern asmlinkage int sys_ipc(uint call, int first, int second, int third,
-			      void __user *ptr, long fifth);
-
 asmlinkage int sys_oabi_ipc(uint call, int first, int second, int third,
 			    void __user *ptr, long fifth)
 {
diff --git a/include/asm-arm/syscalls.h b/include/asm-arm/syscalls.h
index e69de29..1a97a82 100644
--- a/include/asm-arm/syscalls.h
+++ b/include/asm-arm/syscalls.h
@@ -0,0 +1,73 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_ARM_SYSCALLS_H
+#define _ASM_ARM_SYSCALLS_H
+
+/* kernel/signal.c */
+asmlinkage int sys_sigsuspend(int, unsigned long, old_sigset_t,
+			      struct pt_regs *);
+asmlinkage int sys_rt_sigsuspend(sigset_t __user *, size_t,
+				 struct pt_regs *);
+asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_sigreturn(struct pt_regs *);
+asmlinkage int sys_rt_sigreturn(struct pt_regs *);
+
+/* kernel/sys_arm.c */
+struct mmap_arg_struct;
+asmlinkage int old_mmap(struct mmap_arg_struct __user *);
+asmlinkage unsigned long sys_arm_mremap(unsigned long, unsigned long,
+					unsigned long, unsigned long,
+					unsigned long);
+
+struct sel_arg_struct;
+asmlinkage int old_select(struct sel_arg_struct __user *);
+#if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
+asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
+#endif
+asmlinkage int sys_fork(struct pt_regs *);
+asmlinkage int sys_clone(unsigned long, unsigned long, int __user *,
+			 int, int __user *, struct pt_regs *);
+asmlinkage int sys_vfork(struct pt_regs *);
+asmlinkage int sys_execve(char __user *, char __user * __user *,
+			  char __user * __user *, struct pt_regs *);
+asmlinkage long sys_arm_fadvise64_64(int, int, loff_t, loff_t);
+
+#if defined(CONFIG_OABI_COMPAT)
+/* kernel/sys_oabi-compat.c */
+struct oldabi_stat64;
+asmlinkage long sys_oabi_stat64(char __user *, struct oldabi_stat64 __user *);
+asmlinkage long sys_oabi_lstat64(char __user *, struct oldabi_stat64 __user *);
+asmlinkage long sys_oabi_fstat64(unsigned long, struct oldabi_stat64 __user *);
+asmlinkage long sys_oabi_fstatat64(int, char __user *,
+				   struct oldabi_stat64  __user *, int);
+asmlinkage long sys_oabi_fcntl64(unsigned int, unsigned int, unsigned long);
+struct oabi_epoll_event;
+asmlinkage long sys_oabi_epoll_ctl(int, int, int,
+				   struct oabi_epoll_event __user *);
+asmlinkage long sys_oabi_epoll_wait(int, struct oabi_epoll_event __user *,
+				    int, int);
+struct oabi_sembuf;
+asmlinkage long sys_oabi_semtimedop(int, struct oabi_sembuf __user *,
+				    unsigned, const struct timespec __user *);
+asmlinkage long sys_oabi_semop(int, struct oabi_sembuf __user *, unsigned);
+asmlinkage int sys_oabi_ipc(uint, int, int, int, void __user *, long);
+asmlinkage long sys_oabi_bind(int, struct sockaddr __user *, int);
+asmlinkage long sys_oabi_connect(int, struct sockaddr __user *, int);
+asmlinkage long sys_oabi_sendto(int, void __user *, size_t,
+				unsigned, struct sockaddr __user *, int);
+asmlinkage long sys_oabi_sendmsg(int, struct msghdr __user *, unsigned);
+asmlinkage long sys_oabi_socketcall(int, unsigned long __user *);
+
+#endif
+
+#endif /* _ASM_ARM_SYSCALLS_H */
-- 
1.5.5.1




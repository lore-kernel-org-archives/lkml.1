Return-Path: <linux-kernel-owner+w=401wt.eu-S932175AbXF2ARs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbXF2ARs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 20:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762270AbXF2ARk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 20:17:40 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2490 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761952AbXF2ARj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 20:17:39 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 28 Jun 2007 17:17:37 -0700
Subject: [patch 1/1] compat_alloc_user
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.22229.1183076257.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that is not possible ATM to allocate two or more blocks
of userspace memory. Would a compat_alloc_user() like the one below
make sense (patch untested)?



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



---
 include/asm-ia64/compat.h    |    8 ++++++++
 include/asm-mips/compat.h    |    8 ++++++++
 include/asm-parisc/compat.h  |    8 ++++++++
 include/asm-powerpc/compat.h |    8 ++++++++
 include/asm-s390/compat.h    |    8 ++++++++
 include/asm-sparc64/compat.h |    8 ++++++++
 include/asm-x86_64/compat.h  |    8 ++++++++
 7 files changed, 56 insertions(+)

Index: linux-2.6.mod/include/asm-x86_64/compat.h
===================================================================
--- linux-2.6.mod.orig/include/asm-x86_64/compat.h	2007-06-13 17:48:27.000000000 -0700
+++ linux-2.6.mod/include/asm-x86_64/compat.h	2007-06-13 17:48:32.000000000 -0700
@@ -202,6 +202,14 @@
 	return (void __user *)regs->rsp - len; 
 }
 
+static __inline__ void __user *compat_alloc_user(void __user **prev, long len)
+{
+	void __user *data;
+	data = *prev ? (*prev - len): compat_alloc_user_space(len);
+	*prev = (void __user *) ((unsigned long) data & ~0x7UL);
+	return *prev;
+}
+
 static inline int is_compat_task(void)
 {
 	return current_thread_info()->status & TS_COMPAT;
Index: linux-2.6.mod/include/asm-sparc64/compat.h
===================================================================
--- linux-2.6.mod.orig/include/asm-sparc64/compat.h	2007-06-13 17:48:27.000000000 -0700
+++ linux-2.6.mod/include/asm-sparc64/compat.h	2007-06-13 17:48:32.000000000 -0700
@@ -180,6 +180,14 @@
 	return (void __user *) usp;
 }
 
+static inline void __user *compat_alloc_user(void __user **prev, long len)
+{
+	void __user *data;
+	data = *prev ? (*prev - len): compat_alloc_user_space(len);
+	*prev = (void __user *) ((unsigned long) data & ~0x7UL);
+	return *prev;
+}
+
 struct compat_ipc64_perm {
 	compat_key_t key;
 	__compat_uid32_t uid;
Index: linux-2.6.mod/include/asm-s390/compat.h
===================================================================
--- linux-2.6.mod.orig/include/asm-s390/compat.h	2007-06-13 17:48:27.000000000 -0700
+++ linux-2.6.mod/include/asm-s390/compat.h	2007-06-13 17:48:32.000000000 -0700
@@ -171,6 +171,14 @@
 	return (void __user *) (stack - len);
 }
 
+static inline void __user *compat_alloc_user(void __user **prev, long len)
+{
+	void __user *data;
+	data = *prev ? (*prev - len): compat_alloc_user_space(len);
+	*prev = (void __user *) ((unsigned long) data & ~0x7UL);
+	return *prev;
+}
+
 struct compat_ipc64_perm {
 	compat_key_t key;
 	__compat_uid32_t uid;
Index: linux-2.6.mod/include/asm-powerpc/compat.h
===================================================================
--- linux-2.6.mod.orig/include/asm-powerpc/compat.h	2007-06-13 17:48:27.000000000 -0700
+++ linux-2.6.mod/include/asm-powerpc/compat.h	2007-06-13 17:48:32.000000000 -0700
@@ -146,6 +146,14 @@
 	return (void __user *) (usp - len);
 }
 
+static inline void __user *compat_alloc_user(void __user **prev, long len)
+{
+	void __user *data;
+	data = *prev ? (*prev - len): compat_alloc_user_space(len);
+	*prev = (void __user *) ((unsigned long) data & ~0x7UL);
+	return *prev;
+}
+
 /*
  * ipc64_perm is actually 32/64bit clean but since the compat layer refers to
  * it we may as well define it.
Index: linux-2.6.mod/include/asm-parisc/compat.h
===================================================================
--- linux-2.6.mod.orig/include/asm-parisc/compat.h	2007-06-13 17:48:27.000000000 -0700
+++ linux-2.6.mod/include/asm-parisc/compat.h	2007-06-13 17:48:32.000000000 -0700
@@ -150,6 +150,14 @@
 	return (void __user *)regs->gr[30];
 }
 
+static __inline__ void __user *compat_alloc_user(void __user **prev, long len)
+{
+	void __user *data;
+	data = *prev ? : compat_alloc_user_space(len);
+	*prev = data + ((len + 0x7UL) & ~0x7UL);
+	return data;
+}
+
 static inline int __is_compat_task(struct task_struct *t)
 {
 	return test_ti_thread_flag(task_thread_info(t), TIF_32BIT);
Index: linux-2.6.mod/include/asm-mips/compat.h
===================================================================
--- linux-2.6.mod.orig/include/asm-mips/compat.h	2007-06-13 17:48:27.000000000 -0700
+++ linux-2.6.mod/include/asm-mips/compat.h	2007-06-13 17:48:32.000000000 -0700
@@ -148,6 +148,14 @@
 	return (void __user *) (regs->regs[29] - len);
 }
 
+static inline void __user *compat_alloc_user(void __user **prev, long len)
+{
+	void __user *data;
+	data = *prev ? (*prev - len): compat_alloc_user_space(len);
+	*prev = (void __user *) ((unsigned long) data & ~0x7UL);
+	return *prev;
+}
+
 struct compat_ipc64_perm {
 	compat_key_t key;
 	__compat_uid32_t uid;
Index: linux-2.6.mod/include/asm-ia64/compat.h
===================================================================
--- linux-2.6.mod.orig/include/asm-ia64/compat.h	2007-06-13 17:48:27.000000000 -0700
+++ linux-2.6.mod/include/asm-ia64/compat.h	2007-06-13 17:48:32.000000000 -0700
@@ -202,4 +202,12 @@
 	return (void __user *) (((regs->r12 & 0xffffffff) & -16) - len);
 }
 
+static __inline__ void __user *compat_alloc_user(void __user **prev, long len)
+{
+	void __user *data;
+	data = *prev ? (*prev - len): compat_alloc_user_space(len);
+	*prev = (void __user *) ((unsigned long) data & ~0xfUL;
+	return *prev;
+}
+
 #endif /* _ASM_IA64_COMPAT_H */


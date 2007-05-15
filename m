Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbXEOTgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbXEOTgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXEOTgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:36:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45054 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbXEOTgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:36:03 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fix uml-x86_64
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com
Message-Id: <E1Ho2oS-0003Sw-9Y@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 15 May 2007 20:36:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


__NR_syscall_max is done in x86_64 asm-offsets; do an equivalent in
uml kern_constants.h

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/sysdep-x86_64/kernel-offsets.h |    9 +++++++++
 arch/um/include/sysdep-x86_64/syscalls.h       |    3 ++-
 arch/um/sys-x86_64/syscall_table.c             |    5 +++--
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/um/include/sysdep-x86_64/kernel-offsets.h b/arch/um/include/sysdep-x86_64/kernel-offsets.h
index a307237..c978b58 100644
--- a/arch/um/include/sysdep-x86_64/kernel-offsets.h
+++ b/arch/um/include/sysdep-x86_64/kernel-offsets.h
@@ -17,7 +17,16 @@
 #define OFFSET(sym, str, mem) \
 	DEFINE(sym, offsetof(struct str, mem));
 
+#define __NO_STUBS 1
+#undef __SYSCALL
+#undef _ASM_X86_64_UNISTD_H_
+#define __SYSCALL(nr, sym) [nr] = 1,
+static char syscalls[] = {
+#include <asm/arch/unistd.h>
+};
+
 void foo(void)
 {
 #include <common-offsets.h>
+DEFINE(UM_NR_syscall_max, sizeof(syscalls) - 1);
 }
diff --git a/arch/um/include/sysdep-x86_64/syscalls.h b/arch/um/include/sysdep-x86_64/syscalls.h
index 5e86aa0..cf72256 100644
--- a/arch/um/include/sysdep-x86_64/syscalls.h
+++ b/arch/um/include/sysdep-x86_64/syscalls.h
@@ -9,6 +9,7 @@
 
 #include <linux/msg.h>
 #include <linux/shm.h>
+#include <kern_constants.h>
 
 typedef long syscall_handler_t(void);
 
@@ -29,6 +30,6 @@ extern long old_mmap(unsigned long addr, unsigned long len,
 extern syscall_handler_t sys_modify_ldt;
 extern syscall_handler_t sys_arch_prctl;
 
-#define NR_syscalls (__NR_syscall_max + 1)
+#define NR_syscalls (UM_NR_syscall_max + 1)
 
 #endif
diff --git a/arch/um/sys-x86_64/syscall_table.c b/arch/um/sys-x86_64/syscall_table.c
index 9e9ad72..5133988 100644
--- a/arch/um/sys-x86_64/syscall_table.c
+++ b/arch/um/sys-x86_64/syscall_table.c
@@ -4,6 +4,7 @@
 #include <linux/linkage.h>
 #include <linux/sys.h>
 #include <linux/cache.h>
+#include <kern_constants.h>
 
 #define __NO_STUBS
 
@@ -45,8 +46,8 @@ typedef void (*sys_call_ptr_t)(void);
 
 extern void sys_ni_syscall(void);
 
-sys_call_ptr_t sys_call_table[__NR_syscall_max+1] __cacheline_aligned = {
+sys_call_ptr_t sys_call_table[UM_NR_syscall_max+1] __cacheline_aligned = {
 	/* Smells like a like a compiler bug -- it doesn't work when the & below is removed. */
-	[0 ... __NR_syscall_max] = &sys_ni_syscall,
+	[0 ... UM_NR_syscall_max] = &sys_ni_syscall,
 #include <asm-x86_64/unistd.h>
 };
-- 
1.5.0-rc2.GIT



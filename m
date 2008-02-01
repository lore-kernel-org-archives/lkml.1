Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYBARio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYBARio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYBARie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:38:34 -0500
Received: from [198.99.130.12] ([198.99.130.12]:35008 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYBARid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:38:33 -0500
Date: Fri, 1 Feb 2008 12:38:18 -0500
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>, Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [git Patch] UML: a build error fix
Message-ID: <20080201173818.GA6984@c2.user-mode-linux.org>
References: <20080131151741.GE2471@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131151741.GE2471@hacking>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 11:17:41PM +0800, WANG Cong wrote:
> This patch fixed this error:
> 
> arch/um/kernel/skas/syscall.c: In function 'handle_syscall':
> arch/um/kernel/skas/syscall.c:33: error: 'NR_syscalls' undeclared (first use in this function)

That works, but I think doing things the way that i386 does them is cleaner.

Andrew, can you stick the patch below into -mm and push it to Linus?

				Jeff

-- 
Work email - jdike at linux dot intel dot com



Redo the calculation of NR_syscalls since that disappeared from i386
and use a similar mechanism on x86_64.

We now figure out the size of the system call table in arch code and
stick that in syscall_table_size.  arch/um/kernel/skas/syscall.c
defines NR_syscalls in terms of that since its the only thing that
needs to know how many system calls there are.

The old mechananism that was used on x86_64 is gone.

arch/um/include/sysdep-i386/syscalls.h got some formatting since I was
looking at it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
---
 arch/um/include/sysdep-i386/syscalls.h         |    5 +++--
 arch/um/include/sysdep-x86_64/kernel-offsets.h |    9 ---------
 arch/um/include/sysdep-x86_64/syscalls.h       |    2 --
 arch/um/kernel/skas/syscall.c                  |    3 +++
 arch/um/sys-i386/sys_call_table.S              |    5 +++++
 arch/um/sys-x86_64/syscall_table.c             |   17 ++++++++++++++---
 6 files changed, 25 insertions(+), 16 deletions(-)

Index: linux-2.6-git/arch/um/include/sysdep-x86_64/syscalls.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/sysdep-x86_64/syscalls.h	2008-02-01 11:24:32.000000000 -0500
+++ linux-2.6-git/arch/um/include/sysdep-x86_64/syscalls.h	2008-02-01 11:47:51.000000000 -0500
@@ -30,6 +30,4 @@ extern long old_mmap(unsigned long addr,
 extern syscall_handler_t sys_modify_ldt;
 extern syscall_handler_t sys_arch_prctl;
 
-#define NR_syscalls (UM_NR_syscall_max + 1)
-
 #endif
Index: linux-2.6-git/arch/um/kernel/skas/syscall.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/skas/syscall.c	2008-02-01 11:24:32.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/skas/syscall.c	2008-02-01 11:48:02.000000000 -0500
@@ -9,6 +9,9 @@
 #include "sysdep/ptrace.h"
 #include "sysdep/syscalls.h"
 
+extern int syscall_table_size;
+#define NR_syscalls (syscall_table_size / sizeof(void *))
+
 void handle_syscall(struct uml_pt_regs *r)
 {
 	struct pt_regs *regs = container_of(r, struct pt_regs, regs);
Index: linux-2.6-git/arch/um/sys-i386/sys_call_table.S
===================================================================
--- linux-2.6-git.orig/arch/um/sys-i386/sys_call_table.S	2008-02-01 11:24:32.000000000 -0500
+++ linux-2.6-git/arch/um/sys-i386/sys_call_table.S	2008-02-01 12:08:17.000000000 -0500
@@ -9,4 +9,9 @@
 
 #define old_mmap old_mmap_i386
 
+.section .rodata,"a"
+
 #include "../../x86/kernel/syscall_table_32.S"
+
+ENTRY(syscall_table_size)
+.long .-sys_call_table
Index: linux-2.6-git/arch/um/include/sysdep-i386/syscalls.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/sysdep-i386/syscalls.h	2007-11-28 13:01:17.000000000 -0500
+++ linux-2.6-git/arch/um/include/sysdep-i386/syscalls.h	2008-02-01 11:48:02.000000000 -0500
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2008 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -18,7 +18,8 @@ extern syscall_handler_t old_mmap_i386;
 extern syscall_handler_t *sys_call_table[];
 
 #define EXECUTE_SYSCALL(syscall, regs) \
-	((long (*)(struct syscall_args)) (*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
+	((long (*)(struct syscall_args)) \
+	 (*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
 
 extern long sys_mmap2(unsigned long addr, unsigned long len,
 		      unsigned long prot, unsigned long flags,
Index: linux-2.6-git/arch/um/include/sysdep-x86_64/kernel-offsets.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/sysdep-x86_64/kernel-offsets.h	2007-12-03 23:56:34.000000000 -0500
+++ linux-2.6-git/arch/um/include/sysdep-x86_64/kernel-offsets.h	2008-02-01 11:48:01.000000000 -0500
@@ -17,16 +17,7 @@
 #define OFFSET(sym, str, mem) \
 	DEFINE(sym, offsetof(struct str, mem));
 
-#define __NO_STUBS 1
-#undef __SYSCALL
-#undef _ASM_X86_64_UNISTD_H_
-#define __SYSCALL(nr, sym) [nr] = 1,
-static char syscalls[] = {
-#include <asm/arch/unistd.h>
-};
-
 void foo(void)
 {
 #include <common-offsets.h>
-DEFINE(UM_NR_syscall_max, sizeof(syscalls) - 1);
 }
Index: linux-2.6-git/arch/um/sys-x86_64/syscall_table.c
===================================================================
--- linux-2.6-git.orig/arch/um/sys-x86_64/syscall_table.c	2008-01-25 11:14:05.000000000 -0500
+++ linux-2.6-git/arch/um/sys-x86_64/syscall_table.c	2008-02-01 11:48:01.000000000 -0500
@@ -46,8 +46,19 @@ typedef void (*sys_call_ptr_t)(void);
 
 extern void sys_ni_syscall(void);
 
-sys_call_ptr_t sys_call_table[UM_NR_syscall_max+1] __cacheline_aligned = {
-	/* Smells like a like a compiler bug -- it doesn't work when the & below is removed. */
-	[0 ... UM_NR_syscall_max] = &sys_ni_syscall,
+/*
+ * We used to have a trick here which made sure that holes in the
+ * x86_64 table were filled in with sys_ni_syscall, but a comment in
+ * unistd_64.h says that holes aren't allowed, so the trick was
+ * removed.
+ * The trick looked like this
+ *	[0 ... UM_NR_syscall_max] = &sys_ni_syscall
+ * before including unistd_64.h - the later initializations overwrote
+ * the sys_ni_syscall filler.
+ */
+
+sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
 #include <asm-x86/unistd_64.h>
 };
+
+int syscall_table_size = sizeof(sys_call_table);
Redo the calculation of NR_syscalls since that disappeared from i386
and use a similar mechanism on x86_64.

We now figure out the size of the system call table in arch code and
stick that in syscall_table_size.  arch/um/kernel/skas/syscall.c
defines NR_syscalls in terms of that since its the only thing that
needs to know how many system calls there are.

The old mechananism that was used on x86_64 is gone.

arch/um/include/sysdep-i386/syscalls.h got some formatting since I was
looking at it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/sysdep-i386/syscalls.h         |    5 +++--
 arch/um/include/sysdep-x86_64/kernel-offsets.h |    9 ---------
 arch/um/include/sysdep-x86_64/syscalls.h       |    2 --
 arch/um/kernel/skas/syscall.c                  |    3 +++
 arch/um/sys-i386/sys_call_table.S              |    5 +++++
 arch/um/sys-x86_64/syscall_table.c             |   17 ++++++++++++++---
 6 files changed, 25 insertions(+), 16 deletions(-)

Index: linux-2.6-git/arch/um/include/sysdep-x86_64/syscalls.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/sysdep-x86_64/syscalls.h	2008-02-01 11:24:32.000000000 -0500
+++ linux-2.6-git/arch/um/include/sysdep-x86_64/syscalls.h	2008-02-01 11:47:51.000000000 -0500
@@ -30,6 +30,4 @@ extern long old_mmap(unsigned long addr,
 extern syscall_handler_t sys_modify_ldt;
 extern syscall_handler_t sys_arch_prctl;
 
-#define NR_syscalls (UM_NR_syscall_max + 1)
-
 #endif
Index: linux-2.6-git/arch/um/kernel/skas/syscall.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/skas/syscall.c	2008-02-01 11:24:32.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/skas/syscall.c	2008-02-01 11:48:02.000000000 -0500
@@ -9,6 +9,9 @@
 #include "sysdep/ptrace.h"
 #include "sysdep/syscalls.h"
 
+extern int syscall_table_size;
+#define NR_syscalls (syscall_table_size / sizeof(void *))
+
 void handle_syscall(struct uml_pt_regs *r)
 {
 	struct pt_regs *regs = container_of(r, struct pt_regs, regs);
Index: linux-2.6-git/arch/um/sys-i386/sys_call_table.S
===================================================================
--- linux-2.6-git.orig/arch/um/sys-i386/sys_call_table.S	2008-02-01 11:24:32.000000000 -0500
+++ linux-2.6-git/arch/um/sys-i386/sys_call_table.S	2008-02-01 12:08:17.000000000 -0500
@@ -9,4 +9,9 @@
 
 #define old_mmap old_mmap_i386
 
+.section .rodata,"a"
+
 #include "../../x86/kernel/syscall_table_32.S"
+
+ENTRY(syscall_table_size)
+.long .-sys_call_table
Index: linux-2.6-git/arch/um/include/sysdep-i386/syscalls.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/sysdep-i386/syscalls.h	2007-11-28 13:01:17.000000000 -0500
+++ linux-2.6-git/arch/um/include/sysdep-i386/syscalls.h	2008-02-01 11:48:02.000000000 -0500
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2008 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -18,7 +18,8 @@ extern syscall_handler_t old_mmap_i386;
 extern syscall_handler_t *sys_call_table[];
 
 #define EXECUTE_SYSCALL(syscall, regs) \
-	((long (*)(struct syscall_args)) (*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
+	((long (*)(struct syscall_args)) \
+	 (*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
 
 extern long sys_mmap2(unsigned long addr, unsigned long len,
 		      unsigned long prot, unsigned long flags,
Index: linux-2.6-git/arch/um/include/sysdep-x86_64/kernel-offsets.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/sysdep-x86_64/kernel-offsets.h	2007-12-03 23:56:34.000000000 -0500
+++ linux-2.6-git/arch/um/include/sysdep-x86_64/kernel-offsets.h	2008-02-01 11:48:01.000000000 -0500
@@ -17,16 +17,7 @@
 #define OFFSET(sym, str, mem) \
 	DEFINE(sym, offsetof(struct str, mem));
 
-#define __NO_STUBS 1
-#undef __SYSCALL
-#undef _ASM_X86_64_UNISTD_H_
-#define __SYSCALL(nr, sym) [nr] = 1,
-static char syscalls[] = {
-#include <asm/arch/unistd.h>
-};
-
 void foo(void)
 {
 #include <common-offsets.h>
-DEFINE(UM_NR_syscall_max, sizeof(syscalls) - 1);
 }
Index: linux-2.6-git/arch/um/sys-x86_64/syscall_table.c
===================================================================
--- linux-2.6-git.orig/arch/um/sys-x86_64/syscall_table.c	2008-01-25 11:14:05.000000000 -0500
+++ linux-2.6-git/arch/um/sys-x86_64/syscall_table.c	2008-02-01 11:48:01.000000000 -0500
@@ -46,8 +46,19 @@ typedef void (*sys_call_ptr_t)(void);
 
 extern void sys_ni_syscall(void);
 
-sys_call_ptr_t sys_call_table[UM_NR_syscall_max+1] __cacheline_aligned = {
-	/* Smells like a like a compiler bug -- it doesn't work when the & below is removed. */
-	[0 ... UM_NR_syscall_max] = &sys_ni_syscall,
+/*
+ * We used to have a trick here which made sure that holes in the
+ * x86_64 table were filled in with sys_ni_syscall, but a comment in
+ * unistd_64.h says that holes aren't allowed, so the trick was
+ * removed.
+ * The trick looked like this
+ *	[0 ... UM_NR_syscall_max] = &sys_ni_syscall
+ * before including unistd_64.h - the later initializations overwrote
+ * the sys_ni_syscall filler.
+ */
+
+sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
 #include <asm-x86/unistd_64.h>
 };
+
+int syscall_table_size = sizeof(sys_call_table);

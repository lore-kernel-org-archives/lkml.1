Return-Path: <linux-kernel-owner+w=401wt.eu-S1760769AbXIQJL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760769AbXIQJL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757983AbXIQIxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:53:35 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47066 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227AbXIQIxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:53:34 -0400
Date: Mon, 17 Sep 2007 10:54:12 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Jakub Jelinek <jakub@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: increase AT_VECTOR_SIZE to terminate saved_auxv properly
Message-ID: <20070917085412.GA26593@aepfle.de>
References: <20070914110057.GA10088@aepfle.de> <20070915140106.GA7129@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070915140106.GA7129@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, Jakub Jelinek wrote:

> > If AT_NULL is required, AT_VECTOR_SIZE should be changed from 44 to 46.
> 
> No, it should be computed instead from the number of target independent aux
> vector pairs and then from an per-arch macro which says how many arch
> specific aux vector pairs are needed.

How should I define the arch specific part? ARCH_DLINFO is in asm/elf.h.
I suspect that sched.h should not include elh.h.
What asm/xyz.h would be a good place for AT_VECTOR_SIZE_ARCH?
The attempt below does currently not compile.


include/asm-powerpc/elf.h has 6 entries in ARCH_DLINFO.
fs/binfmt_elf.c has 14 unconditional NEW_AUX_ENT entries and 2
conditional NEW_AUX_ENT entries.
So in the worst case, saved_auxv does not get an AT_NULL entry at the
end.

The saved_auxv array must be terminated with an AT_NULL entry.
Make the size of mm_struct->saved_auxv arch dependend,
based on the number of ARCH_DLINFO entries.

---
 include/asm-alpha/elf.h   |    1 +
 include/asm-i386/elf.h    |    1 +
 include/asm-ia64/elf.h    |    1 +
 include/asm-powerpc/elf.h |    1 +
 include/asm-sh/elf.h      |    1 +
 include/linux/auxvec.h    |    4 +++-
 include/linux/elf.h       |    5 +++++
 include/linux/sched.h     |    1 -
 8 files changed, 13 insertions(+), 2 deletions(-)

--- a/include/asm-alpha/elf.h
+++ b/include/asm-alpha/elf.h
@@ -155,6 +155,7 @@ extern int alpha_l1d_cacheshape;
 extern int alpha_l2_cacheshape;
 extern int alpha_l3_cacheshape;
 
+#define AT_VECTOR_SIZE_ARCH 4
 #define ARCH_DLINFO						\
   do {								\
     NEW_AUX_ENT(AT_L1I_CACHESHAPE, alpha_l1i_cacheshape);	\
--- a/include/asm-i386/elf.h
+++ b/include/asm-i386/elf.h
@@ -152,6 +152,7 @@ extern int arch_setup_additional_pages(s
 
 extern unsigned int vdso_enabled;
 
+#define AT_VECTOR_SIZE_ARCH 2
 #define ARCH_DLINFO							\
 do if (vdso_enabled) {							\
 		NEW_AUX_ENT(AT_SYSINFO,	VDSO_ENTRY);			\
--- a/include/asm-ia64/elf.h
+++ b/include/asm-ia64/elf.h
@@ -192,6 +192,7 @@ extern int dump_task_fpu (struct task_st
 
 #define GATE_EHDR	((const struct elfhdr *) GATE_ADDR)
 
+#define AT_VECTOR_SIZE_ARCH 2
 #define ARCH_DLINFO								\
 do {										\
 	extern char __kernel_syscall_via_epc[];					\
--- a/include/asm-powerpc/elf.h
+++ b/include/asm-powerpc/elf.h
@@ -282,6 +282,7 @@ extern int arch_setup_additional_pages(s
  * - for compatibility with glibc ARCH_DLINFO must always be defined on PPC,
  *   even if DLINFO_ARCH_ITEMS goes to zero or is undefined.
  */
+#define AT_VECTOR_SIZE_ARCH 6
 #define ARCH_DLINFO							\
 do {									\
 	/* Handle glibc compatibility. */				\
--- a/include/asm-sh/elf.h
+++ b/include/asm-sh/elf.h
@@ -133,6 +133,7 @@ extern void __kernel_vsyscall;
 #define VDSO_BASE		((unsigned long)current->mm->context.vdso)
 #define VDSO_SYM(x)		(VDSO_BASE + (unsigned long)(x))
 
+#define AT_VECTOR_SIZE_ARCH 1
 #define ARCH_DLINFO						\
 do {								\
 	if (vdso_enabled)					\
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -26,6 +26,8 @@
 
 #define AT_SECURE 23   /* secure mode boolean */
 
-#define AT_VECTOR_SIZE  44 /* Size of auxiliary table.  */
+#ifdef __KERNEL__
+#define AT_VECTOR_SIZE_BASE  (14 + 2) /* generic entries in auxiliary table. */
+#endif
 
 #endif /* _LINUX_AUXVEC_H */
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -6,6 +6,11 @@
 #include <linux/elf-em.h>
 #include <asm/elf.h>
 
+#ifndef AT_VECTOR_SIZE_ARCH
+#define AT_VECTOR_SIZE_ARCH 0
+#endif
+#define AT_VECTOR_SIZE (AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1)
+
 struct file;
 
 #ifndef elf_read_implies_exec
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_SCHED_H
 #define _LINUX_SCHED_H
 
-#include <linux/auxvec.h>	/* For AT_VECTOR_SIZE */
 
 /*
  * cloning flags:

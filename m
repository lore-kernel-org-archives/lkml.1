Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbXIRLyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbXIRLyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 07:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbXIRLy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 07:54:29 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:51766 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbXIRLy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 07:54:28 -0400
Date: Tue, 18 Sep 2007 13:55:04 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] increase AT_VECTOR_SIZE to terminate saved_auxv properly
Message-ID: <20070918115504.GA609@aepfle.de>
References: <20070914110057.GA10088@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070914110057.GA10088@aepfle.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


include/asm-powerpc/elf.h has 6 entries in ARCH_DLINFO.
fs/binfmt_elf.c has 14 unconditional NEW_AUX_ENT entries and 2
conditional NEW_AUX_ENT entries.
So in the worst case, saved_auxv does not get an AT_NULL entry at the
end.

The saved_auxv array must be terminated with an AT_NULL entry.
Make the size of mm_struct->saved_auxv arch dependend,
based on the number of ARCH_DLINFO entries.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 include/asm-alpha/system.h   |    1 +
 include/asm-i386/system.h    |    1 +
 include/asm-ia64/system.h    |    2 ++
 include/asm-powerpc/system.h |    1 +
 include/asm-sh/system.h      |    1 +
 include/linux/auxvec.h       |    4 +++-
 include/linux/elf.h          |    1 -
 include/linux/sched.h        |    6 +++++-
 8 files changed, 14 insertions(+), 3 deletions(-)

--- a/include/asm-alpha/system.h
+++ b/include/asm-alpha/system.h
@@ -48,6 +48,7 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/kernel.h>
+#define AT_VECTOR_SIZE_ARCH 4
 
 /*
  * This is the logout header that should be common to all platforms
--- a/include/asm-i386/system.h
+++ b/include/asm-i386/system.h
@@ -7,6 +7,7 @@
 #include <asm/cmpxchg.h>
 
 #ifdef __KERNEL__
+#define AT_VECTOR_SIZE_ARCH 2
 
 struct task_struct;	/* one of the stranger aspects of C forward declarations.. */
 extern struct task_struct * FASTCALL(__switch_to(struct task_struct *prev, struct task_struct *next));
--- a/include/asm-ia64/system.h
+++ b/include/asm-ia64/system.h
@@ -32,6 +32,8 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 
+#define AT_VECTOR_SIZE_ARCH 2
+
 struct pci_vector_struct {
 	__u16 segment;	/* PCI Segment number */
 	__u16 bus;	/* PCI Bus number */
--- a/include/asm-powerpc/system.h
+++ b/include/asm-powerpc/system.h
@@ -40,6 +40,7 @@
 #define set_mb(var, value)	do { var = value; mb(); } while (0)
 
 #ifdef __KERNEL__
+#define AT_VECTOR_SIZE_ARCH 6
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()
--- a/include/asm-sh/system.h
+++ b/include/asm-sh/system.h
@@ -11,6 +11,7 @@
 #include <asm/types.h>
 #include <asm/ptrace.h>
 
+#define AT_VECTOR_SIZE_ARCH 1
 /*
  *	switch_to() should switch tasks to task nr n, first
  */
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
@@ -2,7 +2,6 @@
 #define _LINUX_ELF_H
 
 #include <linux/types.h>
-#include <linux/auxvec.h>
 #include <linux/elf-em.h>
 #include <asm/elf.h>
 
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_SCHED_H
 #define _LINUX_SCHED_H
 
-#include <linux/auxvec.h>	/* For AT_VECTOR_SIZE */
 
 /*
  * cloning flags:
@@ -90,6 +89,11 @@ struct exec_domain;
 struct futex_pi_state;
 struct bio;
 
+#include <linux/auxvec.h>
+#ifndef AT_VECTOR_SIZE_ARCH
+#define AT_VECTOR_SIZE_ARCH 0
+#endif
+#define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
 /*
  * List of flags we want to share for kernel threads,
  * if only because they are not used by them anyway.

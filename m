Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYAHWQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYAHWQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYAHWPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:15:35 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:47848
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751741AbYAHWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:15:33 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 01 of 10] x86: move all asm/pgtable constants into one place
X-Mercurial-Node: a6d5e9e1a81d750da4a76b0c9863ab0d88afbeb5
Message-Id: <a6d5e9e1a81d750da4a7.1199829604@localhost>
In-Reply-To: <patchbomb.1199829603@localhost>
Date: Tue, 08 Jan 2008 14:00:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32 and 64-bit use the same flags for pagetable entries, so make them all common.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/asm-x86/pgtable.h    |  113 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/pgtable_32.h |  110 ----------------------------------------
 include/asm-x86/pgtable_64.h |   91 ---------------------------------
 3 files changed, 113 insertions(+), 201 deletions(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -1,5 +1,118 @@
+#ifndef _ASM_X86_PGTABLE_H
+#define _ASM_X86_PGTABLE_H
+
+#define USER_PTRS_PER_PGD	((TASK_SIZE-1)/PGDIR_SIZE+1)
+#define FIRST_USER_ADDRESS	0
+
+#define _PAGE_BIT_PRESENT	0
+#define _PAGE_BIT_RW		1
+#define _PAGE_BIT_USER		2
+#define _PAGE_BIT_PWT		3
+#define _PAGE_BIT_PCD		4
+#define _PAGE_BIT_ACCESSED	5
+#define _PAGE_BIT_DIRTY		6
+#define _PAGE_BIT_FILE		6
+#define _PAGE_BIT_PSE		7	/* 4 MB (or 2MB) page */
+#define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
+#define _PAGE_BIT_UNUSED1	9	/* available for programmer */
+#define _PAGE_BIT_UNUSED2	10
+#define _PAGE_BIT_UNUSED3	11
+#define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
+
+#define _PAGE_PRESENT	(_AC(1, UL)<<_PAGE_BIT_PRESENT)
+#define _PAGE_RW	(_AC(1, UL)<<_PAGE_BIT_RW)
+#define _PAGE_USER	(_AC(1, UL)<<_PAGE_BIT_USER)
+#define _PAGE_PWT	(_AC(1, UL)<<_PAGE_BIT_PWT)
+#define _PAGE_PCD	(_AC(1, UL)<<_PAGE_BIT_PCD)
+#define _PAGE_ACCESSED	(_AC(1, UL)<<_PAGE_BIT_ACCESSED)
+#define _PAGE_DIRTY	(_AC(1, UL)<<_PAGE_BIT_DIRTY)
+#define _PAGE_PSE	(_AC(1, UL)<<_PAGE_BIT_PSE)	/* 2MB page */
+#define _PAGE_GLOBAL	(_AC(1, UL)<<_PAGE_BIT_GLOBAL)	/* Global TLB entry */
+#define _PAGE_UNUSED1	(_AC(1, UL)<<_PAGE_BIT_UNUSED1)
+#define _PAGE_UNUSED2	(_AC(1, UL)<<_PAGE_BIT_UNUSED2)
+#define _PAGE_UNUSED3	(_AC(1, UL)<<_PAGE_BIT_UNUSED3)
+
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+#define _PAGE_NX	(_AC(1, ULL) << _PAGE_BIT_NX)
+#else
+#define _PAGE_NX	0
+#endif
+
+/* If _PAGE_PRESENT is clear, we use these: */
+#define _PAGE_FILE	_PAGE_DIRTY	/* nonlinear file mapping, saved PTE; unset:swap */
+#define _PAGE_PROTNONE	_PAGE_PSE	/* if the user mapped it with PROT_NONE;
+					   pte_present gives true */
+
+#define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
+
+#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
+
+#define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
+#define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
+
+#define PAGE_SHARED_EXEC	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED)
+#define PAGE_COPY_NOEXEC	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
+#define PAGE_COPY_EXEC		__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
+#define PAGE_COPY		PAGE_COPY_NOEXEC
+#define PAGE_READONLY		__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
+#define PAGE_READONLY_EXEC	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
+
+#ifdef CONFIG_X86_32
+#define _PAGE_KERNEL_EXEC \
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
+#define _PAGE_KERNEL (_PAGE_KERNEL_EXEC | _PAGE_NX)
+
+#ifndef __ASSEMBLER__
+extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
+#endif	/* __ASSEMBLER__ */
+#else
+#define __PAGE_KERNEL_EXEC						\
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
+#define __PAGE_KERNEL		(__PAGE_KERNEL_EXEC | _PAGE_NX)
+#endif
+
+#define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
+#define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
+#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RO | _PAGE_USER)
+#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
+#define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
+
+#define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
+#define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
+#define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC)
+#define PAGE_KERNEL_RX			__pgprot(__PAGE_KERNEL_RX)
+#define PAGE_KERNEL_NOCACHE		__pgprot(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_LARGE		__pgprot(__PAGE_KERNEL_LARGE)
+#define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
+#define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
+#define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
+
+/*         xwr */
+#define __P000	PAGE_NONE
+#define __P001	PAGE_READONLY
+#define __P010	PAGE_COPY
+#define __P011	PAGE_COPY
+#define __P100	PAGE_READONLY_EXEC
+#define __P101	PAGE_READONLY_EXEC
+#define __P110	PAGE_COPY_EXEC
+#define __P111	PAGE_COPY_EXEC
+
+#define __S000	PAGE_NONE
+#define __S001	PAGE_READONLY
+#define __S010	PAGE_SHARED
+#define __S011	PAGE_SHARED
+#define __S100	PAGE_READONLY_EXEC
+#define __S101	PAGE_READONLY_EXEC
+#define __S110	PAGE_SHARED_EXEC
+#define __S111	PAGE_SHARED_EXEC
+
 #ifdef CONFIG_X86_32
 # include "pgtable_32.h"
 #else
 # include "pgtable_64.h"
 #endif
+
+#endif	/* _ASM_X86_PGTABLE_H */
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -58,9 +58,6 @@ void paging_init(void);
 #define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
 
-#define USER_PTRS_PER_PGD	(TASK_SIZE/PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
-
 #define USER_PGD_PTRS (PAGE_OFFSET >> PGDIR_SHIFT)
 #define KERNEL_PGD_PTRS (PTRS_PER_PGD-USER_PGD_PTRS)
 
@@ -83,113 +80,6 @@ void paging_init(void);
 #else
 # define VMALLOC_END	(FIXADDR_START-2*PAGE_SIZE)
 #endif
-
-/*
- * _PAGE_PSE set in the page directory entry just means that
- * the page directory entry points directly to a 4MB-aligned block of
- * memory. 
- */
-#define _PAGE_BIT_PRESENT	0
-#define _PAGE_BIT_RW		1
-#define _PAGE_BIT_USER		2
-#define _PAGE_BIT_PWT		3
-#define _PAGE_BIT_PCD		4
-#define _PAGE_BIT_ACCESSED	5
-#define _PAGE_BIT_DIRTY		6
-#define _PAGE_BIT_PSE		7	/* 4 MB (or 2MB) page, Pentium+, if present.. */
-#define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
-#define _PAGE_BIT_UNUSED1	9	/* available for programmer */
-#define _PAGE_BIT_UNUSED2	10
-#define _PAGE_BIT_UNUSED3	11
-#define _PAGE_BIT_NX		63
-
-#define _PAGE_PRESENT	0x001
-#define _PAGE_RW	0x002
-#define _PAGE_USER	0x004
-#define _PAGE_PWT	0x008
-#define _PAGE_PCD	0x010
-#define _PAGE_ACCESSED	0x020
-#define _PAGE_DIRTY	0x040
-#define _PAGE_PSE	0x080	/* 4 MB (or 2MB) page, Pentium+, if present.. */
-#define _PAGE_GLOBAL	0x100	/* Global TLB entry PPro+ */
-#define _PAGE_UNUSED1	0x200	/* available for programmer */
-#define _PAGE_UNUSED2	0x400
-#define _PAGE_UNUSED3	0x800
-
-/* If _PAGE_PRESENT is clear, we use these: */
-#define _PAGE_FILE	0x040	/* nonlinear file mapping, saved PTE; unset:swap */
-#define _PAGE_PROTNONE	0x080	/* if the user mapped it with PROT_NONE;
-				   pte_present gives true */
-#ifdef CONFIG_X86_PAE
-#define _PAGE_NX	(1ULL<<_PAGE_BIT_NX)
-#else
-#define _PAGE_NX	0
-#endif
-
-#define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
-#define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
-#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
-
-#define PAGE_NONE \
-	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
-#define PAGE_SHARED \
-	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED)
-
-#define PAGE_SHARED_EXEC \
-	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED)
-#define PAGE_COPY_NOEXEC \
-	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
-#define PAGE_COPY_EXEC \
-	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
-#define PAGE_COPY \
-	PAGE_COPY_NOEXEC
-#define PAGE_READONLY \
-	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
-#define PAGE_READONLY_EXEC \
-	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
-
-#define _PAGE_KERNEL \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_NX)
-#define _PAGE_KERNEL_EXEC \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
-
-extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
-#define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
-#define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
-#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
-#define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
-#define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
-
-#define PAGE_KERNEL		__pgprot(__PAGE_KERNEL)
-#define PAGE_KERNEL_RO		__pgprot(__PAGE_KERNEL_RO)
-#define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC)
-#define PAGE_KERNEL_RX		__pgprot(__PAGE_KERNEL_RX)
-#define PAGE_KERNEL_NOCACHE	__pgprot(__PAGE_KERNEL_NOCACHE)
-#define PAGE_KERNEL_LARGE	__pgprot(__PAGE_KERNEL_LARGE)
-#define PAGE_KERNEL_LARGE_EXEC	__pgprot(__PAGE_KERNEL_LARGE_EXEC)
-
-/*
- * The i386 can't do page protection for execute, and considers that
- * the same are read. Also, write permissions imply read permissions.
- * This is the closest we can get..
- */
-#define __P000	PAGE_NONE
-#define __P001	PAGE_READONLY
-#define __P010	PAGE_COPY
-#define __P011	PAGE_COPY
-#define __P100	PAGE_READONLY_EXEC
-#define __P101	PAGE_READONLY_EXEC
-#define __P110	PAGE_COPY_EXEC
-#define __P111	PAGE_COPY_EXEC
-
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READONLY
-#define __S010	PAGE_SHARED
-#define __S011	PAGE_SHARED
-#define __S100	PAGE_READONLY_EXEC
-#define __S101	PAGE_READONLY_EXEC
-#define __S110	PAGE_SHARED_EXEC
-#define __S111	PAGE_SHARED_EXEC
 
 /*
  * Define this if things work differently on an i386 and an i486:
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -131,8 +131,6 @@ static inline pte_t ptep_get_and_clear_f
 #define PGDIR_SIZE	(_AC(1,UL) << PGDIR_SHIFT)
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
 
-#define USER_PTRS_PER_PGD	((TASK_SIZE-1)/PGDIR_SIZE+1)
-#define FIRST_USER_ADDRESS	0
 
 #define MAXMEM		 _AC(0x3fffffffffff, UL)
 #define VMALLOC_START    _AC(0xffffc20000000000, UL)
@@ -141,95 +139,6 @@ static inline pte_t ptep_get_and_clear_f
 #define MODULES_VADDR    _AC(0xffffffff88000000, UL)
 #define MODULES_END      _AC(0xfffffffffff00000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
-
-#define _PAGE_BIT_PRESENT	0
-#define _PAGE_BIT_RW		1
-#define _PAGE_BIT_USER		2
-#define _PAGE_BIT_PWT		3
-#define _PAGE_BIT_PCD		4
-#define _PAGE_BIT_ACCESSED	5
-#define _PAGE_BIT_DIRTY		6
-#define _PAGE_BIT_PSE		7	/* 4 MB (or 2MB) page */
-#define _PAGE_BIT_FILE		6
-#define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
-#define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
-
-#define _PAGE_PRESENT	(_AC(1, UL)<<_PAGE_BIT_PRESENT)
-#define _PAGE_RW	(_AC(1, UL)<<_PAGE_BIT_RW)
-#define _PAGE_USER	(_AC(1, UL)<<_PAGE_BIT_USER)
-#define _PAGE_PWT	(_AC(1, UL)<<_PAGE_BIT_PWT)
-#define _PAGE_PCD	(_AC(1, UL)<<_PAGE_BIT_PCD)
-#define _PAGE_ACCESSED	(_AC(1, UL)<<_PAGE_BIT_ACCESSED)
-#define _PAGE_DIRTY	(_AC(1, UL)<<_PAGE_BIT_DIRTY)
-/* 2MB page */
-#define _PAGE_PSE	(_AC(1, UL)<<_PAGE_BIT_PSE)
-/* nonlinear file mapping, saved PTE; unset:swap */
-#define _PAGE_FILE	(_AC(1, UL)<<_PAGE_BIT_FILE)
-/* Global TLB entry */
-#define _PAGE_GLOBAL	(_AC(1, UL)<<_PAGE_BIT_GLOBAL)
-
-#define _PAGE_PROTNONE	0x080	/* If not present */
-#define _PAGE_NX        (_AC(1, UL)<<_PAGE_BIT_NX)
-
-#define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
-#define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
-
-#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
-
-#define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
-#define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
-#define PAGE_SHARED_EXEC __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED)
-#define PAGE_COPY_NOEXEC __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
-#define PAGE_COPY PAGE_COPY_NOEXEC
-#define PAGE_COPY_EXEC __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
-#define PAGE_READONLY	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
-#define PAGE_READONLY_EXEC __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
-#define __PAGE_KERNEL \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_NX)
-#define __PAGE_KERNEL_EXEC \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
-#define __PAGE_KERNEL_NOCACHE \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_PCD | _PAGE_PWT | _PAGE_ACCESSED | _PAGE_NX)
-#define __PAGE_KERNEL_RO \
-	(_PAGE_PRESENT | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_NX)
-#define __PAGE_KERNEL_VSYSCALL \
-	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
-#define __PAGE_KERNEL_VSYSCALL_NOCACHE \
-	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_PCD | _PAGE_PWT)
-#define __PAGE_KERNEL_LARGE \
-	(__PAGE_KERNEL | _PAGE_PSE)
-#define __PAGE_KERNEL_LARGE_EXEC \
-	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
-
-#define MAKE_GLOBAL(x) __pgprot((x) | _PAGE_GLOBAL)
-
-#define PAGE_KERNEL MAKE_GLOBAL(__PAGE_KERNEL)
-#define PAGE_KERNEL_EXEC MAKE_GLOBAL(__PAGE_KERNEL_EXEC)
-#define PAGE_KERNEL_RO MAKE_GLOBAL(__PAGE_KERNEL_RO)
-#define PAGE_KERNEL_NOCACHE MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
-#define PAGE_KERNEL_VSYSCALL32 __pgprot(__PAGE_KERNEL_VSYSCALL)
-#define PAGE_KERNEL_VSYSCALL MAKE_GLOBAL(__PAGE_KERNEL_VSYSCALL)
-#define PAGE_KERNEL_LARGE MAKE_GLOBAL(__PAGE_KERNEL_LARGE)
-#define PAGE_KERNEL_VSYSCALL_NOCACHE MAKE_GLOBAL(__PAGE_KERNEL_VSYSCALL_NOCACHE)
-
-/*         xwr */
-#define __P000	PAGE_NONE
-#define __P001	PAGE_READONLY
-#define __P010	PAGE_COPY
-#define __P011	PAGE_COPY
-#define __P100	PAGE_READONLY_EXEC
-#define __P101	PAGE_READONLY_EXEC
-#define __P110	PAGE_COPY_EXEC
-#define __P111	PAGE_COPY_EXEC
-
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READONLY
-#define __S010	PAGE_SHARED
-#define __S011	PAGE_SHARED
-#define __S100	PAGE_READONLY_EXEC
-#define __S101	PAGE_READONLY_EXEC
-#define __S110	PAGE_SHARED_EXEC
-#define __S111	PAGE_SHARED_EXEC
 
 #ifndef __ASSEMBLY__
 



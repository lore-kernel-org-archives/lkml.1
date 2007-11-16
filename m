Return-Path: <linux-kernel-owner+w=401wt.eu-S935236AbXKPVqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935236AbXKPVqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934038AbXKPVne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:43:34 -0500
Received: from [198.99.130.12] ([198.99.130.12]:59884 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S935089AbXKPVna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:43:30 -0500
Date: Fri, 16 Nov 2007 16:42:25 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/8] UML - header untangling
Message-ID: <20071116214225.GA13852@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Untangle UML headers somewhat and add some includes where they were
needed explicitly, but gotten accidentally via some other header.

arch/um/include/um_uaccess.h loses asm/fixmap.h because it uses no
fixmap stuff and gains elf.h, because it needs FIXADDR_USER_*, and
archsetjmp.h, because it needs jmp_buf.

pmd_alloc_one is uninlined because it needs mm_struct, and that's
inconvenient to provide in asm-um/pgtable-3level.h.

elf_core_copy_fpregs is also uninlined from elf-i386.h and
elf-x86_64.h, which duplicated the code anyway, to
arch/um/kernel/process.c, so that the reference to current_thread
doesn't pull sched.h or anything related into asm/elf.h.

arch/um/sys-i386/ldt.c, arch/um/kernel/tlb.c and
arch/um/kernel/skas/uaccess.c got sched.h because they dereference
task_structs.  Its includes of linux and asm headers got turned from
"" to <>.

arch/um/sys-i386/bug.c gets asm/errno.h because it needs errno
constants.

asm/elf-i386 gets asm/user.h because it needs user_regs_struct.

asm/fixmap.h gets page.h because it needs PAGE_SIZE and PAGE_MASK and
system.h for BUG_ON.

asm/pgtable doesn't need sched.h.

asm/processor-generic.h defined mm_segment_t, but didn't use it.  So,
that definition is moved to uaccess.h, which defines a bunch of
mm_segment_t-related stuff.  thread_info.h uses mm_segment_t, and
includes uaccess.h, which causes a recursion.  So, the definition is
placed above the include of thread_info. in uaccess.h.  thread_info.h
also gets page.h because it needs PAGE_SIZE.

ObCheckpatchViolationJustification - I'm not adding a typedef; I'm
moving mm_segment_t from one place to another.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/random.c           |    1 +
 arch/um/include/um_uaccess.h       |    3 ++-
 arch/um/kernel/mem.c               |   21 ++++++++++++++++-----
 arch/um/kernel/process.c           |    8 ++++++++
 arch/um/kernel/skas/uaccess.c      |   13 +++++++------
 arch/um/kernel/tlb.c               |    7 ++++---
 arch/um/sys-i386/bug.c             |    1 +
 arch/um/sys-i386/ldt.c             |    5 +++--
 include/asm-um/elf-i386.h          |    9 ++-------
 include/asm-um/elf-x86_64.h        |    8 +-------
 include/asm-um/fixmap.h            |    3 ++-
 include/asm-um/pgtable-3level.h    |   11 ++---------
 include/asm-um/pgtable.h           |    1 -
 include/asm-um/processor-generic.h |    5 +----
 include/asm-um/thread_info.h       |    3 ++-
 include/asm-um/uaccess.h           |   10 +++++++++-
 16 files changed, 61 insertions(+), 48 deletions(-)

Index: linux-2.6.22/arch/um/drivers/random.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/random.c	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/arch/um/drivers/random.c	2007-11-16 13:30:15.000000000 -0500
@@ -5,6 +5,7 @@
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
  */
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
Index: linux-2.6.22/arch/um/include/um_uaccess.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/um_uaccess.h	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/arch/um/include/um_uaccess.h	2007-11-16 13:33:28.000000000 -0500
@@ -6,7 +6,8 @@
 #ifndef __ARCH_UM_UACCESS_H
 #define __ARCH_UM_UACCESS_H
 
-#include "asm/fixmap.h"
+#include "asm/elf.h"
+#include "sysdep/archsetjmp.h"
 
 #define __under_task_size(addr, size) \
 	(((unsigned long) (addr) < TASK_SIZE) && \
Index: linux-2.6.22/arch/um/kernel/mem.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/mem.c	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/mem.c	2007-11-16 15:18:34.000000000 -0500
@@ -152,7 +152,7 @@ pgprot_t kmap_prot;
 
 #define kmap_get_fixmap_pte(vaddr)					\
 	pte_offset_kernel(pmd_offset(pud_offset(pgd_offset_k(vaddr), (vaddr)),\
- 			  (vaddr)), (vaddr))
+				     (vaddr)), (vaddr))
 
 static void __init kmap_init(void)
 {
@@ -278,7 +278,8 @@ struct page *arch_validate(struct page *
 	goto again;
 }
 
-/* This can't do anything because nothing in the kernel image can be freed
+/*
+ * This can't do anything because nothing in the kernel image can be freed
  * since it's not in kernel physical memory.
  */
 
@@ -331,9 +332,7 @@ void show_mem(void)
 	printk("%d pages swap cached\n", cached);
 }
 
-/*
- * Allocate and free page tables.
- */
+/* Allocate and free page tables. */
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
@@ -370,3 +369,15 @@ pgtable_t pte_alloc_one(struct mm_struct
 		pgtable_page_ctor(pte);
 	return pte;
 }
+
+#ifdef CONFIG_3_LEVEL_PGTABLES
+pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	pmd_t *pmd = (pmd_t *) __get_free_page(GFP_KERNEL);
+
+	if (pmd)
+		memset(pmd, 0, PAGE_SIZE);
+
+	return pmd;
+}
+#endif
Index: linux-2.6.22/arch/um/kernel/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/process.c	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/process.c	2007-11-16 15:16:54.000000000 -0500
@@ -443,3 +443,11 @@ unsigned long get_wchan(struct task_stru
 
 	return 0;
 }
+
+int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu)
+{
+	int cpu = current_thread_info()->cpu;
+
+	return save_fp_registers(userspace_pid[cpu], (unsigned long *) fpu);
+}
+
Index: linux-2.6.22/arch/um/kernel/skas/uaccess.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/skas/uaccess.c	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/skas/uaccess.c	2007-11-16 15:16:54.000000000 -0500
@@ -3,12 +3,13 @@
  * Licensed under the GPL
  */
 
-#include "linux/err.h"
-#include "linux/highmem.h"
-#include "linux/mm.h"
-#include "asm/current.h"
-#include "asm/page.h"
-#include "asm/pgtable.h"
+#include <linux/err.h>
+#include <linux/highmem.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <asm/current.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
 #include "kern_util.h"
 #include "os.h"
 
Index: linux-2.6.22/arch/um/kernel/tlb.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/tlb.c	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/tlb.c	2007-11-16 15:16:54.000000000 -0500
@@ -3,9 +3,10 @@
  * Licensed under the GPL
  */
 
-#include "linux/mm.h"
-#include "asm/pgtable.h"
-#include "asm/tlbflush.h"
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
 #include "as-layout.h"
 #include "mem_user.h"
 #include "os.h"
Index: linux-2.6.22/arch/um/sys-i386/bug.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/bug.c	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/arch/um/sys-i386/bug.c	2007-11-16 13:30:15.000000000 -0500
@@ -4,6 +4,7 @@
  */
 
 #include <linux/uaccess.h>
+#include <asm/errno.h>
 
 /* Mostly copied from i386/x86_86 - eliminated the eip < PAGE_OFFSET because
  * that's not relevant in skas mode.
Index: linux-2.6.22/arch/um/sys-i386/ldt.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/ldt.c	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/arch/um/sys-i386/ldt.c	2007-11-16 13:41:19.000000000 -0500
@@ -3,8 +3,9 @@
  * Licensed under the GPL
  */
 
-#include "linux/mm.h"
-#include "asm/unistd.h"
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <asm/unistd.h>
 #include "os.h"
 #include "proc_mm.h"
 #include "skas.h"
Index: linux-2.6.22/include/asm-um/elf-i386.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/elf-i386.h	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/include/asm-um/elf-i386.h	2007-11-16 15:16:54.000000000 -0500
@@ -5,7 +5,7 @@
 #ifndef __UM_ELF_I386_H
 #define __UM_ELF_I386_H
 
-#include <linux/sched.h>
+#include <asm/user.h>
 #include "skas.h"
 
 #define R_386_NONE	0
@@ -76,12 +76,7 @@ typedef struct user_i387_struct elf_fpre
 	pr_reg[16] = PT_REGS_SS(regs);		\
 } while(0);
 
-static inline int elf_core_copy_fpregs(struct task_struct *t,
-				       elf_fpregset_t *fpu)
-{
-	int cpu = ((struct thread_info *) t->stack)->cpu;
-	return save_fp_registers(userspace_pid[cpu], (unsigned long *) fpu);
-}
+extern int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu);
 
 #define ELF_CORE_COPY_FPREGS(t, fpu) elf_core_copy_fpregs(t, fpu)
 
Index: linux-2.6.22/include/asm-um/fixmap.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/fixmap.h	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/include/asm-um/fixmap.h	2007-11-16 15:16:54.000000000 -0500
@@ -1,9 +1,10 @@
 #ifndef __UM_FIXMAP_H
 #define __UM_FIXMAP_H
 
+#include <asm/system.h>
 #include <asm/kmap_types.h>
 #include <asm/archparam.h>
-#include <asm/elf.h>
+#include <asm/page.h>
 
 /*
  * Here we define all the compile-time 'special' virtual
Index: linux-2.6.22/include/asm-um/pgtable-3level.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/pgtable-3level.h	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/include/asm-um/pgtable-3level.h	2007-11-16 15:16:54.000000000 -0500
@@ -60,15 +60,8 @@ static inline void pgd_mkuptodate(pgd_t 
 
 #define set_pmd(pmdptr, pmdval) set_64bit((phys_t *) (pmdptr), pmd_val(pmdval))
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-        pmd_t *pmd = (pmd_t *) __get_free_page(GFP_KERNEL);
-
-        if(pmd)
-                memset(pmd, 0, PAGE_SIZE);
-
-        return pmd;
-}
+struct mm_struct;
+extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address);
 
 static inline void pud_clear (pud_t *pud)
 {
Index: linux-2.6.22/include/asm-um/pgtable.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/pgtable.h	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/include/asm-um/pgtable.h	2007-11-16 15:16:54.000000000 -0500
@@ -8,7 +8,6 @@
 #ifndef __UM_PGTABLE_H
 #define __UM_PGTABLE_H
 
-#include "linux/sched.h"
 #include <asm/fixmap.h>
 
 #define _PAGE_PRESENT	0x001
Index: linux-2.6.22/include/asm-um/processor-generic.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/processor-generic.h	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/include/asm-um/processor-generic.h	2007-11-16 15:16:54.000000000 -0500
@@ -11,6 +11,7 @@ struct pt_regs;
 struct task_struct;
 
 #include "asm/ptrace.h"
+#include "asm/pgtable.h"
 #include "registers.h"
 #include "sysdep/archsetjmp.h"
 
@@ -68,10 +69,6 @@ struct thread_struct {
 	.request		= { 0 } \
 }
 
-typedef struct {
-	unsigned long seg;
-} mm_segment_t;
-
 extern struct task_struct *alloc_task_struct(void);
 
 static inline void release_thread(struct task_struct *task)
Index: linux-2.6.22/include/asm-um/uaccess.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/uaccess.h	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/include/asm-um/uaccess.h	2007-11-16 13:30:15.000000000 -0500
@@ -6,7 +6,15 @@
 #ifndef __UM_UACCESS_H
 #define __UM_UACCESS_H
 
-#include "linux/sched.h"
+#include <asm/errno.h>
+#include <asm/processor.h>
+
+/* thread_info has a mm_segment_t in it, so put the definition up here */
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+#include "linux/thread_info.h"
 
 #define VERIFY_READ 0
 #define VERIFY_WRITE 1
Index: linux-2.6.22/include/asm-um/thread_info.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/thread_info.h	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/include/asm-um/thread_info.h	2007-11-16 15:16:54.000000000 -0500
@@ -8,8 +8,9 @@
 
 #ifndef __ASSEMBLY__
 
-#include <asm/processor.h>
 #include <asm/types.h>
+#include <asm/page.h>
+#include <asm/uaccess.h>
 
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
Index: linux-2.6.22/include/asm-um/elf-x86_64.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/elf-x86_64.h	2007-11-16 13:30:12.000000000 -0500
+++ linux-2.6.22/include/asm-um/elf-x86_64.h	2007-11-16 13:30:15.000000000 -0500
@@ -7,7 +7,6 @@
 #ifndef __UM_ELF_X86_64_H
 #define __UM_ELF_X86_64_H
 
-#include <linux/sched.h>
 #include <asm/user.h>
 #include "skas.h"
 
@@ -96,12 +95,7 @@ typedef struct user_i387_struct elf_fpre
 	(pr_reg)[25] = 0;					\
 	(pr_reg)[26] = 0;
 
-static inline int elf_core_copy_fpregs(struct task_struct *t,
-				       elf_fpregset_t *fpu)
-{
-	int cpu = current_thread->cpu;
-	return save_fp_registers(userspace_pid[cpu], (unsigned long *) fpu);
-}
+extern int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu);
 
 #define ELF_CORE_COPY_FPREGS(t, fpu) elf_core_copy_fpregs(t, fpu)
 

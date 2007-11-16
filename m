Return-Path: <linux-kernel-owner+w=401wt.eu-S935159AbXKPVop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935159AbXKPVop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934821AbXKPVnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:43:00 -0500
Received: from [198.99.130.12] ([198.99.130.12]:59858 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934343AbXKPVm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:42:57 -0500
Date: Fri, 16 Nov 2007 16:42:27 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 6/8] UML - Clean up task size calculation
Message-ID: <20071116214227.GA13872@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the calculation and use of the usable address space size on
the host.

task_size is gone, replaced with TASK_SIZE, which is calculated from
CONFIG_TOP_ADDR.  get_kmem_end and set_task_sizes_skas are also gone.

host_task_size, which refers to the entire address space usable by the
UML kernel and which may be larger than the address space usable by a
UML process, since that has to end on a pgdir boundary, is replaced by
CONFIG_TOP_ADDR.

STACK_TOP is now TASK_SIZE minus the two stub pages.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/as-layout.h        |   15 +++++++++++++--
 arch/um/include/common-offsets.h   |    3 +++
 arch/um/include/mem_user.h         |    4 ----
 arch/um/kernel/exec.c              |    2 +-
 arch/um/kernel/ksyms.c             |    3 ---
 arch/um/kernel/physmem.c           |   10 ----------
 arch/um/kernel/tlb.c               |    2 +-
 arch/um/kernel/um_arch.c           |   22 ++--------------------
 include/asm-um/fixmap.h            |    3 +--
 include/asm-um/processor-generic.h |    7 +++----
 10 files changed, 24 insertions(+), 47 deletions(-)

Index: linux-2.6.22/arch/um/include/as-layout.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/as-layout.h	2007-11-16 13:14:39.000000000 -0500
+++ linux-2.6.22/arch/um/include/as-layout.h	2007-11-16 14:39:39.000000000 -0500
@@ -29,9 +29,20 @@
 #define _AC(X, Y)	__AC(X, Y)
 #endif
 
+/*
+ * The "- 1"'s are to avoid gcc complaining about integer overflows
+ * and unrepresentable decimal constants.  With 3-level page tables,
+ * TASK_SIZE is 0x80000000, which gets turned into its signed decimal
+ * equivalent in asm-offsets.s.  gcc then complains about that being
+ * unsigned only in C90.  To avoid that, UM_TASK_SIZE is defined as
+ * TASK_SIZE - 1.  To compensate, we need to add the 1 back here.
+ * However, adding it back to UM_TASK_SIZE produces more gcc
+ * complaints.  So, I adjust the thing being subtracted from
+ * UM_TASK_SIZE instead.  Bah.
+ */
 #define STUB_CODE _AC((unsigned long), \
-		      UML_CONFIG_TOP_ADDR - 2 * UM_KERN_PAGE_SIZE)
-#define STUB_DATA _AC((unsigned long), UML_CONFIG_TOP_ADDR - UM_KERN_PAGE_SIZE)
+		      UM_TASK_SIZE - (2 * UM_KERN_PAGE_SIZE - 1))
+#define STUB_DATA _AC((unsigned long), UM_TASK_SIZE - (UM_KERN_PAGE_SIZE - 1))
 #define STUB_START _AC(, STUB_CODE)
 
 #ifndef __ASSEMBLY__
Index: linux-2.6.22/arch/um/include/common-offsets.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/common-offsets.h	2007-11-16 13:21:51.000000000 -0500
+++ linux-2.6.22/arch/um/include/common-offsets.h	2007-11-16 14:39:39.000000000 -0500
@@ -39,3 +39,6 @@ DEFINE(UM_HZ, HZ);
 DEFINE(UM_USEC_PER_SEC, USEC_PER_SEC);
 DEFINE(UM_NSEC_PER_SEC, NSEC_PER_SEC);
 DEFINE(UM_NSEC_PER_USEC, NSEC_PER_USEC);
+
+/* See as-layout.h for an explanation of the "- 1".  Bah. */
+DEFINE(UM_TASK_SIZE, TASK_SIZE - 1);
Index: linux-2.6.22/arch/um/include/mem_user.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/mem_user.h	2007-11-16 13:14:39.000000000 -0500
+++ linux-2.6.22/arch/um/include/mem_user.h	2007-11-16 14:39:39.000000000 -0500
@@ -46,9 +46,6 @@ extern int iomem_size;
 
 #define ROUND_4M(n) ((((unsigned long) (n)) + (1 << 22)) & ~((1 << 22) - 1))
 
-extern unsigned long host_task_size;
-extern unsigned long task_size;
-
 extern int init_mem_user(void);
 extern void setup_memory(void *entry);
 extern unsigned long find_iomem(char *driver, unsigned long *len_out);
@@ -62,6 +59,5 @@ extern unsigned long phys_offset(unsigne
 extern void unmap_physmem(void);
 extern void map_memory(unsigned long virt, unsigned long phys,
 		       unsigned long len, int r, int w, int x);
-extern unsigned long get_kmem_end(void);
 
 #endif
Index: linux-2.6.22/arch/um/kernel/exec.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/exec.c	2007-11-16 13:14:39.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/exec.c	2007-11-16 14:39:39.000000000 -0500
@@ -19,7 +19,7 @@
 void flush_thread(void)
 {
 	void *data = NULL;
-	unsigned long end = proc_mm ? task_size : STUB_START;
+	unsigned long end = proc_mm ? TASK_SIZE : STUB_START;
 	int ret;
 
 	arch_flush_thread(&current->thread.arch);
Index: linux-2.6.22/arch/um/kernel/ksyms.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/ksyms.c	2007-11-16 13:21:56.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/ksyms.c	2007-11-16 14:39:39.000000000 -0500
@@ -17,11 +17,8 @@ EXPORT_SYMBOL(set_signals);
 EXPORT_SYMBOL(get_signals);
 EXPORT_SYMBOL(kernel_thread);
 EXPORT_SYMBOL(sys_waitpid);
-EXPORT_SYMBOL(task_size);
 EXPORT_SYMBOL(flush_tlb_range);
-EXPORT_SYMBOL(host_task_size);
 EXPORT_SYMBOL(arch_validate);
-EXPORT_SYMBOL(get_kmem_end);
 
 EXPORT_SYMBOL(high_physmem);
 EXPORT_SYMBOL(empty_zero_page);
Index: linux-2.6.22/arch/um/kernel/physmem.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/physmem.c	2007-11-16 13:14:39.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/physmem.c	2007-11-16 14:39:39.000000000 -0500
@@ -55,16 +55,6 @@ int __init init_maps(unsigned long physm
 	return 0;
 }
 
-/* Changed during early boot */
-static unsigned long kmem_top = 0;
-
-unsigned long get_kmem_end(void)
-{
-	if (kmem_top == 0)
-		kmem_top = host_task_size - 1024 * 1024;
-	return kmem_top;
-}
-
 void map_memory(unsigned long virt, unsigned long phys, unsigned long len,
 		int r, int w, int x)
 {
Index: linux-2.6.22/arch/um/kernel/tlb.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/tlb.c	2007-11-16 13:38:29.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/tlb.c	2007-11-16 14:53:08.000000000 -0500
@@ -511,7 +511,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 	if (atomic_read(&mm->mm_users) == 0)
 		return;
 
-	end = proc_mm ? task_size : STUB_START;
+	end = proc_mm ? TASK_SIZE : STUB_START;
 	fix_range(mm, 0, end, 0);
 }
 
Index: linux-2.6.22/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/um_arch.c	2007-11-16 13:21:55.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/um_arch.c	2007-11-16 14:39:39.000000000 -0500
@@ -101,8 +101,6 @@ const struct seq_operations cpuinfo_op =
 };
 
 /* Set in linux_main */
-unsigned long host_task_size;
-unsigned long task_size;
 unsigned long uml_physmem;
 unsigned long uml_reserved; /* Also modified in mem_init */
 unsigned long start_vm;
@@ -234,20 +232,6 @@ EXPORT_SYMBOL(end_iomem);
 
 extern char __binary_start;
 
-static unsigned long set_task_sizes_skas(unsigned long *task_size_out)
-{
-	/* Round up to the nearest 4M */
-	unsigned long host_task_size = ROUND_4M((unsigned long)
-						&host_task_size);
-
-	if (!skas_needs_stub)
-		*task_size_out = host_task_size;
-	else
-		*task_size_out = STUB_START & PGDIR_MASK;
-
-	return host_task_size;
-}
-
 int __init linux_main(int argc, char **argv)
 {
 	unsigned long avail, diff;
@@ -278,8 +262,6 @@ int __init linux_main(int argc, char **a
 
 	printf("UML running in %s mode\n", mode);
 
-	host_task_size = set_task_sizes_skas(&task_size);
-
 	brk_start = (unsigned long) sbrk(0);
 
 	/*
@@ -304,7 +286,7 @@ int __init linux_main(int argc, char **a
 
 	highmem = 0;
 	iomem_size = (iomem_size + PAGE_SIZE - 1) & PAGE_MASK;
-	max_physmem = get_kmem_end() - uml_physmem - iomem_size - MIN_VMALLOC;
+	max_physmem = CONFIG_TOP_ADDR - uml_physmem - iomem_size - MIN_VMALLOC;
 
 	/*
 	 * Zones have to begin on a 1 << MAX_ORDER page boundary,
@@ -336,7 +318,7 @@ int __init linux_main(int argc, char **a
 	}
 
 	virtmem_size = physmem_size;
-	avail = get_kmem_end() - start_vm;
+	avail = CONFIG_TOP_ADDR - start_vm;
 	if (physmem_size > avail)
 		virtmem_size = avail;
 	end_vm = start_vm + virtmem_size;
Index: linux-2.6.22/include/asm-um/fixmap.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/fixmap.h	2007-11-16 13:51:13.000000000 -0500
+++ linux-2.6.22/include/asm-um/fixmap.h	2007-11-16 14:39:39.000000000 -0500
@@ -56,9 +56,8 @@ extern void __set_fixmap (enum fixed_add
  * the start of the fixmap, and leave one page empty
  * at the top of mem..
  */
-extern unsigned long get_kmem_end(void);
 
-#define FIXADDR_TOP	(get_kmem_end() - 0x2000)
+#define FIXADDR_TOP	(CONFIG_TOP_ADDR - 2 * PAGE_SIZE)
 #define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
 
Index: linux-2.6.22/include/asm-um/processor-generic.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/processor-generic.h	2007-11-16 13:30:15.000000000 -0500
+++ linux-2.6.22/include/asm-um/processor-generic.h	2007-11-16 14:39:39.000000000 -0500
@@ -94,15 +94,14 @@ static inline void mm_copy_segments(stru
 /*
  * User space process size: 3GB (default).
  */
-extern unsigned long task_size;
 extern unsigned long stacksizelim;
-extern unsigned long host_task_size;
 
-#define TASK_SIZE	(task_size)
+#define TASK_SIZE (CONFIG_TOP_ADDR & PGDIR_MASK)
 
 #undef STACK_TOP
 #undef STACK_TOP_MAX
-#define STACK_TOP	TASK_SIZE
+
+#define STACK_TOP (TASK_SIZE - 2 * PAGE_SIZE)
 #define STACK_TOP_MAX	STACK_TOP
 #define STACK_ROOM	(stacksizelim)
 

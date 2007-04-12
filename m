Return-Path: <linux-kernel-owner+w=401wt.eu-S1751122AbXDLQeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbXDLQeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXDLQd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:33:28 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:50719 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbXDLQdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:33:24 -0400
Date: Thu, 12 Apr 2007 12:28:05 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 6/6 ] UML - Speed page fault path
Message-ID: <20070412162805.GA7255@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give the page fault code a specialized path.  There is only one page
to look at, so there's no point in going into the general page table
walking code.  There's only going to be one host operation, so there
are no opportunities for merging.  So, we go straight to the pte we
want, figure out what needs doing, and do it.

While I was in here, I fixed the wart where the address passed to
unmap was a void *, but an unsigned long to map and protect.

This gives me just under 10% on a kernel build.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/os.h                  |    2 -
 arch/um/include/skas/mode_kern_skas.h |    2 +
 arch/um/kernel/skas/tlb.c             |   66 ++++++++++++++++++++++++++++++++--
 arch/um/kernel/tlb.c                  |    4 +-
 arch/um/os-Linux/skas/mem.c           |    4 +-
 5 files changed, 72 insertions(+), 6 deletions(-)

Index: linux-2.6.21-mm/arch/um/include/skas/mode_kern_skas.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/skas/mode_kern_skas.h	2007-04-12 11:34:40.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/skas/mode_kern_skas.h	2007-04-12 11:48:33.000000000 -0400
@@ -33,6 +33,8 @@ extern unsigned long set_task_sizes_skas
 extern int start_uml_skas(void);
 extern int external_pid_skas(struct task_struct *task);
 extern int thread_pid_skas(struct task_struct *task);
+extern void flush_tlb_page_skas(struct vm_area_struct *vma,
+				unsigned long address);
 
 #define kmem_end_skas (host_task_size - 1024 * 1024)
 
Index: linux-2.6.21-mm/arch/um/kernel/skas/tlb.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/skas/tlb.c	2007-04-12 11:34:40.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/skas/tlb.c	2007-04-12 11:48:33.000000000 -0400
@@ -32,8 +32,7 @@ static int do_ops(union mm_context *mmu,
 				  op->u.mmap.offset, finished, flush);
 			break;
 		case MUNMAP:
-			ret = unmap(&mmu->skas.id,
-				    (void *) op->u.munmap.addr,
+			ret = unmap(&mmu->skas.id, op->u.munmap.addr,
 				    op->u.munmap.len, finished, flush);
 			break;
 		case MPROTECT:
@@ -94,3 +93,66 @@ void force_flush_all_skas(void)
 	unsigned long end = proc_mm ? task_size : CONFIG_STUB_START;
         fix_range(current->mm, 0, end, 1);
 }
+
+void flush_tlb_page_skas(struct vm_area_struct *vma, unsigned long address)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	struct mm_struct *mm = vma->vm_mm;
+	void *flush = NULL;
+	int r, w, x, err = 0;
+	struct mm_id *mm_id;
+
+	pgd = pgd_offset(vma->vm_mm, address);
+	if(!pgd_present(*pgd))
+		goto kill;
+
+	pud = pud_offset(pgd, address);
+	if(!pud_present(*pud))
+		goto kill;
+
+	pmd = pmd_offset(pud, address);
+	if(!pmd_present(*pmd))
+		goto kill;
+
+	pte = pte_offset_kernel(pmd, address);
+
+	r = pte_read(*pte);
+	w = pte_write(*pte);
+	x = pte_exec(*pte);
+	if (!pte_young(*pte)) {
+		r = 0;
+		w = 0;
+	} else if (!pte_dirty(*pte)) {
+		w = 0;
+	}
+
+	mm_id = &mm->context.skas.id;
+	if(pte_newpage(*pte)){
+		if(pte_present(*pte)){
+			unsigned long long offset;
+			int fd;
+
+			fd = phys_mapping(pte_val(*pte) & PAGE_MASK, &offset);
+			err = map(mm_id, address, PAGE_SIZE, r, w, x, fd,
+				  offset, 1, &flush);
+		}
+		else err = unmap(mm_id, address, PAGE_SIZE, 1, &flush);
+	}
+	else if(pte_newprot(*pte))
+		err = protect(mm_id, address, PAGE_SIZE, r, w, x, 1, &flush);
+
+	if(err)
+		goto kill;
+
+	*pte = pte_mkuptodate(*pte);
+
+	return;
+
+kill:
+	printk("Failed to flush page for address 0x%lx\n", address);
+	force_sig(SIGKILL, current);
+}
+
Index: linux-2.6.21-mm/arch/um/kernel/tlb.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tlb.c	2007-04-12 11:46:27.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tlb.c	2007-04-12 11:48:33.000000000 -0400
@@ -380,7 +380,9 @@ pte_t *addr_pte(struct task_struct *task
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long address)
 {
 	address &= PAGE_MASK;
-	flush_tlb_range(vma, address, address + PAGE_SIZE);
+
+	CHOOSE_MODE(flush_tlb_range(vma, address, address + PAGE_SIZE),
+		    flush_tlb_page_skas(vma, address));
 }
 
 void flush_tlb_all(void)
Index: linux-2.6.21-mm/arch/um/include/os.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/os.h	2007-04-12 11:38:51.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/os.h	2007-04-12 11:48:33.000000000 -0400
@@ -302,7 +302,7 @@ extern long syscall_stub_data(struct mm_
 extern int map(struct mm_id * mm_idp, unsigned long virt,
 	       unsigned long len, int r, int w, int x, int phys_fd,
 	       unsigned long long offset, int done, void **data);
-extern int unmap(struct mm_id * mm_idp, void *addr, unsigned long len,
+extern int unmap(struct mm_id * mm_idp, unsigned long addr, unsigned long len,
 		 int done, void **data);
 extern int protect(struct mm_id * mm_idp, unsigned long addr,
 		   unsigned long len, int r, int w, int x, int done,
Index: linux-2.6.21-mm/arch/um/os-Linux/skas/mem.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/skas/mem.c	2007-04-12 11:34:40.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/skas/mem.c	2007-04-12 11:48:33.000000000 -0400
@@ -219,8 +219,8 @@ int map(struct mm_id * mm_idp, unsigned 
 	return ret;
 }
 
-int unmap(struct mm_id * mm_idp, void *addr, unsigned long len, int done,
-	  void **data)
+int unmap(struct mm_id * mm_idp, unsigned long addr, unsigned long len,
+	  int done, void **data)
 {
 	int ret;
 

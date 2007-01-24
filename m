Return-Path: <linux-kernel-owner+w=401wt.eu-S1750978AbXAXK1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbXAXK1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 05:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbXAXK1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 05:27:00 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:49108 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbXAXK07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 05:26:59 -0500
Date: Wed, 24 Jan 2007 19:25:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] Fix CONFIG_COMPAT_VDSO
Message-ID: <20070124102520.GA25174@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
	linux-kernel@vger.kernel.org
References: <20070117084947.GA19093@elte.hu> <20070117090334.5B6EB1800E8@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070117090334.5B6EB1800E8@magilla.sf.frob.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 17, 2007 at 01:03:34AM -0800, Roland McGrath wrote:
> > i think your patches #1...#7 are must-haves for v2.6.20, while #8-#11 
> > could be delayed to v2.6.21?
> 
> Indeed 1-7 are fixes while 8-11 are only cleanups not changing behavior.
> 
Here's an update for the SH bits when the 8-11 parts are ready..

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

diff --git a/arch/sh/kernel/vsyscall/vsyscall.c b/arch/sh/kernel/vsyscall/vsyscall.c
index deb4694..7b0f66f 100644
--- a/arch/sh/kernel/vsyscall/vsyscall.c
+++ b/arch/sh/kernel/vsyscall/vsyscall.c
@@ -37,11 +37,12 @@ __setup("vdso=", vdso_setup);
  * of the ELF DSO images included therein.
  */
 extern const char vsyscall_trapa_start, vsyscall_trapa_end;
-static void *syscall_page;
+static struct page *syscall_pages[1];
 
 int __init vsyscall_init(void)
 {
-	syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	syscall_pages[0] = virt_to_page(syscall_page);
 
 	/*
 	 * XXX: Map this page to a fixmap entry if we get around
@@ -55,37 +56,10 @@ int __init vsyscall_init(void)
 	return 0;
 }
 
-static struct page *syscall_vma_nopage(struct vm_area_struct *vma,
-				       unsigned long address, int *type)
-{
-	unsigned long offset = address - vma->vm_start;
-	struct page *page;
-
-	if (address < vma->vm_start || address > vma->vm_end)
-		return NOPAGE_SIGBUS;
-
-	page = virt_to_page(syscall_page + offset);
-
-	get_page(page);
-
-	return page;
-}
-
-/* Prevent VMA merging */
-static void syscall_vma_close(struct vm_area_struct *vma)
-{
-}
-
-static struct vm_operations_struct syscall_vm_ops = {
-	.nopage	= syscall_vma_nopage,
-	.close	= syscall_vma_close,
-};
-
 /* Setup a VMA at program startup for the vsyscall page */
 int arch_setup_additional_pages(struct linux_binprm *bprm,
 				int executable_stack)
 {
-	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
 	int ret;
@@ -97,30 +71,16 @@ int arch_setup_additional_pages(struct l
 		goto up_fail;
 	}
 
-	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
-	if (!vma) {
-		ret = -ENOMEM;
+	ret = install_special_mapping(mm, addr, PAGE_SIZE,
+				      VM_READ | VM_EXEC |
+				      VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC |
+				      VM_ALWAYSDUMP,
+				      syscall_pages);
+	if (unlikely(ret))
 		goto up_fail;
-	}
-
-	vma->vm_start = addr;
-	vma->vm_end = addr + PAGE_SIZE;
-	/* MAYWRITE to allow gdb to COW and set breakpoints */
-	vma->vm_flags = VM_READ|VM_EXEC|VM_MAYREAD|VM_MAYEXEC|VM_MAYWRITE;
-	vma->vm_flags |= mm->def_flags;
-	vma->vm_page_prot = protection_map[vma->vm_flags & 7];
-	vma->vm_ops = &syscall_vm_ops;
-	vma->vm_mm = mm;
-
-	ret = insert_vm_struct(mm, vma);
-	if (unlikely(ret)) {
-		kmem_cache_free(vm_area_cachep, vma);
-		goto up_fail;
-	}
 
 	current->mm->context.vdso = (void *)addr;
 
-	mm->total_vm++;
 up_fail:
 	up_write(&mm->mmap_sem);
 	return ret;

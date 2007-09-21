Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbXIURb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbXIURb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbXIURbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:31:19 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:37030 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbXIURbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:31:17 -0400
Date: Fri, 21 Sep 2007 18:30:35 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Coly Li <coyli@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use VM_READ/WRITE/EXEC to set vm_page_prot
In-Reply-To: <46DAF511.6030406@suse.de>
Message-ID: <Pine.LNX.4.64.0709211815440.23588@blonde.wat.veritas.com>
References: <46DAF511.6030406@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Sep 2007, Coly Li wrote:

> When setup vm_page_prot, some code use 0x7 instead of  (VM_READ|VM_WRITE|VM_EXEC). It does works
> well, but it will be better if we use the VM_READ/WRITE/EXEC MACRO :-)
> 
> This patch uses (VM_READ|VM_WRITE|VM_EXEC) to replace 0x7 in vm_page_prot setup.
> 
> Signed-Off-By: Coly Li <coyli@suse.de>

You patch (now in -mm as use-vm_read-write-exec-to-set-vm_page_prot.patch)
looks good to me, thank you.  But could I persuade you to make it even
better, by instead using the vm_get_page_prot() function Dave Airlie
added some while back?

I did some work on that back in 2.6.18 days, but never got around to
sending it off.  It may be all wrong, or missing pieces, by now; but
appended below in case it helps.  If you don't mind, please update
it and send in the result as yours.  If you do mind, please say so
and I'll do it myself - but we can see it's taken me an age, and
it'd also be very rude for me to stomp on your good work.

Thanks,
Hugh

> 
> diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
> index c14abef..864a9f3 100644
> --- a/arch/ia64/mm/init.c
> +++ b/arch/ia64/mm/init.c
> @@ -130,7 +130,8 @@ ia64_init_addr_space (void)
>  		vma->vm_mm = current->mm;
>  		vma->vm_start = current->thread.rbs_bot & PAGE_MASK;
>  		vma->vm_end = vma->vm_start + PAGE_SIZE;
> -		vma->vm_page_prot = protection_map[VM_DATA_DEFAULT_FLAGS & 0x7];
> +		vma->vm_page_prot = protection_map[VM_DATA_DEFAULT_FLAGS &
> +					(VM_READ|VM_WRITE|VM_EXEC)];
>  		vma->vm_flags = VM_DATA_DEFAULT_FLAGS|VM_GROWSUP|VM_ACCOUNT;
>  		down_write(&current->mm->mmap_sem);
>  		if (insert_vm_struct(current->mm, vma)) {
> diff --git a/fs/exec.c b/fs/exec.c
> index c21a8cc..cca277f 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -261,7 +261,8 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
>  	vma->vm_start = vma->vm_end - PAGE_SIZE;
> 
>  	vma->vm_flags = VM_STACK_FLAGS;
> -	vma->vm_page_prot = protection_map[vma->vm_flags & 0x7];
> +	vma->vm_page_prot = protection_map[vma->vm_flags &
> +				(VM_READ|VM_WRITE|VM_EXEC)];
>  	err = insert_vm_struct(mm, vma);
>  	if (err) {
>  		up_write(&mm->mmap_sem);
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 0d40e66..18d33f2 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2210,7 +2210,8 @@ int install_special_mapping(struct mm_struct *mm,
>  	vma->vm_end = addr + len;
> 
>  	vma->vm_flags = vm_flags | mm->def_flags;
> -	vma->vm_page_prot = protection_map[vma->vm_flags & 7];
> +	vma->vm_page_prot = protection_map[vma->vm_flags &
> +				(VM_READ|VM_WRITE|VM_EXEC)];
> 
>  	vma->vm_ops = &special_mapping_vmops;
>  	vma->vm_private_data = pages;

--- 2.6.18-rc2-git6/arch/i386/kernel/sysenter.c	2006-07-16 00:16:57.000000000 +0100
+++ linux/arch/i386/kernel/sysenter.c	2006-07-26 20:58:50.000000000 +0100
@@ -143,7 +143,7 @@ int arch_setup_additional_pages(struct l
 	/* MAYWRITE to allow gdb to COW and set breakpoints */
 	vma->vm_flags = VM_READ|VM_EXEC|VM_MAYREAD|VM_MAYEXEC|VM_MAYWRITE;
 	vma->vm_flags |= mm->def_flags;
-	vma->vm_page_prot = protection_map[vma->vm_flags & 7];
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	vma->vm_ops = &syscall_vm_ops;
 	vma->vm_mm = mm;
 
--- 2.6.18-rc2-git6/arch/ia64/mm/init.c	2006-07-16 00:16:58.000000000 +0100
+++ linux/arch/ia64/mm/init.c	2006-07-26 20:57:57.000000000 +0100
@@ -162,8 +162,8 @@ ia64_init_addr_space (void)
 		vma->vm_mm = current->mm;
 		vma->vm_start = current->thread.rbs_bot & PAGE_MASK;
 		vma->vm_end = vma->vm_start + PAGE_SIZE;
-		vma->vm_page_prot = protection_map[VM_DATA_DEFAULT_FLAGS & 0x7];
 		vma->vm_flags = VM_DATA_DEFAULT_FLAGS|VM_GROWSUP|VM_ACCOUNT;
+		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 		down_write(&current->mm->mmap_sem);
 		if (insert_vm_struct(current->mm, vma)) {
 			up_write(&current->mm->mmap_sem);
--- 2.6.18-rc2-git6/arch/powerpc/kernel/vdso.c	2006-07-16 00:17:00.000000000 +0100
+++ linux/arch/powerpc/kernel/vdso.c	2006-07-26 20:55:36.000000000 +0100
@@ -283,7 +283,7 @@ int arch_setup_additional_pages(struct l
 	 */
 	vma->vm_flags = VM_READ|VM_EXEC|VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC;
 	vma->vm_flags |= mm->def_flags;
-	vma->vm_page_prot = protection_map[vma->vm_flags & 0x7];
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	vma->vm_ops = &vdso_vmops;
 
 	/* Insert new VMA */
--- 2.6.18-rc2-git6/arch/x86_64/ia32/syscall32.c	2005-10-28 01:02:08.000000000 +0100
+++ linux/arch/x86_64/ia32/syscall32.c	2006-07-26 20:54:18.000000000 +0100
@@ -60,7 +60,7 @@ int syscall32_setup_pages(struct linux_b
 	/* MAYWRITE to allow gdb to COW and set breakpoints */
 	vma->vm_flags = VM_READ|VM_EXEC|VM_MAYREAD|VM_MAYEXEC|VM_MAYWRITE;
 	vma->vm_flags |= mm->def_flags;
-	vma->vm_page_prot = protection_map[vma->vm_flags & 7];
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	vma->vm_ops = &syscall32_vm_ops;
 	vma->vm_mm = mm;
 
--- 2.6.18-rc2-git6/fs/exec.c	2006-07-16 00:17:22.000000000 +0100
+++ linux/fs/exec.c	2006-07-26 20:51:34.000000000 +0100
@@ -430,7 +430,7 @@ int setup_arg_pages(struct linux_binprm 
 		else
 			mpnt->vm_flags = VM_STACK_FLAGS;
 		mpnt->vm_flags |= mm->def_flags;
-		mpnt->vm_page_prot = protection_map[mpnt->vm_flags & 0x7];
+		mpnt->vm_page_prot = vm_get_page_prot(mpnt->vm_flags);
 		if ((ret = insert_vm_struct(mm, mpnt))) {
 			up_write(&mm->mmap_sem);
 			kmem_cache_free(vm_area_cachep, mpnt);
--- 2.6.18-rc2-git6/mm/mmap.c	2006-07-16 00:17:39.000000000 +0100
+++ linux/mm/mmap.c	2006-07-26 20:40:12.000000000 +0100
@@ -1065,8 +1072,7 @@ munmap_back:
 	vma->vm_start = addr;
 	vma->vm_end = addr + len;
 	vma->vm_flags = vm_flags;
-	vma->vm_page_prot = protection_map[vm_flags &
-				(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
+	vma->vm_page_prot = vm_get_page_prot(vm_flags);
 	vma->vm_pgoff = pgoff;
 
 	if (file) {
@@ -1093,8 +1099,7 @@ munmap_back:
 	/* Don't make the VMA automatically writable if it's shared, but the
 	 * backer wishes to know when pages are first written to */
 	if (vma->vm_ops && vma->vm_ops->page_mkwrite)
-		vma->vm_page_prot =
-			protection_map[vm_flags & (VM_READ|VM_WRITE|VM_EXEC)];
+		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
 
 	/* We set VM_ACCOUNT in a shared mapping's vm_flags, to inform
 	 * shmem_zero_setup (perhaps called through /dev/zero's ->mmap)
@@ -1928,8 +1933,7 @@ unsigned long do_brk(unsigned long addr,
 	vma->vm_end = addr + len;
 	vma->vm_pgoff = pgoff;
 	vma->vm_flags = flags;
-	vma->vm_page_prot = protection_map[flags &
-				(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
+	vma->vm_page_prot = vm_get_page_prot(flags);
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 out:
 	mm->total_vm += len >> PAGE_SHIFT;
--- 2.6.18-rc2-git6/mm/mprotect.c	2006-07-16 00:17:39.000000000 +0100
+++ linux/mm/mprotect.c	2006-07-26 20:48:07.000000000 +0100
@@ -178,11 +178,10 @@ mprotect_fixup(struct vm_area_struct *vm
 success:
 	/* Don't make the VMA automatically writable if it's shared, but the
 	 * backer wishes to know when pages are first written to */
-	mask = VM_READ|VM_WRITE|VM_EXEC|VM_SHARED;
+	mask = 0;
 	if (vma->vm_ops && vma->vm_ops->page_mkwrite)
-		mask &= ~VM_SHARED;
-
-	newprot = protection_map[newflags & mask];
+		mask = VM_SHARED;
+	newprot = vm_get_page_prot(newflags & ~mask);
 
 	/*
 	 * vm_flags and vm_page_prot are protected by the mmap_sem

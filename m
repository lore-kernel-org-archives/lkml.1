Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbYD2SK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbYD2SK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYD2SKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:10:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366AbYD2SKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:10:10 -0400
Date: Tue, 29 Apr 2008 11:09:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, ajackson@redhat.com, airlied@redhat.com,
       benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] make access_process_vm work on device memory
Message-Id: <20080429110919.dc7b8565.akpm@linux-foundation.org>
In-Reply-To: <20080429113237.614f89a1@cuia.boston.redhat.com>
References: <20080429113237.614f89a1@cuia.boston.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 11:32:37 -0400
Rik van Riel <riel@redhat.com> wrote:

> Make access_process_vm work on VM_IO or VM_PFNMAP VMAs.  This allows ptrace
> and /proc/pid/mem access to work on eg. video card memory mapped by the X
> server and lays the groundwork for gdb support for PPC Cell SPU memory.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Benjamin Herrensmidt <benh@kernel.crashing.org>
> 
> --- 
> 
>  arch/x86/mm/ioremap.c   |    8 ++
>  include/asm-x86/io_32.h |    3 +
>  include/asm-x86/io_64.h |    3 +
>  include/linux/mm.h      |    6 ++
>  mm/memory.c             |  134 +++++++++++++++++++++++++++++++++++++++++-------

I'll consider this an MM patch, to be mastered in -mm.  If agreeable, x86
review-and-acks would be nice, please.

> 
> Index: linux-2.6.25-mm1/mm/memory.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/mm/memory.c	2008-04-27 11:06:04.000000000 -0400
> +++ linux-2.6.25-mm1/mm/memory.c	2008-04-29 00:52:01.000000000 -0400
> @@ -2720,6 +2720,86 @@ int in_gate_area_no_task(unsigned long a
>  
>  #endif	/* __HAVE_ARCH_GATE_AREA */
>  
> +#ifdef _HAVE_ARCH_IOREMAP_PROT

urgh.

We have HAVE_ARCH*
We have __HAVE_ARCH*
We have ARCH_HAS*
We have __ARCH_HAS*

what a mess.

Probably the preferred (but still ugly) approach is to implement
CONFIG_ARCH_*.

> +static resource_size_t follow_phys(struct vm_area_struct *vma,
> +			unsigned long address, unsigned int flags,
> +			unsigned long *prot)
> +{
> +	pgd_t *pgd;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +	pte_t *ptep, pte;
> +	spinlock_t *ptl;
> +	resource_size_t phys_addr = 0;
> +	struct mm_struct *mm = vma->vm_mm;
> +
> +	VM_BUG_ON(!(vma->vm_flags & (VM_IO | VM_PFNMAP)));
> +
> +	pgd = pgd_offset(mm, address);
> +	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
> +		goto no_page_table;
> +
> +	pud = pud_offset(pgd, address);
> +	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
> +		goto no_page_table;
> +
> +	pmd = pmd_offset(pud, address);
> +	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
> +		goto no_page_table;
> +
> +	/* We cannot handle huge page PFN maps. Luckily they don't exist. */
> +	if (pmd_huge(*pmd))
> +		goto no_page_table;
> +
> +	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
> +	if (!ptep)
> +		goto out;

hm, more copy-n-paste.

> +	pte = *ptep;
> +	if (!pte_present(pte))
> +		goto unlock;
> +	if ((flags & FOLL_WRITE) && !pte_write(pte))
> +		goto unlock;
> +	phys_addr = pte_pfn(pte);
> +	phys_addr <<= PAGE_SHIFT; /* Shift here to avoid overflow on PAE? */

That comment betrays a lack of confidence ;)

What's the score here?

> +	*prot = pgprot_val(pte_pgprot(pte));
> +
> +unlock:
> +	pte_unmap_unlock(ptep, ptl);
> +out:
> +	return phys_addr;
> +no_page_table:
> +	return 0;
> +}
> +
> +int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
> +			void *buf, int len, int write)
> +{
> +	resource_size_t phys_addr;
> +	unsigned long prot = 0;
> +	void *maddr;
> +	int offset = addr & (PAGE_SIZE-1);
> +
> +	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> +		return -EINVAL;
> +
> +	phys_addr = follow_phys(vma, addr, write, &prot);
> +
> +	if (!phys_addr)
> +		return -EINVAL;
> +
> +	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
> +	if (write)
> +		memcpy_toio(maddr + offset, buf, len);
> +	else
> +		memcpy_fromio(buf, maddr + offset, len);
> +	iounmap(maddr);
> +
> +	return len;
> +}
> +#endif
> +
>  /*
>   * Access another process' address space.
>   * Source/target buffer must be kernel space,
> @@ -2729,7 +2809,6 @@ int access_process_vm(struct task_struct
>  {
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
> -	struct page *page;
>  	void *old_buf = buf;
>  
>  	mm = get_task_mm(tsk);
> @@ -2741,28 +2820,47 @@ int access_process_vm(struct task_struct
>  	while (len) {
>  		int bytes, ret, offset;
>  		void *maddr;
> +		struct page *page = NULL;
>  
>  		ret = get_user_pages(tsk, mm, addr, 1,
>  				write, 1, &page, &vma);
> -		if (ret <= 0)
> -			break;
> -
> -		bytes = len;
> -		offset = addr & (PAGE_SIZE-1);
> -		if (bytes > PAGE_SIZE-offset)
> -			bytes = PAGE_SIZE-offset;
> -
> -		maddr = kmap(page);
> -		if (write) {
> -			copy_to_user_page(vma, page, addr,
> -					  maddr + offset, buf, bytes);
> -			set_page_dirty_lock(page);
> +		if (ret <= 0) {
> +			/*
> +			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
> +			 * we can access using slightly different code.
> +			 */
> +#ifdef _HAVE_ARCH_IOREMAP_PROT
> +			vma = find_vma(mm, addr);
> +			if (!vma)
> +				break;
> +			if (vma->vm_ops && vma->vm_ops->access)
> +				ret = vma->vm_ops->access(vma, addr, buf,
> +							  len, write);
> +			else
> +				ret = generic_access_phys(vma, addr, buf,
> +							  len, write);

Should we do it this way, or should we ensure that all suitable vmas have
set their ->vm_ops->access to generic_access_phys()?


> +			if (ret <= 0)
> +#endif
> +				break;
> +			bytes = ret;
>  		} else {
> -			copy_from_user_page(vma, page, addr,
> -					    buf, maddr + offset, bytes);
> +			bytes = len;
> +			offset = addr & (PAGE_SIZE-1);
> +			if (bytes > PAGE_SIZE-offset)
> +				bytes = PAGE_SIZE-offset;
> +
> +			maddr = kmap(page);
> +			if (write) {
> +				copy_to_user_page(vma, page, addr,
> +						  maddr + offset, buf, bytes);
> +				set_page_dirty_lock(page);
> +			} else {
> +				copy_from_user_page(vma, page, addr,
> +						    buf, maddr + offset, bytes);
> +			}
> +			kunmap(page);
> +			page_cache_release(page);
>  		}
> -		kunmap(page);
> -		page_cache_release(page);
>  		len -= bytes;
>  		buf += bytes;
>  		addr += bytes;
> Index: linux-2.6.25-mm1/arch/x86/mm/ioremap.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/arch/x86/mm/ioremap.c	2008-04-22 10:33:42.000000000 -0400
> +++ linux-2.6.25-mm1/arch/x86/mm/ioremap.c	2008-04-28 22:06:08.000000000 -0400
> @@ -287,6 +287,14 @@ void __iomem *ioremap_cache(resource_siz
>  }
>  EXPORT_SYMBOL(ioremap_cache);
>  
> +void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
> +				unsigned long prot_val)
> +{
> +	return __ioremap_caller(phys_addr, size, (prot_val & _PAGE_CACHE_MASK),
> +				__builtin_return_address(0));
> +}
> +EXPORT_SYMBOL(ioremap_prot);
> +
>  /**
>   * iounmap - Free a IO remapping
>   * @addr: virtual address from ioremap_*
> Index: linux-2.6.25-mm1/include/asm-x86/io_32.h
> ===================================================================
> --- linux-2.6.25-mm1.orig/include/asm-x86/io_32.h	2008-04-22 10:33:44.000000000 -0400
> +++ linux-2.6.25-mm1/include/asm-x86/io_32.h	2008-04-28 21:38:03.000000000 -0400
> @@ -110,6 +110,9 @@ static inline void *phys_to_virt(unsigne
>   */
>  extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
>  extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
> +extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
> +				unsigned long prot_val);
> +#define _HAVE_ARCH_IOREMAP_PROT
>  
>  /*
>   * The default ioremap() behavior is non-cached:
> Index: linux-2.6.25-mm1/include/asm-x86/io_64.h
> ===================================================================
> --- linux-2.6.25-mm1.orig/include/asm-x86/io_64.h	2008-04-22 10:33:44.000000000 -0400
> +++ linux-2.6.25-mm1/include/asm-x86/io_64.h	2008-04-28 21:37:42.000000000 -0400
> @@ -175,6 +175,9 @@ extern void early_iounmap(void *addr, un
>   */
>  extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
>  extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
> +extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
> +				unsigned long prot_val);
> +#define _HAVE_ARCH_IOREMAP_PROT

I expect that any architecture which implements ioremap_prot() will have to
implement it with the same signature, yes?

So perhaps the declaration should be placed in include/linux/io.h.
 
>  /*
>   * The default ioremap() behavior is non-cached:
> Index: linux-2.6.25-mm1/include/linux/mm.h
> ===================================================================
> --- linux-2.6.25-mm1.orig/include/linux/mm.h	2008-04-27 11:06:04.000000000 -0400
> +++ linux-2.6.25-mm1/include/linux/mm.h	2008-04-28 22:01:26.000000000 -0400
> @@ -171,6 +171,12 @@ struct vm_operations_struct {
>  	/* notification that a previously read-only page is about to become
>  	 * writable, if an error is returned it will cause a SIGBUS */
>  	int (*page_mkwrite)(struct vm_area_struct *vma, struct page *page);
> +
> +	/* called by access_process_vm when get_user_pages() fails, typically
> +	 * for use by special VMAs that can switch between memory and hardware
> +	 */
> +	int (*access)(struct vm_area_struct *vma, unsigned long addr,
> +		      void *buf, int len, int write);
>  #ifdef CONFIG_NUMA
>  	/*
>  	 * set_policy() op must add a reference to any non-NULL @new mempolicy


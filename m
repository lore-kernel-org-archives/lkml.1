Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbXLFTrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbXLFTrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbXLFTrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:47:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46319 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbXLFTrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:47:11 -0500
Date: Thu, 6 Dec 2007 11:46:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/6] UML - Customize tlb.h
Message-Id: <20071206114642.555a0749.akpm@linux-foundation.org>
In-Reply-To: <20071206170640.GA7420@c2.user-mode-linux.org>
References: <20071206170640.GA7420@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 12:06:40 -0500
Jeff Dike <jdike@addtoit.com> wrote:

> Customize the hooks in tlb.h to optimize TLB flushing some more.
> 
> Add start and end fields to tlb_gather_mmu, which are used to limit
> the address space range scanned when a region is unmapped.
> 
> The interfaces which just free page tables, without actually changing
> mappings, don't need to cause a TLB flush.
> 
> ...
>
> +void flush_tlb_mm(struct mm_struct *mm)
> +{
> +	struct vm_area_struct *vma = mm->mmap;
> +
> +	if (atomic_read(&mm->mm_users) == 0)
> +		return;

Under which circumstances does this test succeed?

> +	while (vma != NULL) {
> +		fix_range(mm, vma->vm_start, vma->vm_end, 0);
> +		vma = vma->vm_next;
> +	}
>  }
>  
>  void force_flush_all(void)
> Index: linux-2.6-git/include/asm-um/tlb.h
> ===================================================================
> --- linux-2.6-git.orig/include/asm-um/tlb.h	2007-12-06 10:34:31.000000000 -0500
> +++ linux-2.6-git/include/asm-um/tlb.h	2007-12-06 10:58:34.000000000 -0500
> @@ -1,6 +1,125 @@
>  #ifndef __UM_TLB_H
>  #define __UM_TLB_H
>  
> -#include <asm/arch/tlb.h>
> +#include <linux/swap.h>
> +#include <asm/pgalloc.h>
> +#include <asm/tlbflush.h>
> +
> +#define tlb_start_vma(tlb, vma) do { } while (0)
> +#define tlb_end_vma(tlb, vma) do { } while (0)
> +#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
> +
> +/* struct mmu_gather is an opaque type used by the mm code for passing around
> + * any data needed by arch specific code for tlb_remove_page.
> + */
> +struct mmu_gather {
> +	struct mm_struct	*mm;
> +	unsigned int		need_flush; /* Really unmapped some ptes? */
> +	unsigned long		start;
> +	unsigned long		end;
> +	unsigned int		fullmm; /* non-zero means full mm flush */
> +};
> +
> +/* Users of the generic TLB shootdown code must declare this storage space. */
> +DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
> +
> +static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep,
> +					  unsigned long address)
> +{
> +	if (tlb->start > address)
> +		tlb->start = address;
> +	if (tlb->end < address + PAGE_SIZE)
> +		tlb->end = address + PAGE_SIZE;
> +}
> +
> +static inline void init_tlb_gather(struct mmu_gather *tlb)
> +{
> +	tlb->need_flush = 0;
> +
> +	tlb->start = TASK_SIZE;
> +	tlb->end = 0;
> +
> +	if (tlb->fullmm) {
> +		tlb->start = 0;
> +		tlb->end = TASK_SIZE;
> +	}
> +}
> +
> +/* tlb_gather_mmu
> + *	Return a pointer to an initialized struct mmu_gather.
> + */
> +static inline struct mmu_gather *
> +tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
> +{
> +	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
> +
> +	tlb->mm = mm;
> +	tlb->fullmm = full_mm_flush;
> +
> +	init_tlb_gather(tlb);
> +
> +	return tlb;
> +}

This file rather needs an inclusion of percpu.h.  I guess you got lucky.



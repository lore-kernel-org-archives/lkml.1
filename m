Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbZCMQZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbZCMQZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbZCMQZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:25:36 -0400
Received: from mail.suse.de ([195.135.220.2]:43132 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbZCMQZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:25:35 -0400
Date: Fri, 13 Mar 2009 17:25:30 +0100
From: Nick Piggin <npiggin@suse.de>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, elendil@planet.nl, thellstrom@vmware.com,
       ebiederm@xmission.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] VM, x86, PAT: Change is_linear_pfn_mapping to not use vm_pgoff
Message-ID: <20090313162530.GA7118@wotan.suse.de>
References: <20090313004527.GA7176@linux-os.sc.intel.com> <tip-4bb9c5c02153dfc89a6c73a6f32091413805ad7d@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-4bb9c5c02153dfc89a6c73a6f32091413805ad7d@git.kernel.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 04:03:39AM +0000, Pallipadi, Venkatesh wrote:
> Commit-ID:  4bb9c5c02153dfc89a6c73a6f32091413805ad7d
> Gitweb:     http://git.kernel.org/tip/4bb9c5c02153dfc89a6c73a6f32091413805ad7d
> Author:     Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> AuthorDate: Thu, 12 Mar 2009 17:45:27 -0700
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 13 Mar 2009 04:28:50 +0100
> 
> VM, x86, PAT: Change is_linear_pfn_mapping to not use vm_pgoff
> 
> Impact: fix false positive PAT warnings - also fix VirtalBox hang
> 
> Use of vma->vm_pgoff to identify the pfnmaps that are fully
> mapped at mmap time is broken. vm_pgoff is set by generic mmap
> code even for cases where drivers are setting up the mappings
> at the fault time.
> 
> The problem was originally reported here:
> 
>  http://marc.info/?l=linux-kernel&m=123383810628583&w=2
> 
> Change is_linear_pfn_mapping logic to overload VM_INSERTPAGE
> flag along with VM_PFNMAP to mean full PFNMAP setup at mmap
> time.
> 
> Problem also tracked at:
> 
>  http://bugzilla.kernel.org/show_bug.cgi?id=12800
> 
> Reported-by: Thomas Hellstrom <thellstrom@vmware.com>
> Tested-by: Frans Pop <elendil@planet.nl>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha>@intel.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: "ebiederm@xmission.com" <ebiederm@xmission.com>
> Cc: <stable@kernel.org> # only for 2.6.29.1, not .28
> LKML-Reference: <20090313004527.GA7176@linux-os.sc.intel.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/mm/pat.c  |    5 +++--
>  include/linux/mm.h |   15 +++++++++++++--
>  mm/memory.c        |    6 ++++--
>  3 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index e0ab173..21bc1f7 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -641,10 +641,11 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
>  	is_ram = pat_pagerange_is_ram(paddr, paddr + size);
>  
>  	/*
> -	 * reserve_pfn_range() doesn't support RAM pages.
> +	 * reserve_pfn_range() doesn't support RAM pages. Maintain the current
> +	 * behavior with RAM pages by returning success.
>  	 */
>  	if (is_ram != 0)
> -		return -EINVAL;
> +		return 0;
>  
>  	ret = reserve_memtype(paddr, paddr + size, want_flags, &flags);
>  	if (ret)
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 065cdf8..3daa05f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -98,7 +98,7 @@ extern unsigned int kobjsize(const void *objp);
>  #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
>  #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
>  #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
> -#define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
> +#define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it. Refer note in VM_PFNMAP_AT_MMAP below */
>  #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
>  
>  #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
> @@ -127,6 +127,17 @@ extern unsigned int kobjsize(const void *objp);
>  #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_RESERVED | VM_PFNMAP)
>  
>  /*
> + * pfnmap vmas that are fully mapped at mmap time (not mapped on fault).
> + * Used by x86 PAT to identify such PFNMAP mappings and optimize their handling.
> + * Note VM_INSERTPAGE flag is overloaded here. i.e,
> + * VM_INSERTPAGE && !VM_PFNMAP implies
> + *     The vma has had "vm_insert_page()" done on it
> + * VM_INSERTPAGE && VM_PFNMAP implies
> + *     The vma is PFNMAP with full mapping at mmap time
> + */
> +#define VM_PFNMAP_AT_MMAP (VM_INSERTPAGE | VM_PFNMAP)

This is really ugly IMO. Either it should be its own bit, or if you want
to reduce usage of bits, then set aside some bits to represent a set of
vma types, and convert existing code over to use that. 

Why not just use another vm_flag for 2.6.29 and earlier (we have 2 left),
then do some flag rationalisation in 2.6.30?

But I do like just avoiding these games entirely and encoding it
explicitly.


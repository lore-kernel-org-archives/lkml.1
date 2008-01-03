Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbYACG2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbYACG2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 01:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbYACG2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 01:28:38 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:42818 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbYACG2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 01:28:38 -0500
Message-ID: <477C808B.9080704@cosmosbay.com>
Date: Thu, 03 Jan 2008 07:28:27 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [20/20] x86: Print which shared library/executable faulted
 in segfault etc. messages
References: <20080103149.088038000@suse.de> <20080103005016.4DA4C14D40@wotan.suse.de>
In-Reply-To: <20080103005016.4DA4C14D40@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 03 Jan 2008 07:28:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> They now look like
> 
> hal-resmgr[13791]: segfault at 3c rip 2b9c8caec182 rsp 7fff1e825d30 error 4 in libacl.so.1.1.0[2b9c8caea000+6000]
> 
> This makes it easier to pinpoint bugs to specific libraries. 
> 
> And printing the offset into a mapping also always allows to find the 
> correct fault point in a library even with randomized mappings. Previously
> there was no way to actually find the correct code address inside
> the randomized mapping.
> 
> Relies on earlier patch to shorten the printk formats.
> 
> They are often now longer than 80 characters, but I think that's worth 
> it.
> 
> Patch for i386 and x86-64.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/kernel/signal_32.c |    7 +++++--
>  arch/x86/kernel/signal_64.c |    7 +++++--
>  arch/x86/kernel/traps_32.c  |    7 +++++--
>  arch/x86/mm/fault_32.c      |    4 +++-
>  include/linux/mm.h          |    1 +
>  mm/memory.c                 |   27 +++++++++++++++++++++++++++
>  6 files changed, 46 insertions(+), 7 deletions(-)
> 
> Index: linux/include/linux/mm.h
> ===================================================================
> --- linux.orig/include/linux/mm.h
> +++ linux/include/linux/mm.h
> @@ -1145,6 +1145,7 @@ extern int randomize_va_space;
>  #endif
>  
>  const char * arch_vma_name(struct vm_area_struct *vma);
> +void print_vma_addr(char *prefix, unsigned long rip);
>  
>  struct page *sparse_mem_map_populate(unsigned long pnum, int nid);
>  pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
> Index: linux/mm/memory.c
> ===================================================================
> --- linux.orig/mm/memory.c
> +++ linux/mm/memory.c
> @@ -2746,3 +2746,30 @@ int access_process_vm(struct task_struct
>  
>  	return buf - old_buf;
>  }
> +
> +/*
> + * Print the name of a VMA.
> + */
> +void print_vma_addr(char *prefix, unsigned long ip)
> +{
> +	struct mm_struct *mm = current->mm;
> +	struct vm_area_struct *vma;
> +	down_read(&mm->mmap_sem);
> +	vma = find_vma(mm, ip);
> +	if (vma && vma->vm_file) {
> +		struct file *f = vma->vm_file;
> +		char *buf = (char *)__get_free_page(GFP_KERNEL);
> +		if (buf) {
> +			char *p, *s;
> +			p = d_path(f->f_dentry, f->f_vfsmnt, buf, PAGE_SIZE);

d_path() can returns an error. You should add :

	if (IS_ERR(p))
		p = "?";

> +			s = strrchr(p, '/');
> +			if (s)
> +				p = s+1;
> +			printk("%s%s[%lx+%lx]", prefix, p,
> +					vma->vm_start,
> +					vma->vm_end - vma->vm_start);
> +			free_page((unsigned long)buf);
> +		}
> +	}
> +	up_read(&current->mm->mmap_sem);
> +}

Thank you


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbZALUFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbZALUFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbZALUF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:05:26 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:51505 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbZALUFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:05:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=yIGB2u/X/o2STiLlpYr44RZxyBe45I7+s4vRenGGewq6E7ocf5JpDWl5qZzUgYl2ZG
         A5IdRQWfZQn0uDwSCB62gk+z8dVzDUdtmZgVB63e4B5Vl8H/JKGuuCgs9PEoI5OG2hl3
         bRGMhTWTZAP2PfaQS8eT4vUukQVxdQgm0AGaA=
Message-ID: <64bb37e0901121205u78195ac4j145fa922f9e99107@mail.gmail.com>
Date: Mon, 12 Jan 2009 21:05:20 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [git pull] x86 fixes
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090112192912.GA31650@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090111143951.GA6666@elte.hu>
	 <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com>
	 <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com>
	 <64bb37e0901121101y73c492fel38a70681f226b526@mail.gmail.com>
	 <20090112191934.GA28851@linux-os.sc.intel.com>
	 <20090112192912.GA31650@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 8:29 PM, Pallipadi, Venkatesh
<venkatesh.pallipadi@intel.com> wrote:
> oops. I missed out one file in the earlier test patch. Below is the
> updated test patch that will go against 29-rc1.
>
> Thanks,
> Venki
>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipad@intel.com>

Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>

The system boots normal and glxgears is accelerated again.

> ---
>
> Index: linux-2.6/arch/x86/mm/pat.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/pat.c    2009-01-12 10:45:03.000000000 -0800
> +++ linux-2.6/arch/x86/mm/pat.c 2009-01-12 11:06:43.000000000 -0800
> @@ -601,12 +601,13 @@ void unmap_devmem(unsigned long pfn, uns
>  * Reserved non RAM regions only and after successful reserve_memtype,
>  * this func also keeps identity mapping (if any) in sync with this new prot.
>  */
> -static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t vma_prot)
> +static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
> +                               int strict_prot)
>  {
>        int is_ram = 0;
>        int id_sz, ret;
>        unsigned long flags;
> -       unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
> +       unsigned long want_flags = (pgprot_val(*vma_prot) & _PAGE_CACHE_MASK);
>
>        is_ram = pagerange_is_ram(paddr, paddr + size);
>
> @@ -625,15 +626,29 @@ static int reserve_pfn_range(u64 paddr,
>                return ret;
>
>        if (flags != want_flags) {
> -               free_memtype(paddr, paddr + size);
> -               printk(KERN_ERR
> -               "%s:%d map pfn expected mapping type %s for %Lx-%Lx, got %s\n",
> -                       current->comm, current->pid,
> -                       cattr_name(want_flags),
> -                       (unsigned long long)paddr,
> -                       (unsigned long long)(paddr + size),
> -                       cattr_name(flags));
> -               return -EINVAL;
> +               if (strict_prot ||
> +                   (want_flags == _PAGE_CACHE_UC_MINUS &&
> +                    flags == _PAGE_CACHE_WB) ||
> +                   (want_flags == _PAGE_CACHE_WC &&
> +                    flags == _PAGE_CACHE_WB)) {
> +                       free_memtype(paddr, paddr + size);
> +                       printk(KERN_ERR "%s:%d map pfn expected mapping type %s"
> +                               " for %Lx-%Lx, got %s\n",
> +                               current->comm, current->pid,
> +                               cattr_name(want_flags),
> +                               (unsigned long long)paddr,
> +                               (unsigned long long)(paddr + size),
> +                               cattr_name(flags));
> +                       return -EINVAL;
> +               }
> +               /*
> +                * We allow returning different type than the one requested in
> +                * non strict case.
> +                */
> +               *vma_prot = __pgprot((pgprot_val(*vma_prot) &
> +                                     (~_PAGE_CACHE_MASK)) |
> +                                    flags);
> +
>        }
>
>        /* Need to keep identity mapping in sync */
> @@ -689,6 +704,7 @@ int track_pfn_vma_copy(struct vm_area_st
>        unsigned long vma_start = vma->vm_start;
>        unsigned long vma_end = vma->vm_end;
>        unsigned long vma_size = vma_end - vma_start;
> +       pgprot_t pgprot;
>
>        if (!pat_enabled)
>                return 0;
> @@ -702,7 +718,8 @@ int track_pfn_vma_copy(struct vm_area_st
>                        WARN_ON_ONCE(1);
>                        return -EINVAL;
>                }
> -               return reserve_pfn_range(paddr, vma_size, __pgprot(prot));
> +               pgprot = __pgprot(prot);
> +               return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
>        }
>
>        /* reserve entire vma page by page, using pfn and prot from pte */
> @@ -710,7 +727,8 @@ int track_pfn_vma_copy(struct vm_area_st
>                if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
>                        continue;
>
> -               retval = reserve_pfn_range(paddr, PAGE_SIZE, __pgprot(prot));
> +               pgprot = __pgprot(prot);
> +               retval = reserve_pfn_range(paddr, PAGE_SIZE, &pgprot, 1);
>                if (retval)
>                        goto cleanup_ret;
>        }
> @@ -741,7 +759,7 @@ cleanup_ret:
>  * Note that this function can be called with caller trying to map only a
>  * subrange/page inside the vma.
>  */
> -int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
> +int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
>                        unsigned long pfn, unsigned long size)
>  {
>        int retval = 0;
> @@ -758,14 +776,14 @@ int track_pfn_vma_new(struct vm_area_str
>        if (is_linear_pfn_mapping(vma)) {
>                /* reserve the whole chunk starting from vm_pgoff */
>                paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
> -               return reserve_pfn_range(paddr, vma_size, prot);
> +               return reserve_pfn_range(paddr, vma_size, prot, 0);
>        }
>
>        /* reserve page by page using pfn and size */
>        base_paddr = (resource_size_t)pfn << PAGE_SHIFT;
>        for (i = 0; i < size; i += PAGE_SIZE) {
>                paddr = base_paddr + i;
> -               retval = reserve_pfn_range(paddr, PAGE_SIZE, prot);
> +               retval = reserve_pfn_range(paddr, PAGE_SIZE, prot, 0);
>                if (retval)
>                        goto cleanup_ret;
>        }
> Index: linux-2.6/mm/memory.c
> ===================================================================
> --- linux-2.6.orig/mm/memory.c  2009-01-12 10:45:03.000000000 -0800
> +++ linux-2.6/mm/memory.c       2009-01-12 10:59:30.000000000 -0800
> @@ -1511,6 +1511,7 @@ int vm_insert_pfn(struct vm_area_struct
>                        unsigned long pfn)
>  {
>        int ret;
> +       pgprot_t pgprot = vma->vm_page_prot;
>        /*
>         * Technically, architectures with pte_special can avoid all these
>         * restrictions (same for remap_pfn_range).  However we would like
> @@ -1525,10 +1526,10 @@ int vm_insert_pfn(struct vm_area_struct
>
>        if (addr < vma->vm_start || addr >= vma->vm_end)
>                return -EFAULT;
> -       if (track_pfn_vma_new(vma, vma->vm_page_prot, pfn, PAGE_SIZE))
> +       if (track_pfn_vma_new(vma, &pgprot, pfn, PAGE_SIZE))
>                return -EINVAL;
>
> -       ret = insert_pfn(vma, addr, pfn, vma->vm_page_prot);
> +       ret = insert_pfn(vma, addr, pfn, pgprot);
>
>        if (ret)
>                untrack_pfn_vma(vma, pfn, PAGE_SIZE);
> @@ -1671,9 +1672,15 @@ int remap_pfn_range(struct vm_area_struc
>
>        vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
>
> -       err = track_pfn_vma_new(vma, prot, pfn, PAGE_ALIGN(size));
> -       if (err)
> +       err = track_pfn_vma_new(vma, &prot, pfn, PAGE_ALIGN(size));
> +       if (err) {
> +               /*
> +                * To indicate that track_pfn related cleanup is not
> +                * needed from higher level routine calling unmap_vmas
> +                */
> +               vma->vm_flags &= ~(VM_IO | VM_RESERVED | VM_PFNMAP);
>                return -EINVAL;
> +       }
>
>        BUG_ON(addr >= end);
>        pfn -= addr >> PAGE_SHIFT;
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index 72ebe91..8e6d0ca 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -301,7 +301,7 @@ static inline void ptep_modify_prot_commit(struct mm_struct *mm,
>  * track_pfn_vma_new is called when a _new_ pfn mapping is being established
>  * for physical range indicated by pfn and size.
>  */
> -static inline int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
> +static inline int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
>                                        unsigned long pfn, unsigned long size)
>  {
>        return 0;
> @@ -332,7 +332,7 @@ static inline void untrack_pfn_vma(struct vm_area_struct *vma,
>  {
>  }
>  #else
> -extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
> +extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
>                                unsigned long pfn, unsigned long size);
>  extern int track_pfn_vma_copy(struct vm_area_struct *vma);
>  extern void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
>

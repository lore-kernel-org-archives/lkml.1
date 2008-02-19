Return-Path: <linux-kernel-owner+w=401wt.eu-S1759756AbYBSXJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756AbYBSXJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbYBSXI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:08:59 -0500
Received: from n11.bullet.mail.mud.yahoo.com ([209.191.125.210]:20169 "HELO
	n11.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755721AbYBSXI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:08:57 -0500
X-Yahoo-Newman-Id: 220748.12361.bm@omp408.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xd/TKItY55+u8vVKqwGmC3USZEKAPnGI/3WrT7uAC3e3U7n6nE4LlIkED0rEDcKdOdkt85jugjY5Kc4ghOTPn1m06cOsvQa9p8OK7qZAF1r//D6/QHS8oWVdjcBVPqCx/IuwhRhp5dP8v1Npo6BZbMhhcudcD931hGaSANSTDag=  ;
X-YMail-OSG: oUMKXA4VM1lNtZ7uifnATdjjWOSGI3c8jtnbb1XSuIuXL_4DUBi5j1OlMARV8wusSiKCg6K5Tg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
Date: Wed, 20 Feb 2008 10:08:49 +1100
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, Andrea Arcangeli <andrea@qumranet.com>,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
References: <20080215064859.384203497@sgi.com> <20080215064932.620773824@sgi.com>
In-Reply-To: <20080215064932.620773824@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201008.49933.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2008 17:49, Christoph Lameter wrote:
> The invalidation of address ranges in a mm_struct needs to be
> performed when pages are removed or permissions etc change.
>
> If invalidate_range_begin() is called with locks held then we
> pass a flag into invalidate_range() to indicate that no sleeping is
> possible. Locks are only held for truncate and huge pages.

You can't sleep inside rcu_read_lock()!

I must say that for a patch that is up to v8 or whatever and is
posted twice a week to such a big cc list, it is kind of slack to
not even test it and expect other people to review it.

Also, what we are going to need here are not skeleton drivers
that just do all the *easy* bits (of registering their callbacks),
but actual fully working examples that do everything that any
real driver will need to do. If not for the sanity of the driver
writer, then for the sanity of the VM developers (I don't want
to have to understand xpmem or infiniband in order to understand
how the VM works).



> In two cases we use invalidate_range_begin/end to invalidate
> single pages because the pair allows holding off new references
> (idea by Robin Holt).
>
> do_wp_page(): We hold off new references while we update the pte.
>
> xip_unmap: We are not taking the PageLock so we cannot
> use the invalidate_page mmu_rmap_notifier. invalidate_range_begin/end
> stands in.
>
> Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
> Signed-off-by: Robin Holt <holt@sgi.com>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
>
> ---
>  mm/filemap_xip.c |    5 +++++
>  mm/fremap.c      |    3 +++
>  mm/hugetlb.c     |    3 +++
>  mm/memory.c      |   35 +++++++++++++++++++++++++++++------
>  mm/mmap.c        |    2 ++
>  mm/mprotect.c    |    3 +++
>  mm/mremap.c      |    7 ++++++-
>  7 files changed, 51 insertions(+), 7 deletions(-)
>
> Index: linux-2.6/mm/fremap.c
> ===================================================================
> --- linux-2.6.orig/mm/fremap.c	2008-02-14 18:43:31.000000000 -0800
> +++ linux-2.6/mm/fremap.c	2008-02-14 18:45:07.000000000 -0800
> @@ -15,6 +15,7 @@
>  #include <linux/rmap.h>
>  #include <linux/module.h>
>  #include <linux/syscalls.h>
> +#include <linux/mmu_notifier.h>
>
>  #include <asm/mmu_context.h>
>  #include <asm/cacheflush.h>
> @@ -214,7 +215,9 @@ asmlinkage long sys_remap_file_pages(uns
>  		spin_unlock(&mapping->i_mmap_lock);
>  	}
>
> +	mmu_notifier(invalidate_range_begin, mm, start, start + size, 0);
>  	err = populate_range(mm, vma, start, size, pgoff);
> +	mmu_notifier(invalidate_range_end, mm, start, start + size, 0);
>  	if (!err && !(flags & MAP_NONBLOCK)) {
>  		if (unlikely(has_write_lock)) {
>  			downgrade_write(&mm->mmap_sem);
> Index: linux-2.6/mm/memory.c
> ===================================================================
> --- linux-2.6.orig/mm/memory.c	2008-02-14 18:43:31.000000000 -0800
> +++ linux-2.6/mm/memory.c	2008-02-14 18:45:07.000000000 -0800
> @@ -51,6 +51,7 @@
>  #include <linux/init.h>
>  #include <linux/writeback.h>
>  #include <linux/memcontrol.h>
> +#include <linux/mmu_notifier.h>
>
>  #include <asm/pgalloc.h>
>  #include <asm/uaccess.h>
> @@ -611,6 +612,9 @@ int copy_page_range(struct mm_struct *ds
>  	if (is_vm_hugetlb_page(vma))
>  		return copy_hugetlb_page_range(dst_mm, src_mm, vma);
>
> +	if (is_cow_mapping(vma->vm_flags))
> +		mmu_notifier(invalidate_range_begin, src_mm, addr, end, 0);
> +
>  	dst_pgd = pgd_offset(dst_mm, addr);
>  	src_pgd = pgd_offset(src_mm, addr);
>  	do {
> @@ -621,6 +625,11 @@ int copy_page_range(struct mm_struct *ds
>  						vma, addr, next))
>  			return -ENOMEM;
>  	} while (dst_pgd++, src_pgd++, addr = next, addr != end);
> +
> +	if (is_cow_mapping(vma->vm_flags))
> +		mmu_notifier(invalidate_range_end, src_mm,
> +						vma->vm_start, end, 0);
> +
>  	return 0;
>  }
>
> @@ -893,13 +902,16 @@ unsigned long zap_page_range(struct vm_a
>  	struct mmu_gather *tlb;
>  	unsigned long end = address + size;
>  	unsigned long nr_accounted = 0;
> +	int atomic = details ? (details->i_mmap_lock != 0) : 0;
>
>  	lru_add_drain();
>  	tlb = tlb_gather_mmu(mm, 0);
>  	update_hiwater_rss(mm);
> +	mmu_notifier(invalidate_range_begin, mm, address, end, atomic);
>  	end = unmap_vmas(&tlb, vma, address, end, &nr_accounted, details);
>  	if (tlb)
>  		tlb_finish_mmu(tlb, address, end);
> +	mmu_notifier(invalidate_range_end, mm, address, end, atomic);
>  	return end;
>  }
>

Where do you invalidate for munmap()?

Also, how to you resolve the case where you are not allowed to sleep?
I would have thought either you have to handle it, in which case nobody
needs to sleep; or you can't handle it, in which case the code is
broken.


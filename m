Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbYIBQ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbYIBQ20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 12:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbYIBQ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 12:28:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43098 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbYIBQ2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:28:05 -0400
Date: Tue, 2 Sep 2008 17:27:59 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Adam Litke <agl@us.ibm.com>, Hugh Dickins <hugh@veritas.com>,
       Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       William Irwin <wli@holomorphy.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hugepage: support ZERO_PAGE()
Message-ID: <20080902162759.GD26372@csn.ul.ie>
References: <20080829082832.3C1D.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1220023713.14358.173.camel@localhost.localdomain> <20080902100910.1AAB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080902100910.1AAB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (02/09/08 10:21), KOSAKI Motohiro didst pronounce:
> CCed Mel Golman
> 

Here is a second go at reviewing this after spending a bit more time on
it.

> > > > One caution though: how well does it behave when coredumping a large
> > > > area of hugepages which have not actually been instantiated prior to
> > > > the coredump?  We have that funny FOLL_ANON ZERO_PAGE code in
> > > > follow_page() to avoid wasting memory on large uninstantiated anon
> > > > areas, but hugepages won't go that way.  If the dump hangs waiting for
> > > > memory to be freed, or OOMkills other processes, that wouldn't be good;
> > > > whereas if hugepage reservations (I've not followed what happens with
> > > > them) or whatever just make it skip when no more, that should be okay.
> > > 
> > > I think hugepage reservation pages always exist when hugepage COW happend.
> > > Then, hugepage access never cause try_to_free_pages() nor OOM.
> > 
> > (Mel, since you wrote the private reservation hugetlb code, would you
> > care to verify the following:)
> > 
> > Well, reserved huge pages _almost_ always exist.  The notable exception
> > happens when a process creates a MAP_PRIVATE hugetlb mapping and then
> > forks.  No guarantees are made to the children for access to that
> > hugetlb mapping.  So if such a child were to core dump an unavailable
> > huge page, follow_hugetlb_page() would fail.  I think that case is
> > harmless since it looks like elf_coredump() will replace it with a
> > zeroed page?
> > 
> > The part of Hugh's email that does deserve more attention is the part
> > about FOLL_ANON and the ZERO_PAGE.  It seems like an awful waste to zero
> > out and instantiate huge pages just for a core dump.  I think it would
> > be worth adding a flag to follow_hugetlb_page() so that it can be
> > instructed to not fault in un-instantiated huge pages.  This would take
> > some investigating as to whether it is even valid for
> > follow_hugetlb_page() to return the ZERO_PAGE().
> 
> Adam, Thank you precious explain.
> 
> Honestly, I can't imazine non-zero-page-support cause terrible things.
> Can you explain when happend the terrible things?
> I don't know its problem is big issue or not.
> 
> 
> Anyway, I made hugepage's zero page patch.
> Could you please see it?
> 
> 
> 
> =======================================================================================
> Subject: hugepage: supoort ZERO_PAGE()
> 
> Now, hugepage doesn't use zero page at all because zero page is almost used for coredumping only
> and it isn't supported ago.
> 
> But now, we implemented hugepage coredumping and we should implement the zero page of hugepage.
> The patch do that.
> 
> 
> Implementation note:
> -------------------------------------------------------------
> o Why do we only check VM_SHARED for zero page?
>   normal page checked as ..
> 
> 	static inline int use_zero_page(struct vm_area_struct *vma)
> 	{
> 	        if (vma->vm_flags & (VM_LOCKED | VM_SHARED))
> 	                return 0;
> 	
> 	        return !vma->vm_ops || !vma->vm_ops->fault;
> 	}
> 
> First, hugepages never mlock()ed. we don't need concern to VM_LOCKED.
> 
> Second, hugetlbfs is pseudo filesystem, not real filesystem and it doesn't have any file backing.
> Then, ops->fault checking is meaningless.
> 
> 
> o Why don't we use zero page if !pte.
> 
> !pte indicate {pud, pmd} doesn't exist or any error happend.
> So, We shouldn't return zero page if any error happend.
> 
> 
> 
> test method
> -------------------------------------------------------
> console 1:
> 
> 	# su
> 	# echo 100 >/proc/sys/vm/nr_hugepages
> 	# mount -t hugetlbfs none /hugetlbfs/
> 	# watch -n1 cat /proc/meminfo
> 
> console 2:
> 	% gcc -g -Wall crash_hugepage.c -o crash_hugepage -lhugetlbfs
> 	% ulimit -c unlimited
> 	% echo 0x23 >/proc/self/coredump_filter
> 	% HUGETLB_MORECORE=yes ./crash_hugepage 50
> 		-> segmentation fault
> 	% gdb
> 
> crash_hugepage.c
> ----------------------
> #include <stdlib.h>
> #include <stdio.h>
> #include <unistd.h>
> 
> #define HUGEPAGE_SIZE (2*1024*1024)
> 
> int main(int argc, char** argv){
> 	char* p;
> 
> 	p = malloc( atoi(argv[1]) * HUGEPAGE_SIZE);
> 	sleep(2);
> 
> 	*(p + HUGEPAGE_SIZE) = 1;
> 	sleep(2);
> 
> 	*(int*)0 = 1;
> 
> 	return 0;
> }
> --------------------------------
> 

I checked and this appears to be ok for both gdb and direct-io at least.
More comments are below. They are mostly about style except for one.

> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Adam Litke <agl@us.ibm.com>
> CC: Hugh Dickins <hugh@veritas.com>
> CC: Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>
> CC: William Irwin <wli@holomorphy.com>
> CC: Mel Gorman <mel@skynet.ie>
> 
> ---
>  include/linux/hugetlb.h |    6 ++++--
>  mm/hugetlb.c            |   29 +++++++++++++++++++++++++----
>  mm/memory.c             |    3 ++-
>  3 files changed, 31 insertions(+), 7 deletions(-)
> 
> Index: b/mm/hugetlb.c
> ===================================================================
> --- a/mm/hugetlb.c	2008-08-31 01:57:36.000000000 +0900
> +++ b/mm/hugetlb.c	2008-09-02 08:39:31.000000000 +0900
> @@ -2022,15 +2022,30 @@ follow_huge_pud(struct mm_struct *mm, un
>  	return NULL;
>  }
>  
> +static int huge_zeropage_ok(pte_t *ptep, int write, int shared)
> +{
> +	if (!ptep)
> +		return 0;
> +
> +	if (write)
> +		return 0;
> +
> +	if (shared)
> +		return 0;
> +
> +	return huge_pte_none(huge_ptep_get(ptep));
> +}
> +
>  int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  			struct page **pages, struct vm_area_struct **vmas,
>  			unsigned long *position, int *length, int i,
> -			int write)
> +			int write, int shared)

Why does the signature need to change? You have the VMA and could check
the vma->flags within the function.

>  {
>  	unsigned long pfn_offset;
>  	unsigned long vaddr = *position;
>  	int remainder = *length;
>  	struct hstate *h = hstate_vma(vma);
> +	int zeropage_ok = 0;
>  
>  	spin_lock(&mm->page_table_lock);
>  	while (vaddr < vma->vm_end && remainder) {
> @@ -2043,8 +2058,11 @@ int follow_hugetlb_page(struct mm_struct
>  		 * first, for the page indexing below to work.
>  		 */
>  		pte = huge_pte_offset(mm, vaddr & huge_page_mask(h));
> +		if (huge_zeropage_ok(pte, write, shared))
> +			zeropage_ok = 1;
>  
> -		if (!pte || huge_pte_none(huge_ptep_get(pte)) ||
> +		if (!pte ||
> +		    (huge_pte_none(huge_ptep_get(pte)) && !zeropage_ok) ||
>  		    (write && !pte_write(huge_ptep_get(pte)))) {
>  			int ret;
>  
> @@ -2061,11 +2079,14 @@ int follow_hugetlb_page(struct mm_struct
>  		}
>  
>  		pfn_offset = (vaddr & ~huge_page_mask(h)) >> PAGE_SHIFT;
> -		page = pte_page(huge_ptep_get(pte));
> +		if (zeropage_ok)
> +			page = ZERO_PAGE(0);
> +		else
> +			page = pte_page(huge_ptep_get(pte));

Calculate pfn_offset within the if statement here so that the change
below is unnecessary. The zeropage_ok ? 0 : pfn_offset is trickier to
read than it needs to be.

>  same_page:
>  		if (pages) {
>  			get_page(page);
> -			pages[i] = page + pfn_offset;
> +			pages[i] = page + (zeropage_ok ? 0 : pfn_offset);
>  		}

For direct-IO on NUMA, do we care that we are now calling get_page() and
bumping the reference count on the zero page instead of a struct page
that could be local? I suspect the answer is "no" because the same
problem would apply for base pages but someone might disagree.

>  
>  		if (vmas)
> Index: b/include/linux/hugetlb.h
> ===================================================================
> --- a/include/linux/hugetlb.h	2008-09-02 08:05:46.000000000 +0900
> +++ b/include/linux/hugetlb.h	2008-09-02 08:40:46.000000000 +0900
> @@ -21,7 +21,9 @@ int hugetlb_sysctl_handler(struct ctl_ta
>  int hugetlb_overcommit_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
>  int hugetlb_treat_movable_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
>  int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
> -int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int, int);
> +int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
> +			struct page **, struct vm_area_struct **,
> +			unsigned long *, int *, int, int, int);
>  void unmap_hugepage_range(struct vm_area_struct *,
>  			unsigned long, unsigned long, struct page *);
>  void __unmap_hugepage_range(struct vm_area_struct *,
> @@ -74,7 +76,7 @@ static inline unsigned long hugetlb_tota
>  	return 0;
>  }
>  
> -#define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
> +#define follow_hugetlb_page(m, v, p, vs, a, b, i, w, s)	({ BUG(); 0; })
>  #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
>  #define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
>  #define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
> Index: b/mm/memory.c
> ===================================================================
> --- a/mm/memory.c	2008-08-30 11:31:53.000000000 +0900
> +++ b/mm/memory.c	2008-09-02 08:41:12.000000000 +0900
> @@ -1208,7 +1208,8 @@ int __get_user_pages(struct task_struct 
>  
>  		if (is_vm_hugetlb_page(vma)) {
>  			i = follow_hugetlb_page(mm, vma, pages, vmas,
> -						&start, &len, i, write);
> +						&start, &len, i, write,
> +						vma->vm_flags & VM_SHARED);
>  			continue;
>  		}
>  
> 
> 
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbYIBPNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbYIBPNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYIBPNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:13:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34341 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbYIBPNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:13:42 -0400
Date: Tue, 2 Sep 2008 16:13:39 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Adam Litke <agl@us.ibm.com>, Hugh Dickins <hugh@veritas.com>,
       Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       William Irwin <wli@holomorphy.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hugepage: support ZERO_PAGE()
Message-ID: <20080902151339.GC26372@csn.ul.ie>
References: <20080829082832.3C1D.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1220023713.14358.173.camel@localhost.localdomain> <20080902100910.1AAB.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080902142234.GB26372@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080902142234.GB26372@csn.ul.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (02/09/08 15:22), Mel Gorman didst pronounce:
> > <SNIP>
> > @@ -2061,11 +2079,14 @@ int follow_hugetlb_page(struct mm_struct
> >  		}
> >  
> >  		pfn_offset = (vaddr & ~huge_page_mask(h)) >> PAGE_SHIFT;
> > -		page = pte_page(huge_ptep_get(pte));
> > +		if (zeropage_ok)
> > +			page = ZERO_PAGE(0);
> > +		else
> > +			page = pte_page(huge_ptep_get(pte));
> 
> This does not look safe in the ptrace case at all. If I ptrace the app
> to read a hugetlbfs-backed region, get_user_pages() gets called and then
> this. In that case, it would appear that a 4K page would be put in place
> where a hugepage is expected. What am I missing?
> 

D'oh, what was I thinking. It's only read in PAGE_SIZE portions so it will
not be reading beyond the boundary. It should be safe in the ptrace and
direct-io cases.

> >  same_page:
> >  		if (pages) {
> >  			get_page(page);
> > -			pages[i] = page + pfn_offset;
> > +			pages[i] = page + (zeropage_ok ? 0 : pfn_offset);
> >  		}
> >  
> >  		if (vmas)
> > Index: b/include/linux/hugetlb.h
> > ===================================================================
> > --- a/include/linux/hugetlb.h	2008-09-02 08:05:46.000000000 +0900
> > +++ b/include/linux/hugetlb.h	2008-09-02 08:40:46.000000000 +0900
> > @@ -21,7 +21,9 @@ int hugetlb_sysctl_handler(struct ctl_ta
> >  int hugetlb_overcommit_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
> >  int hugetlb_treat_movable_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
> >  int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
> > -int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int, int);
> > +int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
> > +			struct page **, struct vm_area_struct **,
> > +			unsigned long *, int *, int, int, int);
> >  void unmap_hugepage_range(struct vm_area_struct *,
> >  			unsigned long, unsigned long, struct page *);
> >  void __unmap_hugepage_range(struct vm_area_struct *,
> > @@ -74,7 +76,7 @@ static inline unsigned long hugetlb_tota
> >  	return 0;
> >  }
> >  
> > -#define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
> > +#define follow_hugetlb_page(m, v, p, vs, a, b, i, w, s)	({ BUG(); 0; })
> >  #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
> >  #define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
> >  #define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
> > Index: b/mm/memory.c
> > ===================================================================
> > --- a/mm/memory.c	2008-08-30 11:31:53.000000000 +0900
> > +++ b/mm/memory.c	2008-09-02 08:41:12.000000000 +0900
> > @@ -1208,7 +1208,8 @@ int __get_user_pages(struct task_struct 
> >  
> >  		if (is_vm_hugetlb_page(vma)) {
> >  			i = follow_hugetlb_page(mm, vma, pages, vmas,
> > -						&start, &len, i, write);
> > +						&start, &len, i, write,
> > +						vma->vm_flags & VM_SHARED);
> >  			continue;
> >  		}
> >  
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

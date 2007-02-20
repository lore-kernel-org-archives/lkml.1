Return-Path: <linux-kernel-owner+w=401wt.eu-S965174AbXBTPuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965174AbXBTPuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965176AbXBTPuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:50:51 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:52644 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965174AbXBTPuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:50:50 -0500
Date: Tue, 20 Feb 2007 15:50:47 +0000
To: Christoph Hellwig <hch@infradead.org>, Adam Litke <agl@us.ibm.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Introduce the pagetable_operations and associated helper macros.
Message-ID: <20070220155047.GA16142@skynet.ie>
References: <20070219183123.27318.27319.stgit@localhost.localdomain> <20070219183133.27318.92920.stgit@localhost.localdomain> <20070219222906.GA16385@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070219222906.GA16385@infradead.org>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (19/02/07 22:29), Christoph Hellwig didst pronounce:
> On Mon, Feb 19, 2007 at 10:31:34AM -0800, Adam Litke wrote:
> > Signed-off-by: Adam Litke <agl@us.ibm.com>
> > ---
> > 
> >  include/linux/mm.h |   25 +++++++++++++++++++++++++
> >  1 files changed, 25 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 2d2c08d..a2fa66d 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -98,6 +98,7 @@ struct vm_area_struct {
> >  
> >  	/* Function pointers to deal with this struct. */
> >  	struct vm_operations_struct * vm_ops;
> > +	struct pagetable_operations_struct * pagetable_ops;
> >  
> >  	/* Information about our backing store: */
> >  	unsigned long vm_pgoff;		/* Offset (within vm_file) in PAGE_SIZE
> > @@ -218,6 +219,30 @@ struct vm_operations_struct {
> >  };
> >  
> >  struct mmu_gather;
> > +
> > +struct pagetable_operations_struct {
> > +	int (*fault)(struct mm_struct *mm,
> > +		struct vm_area_struct *vma,
> > +		unsigned long address, int write_access);
> > +	int (*copy_vma)(struct mm_struct *dst, struct mm_struct *src,
> > +		struct vm_area_struct *vma);
> > +	int (*pin_pages)(struct mm_struct *mm, struct vm_area_struct *vma,
> > +		struct page **pages, struct vm_area_struct **vmas,
> > +		unsigned long *position, int *length, int i);
> > +	void (*change_protection)(struct vm_area_struct *vma,
> > +		unsigned long address, unsigned long end, pgprot_t newprot);
> > +	unsigned long (*unmap_page_range)(struct vm_area_struct *vma,
> > +		unsigned long address, unsigned long end, long *zap_work);
> > +	void (*free_pgtable_range)(struct mmu_gather **tlb,
> > +		unsigned long addr, unsigned long end,
> > +		unsigned long floor, unsigned long ceiling);
> > +};
> 
> I don't think adding another operation vector is a good idea.  But I'd
> rather extend the vma operations vector to deal with all nessecary
> buts ubstead if addubg a second one.

Well, there are a lot of users of vm_operations_struct that have no interest in
the operations in pagetable_operations_struct. Expanding vm_operations_struct
would increase the size of all VMAs by more than is necessary.

Also, having the pagetable ops in vm_operations_struct might lead device
drivers to believe they should be doing something entertaining there. In
reality, we would only want drivers playing with pagetable_operations when
they really know what they are doing and why.  Having the pagetable_ops
set is similar to VM_HUGETLB set as a strong sign that something unusual is
going on that is fairly easy to check for.

I prefer the additional struct to extending VMAs anyway.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

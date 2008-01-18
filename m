Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbYARKkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbYARKkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYARKkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:40:01 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:46196 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbYARKkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:40:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=x502ZwVZZ2eYbHtKMu+1bzivVjvB6eaGArIIudr+a1JdfRm8oJXTcQVRMQcgwPhM9j0kdNYEDUAhhpF8AvD+pfCYaeAKcKEFWrrPqcrzrZO0BGkYgNEvulv9IE58bjoofGG9SxCYDFVTDJs/wb1Fatcv7l8l4mcHfOFZMugNGws=
Message-ID: <4df4ef0c0801180239x7eddb797qa33950f12ddad13f@mail.gmail.com>
Date: Fri, 18 Jan 2008 13:39:58 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped files
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-Reply-To: <1200651958.5920.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12006091182260-git-send-email-salikhmetov@gmail.com>
	 <12006091211208-git-send-email-salikhmetov@gmail.com>
	 <E1JFnsg-0008UU-LU@pomaz-ex.szeredi.hu>
	 <1200651337.5920.9.camel@twins> <1200651958.5920.12.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/18, Peter Zijlstra <peterz@infradead.org>:
>
> On Fri, 2008-01-18 at 11:15 +0100, Peter Zijlstra wrote:
> > On Fri, 2008-01-18 at 10:51 +0100, Miklos Szeredi wrote:
> >
> > > > diff --git a/mm/msync.c b/mm/msync.c
> > > > index a4de868..a49af28 100644
> > > > --- a/mm/msync.c
> > > > +++ b/mm/msync.c
> > > > @@ -13,11 +13,33 @@
> > > >  #include <linux/syscalls.h>
> > > >
> > > >  /*
> > > > + * Scan the PTEs for pages belonging to the VMA and mark them read-only.
> > > > + * It will force a pagefault on the next write access.
> > > > + */
> > > > +static void vma_wrprotect(struct vm_area_struct *vma)
> > > > +{
> > > > + unsigned long addr;
> > > > +
> > > > + for (addr = vma->vm_start; addr < vma->vm_end; addr += PAGE_SIZE) {
> > > > +         spinlock_t *ptl;
> > > > +         pgd_t *pgd = pgd_offset(vma->vm_mm, addr);
> > > > +         pud_t *pud = pud_offset(pgd, addr);
> > > > +         pmd_t *pmd = pmd_offset(pud, addr);
> > > > +         pte_t *pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> > > > +
> > > > +         if (pte_dirty(*pte) && pte_write(*pte))
> > > > +                 *pte = pte_wrprotect(*pte);
> > > > +         pte_unmap_unlock(pte, ptl);
> > > > + }
> > > > +}
> > >
> > > What about ram based filesystems?  They don't start out with read-only
> > > pte's, so I think they don't want them read-protected now either.
> > > Unless this is essential for correct mtime/ctime accounting on these
> > > filesystems (I don't think it really is).  But then the mapping should
> > > start out read-only as well, otherwise the time update will only work
> > > after an msync(MS_ASYNC).
> >
> > page_mkclean() has all the needed logic for this, it also walks the rmap
> > and cleans out all other users, which I think is needed too for
> > consistencies sake:
> >
> > Process A                     Process B
> >
> > mmap(foo.txt)                 mmap(foo.txt)
> >
> > dirty page
> >                               dirty page
> >
> > msync(MS_ASYNC)
> >
> >                               dirty page
> >
> > msync(MS_ASYNC) <--- now what?!
> >
> >
> > So what I would suggest is using the page table walkers from mm, and
> > walks the page range, obtain the page using vm_normal_page() and call
> > page_mkclean(). (Oh, and ensure you don't nest the pte lock :-)
> >
> > All in all, that sounds rather expensive..
>
> Bah, and will break on s390... so we'd need a page_mkclean() variant
> that doesn't actually clear dirty.

So the current version of the functional changes patch takes this into account.

>
>

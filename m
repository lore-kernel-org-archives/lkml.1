Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbYAVCjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbYAVCjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 21:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYAVCj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 21:39:26 -0500
Received: from ro-out-1112.google.com ([72.14.202.182]:12439 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYAVCjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 21:39:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gYweP1jUihRR29wBA7SsCi7zXle+SnHZ+RbvY/zaoiT0RukRccyQpEr+DZoOL1Ybe+SqmioSXxm5dLO4o/kD49O8bMo9xUXvXn+EAy7ELV0U9CXP79T2M1hp6Gs6ALGeUwbHiA8pkwiydU/aq9hccoo0B6PAQ/Nvk5g23yVxRIA=
Message-ID: <4df4ef0c0801211839p73b6b203q47549fba2be8438b@mail.gmail.com>
Date: Tue, 22 Jan 2008 05:39:23 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7 2/2] Update ctime and mtime for memory-mapped files
Cc: linux-mm@kvack.org, jakob@unthought.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, a.p.zijlstra@chello.nl,
       "Andrew Morton" <akpm@linux-foundation.org>, protasnb@gmail.com,
       miklos@szeredi.hu, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-Reply-To: <alpine.LFD.1.00.0801211805220.2957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12009619562023-git-send-email-salikhmetov@gmail.com>
	 <12009619584168-git-send-email-salikhmetov@gmail.com>
	 <alpine.LFD.1.00.0801211805220.2957@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/22, Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Tue, 22 Jan 2008, Anton Salikhmetov wrote:
> >
> >  /*
> > + * Scan the PTEs for pages belonging to the VMA and mark them read-only.
> > + * It will force a pagefault on the next write access.
> > + */
> > +static void vma_wrprotect(struct vm_area_struct *vma)
> > +{
> > +     unsigned long addr;
> > +
> > +     for (addr = vma->vm_start; addr < vma->vm_end; addr += PAGE_SIZE) {
> > +             spinlock_t *ptl;
> > +             pgd_t *pgd = pgd_offset(vma->vm_mm, addr);
> > +             pud_t *pud = pud_offset(pgd, addr);
> > +             pmd_t *pmd = pmd_offset(pud, addr);
> > +             pte_t *pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>
> This is extremely expensive over bigger areas, especially sparsely mapped
> ones (it does all the lookups for all four levels over and over and over
> again for eachg page).
>
> I think Peter Zijlstra posted a version that uses the regular kind of
> nested loop (with inline functions to keep the thing nice and clean),
> which gets rid of that.

Thanks for your feedback, Linus!

I will use Peter Zijlstra's version of such an operation in my next
patch series.

>
> [ The sad/funny part is that this is all how we *used* to do msync(), back
>   in the days: we're literally going back to the "pre-cleanup" logic. See
>   commit 204ec841fbea3e5138168edbc3a76d46747cc987: "mm: msync() cleanup"
>   for details ]
>
> Quite frankly, I really think you might be better off just doing a
>
>         git revert 204ec841fbea3e5138168edbc3a76d46747cc987
>
> and working from there! I just checked, and it still reverts cleanly, and
> you'd end up with a nice code-base that (a) has gotten years of testing
> and (b) already has the looping-over-the-pagetables code.
>
>                         Linus
>

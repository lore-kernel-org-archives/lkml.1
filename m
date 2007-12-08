Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbXLHJPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbXLHJPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 04:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbXLHJPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 04:15:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59623 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbXLHJPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 04:15:39 -0500
Date: Sat, 8 Dec 2007 10:15:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: npiggin@suse.de, mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [patch 07/18] v4l: nopage
Message-ID: <20071208091508.GA20516@elte.hu>
References: <20071205071547.701344000@nick.local0.net> <20071205071627.469118000@nick.local0.net> <20071207163142.4e77f9c3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207163142.4e77f9c3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 05 Dec 2007 18:15:54 +1100
> npiggin@suse.de wrote:
> 
> > +static int
> > +videobuf_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  {
> >  	struct page *page;
> >  
> > -	dprintk(3,"nopage: fault @ %08lx [vma %08lx-%08lx]\n",
> > -		vaddr,vma->vm_start,vma->vm_end);
> > -	if (vaddr > vma->vm_end)
> > -		return NOPAGE_SIGBUS;
> > +	dprintk(3,"fault: fault @ %08lx [vma %08lx-%08lx]\n",
> > +		(unsigned long)vmf->virtual_address,vma->vm_start,vma->vm_end);
> >  	page = alloc_page(GFP_USER | __GFP_DMA32);
> >  	if (!page)
> > -		return NOPAGE_OOM;
> > +		return VM_FAULT_OOM;
> >  	clear_user_page(page_address(page), vaddr, page);
> 
> This didn't compile on sparc64 because `vaddr' is undefined.
> 
> 
> Let us see why:
> 
> #define clear_user_page(page, vaddr, pg)	clear_page(page)
> #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
> 
> #define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
> 	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
> 
> root cause: lack of argument checking on x86 due to stupid macros.
> 
> 
> Could someone *please* start a little project of extirpating this 
> utter brain damage?  Convert those macros to typechecked static 
> inlines on x86 (at least) so this sort of thing (which happens again 
> and again and again) is lessened?

i wanted to write a reply to suggest a checkpatch policy for this. When 
i noticed this sentence at the end of your mail:

> macros are such miserable things.  I wonder if we could get checkpatch 
> to help out here?

/me too :-)

any policy that gets into checkpatch.pl's default output is a policy for 
arch/x86 patch merging. (as long as it's not a false positive) And 
because we do all these unifications the effects of checkpatch.pl 
permeate basically every aspect of arch/x86.

one approach would be to make new macros in include/* a no-no. That 
would hurt a few of the legitimate uses though, so maybe a useful 
refinement would be to check the structure of macros: are arguments used 
twice (side-effect), are arguments unused (typechecking dager), are 
arguments cast (type-loss danger), etc. Looks very hard to implement 
though :-/ Andy, what do you think?

	Ingo

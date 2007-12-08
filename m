Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbXLHKRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbXLHKRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 05:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXLHKRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 05:17:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203AbXLHKRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 05:17:39 -0500
Date: Sat, 8 Dec 2007 02:15:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: npiggin@suse.de, mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [patch 07/18] v4l: nopage
Message-Id: <20071208021559.d0d572d4.akpm@linux-foundation.org>
In-Reply-To: <20071208091508.GA20516@elte.hu>
References: <20071205071547.701344000@nick.local0.net>
	<20071205071627.469118000@nick.local0.net>
	<20071207163142.4e77f9c3.akpm@linux-foundation.org>
	<20071208091508.GA20516@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 10:15:08 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 05 Dec 2007 18:15:54 +1100
> > npiggin@suse.de wrote:
> > 
> > > +static int
> > > +videobuf_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> > >  {
> > >  	struct page *page;
> > >  
> > > -	dprintk(3,"nopage: fault @ %08lx [vma %08lx-%08lx]\n",
> > > -		vaddr,vma->vm_start,vma->vm_end);
> > > -	if (vaddr > vma->vm_end)
> > > -		return NOPAGE_SIGBUS;
> > > +	dprintk(3,"fault: fault @ %08lx [vma %08lx-%08lx]\n",
> > > +		(unsigned long)vmf->virtual_address,vma->vm_start,vma->vm_end);
> > >  	page = alloc_page(GFP_USER | __GFP_DMA32);
> > >  	if (!page)
> > > -		return NOPAGE_OOM;
> > > +		return VM_FAULT_OOM;
> > >  	clear_user_page(page_address(page), vaddr, page);
> > 
> > This didn't compile on sparc64 because `vaddr' is undefined.
> > 
> > 
> > Let us see why:
> > 
> > #define clear_user_page(page, vaddr, pg)	clear_page(page)
> > #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
> > 
> > #define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
> > 	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
> > 
> > root cause: lack of argument checking on x86 due to stupid macros.
> > 
> > 
> > Could someone *please* start a little project of extirpating this 
> > utter brain damage?  Convert those macros to typechecked static 
> > inlines on x86 (at least) so this sort of thing (which happens again 
> > and again and again) is lessened?

We should fix existing stuff, like this.

> i wanted to write a reply to suggest a checkpatch policy for this. When 
> i noticed this sentence at the end of your mail:
> 
> > macros are such miserable things.  I wonder if we could get checkpatch 
> > to help out here?
> 
> /me too :-)
> 
> any policy that gets into checkpatch.pl's default output is a policy for 
> arch/x86 patch merging. (as long as it's not a false positive) And 
> because we do all these unifications the effects of checkpatch.pl 
> permeate basically every aspect of arch/x86.
> 
> one approach would be to make new macros in include/* a no-no. That 
> would hurt a few of the legitimate uses though, so maybe a useful 
> refinement would be to check the structure of macros: are arguments used 
> twice (side-effect), are arguments unused (typechecking dager), are 
> arguments cast (type-loss danger), etc. Looks very hard to implement 
> though :-/ Andy, what do you think?

I think whining about anything which matches

#define foo(...) bar(

would be a decent start.

grep '^[       ]*#[    ]*define[       ][      ]*[^(]*[(][^)]*[)][      ]*[a-zA-Z]' include/asm-x86/*.h

(hey, that worked on the first attempt)

Lots of falsies tho.

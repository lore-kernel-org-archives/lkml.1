Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbYD2Sdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbYD2Sdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbYD2Sd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:33:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbYD2Sd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:33:26 -0400
Date: Tue, 29 Apr 2008 14:32:54 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ajackson@redhat.com, airlied@redhat.com,
       benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] make access_process_vm work on device memory
Message-ID: <20080429143254.38f60106@cuia.boston.redhat.com>
In-Reply-To: <20080429110919.dc7b8565.akpm@linux-foundation.org>
References: <20080429113237.614f89a1@cuia.boston.redhat.com>
	<20080429110919.dc7b8565.akpm@linux-foundation.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 11:09:19 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> I'll consider this an MM patch, to be mastered in -mm.  If agreeable, x86
> review-and-acks would be nice, please.

Sounds good to me.  Ben Herrenschmidt has tested this patch on PPC Cell,
accessing SPU memory and Adam Jackson has tested it on x86, accessing
video memory with gdb attached to an X server.

Considering the recent amount of change in the ioremap code upstream,
having this patch live in -mm for a few weeks is probably a good idea.

> > Index: linux-2.6.25-mm1/mm/memory.c
> > ===================================================================
> > --- linux-2.6.25-mm1.orig/mm/memory.c	2008-04-27 11:06:04.000000000 -0400
> > +++ linux-2.6.25-mm1/mm/memory.c	2008-04-29 00:52:01.000000000 -0400
> > @@ -2720,6 +2720,86 @@ int in_gate_area_no_task(unsigned long a
> >  
> >  #endif	/* __HAVE_ARCH_GATE_AREA */
> >  
> > +#ifdef _HAVE_ARCH_IOREMAP_PROT
> 
> urgh.
> 
> We have HAVE_ARCH*
> We have __HAVE_ARCH*
> We have ARCH_HAS*
> We have __ARCH_HAS*

We already have _HAVE_ARCH* too.  I copied the convention from the
first definition I ran into.

> what a mess.

No kidding.

> Probably the preferred (but still ugly) approach is to implement
> CONFIG_ARCH_*.

If you feel strongly about having this as CONFIG_ARCH_IOREMAP_PROT I can
send you an incremental patch to do things that way.  Just let me know.

> > +	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
> > +	if (!ptep)
> > +		goto out;
> 
> hm, more copy-n-paste.

It's pretty close, yeah.  Not quite the same though :(
 
> > +	pte = *ptep;
> > +	if (!pte_present(pte))
> > +		goto unlock;
> > +	if ((flags & FOLL_WRITE) && !pte_write(pte))
> > +		goto unlock;
> > +	phys_addr = pte_pfn(pte);
> > +	phys_addr <<= PAGE_SHIFT; /* Shift here to avoid overflow on PAE? */
> 
> That comment betrays a lack of confidence ;)
> 
> What's the score here?

On PAE I think that pte_pfn() returns an unsigned long, which cannot be
left shifted by PAGE_SHIFT. After assigning that value to a resource_size_t
(which is 64 bit on PAE) we can safely do the shift.

I can remove the question mark if you want.

> > +++ linux-2.6.25-mm1/include/asm-x86/io_64.h	2008-04-28 21:37:42.000000000 -0400
> > @@ -175,6 +175,9 @@ extern void early_iounmap(void *addr, un
> >   */
> >  extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
> >  extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
> > +extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
> > +				unsigned long prot_val);
> > +#define _HAVE_ARCH_IOREMAP_PROT
> 
> I expect that any architecture which implements ioremap_prot() will have to
> implement it with the same signature, yes?
> 
> So perhaps the declaration should be placed in include/linux/io.h.

Well, they also need to implement pgprot_val and pte_pgprot.  As for the ioremap
declarations, I just placed them near the others, none of the function declarations
for ioremap() itself are in include/linux/io.h.

-- 
All Rights Reversed

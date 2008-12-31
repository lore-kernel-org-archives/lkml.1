Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYLaJeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYLaJeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYLaJd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:33:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:49628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbYLaJd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:33:58 -0500
Date: Wed, 31 Dec 2008 10:33:56 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, ijc@hellion.org.uk
Subject: Re: early fixmap causes kmap breakage
Message-ID: <20081231093356.GD32239@wotan.suse.de>
References: <20081218211543.GB10681@wotan.suse.de> <20081229151731.2a2c5a02.akpm@linux-foundation.org> <20081230040118.GA27679@wotan.suse.de> <20081230061344.GA28281@elte.hu> <20081230102831.GB3189@wotan.suse.de> <m1bput4766.fsf@frodo.ebiederm.org> <20081231015452.GC32239@wotan.suse.de> <m13ag44t20.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13ag44t20.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 01:01:27AM -0800, Eric W. Biederman wrote:
> Nick Piggin <npiggin@suse.de> writes:
> >> the assumption that the fixmap entries are all contiguous.
> >
> > Yes. That wasn't obvious from my problem description?
> 
> Not quite.  I was the change to one_page_table_init in the patch that made
> it clear to me.  If you have been working the code for a while or come at
> it from the proper angle it is, obvious.  I haven't looked at it in a bit
> and came at it from the wrong angle initially. 

OK. I'll try to improve it.

 
> >> Ditching the swapper_pg_fixmap has some problems.
> >> 
> >> This appears to break early_printk to a usb debug port, which calls
> >> set_fixmap_nocache and expects the mapping to last.
> >> 
> >> This looks like it will have problems with Xen and other environments
> >> where we come in with a pre-populated page table, possibly unmapping
> >> something important.
> >
> > My patch copies the early fixmap mappings to the new page table. Isn't
> > this enough?
> 
> I'm not certain.  Xen can get really finicky if you mess with it's
> pre-established mappings.  Which is one of the reasons why we preserve
> the current mappings.  It was a real struggle to find a solution that
> worked for everything last time we had a PAE problem, and apparently
> we failed to test with large numbers of cpus in the config.
> 
> So please excuse me if I'm leery of a quick fix, to code that is obviously
> insufficiently clean to do what needs to be done intentionally.

Well we should just ask the Xen people whether it will work or not. Why
wouldn't it? Xen has to be able to cope with kernel mappings coming and
going.


> I also don't see the urgency as this problem has existed for long enough
> that I have had time to page out the original conversation, so please
> let's take the time to do this cleanly.

Just to have a straightforward fix for stable kernels I guess.

 
> >> one_page_table_init relies on alloc_bootmem_low_pages for it's memory
> > allocation
> >> so we do not have a guarantee that we will have contiguous memory even without
> >> this.
> >
> > It's OK, if fragile, in early boot where it uses alloc_low_page.
> 
> Which accounts for early_ioremap_init but not permanent_kmaps_init
> which has the same constraint, and also calls page_table_range_init,
> but does so after the bootmem allocator has been initialized.  So
> no we can't rely on the simplicity of alloc_low_page to guarantee
> us a contiguous chunk of ptes. 

Sure, but I have added a check for that so it will panic if
there is a problem. My patch hasn't made things in that department
more fragile, put it that way.

> >> I see three ways we can address this.
> >> - Grow swapper_pg_fixmap to cover the entire fixmap range.
> >>   This trivially and without problems gives an atomic guarantee,
> >>   and should allow removal of code that sets up the fixmaps later
> >>   in C, except in weird cases like Xen.
> >
> > Would be fine by me, although I want to get a minimal patch working
> > in the meantime if that is going to be complex.
> 
> No.  It should be just a matter of passing the number of pages
> we need to initialize in a form that assembly can use and upgrading
> the current code to a loop.
> 
> Unless Xen and co, rely on this code to add kmaps to their initial
> page table which not that I think about it I expect they do.
> 
> > Go wild if you'd like to spend time optimising x86 PAE ;)
> 
> Nit: It is x86 highmem not x86 PAE.
> 
> >> - Not support more than 32 cpus on x86_32.
> >  
> > This is not an option really. Anyway, it's not more than 32 CPUs, but
> > can be a problem with as few as about 8 depending on config.
> 
> That sounds like a lot of IOAPICs.  Can you really see this with only
> 8 cpus??

With highmem debugging, yes I think I saw a kmap bug come from CPU7.

 
> >> I suspect it might even be worth writing a version of one_page_table_init
> >> that would guarantee discontiguous pages.  So we can flush out these
> >> kinds of fragile assumptions.  
> >
> > So did you actually see anything wrong with my last patch which catches
> > discontiguous page tables and copies over the early fixmap translations?
> 
> Sorry I missed the copy of the ptes in my quest to put what you were saying
> in perspective.
> 
> Real concerns:
> 
> We are not always using alloc_low_page() so we have an allocator that
> does not guarantee the property we are seeking.
> 
> - I don't see what prevents us from hitting a kernel page table entry
>   and unmapping ourselves while we are in the middle of this.
> 
>   Minor but very important that we verify.

Because it's in the pkmap area?

 
> - I don't see (if the end mappings are the same) why we need to flush
>   the tlb.

Hmm... x86 CPUs can cache higher level page table translations in
non-cache-coherent buffers, so they could continue to look at the
old page table page after we insert new mappings int othe new one,
thus missing them and faulting. I don't know whether that fault is
going to be guaranteed to flush those higher level translations,
but I don't want to risk it. It's not performance critical.


> - We have a lot of stale comments that you are not updating.

Which? (ah, I see below)

> - page_table_range_init does not explicitly do what you are changing it to
>   guarantee in your patch.  So I think we are taking a weird accidental dependency
>   and applying a bit more duck tape instead of fixing this cleanly, which
>   means some other change is likely to trigger this in another way.

What do you mean? Contiguity of pte pages is guaranteed after my patch.
If there is anything else it is supposed to do but doesn't, then that's
for another patch?

 
> On the other hand it does look like fixing page_table_range_init so that
> it cleanly guarantees what we actually expect from it, is the way to go.
> It is in C so it is readable and it is it can be used to fix up any
> preexisting page tables form Xen and elsewhere.
> 
> Stale comments that I found at a quick look:
> mm/init_32.c:
> >  * In general, pagetable_init() assumes that the pagetable may already
> >  * be partially populated, and so it avoids stomping on any existing
> >  * mappings.
> 
> asm/highmem.h:
>  > /*
>  >  * Right now we initialize only a single pte table. It can be extended
>  >  * easily, subsequent pte tables have to be allocated in one physical
>  >  * chunk of RAM.
>  >  */
> 
> Eric

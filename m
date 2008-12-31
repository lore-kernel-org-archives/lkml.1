Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYLaJHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYLaJHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYLaJHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:07:31 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46112 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbYLaJH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:07:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, ijc@hellion.org.uk
Subject: Re: early fixmap causes kmap breakage
References: <20081218211543.GB10681@wotan.suse.de>
	<20081229151731.2a2c5a02.akpm@linux-foundation.org>
	<20081230040118.GA27679@wotan.suse.de>
	<20081230061344.GA28281@elte.hu> <20081230102831.GB3189@wotan.suse.de>
	<m1bput4766.fsf@frodo.ebiederm.org>
	<20081231015452.GC32239@wotan.suse.de>
Date: Wed, 31 Dec 2008 01:01:27 -0800
In-Reply-To: <20081231015452.GC32239@wotan.suse.de> (Nick Piggin's message of
	"Wed, 31 Dec 2008 02:54:52 +0100")
Message-ID: <m13ag44t20.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: npiggin@suse.de, ijc@hellion.org.uk, tglx@linutronix.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

> On Tue, Dec 30, 2008 at 02:41:53PM -0800, Eric W. Biederman wrote:
>> Nick Piggin <npiggin@suse.de> writes:
>> 
>> > On Tue, Dec 30, 2008 at 07:13:44AM +0100, Ingo Molnar wrote:
>> >> 
>> >> * Nick Piggin <npiggin@suse.de> wrote:
>> >> 
>> >> > On Mon, Dec 29, 2008 at 03:17:31PM -0800, Andrew Morton wrote:
>> >> > > On Thu, 18 Dec 2008 22:15:43 +0100
>> >> > > Nick Piggin <npiggin@suse.de> wrote:
>> >> > > 
>> >> > > > Hi,
>> >> > > > 
>> >> > > > I've debugged a problem where i386+pae systems with more than a few
> CPUs
>> >> > > > blow up at boot in the kmap_atomic code.
>> >> > > 
>> >> > > ping?
>> >> > 
>> >> > No further progress here, I'm waiting on input for how to fix this 
>> >> > "nicely". Meantime, clearing the early fixmap pte I guess works, but you
>> >> > lose a page... is it possible to put it into .initdata or is there some 
>> >> > issue with that? (I guess on a PAE kernel, 4K isn't a big deal).
>> >> 
>> >> yeah, 4K shouldnt be a big deal. Mind sending a patch for this?
>> >
>> > How's this?
>> > --
>> >
>> > The early fixmap pmd entry inserted at the very top of the KVA is casing the
>> > subsequent fixmap mapping code to not provide physically linear pte pages
> over
>> > the kmap atomic portion of the fixmap (which relies on said property to
>> > calculate
>> > pte address).
>> >
>> > This has caused weird boot failures in kmap_atomic much later in the boot
>> > process (initial userspace faults) on a 32-bit PAE system with a larger
> number
>> > of CPUs (smaller CPU counts tend not to run over into the next page so don't
>> > show up the problem).
>> atomic>
>> > Solve this by attempting to clear out the page table, and copy any of its
>> > entries to the new one. Also, add a bug if a nonlinear condition is
> encounted
>> > and can't be resolved, which might save some hours of debugging if this
> fragile
>> > scheme ever breaks again...
>> >
>> > Putting swapper_pg_fixmap into initdata is an exercise left for the
> reviewer...
>> 
>> Ok.  I see what is going on now.  We have exceeded 512 fixmap entries, causing
>> the fixmap entries to consume more than 2MB of the address space.  Which broke
>> the assumption that the fixmap entries are all contiguous.
>
> Yes. That wasn't obvious from my problem description?

Not quite.  I was the change to one_page_table_init in the patch that made
it clear to me.  If you have been working the code for a while or come at
it from the proper angle it is, obvious.  I haven't looked at it in a bit
and came at it from the wrong angle initially. 

>> Ditching the swapper_pg_fixmap has some problems.
>> 
>> This appears to break early_printk to a usb debug port, which calls
>> set_fixmap_nocache and expects the mapping to last.
>> 
>> This looks like it will have problems with Xen and other environments
>> where we come in with a pre-populated page table, possibly unmapping
>> something important.
>
> My patch copies the early fixmap mappings to the new page table. Isn't
> this enough?

I'm not certain.  Xen can get really finicky if you mess with it's
pre-established mappings.  Which is one of the reasons why we preserve
the current mappings.  It was a real struggle to find a solution that
worked for everything last time we had a PAE problem, and apparently
we failed to test with large numbers of cpus in the config.

So please excuse me if I'm leery of a quick fix, to code that is obviously
insufficiently clean to do what needs to be done intentionally.

I also don't see the urgency as this problem has existed for long enough
that I have had time to page out the original conversation, so please
let's take the time to do this cleanly.

>> one_page_table_init relies on alloc_bootmem_low_pages for it's memory
> allocation
>> so we do not have a guarantee that we will have contiguous memory even without
>> this.
>
> It's OK, if fragile, in early boot where it uses alloc_low_page.

Which accounts for early_ioremap_init but not permanent_kmaps_init
which has the same constraint, and also calls page_table_range_init,
but does so after the bootmem allocator has been initialized.  So
no we can't rely on the simplicity of alloc_low_page to guarantee
us a contiguous chunk of ptes. 

>> I see three ways we can address this.
>> - Grow swapper_pg_fixmap to cover the entire fixmap range.
>>   This trivially and without problems gives an atomic guarantee,
>>   and should allow removal of code that sets up the fixmaps later
>>   in C, except in weird cases like Xen.
>
> Would be fine by me, although I want to get a minimal patch working
> in the meantime if that is going to be complex.

No.  It should be just a matter of passing the number of pages
we need to initialize in a form that assembly can use and upgrading
the current code to a loop.

Unless Xen and co, rely on this code to add kmaps to their initial
page table which not that I think about it I expect they do.

> Go wild if you'd like to spend time optimising x86 PAE ;)

Nit: It is x86 highmem not x86 PAE.

>> - Not support more than 32 cpus on x86_32.
>  
> This is not an option really. Anyway, it's not more than 32 CPUs, but
> can be a problem with as few as about 8 depending on config.

That sounds like a lot of IOAPICs.  Can you really see this with only
8 cpus??

>> I suspect it might even be worth writing a version of one_page_table_init
>> that would guarantee discontiguous pages.  So we can flush out these
>> kinds of fragile assumptions.  
>
> So did you actually see anything wrong with my last patch which catches
> discontiguous page tables and copies over the early fixmap translations?

Sorry I missed the copy of the ptes in my quest to put what you were saying
in perspective.

Real concerns:

We are not always using alloc_low_page() so we have an allocator that
does not guarantee the property we are seeking.

- I don't see what prevents us from hitting a kernel page table entry
  and unmapping ourselves while we are in the middle of this.

  Minor but very important that we verify.

- I don't see (if the end mappings are the same) why we need to flush
  the tlb.

- We have a lot of stale comments that you are not updating.

- page_table_range_init does not explicitly do what you are changing it to
  guarantee in your patch.  So I think we are taking a weird accidental dependency
  and applying a bit more duck tape instead of fixing this cleanly, which
  means some other change is likely to trigger this in another way.

On the other hand it does look like fixing page_table_range_init so that
it cleanly guarantees what we actually expect from it, is the way to go.
It is in C so it is readable and it is it can be used to fix up any
preexisting page tables form Xen and elsewhere.

Stale comments that I found at a quick look:
mm/init_32.c:
>  * In general, pagetable_init() assumes that the pagetable may already
>  * be partially populated, and so it avoids stomping on any existing
>  * mappings.

asm/highmem.h:
 > /*
 >  * Right now we initialize only a single pte table. It can be extended
 >  * easily, subsequent pte tables have to be allocated in one physical
 >  * chunk of RAM.
 >  */

Eric

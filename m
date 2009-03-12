Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbZCLDBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbZCLDBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 23:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbZCLDAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 23:00:54 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:34827 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753455AbZCLDAn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 23:00:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IlwgQthI+M8bJEFVzcz/lsWwl4hPPP1HZ/2jf2qy6k1KHuCSMUTTWW351DOJyf6PX8APG1ZbwCNOeHEni2raReNwY2Mdkacr7lwUOwzRE1UsG7E0/CtsN9TNeQr4XACu2OVKEp9RJxxp7DVvKzS8rxDNtcy2EOjVqUcVh3bm6ok=  ;
X-YMail-OSG: .CGS8kIVM1mSW0l5rWjd_XsrdrPYO7ZQKDIY.uBI28LFshwvt1IfwDXf.EMOb98l.147yQEKiB2iW_c1NsLidWjPExx7pwTm7WmOmXWlhDFxBV7wKy8cQZgLS7ynFwOsSLf9fInhc0WkuCEpO1ooAIPvLG4AE4Xn61kT_yrft.4xBUgSerSfqsYeetMdRP2fc.I8Q4fD09K2SDyLxdoyHiK473kOYMZ9QdM-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Daniel Lowengrub <lowdanie@gmail.com>
Subject: Re: [PATCH 1/2] mm: use list.h for vma list
Date: Thu, 12 Mar 2009 14:00:34 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <8c5a844a0903110255q45b7cdf4u1453ce40d495ee2c@mail.gmail.com> <200903112254.56764.nickpiggin@yahoo.com.au> <8c5a844a0903110625y416e7a3ft448a44b1bf70c990@mail.gmail.com>
In-Reply-To: <8c5a844a0903110625y416e7a3ft448a44b1bf70c990@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903121400.34973.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 00:25:05 Daniel Lowengrub wrote:
> On Wed, Mar 11, 2009 at 1:54 PM, Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > On Wednesday 11 March 2009 20:55:48 Daniel Lowengrub wrote:
> >> diff -uNr linux-2.6.28.7.vanilla/arch/arm/mm/mmap.c
> >> linux-2.6.28.7/arch/arm/mm/mmap.c
> >>.....
> >> -     for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
> >> +     for (vma = find_vma(mm, addr); ; vma = vma->vma_next(vma)) {
> >>               /* At this point:  (!vma || addr < vma->vm_end). */
> >>               if (TASK_SIZE - len < addr) {
> >>                       /*
> >
> > Careful with your replacements. I'd suggest a mechanical search &
> > replace might be less error prone.
>
> Thanks for pointing that out.  The code compiled and ran on my x86 machine
> so I'll take an extra look at the other architectures.
>
> >> linux-2.6.28.7/include/linux/mm.h
> >> --- linux-2.6.28.7.vanilla/include/linux/mm.h 2009-03-06
> >>...
> >> +/* Interface for the list_head prev and next pointers.  They
> >> + * don't let you wrap around the vm_list.
> >> + */
> >
> > Hmm, I don't think these are really appropriate replacements for
> > vma->vm_next. 2 branches and a lot of extra icache.
> >
> > A non circular list like hlist might work better, but I suspect if
> > callers are converted properly to have conditions ensuring that it
> > doesn't wrap and doesn't get NULL vmas passed in, then it could
> > avoid both those branches and just be a wrapper around
> > list_entry(vma->vm_list.next)
>
> The main place I can think of where "list_entry(vma->vm_list.next)"
> can be used without the extra conditionals is inside a loop where
> we're going through every vma in the
> list.  This is usually done  with "list_for_each_entry" which uses
> "list_entry(...)" anyway.
> But in all the places that we start from some point inside the list
> (usually with a find_vma)
> a regular "for" list is used with "vma_next" as the last parameter.
> In this case it would
> probably be better to use "list_for_each_entry_continue" which would
> lower the amount of pointless calls to "vma_next".

That would work.


> The first condition in vma_next also does away with the excessive use
> of the ternary operator in the mmap.c file.

I don't think too highly of hiding that stuff. If vma_next isn't an
obvious list_entry(vma->list.next), then you end up having to look
at the definition anyway.


> Where else in the code
> would it be faster to use
> "list_entry(...)" together with conditionals?

Basically anywhere you have replaced vma->vm_next with vma_next without
also modifying the inner loop AFAIKS. I'd honestly just keep it simple
and not have these kinds of wrappers -- everyone knows list.h.

> I'll look through the code again with all this in mind and see if
> calls to the vma_next function can be minimized to the point of
> removing it like
> you said.

That would be great.

> >>  struct mm_struct {
> >> -     struct vm_area_struct * mmap;           /* list of VMAs */
> >> +     struct list_head mm_vmas;               /* list of VMAs */
> >
> >.... like this nice name change ;)
>
> This and other parts of the patch are based on a previous attempt by
> Paul Zijlstra.

OK that's fine, if you could just change vm_list to vma_list too, then? :)


> >> @@ -988,7 +989,8 @@
> >>       lru_add_drain();
> >>       tlb = tlb_gather_mmu(mm, 0);
> >>       update_hiwater_rss(mm);
> >> -     end = unmap_vmas(&tlb, vma, address, end, &nr_accounted, details);
> >> +     end = unmap_vmas(&tlb, &mm->mm_vmas, vma, address, end,
> >> +                     &nr_accounted, details);
> >
> > Why do you change this if the caller knows where the list head is
> > anyway, and extracts it from the mm? I'd prefer to keep changes to
> > calling convention to a minimum (and I hope with the changes to
> > vma_next I suggested then it wouldn't be needed to carry the list
> > head around everywhere anyway).
>
> The unmap_vmas was changed because sometimes (in exit_mmap for example)
> "unmap_vmas" is used right after "detach_vmas_to_be_unmapped" which
> now returns a list of the vmas we want to unmap.  Now that we already
> have this list for free it seems like a good idea to be able to pass
> it to "unmap_vmas".  Do you think that this causes
> more damage than it's worth?

Basically I'd rather not change calling conventions depending on
the exact implementation of the list and list iterators, at least
not until those are looking better (and then you look if any calling
changes improve efficiency at all, at which point I wouldn't object).


> After reading what you said before, it looks like we could take better
> advantage of this
> if we use "list_entry(...) in unmap_vmas's main loop instead of a
> regular for loop
> with __vma_next.
> Thank you for the helpful suggestions.

Thanks for persisting!


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYHQMXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYHQMXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYHQMXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:23:09 -0400
Received: from saeurebad.de ([85.214.36.134]:37535 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbYHQMXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:23:07 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] mm: make unmap_vmas() handle non-page-aligned boundary addresses
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
	<sNRO-BDDjQL.A.spE.VazpIB@albercik>
	<Pine.LNX.4.64.0808170036400.25704@blonde.site>
	<87fxp4pi0r.fsf_-_@skyscraper.fehenstaub.lan>
	<Pine.LNX.4.64.0808171151190.13521@blonde.site>
Date: Sun, 17 Aug 2008 14:22:42 +0200
In-Reply-To: <Pine.LNX.4.64.0808171151190.13521@blonde.site> (Hugh Dickins's
	message of "Sun, 17 Aug 2008 12:30:34 +0100 (BST)")
Message-ID: <8763pzygod.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

Hugh Dickins <hugh@veritas.com> writes:

> On Sun, 17 Aug 2008, Johannes Weiner wrote:
>> zap_pte_range() overruns the page tables if the distance between the
>> start and end is not a multiple of the pagesize.  Because then,
>> `start' will never be equal to `end' and we will keep looping.
>> 
>> To fix this, round the boundary addresses to exclude partial pages from
>> the range completely, we must not unmap them anyway.
>
> You've a good idea here, but no.
>
>> 
>> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>> ---
>> 
>> Hugh Dickins <hugh@veritas.com> writes:
>> 
>> > On Sat, 16 Aug 2008, Rafael J. Wysocki wrote:
>> >> 
>> >> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11335
>> >> Subject		: 2.6.27-rc2-git5 BUG: unable to handle kernel paging request
>> >> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
>> >> Date		: 2008-08-12 4:18 (5 days old)
>> >> References	: http://marc.info/?l=linux-kernel&m=121851477201960&w=4
>> >> Handled-By	: Hugh Dickins <hugh@veritas.com>
>> >
>> > This should still be listed for now, it's interesting,
>> > but I doubt we'll make any progress unless it can be reproduced.
>> 
>> I think this patch fixes it.  exit_mmap() even calls unmap_vmas() with
>> an ending address of -1UL which is not page-aligned in my book and on my
>> architecture :)
>
> You need to take into consideration that gazillions of calls to
> exit_mmap(), unmap_vmas() and zap_pte_range() have been succeeding
> since we reworked those loops three years ago.  exit_mmap() calls
> unmap_vmas() with a start_addr of 0 (so your patch won't help that),
> and the (unsigned long) end_addr of -1 is simply an upper bound on
> on how far the vma loop goes, it doesn't need the alignment your
> patch enforces.

Now that you say it, yes, I don't see any way how the upper bound of
-1UL could break it as vm_end is most probably lower than that :)

However:

		start = max(vma->vm_start, start_addr);
		end = min(vma->vm_end, end_addr);

The overrun *is* possible if the given ending address is lower than the
vm_end.

The same goes for a broken start if it is higher than vm_start.

> That's a great idea that overrunning a pagetable may account for
> Randy's apparent pagetable corruption: I (and please, you too) need
> to go back over the info he's given with that hypothesis in mind,
> it certainly fits well the fact that 6 out of 7 entries were found
> bad at the _start_ of a pagetable before collapsing - though OTOH
> I don't think it does fit with the two processes seeing similar
> but different corruption, or the general protection faults.
> But definitely worth pursuing, it hadn't crossed my mind.

Frankly, I didn't look too much at what Randy reported.  I ran off a bit
quick when I saw that the fault came on an empty PMD within this code as
this overrun issue was still in the back of my head and I knew there
were similar loops involved.

I will try and help debugging this further.

> But if a pagetable is being overrun in that way, doesn't that mean
> that a vma->vm_start (or vma->vm_end?) has got corrupted, and then
> we'll need to work that out.  vm_start and vm_end (unless corrupted)
> are always page aligned, and there's lots of code which assumes that:
> or have you noticed somewhere that's not so?

No, I have not.

But an overrun condition also does not require broken VMA bounds.
Although that could be a possibility, too, of course.

>> It is a similar problem to what we had with gup some weeks ago.
>
> You're right that those pgd_addr_end() etc. loops have an implicit
> and fragile dependence on the page alignment of addr and end.  They
> were written that way to maximize efficiency and be homogeneous
> across the levels, while handling the wrapped end 0 case.  But both
> fast gup and pagewalk have stumbled on those assumptions recently.

Yeah, especially since they could cause silent page table corruption :(

In this respect, I still think that my patch has a point.  Because yes,
the looping depends on page aligned boundaries, but we don't check for
this required dependency and values leading to overruns are able to pass
through, as explained above.

> Hugh

	Hannes

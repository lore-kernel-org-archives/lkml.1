Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbYCEOmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbYCEOmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 09:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYCEOmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 09:42:43 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35562 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYCEOmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 09:42:42 -0500
Date: Wed, 5 Mar 2008 14:29:59 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: preempt bug in set_pmd_pfn?
In-Reply-To: <20080305064814.GB28398@elte.hu>
Message-ID: <Pine.LNX.4.64.0803051407310.22243@blonde.site>
References: <47CDBB87.8090906@goop.org> <20080304212821.GB8944@elte.hu>
 <47CDBEDC.1050302@goop.org> <20080305064814.GB28398@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > Ingo Molnar wrote:
> >> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >>   
> >>> I think set_pmd_pfn, which is only called by __set_fixmap, might have a 
> >>> preempt bug in it.
> >>>     
> >>
> >> yes, and we had similar preemption bugs in the past. I guess most places 
> >> are either infrequent or have some natural atomicity anyway. Wanna send a 
> >> patch?
> >
> > Sure.  Should it just disable preemption, or take a lock?  It calls 
> > set_pte_at without holding any pte locks; that seems to be relatively 
> > common.  Is it OK when you're operating on init_mm?
> 
> no, it's not OK to modify the kernel pagetable without locking - taking 
> the pgd_lock should do the trick. Could you send the stacktrace that 
> shows the place that is preemptible?

Please, Ingo, could you give an example of where such additional locking
is actually necessary?

I ask because I went over those places when splitting the page_table_lock
for userspace in 2.6.15.  Some things took init_mm.page_table_lock and
some things didn't, and I concluded that actually none of them needed it.

With the userspace pagetables, we need to guard against racing threads
and vmscan/rmap.  But with the kernel pagetables, we'd already be in
serious trouble if two cpus could be modifying the same pte at the
same time - there needs to be other serialization already e.g. vmalloc
has its own locking for parcelling out areas to different uses, so down
at the page table level there should be no conflict.

Allocation of new page tables, yes, that needs locking, and does use
the page_table_lock for kernel space just as for user space.

That was all two years ago, I may have been wrong then, or a lot may
have changed since.  But I've heard of a grand total of 0 problems
from not having such locking.

And on the original topic of flush TLB without preemption disabled:
again I'm not sure there's a bug there, but it's less clear.  Aren't
some of those __flush_tlb_ones just unnecessary, we're simply filling
a previously empty slot?  And if there's a guarantee that preemption
will itself involve a TLB flush (maybe there's no such guarantee for
these kernel entries, it's quite a different case from the userspace
one, and you'll be worrying about the global bit), if, then it'd be
okay to __flush_tlb_one without disabling preemption.

Hugh

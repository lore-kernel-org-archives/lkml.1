Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbYEWS3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbYEWS3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbYEWS26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:28:58 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41439 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202AbYEWS2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:28:55 -0400
Subject: Re: [PATCH 0 of 4] mm+paravirt+xen: add pte read-modify-write
	abstraction
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <patchbomb.1211552448@localhost>
References: <patchbomb.1211552448@localhost>
Content-Type: text/plain
Date: Fri, 23 May 2008 11:27:53 -0700
Message-Id: <1211567273.7465.36.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-23 at 15:20 +0100, Jeremy Fitzhardinge wrote:
> Hi all,
> 
> This little series adds a new transaction-like abstraction for doing
> RMW updates to a pte, hooks it into paravirt_ops, and then makes use
> of it in Xen.
> 
> The basic problem is that mprotect is very slow under Xen (up to 50x
> slower than native), primarily because of the
> 
> 	ptent = ptep_get_and_clear(mm, addr, pte);
> 	ptent = pte_modify(ptent, newprot);
> 	/* ... */
> 	set_pte_at(mm, addr, pte, ptent);
> 
> sequence in mm/mprotect.c:change_pte_range().
> 
> This is bad for Xen for two reasons:
> 
>   1: ptep_get_and_clear() ends up being a xchg on the pte.  Since the
>      pte page is read-only (as it must be, because Xen needs to
>      control all pte updates), this traps into Xen, which then
>      emulates the instruction.  Trapping into the instruction emulator
>      is inherently fairly expensive.  And,
> 
>   2: because ptep_get_and_clear has atomic-fetch-and-update semantics,
>      it's impossible to implement in a way which can be batched to amortize
>      the cost of faulting into the hypervisor.
> 
> This series adds the pte_rmw_start() and pte_rmw_commit() operations,
> which change this sequence to:
> 
> 	ptent = pte_rmw_start(mm, addr, pte);
> 	ptent = pte_modify(ptent, newprot);
> 	/* ... */
> 	pte_rmw_commit(mm, addr, pte, ptent);
> 
> Which looks very familiar.  And, indeed, when compiled without
> CONFIG_PARAVIRT (or on a non-x86 architecture), it will end up doing
> precisely the same thing as before.
> 
> However, the effective semantics are a bit different.  pte_rmw_start()
> means "I'm reading this pte with the intention of updating it; please
> don't lose any hardware pte changes in the meantime".  And
> pte_rmw_commit() means "Here's a new value for the pte, but make sure
> you don't lose any hardware changes".
> 
> The default implementation achieves these semantics by making
> pte_rmw_start() set the pte to non-present, which prevents any async
> hardware changes to the pte.  The pte_rmw_commit() can then just write
> the new value into place without having to worry about preserving any
> changes, because it knows there are none.

This all sounds fine.

> Xen implements pte_rmw_start() as a simple read of the pte.  This
> leaves the pte unchanged in memory, and the hardware may make
> asynchronous changes to it.  It implements pte_rmw_commit() using a
> hypercall which preserves the state of the Access/Dirty bits to update
> the pte.  This allows the whole change_pte_range() loop to be run
> without any synchronous unbatched traps into the hypervisor.  With
> this change in place, an mprotect microbenchmark goes from being 50x
> worse than native to around 7x, which is acceptible.

I'm a bit skeptical you can get such a semantic to work without a very
heavyweight method in the hypervisor.  How do you guarantee no other CPU
is fizzling the A/D bits in the page table (it can be done by hardware
with direct page tables), unless you use some kind of IPI?  Is this why
it is still 7x?

Still, a 7x gain from asynchronous batching is very nice.  I wonder if
that means the average mprotect size in your benchmark is 7 pages.

> I believe that other virtualization systems, whether they use direct
> paging like Xen, or a shadow pagetable scheme (vmi, kvm, lguest), can
> make use of this interface to improve the performance.

On VMI, we don't trap the xchg of the pte, thus we don't have any
bottleneck here to begin with.  Nit, wiggle, shadow pagetables are a
good thing.

Zach


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761319AbXJELiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319AbXJELiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 07:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbXJELiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 07:38:14 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42744 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbXJELiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 07:38:12 -0400
Date: Fri, 5 Oct 2007 12:36:33 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: David Rientjes <rientjes@google.com>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Keir Fraser <keir@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
In-Reply-To: <470596C4.8060804@goop.org>
Message-ID: <Pine.LNX.4.64.0710051146300.25518@blonde.wat.veritas.com>
References: <470596C4.8060804@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I see the discussion has somehow moved on to pagetable locking -
mysterious because the word "lock" never once appears in your
otherwise very helpful elucidation below, for which many thanks.

Maybe what I have to add is now of historical interest only, or none,
but I was prevented from answering your original mail earlier...

On Thu, 4 Oct 2007, Jeremy Fitzhardinge wrote:

> David's change 10a8d6ae4b3182d6588a5809a8366343bc295c20, "i386: add
> ptep_test_and_clear_{dirty,young}" has introduced an SMP race which
> affects the Xen pv-ops backend.

I think that race with Xen has been there all along, not introduced
by David's commit.  Take a look at ptep_clear_flush_young() in the
2.6.21 include/asm-i386/pgtable.h, it looks equally a problem to me.

> 
> In Xen, pagetables are normally kept RO so that the hypervisor can
> mediate all updates to them.  If Xen sees a write to an active
> (currently pointed to by cr3) or pinned (a currently inactive but
> registered pagetable), it will trap the write fault and emulate the
> instruction making the update; this means that most pagetable-modifying
> code doesn't need to know or care that pagetables are RO.
> 
> When a pagetable is first created (either in execve or fork), the the
> Xen paravirt backend pins the pagetable, and conversely, on exit it is
> unpinned; this is done via the arch_dup_mmap() and activate_mm() hooks. 
> Pinning is done in two phases: first the pagetable pages are marked RO,
> and then the pagetable is registered with Xen; unpinning is the

To my naive mind, your problem actually lies in those two stages:
whatever marks the pages RO should not be keeping Xen in ignorance.

> opposite.  This works assuming that the pagetable is not in use, and not
> yet visible to other cpus.
> 
> The race on pagetable creation is this: in kernel/fork.c:dup_mmap(), it
> copies the old pagetable into the new one, and registers each vma with
> the rmap prio tree.  Once everything is copied, it calls
> arch_dup_mmap(), which ends up doing the Xen pagetable pin.  However,
> because the pagetable is visible to other cpus via the prio tree,
> pagetable modifications (specifically, clearing the access bit) can race
> with pinning.  If it hits between making the pagetable pages RO but
> before they're registered with Xen, modifications to the flags will
> fault, and Xen won't know to do the fixup.
> 
> The converse is also true in exit_mmap(): arch_exit_mmap is called
> before removing the vmas from the prio tree, so it can race with unpinning.
> 
[oops snipped]
> 
> It all worked OK before David's change, because asm-generic/pgtable.h
> uses set_pte_at(), which ends up making a hypercall to update the
> pagetable, which always works regardless of the state of the pagetable
> pages.

Except ptep_clear_flush_young() didn't use set_pte_at().

> 
> It seems to me that there are a few ways to fix this:
> 
>    1. Use asm-generic/pgtable.h when CONFIG_PARAVIRT is enabled.  This
>       will clearly work, but is pretty blunt.

No.  The asm-generic/pgtable.h version of ptep_test_and_clear_young()
does set_pte_at((__vma)->vm_mm, (__address), (__ptep), pte_mkold(__pte)),
which may be nice for Xen, but is dangerously racy on i386 SMP (I hope
it's not racy on the other architectures using it...): it's in danger
of losing the dirty bit if that gets set in userspace in between us
reading __pte and setting the pte_mkold version of __pte.  There's
no issue if we were to lose the young bit while setting the dirty
bit, but losing the dirty in setting the young is a no no.

>    2. Make test_and_clear_pte_flags a new paravirt-op, which can be
>       implemented in Xen as a hypercall, and as a raw test_and_clear_bit
>       for everyone else.  The downside is adding yet another pv-op.

Maybe (if this turns out to be more than just a muddle over pagetable
locking).  But note that you have a problem, not just with the
ptep_clear_flush_young from page_referenced_one, but also with the
ptep_clear_flush (which ends up using native_ptep_get_and_clear on
i386 I think) from try_to_unmap_one: you just won't hit that one
as often as the page_referenced_one case.

Anything in include/asm-i386/pgtable.h which uses pte_update or
pte_update_defer ought to be considered; but I expect that you'll
find all the other instances are only used from safe contexts,
which cannot race with yours.  The pte_update comes after the op
that concerns you: maybe there should be a pte_about_to_update
just before, to handle your case?

>    3. Restructure the pagetable setup code so that the mm is not added
>       to the prio tree until after arch_dup_mmap has been called (and
>       the converse for exit_mmap).  This is arguably cleaner, but I
>       haven't looked to see how much trouble this would be.

No.  It is intentional that we make those ptes visible as early as
possible, so that concurrent pageout (and less importantly swapoff)
has the best chance of finding all references to a page (or swap ent).
If they only became visible at the final arch_dup_mmap stage, then
it might become impossible to fork a large well-populated mm, if it
contains those very pages which need to be freed to make space to
allocate pagetables for the child.

Hugh

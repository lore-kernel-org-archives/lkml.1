Return-Path: <linux-kernel-owner+w=401wt.eu-S1763876AbXJETkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763876AbXJETkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759784AbXJETjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:39:54 -0400
Received: from gw.goop.org ([64.81.55.164]:42745 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759232AbXJETjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:39:53 -0400
Message-ID: <470692FE.6070203@goop.org>
Date: Fri, 05 Oct 2007 12:39:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: David Rientjes <rientjes@google.com>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Keir Fraser <keir@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
References: <470596C4.8060804@goop.org> <Pine.LNX.4.64.0710051146300.25518@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0710051146300.25518@blonde.wat.veritas.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> I see the discussion has somehow moved on to pagetable locking -
> mysterious because the word "lock" never once appears in your
> otherwise very helpful elucidation below, for which many thanks.
>   

It has to be taken with a grain of salt.  The reason "lock" isn't
mentioned is because I mis-analyzed the situation, and overlooked that
page_referenced_one does actually take the pte's lock.

> Maybe what I have to add is now of historical interest only, or none,
> but I was prevented from answering your original mail earlier...
>
> On Thu, 4 Oct 2007, Jeremy Fitzhardinge wrote:
>
>   
>> David's change 10a8d6ae4b3182d6588a5809a8366343bc295c20, "i386: add
>> ptep_test_and_clear_{dirty,young}" has introduced an SMP race which
>> affects the Xen pv-ops backend.
>>     
>
> I think that race with Xen has been there all along, not introduced
> by David's commit.  Take a look at ptep_clear_flush_young() in the
> 2.6.21 include/asm-i386/pgtable.h, it looks equally a problem to me.
>   

Yes, but I don't think its a problem with correct locking.  set_pte_at
is a red herring.

>> When a pagetable is first created (either in execve or fork), the the
>> Xen paravirt backend pins the pagetable, and conversely, on exit it is
>> unpinned; this is done via the arch_dup_mmap() and activate_mm() hooks. 
>> Pinning is done in two phases: first the pagetable pages are marked RO,
>> and then the pagetable is registered with Xen; unpinning is the
>>     
>
> To my naive mind, your problem actually lies in those two stages:
> whatever marks the pages RO should not be keeping Xen in ignorance.
>   

No, its the Xen-specific kernel code which does the RO marking: it marks
the pagetables RO (using a hypercall to make the actual modifications),
and then tells the hypervisor to pin the whole pagetable.  It can't be
done atomically, so there's always a window between the two phases.

>> It all worked OK before David's change, because asm-generic/pgtable.h
>> uses set_pte_at(), which ends up making a hypercall to update the
>> pagetable, which always works regardless of the state of the pagetable
>> pages.
>>     
>
> Except ptep_clear_flush_young() didn't use set_pte_at().
>   

Yes, my mistake.

>>    3. Restructure the pagetable setup code so that the mm is not added
>>       to the prio tree until after arch_dup_mmap has been called (and
>>       the converse for exit_mmap).  This is arguably cleaner, but I
>>       haven't looked to see how much trouble this would be.
>>     
>
> No.  It is intentional that we make those ptes visible as early as
> possible, so that concurrent pageout (and less importantly swapoff)
> has the best chance of finding all references to a page (or swap ent).
> If they only became visible at the final arch_dup_mmap stage, then
> it might become impossible to fork a large well-populated mm, if it
> contains those very pages which need to be freed to make space to
> allocate pagetables for the child.

Hm, OK.

    J

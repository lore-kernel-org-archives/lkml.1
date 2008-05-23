Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbYEWX0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbYEWX0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 19:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYEWX0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 19:26:07 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:48802 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbYEWX0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 19:26:06 -0400
Subject: Re: [PATCH 0 of 4] mm+paravirt+xen: add pte
	read-modify-write	abstraction
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
In-Reply-To: <483729E7.9010002@goop.org>
References: <patchbomb.1211552448@localhost>
	 <1211567273.7465.36.camel@bodhitayantram.eng.vmware.com>
	 <483729E7.9010002@goop.org>
Content-Type: text/plain
Date: Fri, 23 May 2008 16:25:22 -0700
Message-Id: <1211585122.7465.70.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-23 at 21:32 +0100, Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
> > I'm a bit skeptical you can get such a semantic to work without a very
> > heavyweight method in the hypervisor.  How do you guarantee no other CPU
> > is fizzling the A/D bits in the page table (it can be done by hardware
> > with direct page tables), unless you use some kind of IPI?  Is this why
> > it is still 7x?
> >   
> 
> No, you just use cmpxchg.  It's pretty lightweight really.  Xen holds a 
> lock internally to stop other cpus from updating the pte in software, so 
> the only source of modification is the hardware itself; the cmpxchg loop 
> is guaranteed to terminate because the A/D bits can only transition from 
> 0->1.

Ah yes, you're not worried about invalidations.  You can actually do better using a lock; xor combination, which will allow you to flip any of the protection bits without looping (you are guaranteed on Linux not to have concurrent updates by the guest holding the pagetable lock).  It might fail for other guests though, and I'm not sure its any cheaper on modern processors (in fact, it wouldn't surprise me if Intel optimized cmpxchg so it was cheaper).

> >> I believe that other virtualization systems, whether they use direct
> >> paging like Xen, or a shadow pagetable scheme (vmi, kvm, lguest), can
> >> make use of this interface to improve the performance.
> >>     
> >
> > On VMI, we don't trap the xchg of the pte, thus we don't have any
> > bottleneck here to begin with.
> 
> If you're doing code rewriting then I guess you can effectively do the 
> same trick at that point.  If not, then presumably you take a fault for 
> the first pte updated in the mprotect and then sync the shadow up when 
> the tlb flush happens; batching that trap and the tlb flush would give 
> you some benefit for small mprotects.

We don't fault.  We write directly to the primary page tables, and clear
the pte just like native.  We just issue all mprotect updates in the
queue, and flush the queue when leaving lazy mmu mode.  You can't wait
for the TLB flush, you must flush the updates before releasing the
pagetable lock, or you could get misordered updates in an SMP system.

A/D bits are propagated from shadow to primary by getting page faults on
an access that would set an A/D bit in hardware; if we get a page fault
for what would be an A/D bit update in the window where the primary PTE
has been cleared, we convert it to a guest fault (just as native
hardware would).  Linux is already prepared to handle these spurious
faults by revalidating the mapping.

Zach


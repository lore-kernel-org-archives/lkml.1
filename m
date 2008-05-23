Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbYEWOZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbYEWOZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbYEWOZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:25:42 -0400
Received: from gw.goop.org ([64.81.55.164]:48103 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287AbYEWOZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:25:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 4] mm+paravirt+xen: add pte read-modify-write abstraction
Message-Id: <patchbomb.1211552448@localhost>
Date: Fri, 23 May 2008 15:20:48 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This little series adds a new transaction-like abstraction for doing
RMW updates to a pte, hooks it into paravirt_ops, and then makes use
of it in Xen.

The basic problem is that mprotect is very slow under Xen (up to 50x
slower than native), primarily because of the

	ptent = ptep_get_and_clear(mm, addr, pte);
	ptent = pte_modify(ptent, newprot);
	/* ... */
	set_pte_at(mm, addr, pte, ptent);

sequence in mm/mprotect.c:change_pte_range().

This is bad for Xen for two reasons:

  1: ptep_get_and_clear() ends up being a xchg on the pte.  Since the
     pte page is read-only (as it must be, because Xen needs to
     control all pte updates), this traps into Xen, which then
     emulates the instruction.  Trapping into the instruction emulator
     is inherently fairly expensive.  And,

  2: because ptep_get_and_clear has atomic-fetch-and-update semantics,
     it's impossible to implement in a way which can be batched to amortize
     the cost of faulting into the hypervisor.

This series adds the pte_rmw_start() and pte_rmw_commit() operations,
which change this sequence to:

	ptent = pte_rmw_start(mm, addr, pte);
	ptent = pte_modify(ptent, newprot);
	/* ... */
	pte_rmw_commit(mm, addr, pte, ptent);

Which looks very familiar.  And, indeed, when compiled without
CONFIG_PARAVIRT (or on a non-x86 architecture), it will end up doing
precisely the same thing as before.

However, the effective semantics are a bit different.  pte_rmw_start()
means "I'm reading this pte with the intention of updating it; please
don't lose any hardware pte changes in the meantime".  And
pte_rmw_commit() means "Here's a new value for the pte, but make sure
you don't lose any hardware changes".

The default implementation achieves these semantics by making
pte_rmw_start() set the pte to non-present, which prevents any async
hardware changes to the pte.  The pte_rmw_commit() can then just write
the new value into place without having to worry about preserving any
changes, because it knows there are none.

Xen implements pte_rmw_start() as a simple read of the pte.  This
leaves the pte unchanged in memory, and the hardware may make
asynchronous changes to it.  It implements pte_rmw_commit() using a
hypercall which preserves the state of the Access/Dirty bits to update
the pte.  This allows the whole change_pte_range() loop to be run
without any synchronous unbatched traps into the hypervisor.  With
this change in place, an mprotect microbenchmark goes from being 50x
worse than native to around 7x, which is acceptible.

I believe that other virtualization systems, whether they use direct
paging like Xen, or a shadow pagetable scheme (vmi, kvm, lguest), can
make use of this interface to improve the performance.

Unfortunately (or fortunately) there aren't very many other areas of
the kernel which can really take advantage of this.  There's only a
couple of other instances of ptep_get_and_clear() in mm/, and they're
being used in a similar way; but I don't think they're very
performance critical (though zap_pte_range might be interesting).

In general, mprotect is rarely a performance bottleneck.  But some
debugging libraries (such as electric fence) and garbage collectors
can be very heavy users of mprotect, and this change could materially
benefit them.

Thanks,
	J


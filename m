Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYEaAPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYEaAPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbYEaANi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:13:38 -0400
Received: from host217-43-228-68.range217-43.btcentralplus.com ([217.43.228.68]:34077
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753584AbYEaANd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:13:33 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 4] mm+paravirt+xen: add pte read-modify-write abstraction
	(take 2)
Message-Id: <patchbomb.1212192268@localhost>
Date: Sat, 31 May 2008 01:04:28 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
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

[ Change since last post: change name to ptep_modify_prot_, on the
  grounds that it isn't really a general pte-modification interface. ]

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
     is inherently expensive.  And,

  2: because ptep_get_and_clear has atomic-fetch-and-update semantics,
     it's impossible to implement in a way which can be batched to
     amortize the cost of trapping into the hypervisor.

This series adds the ptep_modify_prot_start() and
ptep_modify_prot_commit() operations, which change this sequence to:

	ptent = ptep_modify_prot_start(mm, addr, pte);
	ptent = pte_modify(ptent, newprot);
	/* ... */
	ptep_modify_prot_commit(mm, addr, pte, ptent);

Which looks very familiar.  And, indeed, when compiled without
CONFIG_PARAVIRT (or on a non-x86 architecture), it will end up doing
precisely the same thing as before.

However, the effective semantics are a bit different.
ptep_modify_prot_start() means "I'm reading this pte with the
intention of updating it; please don't lose any hardware pte changes
in the meantime".  And ptep_modify_prot_commit() means "Here's a new
value for the pte, but make sure you don't lose any hardware changes".

The default implementation achieves these semantics by making
ptep_modify_prot_start() set the pte to non-present, which prevents
any async hardware changes to the pte.  The ptep_modify_prot_commit()
can then just write the new value into place without having to worry
about preserving any changes, because it knows there are none.

Xen implements ptep_modify_prot_start() as a simple read of the pte.
This leaves the pte unchanged in memory, and the hardware may make
asynchronous changes to it.  It implements ptep_modify_prot_commit()
using a batched hypercall which preserves the state of the
Access/Dirty bits when updating the pte.  This allows the whole
change_pte_range() loop to be run without any synchronous unbatched
traps into the hypervisor.  With this change in place, an mprotect
microbenchmark goes from being 50x worse than native to around 7x,
which is acceptible.

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


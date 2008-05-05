Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbYEERPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbYEERPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYEEROt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:14:49 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:45736
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbYEEROh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:14:37 -0400
Date: Mon, 5 May 2008 19:14:34 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Jack Steiner <steiner@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 01 of 11] mmu-notifier-core
Message-ID: <20080505171434.GF8470@duo.random>
References: <patchbomb.1209740703@duo.random> <1489529e7b53d3f2dab8.1209740704@duo.random> <20080505162113.GA18761@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505162113.GA18761@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 11:21:13AM -0500, Jack Steiner wrote:
> The GRU does the registration/deregistration of mmu notifiers from mmap/munmap.
> At this point, the mmap_sem is already held writeable. I hit a deadlock
> in mm_lock.

It'd been better to know about this detail earlier, but frankly this
is a minor problem, the important thing is we all agree together on
the more difficult parts ;).

> A quick fix would be to do one of the following:
> 
> 	- move the mmap_sem locking to the caller of the [de]registration routines.
> 	  Since the first/last thing done in mm_lock/mm_unlock is to
> 	  acquire/release mmap_sem, this change does not cause major changes.

I don't like this solution very much. Nor GRU nor KVM will call
mmu_notifier_register inside the mmap_sem protected sections, so I
think the default mmu_notifier_register should be smp safe by itself
without requiring additional locks to be artificially taken externally
(especially because the need for mmap_sem in write mode is a very
mmu_notifier internal detail).

> 	- add a flag to mmu_notifier_[un]register routines to indicate
> 	  if mmap_sem is already locked.

The interface would change like this:

#define MMU_NOTIFIER_REGISTER_MMAP_SEM (1<<0)
void mmu_notifier_register(struct mmu_notifier *mn, struct mm_struct *mm,
			   unsigned long mmu_notifier_flags);

A third solution is to add:

/*
 * This must can be called instead of mmu_notifier_register after
 * taking the mmap_sem in write mode (read mode isn't enough).
 */
void __mmu_notifier_register(struct mmu_notifier *mn, struct mm_struct *mm);

Do you still prefer the bitflag or you prefer
__mmu_notifier_register. It's ok either ways, except
__mmu_notifier_reigster could be removed in a backwards compatible
way, the bitflag can't.

> I've temporarily deleted the mm_lock locking of mmap_sem and am continuing to
> test. More later....

Sure! In the meantime go ahead this way.

Another very minor change I've been thinking about is to make
->release not mandatory. It happens that with KVM ->release isn't
strictly required because after mm_users reaches 0, no guest could
possibly run anymore. So I'm using ->release only for debugging by
placing -1UL in the root shadow pagetable, to be sure ;). So because
at least one user won't strictly require ->release being consistent in
having all method optional may be nicer. Alternatively we could make
them all mandatory and if somebody doesn't need one of the methods it
should implement it as a dummy function. Both ways have pros and cons,
but they don't make any difference to us in practice. If I've to
change the patch for the mmap_sem taken during registration I may as
well cleanup this minor bit.

Also note the rculist.h patch you sent earlier won't work against
mainline so I can't incorporate it in my patchset, Andrew will have to
apply it as mmu-notifier-core-mm after incorporating mmu-notifier-core
into -mm.

Until a new update is released, mmu-notifier-core v15 remains ok for
merging, no known bugs, here we're talking about a new and simple
feature and a tiny cleanup that nobody can notice anyway.

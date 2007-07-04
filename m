Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbXGDHc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbXGDHc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 03:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXGDHcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 03:32:20 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:33236 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbXGDHcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 03:32:19 -0400
Subject: Re: [patch 5/5] s390 tlb flush fix.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Hugh Dickins <hugh@veritas.com>
Cc: akpm@linux-foundation.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0707031921270.8155@blonde.wat.veritas.com>
References: <20070703111822.418649776@de.ibm.com>
	 <20070703121229.180281096@de.ibm.com>
	 <Pine.LNX.4.64.0707031921270.8155@blonde.wat.veritas.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 04 Jul 2007 09:34:34 +0200
Message-Id: <1183534474.1208.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 19:58 +0100, Hugh Dickins wrote:
> On Tue, 3 Jul 2007, Martin Schwidefsky wrote:
> > +
> > +static inline struct mmu_gather *tlb_gather_mmu(struct mm_struct *mm,
> > +						unsigned int full_mm_flush)
> > +{
> > +	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
> > +
> > +	tlb->mm = mm;
> > +	tlb->fullmm = full_mm_flush || (num_online_cpus() == 1) ||
> > +		(atomic_read(&mm->mm_users) <= 1);
> > +	tlb->nr_ptes = 0;
> > +	tlb->nr_pmds = TLB_NR_PTRS;
> > +	if (tlb->fullmm)
> > +		__tlb_flush_mm(mm);
> > +	return tlb;
> > +}
> 
> I'm afraid that mm_users test (and probably some of your other
> mm_users tests) is not good: because this also gets called when
> a file is truncated while it is mapped - the active mm at that
> time is likely not to be one of the mm_users.  (Do any other
> arches use mm_users in that way?  No: that should be a warning.)

Good catch, that would have caused me some headache. So I need to add a
current->active_mm==mm check if mm_users==1.

> You might do better to make more use of cpu_vm_mask (though I
> didn't see where any bits get cleared from it on s390 at present).

We don't clear any of the bits in cpu_vm_mask. I though about it for a
while and got tangled in race conditions. The cpu_vm_mask optimization
works for short-lived processes which always executed on the same cpu.

> Though it seems sensible to aim for one TLB flush at the beginning
> as you're doing, that's not what other arches do (some have to
> worry about speculative execution, but you don't?), and it
> worries me that you're taking s390 further away into its own
> implementation: which you're surely entitled to do, but then
> we're more likely to screw you over by mistake in future.

We do not have to worry about speculative execution because s390 uses
special instruction to do user access (mvcs, mvcp and mvcos) and the
kernel has its own address space. The compiler doesn't know about these
instruction and cannot "accidentally" access a user space address over
the user page table when it shouldn't.

> Is there perhaps another architecture whose procedures you
> can copy?  Changing a pte while another cpu is accessing it
> is not a problem unique to s390.

No, I don't think so. s390 is quite unique with the restriction that you
may not do a set_pte_at .. flush_tlb_xxx while a pte might get accessed
by a different cpu.

> Patches 1-4 looked fine to me, but I believe this 5/5
> is the rationale behind all of them.

Yes, indeed the tlb flush fix and the 1K/2K page tables are my reasons
for all these patches.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.



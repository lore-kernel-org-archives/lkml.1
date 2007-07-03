Return-Path: <linux-kernel-owner+w=401wt.eu-S1759759AbXGCS7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759759AbXGCS7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 14:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632AbXGCS7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 14:59:09 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42823 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759360AbXGCS7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 14:59:08 -0400
Date: Tue, 3 Jul 2007 19:58:19 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: akpm@linux-foundation.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 5/5] s390 tlb flush fix.
In-Reply-To: <20070703121229.180281096@de.ibm.com>
Message-ID: <Pine.LNX.4.64.0707031921270.8155@blonde.wat.veritas.com>
References: <20070703111822.418649776@de.ibm.com> <20070703121229.180281096@de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBsaW51eC1tbUBrdmFjay5vcmcAcGV0ZXJ6QGluZnJhZGVhZC5vcmcAc2Nod2lkZWZza3lAZGUuaWJtLmNvbQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Martin Schwidefsky wrote:
> +
> +static inline struct mmu_gather *tlb_gather_mmu(struct mm_struct *mm,
> +						unsigned int full_mm_flush)
> +{
> +	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
> +
> +	tlb->mm = mm;
> +	tlb->fullmm = full_mm_flush || (num_online_cpus() == 1) ||
> +		(atomic_read(&mm->mm_users) <= 1);
> +	tlb->nr_ptes = 0;
> +	tlb->nr_pmds = TLB_NR_PTRS;
> +	if (tlb->fullmm)
> +		__tlb_flush_mm(mm);
> +	return tlb;
> +}

I'm afraid that mm_users test (and probably some of your other
mm_users tests) is not good: because this also gets called when
a file is truncated while it is mapped - the active mm at that
time is likely not to be one of the mm_users.  (Do any other
arches use mm_users in that way?  No: that should be a warning.)

You might do better to make more use of cpu_vm_mask (though I
didn't see where any bits get cleared from it on s390 at present).

Though it seems sensible to aim for one TLB flush at the beginning
as you're doing, that's not what other arches do (some have to
worry about speculative execution, but you don't?), and it
worries me that you're taking s390 further away into its own
implementation: which you're surely entitled to do, but then
we're more likely to screw you over by mistake in future.

Is there perhaps another architecture whose procedures you
can copy?  Changing a pte while another cpu is accessing it
is not a problem unique to s390.

Patches 1-4 looked fine to me, but I believe this 5/5
is the rationale behind all of them.

Hugh

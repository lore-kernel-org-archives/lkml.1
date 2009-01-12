Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbZALXBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbZALXBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZALXBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:01:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36197 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZALXBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:01:02 -0500
Date: Tue, 13 Jan 2009 00:00:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>, andi@firstfloor.org,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090112230052.GB18771@elte.hu>
References: <20090112213539.GA10720@gambetta> <20090112223421.GA20594@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112223421.GA20594@localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> Hi Frederik,
> 
> On Mon, Jan 12, 2009 at 10:35:42PM +0100, Frederik Deweerdt wrote:
> >
> >Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
> >
> >diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
> >index f8be6f1..c177a1f 100644
> >--- a/arch/x86/kernel/tlb_64.c
> >+++ b/arch/x86/kernel/tlb_64.c
> >@@ -33,7 +33,7 @@
> >  *	To avoid global state use 8 different call vectors.
> >  *	Each CPU uses a specific vector to trigger flushes on other
> >  *	CPUs. Depending on the received vector the target CPUs look into
> >- *	the right per cpu variable for the flush data.
> >+ *	the right array slot for the flush data.
> >  *
> >  *	With more than 8 CPUs they are hashed to the 8 available
> >  *	vectors. The limited global vector space forces us to this right now.
> >@@ -54,7 +54,7 @@ union smp_flush_state {
> > /* State is put into the per CPU data section, but padded
> >    to a full cache line because other CPUs can access it and we don't
> >    want false sharing in the per cpu data segment. */
> >-static DEFINE_PER_CPU(union smp_flush_state, flush_state);
> >+static union smp_flush_state flush_state[NUM_INVALIDATE_TLB_VECTORS];
> 
> Since flush_state has a spinlock, an array of flush_states would end up 
> having multiples spinlocks on the same L1 cacheline.  However, I see 
> that the union smp_flush_state is already padded to SMP_CACHE_BYTES.

Correct.

> With per-cpu areas, locks belonging to different array elements did not 
> end up on the same internode cacheline due to per-node allocation of 
> per-cpu areas, but with a simple array, two locks could end up on the 
> same internode cacheline.
> 
> Hence, can you please change the padding in smp_flush_state to 
> INTERNODE_CACHE_BYTES (you have to derive this off 
> INTERNODE_CACHE_SHIFT) and align it using 
> ____cacheline_internodealigned_in_smp?

Yes, that matters to vsmp, which has ... 4K node cache-lines.

Note that there's already CONFIG_X86_INTERNODE_CACHE_BYTES which is set 
properly on vsmp.

So ... something like the commit below?

	Ingo

--------------->
>From 23d9dc8bffc759c131b09a48b5215cc2b37a5ac3 Mon Sep 17 00:00:00 2001
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Date: Mon, 12 Jan 2009 22:35:42 +0100
Subject: [PATCH] x86, tlb flush_data: replace per_cpu with an array

Impact: micro-optimization, memory reduction

On x86_64 flush tlb data is stored in per_cpu variables. This is
unnecessary because only the first NUM_INVALIDATE_TLB_VECTORS entries
are accessed.

This patch aims at making the code less confusing (there's nothing
really "per_cpu") by using a plain array. It also would save some memory
on most distros out there (Ubuntu x86_64 has NR_CPUS=64 by default).

[ Ravikiran G Thirumalai also pointed out that the correct alignment
  is ____cacheline_internodealigned_in_smp, so that there's no
  bouncing on vsmp. ]

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tlb_64.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index f8be6f1..c5a6c6f 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -33,7 +33,7 @@
  *	To avoid global state use 8 different call vectors.
  *	Each CPU uses a specific vector to trigger flushes on other
  *	CPUs. Depending on the received vector the target CPUs look into
- *	the right per cpu variable for the flush data.
+ *	the right array slot for the flush data.
  *
  *	With more than 8 CPUs they are hashed to the 8 available
  *	vectors. The limited global vector space forces us to this right now.
@@ -48,13 +48,13 @@ union smp_flush_state {
 		unsigned long flush_va;
 		spinlock_t tlbstate_lock;
 	};
-	char pad[SMP_CACHE_BYTES];
-} ____cacheline_aligned;
+	char pad[X86_INTERNODE_CACHE_BYTES];
+} ____cacheline_internodealigned_in_smp;
 
 /* State is put into the per CPU data section, but padded
    to a full cache line because other CPUs can access it and we don't
    want false sharing in the per cpu data segment. */
-static DEFINE_PER_CPU(union smp_flush_state, flush_state);
+static union smp_flush_state flush_state[NUM_INVALIDATE_TLB_VECTORS];
 
 /*
  * We cannot call mmdrop() because we are in interrupt context,
@@ -129,7 +129,7 @@ asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
 	 * Use that to determine where the sender put the data.
 	 */
 	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
-	f = &per_cpu(flush_state, sender);
+	f = &flush_state[sender];
 
 	if (!cpu_isset(cpu, f->flush_cpumask))
 		goto out;
@@ -169,7 +169,7 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 
 	/* Caller has disabled preemption */
 	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
-	f = &per_cpu(flush_state, sender);
+	f = &flush_state[sender];
 
 	/*
 	 * Could avoid this lock when
@@ -205,8 +205,8 @@ static int __cpuinit init_smp_flush(void)
 {
 	int i;
 
-	for_each_possible_cpu(i)
-		spin_lock_init(&per_cpu(flush_state, i).tlbstate_lock);
+	for (i = 0; i < ARRAY_SIZE(flush_state); i++)
+		spin_lock_init(&flush_state[i].tlbstate_lock);
 
 	return 0;
 }

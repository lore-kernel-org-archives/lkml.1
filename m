Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbZBORlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbZBORlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 12:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbZBORlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 12:41:36 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46135 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186AbZBORlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 12:41:35 -0500
Subject: Re: x86: unify genapic code, unify subarchitectures, remove
	old	subarchitecture code
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       hpa <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <498F0ED9.1080906@goop.org>
References: <1234102566.4244.7.camel@localhost.localdomain>
	 <498F0ED9.1080906@goop.org>
Content-Type: text/plain
Date: Sun, 15 Feb 2009 11:41:32 -0600
Message-Id: <1234719693.3299.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-08 at 08:56 -0800, Jeremy Fitzhardinge wrote:
> James Bottomley wrote:
> > The other big problem is mm/tlb.c.  This directly uses genapic with 8
> > vectors which is impossible for voyager: the QIC only has 8 separate IPI
> > vectors for everything.  The two alternatives which spring to mind are
> > either to rebase mm/tlb.c on top of smp_call_function.  This would add a
> > small amount to the critical path, but would also allow vector scaling
> > beyond the current 8 IPI vectors to a per processor number (i.e. might
> > scale better beyond 8 cores).
> 
> I floated an experimental patch to do just that last year.  There were 
> concerns because it had a pretty significantly hit on the performance of 
> tlb-heavy benchmarks; and since then a multicast smp_call_function ends 
> up kmallocing, which probably won't help matters. 

Agree this is a nasty problem.   However, I can't see any reason why
smp_call_function_many() needs to allocate in the wait case ... and the
tlb flushing code would be using the wait case.  What about this fix to
the generic SMP code (cc'd Jens) that would allow us to take on stack
data and the fast path all the time?

By the way, I can see us building up stack runoff danger for the large
CPU machines, so the on stack piece could be limited to a maximal CPU
cap beyond which it has to kmalloc ... the large CPU machines would
still probably pick up scaling benefits in that case ... thoughts?

>  I got called away to 
> other things before really exploring all the options here, so it may 
> well be worth reviving that work.
> 
> >   Or to keep voyager separate and move
> > pieces of paravirt ops (or rather a separated piece of pv_ops) into
> > smp_ops to effect the separation. 
> 
> This should be easy since you can can hook all the tlb operations via 
> pv_mmu_ops.  And to avoid duplicating a lot of similar-looking code, you 
> could just do a generic smp_call_function-based version.

Yes ... will do.  If we can't make the unified non-IPI version work fast
enough, then both of us can share the call function version.

James

---

diff --git a/kernel/smp.c b/kernel/smp.c
index 5cfa0e5..ca58ca3 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -294,6 +294,10 @@ void smp_call_function_many(const struct cpumask *mask,
 	struct call_function_data *data;
 	unsigned long flags;
 	int cpu, next_cpu;
+	struct {
+		struct call_function_data d;
+		unsigned long c[BITS_TO_LONGS(NR_CPUS)];
+	} stack_data;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
@@ -317,7 +321,10 @@ void smp_call_function_many(const struct cpumask *mask,
 		return;
 	}
 
-	data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
+	if (wait)
+		data = &stack_data.d;
+	else
+		data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
 	if (unlikely(!data)) {
 		/* Slow path. */
 		for_each_online_cpu(cpu) {



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbZERTDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbZERTDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZERTDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:03:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51584 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZERTDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:03:42 -0400
Date: Mon, 18 May 2009 21:03:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alexander Viro <viro@ftp.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20090518190320.GA20260@elte.hu>
References: <20090518142707.GA24142@elte.hu> <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain> <20090518164921.GA6903@elte.hu> <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain> <20090518170909.GA1623@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518170909.GA1623@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Mon, 18 May 2009, Ingo Molnar wrote:
> > > 
> > > hm - i've Cc:-ed Jeff & Viro. The background is that Sparse and LLVM 
> > > barfed on the current construct and Al strongly advocated this 
> > > solution, see:
> > 
> > I know the background.
> > 
> > Did you read my email?
> > 
> > Did you see my one-line patch that fixes the same problem WITHOUT 
> > THE INSANITY?
> 
> Yes, i even proposed that very patch in the original discussion, in 
> my first reply:
> 
>     http://lkml.org/lkml/2009/5/8/378

Something like the patch below. It also fixes ->span[] which has a 
similar problem.

But ... i think this needs further clean-ups really. Either go fully 
static, or go fully dynamic.

I'd suggest we go fully dynamic: the static structures are never 
used directly anyway, they are pointer-ized during sched domain 
setup.

The reason for this duality is allocation bootstrap: there's no 
generic early-capable allocator that allocates something and 
switches from bootmem to kmalloc transparently once the SLAB has 
been set up.

Would be nice if bootmem_alloc() was extended with such properties - 
if SLAB is up (and bootmem is down) it would return 
kmalloc(GFP_KERNEL) memory buffers.

	Ingo

-------------->
Subject: sched: properly define the sched_group::cpumask and sched_domain::span fields
From: Ingo Molnar <mingo@elte.hu>

Properly document the variable-size structure tricks we are doing
wrt. struct sched_group and sched_domain, and use the field[0] GCC
extension instead of defining a vla array.

Dont use unions for this, as pointed out by Linus.

This also un-confuses Sparse and LLVM.

Reported-by: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain>
Not-Yet-Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   25 ++++++++++++++++++++++---
 kernel/sched.c        |    5 +++--
 2 files changed, 25 insertions(+), 5 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -846,7 +846,17 @@ struct sched_group {
 	 */
 	u32 reciprocal_cpu_power;
 
-	unsigned long cpumask[];
+	/*
+	 * The CPUs this group covers.
+	 *
+	 * NOTE: this field is variable length. (Allocated dynamically
+	 * by attaching extra space to the end of the structure,
+	 * depending on how many CPUs the kernel has booted up with)
+	 *
+	 * It is also be embedded into static data structures at build
+	 * time. (See 'struct static_sched_group' in kernel/sched.c)
+	 */
+	unsigned long cpumask[0];
 };
 
 static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
@@ -932,8 +942,17 @@ struct sched_domain {
 	char *name;
 #endif
 
-	/* span of all CPUs in this domain */
-	unsigned long span[];
+	/*
+	 * Span of all CPUs in this domain.
+	 *
+	 * NOTE: this field is variable length. (Allocated dynamically
+	 * by attaching extra space to the end of the structure,
+	 * depending on how many CPUs the kernel has booted up with)
+	 *
+	 * It is also be embedded into static data structures at build
+	 * time. (See 'struct static_sched_domain' in kernel/sched.c)
+	 */
+	unsigned long span[0];
 };
 
 static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -8049,8 +8049,9 @@ int sched_smt_power_savings = 0, sched_m
 
 /*
  * The cpus mask in sched_group and sched_domain hangs off the end.
- * FIXME: use cpumask_var_t or dynamic percpu alloc to avoid wasting space
- * for nr_cpu_ids < CONFIG_NR_CPUS.
+ *
+ * ( See the the comments in include/linux/sched.h:struct sched_group
+ *   and struct sched_domain. )
  */
 struct static_sched_group {
 	struct sched_group sg;

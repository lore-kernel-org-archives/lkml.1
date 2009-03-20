Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbZCTNpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbZCTNpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbZCTNpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:45:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbZCTNpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:45:16 -0400
Subject: Re: [PATCH] lockdep: fix deadlock in lockdep_trace_alloc
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       "lkml," <linux-kernel@vger.kernel.org>
In-Reply-To: <20090320140753.307a3c7d@osiris.boeblingen.de.ibm.com>
References: <1237544000.24626.52.camel@twins>
	 <1237544798.24626.54.camel@twins>
	 <20090320140753.307a3c7d@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Mar 2009 14:45:00 +0100
Message-Id: <1237556700.24626.100.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 14:07 +0100, Heiko Carstens wrote:
> On Fri, 20 Mar 2009 11:26:38 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Heiko pointed out that checking for irqs_disabled() after we disable
> > them is quite pointless..
> > 
> > New patch below.
> > 
> > ---
> > Subject: lockdep: fix deadlock in lockdep_trace_alloc
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Fri Mar 20 11:24:21 CET 2009
> > 
> > Heiko reported that we grab the graph lock with irqs enabled.
> > 
> > Fix this by providing the same wrapper as all other lockdep entry
> > functions have.
> > 
> > Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  kernel/lockdep.c |   21 +++++++++++++++++++--
> >  1 file changed, 19 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6/kernel/lockdep.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/lockdep.c
> > +++ linux-2.6/kernel/lockdep.c
> > @@ -2258,7 +2258,7 @@ void trace_softirqs_off(unsigned long ip
> >  		debug_atomic_inc(&redundant_softirqs_off);
> >  }
> > 
> > -void lockdep_trace_alloc(gfp_t gfp_mask)
> > +static void __lockdep_trace_alloc(gfp_t gfp_mask)
> >  {
> >  	struct task_struct *curr = current;
> > 
> > @@ -2277,10 +2277,27 @@ void lockdep_trace_alloc(gfp_t gfp_mask)
> >  	if (!(gfp_mask & __GFP_FS))
> >  		return;
> > 
> > +	mark_held_locks(curr, RECLAIM_FS);
> > +}
> > +
> > +static void check_flags(unsigned long flags);
> > +
> > +void lockdep_trace_alloc(gfp_t gfp_mask)
> > +{
> > +	unsigned long flags;
> > +
> > +	if (unlikely(current->lockdep_recursion))
> > +		return;
> > +
> >  	if (DEBUG_LOCKS_WARN_ON(irqs_disabled()))
> >  		return;
> > 
> > -	mark_held_locks(curr, RECLAIM_FS);
> > +	raw_local_irq_save(flags);
> > +	check_flags(flags);
> > +	current->lockdep_recursion = 1;
> > +	__lockdep_trace_alloc(gfp_mask);
> > +	current->lockdep_recursion = 0;
> > +	raw_local_irq_restore(flags);
> 
> Hmm... still not working:

Its Friday for sure... :/

Actually reading the code helps, we should only do that IRQ check if its
a __GFP_FS allocation -- those should never be done with IRQs disabled.

So we need to pass the flags down and fudge in that.

---
Subject: lockdep: fix deadlock in lockdep_trace_alloc
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Mar 20 11:24:21 CET 2009

Heiko reported that we grab the graph lock with irqs enabled.

Fix this by providing the same wrapper as all other lockdep entry
functions have.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2258,7 +2258,7 @@ void trace_softirqs_off(unsigned long ip
 		debug_atomic_inc(&redundant_softirqs_off);
 }
 
-void lockdep_trace_alloc(gfp_t gfp_mask)
+static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
 {
 	struct task_struct *curr = current;
 
@@ -2277,12 +2277,29 @@ void lockdep_trace_alloc(gfp_t gfp_mask)
 	if (!(gfp_mask & __GFP_FS))
 		return;
 
-	if (DEBUG_LOCKS_WARN_ON(irqs_disabled()))
+	if (DEBUG_LOCKS_WARN_ON(raw_irqs_disabled_flags(flags)))
 		return;
 
 	mark_held_locks(curr, RECLAIM_FS);
 }
 
+static void check_flags(unsigned long flags);
+
+void lockdep_trace_alloc(gfp_t gfp_mask)
+{
+	unsigned long flags;
+
+	if (unlikely(current->lockdep_recursion))
+		return;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+	current->lockdep_recursion = 1;
+	__lockdep_trace_alloc(gfp_mask, flags);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+}
+
 static int mark_irqflags(struct task_struct *curr, struct held_lock *hlock)
 {
 	/*


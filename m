Return-Path: <linux-kernel-owner+w=401wt.eu-S1764933AbXLUAbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764933AbXLUAbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbXLUAbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:31:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51539 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbXLUAbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:31:06 -0500
Date: Fri, 21 Dec 2007 01:30:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trond.myklebust@fys.uio.no, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-ID: <20071221003035.GA10123@elte.hu>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org> <20071220145415.f737e7f3.akpm@linux-foundation.org> <20071220234759.GA29776@elte.hu> <20071220161934.0f55029a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220161934.0f55029a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 21 Dec 2007 00:47:59 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > >  		__raw_spin_lock(&die.lock);
> > >  		raw_local_save_flags(flags);
> > > -		die.lock_owner = smp_processor_id();
> > > +		die.lock_owner = raw_smp_processor_id();
> > 
> > we just disabled irqs with raw_local_save_flags().
> 
> <chases x86 spaghetti for a while>
> 
> raw_local_save_flags() doesn't disable interrupts?

argh. Indeed! (I wanted us to fix that misleading name eons ago, to 
*_save_flags_only(), but some stupid bikeshed painting discussion 
prevented it from ever happening.)

that should have been raw_local_irq_save(flags)!

but ... why is it done like that? Why do we first take the die.lock and 
disable interrupts afterwards? It's highly weird. 64-bit does it all 
correctly in traps_64.c, so unification will help us out - but so far 
perhaps the patch below we should do in 2.6.24?

	Ingo

------------>
Subject: x86: fix die() to not be preemptible
From: Ingo Molnar <mingo@elte.hu>

Andrew "Eagle Eye" Morton noticed that we use raw_local_save_flags()
instead of raw_local_irq_save(flags) in die().

do it correctly - and first disable interrupts, then take the spinlock.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/traps_32.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-x86.q/arch/x86/kernel/traps_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/traps_32.c
+++ linux-x86.q/arch/x86/kernel/traps_32.c
@@ -373,14 +373,13 @@ void die(const char * str, struct pt_reg
 
 	if (die.lock_owner != raw_smp_processor_id()) {
 		console_verbose();
+		raw_local_irq_save(flags);
 		__raw_spin_lock(&die.lock);
-		raw_local_save_flags(flags);
 		die.lock_owner = smp_processor_id();
 		die.lock_owner_depth = 0;
 		bust_spinlocks(1);
-	}
-	else
-		raw_local_save_flags(flags);
+	} else
+		raw_local_irq_save(flags);
 
 	if (++die.lock_owner_depth < 3) {
 		unsigned long esp;

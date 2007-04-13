Return-Path: <linux-kernel-owner+w=401wt.eu-S1030889AbXDMX0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030889AbXDMX0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1160999AbXDMX0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:26:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43687 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030889AbXDMX0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:26:01 -0400
Date: Sat, 14 Apr 2007 01:25:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413232550.GB15894@elte.hu>
References: <20070413202100.GA9957@elte.hu> <46200D47.70108@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46200D47.70108@googlemail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gabriel C <nix.or.die@googlemail.com> wrote:

> > as usual, any sort of feedback, bugreports, fixes and suggestions 
> > are more than welcome,
> 
> Compile error here.

ah, !CONFIG_SMP. Does the patch below do the trick for you? (I've also 
updated the full patch at the cfs-scheduler URL)

	Ingo

----------------------->
From: Ingo Molnar <mingo@elte.hu>
Subject: [cfs] fix !CONFIG_SMP build

fix the !CONFIG_SMP build error reported by Gabriel C

Signed-off-by: Ingo Molnar <mingo@elte.hu>

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -257,16 +257,6 @@ static inline unsigned long long __rq_cl
 	return rq->rq_clock;
 }
 
-static inline unsigned long long rq_clock(struct rq *rq)
-{
-	int this_cpu = smp_processor_id();
-
-	if (this_cpu == rq->cpu)
-		return __rq_clock(rq);
-
-	return rq->rq_clock;
-}
-
 static inline int cpu_of(struct rq *rq)
 {
 #ifdef CONFIG_SMP
@@ -276,6 +266,16 @@ static inline int cpu_of(struct rq *rq)
 #endif
 }
 
+static inline unsigned long long rq_clock(struct rq *rq)
+{
+	int this_cpu = smp_processor_id();
+
+	if (this_cpu == cpu_of(rq))
+		return __rq_clock(rq);
+
+	return rq->rq_clock;
+}
+
 /*
  * The domain tree (rq->sd) is protected by RCU's quiescent state transition.
  * See detach_destroy_domains: synchronize_sched for details.

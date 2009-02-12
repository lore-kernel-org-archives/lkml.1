Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbZBLKvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbZBLKvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbZBLKux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:50:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41277 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbZBLKuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:50:52 -0500
Date: Thu, 12 Feb 2009 11:50:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: [patch] sched: cpu hotplug fix
Message-ID: <20090212105027.GA12474@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere> <20090212081801.GA22979@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212081801.GA22979@elte.hu>
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


The fix below addresses a lockdep warning i triggered with your config.

(You could hit this if you try to use s2ram or hibernation or explicit
CPU hotplug ops.)

	Ingo

-------------->
Subject: sched: cpu hotplug fix
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Feb 12 11:35:40 CET 2009

rq_attach_root() does a kfree() with the runqueue lock held.

That's not a very wise move, fix it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -7619,20 +7619,26 @@ static void free_rootdomain(struct root_
 
 static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 {
+	struct root_domain *old_rd = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rq->lock, flags);
 
 	if (rq->rd) {
-		struct root_domain *old_rd = rq->rd;
+		old_rd = rq->rd;
 
 		if (cpumask_test_cpu(rq->cpu, old_rd->online))
 			set_rq_offline(rq);
 
 		cpumask_clear_cpu(rq->cpu, old_rd->span);
 
-		if (atomic_dec_and_test(&old_rd->refcount))
-			free_rootdomain(old_rd);
+		/*
+		 * If we dont want to free the old_rt yet then
+		 * set old_rd to NULL to skip the freeing later
+		 * in this function:
+		 */
+		if (!atomic_dec_and_test(&old_rd->refcount))
+			old_rd = NULL;
 	}
 
 	atomic_inc(&rd->refcount);
@@ -7643,6 +7649,9 @@ static void rq_attach_root(struct rq *rq
 		set_rq_online(rq);
 
 	spin_unlock_irqrestore(&rq->lock, flags);
+
+	if (old_rd)
+		free_rootdomain(old_rd);
 }
 
 static int __init_refok init_rootdomain(struct root_domain *rd, bool bootmem)


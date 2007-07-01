Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbXGAIpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbXGAIpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 04:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbXGAIpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 04:45:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56928 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbXGAIpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 04:45:18 -0400
Date: Sun, 1 Jul 2007 10:45:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070701084501.GA10548@elte.hu>
References: <20070622220202.GA16872@elte.hu> <20070630210649.GA13186@1wt.eu> <20070701083102.GA4499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701083102.GA4499@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Willy,

could you check whether your current v18 CFS tree has the fix below 
included? I discovered it right after having released v18 so i updated 
the v18 files in place - but maybe you downloaded an early version? I 
thought it's relatively harmless, that it would only affect SCHED_IDLE 
tasks, but maybe it affects nice +19 tasks too on your box!

	Ingo

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -342,8 +342,9 @@ update_stats_enqueue(struct cfs_rq *cfs_
 		s64 tmp;
 
 		if (se->wait_runtime < 0) {
-			tmp = (0 - se->wait_runtime) << NICE_0_SHIFT;
-			key += (tmp * se->load.inv_weight) >> WMULT_SHIFT;
+			tmp = -se->wait_runtime;
+			key += (tmp * se->load.inv_weight) >>
+					(WMULT_SHIFT - NICE_0_SHIFT);
 		} else {
 			tmp = se->wait_runtime * se->load.weight;
 			key -= tmp >> NICE_0_SHIFT;

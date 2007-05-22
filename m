Return-Path: <linux-kernel-owner+w=401wt.eu-S1760377AbXEVUL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377AbXEVUL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbXEVULU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:11:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34046 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936AbXEVULT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:11:19 -0400
Date: Tue, 22 May 2007 22:10:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Anant Nitya <kernel@prachanda.info>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] local_softirq_pending storm
Message-ID: <20070522201046.GA6113@elte.hu>
References: <200705091942.22920.kernel@prachanda.hub> <200705191525.28400.kernel@prachanda.hub> <1179601868.12981.127.camel@chaos> <200705200253.44992.kernel@prachanda.hub> <1179697388.6570.26.camel@chaos> <6bffcb0e0705221203s1ba21ed3j641e91036859db7d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0705221203s1ba21ed3j641e91036859db7d@mail.gmail.com>
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


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Bad news - I hit a bug in 2.6.22-rc2-hrt3. Bug symptoms:
> - X hangs (keyboard, mouse, sound etc.)
> - only Magic SysRq works

please try the patch below! I think we have nailed this bug.

	Ingo

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4212,9 +4212,7 @@ int __sched cond_resched_softirq(void)
 	BUG_ON(!in_softirq());
 
 	if (need_resched() && system_state == SYSTEM_RUNNING) {
-		raw_local_irq_disable();
-		_local_bh_enable();
-		raw_local_irq_enable();
+		local_bh_enable();
 		__cond_resched();
 		local_bh_disable();
 		return 1;

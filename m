Return-Path: <linux-kernel-owner+w=401wt.eu-S1761534AbXEVGXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534AbXEVGXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 02:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbXEVGXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 02:23:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59203 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955AbXEVGXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 02:23:13 -0400
Date: Tue, 22 May 2007 08:22:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: bad networking related lag in v2.6.22-rc2
Message-ID: <20070522062233.GA20002@elte.hu>
References: <20070517174533.GA538@elte.hu> <465208D2.6070409@trash.net> <46520F77.5000408@trash.net> <200705221147.56571.kernel@prachanda.hub>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705221147.56571.kernel@prachanda.hub>
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


* Anant Nitya <kernel@prachanda.info> wrote:

> > I think I already found the bug, please try if this patch helps.
> 
> Sorry, but this patch is not helping here. I recompiled the kernel 
> with this patch but same load pattern still make system to crawl.
> 
> Here is the link for script I use to shape traffic.
> 
> http://cybertek.info/taitai/adslbwopt.sh

could you also apply the fix for the softirq problem below, to make sure 
it does not interact?

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

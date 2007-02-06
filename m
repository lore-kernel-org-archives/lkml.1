Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbXBFQsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbXBFQsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbXBFQse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:48:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51277 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbXBFQsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:48:33 -0500
Date: Tue, 6 Feb 2007 17:48:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mattia Dongili <malattia@linux.it>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, netdev@vger.kernel.org,
       netfilter-devel@lists.netfilter.org
Subject: Re: dynticks + iptables almost stops the boot process [was: Re: 2.6.20-rc6-mm3]
Message-ID: <20070206164826.GA3491@elte.hu>
References: <20070129204528.eb8d695e.akpm@osdl.org> <20070131215241.GB2890@inferi.kami.home> <20070131232130.GC4137@inferi.kami.home> <1170358572.29240.292.camel@localhost.localdomain> <1170360101.29240.297.camel@localhost.localdomain> <20070201211137.GA2830@inferi.kami.home> <1170369202.29240.339.camel@localhost.localdomain> <20070202191802.GA4262@inferi.kami.home> <1170448034.29240.364.camel@localhost.localdomain> <20070202204344.GB4262@inferi.kami.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202204344.GB4262@inferi.kami.home>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Mattia,

* Mattia Dongili <malattia@linux.it> wrote:

> > I have it halfways reproducible now and I'm working to find the root 
> > cause. Thanks for providing the info.
> 
> Great, I'm obviously available to test any patch :)

Could you try the patch below? The RCU serialization code (a rare call 
but can be common in some types of setups) has a nasty implicit 
dependency on the HZ tick - which until now was a hidden wart but became 
an explicit bug under dynticks. Maybe this is what is slowing down your 
box.

	Ingo

------------------------->
Subject: [patch] dynticks: make sure synchronize_rcu() completes
From: Ingo Molnar <mingo@elte.hu>

synchronize_rcu() has a nasty implicit dependency on the HZ tick: it 
relies on another CPU finishing all RCU work so that this CPU can finish 
its RCU work too - in IRQ context. But wait_for_completion() goes to 
sleep indefinitely on dynticks and there might be no other IRQs to this 
CPU for a long time.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcupdate.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux/kernel/rcupdate.c
===================================================================
--- linux.orig/kernel/rcupdate.c
+++ linux/kernel/rcupdate.c
@@ -85,8 +85,13 @@ void synchronize_rcu(void)
 	/* Will wake me after RCU finished */
 	call_rcu(&rcu.head, wakeme_after_rcu);
 
-	/* Wait for it */
-	wait_for_completion(&rcu.completion);
+	/*
+	 * Wait for it. Note: on dynticks RCU completion needs to be
+	 * polled frequently, to make sure we finish work. If this CPU
+	 * goes idle then another CPU cannot finish this CPU's work.
+	 */
+	while (wait_for_completion_timeout(&rcu.completion, HZ/100 ? : 1) == 0)
+		/* nothing */;
 }
 
 static void rcu_barrier_callback(struct rcu_head *notused)

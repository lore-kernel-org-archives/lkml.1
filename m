Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbZAENOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbZAENOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbZAENNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:13:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58407 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbZAENNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:13:53 -0500
Date: Mon, 5 Jan 2009 14:13:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [PATCH] hrtimer: splitout peek ahead functionality, fix
Message-ID: <20090105131334.GA11254@elte.hu>
References: <20090105102818.829119334@chello.nl> <20090105121505.GA13969@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105121505.GA13969@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Please consider for .29.
> 
> picked them up into tip/timers/urgent:
> 
>  e3f1d88: hrtimer: fixup comments
>  a6037b6: hrtimer: fix recursion deadlock by re-introducing the softirq
>  731a55b: hrtimer: simplify hotplug migration
>  d5fd43c: hrtimer: fix HOTPLUG_CPU=n compile warning
>  8bdec95: hrtimer: splitout peek ahead functionality

i needed the small fixlet below, for !HIGH_RES_TIMERS.

	Ingo

-------------->
>From 82c5b7b527ccc4b5d3cf832437e842f9d2920a79 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 5 Jan 2009 14:11:10 +0100
Subject: [PATCH] hrtimer: splitout peek ahead functionality, fix

Impact: build fix on !CONFIG_HIGH_RES_TIMERS

Fix:

  kernel/hrtimer.c:1586: error: implicit declaration of function '__hrtimer_peek_ahead_timers'

Signen-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/hrtimer.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index aa024f2..1455b76 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1268,7 +1268,11 @@ static void run_hrtimer_softirq(struct softirq_action *h)
 	hrtimer_peek_ahead_timers();
 }
 
-#endif	/* CONFIG_HIGH_RES_TIMERS */
+#else /* CONFIG_HIGH_RES_TIMERS */
+
+static inline void __hrtimer_peek_ahead_timers(void) { }
+
+#endif	/* !CONFIG_HIGH_RES_TIMERS */
 
 /*
  * Called from timer softirq every jiffy, expire hrtimers:

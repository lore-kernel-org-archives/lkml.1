Return-Path: <linux-kernel-owner+w=401wt.eu-S1761453AbXGKRsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453AbXGKRsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbXGKRsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:48:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37364 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbXGKRsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:48:06 -0400
Date: Wed, 11 Jul 2007 19:47:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Bligh <mbligh@mbligh.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: Performance regression in 2.6.22-git1 (new sched code?)
Message-ID: <20070711174759.GA17471@elte.hu>
References: <4693C3D2.9020005@mbligh.org> <20070710210945.GA4231@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710210945.GA4231@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > http://test.kernel.org/perf/kernbench.elm3b132.png
> 
> thx! I'll check this tomorrow, meanwhile here are a few quick ideas.

ok, i've re-tested this, and could you please try the fix attached 
below, combined with a CONFIG_HZ=100 run and with SCHED_DEBUG disabled? 
I think a fair bit of the overhead comes from granularity being capped 
to 10 msecs instead of the intended 100 msecs.

	Ingo

--------------------------------------------->
Subject: [patch] sched: allow larger granularity
From: Ingo Molnar <mingo@elte.hu>

allow granularity up to 100 msecs, instead of 10 msecs.
(needed on larger boxes)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4772,7 +4772,7 @@ cpumask_t nohz_cpu_mask = CPU_MASK_NONE;
 static inline void sched_init_granularity(void)
 {
 	unsigned int factor = 1 + ilog2(num_online_cpus());
-	const unsigned long gran_limit = 10000000;
+	const unsigned long gran_limit = 100000000;
 
 	sysctl_sched_granularity *= factor;
 	if (sysctl_sched_granularity > gran_limit)

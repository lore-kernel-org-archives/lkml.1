Return-Path: <linux-kernel-owner+w=401wt.eu-S1759856AbZACMUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbZACMUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 07:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbZACMT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 07:19:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34465 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbZACMT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 07:19:56 -0500
Date: Sat, 3 Jan 2009 13:19:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] cpumask: convert RCU implementations, fix
Message-ID: <20090103121939.GA15006@elte.hu>
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <200901031751.00076.rusty@rustcorp.com.au> <20090103105208.GA19080@elte.hu> <20090103115904.GA440@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090103115904.GA440@elte.hu>
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


there's a build warning regression as well on CONFIG_RCU_CLASSIC:

 kernel/rcuclassic.c: In function ‘rcu_start_batch’:
 kernel/rcuclassic.c:397: warning: passing argument 1 of ‘cpumask_andnot’ from incompatible pointer type

caused by:

 bd232f9: cpumask: convert RCU implementations

fixed via the patch below. (i'll carry this in cpus4096 too, ok?)

	Ingo

---------------------->
>From 9caab32c0d69e569e33caa03845cec73ae701f32 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 3 Jan 2009 13:16:09 +0100
Subject: [PATCH] cpumask: convert RCU implementations, fix
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Impact: cleanup

This warning:

 kernel/rcuclassic.c: In function ‘rcu_start_batch’:
 kernel/rcuclassic.c:397: warning: passing argument 1 of ‘cpumask_andnot’ from incompatible pointer type

triggers because one usage site of rcp->cpumask was not converted
to to_cpumask(rcp->cpumask). There's no ill effects of this bug.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcuclassic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 6ec495f..490934f 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -394,7 +394,8 @@ static void rcu_start_batch(struct rcu_ctrlblk *rcp)
 		 * unnecessarily.
 		 */
 		smp_mb();
-		cpumask_andnot(&rcp->cpumask, cpu_online_mask, nohz_cpu_mask);
+		cpumask_andnot(to_cpumask(rcp->cpumask),
+			       cpu_online_mask, nohz_cpu_mask);
 
 		rcp->signaled = 0;
 	}

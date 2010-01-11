Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839Ab0AKQRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab0AKQRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 11:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541Ab0AKQRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 11:17:05 -0500
Received: from mail.gmx.net ([213.165.64.20]:44406 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750934Ab0AKQRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 11:17:05 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Q7ppACxBQwslKzzzVKOKz+syOJlktua3JQDoG+M
	XZaGT0Vch/9MZh
Subject: Re: tbench regression with 2.6.33-rc1
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1263211680.4244.50.camel@laptop>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1263211680.4244.50.camel@laptop>
Content-Type: text/plain
Date: Mon, 11 Jan 2010 17:16:52 +0100
Message-Id: <1263226612.6290.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 13:08 +0100, Peter Zijlstra wrote:
> On Fri, 2009-12-25 at 19:11 +0800, Lin Ming wrote:
> > Hi,
> > 
> > Test machine: 16 cpus (4P/2Core/HT), 8G mem
> > tbench test command:
> > tbench_srv &
> > tbench 32
> > 
> > Compared with 2.6.32, tbench has ~4% regression in 2.6.33-rc1.
> > 
> > >From vmstat data, the context switch number also drop ~4%.
> > perf top data does not show much differences.
> > 
> > But lockstat data shows huge difference in rq->lock, as below.
> > See the attachment for the full lockstat data.
> > 
> > Any clue of this regression?
> 
> Nope, I thought to see the same on a dual-socket machine, but when
> bisecting I ended up on a user-space perf commit, which is pretty much
> impossible.
> 
> I did notice some variance in the numbers between boots, maybe it was
> large enough to fool me.. (~2800 MB/s was the good one, ~2200 MB/s was
> the bad one).
> 
> perf itself also didn't really provide clue, perf record -ag on the
> workload didn't really show anything scheduler related. vmstat 1 did
> show a proportional drop in context switch rate between the kernels
> though.. most odd.

I've been all through it too, same result.  The below may make a bit of
difference, but really has diddly spit to do with this oddity.

netperf TCP_RR
tip          93445 RR/sec
tip+         99454 RR/sec
             1.064

tbench 8
tip          1144 MB/sec
tip+         1166 MB/sec
             1.019

sched: don't call wake_affine() when the result doesn't matter.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

 kernel/sched_fair.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1530,6 +1530,7 @@ static int select_task_rq_fair(struct ta
 			sd = tmp;
 	}
 
+#ifdef CONFIG_GROUP_SCHED
 	if (sched_feat(LB_SHARES_UPDATE)) {
 		/*
 		 * Pick the largest domain to update shares over
@@ -1543,9 +1544,16 @@ static int select_task_rq_fair(struct ta
 		if (tmp)
 			update_shares(tmp);
 	}
+#endif
 
-	if (affine_sd && wake_affine(affine_sd, p, sync))
-		return cpu;
+	if (affine_sd) {
+		if (cpu == prev_cpu)
+			return cpu;
+		if (wake_affine(affine_sd, p, sync))
+			return cpu;
+		if (!(affine_sd->flags & SD_BALANCE_WAKE))
+			return prev_cpu;
+	}
 
 	while (sd) {
 		int load_idx = sd->forkexec_idx;



Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbXIYLeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbXIYLeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXIYLdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:33:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40071 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbXIYLdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:33:52 -0400
Date: Tue, 25 Sep 2007 13:33:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925113306.GA19166@elte.hu>
References: <20070924214537.GA18980@elte.hu> <1190700652.6482.7.camel@Homer.simpson.net> <1190705759.11910.10.camel@Homer.simpson.net> <1190709207.11226.6.camel@Homer.simpson.net> <20070925091331.GA22905@elte.hu> <20070925094440.GK26289@linux.vnet.ibm.com> <20070925094040.GA28391@elte.hu> <20070925101044.GA923@elte.hu> <20070925102855.GL26289@linux.vnet.ibm.com> <20070925103617.GA3426@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925103617.GA3426@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> hm. perhaps this fixup in kernel/sched.c:set_task_cpu():
> 
>         p->se.vruntime -= old_rq->cfs.min_vruntime - new_rq->cfs.min_vruntime;
> 
> needs to become properly group-hierarchy aware?

a quick first stab like the one below does not appear to solve the 
problem.

	Ingo

------------------->
Subject: sched: group scheduler SMP migration fix
From: Ingo Molnar <mingo@elte.hu>

group scheduler SMP migration fix.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1039,7 +1039,8 @@ void set_task_cpu(struct task_struct *p,
 {
 	int old_cpu = task_cpu(p);
 	struct rq *old_rq = cpu_rq(old_cpu), *new_rq = cpu_rq(new_cpu);
-	u64 clock_offset;
+	struct sched_entity *se;
+	u64 clock_offset, voffset;
 
 	clock_offset = old_rq->clock - new_rq->clock;
 
@@ -1051,7 +1052,11 @@ void set_task_cpu(struct task_struct *p,
 	if (p->se.block_start)
 		p->se.block_start -= clock_offset;
 #endif
-	p->se.vruntime -= old_rq->cfs.min_vruntime - new_rq->cfs.min_vruntime;
+
+	se = &p->se;
+	voffset = old_rq->cfs.min_vruntime - new_rq->cfs.min_vruntime;
+	for_each_sched_entity(se)
+		se->vruntime -= voffset;
 
 	__set_task_cpu(p, new_cpu);
 }

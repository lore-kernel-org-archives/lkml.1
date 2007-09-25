Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbXIYMlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbXIYMlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXIYMlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:41:01 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47907 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbXIYMk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:40:59 -0400
Date: Tue, 25 Sep 2007 18:21:29 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925125129.GA26310@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070924214537.GA18980@elte.hu> <1190700652.6482.7.camel@Homer.simpson.net> <1190705759.11910.10.camel@Homer.simpson.net> <1190709207.11226.6.camel@Homer.simpson.net> <20070925091331.GA22905@elte.hu> <20070925094440.GK26289@linux.vnet.ibm.com> <20070925094040.GA28391@elte.hu> <20070925101044.GA923@elte.hu> <20070925102855.GL26289@linux.vnet.ibm.com> <20070925103617.GA3426@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925103617.GA3426@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 12:36:17PM +0200, Ingo Molnar wrote:
> hm. perhaps this fixup in kernel/sched.c:set_task_cpu():
> 
>         p->se.vruntime -= old_rq->cfs.min_vruntime - new_rq->cfs.min_vruntime;

This definitely does need some fixup, even though I am not sure yet if
it will solve completely the latency issue.

I tried the following patch. I *think* I see some improvement, wrt
latency seen when I type on the shell. Before this patch, I noticed
oddities like "kill -9 chew-max-pid" wont kill chew-max (it is queued in
runqueue waiting for a looong time to run before it can acknowledge
signal and exit). With this patch, I don't see such oddities ..So I am hoping 
it fixes the latency problem you are seeing as well.



Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -1039,6 +1039,8 @@ void set_task_cpu(struct task_struct *p,
 {
 	int old_cpu = task_cpu(p);
 	struct rq *old_rq = cpu_rq(old_cpu), *new_rq = cpu_rq(new_cpu);
+	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
+		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
 	u64 clock_offset;
 
 	clock_offset = old_rq->clock - new_rq->clock;
@@ -1051,7 +1053,8 @@ void set_task_cpu(struct task_struct *p,
 	if (p->se.block_start)
 		p->se.block_start -= clock_offset;
 #endif
-	p->se.vruntime -= old_rq->cfs.min_vruntime - new_rq->cfs.min_vruntime;
+	p->se.vruntime -= old_cfsrq->min_vruntime -
+					 new_cfsrq->min_vruntime;
 
 	__set_task_cpu(p, new_cpu);
 }
 

--
Regards,
vatsa

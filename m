Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbYKLLj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbYKLLj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 06:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYKLLjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 06:39:47 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:41203 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYKLLjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:39:46 -0500
Date: Wed, 12 Nov 2008 17:08:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Vaidyanathan S <svaidyan@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: efault@gmx.de
Subject: Re: [PATCH][mmotm] Sched fix stale value in average load per task
Message-ID: <20081112113852.GA26884@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Vaidyanathan S <svaidyan@in.ibm.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Bharata B Rao <bharata@linux.vnet.ibm.com>, efault@gmx.de
References: <20081112104900.GA13896@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081112104900.GA13896@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2008-11-12 16:19:00]:

> +	else
> +		rq->avg_load_per_task = 0;
>  
>  	return rq->avg_load_per_task;

On second thoughts, does this look better? (Based on Mike Galbraith's
suggestion)


cpu_avg_load_per_task() returns a stale value when nr_running is 0. It returns
an older stale (caculated when nr_running was non zero) value. This patch
returns and sets rq->avg_load_per_task to zero when nr_running is 0.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 kernel/sched.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/sched.c~sched-fix-stale-load-avg kernel/sched.c
--- linux-2.6.28-rc4/kernel/sched.c~sched-fix-stale-load-avg	2008-11-12 15:55:38.000000000 +0530
+++ linux-2.6.28-rc4-balbir/kernel/sched.c	2008-11-12 16:40:26.000000000 +0530
@@ -571,8 +571,6 @@ struct rq {
 	int cpu;
 	int online;
 
-	unsigned long avg_load_per_task;
-
 	struct task_struct *migration_thread;
 	struct list_head migration_queue;
 #endif
@@ -1428,10 +1426,10 @@ static unsigned long cpu_avg_load_per_ta
 {
 	struct rq *rq = cpu_rq(cpu);
 
-	if (rq->nr_running)
-		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
-
-	return rq->avg_load_per_task;
+	if (unlikely(!rq->nr_running))
+		return 0;
+	else
+		return rq->load.weight / rq->nr_running;
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
_

 

-- 
	Balbir

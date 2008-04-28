Return-Path: <linux-kernel-owner+w=401wt.eu-S1763671AbYD1FqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763671AbYD1FqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYD1Fpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:45:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41545 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbYD1Fpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:45:53 -0400
Subject: Re: [PATCH] sched: fair-group: fix a Div0 error of the fair group
	scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: miaox@cn.fujitsu.com
Cc: Ingo Molnar <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <481558A0.9020803@cn.fujitsu.com>
References: <481558A0.9020803@cn.fujitsu.com>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 07:45:44 +0200
Message-Id: <1209361544.6429.4.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 12:54 +0800, Miao Xie wrote:
> When I echoed 0 into the "cpu.shares" file, a Div0 error occured.
> 
> We found it is caused by the following calling.
> 
>    sched_group_set_shares(tg, shares)
>        set_se_shares(tg->se[i], shares/nr_cpu_ids)
>            __set_se_shares(se, shares)
>                div64_64((1ULL<<32), shares)
> 
> When the echoed value was less than the number of processores, the result of the
> sentence "shares/nr_cpu_ids" was 0, and then the system called div64() to divide
> the result, the Div0 error occured.
> 
> It is unnecessary that the shares value is divided by nr_cpu_ids, I think.
> Because in the function  __update_group_shares_cpu() and init_tg_cfs_entry(),
> the shares value isn't divided by nr_cpu_ids when setting shares of the sched
> entity.
> 
> This patch fixes this bug. And echoing ULONG_MAX value into cpu.shares also
> causes Div0 error, so we set a macro MAX_SHARES to limit the max value of
> shares.

how about:

diff --git a/kernel/sched.c b/kernel/sched.c
index 740fb40..b68127a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8025,7 +8025,7 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 
 	se->my_q = cfs_rq;
 	se->load.weight = tg->shares;
-	se->load.inv_weight = div64_64(1ULL<<32, se->load.weight);
+	se->load.inv_weight = 0;
 	se->parent = parent;
 }
 #endif
@@ -8692,7 +8692,7 @@ static void __set_se_shares(struct sched_entity *se, unsigned long shares)
 		dequeue_entity(cfs_rq, se, 0);
 
 	se->load.weight = shares;
-	se->load.inv_weight = div64_64((1ULL<<32), shares);
+	se->load.inv_weight = 0;
 
 	if (on_rq)
 		enqueue_entity(cfs_rq, se, 0);



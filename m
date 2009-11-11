Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZKKKID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZKKKID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 05:08:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZKKKIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 05:08:02 -0500
Received: from casper.infradead.org ([85.118.1.10]:52549 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbZKKKIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 05:08:01 -0500
Subject: Re: [BUG] cpu controller can't provide fair CPU time for each group
From: Peter Zijlstra <peterz@infradead.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091111134910.5F42.E1E9C6FF@jp.fujitsu.com>
References: <4AEF94E8.3030403@cn.fujitsu.com>
	 <1257846518.4648.18.camel@twins>
	 <20091111134910.5F42.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 11 Nov 2009 11:07:28 +0100
Message-ID: <1257934048.23203.76.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 15:21 +0900, Yasunori Goto wrote:
> > Someone needs to fix that if they really care.
> 
> To be honest, I don't have any good idea because I'm not familiar with
> schduler's code. 

You could possible try something like the below, its rather gross but
might maybe work,.. has other issues though.


---
 kernel/sched.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 91642c1..65629a3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1614,7 +1614,7 @@ static void update_group_shares_cpu(struct task_group *tg, int cpu,
  */
 static int tg_shares_up(struct task_group *tg, void *data)
 {
-	unsigned long weight, rq_weight = 0, shares = 0;
+	unsigned long weight, rq_weight = 0, sum_weight = 0, shares = 0;
 	unsigned long *usd_rq_weight;
 	struct sched_domain *sd = data;
 	unsigned long flags;
@@ -1630,6 +1630,7 @@ static int tg_shares_up(struct task_group *tg, void *data)
 		weight = tg->cfs_rq[i]->load.weight;
 		usd_rq_weight[i] = weight;
 
+		rq_weight += weight;
 		/*
 		 * If there are currently no tasks on the cpu pretend there
 		 * is one of average load so that when a new task gets to
@@ -1638,10 +1639,14 @@ static int tg_shares_up(struct task_group *tg, void *data)
 		if (!weight)
 			weight = NICE_0_LOAD;
 
-		rq_weight += weight;
+		sum_weight += weight;
+
 		shares += tg->cfs_rq[i]->shares;
 	}
 
+	if (!rq_weight)
+		rq_weight = sum_weight;
+
 	if ((!shares && rq_weight) || shares > tg->shares)
 		shares = tg->shares;
 


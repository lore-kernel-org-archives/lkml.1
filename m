Return-Path: <linux-kernel-owner+w=401wt.eu-S935123AbYEBNKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935123AbYEBNKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760382AbYEBNK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:10:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39833 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759837AbYEBNK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:10:27 -0400
Subject: Re: questions on calc_delta_mine() in sched.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1209731455.6508.8.camel@lappy>
References: <481A2BF6.2070406@austin.ibm.com>
	 <1209730442.6508.3.camel@lappy>  <1209731455.6508.8.camel@lappy>
Content-Type: text/plain
Date: Fri, 02 May 2008 15:10:07 +0200
Message-Id: <1209733807.6929.0.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 14:30 +0200, Peter Zijlstra wrote: 
> On Fri, 2008-05-02 at 14:14 +0200, Peter Zijlstra wrote:
> 
> > And, no sadly I have no ideas on how to get rid of it ;-/
> 
> Well, not quite true - I've once thought about a small cache of recently
> computed inverse values. Esp for say a ping-pong scenario you end up
> re-computing basically the same values over and over again.
> 
> Maybe something like this (fully untested):

This one builds and... boots


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -537,6 +537,9 @@ struct rq {
 	unsigned long nr_load_updates;
 	u64 nr_switches;
 
+	struct load_weight lw_cache[4];
+	int lw_cache_idx;
+
 	struct cfs_rq cfs;
 	struct rt_rq rt;
 
@@ -1438,8 +1441,24 @@ calc_delta_mine(unsigned long delta_exec
 {
 	u64 tmp;
 
-	if (unlikely(!lw->inv_weight))
-		lw->inv_weight = (WMULT_CONST-lw->weight/2) / (lw->weight+1);
+	if (!lw->inv_weight) {
+		struct rq *rq = cpu_rq(smp_processor_id());
+		unsigned long weight = lw->weight;
+		int i;
+
+		for (i = 0; i < ARRAY_SIZE(rq->lw_cache); i++) {
+			if (rq->lw_cache[i].weight == weight)
+				lw->inv_weight = rq->lw_cache[i].inv_weight;
+			goto got_inv;
+		}
+		if (unlikely(!weight))
+			weight++;
+		lw->inv_weight = 1 + (WMULT_CONST - weight/2) / weight;
+		rq->lw_cache[rq->lw_cache_idx] = *lw;
+		rq->lw_cache_idx++;
+		rq->lw_cache_idx %= ARRAY_SIZE(rq->lw_cache);
+	}
+ got_inv:
 
 	tmp = (u64)delta_exec * weight;
 	/*
@@ -8025,7 +8044,7 @@ static void init_tg_cfs_entry(struct tas
 
 	se->my_q = cfs_rq;
 	se->load.weight = tg->shares;
-	se->load.inv_weight = div64_64(1ULL<<32, se->load.weight);
+	se->load.inv_weight = 0;
 	se->parent = parent;
 }
 #endif
@@ -8692,7 +8711,7 @@ static void __set_se_shares(struct sched
 		dequeue_entity(cfs_rq, se, 0);
 
 	se->load.weight = shares;
-	se->load.inv_weight = div64_64((1ULL<<32), shares);
+	se->load.inv_weight = 0;
 
 	if (on_rq)
 		enqueue_entity(cfs_rq, se, 0);



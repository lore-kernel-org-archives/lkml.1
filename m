Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbYF0L7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbYF0L7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYF0L5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:57:55 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:61624 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbYF0L5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:52 -0400
Message-Id: <20080627115211.155726846@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:13 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/30] sched: fix calc_delta_asym
Content-Disposition: inline; filename=sched-fiddle-asym.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, so why are we in this mess, it was:

  1/w

but now we mixed that rw in the mix like:

 rw/w

rw being \Sum w suggests: fiddling w, we should also fiddle rw, humm?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -432,6 +432,7 @@ calc_delta_asym(unsigned long delta, str
 
 	for_each_sched_entity(se) {
 		struct load_weight *se_lw = &se->load;
+		unsigned long rw = cfs_rq_of(se)->load.weight;
 
 #ifdef CONFIG_FAIR_SCHED_GROUP
 		struct cfs_rq *cfs_rq = se->my_q;
@@ -453,14 +454,16 @@ calc_delta_asym(unsigned long delta, str
 			lw.inv_weight = 0;
 
 			se_lw = &lw;
+			rw += lw.weight - se->load.weight;
 		} else
 #endif
 
-		if (se->load.weight < NICE_0_LOAD)
+		if (se->load.weight < NICE_0_LOAD) {
 			se_lw = &lw;
+			rw += NICE_0_LOAD - se->load.weight;
+		}
 
-		delta = calc_delta_mine(delta,
-				cfs_rq_of(se)->load.weight, se_lw);
+		delta = calc_delta_mine(delta, rw, se_lw);
 	}
 
 	return delta;

-- 


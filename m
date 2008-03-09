Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbYCIRLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbYCIRLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYCIRJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:09:23 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:35891 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbYCIRJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:09:18 -0400
Message-Id: <20080309170928.369730000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:09:01 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 11/17] sched: fair: optimize sched_slice()
Content-Disposition: inline; filename=sched-opt-sched_slice.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache the divide in the hope we can avoid doing it in steady state opteration.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c       |    2 ++
 kernel/sched_debug.c |    1 +
 kernel/sched_fair.c  |    6 ++----
 3 files changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -1298,11 +1298,13 @@ calc_delta_mine(unsigned long delta_exec
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
 {
 	lw->weight += inc;
+	lw->inv_weight = 0;
 }
 
 static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
 {
 	lw->weight -= dec;
+	lw->inv_weight = 0;
 }
 
 /*
Index: linux-2.6-2/kernel/sched_debug.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_debug.c
+++ linux-2.6-2/kernel/sched_debug.c
@@ -137,6 +137,7 @@ void print_cfs_rq(struct seq_file *m, in
 			SPLIT_NS(spread0));
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
+	SEQ_printf(m, "  .%-30s: %ld\n", "load^-1", cfs_rq->load.inv_weight);
 #ifdef CONFIG_SCHEDSTATS
 	SEQ_printf(m, "  .%-30s: %d\n", "bkl_count",
 			rq->bkl_count);
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -369,10 +369,8 @@ static u64 sched_slice(struct cfs_rq *cf
 		goto out;
 
 	for_each_sched_entity(se) {
-		cfs_rq = cfs_rq_of(se);
-
-		slice *= se->load.weight;
-		do_div(slice, cfs_rq->load.weight);
+		slice = calc_delta_mine(slice,
+				se->load.weight, &cfs_rq_of(se)->load);
 	}
 
 out:

--


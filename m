Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYBRKAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYBRKAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbYBRJ7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:59:25 -0500
Received: from viefep32-int.chello.at ([62.179.121.50]:45336 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbYBRJ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:59:23 -0500
Message-Id: <20080218095625.579955000@chello.nl>
References: <20080218095535.629736000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 18 Feb 2008 10:55:41 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       dhaval@linux.vnet.ibm.com, tong.n.li@intel.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/7] sched: fair: optimize sched_slice()
Content-Disposition: inline; filename=sched-opt-sched_slice.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache the divide in the hope we can avoid doing it in steady state optertion.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c       |    2 ++
 kernel/sched_debug.c |    1 +
 kernel/sched_fair.c  |    6 ++----
 3 files changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1225,11 +1225,13 @@ calc_delta_mine(unsigned long delta_exec
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
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -137,6 +137,7 @@ void print_cfs_rq(struct seq_file *m, in
 			SPLIT_NS(spread0));
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
+	SEQ_printf(m, "  .%-30s: %ld\n", "load^-1", cfs_rq->load.inv_weight);
 #ifdef CONFIG_SCHEDSTATS
 	SEQ_printf(m, "  .%-30s: %d\n", "bkl_count",
 			rq->bkl_count);
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -374,10 +374,8 @@ static u64 sched_slice(struct cfs_rq *cf
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


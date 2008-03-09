Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbYCIRRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbYCIRRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYCIRQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:16:57 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:58953 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752401AbYCIRQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:16:56 -0400
Message-Id: <20080309170929.637205000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:09:06 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 16/17] sched: fair: bound tardiness
Content-Disposition: inline; filename=sched-fair-slice-limit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EEVDF guarantees a O(1) tardiness exceeding the deadline, this tardines comes
from the slice length. So by limiting the slice length when there is
competition, we limit the amount by which the deadline can be exceeded.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -584,15 +584,21 @@ static u64 sched_slice(struct cfs_rq *cf
 {
 	u64 slice = __sched_period(cfs_rq->nr_running);
 
-	/*
-	 * FIXME: curious 'hack' to make it boot - when the tick is started we
-	 * hit this with the init_task, which is not actually enqueued.
-	 */
 	if (unlikely(rq_of(cfs_rq)->load.weight <= se->load.weight))
 		goto out;
 
 	slice = calc_delta_weight(slice, se);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	/*
+	 * EEVDF guarantees a O(1) tardiness exceeding the deadline, this
+	 * tardines comes from the slice length. So by limiting the slice
+	 * length when there is competition, we limit the amount by which the
+	 * deadline can be exceeded.
+	 */
+	if (rq_of(cfs_rq)->cfs_root.nr_queued)
+		slice = min_t(u64, slice, sysctl_sched_min_granularity);
+#endif
 out:
 	return slice;
 }

--


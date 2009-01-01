Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbZAAHqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbZAAHqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 02:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZAAHqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 02:46:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:40599 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751765AbZAAHqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 02:46:13 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19dmWRjVHBd7cJ8z2rExiXkbLSzbxbJlFp4AP2OYd
	nSszO7D3oZQsIs
Subject: [patch] Re: problem with "sched: revert back to per-rq vruntime"?
From: Mike Galbraith <efault@gmx.de>
To: Jayson King <dev@jaysonking.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
In-Reply-To: <495BD346.9040408@jaysonking.com>
References: <495948E0.8040502@jaysonking.com>
	 <495A788B.3010001@jaysonking.com>
	 <1230740773.6412.21.camel@marge.simson.net>
	 <495BD346.9040408@jaysonking.com>
Content-Type: text/plain
Date: Thu, 01 Jan 2009 08:46:03 +0100
Message-Id: <1230795963.5892.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would perhaps be prettier to have the load already in place at call
time, but methinks the enqueue/dequeue accounting logic is nice as is,
so complete the unlikely case handling in an unlikely block.
 
Impact: bug fixlet.

Account for tasks which have not yet been enqueued in calc_delta_weight().

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5ad4440..4685f28 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -392,8 +392,16 @@ static inline unsigned long
 calc_delta_weight(unsigned long delta, struct sched_entity *se)
 {
 	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				se->load.weight, &cfs_rq_of(se)->load);
+		struct load_weight *load = &cfs_rq_of(se)->load;
+
+		if (unlikely(!se->on_rq)) {
+			struct load_weight tmp;
+
+			tmp.weight = load->weight + se->load.weight;
+			tmp.inv_weight = 0;
+			load = &tmp;
+		}
+		delta = calc_delta_mine(delta, se->load.weight, load);
 	}
 
 	return delta;



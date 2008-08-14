Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbYHNNtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbYHNNtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbYHNNs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:48:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:42321 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbYHNNsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:48:55 -0400
Subject: [PATCH] sched: fix rt-bandwidth hotplug race
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alex Nixon <alex.nixon@citrix.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 15:49:00 +0200
Message-Id: <1218721740.10800.230.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: fix rt-bandwidth hotplug race
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Aug 14 15:42:44 CEST 2008

When we hot-unplug a cpu and rebuild the sched-domain, all cpus will be
detatched. Alex observed the case where a runqueue was stealing bandwidth
from an already disabled runqueue to satisfy its own needs.

Stop this by skipping over already disabled runqueues.

Reported-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Alex Nixon <alex.nixon@citrix.com>
---
 kernel/sched_rt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -298,7 +298,7 @@ static void __disable_runtime(struct rq 
 			struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 			s64 diff;
 
-			if (iter == rt_rq)
+			if (iter == rt_rq || iter->rt_runtime == RUNTIME_INF)
 				continue;
 
 			spin_lock(&iter->rt_runtime_lock);



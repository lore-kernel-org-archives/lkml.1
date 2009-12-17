Return-Path: <linux-kernel-owner+w=401wt.eu-S965301AbZLQS7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301AbZLQS7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759604AbZLQS7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:59:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:60921 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbZLQS7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:59:06 -0500
Message-Id: <20091217185430.655230380@chello.nl>
References: <20091217185021.684424629@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 17 Dec 2009 19:50:27 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/6] sched: Add a lock break for PREEMPT=y
Content-Disposition: inline; filename=sched-lb-6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since load-balancing can hold rq->locks for quite a long while, allow
breaking out early when there is lock contention.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -2065,6 +2065,10 @@ static int move_tasks(struct rq *this_rq
 		 */
 		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
 			break;
+
+		if (raw_spin_is_contended(&this_rq->lock) ||
+				raw_spin_is_contended(&busiest->lock))
+			break;
 #endif
 	} while (load_moved && max_load_move > total_load_moved);
 

-- 


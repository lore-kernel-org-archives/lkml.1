Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYJXJ64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYJXJ64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYJXJ6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:58:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:36221 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYJXJ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:58:42 -0400
Message-Id: <20081024091109.422586607@chello.nl>
References: <20081024090611.936552213@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 24 Oct 2008 11:06:12 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, efault@gmx.de, vatsa@in.ibm.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/8] sched: fix a find_busiest_group buglet
Content-Disposition: inline; filename=sched-fbg-buglet.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In one of the group load balancer patches:

	commit 408ed066b11cf9ee4536573b4269ee3613bd735e
	Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
	Date:   Fri Jun 27 13:41:28 2008 +0200
	Subject: sched: hierarchical load vs find_busiest_group

The following change:

-               if (max_load - this_load + SCHED_LOAD_SCALE_FUZZ >=
+               if (max_load - this_load + 2*busiest_load_per_task >=
                                        busiest_load_per_task * imbn) {

made the condition always true, because imbn is [1,2].
Therefore, remove the 2*, and give the it a fair chance.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3343,7 +3343,7 @@ small_imbalance:
 		} else
 			this_load_per_task = cpu_avg_load_per_task(this_cpu);
 
-		if (max_load - this_load + 2*busiest_load_per_task >=
+		if (max_load - this_load + busiest_load_per_task >=
 					busiest_load_per_task * imbn) {
 			*imbalance = busiest_load_per_task;
 			return busiest;

-- 


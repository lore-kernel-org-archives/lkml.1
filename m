Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYFLIpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYFLIpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbYFLIon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:44:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50569 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbYFLIok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:44:40 -0400
Message-ID: <4850E19B.1050202@cn.fujitsu.com>
Date: Thu, 12 Jun 2008 16:43:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: mingo@elte.hu
CC: peterz@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] sched: 64bit: fix overflow(was: fix divide by zero)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(overflow means weight >= 2^32 here, because inv_weigh = 2^32/weight)

A weight of a cfs_rq is the sum of weights of which entities
are queued on this cfs_rq, so it will be overflow when entities
are too many. 

Although, overflow is very hardly occurred, but it break fairness when
it is occurred. And 64bits system have more memory than 32bits system
and 64bits system can create more process usually, so overflow many be
occurred more.

This patch guarantee fairness when overflow in 64bits system.
Thanks to the optimization of compiler, it change nothing in 32bits system.


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index bfb8ad8..e277533 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1337,8 +1337,13 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 {
 	u64 tmp;
 
-	if (!lw->inv_weight)
-		lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)/(lw->weight+1);
+	if (!lw->inv_weight) {
+		if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
+			lw->inv_weight = 1;
+		else
+			lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)
+				/ (lw->weight+1);
+	}
 
 	tmp = (u64)delta_exec * weight;
 	/*





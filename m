Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbZLIRmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbZLIRmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZLIRmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:42:24 -0500
Received: from smtp.nokia.com ([192.100.122.230]:64811 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbZLIRmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:42:23 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: mingo@elte.hu
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sched: Memory leak in two error corner cases
Date: Wed,  9 Dec 2009 19:45:46 +0200
Message-Id: <1260380746-4856-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 09 Dec 2009 17:42:07.0636 (UTC) FILETIME=[ED8F4D40:01CA78F6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Carmody <ext-phil.2.carmody@nokia.com>

If the second in each of these pairs of allocations fails, then
the first one will not be freed in the error route out.

Found by a static code analysis tool.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 kernel/sched.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e7f2cfa..29ebc4a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9841,8 +9841,10 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 
 		se = kzalloc_node(sizeof(struct sched_entity),
 				  GFP_KERNEL, cpu_to_node(i));
-		if (!se)
+		if (!se) {
+			kfree(cfs_rq);
 			goto err;
+		}
 
 		init_tg_cfs_entry(tg, cfs_rq, se, i, 0, parent->se[i]);
 	}
@@ -9929,8 +9931,10 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 
 		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
 				     GFP_KERNEL, cpu_to_node(i));
-		if (!rt_se)
+		if (!rt_se) {
+			kfree(rt_rq);
 			goto err;
+		}
 
 		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent->rt_se[i]);
 	}
-- 
1.6.0.4


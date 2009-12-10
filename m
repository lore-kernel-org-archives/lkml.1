Return-Path: <linux-kernel-owner+w=401wt.eu-S934391AbZLJM0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391AbZLJM0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 07:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934186AbZLJM0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 07:26:12 -0500
Received: from smtp.nokia.com ([192.100.105.134]:30786 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934184AbZLJM0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 07:26:11 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: mingo@elte.hu
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] sched: Memory leak in two error corner cases
Date: Thu, 10 Dec 2009 14:29:37 +0200
Message-Id: <1260448177-28448-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20091210080240.GE25549@elte.hu>
References: <20091210080240.GE25549@elte.hu>
X-OriginalArrivalTime: 10 Dec 2009 12:25:58.0626 (UTC) FILETIME=[ED8FD420:01CA7993]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the second in each of these pairs of allocations fails, then
the first one will not be freed in the error route out.

Found by a static code analysis tool.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 kernel/sched.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3c11ae0..ee8046f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9765,13 +9765,15 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 		se = kzalloc_node(sizeof(struct sched_entity),
 				  GFP_KERNEL, cpu_to_node(i));
 		if (!se)
-			goto err;
+			goto err_free_rq;
 
 		init_tg_cfs_entry(tg, cfs_rq, se, i, 0, parent->se[i]);
 	}
 
 	return 1;
 
+ err_free_rq:
+	kfree(cfs_rq);
  err:
 	return 0;
 }
@@ -9853,13 +9855,15 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
 				     GFP_KERNEL, cpu_to_node(i));
 		if (!rt_se)
-			goto err;
+			goto err_free_rq;
 
 		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent->rt_se[i]);
 	}
 
 	return 1;
 
+ err_free_rq:
+	kfree(rt_rq);
  err:
 	return 0;
 }
-- 
1.6.0.4


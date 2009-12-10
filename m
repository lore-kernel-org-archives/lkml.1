Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbZLJNhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbZLJNhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760667AbZLJNho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:37:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:41373 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759104AbZLJNhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:37:42 -0500
Date: Thu, 10 Dec 2009 13:37:01 GMT
From: tip-bot for Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, ext-phil.2.carmody@nokia.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, ext-phil.2.carmody@nokia.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260448177-28448-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1260448177-28448-1-git-send-email-ext-phil.2.carmody@nokia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix memory leak in two error corner cases
Message-ID: <tip-dfc12eb26a285df316be68a808af86964f3bff86@git.kernel.org>
Git-Commit-ID: dfc12eb26a285df316be68a808af86964f3bff86
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dfc12eb26a285df316be68a808af86964f3bff86
Gitweb:     http://git.kernel.org/tip/dfc12eb26a285df316be68a808af86964f3bff86
Author:     Phil Carmody <ext-phil.2.carmody@nokia.com>
AuthorDate: Thu, 10 Dec 2009 14:29:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 14:28:10 +0100

sched: Fix memory leak in two error corner cases

If the second in each of these pairs of allocations fails, then the
first one will not be freed in the error route out.

Found by a static code analysis tool.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1260448177-28448-1-git-send-email-ext-phil.2.carmody@nokia.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3de3dea..36cc05a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9855,13 +9855,15 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
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
@@ -9943,13 +9945,15 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
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

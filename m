Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbYGPDoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbYGPDoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 23:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYGPDoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 23:44:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64378 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbYGPDoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 23:44:11 -0400
Message-ID: <487D6E4D.6040704@cn.fujitsu.com>
Date: Wed, 16 Jul 2008 11:43:09 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] cpuset: code-cleanup for started_after
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup(cgroup_scan_tasks) will initialize heap->gt for us.
this patch removes started_after() and its helper-function.


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 798b3ab..aaec03a 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -701,36 +701,6 @@ done:
 	/* Don't kfree(dattr) -- partition_sched_domains() does that. */
 }
 
-static inline int started_after_time(struct task_struct *t1,
-				     struct timespec *time,
-				     struct task_struct *t2)
-{
-	int start_diff = timespec_compare(&t1->start_time, time);
-	if (start_diff > 0) {
-		return 1;
-	} else if (start_diff < 0) {
-		return 0;
-	} else {
-		/*
-		 * Arbitrarily, if two processes started at the same
-		 * time, we'll say that the lower pointer value
-		 * started first. Note that t2 may have exited by now
-		 * so this may not be a valid pointer any longer, but
-		 * that's fine - it still serves to distinguish
-		 * between two tasks started (effectively)
-		 * simultaneously.
-		 */
-		return t1 > t2;
-	}
-}
-
-static inline int started_after(void *p1, void *p2)
-{
-	struct task_struct *t1 = p1;
-	struct task_struct *t2 = p2;
-	return started_after_time(t1, &t2->start_time, t2);
-}
-
 /**
  * cpuset_test_cpumask - test a task's cpus_allowed versus its cpuset's
  * @tsk: task to test
@@ -809,7 +779,12 @@ static int update_cpumask(struct cpuset *cs, char *buf)
 	if (cpus_equal(cs->cpus_allowed, trialcs.cpus_allowed))
 		return 0;
 
-	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, &started_after);
+	/*
+	 * cgroup_scan_tasks() will initialize heap->gt for us.
+	 * heap_init() is still needed here for we should not change
+	 * cs->cpus_allowed when heap_init() fails.
+	 */
+	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
 	if (retval)
 		return retval;
 






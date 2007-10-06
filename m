Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbXJFJsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbXJFJsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 05:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932100AbXJFJsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 05:48:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44940 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753381AbXJFJrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 05:47:52 -0400
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 06 Oct 2007 02:47:49 -0700
Message-Id: <20071006094749.17518.88048.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH] cpusets - decrustify cpuset mask update code
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Decrustify the kernel/cpuset.c 'cpus' and 'mems' updating code.

Other than subtle improvements in the consistency of identifying
white space at the beginning and end of passed in masks, this
doesn't make any visible difference in behaviour.  But it's
one or two hundred kernel text bytes smaller, and easier to
understand.

Signed-off-by: Paul Jackson <pj@sgi.com>

---

Andrew - this patch goes after:
  cpuset sched_load_balance flag

 kernel/cpuset.c |   50 ++++++++++++++++++++------------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

--- 2.6.23-rc8-mm1.orig/kernel/cpuset.c	2007-10-04 10:56:01.745248540 -0700
+++ 2.6.23-rc8-mm1/kernel/cpuset.c	2007-10-04 11:02:32.939745095 -0700
@@ -488,6 +488,14 @@ static int validate_change(const struct 
 			return -EINVAL;
 	}
 
+	/* Cpusets with tasks can't have empty cpus_allowed or mems_allowed */
+	if (cgroup_task_count(cur->css.cgroup)) {
+		if (cpus_empty(trial->cpus_allowed) ||
+	    	    nodes_empty(trial->mems_allowed)) {
+			return -ENOSPC;
+		}
+	}
+
 	return 0;
 }
 
@@ -778,11 +786,13 @@ static int update_cpumask(struct cpuset 
 	trialcs = *cs;
 
 	/*
-	 * We allow a cpuset's cpus_allowed to be empty; if it has attached
-	 * tasks, we'll catch it later when we validate the change and return
-	 * -ENOSPC.
+	 * An empty cpus_allowed is ok iff there are no tasks in the cpuset.
+	 * Since cpulist_parse() fails on an empty mask, we special case
+	 * that parsing.  The validate_change() call ensures that cpusets
+	 * with tasks have cpus.
 	 */
-	if (!buf[0] || (buf[0] == '\n' && !buf[1])) {
+	buf = strstrip(buf);
+	if (!*buf) {
 		cpus_clear(trialcs.cpus_allowed);
 	} else {
 		retval = cpulist_parse(buf, trialcs.cpus_allowed);
@@ -790,10 +800,6 @@ static int update_cpumask(struct cpuset 
 			return retval;
 	}
 	cpus_and(trialcs.cpus_allowed, trialcs.cpus_allowed, cpu_online_map);
-	/* cpus_allowed cannot be empty for a cpuset with attached tasks. */
-	if (cgroup_task_count(cs->css.cgroup) &&
-	    cpus_empty(trialcs.cpus_allowed))
-		return -ENOSPC;
 	retval = validate_change(cs, &trialcs);
 	if (retval < 0)
 		return retval;
@@ -902,29 +908,19 @@ static int update_nodemask(struct cpuset
 	trialcs = *cs;
 
 	/*
-	 * We allow a cpuset's mems_allowed to be empty; if it has attached
-	 * tasks, we'll catch it later when we validate the change and return
-	 * -ENOSPC.
+	 * An empty mems_allowed is ok iff there are no tasks in the cpuset.
+	 * Since nodelist_parse() fails on an empty mask, we special case
+	 * that parsing.  The validate_change() call ensures that cpusets
+	 * with tasks have memory.
 	 */
-	if (!buf[0] || (buf[0] == '\n' && !buf[1])) {
+	buf = strstrip(buf);
+	if (!*buf) {
 		nodes_clear(trialcs.mems_allowed);
 	} else {
 		retval = nodelist_parse(buf, trialcs.mems_allowed);
 		if (retval < 0)
 			goto done;
-		if (!nodes_intersects(trialcs.mems_allowed,
-						node_states[N_HIGH_MEMORY])) {
-			/*
-			 * error if only memoryless nodes specified.
-			 */
-			retval = -ENOSPC;
-			goto done;
-		}
 	}
-	/*
-	 * Exclude memoryless nodes.  We know that trialcs.mems_allowed
-	 * contains at least one node with memory.
-	 */
 	nodes_and(trialcs.mems_allowed, trialcs.mems_allowed,
 						node_states[N_HIGH_MEMORY]);
 	oldmem = cs->mems_allowed;
@@ -932,12 +928,6 @@ static int update_nodemask(struct cpuset
 		retval = 0;		/* Too easy - nothing to do */
 		goto done;
 	}
-	/* mems_allowed cannot be empty for a cpuset with attached tasks. */
-	if (cgroup_task_count(cs->css.cgroup) &&
-	    nodes_empty(trialcs.mems_allowed)) {
-		retval = -ENOSPC;
-		goto done;
-	}
 	retval = validate_change(cs, &trialcs);
 	if (retval < 0)
 		goto done;

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373

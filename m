Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXIPIEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXIPIEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 04:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXIPID7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 04:03:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41884 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751469AbXIPID5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 04:03:57 -0400
From: Paul Jackson <pj@sgi.com>
To: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Date: Sun, 16 Sep 2007 01:03:56 -0700
Message-Id: <20070916080356.7786.3884.sendpatchset@jackhammer.engr.sgi.com>
Subject: [RFC] container cpusets - decrustify cpuset mask update code
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage,

The kernel/cpuset.c code handling the updating of a cpusets
'cpus' and 'mems' masks was starting to look a little bit
crufty to me.

So I rewrote it a little bit.  Other than subtle improvements
in the consistency of identifying white space at the beginning
and end of passed in masks, I don't see that it makes any
visible difference in behaviour.  But it's one or two hundred
kernel text bytes smaller, and to my eye, easier to understand.

If you find this to be an improvement, could you fold it
into your container patch set?

Signed-off-by: Paul Jackson <pj@sgi.com>

---

 kernel/cpuset.c |   50 ++++++++++++++++++++------------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

--- 2.6.23-rc4-mm1.orig/kernel/cpuset.c	2007-09-16 00:10:53.505477423 -0700
+++ 2.6.23-rc4-mm1/kernel/cpuset.c	2007-09-16 00:15:53.445922524 -0700
@@ -478,6 +478,14 @@ static int validate_change(const struct 
 			return -EINVAL;
 	}
 
+	/* Cpusets with tasks can't have empty cpus_allowed or mems_allowed */
+	if (container_task_count(cur->css.container)) {
+		if (cpus_empty(trial->cpus_allowed) ||
+	    	    nodes_empty(trial->mems_allowed)) {
+			return -ENOSPC;
+		}
+	}
+
 	return 0;
 }
 
@@ -497,11 +505,13 @@ static int update_cpumask(struct cpuset 
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
@@ -509,10 +519,6 @@ static int update_cpumask(struct cpuset 
 			return retval;
 	}
 	cpus_and(trialcs.cpus_allowed, trialcs.cpus_allowed, cpu_online_map);
-	/* cpus_allowed cannot be empty for a cpuset with attached tasks. */
-	if (container_task_count(cs->css.container) &&
-	    cpus_empty(trialcs.cpus_allowed))
-		return -ENOSPC;
 	retval = validate_change(cs, &trialcs);
 	if (retval < 0)
 		return retval;
@@ -609,29 +615,19 @@ static int update_nodemask(struct cpuset
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
@@ -639,12 +635,6 @@ static int update_nodemask(struct cpuset
 		retval = 0;		/* Too easy - nothing to do */
 		goto done;
 	}
-	/* mems_allowed cannot be empty for a cpuset with attached tasks. */
-	if (container_task_count(cs->css.container) &&
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

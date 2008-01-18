Return-Path: <linux-kernel-owner+w=401wt.eu-S1762078AbYARPYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078AbYARPYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759986AbYARPYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:24:25 -0500
Received: from relay1.sgi.com ([192.48.171.29]:60280 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759605AbYARPYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:24:23 -0500
Date: Fri, 18 Jan 2008 09:24:22 -0600
To: pj@sgi.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [RFC] hotplug cpu move tasks in empty cpusets - possible
 refinements
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080118152422.7038533B943@attica.americas.sgi.com>
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Paul,

> Query for Cliff:
> 1) Can we narrow the scope of callback_mutex in scan_for_empty_cpusets()?
> 2) Can we avoid rewriting the cpus, mems of cpusets except when it is
>    likely that we'll be changing them?
> 3) Should not remove_tasks_in_empty_cpuset() also check for empty mems?
> -pj

I agree with all of the above refinements.
And I just tested the below patch and find no problem.

So this is an ACK from me.

-Cliff

---

 kernel/cpuset.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/cpuset.c
===================================================================
--- linux-2.6.orig/kernel/cpuset.c
+++ linux-2.6/kernel/cpuset.c
@@ -1748,7 +1748,8 @@ static void remove_tasks_in_empty_cpuset
 	 * has online cpus, so can't be empty).
 	 */
 	parent = cs->parent;
-	while (cpus_empty(parent->cpus_allowed))
+	while (cpus_empty(parent->cpus_allowed) ||
+			nodes_empty(parent->mems_allowed))
 		parent = parent->parent;
 
 	move_member_tasks_to_cpuset(cs, parent);
@@ -1780,7 +1781,6 @@ static void scan_for_empty_cpusets(const
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
-	mutex_lock(&callback_mutex);
 	while (!list_empty(&queue)) {
 		cp = container_of(queue.next, struct cpuset, stack_list);
 		list_del(queue.next);
@@ -1789,19 +1789,24 @@ static void scan_for_empty_cpusets(const
 			list_add_tail(&child->stack_list, &queue);
 		}
 		cont = cp->css.cgroup;
+
+		/* Continue past cpusets with all cpus, mems online */
+		if (cpus_subset(cp->cpus_allowed, cpu_online_map) &&
+		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
+			continue;
+
 		/* Remove offline cpus and mems from this cpuset. */
+		mutex_lock(&callback_mutex);
 		cpus_and(cp->cpus_allowed, cp->cpus_allowed, cpu_online_map);
 		nodes_and(cp->mems_allowed, cp->mems_allowed,
 						node_states[N_HIGH_MEMORY]);
+		mutex_unlock(&callback_mutex);
+
+	        /* Move tasks from the empty cpuset to a parent */
 		if (cpus_empty(cp->cpus_allowed) ||
-		     nodes_empty(cp->mems_allowed)) {
-		        /* Move tasks from the empty cpuset to a parent */
-			mutex_unlock(&callback_mutex);
+		     nodes_empty(cp->mems_allowed))
 			remove_tasks_in_empty_cpuset(cp);
-			mutex_lock(&callback_mutex);
-		}
 	}
-	mutex_unlock(&callback_mutex);
 }
 
 /*

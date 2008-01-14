Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYANGms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYANGms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 01:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755658AbYANGmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 01:42:07 -0500
Received: from relay1.sgi.com ([192.48.171.29]:41596 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755628AbYANGmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:42:06 -0500
From: Paul Jackson <pj@sgi.com>
To: Cliff Wickman <cpw@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 13 Jan 2008 22:42:05 -0800
Message-Id: <20080114064205.2784.55601.sendpatchset@jackhammer.engr.sgi.com>
Subject: [RFC] hotplug cpu move tasks in empty cpusets - possible refinements
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Query for Cliff:

1) Can we narrow the scope of callback_mutex in scan_for_empty_cpusets()?

2) Can we avoid rewriting the cpus, mems of cpusets except when it is
   likely that we'll be changing them?

3) Should not remove_tasks_in_empty_cpuset() also check for empty mems?

-pj

---

 kernel/cpuset.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- 2.6.24-rc6-mm1.orig/kernel/cpuset.c	2008-01-12 22:04:08.027821401 -0800
+++ 2.6.24-rc6-mm1/kernel/cpuset.c	2008-01-12 22:10:30.701745078 -0800
@@ -1751,7 +1751,8 @@ static void remove_tasks_in_empty_cpuset
 	 * has online cpus, so can't be empty).
 	 */
 	parent = cs->parent;
-	while (cpus_empty(parent->cpus_allowed))
+	while (cpus_empty(parent->cpus_allowed) ||
+			nodes_empty(parent->mems_allowed))
 		parent = parent->parent;
 
 	move_member_tasks_to_cpuset(cs, parent);
@@ -1783,7 +1784,6 @@ static void scan_for_empty_cpusets(const
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
-	mutex_lock(&callback_mutex);
 	while (!list_empty(&queue)) {
 		cp = container_of(queue.next, struct cpuset, stack_list);
 		list_del(queue.next);
@@ -1792,19 +1792,24 @@ static void scan_for_empty_cpusets(const
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

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373

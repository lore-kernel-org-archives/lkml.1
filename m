Return-Path: <linux-kernel-owner+w=401wt.eu-S1764638AbYA2QoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764638AbYA2QoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbYA2Qn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:43:57 -0500
Received: from relay1.sgi.com ([192.48.171.29]:53780 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754256AbYA2Qn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:43:56 -0500
Date: Tue, 29 Jan 2008 10:43:54 -0600
To: linux-kernel@vger.kernel.org
Cc: pj@sgi.com, akpm@osdl.org
Subject: [PATCH 4/4] hotplug cpu move tasks in empty cpusets - refinements
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080129164354.D7E5F33B943@attica.americas.sgi.com>
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


   Narrow the scope of callback_mutex in scan_for_empty_cpusets().
    Avoid rewriting the cpus, mems of cpusets except when it is
         likely that we'll be changing them.
    Have remove_tasks_in_empty_cpuset() also check for empty mems.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Cliff Wickman <cpw@sgi.com>


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
+		/* Move tasks from the empty cpuset to a parent */
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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYANGlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYANGlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 01:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYANGlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 01:41:44 -0500
Received: from relay2.sgi.com ([192.48.171.30]:44462 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751438AbYANGlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:41:44 -0500
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Lee.Schermerhorn@hp.com, Cliff Wickman <cpw@sgi.com>,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>
Date: Sun, 13 Jan 2008 22:41:41 -0800
Message-Id: <20080114064141.2782.77305.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 1/3] hotplug cpu move tasks in empty cpusets to parent node_online_map fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

As of the October 2007 kernel/cpuset.c patch "Memoryless nodes:
Use N_HIGH_MEMORY for cpusets", cpuset nodes are relative to
the nodes with (HIGH) memory, not relative to all nodes in
node_online_map.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>

---

 kernel/cpuset.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- 2.6.24-rc6-mm1.orig/kernel/cpuset.c	2008-01-12 18:52:43.480406969 -0800
+++ 2.6.24-rc6-mm1/kernel/cpuset.c	2008-01-12 19:07:44.330236260 -0800
@@ -1817,7 +1817,8 @@ static void scan_for_empty_cpusets(const
 		cont = cp->css.cgroup;
 		/* Remove offline cpus and mems from this cpuset. */
 		cpus_and(cp->cpus_allowed, cp->cpus_allowed, cpu_online_map);
-		nodes_and(cp->mems_allowed, cp->mems_allowed, node_online_map);
+		nodes_and(cp->mems_allowed, cp->mems_allowed,
+						node_states[N_HIGH_MEMORY]);
 		if ((cpus_empty(cp->cpus_allowed) ||
 		     nodes_empty(cp->mems_allowed))) {
 		        /* Move tasks from the empty cpuset to a parent */
@@ -1832,8 +1833,8 @@ static void scan_for_empty_cpusets(const
 
 /*
  * The cpus_allowed and mems_allowed nodemasks in the top_cpuset track
- * cpu_online_map and node_online_map.  Force the top cpuset to track
- * whats online after any CPU or memory node hotplug or unplug event.
+ * cpu_online_map and node_states[N_HIGH_MEMORY].  Force the top cpuset to
+ * track what's online after any CPU or memory node hotplug or unplug event.
  *
  * Since there are two callers of this routine, one for CPU hotplug
  * events and one for memory node hotplug events, we could have coded

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373

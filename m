Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbYBDRk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbYBDRk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbYBDRks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:40:48 -0500
Received: from relay1.sgi.com ([192.48.171.29]:57534 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755112AbYBDRkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:40:47 -0500
Date: Mon, 04 Feb 2008 11:40:46 -0600
To: linux-kernel@vger.kernel.org
Cc: pj@sgi.com, clameter@sgi.com, rientjes@google.com,
       linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com, akpm@osdl.org
Subject: [PATCH 1/4 v2] hotplug cpu move tasks in empty cpusets to parent
 node_online_map fix
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080204174046.91FA31FE109@attica.americas.sgi.com>
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As of the October 2007 kernel/cpuset.c patch "Memoryless nodes:
Use N_HIGH_MEMORY for cpusets", cpuset nodes are relative to
the nodes with (HIGH) memory, not relative to all nodes in
node_online_map.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Cliff Wickman <cpw@sgi.com>

---

 kernel/cpuset.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/cpuset.c
===================================================================
--- linux-2.6.orig/kernel/cpuset.c
+++ linux-2.6/kernel/cpuset.c
@@ -1762,7 +1762,8 @@ static void scan_for_empty_cpusets(const
 		cont = cp->css.cgroup;
 		/* Remove offline cpus and mems from this cpuset. */
 		cpus_and(cp->cpus_allowed, cp->cpus_allowed, cpu_online_map);
-		nodes_and(cp->mems_allowed, cp->mems_allowed, node_online_map);
+		nodes_and(cp->mems_allowed, cp->mems_allowed,
+						node_states[N_HIGH_MEMORY]);
 		if ((cpus_empty(cp->cpus_allowed) ||
 		     nodes_empty(cp->mems_allowed))) {
 			/* Move tasks from the empty cpuset to a parent */
@@ -1777,8 +1778,8 @@ static void scan_for_empty_cpusets(const
 
 /*
  * The cpus_allowed and mems_allowed nodemasks in the top_cpuset track
- * cpu_online_map and node_online_map.  Force the top cpuset to track
- * whats online after any CPU or memory node hotplug or unplug event.
+ * cpu_online_map and node_states[N_HIGH_MEMORY].  Force the top cpuset to
+ * track what's online after any CPU or memory node hotplug or unplug event.
  *
  * Since there are two callers of this routine, one for CPU hotplug
  * events and one for memory node hotplug events, we could have coded

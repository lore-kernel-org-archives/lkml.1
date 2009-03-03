Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbZCCEvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbZCCEvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 23:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZCCEuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 23:50:35 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3041 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZCCEud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 23:50:33 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=K0mnPjBSkZv1YxKIXYykN7ar+4POSSyrT39Bd30hDAPDpErBe38IsjUzPkERTfrvU
	9bAzbQ1+4UArPWxiY8JRw==
Date: Mon, 2 Mar 2009 20:50:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Paul Menage <menage@google.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/2] cpusets: replace zone allowed functions with node
 allowed
Message-ID: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpuset_zone_allowed() variants are actually only a function of the
zone's node.

Cc: Paul Menage <menage@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/cpuset.h |   33 ++++++++++++++++++++++-----
 kernel/cpuset.c        |   59 ++++++++++++++++++++---------------------------
 2 files changed, 52 insertions(+), 40 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -12,6 +12,7 @@
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
 #include <linux/cgroup.h>
+#include <linux/mm.h>
 
 #ifdef CONFIG_CPUSETS
 
@@ -29,19 +30,29 @@ void cpuset_init_current_mems_allowed(void);
 void cpuset_update_task_memory_state(void);
 int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
 
-extern int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask);
-extern int __cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask);
+extern int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask);
+extern int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask);
 
-static int inline cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
+static inline int cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 {
 	return number_of_cpusets <= 1 ||
-		__cpuset_zone_allowed_softwall(z, gfp_mask);
+		__cpuset_node_allowed_softwall(node, gfp_mask);
 }
 
-static int inline cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
+static inline int cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
 {
 	return number_of_cpusets <= 1 ||
-		__cpuset_zone_allowed_hardwall(z, gfp_mask);
+		__cpuset_node_allowed_hardwall(node, gfp_mask);
+}
+
+static inline int cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
+{
+	return cpuset_node_allowed_softwall(zone_to_nid(z), gfp_mask);
+}
+
+static inline int cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
+{
+	return cpuset_node_allowed_hardwall(zone_to_nid(z), gfp_mask);
 }
 
 extern int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
@@ -112,6 +123,16 @@ static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
 	return 1;
 }
 
+static inline int cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
+{
+	return 1;
+}
+
+static inline int cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
+{
+	return 1;
+}
+
 static inline int cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
 {
 	return 1;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2206,26 +2206,24 @@ static const struct cpuset *nearest_hardwall_ancestor(const struct cpuset *cs)
 }
 
 /**
- * cpuset_zone_allowed_softwall - Can we allocate on zone z's memory node?
- * @z: is this zone on an allowed node?
+ * cpuset_node_allowed_softwall - Can we allocate on a memory node?
+ * @node: is this an allowed node?
  * @gfp_mask: memory allocation flags
  *
- * If we're in interrupt, yes, we can always allocate.  If
- * __GFP_THISNODE is set, yes, we can always allocate.  If zone
- * z's node is in our tasks mems_allowed, yes.  If it's not a
- * __GFP_HARDWALL request and this zone's nodes is in the nearest
- * hardwalled cpuset ancestor to this tasks cpuset, yes.
- * If the task has been OOM killed and has access to memory reserves
- * as specified by the TIF_MEMDIE flag, yes.
+ * If we're in interrupt, yes, we can always allocate.  If __GFP_THISNODE is
+ * set, yes, we can always allocate.  If node is in our task's mems_allowed,
+ * yes.  If it's not a __GFP_HARDWALL request and this node is in the nearest
+ * hardwalled cpuset ancestor to this task's cpuset, yes.  If the task has been
+ * OOM killed and has access to memory reserves as specified by the TIF_MEMDIE
+ * flag, yes.
  * Otherwise, no.
  *
- * If __GFP_HARDWALL is set, cpuset_zone_allowed_softwall()
- * reduces to cpuset_zone_allowed_hardwall().  Otherwise,
- * cpuset_zone_allowed_softwall() might sleep, and might allow a zone
- * from an enclosing cpuset.
+ * If __GFP_HARDWALL is set, cpuset_node_allowed_softwall() reduces to
+ * cpuset_node_allowed_hardwall().  Otherwise, cpuset_node_allowed_softwall()
+ * might sleep, and might allow a node from an enclosing cpuset.
  *
- * cpuset_zone_allowed_hardwall() only handles the simpler case of
- * hardwall cpusets, and never sleeps.
+ * cpuset_node_allowed_hardwall() only handles the simpler case of hardwall
+ * cpusets, and never sleeps.
  *
  * The __GFP_THISNODE placement logic is really handled elsewhere,
  * by forcibly using a zonelist starting at a specified node, and by
@@ -2264,20 +2262,17 @@ static const struct cpuset *nearest_hardwall_ancestor(const struct cpuset *cs)
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
  *
  * Rule:
- *    Don't call cpuset_zone_allowed_softwall if you can't sleep, unless you
+ *    Don't call cpuset_node_allowed_softwall if you can't sleep, unless you
  *    pass in the __GFP_HARDWALL flag set in gfp_flag, which disables
  *    the code that might scan up ancestor cpusets and sleep.
  */
-
-int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
+int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 {
-	int node;			/* node that zone z is on */
 	const struct cpuset *cs;	/* current cpuset ancestors */
 	int allowed;			/* is allocation in zone z allowed? */
 
 	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
 		return 1;
-	node = zone_to_nid(z);
 	might_sleep_if(!(gfp_mask & __GFP_HARDWALL));
 	if (node_isset(node, current->mems_allowed))
 		return 1;
@@ -2306,15 +2301,15 @@ int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
 }
 
 /*
- * cpuset_zone_allowed_hardwall - Can we allocate on zone z's memory node?
- * @z: is this zone on an allowed node?
+ * cpuset_node_allowed_hardwall - Can we allocate on a memory node?
+ * @node: is this an allowed node?
  * @gfp_mask: memory allocation flags
  *
- * If we're in interrupt, yes, we can always allocate.
- * If __GFP_THISNODE is set, yes, we can always allocate.  If zone
- * z's node is in our tasks mems_allowed, yes.   If the task has been
- * OOM killed and has access to memory reserves as specified by the
- * TIF_MEMDIE flag, yes.  Otherwise, no.
+ * If we're in interrupt, yes, we can always allocate.  If __GFP_THISNODE is
+ * set, yes, we can always allocate.  If node is in our task's mems_allowed,
+ * yes.  If the task has been OOM killed and has access to memory reserves as
+ * specified by the TIF_MEMDIE flag, yes.
+ * Otherwise, no.
  *
  * The __GFP_THISNODE placement logic is really handled elsewhere,
  * by forcibly using a zonelist starting at a specified node, and by
@@ -2322,20 +2317,16 @@ int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
  * any node on the zonelist except the first.  By the time any such
  * calls get to this routine, we should just shut up and say 'yes'.
  *
- * Unlike the cpuset_zone_allowed_softwall() variant, above,
- * this variant requires that the zone be in the current tasks
+ * Unlike the cpuset_node_allowed_softwall() variant, above,
+ * this variant requires that the node be in the current task's
  * mems_allowed or that we're in interrupt.  It does not scan up the
  * cpuset hierarchy for the nearest enclosing mem_exclusive cpuset.
  * It never sleeps.
  */
-
-int __cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
+int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
 {
-	int node;			/* node that zone z is on */
-
 	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
 		return 1;
-	node = zone_to_nid(z);
 	if (node_isset(node, current->mems_allowed))
 		return 1;
 	/*

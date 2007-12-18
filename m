Return-Path: <linux-kernel-owner+w=401wt.eu-S1765111AbXLRDDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765111AbXLRDDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 22:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbXLRDDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 22:03:06 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:37873
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750814AbXLRDDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 22:03:04 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] sched: dynamically update the root-domain span/online maps
To: srostedt@redhat.com
Cc: mingo@elte.hu, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, ghaskins@novell.com
Date: Mon, 17 Dec 2007 21:40:32 -0500
Message-ID: <20071218023805.4390.19471.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,
  I posted a suspend-to-ram fix to sched-devel earlier today:

http://lkml.org/lkml/2007/12/17/445

This fix should also be applied to -rt as I introduced the same regression
there.  Here is a version of the fix for 23-rt13.  I can submit a version for
24-rc5-rt1 at your request.

Regards,
-Greg

---------------------------------

The baseline code statically builds the span maps when the domain is formed.
Previous attempts at dynamically updating the maps caused a suspend-to-ram
regression, which should now be fixed.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 244c4b5..95b8c99 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -281,8 +281,6 @@ struct rt_rq {
  * exclusive cpuset is created, we also create and attach a new root-domain
  * object.
  *
- * By default the system creates a single root-domain with all cpus as
- * members (mimicking the global state we have today).
  */
 struct root_domain {
 	atomic_t refcount;
@@ -300,6 +298,10 @@ struct root_domain {
 #endif
 };
 
+/*
+ * By default the system creates a single root-domain with all cpus as
+ * members (mimicking the global state we have today).
+ */
 static struct root_domain def_root_domain;
 
 #endif
@@ -6066,6 +6068,10 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	atomic_inc(&rd->refcount);
 	rq->rd = rd;
 
+	cpu_set(rq->cpu, rd->span);
+	if (cpu_isset(rq->cpu, cpu_online_map))
+		cpu_set(rq->cpu, rd->online);
+
 	for (class = sched_class_highest; class; class = class->next) {
 		if (class->join_domain)
 			class->join_domain(rq);
@@ -6074,12 +6080,12 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
-static void init_rootdomain(struct root_domain *rd, const cpumask_t *map)
+static void init_rootdomain(struct root_domain *rd)
 {
 	memset(rd, 0, sizeof(*rd));
 
-	rd->span = *map;
-	cpus_and(rd->online, rd->span, cpu_online_map);
+	cpus_clear(rd->span);
+	cpus_clear(rd->online);
 
 	cpupri_init(&rd->cpupri);
 
@@ -6087,13 +6093,11 @@ static void init_rootdomain(struct root_domain *rd, const cpumask_t *map)
 
 static void init_defrootdomain(void)
 {
-	cpumask_t cpus = CPU_MASK_ALL;
-
-	init_rootdomain(&def_root_domain, &cpus);
+	init_rootdomain(&def_root_domain);
 	atomic_set(&def_root_domain.refcount, 1);
 }
 
-static struct root_domain *alloc_rootdomain(const cpumask_t *map)
+static struct root_domain *alloc_rootdomain(void)
 {
 	struct root_domain *rd;
 
@@ -6101,7 +6105,7 @@ static struct root_domain *alloc_rootdomain(const cpumask_t *map)
 	if (!rd)
 		return NULL;
 
-	init_rootdomain(rd, map);
+	init_rootdomain(rd);
 
 	return rd;
 }
@@ -6523,7 +6527,7 @@ static int build_sched_domains(const cpumask_t *cpu_map)
 	sched_group_nodes_bycpu[first_cpu(*cpu_map)] = sched_group_nodes;
 #endif
 
-	rd = alloc_rootdomain(cpu_map);
+	rd = alloc_rootdomain();
 	if (!rd) {
 		printk(KERN_WARNING "Cannot alloc root domain\n");
 		return -ENOMEM;
@@ -7021,7 +7025,6 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
-		rq_attach_root(rq, &def_root_domain);
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
 		rq->push_cpu = 0;
@@ -7030,6 +7033,7 @@ void __init sched_init(void)
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq->rt.highest_prio = MAX_RT_PRIO;
 		rq->rt.overloaded = 0;
+		rq_attach_root(rq, &def_root_domain);
 #endif
 		atomic_set(&rq->nr_iowait, 0);
 


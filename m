Return-Path: <linux-kernel-owner+w=401wt.eu-S1760676AbXLRBSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbXLRBSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbXLRBST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:18:19 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:36800
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753092AbXLRBSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:18:17 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] sched: dynamically update the root-domain span/online maps
To: mingo@elte.hu
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
Date: Mon, 17 Dec 2007 19:55:42 -0500
Message-ID: <20071218005217.4957.3055.stgit@novell1.haskins.net>
In-Reply-To: <200712172339.lBHNdmDD008149@imap1.linux-foundation.org>
References: <200712172339.lBHNdmDD008149@imap1.linux-foundation.org>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
   The following patch applies to sched-devel to replace the root-domain patch
   that was reverted as noted here:

http://marc.info/?l=linux-mm-commits&m=119793598429477&w=2

I have confirmed that it builds and boots clean, and it passes checkpatch.
However, my test machine seems to be having problems with suspend-to-ram that
are unrelated to this patch that prevent me from verifying the fix entirely.
If Gautham or Andrew could confirm that it resolves their suspend-to-ram
issue, I would be most appreciative.

Regards,
-Greg

--------------------------------------
sched: dynamically update the root-domain span/online maps

The baseline code statically builds the span maps when the domain is formed.
Previous attempts at dynamically updating the maps caused a suspend-to-ram
regression, which should now be fixed.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dc6fb24..48cfec1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -359,8 +359,6 @@ struct rt_rq {
  * exclusive cpuset is created, we also create and attach a new root-domain
  * object.
  *
- * By default the system creates a single root-domain with all cpus as
- * members (mimicking the global state we have today).
  */
 struct root_domain {
 	atomic_t refcount;
@@ -375,6 +373,10 @@ struct root_domain {
 	atomic_t rto_count;
 };
 
+/*
+ * By default the system creates a single root-domain with all cpus as
+ * members (mimicking the global state we have today).
+ */
 static struct root_domain def_root_domain;
 
 #endif
@@ -5854,6 +5856,9 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 				class->leave_domain(rq);
 		}
 
+		cpu_clear(rq->cpu, old_rd->span);
+		cpu_clear(rq->cpu, old_rd->online);
+
 		if (atomic_dec_and_test(&old_rd->refcount))
 			kfree(old_rd);
 	}
@@ -5861,6 +5866,10 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	atomic_inc(&rd->refcount);
 	rq->rd = rd;
 
+	cpu_set(rq->cpu, rd->span);
+	if (cpu_isset(rq->cpu, cpu_online_map))
+		cpu_set(rq->cpu, rd->online);
+
 	for (class = sched_class_highest; class; class = class->next) {
 		if (class->join_domain)
 			class->join_domain(rq);
@@ -5869,23 +5878,21 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
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
 }
 
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
 
@@ -5893,7 +5900,7 @@ static struct root_domain *alloc_rootdomain(const cpumask_t *map)
 	if (!rd)
 		return NULL;
 
-	init_rootdomain(rd, map);
+	init_rootdomain(rd);
 
 	return rd;
 }
@@ -6314,7 +6321,7 @@ static int build_sched_domains(const cpumask_t *cpu_map)
 	sched_group_nodes_bycpu[first_cpu(*cpu_map)] = sched_group_nodes;
 #endif
 
-	rd = alloc_rootdomain(cpu_map);
+	rd = alloc_rootdomain();
 	if (!rd) {
 		printk(KERN_WARNING "Cannot alloc root domain\n");
 		return -ENOMEM;
@@ -6886,7 +6893,6 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
-		rq_attach_root(rq, &def_root_domain);
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
 		rq->push_cpu = 0;
@@ -6895,6 +6901,7 @@ void __init sched_init(void)
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq->rt.highest_prio = MAX_RT_PRIO;
 		rq->rt.overloaded = 0;
+		rq_attach_root(rq, &def_root_domain);
 #endif
 		atomic_set(&rq->nr_iowait, 0);
 


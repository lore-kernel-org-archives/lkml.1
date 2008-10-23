Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbYJWCJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbYJWCJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYJWCI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:29 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46583 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752536AbYJWCI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:27 -0400
Message-Id: <20081023020826.911588000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:29 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/35] sched: Reduce stack size requirements in kernel/sched.c
Content-Disposition: inline; filename=sched:reduce-stack-usage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use node_to_cpumask_ptr in place of node_to_cpumask to reduce stack
requirements in sched.c

Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/sched.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- linux-2.6.28.orig/kernel/sched.c
+++ linux-2.6.28/kernel/sched.c
@@ -6118,8 +6118,9 @@ static void move_task_off_dead_cpu(int d
 
 	do {
 		/* On same node? */
-		mask = node_to_cpumask(cpu_to_node(dead_cpu));
-		cpus_and(mask, mask, p->cpus_allowed);
+		node_to_cpumask_ptr(pnodemask, cpu_to_node(dead_cpu));
+
+		cpus_and(mask, *pnodemask, p->cpus_allowed);
 		dest_cpu = any_online_cpu(mask);
 
 		/* On any allowed CPU? */
@@ -7127,9 +7128,9 @@ static int cpu_to_allnodes_group(int cpu
 				 struct sched_group **sg, cpumask_t *nodemask)
 {
 	int group;
+	node_to_cpumask_ptr(pnodemask, cpu_to_node(cpu));
 
-	*nodemask = node_to_cpumask(cpu_to_node(cpu));
-	cpus_and(*nodemask, *nodemask, *cpu_map);
+	cpus_and(*nodemask, *pnodemask, *cpu_map);
 	group = first_cpu(*nodemask);
 
 	if (sg)
@@ -7179,9 +7180,9 @@ static void free_sched_groups(const cpum
 
 		for (i = 0; i < nr_node_ids; i++) {
 			struct sched_group *oldsg, *sg = sched_group_nodes[i];
+			node_to_cpumask_ptr(pnodemask, i);
 
-			*nodemask = node_to_cpumask(i);
-			cpus_and(*nodemask, *nodemask, *cpu_map);
+			cpus_and(*nodemask, *pnodemask, *cpu_map);
 			if (cpus_empty(*nodemask))
 				continue;
 

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765978AbYDOUHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765978AbYDOUHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbYDOUH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:07:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46854 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759388AbYDOUHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:07:25 -0400
Message-Id: <20080415200724.450255000@polaris-admin.engr.sgi.com>
References: <20080415200724.217829000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Apr 2008 13:07:25 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] sched: remove another cpumask_t variable from stack
Content-Disposition: inline; filename=cpumask_in_sched
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    * Remove another cpumask_t variable from stack that was missed in the
      last kernel_sched_c updates.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/sched.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- linux-2.6.x86.sched.orig/kernel/sched.c
+++ linux-2.6.x86.sched/kernel/sched.c
@@ -6539,27 +6539,24 @@ static int find_next_best_node(int node,
  * should be one that prevents unnecessary balancing, but also spreads tasks
  * out optimally.
  */
-static cpumask_t sched_domain_node_span(int node)
+static void sched_domain_node_span(int node, cpumask_t *span)
 {
 	nodemask_t used_nodes;
-	cpumask_t span;
 	node_to_cpumask_ptr(nodemask, node);
 	int i;
 
-	cpus_clear(span);
+	cpus_clear(*span);
 	nodes_clear(used_nodes);
 
-	cpus_or(span, span, *nodemask);
+	cpus_or(*span, *span, *nodemask);
 	node_set(node, used_nodes);
 
 	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
 		int next_node = find_next_best_node(node, &used_nodes);
 
 		node_to_cpumask_ptr_next(nodemask, next_node);
-		cpus_or(span, span, *nodemask);
+		cpus_or(*span, *span, *nodemask);
 	}
-
-	return span;
 }
 #endif
 
@@ -6921,7 +6918,7 @@ static int build_sched_domains(const cpu
 
 		sd = &per_cpu(node_domains, i);
 		SD_INIT(sd, NODE);
-		sd->span = sched_domain_node_span(cpu_to_node(i));
+		sched_domain_node_span(cpu_to_node(i), &sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7036,7 +7033,7 @@ static int build_sched_domains(const cpu
 			continue;
 		}
 
-		*domainspan = sched_domain_node_span(i);
+		sched_domain_node_span(i, domainspan);
 		cpus_and(*domainspan, *domainspan, *cpu_map);
 
 		sg = kmalloc_node(sizeof(struct sched_group), GFP_KERNEL, i);

-- 

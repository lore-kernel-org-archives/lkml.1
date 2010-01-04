Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062Ab0ADWhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0ADWhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999Ab0ADWhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:37:17 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46175 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab0ADWhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:37:07 -0500
Message-Id: <20100104223557.143622910@quilx.com>
References: <20100104223439.228028923@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 04 Jan 2010 16:34:45 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V9 6/7] this_cpu ops: Remove pageset_notifier
Content-Disposition: inline; filename=percpu_page_alloc_remove_pageset_notifier
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the pageset notifier since it only marks that a processor
exists on a specific node. Move that code into the vmstat notifier.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/page_alloc.c |   27 ---------------------------
 mm/vmstat.c     |    1 +
 2 files changed, 1 insertion(+), 27 deletions(-)

Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2010-01-04 14:44:26.000000000 -0600
+++ linux-2.6/mm/vmstat.c	2010-01-04 14:44:28.000000000 -0600
@@ -908,6 +908,7 @@ static int __cpuinit vmstat_cpuup_callba
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		start_cpu_timer(cpu);
+		node_set_state(cpu_to_node(cpu), N_CPU);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2010-01-04 14:44:26.000000000 -0600
+++ linux-2.6/mm/page_alloc.c	2010-01-04 14:44:28.000000000 -0600
@@ -3126,27 +3126,6 @@ static void setup_pagelist_highmark(stru
 		pcp->batch = PAGE_SHIFT * 8;
 }
 
-
-static int __cpuinit pageset_cpuup_callback(struct notifier_block *nfb,
-		unsigned long action,
-		void *hcpu)
-{
-	int cpu = (long)hcpu;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		node_set_state(cpu_to_node(cpu), N_CPU);
-		break;
-	default:
-		break;
-	}
-	return ret;
-}
-
-static struct notifier_block __cpuinitdata pageset_notifier =
-	{ &pageset_cpuup_callback, NULL, 0 };
-
 /*
  * Allocate per cpu pagesets and initialize them.
  * Before this call only boot pagesets were available.
@@ -3172,12 +3151,6 @@ void __init setup_per_cpu_pageset(void)
 						percpu_pagelist_fraction));
 		}
 	}
-	/*
-	 * The boot cpu is always the first active.
-	 * The boot node has a processor.
-	 */
-	node_set_state(cpu_to_node(smp_processor_id()), N_CPU);
-	register_cpu_notifier(&pageset_notifier);
 }
 
 static noinline __init_refok

-- 

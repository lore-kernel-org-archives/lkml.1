Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbZLNWE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbZLNWE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbZLNWE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:04:56 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:59429 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520AbZLNWEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:04:52 -0500
Message-Id: <20091214220339.733925940@quilx.com>
References: <20091214220320.665065925@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 14 Dec 2009 16:03:22 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V7 2/8] this_cpu ops: Remove pageset_notifier
Content-Disposition: inline; filename=percpu_page_alloc_remove_pageset_notifier
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the pageset notifier since it only marks that a processor
exists on a specific node. Move that code into the vmstat notifier.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/page_alloc.c |   28 ----------------------------
 mm/vmstat.c     |    1 +
 2 files changed, 1 insertion(+), 28 deletions(-)

Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2009-10-29 15:37:50.000000000 -0500
+++ linux-2.6/mm/vmstat.c	2009-10-29 15:37:54.000000000 -0500
@@ -905,6 +905,7 @@ static int __cpuinit vmstat_cpuup_callba
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		start_cpu_timer(cpu);
+		node_set_state(cpu_to_node(cpu), N_CPU);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2009-10-29 15:37:50.000000000 -0500
+++ linux-2.6/mm/page_alloc.c	2009-10-29 15:37:54.000000000 -0500
@@ -3107,27 +3107,6 @@ static void setup_pagelist_highmark(stru
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
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata pageset_notifier =
-	{ &pageset_cpuup_callback, NULL, 0 };
-
 /*
  * Allocate per cpu pagesets and initialize them.
  * Before this call only boot pagesets were available.
@@ -3153,13 +3132,6 @@ void __init setup_per_cpu_pageset(void)
 						percpu_pagelist_fraction));
 		}
 	}
-
-	/*
-	 * The boot cpu is always the first active.
-	 * The boot node has a processor
-	 */
-	node_set_state(cpu_to_node(smp_processor_id()), N_CPU);
-	register_cpu_notifier(&pageset_notifier);
 }
 
 static noinline __init_refok

-- 

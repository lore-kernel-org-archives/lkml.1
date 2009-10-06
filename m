Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbZJGDE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbZJGDE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZJGDEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:04:55 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:45281 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751323AbZJGDEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:04:54 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20091006233731.985884104@gentwo.org>
References: <20091006233654.815079668@gentwo.org>
User-Agent: quilt/0.46-1
Date: Tue, 06 Oct 2009 19:37:07 -0400
From: cl@linux-foundation.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [this_cpu_xx V5 13/19] this_cpu ops: Remove pageset_notifier
Content-Disposition: inline; filename=this_cpu_remove_pageset_notifier
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
--- linux-2.6.orig/mm/vmstat.c	2009-10-06 18:19:17.000000000 -0500
+++ linux-2.6/mm/vmstat.c	2009-10-06 18:19:20.000000000 -0500
@@ -906,6 +906,7 @@ static int __cpuinit vmstat_cpuup_callba
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		start_cpu_timer(cpu);
+		node_set_state(cpu_to_node(cpu), N_CPU);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2009-10-06 18:19:17.000000000 -0500
+++ linux-2.6/mm/page_alloc.c	2009-10-06 18:19:21.000000000 -0500
@@ -3108,27 +3108,6 @@ static void setup_pagelist_highmark(stru
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
@@ -3154,13 +3133,6 @@ void __init setup_per_cpu_pageset(void)
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

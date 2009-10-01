Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbZJAVbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbZJAVbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZJAVbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:31:13 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:38087 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753002AbZJAVbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:31:09 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 5
	times
Message-Id: <20091001212600.257793664@gentwo.org>
References: <20091001212521.123389189@gentwo.org>
User-Agent: quilt/0.46-1
Date: Thu, 01 Oct 2009 17:25:35 -0400
From: cl@linux-foundation.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [this_cpu_xx V4 14/20] this_cpu ops: Remove pageset_notifier
Content-Disposition: inline; filename=this_cpu_remove_pageset_notifier
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
--- linux-2.6.orig/mm/vmstat.c	2009-09-29 09:02:29.000000000 -0500
+++ linux-2.6/mm/vmstat.c	2009-09-29 09:04:18.000000000 -0500
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
--- linux-2.6.orig/mm/page_alloc.c	2009-09-29 09:04:16.000000000 -0500
+++ linux-2.6/mm/page_alloc.c	2009-09-29 09:04:18.000000000 -0500
@@ -3097,26 +3097,6 @@ static void setup_pagelist_highmark(stru
  */
 static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
 
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
@@ -3141,13 +3121,6 @@ void __init setup_per_cpu_pageset(void)
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

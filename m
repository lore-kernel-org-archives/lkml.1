Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbZFVPlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbZFVPlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbZFVPk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:40:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:54614 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZFVPkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:40:55 -0400
Message-ID: <4A3FA58A.3010909@kernel.org>
Date: Mon, 22 Jun 2009 08:38:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com
CC: Nathan Lynch <ntl@pobox.com>, mel@csn.ul.ie, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       rusty@rustcorp.com.au, steiner@sgi.com, rientjes@google.com,
       containers@lists.linux-foundation.org
Subject: [PATCH] x86: only clear node_states for 64bit
References: <4A05269D.8000701@kernel.org> <20090512111623.GG25923@csn.ul.ie> <4A0A64FB.4080504@kernel.org> <20090513145950.GB28097@csn.ul.ie> <4A0C4910.7090508@kernel.org> <4A0C4A2A.6080009@kernel.org> <20090514095414.ba8356e5.akpm@linux-foundation.org> <4A0C4F67.5080802@kernel.org> <20090514102554.b3a36f19.akpm@linux-foundation.org> <4A0C563A.3020100@kernel.org> <4A2758CB.9090404@kernel.org> <alpine.DEB.1.10.0906041236520.5377@gentwo.org> <4A27FAD4.2010104@kernel.org> <alpine.DEB.1.10.0906041309230.8080@gentwo.org> <4A2803D1.4070001@kernel.org> <m3bpokiv0u.fsf@pobox.com> <4A3B49BA.40100@kernel.org> <m3prd0havh.fsf@pobox.com> <4A3D7419.8040305@kernel.org> <m3my807ug3.fsf@pobox.com>
In-Reply-To: <m3my807ug3.fsf@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan reported that
| commit 73d60b7f747176dbdff826c4127d22e1fd3f9f74
| Author: Yinghai Lu <yinghai@kernel.org>
| Date:   Tue Jun 16 15:33:00 2009 -0700
|
|    page-allocator: clear N_HIGH_MEMORY map before we set it again
|    
|    SRAT tables may contains nodes of very small size.  The arch code may
|    decide to not activate such a node.  However, currently the early boot
|    code sets N_HIGH_MEMORY for such nodes.  These nodes therefore seem to be
|    active although these nodes have no present pages.
|    
|    For 64bit N_HIGH_MEMORY == N_NORMAL_MEMORY, so that works for 64 bit too

the cpuset.mems cgroup attribute on an i386 kvm guest

fix it by only clearing node_states[N_NORMAL_MEMORY] for 64bit only.
and need to do save/restore for that in find_zone_movable_pfn

Reported-by: Nathan Lynch <ntl@pobox.com>
Tested-by: Nathan Lynch <ntl@pobox.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_64.c |    2 ++
 mm/page_alloc.c       |   13 +++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -598,6 +598,8 @@ void __init paging_init(void)
 
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
+	/* clear the default setting with node 0 */
+	nodes_clear(node_states[N_NORMAL_MEMORY]);
 	free_area_init_nodes(max_zone_pfns);
 }
 
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -4037,6 +4037,8 @@ static void __init find_zone_movable_pfn
 	int i, nid;
 	unsigned long usable_startpfn;
 	unsigned long kernelcore_node, kernelcore_remaining;
+	/* save the state before borrow the nodemask */
+	nodemask_t saved_node_state = node_states[N_HIGH_MEMORY];
 	unsigned long totalpages = early_calculate_totalpages();
 	int usable_nodes = nodes_weight(node_states[N_HIGH_MEMORY]);
 
@@ -4064,7 +4066,7 @@ static void __init find_zone_movable_pfn
 
 	/* If kernelcore was not specified, there is no ZONE_MOVABLE */
 	if (!required_kernelcore)
-		return;
+		goto out;
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
 	find_usable_zone_for_movable();
@@ -4163,6 +4165,10 @@ restart:
 	for (nid = 0; nid < MAX_NUMNODES; nid++)
 		zone_movable_pfn[nid] =
 			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
+
+out:
+	/* restore the node_state */
+	node_states[N_HIGH_MEMORY] = saved_node_state;
 }
 
 /* Any regular memory on that node ? */
@@ -4247,11 +4253,6 @@ void __init free_area_init_nodes(unsigne
 						early_node_map[i].start_pfn,
 						early_node_map[i].end_pfn);
 
-	/*
-	 * find_zone_movable_pfns_for_nodes/early_calculate_totalpages init
-	 * that node_mask, clear it at first
-	 */
-	nodes_clear(node_states[N_HIGH_MEMORY]);
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();

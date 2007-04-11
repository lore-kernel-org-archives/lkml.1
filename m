Return-Path: <linux-kernel-owner+w=401wt.eu-S1030342AbXDKXcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030342AbXDKXcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbXDKXcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:32:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:48657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbXDKXcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 19:32:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,396,1170662400"; 
   d="scan'208"; a="72221824:sNHT36408483"
Date: Wed, 11 Apr 2007 16:30:45 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: akpm@linux-foundation.org
Cc: rientjes@google.com, andi@firstfloor.org, clameter@engr.sgi.com,
       dada1@cosmosbay.com, linux-kernel@vger.kernel.org
Subject: [patch] x86_64: more fixes to node_possible_map runtime setup
Message-ID: <20070411233045.GG585@linux-os.sc.intel.com>
References: <200704092205.l39M57AA024903@shell0.pdx.osdl.net> <20070409231328.GE3948@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409231328.GE3948@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 04:13:28PM -0700, Siddha, Suresh B wrote:
> On Mon, Apr 09, 2007 at 03:05:01PM -0700, akpm@linux-foundation.org wrote:
> > Subject: x86_64-set-node_possible_map-at-runtime fix
> > From: David Rientjes <rientjes@google.com>
> > 
> > Clear node_possible_map if numa_emulation() fails for some reason, such as
> > a failed hash shift, but setup_node_range() has already set some fake nodes
> > as online.
> 
> David, Looking at your fix, I think we require more fixes in this area.
> Please review the appended patch. Thanks.

Andrew, Please apply the appended patch. Goes on top of the
x86_64-set-node_possible_map-at-runtime-fix.patch

thanks, suresh
---

Subject: [patch] x86_64: more fixes to node_possible_map runtime setup
From: Suresh Siddha <suresh.b.siddha@intel.com>

More fixes in the failure cases and a small cleanup in numa emulation case.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
---

--- linux-2.6.21-rc6/arch/x86_64/mm/numa.c~	2007-04-09 15:59:03.000000000 -0700
+++ linux-2.6.21-rc6/arch/x86_64/mm/numa.c	2007-04-09 17:44:38.000000000 -0700
@@ -298,7 +298,6 @@ static int __init setup_node_range(int n
 		ret = -1;
 	}
 	nodes[nid].end = *addr;
-	node_set_online(nid);
 	node_set(nid, node_possible_map);
 	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
 	       nodes[nid].start, nodes[nid].end,
@@ -483,7 +482,7 @@ out:
 	 * SRAT.
 	 */
 	remove_all_active_ranges();
-	for_each_online_node(i) {
+	for_each_node_mask(i, node_possible_map) {
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
  		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
@@ -510,11 +509,13 @@ void __init numa_initmem_init(unsigned l
 	if (!numa_off && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
 					  end_pfn << PAGE_SHIFT))
  		return;
+	nodes_clear(node_possible_map);
 #endif
 
 #ifdef CONFIG_K8_NUMA
 	if (!numa_off && !k8_scan_nodes(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT))
 		return;
+	nodes_clear(node_possible_map);
 #endif
 	printk(KERN_INFO "%s\n",
 	       numa_off ? "NUMA turned off" : "No NUMA configuration found");

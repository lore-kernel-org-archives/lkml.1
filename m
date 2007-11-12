Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbXKLXwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbXKLXwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXKLXwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:52:16 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42856 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbXKLXwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:52:15 -0500
Date: Mon, 12 Nov 2007 15:52:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: ak@suse.de
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>, Andy Whitcroft <apw@shadowen.org>
Subject: x86_64: Make sparsemem/vmemmap the default memory model
Message-ID: <Pine.LNX.4.64.0711121549370.29178@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use sparsemem as the only memory model for UP, SMP and NUMA.

Measurements indicate that DISCONTIGMEM has a higher
overhead than sparsemem. And FLATMEMs benefits are minimal. So I think its
best to simply standardize on sparsemem.

Results of page allocator tests (test can be had via git from the slab git
tree on git.kernel.org. See the branch tests)

Measurements in cycle counts. 1000 allocations were performed and then the
average cycle count was calculated.

Order	FlatMem	Discontig	SparseMem
0	  639	  665		  641
1	  567	  647		  593
2	  679	  774		  692
3	  763	  967		  781
4	  961	 1501		  962
5	 1356	 2344		 1392
6	 2224	 3982		 2336
7	 4869	 7225		 5074
8	12500	14048		12732
9	27926	28223		28165
10	58578	58714		58682

If this patch is accepted then we can remove the code for discontig and
flatmem support from x86_64.

(Not sure if I got all the config settings right. Andy?)

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/Kconfig.x86_64 |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

Index: linux-2.6/arch/x86/Kconfig.x86_64
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.x86_64	2007-11-12 15:17:50.721767735 -0800
+++ linux-2.6/arch/x86/Kconfig.x86_64	2007-11-12 15:21:16.659017509 -0800
@@ -390,28 +390,17 @@ config NUMA_EMU
 	  into virtual nodes when booted with "numa=fake=N", where N is the
 	  number of nodes. This is only useful for debugging.
 
-config ARCH_DISCONTIGMEM_ENABLE
-       bool
-       depends on NUMA
-       default y
-
-config ARCH_DISCONTIGMEM_DEFAULT
+config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
-	depends on NUMA
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
-	depends on (NUMA || EXPERIMENTAL)
 	select SPARSEMEM_VMEMMAP_ENABLE
 
 config ARCH_MEMORY_PROBE
 	def_bool y
 	depends on MEMORY_HOTPLUG
 
-config ARCH_FLATMEM_ENABLE
-	def_bool y
-	depends on !NUMA
-
 source "mm/Kconfig"
 
 config MEMORY_HOTPLUG_RESERVE

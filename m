Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbXD0Qt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbXD0Qt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbXD0Qt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:49:28 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:42997 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbXD0Qt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:49:27 -0400
Date: Fri, 27 Apr 2007 17:49:24 +0100
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>,
       suresh.b.siddha@intel.com
Subject: Re: [PATCH] Add vDSO for x86-64 with gettimeofday/clock_gettime/getcpu fix
Message-ID: <20070427164923.GA24574@skynet.ie>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070427085958.GA3645@skynet.ie> <20070427155005.GA20839@skynet.ie> <200704271834.13249.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200704271834.13249.ak@suse.de>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (27/04/07 18:34), Andi Kleen didst pronounce:
> On Friday 27 April 2007 17:50:06 Mel Gorman wrote:
> > On (27/04/07 09:59), Mel Gorman didst pronounce:
> > > On (27/04/07 02:39), Andi Kleen didst pronounce:
> > > > 
> > > > 
> > > > > That's vdso.lds.S, not vdso.lds. The VDSO_TEXT_OFFSET is still 0x400.
> > > > > This is what I should have posted the last time
> > > > > 
> > > > > --- build/arch/x86_64/vdso/voffset.h.orig	2007-04-26 08:43:31.523739878 -0700
> > > > > +++ build/arch/x86_64/vdso/voffset.h	2007-04-26 08:43:38.839579356 -0700
> > > > > @@ -1 +1 @@
> > > > > -#define VDSO_TEXT_OFFSET 0x500
> > > > > +#define VDSO_TEXT_OFFSET 0x400
> > > > 
> > > > It's definitely 0x400 here. Is your patch reversed and you want 0x500? 
> > > > 
> > > 
> > > Sorry, that patch is reversed. It's 0x500 it needs to be to work here.
> > > 
> > 
> > What I should have done in the first place..... Sorry for the noise.
> 
> I had already fixed it up. 
> 

Cool

> But now can you test Suresh's latest patch too please?

I did earlier and it had merge problems. I had responded to the and I see
it in my sent-mail and Andy says he received it but it hasn't shown up on
lkml so somehow I screwed up. Here is the response again.

===== Rend earlier response =====
On (26/04/07 16:40), Siddha, Suresh B didst pronounce:
> On Thu, Apr 26, 2007 at 06:40:36PM +0100, Mel Gorman wrote:
> > NODE_DATA(0) was returning NULL because of
> > x86_64-set-node_possible_map-at-runtime.patch. This patch appears to
> > break acpi_scan_nodes() so that setup_node_bootmem() never gets called and
> > node_data[] remains full of zeros. Later on, reserve_bootmem_generic() is
> > called but with NODE_DATA(0) == NULL, it all goes pear shaped. Author of
> > patch cc'd.
> 
> oops. Appended patch should fix this. Can you please check this and Ack it?
> 

This patch does not apply cleanly to 2.6.21-rc7-mm2. Nor does
x86_64-set-node_possible_map-at-runtime.patch backout cleanly and when rejects
are fixed up, this patch still not apply cleanly . After fixing rejects
I ended up with the patch below that applies on top of 2.6.21-rc7-mm2. It
booted but it's not clear if the end result is what you intended.  Could you
send a patch that applies cleanly on top of 2.6.21-rc7-mm2 and I'll give it
a test please? Thanks

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc7-mm2-clean/arch/x86_64/mm/numa.c linux-2.6.21-rc7-mm2-scratch/arch/x86_64/mm/numa.c
--- linux-2.6.21-rc7-mm2-clean/arch/x86_64/mm/numa.c	2007-04-27 10:24:47.000000000 +0100
+++ linux-2.6.21-rc7-mm2-scratch/arch/x86_64/mm/numa.c	2007-04-27 11:00:40.000000000 +0100
@@ -298,7 +298,7 @@ static int __init setup_node_range(int n
 		ret = -1;
 	}
 	nodes[nid].end = *addr;
-	node_set(nid, node_possible_map);
+	node_set_online(nid);
 	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
 	       nodes[nid].start, nodes[nid].end,
 	       (nodes[nid].end - nodes[nid].start) >> 20);
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc7-mm2-clean/arch/x86_64/mm/srat.c linux-2.6.21-rc7-mm2-scratch/arch/x86_64/mm/srat.c
--- linux-2.6.21-rc7-mm2-clean/arch/x86_64/mm/srat.c	2007-04-27 10:24:47.000000000 +0100
+++ linux-2.6.21-rc7-mm2-scratch/arch/x86_64/mm/srat.c	2007-04-27 10:58:33.000000000 +0100
@@ -25,6 +25,7 @@ int acpi_numa __initdata;
 
 static struct acpi_table_slit *acpi_slit;
 
+static nodemask_t nodes_parsed __initdata;
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
 static int found_add_area __initdata;
@@ -42,7 +43,7 @@ static __init int setup_node(int pxm)
 static __init int conflicting_nodes(unsigned long start, unsigned long end)
 {
 	int i;
-	for_each_node_mask(i, node_possible_map) {
+	for_each_node_mask(i, nodes_parsed) {
 		struct bootnode *nd = &nodes[i];
 		if (nd->start == nd->end)
 			continue;
@@ -320,7 +321,7 @@ acpi_numa_memory_affinity_init(struct ac
 	}
 	nd = &nodes[node];
 	oldnode = *nd;
-	if (!node_test_and_set(node, node_possible_map)) {
+	if (!node_test_and_set(node, nodes_parsed)) {
 		nd->start = start;
 		nd->end = end;
 	} else {
@@ -343,7 +344,7 @@ acpi_numa_memory_affinity_init(struct ac
 		printk(KERN_NOTICE "SRAT: Hotplug region ignored\n");
 		*nd = oldnode;
 		if ((nd->start | nd->end) == 0)
-			node_clear(node, node_possible_map);
+			node_clear(node, nodes_parsed);
 	}
 }
 
@@ -355,7 +356,7 @@ static int nodes_cover_memory(void)
 	unsigned long pxmram, e820ram;
 
 	pxmram = 0;
-	for_each_node_mask(i, node_possible_map) {
+	for_each_node_mask(i, nodes_parsed) {
 		unsigned long s = nodes[i].start >> PAGE_SHIFT;
 		unsigned long e = nodes[i].end >> PAGE_SHIFT;
 		pxmram += e - s;
@@ -379,7 +380,7 @@ static int nodes_cover_memory(void)
 static void unparse_node(int node)
 {
 	int i;
-	node_clear(node, node_possible_map);
+	node_clear(node, nodes_parsed);
 	for (i = 0; i < MAX_LOCAL_APIC; i++) {
 		if (apicid_to_node[i] == node)
 			apicid_to_node[i] = NUMA_NO_NODE;
@@ -418,6 +419,8 @@ int __init acpi_scan_nodes(unsigned long
 		return -1;
 	}
 
+	node_possible_map = nodes_parsed;
+
 	/* Finally register nodes */
 	for_each_node_mask(i, node_possible_map)
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);

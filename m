Return-Path: <linux-kernel-owner+w=401wt.eu-S935481AbYBAFEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935481AbYBAFEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935535AbYBAE6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:58:42 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:48965 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935950AbYBAE6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:58:40 -0500
Date: Fri, 1 Feb 2008 10:27:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>,
       Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH powerpc] Fake NUMA emulation for PowerPC (Take 4)
Message-ID: <20080201045731.GA29448@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Michael Ellerman <michael@ellerman.id.au>,
	Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop> <1200634493.7806.0.camel@concordia.ozlabs.ibm.com> <1200635099.7806.3.camel@concordia.ozlabs.ibm.com> <20080126071339.GA25328@balbir.in.ibm.com> <18332.28991.658933.763115@cargo.ozlabs.ibm.com> <20080128125206.GC4330@balbir.in.ibm.com> <1201611898.26410.7.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1201611898.26410.7.camel@concordia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Ellerman <michael@ellerman.id.au> [2008-01-30 00:04:58]:

> Why do you check !p after assigning to nid? I assume it's because we
> might have reached the end of the command line, ie. p == NULL, but we're
> still adding memory to the last node? If so it's a it's a little subtle
> and deserves a comment I think.
> 
> Otherwise this looks pretty good.
> 
> cheers
> 

Hi, Paul,

Could you please consider version 4 for inclusion?


Changelong v4

1. Add more comments around the checks for command line arguments.

Changelog v3
1. Remove the side-effect of not setting nodes online if they end
   up having no memory in them because of the memory limit.

Changelog v2

1. Get rid of the constant 5 (based on comments from
                                Geert.Uytterhoeven@sonycom.com)
2. Implement suggestions from Olof Johannson
3. Check if cmdline is NULL in fake_numa_create_new_node()

Tested with additional parameters from Olof

numa=debug,fake=
numa=foo,fake=bar


Here's a dumb simple implementation of fake NUMA nodes for PowerPC. Fake
NUMA nodes can be specified using the following command line option

numa=fake=<node range>

node range is of the format <range1>,<range2>,...<rangeN>

Each of the rangeX parameters is passed using memparse(). I find the patch
useful for fake NUMA emulation on my simple PowerPC machine. I've tested it
on a numa box with the following arguments

numa=fake=512M
numa=fake=512M,768M
numa=fake=256M,512M mem=512M
numa=fake=1G mem=768M
numa=fake=
without any numa= argument

The other side-effect introduced by this patch is that; in the case where we
don't have NUMA information, we now set a node online after adding each LMB.
This node could very well be node 0, but in the case that we enable fake
NUMA nodes, when we cross node boundaries, we need to set the new node online.


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 arch/powerpc/mm/numa.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/mm/numa.c~fakenumappc arch/powerpc/mm/numa.c
--- linux-2.6.24-rc8/arch/powerpc/mm/numa.c~fakenumappc	2008-01-28 17:05:34.000000000 +0530
+++ linux-2.6.24-rc8-balbir/arch/powerpc/mm/numa.c	2008-02-01 10:24:57.000000000 +0530
@@ -24,6 +24,8 @@
 
 static int numa_enabled = 1;
 
+static char *cmdline __initdata;
+
 static int numa_debug;
 #define dbg(args...) if (numa_debug) { printk(KERN_INFO args); }
 
@@ -39,6 +41,53 @@ static bootmem_data_t __initdata plat_no
 static int min_common_depth;
 static int n_mem_addr_cells, n_mem_size_cells;
 
+static int __cpuinit fake_numa_create_new_node(unsigned long end_pfn,
+						unsigned int *nid)
+{
+	unsigned long long mem;
+	char *p = cmdline;
+	static unsigned int fake_nid;
+	static unsigned long long curr_boundary;
+
+	/*
+	 * Modify node id, iff we started creating NUMA nodes
+	 * We want to continue from where we left of the last time
+	 */
+	if (fake_nid)
+		*nid = fake_nid;
+	/*
+	 * In case there are no more arguments to parse, the
+	 * node_id should be the same as the last fake node id
+	 * (we've handled this above).
+	 */
+	if (!p)
+		return 0;
+
+	mem = memparse(p, &p);
+	if (!mem)
+		return 0;
+
+	if (mem < curr_boundary)
+		return 0;
+
+	curr_boundary = mem;
+
+	if ((end_pfn << PAGE_SHIFT) > mem) {
+		/*
+		 * Skip commas and spaces
+		 */
+		while (*p == ',' || *p == ' ' || *p == '\t')
+			p++;
+
+		cmdline = p;
+		fake_nid++;
+		*nid = fake_nid;
+		dbg("created new fake_node with id %d\n", fake_nid);
+		return 1;
+	}
+	return 0;
+}
+
 static void __cpuinit map_cpu_to_node(int cpu, int node)
 {
 	numa_cpu_lookup_table[cpu] = node;
@@ -344,6 +393,9 @@ static void __init parse_drconf_memory(s
 			if (nid == 0xffff || nid >= MAX_NUMNODES)
 				nid = default_nid;
 		}
+
+		fake_numa_create_new_node(((start + lmb_size) >> PAGE_SHIFT),
+						&nid);
 		node_set_online(nid);
 
 		size = numa_enforce_memory_limit(start, lmb_size);
@@ -429,6 +481,8 @@ new_range:
 		nid = of_node_to_nid_single(memory);
 		if (nid < 0)
 			nid = default_nid;
+
+		fake_numa_create_new_node(((start + size) >> PAGE_SHIFT), &nid);
 		node_set_online(nid);
 
 		if (!(size = numa_enforce_memory_limit(start, size))) {
@@ -461,7 +515,7 @@ static void __init setup_nonnuma(void)
 	unsigned long top_of_ram = lmb_end_of_DRAM();
 	unsigned long total_ram = lmb_phys_mem_size();
 	unsigned long start_pfn, end_pfn;
-	unsigned int i;
+	unsigned int i, nid = 0;
 
 	printk(KERN_DEBUG "Top of RAM: 0x%lx, Total RAM: 0x%lx\n",
 	       top_of_ram, total_ram);
@@ -471,9 +525,11 @@ static void __init setup_nonnuma(void)
 	for (i = 0; i < lmb.memory.cnt; ++i) {
 		start_pfn = lmb.memory.region[i].base >> PAGE_SHIFT;
 		end_pfn = start_pfn + lmb_size_pages(&lmb.memory, i);
-		add_active_range(0, start_pfn, end_pfn);
+
+		fake_numa_create_new_node(end_pfn, &nid);
+		add_active_range(nid, start_pfn, end_pfn);
+		node_set_online(nid);
 	}
-	node_set_online(0);
 }
 
 void __init dump_numa_cpu_topology(void)
@@ -702,6 +758,10 @@ static int __init early_numa(char *p)
 	if (strstr(p, "debug"))
 		numa_debug = 1;
 
+	p = strstr(p, "fake=");
+	if (p)
+		cmdline = p + strlen("fake=");
+
 	return 0;
 }
 early_param("numa", early_numa);
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

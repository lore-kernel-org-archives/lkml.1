Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbYA1Mwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbYA1Mwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbYA1Mw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:52:27 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:50687 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755494AbYA1Mw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:52:26 -0500
Date: Mon, 28 Jan 2008 18:22:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH powerpc] Fake NUMA emulation for PowerPC (Take 3)
Message-ID: <20080128125206.GC4330@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Paul Mackerras <paulus@samba.org>,
	Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop> <1200634493.7806.0.camel@concordia.ozlabs.ibm.com> <1200635099.7806.3.camel@concordia.ozlabs.ibm.com> <20080126071339.GA25328@balbir.in.ibm.com> <18332.28991.658933.763115@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <18332.28991.658933.763115@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mackerras <paulus@samba.org> [2008-01-27 22:55:43]:

> Balbir Singh writes:
> 
> > Here's a better and more complete fix for the problem. Could you
> > please see if it works for you? I tested it on a real NUMA box and it
> > seemed to work fine there.
> 
> There are a couple of other changes in behaviour that your patch
> introduces, and I'd like to understand them better before taking the
> patch.  First, with your patch we don't set nodes online if they end
> up having no memory in them because of the memory limit, whereas
> previously we did.  Secondly, in the case where we don't have NUMA
> information, we now set node 0 online after adding each LMB, whereas
> previously we only set it online once.
> 
> If in fact these changes are benign, then your patch description
> should mention them and explain why they are benign.
> 
> Paul.
>

Hi, Paul,

Here's version 3 of the patch. I've commented the side-effect of
repeatedly setting node 0 online (as to why that is done) and I've
removed the side effect of not creating memory less nodes
(when we hit the memory limit).

I've described all my tests below
 
Changelog v3
1. Remove the side-effect of not setting nodes online if they end
   up having no memory in them because of the memory limit.

Changelog v2

1. Get rid of the constant 5 (based on comments from
                                Geert.Uytterhoeven@sonycom.com)
2. Implement suggestions from Olof Johannson
3. Check if cmdline is NULL in fake_numa_create_new_node()

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

 arch/powerpc/mm/numa.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/mm/numa.c~fakenumappc arch/powerpc/mm/numa.c
--- linux-2.6.24-rc8/arch/powerpc/mm/numa.c~fakenumappc	2008-01-28 17:05:34.000000000 +0530
+++ linux-2.6.24-rc8-balbir/arch/powerpc/mm/numa.c	2008-01-28 18:15:41.000000000 +0530
@@ -24,6 +24,8 @@
 
 static int numa_enabled = 1;
 
+static char *cmdline __initdata;
+
 static int numa_debug;
 #define dbg(args...) if (numa_debug) { printk(KERN_INFO args); }
 
@@ -39,6 +41,47 @@ static bootmem_data_t __initdata plat_no
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
+	 */
+	if (fake_nid)
+		*nid = fake_nid;
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
@@ -344,6 +387,9 @@ static void __init parse_drconf_memory(s
 			if (nid == 0xffff || nid >= MAX_NUMNODES)
 				nid = default_nid;
 		}
+
+		fake_numa_create_new_node(((start + lmb_size) >> PAGE_SHIFT),
+						&nid);
 		node_set_online(nid);
 
 		size = numa_enforce_memory_limit(start, lmb_size);
@@ -429,6 +475,8 @@ new_range:
 		nid = of_node_to_nid_single(memory);
 		if (nid < 0)
 			nid = default_nid;
+
+		fake_numa_create_new_node(((start + size) >> PAGE_SHIFT), &nid);
 		node_set_online(nid);
 
 		if (!(size = numa_enforce_memory_limit(start, size))) {
@@ -461,7 +509,7 @@ static void __init setup_nonnuma(void)
 	unsigned long top_of_ram = lmb_end_of_DRAM();
 	unsigned long total_ram = lmb_phys_mem_size();
 	unsigned long start_pfn, end_pfn;
-	unsigned int i;
+	unsigned int i, nid = 0;
 
 	printk(KERN_DEBUG "Top of RAM: 0x%lx, Total RAM: 0x%lx\n",
 	       top_of_ram, total_ram);
@@ -471,9 +519,11 @@ static void __init setup_nonnuma(void)
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
@@ -702,6 +752,10 @@ static int __init early_numa(char *p)
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

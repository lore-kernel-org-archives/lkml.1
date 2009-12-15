Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbZLOVoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbZLOVoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbZLOVoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:44:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:37082 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757677AbZLOVoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:44:17 -0500
Message-ID: <4B2802E4.40404@kernel.org>
Date: Tue, 15 Dec 2009 13:43:00 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>
Subject: Re: kexec boot regression
References: <4B27E817.6030705@kernel.org> <20091215195111.GV28252@kernel.dk> <4B27EE38.1050103@kernel.org> <20091215201909.GY28252@kernel.dk> <4B27EFC2.1000505@kernel.org> <20091215204221.GZ28252@kernel.dk> <20091215205512.GA28252@kernel.dk> <20091215210126.GB28252@kernel.dk> <4B27FEFB.30902@kernel.org> <20091215213032.GC28252@kernel.dk> <20091215214009.GD28252@kernel.dk>
In-Reply-To: <20091215214009.GD28252@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------030902050905090103040605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030902050905090103040605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> On Tue, Dec 15 2009, Jens Axboe wrote:
>> On Tue, Dec 15 2009, Yinghai Lu wrote:
>>> Jens Axboe wrote:
>>>> On Tue, Dec 15 2009, Jens Axboe wrote:
>>>>> On Tue, Dec 15 2009, Jens Axboe wrote:
>>>>>> On Tue, Dec 15 2009, Yinghai Lu wrote:
>>>>>>> Jens Axboe wrote:
>>>>>>>> On Tue, Dec 15 2009, Yinghai Lu wrote:
>>>>>>>>> Jens Axboe wrote:
>>>>>>>>>> On Tue, Dec 15 2009, Yinghai Lu wrote:
>>>>>>>>>>> Jens Axboe wrote:
>>>>>>>>>>>> On Tue, Dec 15 2009, Yinghai Lu wrote:
>>>>>>>>>>>>> [PATCH] x86/pci: intel ioh bus num reg accessing fix
>>>>>>>>>>>>>
>>>>>>>>>>>>> it is above 0x100, so if mmconf is not enable, need to skip it
>>>>>>>>>>>> This works, it kexecs kernels fine. But since 2.6.32 doesn't have the
>>>>>>>>>>>> mmconf problem to begin with, are we now just working around the issue?
>>>>>>>>>>>> SRAT still reports issues, numa doesn't work.
>>>>>>>>>>> that patch will be bullet proof... we need it.
>>>>>>>>>>>
>>>>>>>>>>> also still need to figure out why memmap range is not passed properly.
>>>>>>>>>>>
>>>>>>>>>>> do you mean 2.6.32 kexec 2.6.32 it have worked mmconf and numa in
>>>>>>>>>>> second kernel?
>>>>>>>>>> Yes, 2.6.32 booted and 2.6.32 kexec'ed works just fine, no SRAT
>>>>>>>>>> complaints and NUMA works fine.
>>>>>>>>> do you need 
>>>>>>>>> memmap=62G@4G
>>>>>>>>> in this case?
>>>>>>>> Yes, I've needed that always.
>>>>>>> good,
>>>>>>>
>>>>>>> can you enable debug option in kexec to see why kexec can not pass
>>>>>>> whole 38? range to second kernel?
>>>>>> Not getting any output so far, -d doesn't do much. Poking around in the
>>>>>> source...
>>>>> OK, cold boot and kexec 2.0.1 gets all 39 ranges passed properly to
>>>>> kexec'ed kernels. Since the older kexec stopped at range 30 (31 ranges
>>>>> total), that smells like just a kexec bug. Retesting -git...
>>>> Current -git works fine when all the ranges are passed correctly. So, I
>>>> think, the only existing regression is the SRAT issue.
>>> did you change node_shift?
>> Yes:
>>
>> CONFIG_NODES_SHIFT=6
>>
>> What I don't get is that 2.6.32 and -git print the same PXM map, and in
>> both cases it's totalling exactly 64G. Yet it says:
>>
>> SRAT: PXMs only cover 49035MB of your 65419MB e820 RAM. Not used.
> 
> Clue:
> 
> [    0.000000] SRAT: Node 0 PXM 0 0-80000000
> [    0.000000] SRAT: Node 0 PXM 0 100000000-480000000
> [    0.000000] SRAT: Node 2 PXM 1 480000000-880000000
> [    0.000000] SRAT: Node 1 PXM 2 880000000-c80000000
> [    0.000000] SRAT: Node 3 PXM 3 c80000000-1080000000
> [    0.000000] NUMA: Using 31 for the hash shift.
> [    0.000000] pxm0: 0-480000 (4718592), absent 553990
> [    0.000000] pxm1: 880000-c80000 (4194304), absent 0
> [    0.000000] pxm2: 480000-880000 (4194304), absent 4194304
> [    0.000000] pxm3: c80000-1080000 (4194304), absent 0
> [    0.000000] SRAT: PXMs only cover 49035MB of your 65419MB e820 RAM.  Not used.
> [    0.000000] SRAT: SRAT not used.
> 

oh, i post one patch last week, 

can you check it?

YH

--------------030902050905090103040605
Content-Type: message/rfc822;
 name="Attached Message"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Attached Message"

Message-ID: <4B2579D2.3010201@kernel.org>
Date: Sun, 13 Dec 2009 15:33:38 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, 
 "H. Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>, 
 Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix checking of SRAT when node0 ram is not from 0 -v2
References: <4B249143.5050300@kernel.org>
In-Reply-To: <4B249143.5050300@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



Found one system that boot from socket1 instead of socket0, SRAT get rejected...

[    0.000000] SRAT: Node 1 PXM 0 0-a0000
[    0.000000] SRAT: Node 1 PXM 0 100000-80000000
[    0.000000] SRAT: Node 1 PXM 0 100000000-2080000000
[    0.000000] SRAT: Node 0 PXM 1 2080000000-4080000000
[    0.000000] SRAT: Node 2 PXM 2 4080000000-6080000000
[    0.000000] SRAT: Node 3 PXM 3 6080000000-8080000000
[    0.000000] SRAT: Node 4 PXM 4 8080000000-a080000000
[    0.000000] SRAT: Node 5 PXM 5 a080000000-c080000000
[    0.000000] SRAT: Node 6 PXM 6 c080000000-e080000000
[    0.000000] SRAT: Node 7 PXM 7 e080000000-10080000000
...
[    0.000000] NUMA: Allocated memnodemap from 500000 - 701040
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Adding active range (0, 0x2080000, 0x4080000) 0 entries of 3200 used
[    0.000000] Adding active range (1, 0x0, 0x96) 1 entries of 3200 used
[    0.000000] Adding active range (1, 0x100, 0x7f750) 2 entries of 3200 used
[    0.000000] Adding active range (1, 0x100000, 0x2080000) 3 entries of 3200 used
[    0.000000] Adding active range (2, 0x4080000, 0x6080000) 4 entries of 3200 used
[    0.000000] Adding active range (3, 0x6080000, 0x8080000) 5 entries of 3200 used
[    0.000000] Adding active range (4, 0x8080000, 0xa080000) 6 entries of 3200 used
[    0.000000] Adding active range (5, 0xa080000, 0xc080000) 7 entries of 3200 used
[    0.000000] Adding active range (6, 0xc080000, 0xe080000) 8 entries of 3200 used
[    0.000000] Adding active range (7, 0xe080000, 0x10080000) 9 entries of 3200 used
[    0.000000] SRAT: PXMs only cover 917504MB of your 1048566MB e820 RAM. Not used.
[    0.000000] SRAT: SRAT not used.

the early_node_map is not sorted because node0 with non zero start come first.

so try to sort it right away after all regions are registered.

-v2: make it more solid to handle cross node case like node0 [0,4g), [8,12g) and node1 [4g, 8g), [12g, 16g)

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/srat_32.c |    2 ++
 arch/x86/mm/srat_64.c |    4 +++-
 include/linux/mm.h    |    3 +++
 mm/page_alloc.c       |    4 ++--
 4 files changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/srat_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_32.c
+++ linux-2.6/arch/x86/mm/srat_32.c
@@ -267,6 +267,8 @@ int __init get_memcfg_from_srat(void)
 		e820_register_active_regions(chunk->nid, chunk->start_pfn,
 					     min(chunk->end_pfn, max_pfn));
 	}
+	/* for out of order entries in SRAT */
+	sort_node_map();
 
 	for_each_online_node(nid) {
 		unsigned long start = node_start_pfn[nid];
Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -317,7 +317,7 @@ static int __init nodes_cover_memory(con
 		unsigned long s = nodes[i].start >> PAGE_SHIFT;
 		unsigned long e = nodes[i].end >> PAGE_SHIFT;
 		pxmram += e - s;
-		pxmram -= absent_pages_in_range(s, e);
+		pxmram -= __absent_pages_in_range(i, s, e);
 		if ((long)pxmram < 0)
 			pxmram = 0;
 	}
@@ -373,6 +373,8 @@ int __init acpi_scan_nodes(unsigned long
 	for_each_node_mask(i, nodes_parsed)
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
+	/* for out of order entries in SRAT */
+	sort_node_map();
 	if (!nodes_cover_memory(nodes)) {
 		bad_srat();
 		return -1;
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -1022,6 +1022,9 @@ extern void add_active_range(unsigned in
 extern void remove_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
 extern void remove_all_active_ranges(void);
+void sort_node_map(void);
+unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
+						unsigned long end_pfn);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3573,7 +3573,7 @@ static unsigned long __meminit zone_span
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-static unsigned long __meminit __absent_pages_in_range(int nid,
+unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
@@ -4102,7 +4102,7 @@ static int __init cmp_node_active_region
 }
 
 /* sort the node_map by start_pfn */
-static void __init sort_node_map(void)
+void __init sort_node_map(void)
 {
 	sort(early_node_map, (size_t)nr_nodemap_entries,
 			sizeof(struct node_active_region),


--------------030902050905090103040605--

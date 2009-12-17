Return-Path: <linux-kernel-owner+w=401wt.eu-S932836AbZLQBCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbZLQBCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763349AbZLQBCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:02:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:38919 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763573AbZLQBB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:01:56 -0500
Date: Thu, 17 Dec 2009 01:01:28 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, jens.axboe@oracle.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, jens.axboe@oracle.com
In-Reply-To: <4B2579D2.3010201@kernel.org>
References: <4B2579D2.3010201@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix checking of SRAT when node 0 ram is not from 0
Message-ID: <tip-329962503692b42d8088f31584e42d52db179d52@git.kernel.org>
Git-Commit-ID: 329962503692b42d8088f31584e42d52db179d52
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  329962503692b42d8088f31584e42d52db179d52
Gitweb:     http://git.kernel.org/tip/329962503692b42d8088f31584e42d52db179d52
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 15 Dec 2009 17:59:02 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 16 Dec 2009 16:43:37 -0800

x86: Fix checking of SRAT when node 0 ram is not from 0

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

also fixs refression by 8716273c (x86: Export srat physical topology)

-v2: make it more solid to handle cross node case like node0 [0,4g), [8,12g) and node1 [4g, 8g), [12g, 16g)
-v3: update comments.

Reported-and-tested-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4B2579D2.3010201@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/srat_32.c |    2 ++
 arch/x86/mm/srat_64.c |    4 +++-
 include/linux/mm.h    |    3 +++
 mm/page_alloc.c       |    4 ++--
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 6f8aa33..9324f13 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -267,6 +267,8 @@ int __init get_memcfg_from_srat(void)
 		e820_register_active_regions(chunk->nid, chunk->start_pfn,
 					     min(chunk->end_pfn, max_pfn));
 	}
+	/* for out of order entries in SRAT */
+	sort_node_map();
 
 	for_each_online_node(nid) {
 		unsigned long start = node_start_pfn[nid];
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index d890754..a271241 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -317,7 +317,7 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 		unsigned long s = nodes[i].start >> PAGE_SHIFT;
 		unsigned long e = nodes[i].end >> PAGE_SHIFT;
 		pxmram += e - s;
-		pxmram -= absent_pages_in_range(s, e);
+		pxmram -= __absent_pages_in_range(i, s, e);
 		if ((long)pxmram < 0)
 			pxmram = 0;
 	}
@@ -373,6 +373,8 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 	for_each_node_mask(i, nodes_parsed)
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
+	/* for out of order entries in SRAT */
+	sort_node_map();
 	if (!nodes_cover_memory(nodes)) {
 		bad_srat();
 		return -1;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 24c3956..20a2036 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1022,6 +1022,9 @@ extern void add_active_range(unsigned int nid, unsigned long start_pfn,
 extern void remove_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
 extern void remove_all_active_ranges(void);
+void sort_node_map(void);
+unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
+						unsigned long end_pfn);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2bc2ac6..873c863 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3573,7 +3573,7 @@ static unsigned long __meminit zone_spanned_pages_in_node(int nid,
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-static unsigned long __meminit __absent_pages_in_range(int nid,
+unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
@@ -4102,7 +4102,7 @@ static int __init cmp_node_active_region(const void *a, const void *b)
 }
 
 /* sort the node_map by start_pfn */
-static void __init sort_node_map(void)
+void __init sort_node_map(void)
 {
 	sort(early_node_map, (size_t)nr_nodemap_entries,
 			sizeof(struct node_active_region),

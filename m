Return-Path: <linux-kernel-owner+w=401wt.eu-S1764187AbYDPMt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764187AbYDPMt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 08:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763419AbYDPMsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:48:16 -0400
Received: from saeurebad.de ([85.214.36.134]:58566 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763412AbYDPMsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:48:15 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Wed Apr 16 13:37:19 2008
Message-Id: <20080416113719.395268372@skyscraper.fehenstaub.lan>
References: <20080416113629.947746497@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 13:36:33 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux MM <linux-mm@kvack.org>
Subject: [RFC][patch 4/5] mm: Normalize internal argument passing of bootmem data
Content-Disposition: inline; filename=0004-bootmem-Normalize-internal-argument-passing-of-boot.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All _core functions only need the bootmem data, not the node
descriptor.  Adjust the two functions that take a node descriptor
unneededly.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 mm/bootmem.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

Index: tree-linus/mm/bootmem.c
===================================================================
--- tree-linus.orig/mm/bootmem.c
+++ tree-linus/mm/bootmem.c
@@ -85,10 +85,9 @@ static unsigned long __init get_mapsize(
 /*
  * Called once to set up the allocator itself.
  */
-static unsigned long __init init_bootmem_core(pg_data_t *pgdat,
+static unsigned long __init init_bootmem_core(bootmem_data_t *bdata,
 	unsigned long mapstart, unsigned long start, unsigned long end)
 {
-	bootmem_data_t *bdata = pgdat->bdata;
 	unsigned long mapsize;
 
 	bdata->node_bootmem_map = phys_to_virt(PFN_PHYS(mapstart));
@@ -314,11 +313,10 @@ found:
 	return ret;
 }
 
-static unsigned long __init free_all_bootmem_core(pg_data_t *pgdat)
+static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
 	struct page *page;
 	unsigned long pfn;
-	bootmem_data_t *bdata = pgdat->bdata;
 	unsigned long i, count, total = 0;
 	unsigned long idx;
 	unsigned long *map; 
@@ -384,7 +382,7 @@ static unsigned long __init free_all_boo
 unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long freepfn,
 				unsigned long startpfn, unsigned long endpfn)
 {
-	return init_bootmem_core(pgdat, freepfn, startpfn, endpfn);
+	return init_bootmem_core(pgdat->bdata, freepfn, startpfn, endpfn);
 }
 
 void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
@@ -401,14 +399,14 @@ void __init free_bootmem_node(pg_data_t 
 
 unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
-	return free_all_bootmem_core(pgdat);
+	return free_all_bootmem_core(pgdat->bdata);
 }
 
 unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
 {
 	max_low_pfn = pages;
 	min_low_pfn = start;
-	return init_bootmem_core(NODE_DATA(0), start, 0, pages);
+	return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
 }
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
@@ -451,7 +449,7 @@ void __init free_bootmem(unsigned long a
 
 unsigned long __init free_all_bootmem(void)
 {
-	return free_all_bootmem_core(NODE_DATA(0));
+	return free_all_bootmem_core(NODE_DATA(0)->bdata);
 }
 
 void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,

-- 


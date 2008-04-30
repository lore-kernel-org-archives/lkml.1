Return-Path: <linux-kernel-owner+w=401wt.eu-S1760316AbYD3RyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316AbYD3RyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932097AbYD3Rx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:53:29 -0400
Received: from saeurebad.de ([85.214.36.134]:60204 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbYD3Rx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:53:28 -0400
X-Mailbox-Line: From hannes@symbol.fehenstaub.lan Wed Apr 30 19:08:40 2008
Message-Id: <20080430170839.835245774@symbol.fehenstaub.lan>
References: <20080430170521.246745395@symbol.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Wed, 30 Apr 2008 19:05:24 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 3/4] mm: Normalize internal argument passing of bootmem data
Content-Disposition: inline; filename=mm-normalize-internal-argument-passing-of-bootmem-data.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All _core functions only need the bootmem data, not the whole node
descriptor.  Adjust the two functions that take the node descriptor
unneededly.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Ingo Molnar <mingo@elte.hu>
---

Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -87,10 +87,9 @@ static unsigned long __init get_mapsize(
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
@@ -371,11 +370,10 @@ found:
 	return ret;
 }
 
-static unsigned long __init free_all_bootmem_core(pg_data_t *pgdat)
+static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
 	struct page *page;
 	unsigned long pfn;
-	bootmem_data_t *bdata = pgdat->bdata;
 	unsigned long i, count;
 	unsigned long idx;
 	unsigned long *map; 
@@ -440,7 +438,7 @@ static unsigned long __init free_all_boo
 unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long freepfn,
 				unsigned long startpfn, unsigned long endpfn)
 {
-	return init_bootmem_core(pgdat, freepfn, startpfn, endpfn);
+	return init_bootmem_core(pgdat->bdata, freepfn, startpfn, endpfn);
 }
 
 void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
@@ -463,14 +461,14 @@ void __init free_bootmem_node(pg_data_t 
 unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
 	register_page_bootmem_info_node(pgdat);
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
@@ -501,7 +499,7 @@ void __init free_bootmem(unsigned long a
 
 unsigned long __init free_all_bootmem(void)
 {
-	return free_all_bootmem_core(NODE_DATA(0));
+	return free_all_bootmem_core(NODE_DATA(0)->bdata);
 }
 
 void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,

-- 


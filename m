Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab0BWIxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 03:53:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:49883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab0BWIxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 03:53:48 -0500
Message-ID: <4B839749.2060608@kernel.org>
Date: Tue, 23 Feb 2010 00:52:25 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the tip tree
References: <20100223160129.f3819f35.sfr@canb.auug.org.au>
In-Reply-To: <20100223160129.f3819f35.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2010 09:01 PM, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the tip tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
> 
> mm/sparse.c: In function 'sparse_init':
> mm/sparse.c:488: warning: unused variable 'map_count'
> mm/sparse.c:484: warning: unused variable 'size2'
> mm/sparse.c:481: warning: unused variable 'map_map'
> mm/sparse.c: At top level:
> mm/sparse.c:442: warning: 'sparse_early_mem_maps_alloc_node' defined but not used
> 
> Introduced by commit 9bdac914240759457175ac0d6529a37d2820bc4d
> ("sparsemem: Put mem map for one node together").
> 

please check


[PATCH] sparsemem: fix compiling with ppc

Stephen reported:
build (powerpc
ppc64_defconfig) produced these warnings:

mm/sparse.c: In function 'sparse_init':
mm/sparse.c:488: warning: unused variable 'map_count'
mm/sparse.c:484: warning: unused variable 'size2'
mm/sparse.c:481: warning: unused variable 'map_map'
mm/sparse.c: At top level:
mm/sparse.c:442: warning: 'sparse_early_mem_maps_alloc_node' defined but not used

Introduced by commit 9bdac914240759457175ac0d6529a37d2820bc4d
("sparsemem: Put mem map for one node together").

use macro to fix them

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/mm/sparse.c b/mm/sparse.c
index 9b6b93a..22896d5 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -439,6 +439,7 @@ void __init sparse_mem_maps_populate_node(struct page **map_map,
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
+#ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
 				 unsigned long pnum_begin,
 				 unsigned long pnum_end,
@@ -447,8 +448,7 @@ static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
 	sparse_mem_maps_populate_node(map_map, pnum_begin, pnum_end,
 					 map_count, nodeid);
 }
-
-#ifndef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
+#else
 static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
@@ -478,14 +478,17 @@ void __init sparse_init(void)
 {
 	unsigned long pnum;
 	struct page *map;
-	struct page **map_map;
 	unsigned long *usemap;
 	unsigned long **usemap_map;
-	int size, size2;
+	int size;
 	int nodeid_begin = 0;
 	unsigned long pnum_begin = 0;
 	unsigned long usemap_count;
+#ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 	unsigned long map_count;
+	int size2;
+	struct page **map_map;
+#endif
 
 	/*
 	 * map is using big page (aka 2M in x86 64 bit)

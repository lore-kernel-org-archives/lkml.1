Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0CGCQc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 21:16:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:57170 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab0CGCQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 21:16:30 -0500
Message-ID: <4B930C24.3030400@kernel.org>
Date: Sat, 06 Mar 2010 18:15:00 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
CC: Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparsemem: on no vmemmap path put mem_map on node high too
References: <49b004811003041321g2567bac8yb73235be32a27e7c@mail.gmail.com>	<20100305032106.GA12065@cmpxchg.org>	<49b004811003042117n720f356h7e10997a1a783475@mail.gmail.com>	<4B915074.4020704@kernel.org>	<4B916BD6.8010701@kernel.org>	<4B91EBC6.6080509@kernel.org> <20100306162234.e2cc84fb.akpm@linux-foundation.org> <4B92F65A.5060305@kernel.org> <4B92F91A.5040607@kernel.org>
In-Reply-To: <4B92F91A.5040607@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we need to put mem_map high when virtual memmap is not used.

before this patch
free mem pfn range on first node:
[    0.000000]  19 - 1f
[    0.000000]  28 40 - 80 95
[    0.000000]  702 740 - 1000 1000
[    0.000000]  347c - 347e
[    0.000000]  34e7 3500 - 3b80 3b8b
[    0.000000]  73b8b 73bc0 - 73c00 73c00
[    0.000000]  73ddd - 73e00
[    0.000000]  73fdd - 74000
[    0.000000]  741dd - 74200
[    0.000000]  743dd - 74400
[    0.000000]  745dd - 74600
[    0.000000]  747dd - 74800
[    0.000000]  749dd - 74a00
[    0.000000]  74bdd - 74c00
[    0.000000]  74ddd - 74e00
[    0.000000]  74fdd - 75000
[    0.000000]  751dd - 75200
[    0.000000]  753dd - 75400
[    0.000000]  755dd - 75600
[    0.000000]  757dd - 75800
[    0.000000]  759dd - 75a00
[    0.000000]  79bdd 79c00 - 7d540 7d550
[    0.000000]  7f745 - 7f750
[    0.000000]  10000b 100040 - 2080000 2080000
so only 79c00 - 7d540 are major free block under 4g...

after this patch, we will get
[    0.000000]  19 - 1f
[    0.000000]  28 40 - 80 95
[    0.000000]  702 740 - 1000 1000
[    0.000000]  347c - 347e
[    0.000000]  34e7 3500 - 3600 3600
[    0.000000]  37dd - 3800
[    0.000000]  39dd - 3a00
[    0.000000]  3bdd - 3c00
[    0.000000]  3ddd - 3e00
[    0.000000]  3fdd - 4000
[    0.000000]  41dd - 4200
[    0.000000]  43dd - 4400
[    0.000000]  45dd - 4600
[    0.000000]  47dd - 4800
[    0.000000]  49dd - 4a00
[    0.000000]  4bdd - 4c00
[    0.000000]  4ddd - 4e00
[    0.000000]  4fdd - 5000
[    0.000000]  51dd - 5200
[    0.000000]  53dd - 5400
[    0.000000]  95dd 9600 - 7d540 7d550
[    0.000000]  7f745 - 7f750
[    0.000000]  17000b 170040 - 2080000 2080000
we will have 9600 - 7d540 for major free block...

sparse-vmemmap path already used __alloc_bootmem_node_high()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/sparse.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/sparse.c
===================================================================
--- linux-2.6.orig/mm/sparse.c
+++ linux-2.6/mm/sparse.c
@@ -381,13 +381,15 @@ static void __init sparse_early_usemaps_
 struct page __init *sparse_mem_map_populate(unsigned long pnum, int nid)
 {
 	struct page *map;
+	unsigned long size;
 
 	map = alloc_remap(nid, sizeof(struct page) * PAGES_PER_SECTION);
 	if (map)
 		return map;
 
-	map = alloc_bootmem_pages_node(NODE_DATA(nid),
-		       PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION));
+	size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
+	map = __alloc_bootmem_node_high(NODE_DATA(nid), size,
+					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
 	return map;
 }
 void __init sparse_mem_maps_populate_node(struct page **map_map,
@@ -411,7 +413,8 @@ void __init sparse_mem_maps_populate_nod
 	}
 
 	size = PAGE_ALIGN(size);
-	map = alloc_bootmem_pages_node(NODE_DATA(nodeid), size * map_count);
+	map = __alloc_bootmem_node_high(NODE_DATA(nodeid), size * map_count,
+					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
 	if (map) {
 		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
 			if (!present_section_nr(pnum))

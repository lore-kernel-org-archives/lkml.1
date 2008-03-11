Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbYCKITN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbYCKITN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYCKIS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:18:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53546 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbYCKIS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:18:56 -0400
Date: Tue, 11 Mar 2008 09:18:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: make mem_map allocation continuous.
Message-ID: <20080311081841.GC24240@elte.hu>
References: <86802c440803102322i74333718h60de0da329b139c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803102322i74333718h60de0da329b139c8@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


find below the patch for -mm inclusion.

	Ingo

------------>
Subject: mm: make mem_map allocation continuous.
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Date: Mon, 10 Mar 2008 23:22:47 -0700

vmemmap allocation currently has this layout:
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001400000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001800000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001c00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810002000000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002400000 on node 0
...

there is a 2M hole between them.

the root cause is that usemap (24 bytes) will be allocated after every
2M mem_map and it will push next vmemmap (2M) to next align (2M).

solution:

try to allocate mem_map continously.

after the patch, we get:
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001400000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001800000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810001c00000 on node 0
...
and usemap will share in page because of they are allocated continuously too.
sparse_early_usemap_alloc: usemap = ffff810024e00000 size = 24
sparse_early_usemap_alloc: usemap = ffff810024e00080 size = 24
sparse_early_usemap_alloc: usemap = ffff810024e00100 size = 24
sparse_early_usemap_alloc: usemap = ffff810024e00180 size = 24
...

so we make the bootmem allocation more compact and use less memory for usemap.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/sparse.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

Index: linux-x86.q/mm/sparse.c
===================================================================
--- linux-x86.q.orig/mm/sparse.c
+++ linux-x86.q/mm/sparse.c
@@ -244,6 +244,7 @@ static unsigned long *__init sparse_earl
 	int nid = sparse_early_nid(ms);
 
 	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	printk(KERN_INFO "sparse_early_usemap_alloc: usemap = %p size = %ld\n", usemap, usemap_size());
 	if (usemap)
 		return usemap;
 
@@ -285,6 +286,8 @@ struct page __init *sparse_early_mem_map
 	return NULL;
 }
 
+/* section_map pointer array is 64k */
+static __initdata struct page *section_map[NR_MEM_SECTIONS];
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
@@ -295,14 +298,29 @@ void __init sparse_init(void)
 	struct page *map;
 	unsigned long *usemap;
 
+	/*
+	 * map is using big page (aka 2M in x86 64 bit)
+	 * usemap is less one page (aka 24 bytes)
+	 * so alloc 2M (with 2M align) and 24 bytes in turn will
+	 * make next 2M slip to one more 2M later.
+	 * then in big system, the memmory will have a lot hole...
+	 * here try to allocate 2M pages continously.
+	 */
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
+		section_map[pnum] = sparse_early_mem_map_alloc(pnum);
+	}
 
-		map = sparse_early_mem_map_alloc(pnum);
-		if (!map)
+
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		if (!present_section_nr(pnum))
 			continue;
 
+		map = section_map[pnum];
+		if (!map)
+			 continue;
+
 		usemap = sparse_early_usemap_alloc(pnum);
 		if (!usemap)
 			continue;

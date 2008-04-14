Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbYDNHYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbYDNHYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbYDNHX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:23:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39857 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542AbYDNHX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:23:58 -0400
Date: Mon, 14 Apr 2008 09:23:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: replace patch about memmap
Message-ID: <20080414072342.GF16163@elte.hu>
References: <86802c440804131151j7b38c1b3lf278acf72bd9c9e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804131151j7b38c1b3lf278acf72bd9c9e@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Ingo,
> 
> please use attached one to replace the two in x86.git/testing.

thanks Yinghai, applied. The delta patch is below.

	Ingo

Index: linux-x86.q/mm/sparse.c
===================================================================
--- linux-x86.q.orig/mm/sparse.c
+++ linux-x86.q/mm/sparse.c
@@ -297,48 +297,50 @@ void __init sparse_init(void)
 	unsigned long pnum;
 	struct page *map;
 	unsigned long *usemap;
-	struct page **section_map;
+	unsigned long **usemap_map;
 	int size;
-	int node;
 
 	/*
 	 * map is using big page (aka 2M in x86 64 bit)
 	 * usemap is less one page (aka 24 bytes)
 	 * so alloc 2M (with 2M align) and 24 bytes in turn will
 	 * make next 2M slip to one more 2M later.
-	 * then in big system, the memmory will have a lot hole...
+	 * then in big system, the memory will have a lot of holes...
 	 * here try to allocate 2M pages continously.
+	 *
+	 * powerpc need to call sparse_init_one_section right after each
+	 * sparse_early_mem_map_alloc, so allocate usemap_map at first.
 	 */
-	size = sizeof(struct page *) * NR_MEM_SECTIONS;
-	section_map = alloc_bootmem(size);
-	if (!section_map)
-		panic("can not allocate section_map\n");
+	size = sizeof(unsigned long *) * NR_MEM_SECTIONS;
+	usemap_map = alloc_bootmem(size);
+	if (!usemap_map)
+		panic("can not allocate usemap_map\n");
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
-		section_map[pnum] = sparse_early_mem_map_alloc(pnum);
+		usemap_map[pnum] = sparse_early_usemap_alloc(pnum);
 	}
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
 
-		map = section_map[pnum];
-		if (!map)
-			 continue;
-
-		usemap = sparse_early_usemap_alloc(pnum);
+		usemap = usemap_map[pnum];
 		if (!usemap)
 			continue;
 
+		map = sparse_early_mem_map_alloc(pnum);
+		if (!map)
+			continue;
+
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map,
 								usemap);
 	}
 
 	vmemmap_populate_print_last();
 
-	free_bootmem(__pa(section_map), size);
+	free_bootmem(__pa(usemap_map), size);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG

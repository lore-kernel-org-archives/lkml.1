Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbYDCB1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbYDCB1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759592AbYDCB1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:27:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:2019 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588AbYDCB1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=lzbTk6xja4D86sP7vscSNIVqSU1jxiOd4eQENHLnVsBju+Y+5GT4zECSIwWdt81A1WIiGgox3gO++xtd6z0SqEQJEaBnFoImyPCr4/kS2HnBc9t34FTGMBcC9cCOLFWXjt96XV7Lwd27nR3l+qF8+7VxKvdQ4vHFw7W8Vr2VRUg=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] mm: make mem_map allocation continuous v2.
Date: Wed, 2 Apr 2008 18:30:24 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Badari Pulavarty <pbadari@us.ibm.com>, michael@ellerman.id.au,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>
References: <200804021525.48799.yhlu.kernel@gmail.com> <20080402155247.5e746be7.akpm@linux-foundation.org> <86802c440804021744m7c6e3d94vcb6af3ebcaa71b5b@mail.gmail.com>
In-Reply-To: <86802c440804021744m7c6e3d94vcb6af3ebcaa71b5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021830.24563.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


vmemmap allocation current got
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001400000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001800000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001c00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810002000000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002400000 on node 0
...

there is 2M hole between them.

the rootcause is that usemap (24 bytes) will be allocated after every 2M
mem_map. and it will push next vmemmap (2M) to next align (2M).

solution:
try to allocate mem_map continously.

after patch, will get
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

for power pc
Badari Pulavarty <pbadari@us.ibm.com> wrote:

>  You have to call sparse_init_one_section() on each pmap and usemap
>  as we allocate - since valid_section() depends on it (which is needed
>  by vmemmap_populate() to check if the section is populated or not).
>  On ppc, we need to call htab_bolted_mapping() on each section and
>  we need to skip existing sections.

so try to allocate usemap at first altogether.

v2 replace:
	[PATCH] mm: make mem_map allocation continuous.
	[PATCH] mm: allocate section_map for sparse_init
	[PATCH] mm: allocate usemap at first instead of mem_map in sparse_init

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/mm/sparse.c b/mm/sparse.c
index f6a43c0..2881222 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -294,22 +294,48 @@ void __init sparse_init(void)
 	unsigned long pnum;
 	struct page *map;
 	unsigned long *usemap;
+	unsigned long **usemap_map;
+	int size;
+
+	/*
+	 * map is using big page (aka 2M in x86 64 bit)
+	 * usemap is less one page (aka 24 bytes)
+	 * so alloc 2M (with 2M align) and 24 bytes in turn will
+	 * make next 2M slip to one more 2M later.
+	 * then in big system, the memory will have a lot of holes...
+	 * here try to allocate 2M pages continously.
+	 *
+	 * powerpc need to call sparse_init_one_section right after each
+	 * sparse_early_mem_map_alloc, so allocate usemap_map at first.
+	 */
+	size = sizeof(unsigned long *) * NR_MEM_SECTIONS;
+	usemap_map = alloc_bootmem(size);
+	if (!usemap_map)
+		panic("can not allocate usemap_map\n");
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
+		usemap_map[pnum] = sparse_early_usemap_alloc(pnum);
+	}
 
-		map = sparse_early_mem_map_alloc(pnum);
-		if (!map)
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		if (!present_section_nr(pnum))
 			continue;
 
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
+
+	free_bootmem(__pa(usemap_map), size);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG

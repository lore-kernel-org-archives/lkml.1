Return-Path: <linux-kernel-owner+w=401wt.eu-S935739AbYCSW2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935739AbYCSW2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYCSVD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:03:26 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:25533 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759785AbYCSVDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:x-length:x-uid:date:content-type:content-transfer-encoding:message-id:from;
        b=nzJmCWucu0cPf+6eom0gdZl40S1hMxGN3cm56tSrixmPhAB0cMgqWaBg/jz/8951dZpKtO6ZPTPCXB86Ds8AB64+hty0gfkAFQSGzHKOIa11iXwnZF3y3y5sr+VnRg0esjldviJJKZR3WUgq6k99OO7uHWksl6BAAWkw3heYxbQ=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 08/12] mm: allocate section_map for sparse_init
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
References: <200803181237.33861.yhlu.kernel@gmail.com>
In-Reply-To: <200803181237.33861.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2734
Date: Wed, 19 Mar 2008 14:04:31 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803191404.31398.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] mm: allocate section_map for sparse_init

allocate section_map in bootmem instead of using __initdata.

need to apply after
	[PATCH] mm: fix boundary checking in free_bootmem_core
	[PATCH] mm: make mem_map allocation continuous.


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/mm/sparse.c
===================================================================
--- linux-2.6.orig/mm/sparse.c
+++ linux-2.6/mm/sparse.c
@@ -285,8 +285,6 @@ struct page __init *sparse_early_mem_map
 	return NULL;
 }
 
-/* section_map pointer array is 64k */
-static __initdata struct page *section_map[NR_MEM_SECTIONS];
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
@@ -296,6 +294,9 @@ void __init sparse_init(void)
 	unsigned long pnum;
 	struct page *map;
 	unsigned long *usemap;
+	struct page **section_map;
+	int size;
+	int node;
 
 	/*
 	 * map is using big page (aka 2M in x86 64 bit)
@@ -305,13 +306,17 @@ void __init sparse_init(void)
 	 * then in big system, the memmory will have a lot hole...
 	 * here try to allocate 2M pages continously.
 	 */
+	size = sizeof(struct page *) * NR_MEM_SECTIONS;
+	section_map = alloc_bootmem(size);
+	if (!section_map)
+		panic("can not allocate section_map\n");
+
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
 		section_map[pnum] = sparse_early_mem_map_alloc(pnum);
 	}
 
-
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
@@ -327,6 +332,8 @@ void __init sparse_init(void)
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map,
 								usemap);
 	}
+
+	free_bootmem(__pa(section_map), size);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG

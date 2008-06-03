Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYFCB7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYFCB7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 21:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbYFCB6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 21:58:31 -0400
Received: from saeurebad.de ([85.214.36.134]:39486 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769AbYFCB6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 21:58:30 -0400
X-Mailbox-Line: From hannes@saeurebad.de Tue Jun  3 02:53:03 2008
Message-Id: <20080603005303.194857720@saeurebad.de>
References: <20080603005017.593345596@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 02:50:22 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 05/14] bootmem: revisit bitmap size calculations
Content-Disposition: inline; filename=bootmem-revisit-bitmap-size-calculation.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reincarnate get_mapsize as bootmap_bytes and implement
bootmem_bootmap_pages on top of it.

Adjust users of these helpers and make free_all_bootmem_core use
bootmem_bootmap_pages instead of open-coding it.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

 mm/bootmem.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -50,17 +50,11 @@ early_param("bootmem_debug", bootmem_deb
 			__FUNCTION__, ## args);		\
 })
 
-/*
- * Given an initialised bdata, it returns the size of the boot bitmap
- */
-static unsigned long __init get_mapsize(bootmem_data_t *bdata)
+static unsigned long __init bootmap_bytes(unsigned long pages)
 {
-	unsigned long mapsize;
-	unsigned long start = PFN_DOWN(bdata->node_boot_start);
-	unsigned long end = bdata->node_low_pfn;
+	unsigned long bytes = (pages + 7) / 8;
 
-	mapsize = ((end - start) + 7) / 8;
-	return ALIGN(mapsize, sizeof(long));
+	return ALIGN(bytes, sizeof(long));
 }
 
 /**
@@ -69,13 +63,9 @@ static unsigned long __init get_mapsize(
  */
 unsigned long __init bootmem_bootmap_pages(unsigned long pages)
 {
-	unsigned long mapsize;
-
-	mapsize = (pages+7)/8;
-	mapsize = (mapsize + ~PAGE_MASK) & PAGE_MASK;
-	mapsize >>= PAGE_SHIFT;
+	unsigned long bytes = bootmap_bytes(pages);
 
-	return mapsize;
+	return PAGE_ALIGN(bytes) >> PAGE_SHIFT;
 }
 
 /*
@@ -117,7 +107,7 @@ static unsigned long __init init_bootmem
 	 * Initially all pages are reserved - setup_arch() has to
 	 * register free RAM areas explicitly.
 	 */
-	mapsize = get_mapsize(bdata);
+	mapsize = bootmap_bytes(end - start);
 	memset(bdata->node_bootmem_map, 0xff, mapsize);
 
 	bdebug("nid=%d start=%lx map=%lx end=%lx mapsize=%ld\n",
@@ -160,7 +150,7 @@ static unsigned long __init free_all_boo
 	struct page *page;
 	unsigned long pfn;
 	unsigned long i, count;
-	unsigned long idx;
+	unsigned long idx, pages;
 	unsigned long *map;
 	int gofast = 0;
 
@@ -211,7 +201,8 @@ static unsigned long __init free_all_boo
 	 * needed anymore:
 	 */
 	page = virt_to_page(bdata->node_bootmem_map);
-	idx = (get_mapsize(bdata) + PAGE_SIZE-1) >> PAGE_SHIFT;
+	pages = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
+	idx = bootmem_bootmap_pages(pages);
 	for (i = 0; i < idx; i++, page++)
 		__free_pages_bootmem(page, 0);
 	count += i;

-- 


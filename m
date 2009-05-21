Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZEUAXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZEUAXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZEUAX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:23:28 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:39193 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbZEUAX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=UhNRmaRRrI2aU4PWNnP/q9gcF5nfwWQTzos61tHnr7P8Nhu77aRdXbLXwwDs7yHmHY
         Oduks48yrcqO3eJGVsMG7y74QGjAhSv3+jJnnebUY1oJe6a02a7F0QoAQyfU508dQnzk
         mlq6NN84Ug1k+i9zqW+twsLn1as0aLtIdsG4E=
Date: Thu, 21 May 2009 09:23:04 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH 1/3]  clean up functions related to pages_min V2
Message-Id: <20090521092304.0eb3c4cb.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since V1 
 o Change function name from setup_per_zone_wmark_min to setup_per_zone_wmarks
   - by Mel Gorman advise
 o Modify description - by KOSAKI advise

Mel changed zone->pages_[high/low/min] with zone->watermark array.
So, the functions related to pages_min also have to be changed.

* setup_per_zone_pages_min
* init_per_zone_pages_min

This patch is just clean up. so it doesn't affect behavior.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/mm.h  |    2 +-
 mm/memory_hotplug.c |    2 +-
 mm/page_alloc.c     |   15 ++++++++-------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a569862..7ea4d1b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1058,7 +1058,7 @@ extern int __meminit __early_pfn_to_nid(unsigned long pfn);
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
-extern void setup_per_zone_pages_min(void);
+extern void setup_per_zone_wmarks(void);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(void);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c083cf5..037291e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -422,7 +422,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages)
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 
-	setup_per_zone_pages_min();
+	setup_per_zone_wmarks();
 	if (onlined_pages) {
 		kswapd_run(zone_to_nid(zone));
 		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9c712f0..b518ea7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4471,12 +4471,13 @@ static void setup_per_zone_lowmem_reserve(void)
 }
 
 /**
- * setup_per_zone_pages_min - called when min_free_kbytes changes.
+ * setup_per_zone_wmarks - called when min_free_kbytes changes 
+ * or when memory is hot-added
  *
- * Ensures that the pages_{min,low,high} values for each zone are set correctly
+ * Ensures that the watermark[min,low,high] values for each zone are set correctly
  * with respect to min_free_kbytes.
  */
-void setup_per_zone_pages_min(void)
+void setup_per_zone_wmarks(void)
 {
 	unsigned long pages_min = min_free_kbytes >> (PAGE_SHIFT - 10);
 	unsigned long lowmem_pages = 0;
@@ -4594,7 +4595,7 @@ static void __init setup_per_zone_inactive_ratio(void)
  * 8192MB:	11584k
  * 16384MB:	16384k
  */
-static int __init init_per_zone_pages_min(void)
+static int __init init_per_zone_wmark_min(void)
 {
 	unsigned long lowmem_kbytes;
 
@@ -4605,12 +4606,12 @@ static int __init init_per_zone_pages_min(void)
 		min_free_kbytes = 128;
 	if (min_free_kbytes > 65536)
 		min_free_kbytes = 65536;
-	setup_per_zone_pages_min();
+	setup_per_zone_wmarks();
 	setup_per_zone_lowmem_reserve();
 	setup_per_zone_inactive_ratio();
 	return 0;
 }
-module_init(init_per_zone_pages_min)
+module_init(init_per_zone_wmark_min)
 
 /*
  * min_free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so 
@@ -4622,7 +4623,7 @@ int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
 {
 	proc_dointvec(table, write, file, buffer, length, ppos);
 	if (write)
-		setup_per_zone_pages_min();
+		setup_per_zone_wmarks();
 	return 0;
 }
 
-- 
1.5.4.3




-- 
Kinds Regards
Minchan Kim

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbYBQMUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbYBQMUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbYBQMUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:20:46 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:44688 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYBQMUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:20:45 -0500
Date: Sun, 17 Feb 2008 13:20:39 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: setup_usemap() must be __meminit
Message-ID: <Pine.LNX.4.64.0802171317230.10451@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k (CONFIG_SPARSEMEM is not set), I get:

    WARNING: vmlinux.o(.meminit.text+0x36c): Section mismatch in reference from the function free_area_init_core() to the function .init.text:setup_usemap()
    The function __meminit free_area_init_core() references
    a function __init setup_usemap().
    If free_area_init_core is only used by setup_usemap then
    annotate free_area_init_core with a matching annotation.

If CONFIG_SPARSEMEM is set, the problem is  not noticed because setup_usemap()
is always inlined.

Properly annotating setup_usemap() and usemap_size() fixes it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 mm/page_alloc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3241,7 +3241,7 @@ static void __meminit calculate_node_tot
  * round what is now in bits to nearest long in bits, then return it in
  * bytes.
  */
-static unsigned long __init usemap_size(unsigned long zonesize)
+static unsigned long __meminit usemap_size(unsigned long zonesize)
 {
 	unsigned long usemapsize;
 
@@ -3253,8 +3253,8 @@ static unsigned long __init usemap_size(
 	return usemapsize / 8;
 }
 
-static void __init setup_usemap(struct pglist_data *pgdat,
-				struct zone *zone, unsigned long zonesize)
+static void __meminit setup_usemap(struct pglist_data *pgdat,
+				   struct zone *zone, unsigned long zonesize)
 {
 	unsigned long usemapsize = usemap_size(zonesize);
 	zone->pageblock_flags = NULL;
@@ -3264,8 +3264,9 @@ static void __init setup_usemap(struct p
 	}
 }
 #else
-static void inline setup_usemap(struct pglist_data *pgdat,
-				struct zone *zone, unsigned long zonesize) {}
+static inline void __meminit setup_usemap(struct pglist_data *pgdat,
+					  struct zone *zone,
+					  unsigned long zonesize) {}
 #endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

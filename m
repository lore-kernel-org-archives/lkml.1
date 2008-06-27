Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbYF0MQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbYF0MQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbYF0MGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:06:22 -0400
Received: from saeurebad.de ([85.214.36.134]:39036 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760108AbYF0MGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:06:19 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 14:00:49 2008
Message-Id: <20080627120049.724004313@saeurebad.de>
References: <20080627115349.743368154@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:54:02 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 13/20] mn10300: use generic show_mem()
Content-Disposition: inline; filename=0014-mn10300-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: David Howells <dhowells@redhat.com>
---
 arch/mn10300/Kconfig      |    1 +
 arch/mn10300/mm/pgtable.c |   27 ---------------------------
 2 files changed, 1 insertion(+), 27 deletions(-)

--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -7,6 +7,7 @@ mainmenu "Linux Kernel Configuration"
 
 config MN10300
 	def_bool y
+	select HAVE_GENERIC_SHOW_MEM
 
 config AM33
 	def_bool y
--- a/arch/mn10300/mm/pgtable.c
+++ b/arch/mn10300/mm/pgtable.c
@@ -27,33 +27,6 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
-void show_mem(void)
-{
-	unsigned long i;
-	int free = 0, total = 0, reserved = 0, shared = 0;
-
-	int cached = 0;
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map + i))
-			reserved++;
-		else if (PageSwapCache(mem_map + i))
-			cached++;
-		else if (!page_count(mem_map + i))
-			free++;
-		else
-			shared += page_count(mem_map + i) - 1;
-	}
-	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d free pages\n", free);
-	printk(KERN_INFO "%d reserved pages\n", reserved);
-	printk(KERN_INFO "%d pages shared\n", shared);
-	printk(KERN_INFO "%d pages swap cached\n", cached);
-}
-
 /*
  * Associate a large virtual page frame with a given physical page frame
  * and protection flags for that frame. pfn is for the base of the page,

-- 


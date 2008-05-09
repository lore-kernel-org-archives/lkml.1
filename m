Return-Path: <linux-kernel-owner+w=401wt.eu-S935038AbYEIGGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935038AbYEIGGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764972AbYEIGG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:06:28 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:50537 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759185AbYEIGG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:06:27 -0400
Date: Fri, 9 May 2008 08:06:09 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Dave Hansen <haveblue@us.ibm.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] memory_hotplug: always initialize pageblock bitmap.
Message-ID: <20080509060609.GB9840@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Trying to online a new memory section that was added via memory hotplug
sometimes results in crashes when the new pages are added via
__free_page. Reason for that is that the pageblock bitmap isn't
initialized and hence contains random stuff.
That means that get_pageblock_migratetype() returns also random stuff
and therefore

	list_add(&page->lru,
		 &zone->free_area[order].free_list[migratetype]);

in __free_one_page() tries to do a list_add to something that isn't
even necessarily a list.
This is only an issue for memory sections that get added after boot
time since all previously present memory sections allocate their
pageblock bitmaps via the bootmem allocator which in turn initializes
just everything it returns.

Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/sparse.c
===================================================================
--- linux-2.6.orig/mm/sparse.c
+++ linux-2.6/mm/sparse.c
@@ -244,7 +244,7 @@ unsigned long usemap_size(void)
 #ifdef CONFIG_MEMORY_HOTPLUG
 static unsigned long *__kmalloc_section_usemap(void)
 {
-	return kmalloc(usemap_size(), GFP_KERNEL);
+	return kzalloc(usemap_size(), GFP_KERNEL);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 

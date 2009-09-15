Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbZIOUjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbZIOUjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbZIOUjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:39:07 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:9885 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879AbZIOUjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:39:06 -0400
X-Trace: 261987044/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.84.74/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.84.74
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgFALuYr0pPRVRK/2dsb2JhbACBU95lhBcF
X-IronPort-AV: E=Sophos;i="4.44,391,1249254000"; 
   d="scan'208";a="261987044"
Date: Tue, 15 Sep 2009 21:38:21 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 4/4] mm: move highest_memmap_pfn
In-Reply-To: <Pine.LNX.4.64.0909152127240.22199@sister.anvils>
Message-ID: <Pine.LNX.4.64.0909152137240.22199@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
 <Pine.LNX.4.64.0909152127240.22199@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move highest_memmap_pfn __read_mostly from page_alloc.c next to
zero_pfn __read_mostly in memory.c: to help them share a cacheline,
since they're very often tested together in vm_normal_page().

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/internal.h   |    3 ++-
 mm/memory.c     |    1 +
 mm/page_alloc.c |    1 -
 3 files changed, 3 insertions(+), 2 deletions(-)

--- mm3/mm/internal.h	2009-09-14 16:34:37.000000000 +0100
+++ mm4/mm/internal.h	2009-09-15 17:32:27.000000000 +0100
@@ -37,6 +37,8 @@ static inline void __put_page(struct pag
 	atomic_dec(&page->_count);
 }
 
+extern unsigned long highest_memmap_pfn;
+
 /*
  * in mm/vmscan.c:
  */
@@ -46,7 +48,6 @@ extern void putback_lru_page(struct page
 /*
  * in mm/page_alloc.c
  */
-extern unsigned long highest_memmap_pfn;
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
 extern void prep_compound_page(struct page *page, unsigned long order);
 
--- mm3/mm/memory.c	2009-09-15 17:32:19.000000000 +0100
+++ mm4/mm/memory.c	2009-09-15 17:32:27.000000000 +0100
@@ -108,6 +108,7 @@ static int __init disable_randmaps(char
 __setup("norandmaps", disable_randmaps);
 
 unsigned long zero_pfn __read_mostly;
+unsigned long highest_memmap_pfn __read_mostly;
 
 /*
  * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
--- mm3/mm/page_alloc.c	2009-09-14 16:34:37.000000000 +0100
+++ mm4/mm/page_alloc.c	2009-09-15 17:32:27.000000000 +0100
@@ -72,7 +72,6 @@ EXPORT_SYMBOL(node_states);
 
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
-unsigned long highest_memmap_pfn __read_mostly;
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 

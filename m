Return-Path: <linux-kernel-owner+w=401wt.eu-S932421AbXBPP50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbXBPP50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932423AbXBPP5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:57:25 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43826 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932421AbXBPP5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:57:25 -0500
Date: Fri, 16 Feb 2007 07:57:18 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: James Morris <jmorris@namei.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: 2.6.20-mm1 [kernel BUG at mm/swap.c:442]
In-Reply-To: <Pine.LNX.4.64.0702160938300.2581@d.namei>
Message-ID: <Pine.LNX.4.64.0702160756020.23808@schroedinger.engr.sgi.com>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702150926560.25081@d.namei> <20070215135157.18085ae3.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702160938300.2581@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007, James Morris wrote:

> Then, I get this reliably as ntpd starts up:
> [   92.905514]  [<c014e7ff>] lru_add_drain+0x57/0x8d
> [   92.905519]  [<c015a03f>] free_pages_and_swap_cache+0x12/0x85
> [   92.905526]  [<c0155acb>] unmap_region+0xfd/0x129
> [   92.905530]  [<c0156404>] do_munmap+0x153/0x1b4
> [   92.905534]  [<c015648a>] sys_munmap+0x25/0x34
> [   92.905538]  [<c01028fc>] syscall_call+0x7/0xb
> [   92.905542]  =======================
> [   92.905544] Code: 74 1a 85 d2 74 0b 8d 82 80 05 00 00 e8 6a 3a 1a 00 8d 86 80 05 00 00 e8 7c 36 1a 00 8b 03 a9 00 00 10 00 74
>  3f 8b 03 a8 20 74 04 <0f> 0b eb fe f0 0f ba 2b 05 f0 0f ba 33 14 f0 0f ba 2b 06 ba 03 

Andrew already has this fix which cures it for me. PG_mlocked pages can 
be freed in some situations and thus we need the correct handling in the 
page allocator:


Index: linux-2.6.20/include/linux/page-flags.h
===================================================================
--- linux-2.6.20.orig/include/linux/page-flags.h	2007-02-15 20:42:42.000000000 -0800
+++ linux-2.6.20/include/linux/page-flags.h	2007-02-15 20:43:33.000000000 -0800
@@ -261,6 +261,7 @@ static inline void SetPageUptodate(struc
 #define PageMlocked(page)	test_bit(PG_mlocked, &(page)->flags)
 #define SetPageMlocked(page)	set_bit(PG_mlocked, &(page)->flags)
 #define ClearPageMlocked(page)	clear_bit(PG_mlocked, &(page)->flags)
+#define __ClearPageMlocked(page) __clear_bit(PG_mlocked, &(page)->flags)
 
 struct page;	/* forward declaration */
 
Index: linux-2.6.20/mm/page_alloc.c
===================================================================
--- linux-2.6.20.orig/mm/page_alloc.c	2007-02-15 20:42:42.000000000 -0800
+++ linux-2.6.20/mm/page_alloc.c	2007-02-15 20:55:23.000000000 -0800
@@ -203,6 +203,7 @@ static void bad_page(struct page *page)
 			1 << PG_slab    |
 			1 << PG_swapcache |
 			1 << PG_writeback |
+			1 << PG_mlocked |
 			1 << PG_buddy );
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
@@ -442,6 +443,11 @@ static inline int free_pages_check(struc
 		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
+	if (PageMlocked(page)) {
+		/* Page is unused so no need to take the lru lock */
+		__ClearPageMlocked(page);
+		dec_zone_page_state(page, NR_MLOCK);
+	}
 	/*
 	 * For now, we report if PG_reserved was found set, but do not
 	 * clear it, and do not free the page.  But we shall soon need
@@ -588,6 +594,7 @@ static int prep_new_page(struct page *pa
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
+			1 << PG_mlocked |
 			1 << PG_buddy ))))
 		bad_page(page);
 

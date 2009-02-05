Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZBEHpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZBEHpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 02:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZBEHou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 02:44:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48116 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbZBEHot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 02:44:49 -0500
Date: Thu, 5 Feb 2009 16:43:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Miller <davem@davemloft.net>
Cc: mel@csn.ul.ie, heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: HOLES_IN_ZONE...
Message-Id: <20090205164330.83777a4d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090204.222651.26527737.davem@davemloft.net>
References: <20090204.222651.26527737.davem@davemloft.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Feb 2009 22:26:51 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> 
> So I've been fighting mysterious crashes on my main sparc64 devel
> machine.  What's happening is that the assertion in
> mm/page_alloc.c:move_freepages() is triggering:
> 
> 	BUG_ON(page_zone(start_page) != page_zone(end_page));
> 
> Once I knew this is what was happening, I added some annotations:
> 
> 	if (unlikely(page_zone(start_page) != page_zone(end_page))) {
> 		printk(KERN_ERR "move_freepages: Bogus zones: "
> 		       "start_page[%p] end_page[%p] zone[%p]\n",
> 		       start_page, end_page, zone);
> 		printk(KERN_ERR "move_freepages: "
> 		       "start_zone[%p] end_zone[%p]\n",
> 		       page_zone(start_page), page_zone(end_page));
> 		printk(KERN_ERR "move_freepages: "
> 		       "start_pfn[0x%lx] end_pfn[0x%lx]\n",
> 		       page_to_pfn(start_page), page_to_pfn(end_page));
> 		printk(KERN_ERR "move_freepages: "
> 		       "start_nid[%d] end_nid[%d]\n",
> 		       page_to_nid(start_page), page_to_nid(end_page));
>  ...
> 
> And here's what I got:
> 
> 	move_freepages: Bogus zones: start_page[2207d0000] end_page[2207dffc0] zone[fffff8103effcb00]
> 	move_freepages: start_zone[fffff8103effcb00] end_zone[fffff8003fffeb00]
> 	move_freepages: start_pfn[0x81f600] end_pfn[0x81f7ff]
> 	move_freepages: start_nid[1] end_nid[0]
> 
> My memory layout on this box is:
> 
> [    0.000000] Zone PFN ranges:
> [    0.000000]   Normal   0x00000000 -> 0x0081ff5d
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[8] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x00020000
> [    0.000000]     1: 0x00800000 -> 0x0081f7ff
> [    0.000000]     1: 0x0081f800 -> 0x0081fe50
> [    0.000000]     1: 0x0081fed1 -> 0x0081fed8
> [    0.000000]     1: 0x0081feda -> 0x0081fedb
> [    0.000000]     1: 0x0081fedd -> 0x0081fee5
> [    0.000000]     1: 0x0081fee7 -> 0x0081ff51
> [    0.000000]     1: 0x0081ff59 -> 0x0081ff5d
> 

Ah, end_pfn is not valid page. And, page->flags shows nid 0.
It seems memmap for end_pfn is not initialized correctly.

At first, there are some complicated around here..

1. pfn_valid() is just for "there is memmap." not for "the memory is valid"
2. If "memory is invalid" && it has memmap, it should be marked as PG_Reserved.
   And it will never be put into buddy allocator. 
3. memmap for not exisiting memory can be initialized but it's depends on
   zone->spanned_pages. (see free_area_init_core())
4. What CONFIG_HOLES_IN_ZONE means is 
   "there can be invalid memmap within coutinuous range of zone->mem_map"
   This comes from VIRTUAL_MEMMAP.
   In usual arch, mem_map is guaranteed to be coutinuous always.




> 	move_freepages: start_zone[fffff8103effcb00] end_zone[fffff8003fffeb00]
> 	move_freepages: start_pfn[0x81f600] end_pfn[0x81f7ff]
> 	move_freepages: start_nid[1] end_nid[0]
> [    0.000000]     0: 0x00000000 -> 0x00020000
> [    0.000000]     1: 0x00800000 -> 0x0081f7ff

> [    0.000000]     1: 0x00800000 -> 0x0081f7ff

I think it's strange that end_pfn's nid is 0.

>From this log, mem_map for end_pfn exists (means pfn_valid(end_pfn) == true)
So, it should be initialized correctly and should have nid 1 if initialized.

Maybe Node1's zone->start_pfn and zone->spanned_pages covers 0x81f7ff, and it's
range is 0x00800000 -> 0x0081ff5d

But,  this check in memmap_init_zone()
==
2619                 if (context == MEMMAP_EARLY) {
2620                         if (!early_pfn_valid(pfn))
2621                                 continue;
2622                         if (!early_pfn_in_nid(pfn, nid))
2623                                 continue;
2624                 }
==
will allow skip to init this mem_map of 0x8af7ff.
*AND*, SetPageResreved() is never called. This is a problem I think.

> It takes a lot of stressing to get that specific chunk of pages to
> attempt to be freed up in a group like that :-/
> 
> As a suggestion, it would have been a lot more pleasant if the code
> validated this requirement (in the !HOLES_IN_ZONE case) at boot time
> instead of after 2 hours of stress testing :-(
> 

Can this patch help you ? (maybe more careful study is necessary...)
---
 mm/page_alloc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: mmotm-2.6.29-Feb03/mm/page_alloc.c
===================================================================
--- mmotm-2.6.29-Feb03.orig/mm/page_alloc.c
+++ mmotm-2.6.29-Feb03/mm/page_alloc.c
@@ -2618,6 +2618,7 @@ void __meminit memmap_init_zone(unsigned
 	unsigned long end_pfn = start_pfn + size;
 	unsigned long pfn;
 	struct zone *z;
+	int tmp;
 
 	if (highest_memmap_pfn < end_pfn - 1)
 		highest_memmap_pfn = end_pfn - 1;
@@ -2632,7 +2633,8 @@ void __meminit memmap_init_zone(unsigned
 		if (context == MEMMAP_EARLY) {
 			if (!early_pfn_valid(pfn))
 				continue;
-			if (!early_pfn_in_nid(pfn, nid))
+			tmp = early_pfn_in_nid(pfn, nid);
+			if (tmp > -1 && tmp != nid)
 				continue;
 		}
 		page = pfn_to_page(pfn);
@@ -2999,8 +3001,9 @@ int __meminit early_pfn_to_nid(unsigned 
 			return early_node_map[i].nid;
 	}
 
-	return 0;
+	return -1;
 }
+
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
 /* Basic iterator support to walk early_node_map[] */





Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbZBEJJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbZBEJJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbZBEJHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:07:39 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60060 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526AbZBEJHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:07:35 -0500
Date: Thu, 5 Feb 2009 18:06:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Miller <davem@davemloft.net>
Cc: mel@csn.ul.ie, heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: HOLES_IN_ZONE...
Message-Id: <20090205180617.8ee3dfb5.kamezawa.hiroyu@jp.fujitsu.com>
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
> The point of this email is, do I really need to set this thing on
> sparc64?  I've never seen this check triggered before, it only seems
> to have started triggering in 2.6.27 or so but I obviously can't find
> anything that would influence something of this nature.
> 

Clarifing my e-mail again..(sorry for bad text.)

1. This is not problem from HOLES_IN_ZONE.
2. Your end_pfn(0x81f7ff)'s memmap is not initialized correctly.
3. It's because 0x81f7ff has memmap but not in early_node_map[].

So, initialzing mem_map() for this end_pfn is necessary.

This is my patch. Mel, how do you think ?
==

A struct page for pfn which is not in early_node_map[] can exist and
it's not be initalized.

This patch changes early_pfn_to_nid() to return -1 and if -1 returns,
initialized mem_map with passed nid. After this patch, the page will be
marked as PG_reserved and never freed later.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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



Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbXICKpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbXICKpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbXICKpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:45:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51130 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbXICKpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:45:35 -0400
Date: Mon, 3 Sep 2007 19:46:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "mel@csn.ul.ie" <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH][-mm] Fix setup_per_zone_pages_min() lock.
Message-Id: <20070903194629.aa24ecc5.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix setup_per_zone_pages_min().

Now setup_per_zone_pages_min() uses zone->lru_lock. This has 2 problems.

1. setup_page_zone_pages_min() modifies zone->pages_min,pages_low,pages_high.
   in atomic. But readers of these values tend not to take lru_lock.
   (At least, we need lock between memory hotplug vs. sysctl)
2. setup_zone_migrate_reserve() should take zone->lock instead of lru_lock.

This patch replaces zone->lru_lock with zone->lock.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



---
 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: devel-2.6.23-rc4-mm1-zone/mm/page_alloc.c
===================================================================
--- devel-2.6.23-rc4-mm1-zone.orig/mm/page_alloc.c
+++ devel-2.6.23-rc4-mm1-zone/mm/page_alloc.c
@@ -4176,8 +4176,8 @@ void setup_per_zone_pages_min(void)
 
 	for_each_zone(zone) {
 		u64 tmp;
+		spin_lock_irqsave(&zone->lock, flags);
 
-		spin_lock_irqsave(&zone->lru_lock, flags);
 		tmp = (u64)pages_min * zone->present_pages;
 		do_div(tmp, lowmem_pages);
 		if (is_highmem(zone)) {
@@ -4208,8 +4208,9 @@ void setup_per_zone_pages_min(void)
 
 		zone->pages_low   = zone->pages_min + (tmp >> 2);
 		zone->pages_high  = zone->pages_min + (tmp >> 1);
+
 		setup_zone_migrate_reserve(zone);
-		spin_unlock_irqrestore(&zone->lru_lock, flags);
+		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
 	/* update totalreserve_pages */


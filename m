Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYJARlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYJARlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 13:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYJARlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 13:41:17 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:64962 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbYJARlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 13:41:17 -0400
Subject: [PATCH] setup_per_zone_pages_min(): take zone->lock instead of
	zone->lru_lock
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080930103748.44A3.E1E9C6FF@jp.fujitsu.com>
References: <1222723206.6791.2.camel@ubuntu>
	 <20080930094017.5ed2938a.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080930103748.44A3.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain
Date: Wed, 01 Oct 2008 19:39:32 +0200
Message-Id: <1222882772.4846.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com> 

This replaces zone->lru_lock in setup_per_zone_pages_min() with zone->lock.
There seems to be no need for the lru_lock anymore, but there is a need for
zone->lock instead, because that function may call move_freepages() via
setup_zone_migrate_reserve().

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>

---
 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -4207,7 +4207,7 @@ void setup_per_zone_pages_min(void)
 	for_each_zone(zone) {
 		u64 tmp;
 
-		spin_lock_irqsave(&zone->lru_lock, flags);
+		spin_lock_irqsave(&zone->lock, flags);
 		tmp = (u64)pages_min * zone->present_pages;
 		do_div(tmp, lowmem_pages);
 		if (is_highmem(zone)) {
@@ -4239,7 +4239,7 @@ void setup_per_zone_pages_min(void)
 		zone->pages_low   = zone->pages_min + (tmp >> 2);
 		zone->pages_high  = zone->pages_min + (tmp >> 1);
 		setup_zone_migrate_reserve(zone);
-		spin_unlock_irqrestore(&zone->lru_lock, flags);
+		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
 	/* update totalreserve_pages */



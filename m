Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbYG2QIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbYG2QIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYG2QIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:08:41 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:49490 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbYG2QIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:08:40 -0400
Subject: Re: memory hotplug: hot-remove fails on lowest chunk in
	ZONE_MOVABLE
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20080723105318.81BC.E1E9C6FF@jp.fujitsu.com>
References: <1216745719.4871.8.camel@localhost.localdomain>
	 <20080723105318.81BC.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 18:07:33 +0200
Message-Id: <1217347653.4829.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-23 at 11:48 +0900, Yasunori Goto wrote:
> > Memory hot-remove of the lowest memory chunk in ZONE_MOVABLE will fail
> > because of some reserved pages at the beginning of each zone
> > (MIGRATE_RESERVED).
> > 
> I believe you are right. Current hot-remove code is NOT perfect.
> You may remove some sections, but may not other sections,
> because there are some un-removable pages by some reasons
> (not only MIGRATE_RESERVED).
> 
> I think MIGRATE_RESERVED pages should be move to MIGRATE_MOVABLE when 
> those pages must be removed, and should recalculate MIGRATE_RESERVED pages.

Hi,

Would it be an option to set pages_min to 0 for ZONE_MOVABLE in
setup_per_zone_pages_min()? This would avoid the MIGRATE_RESERVED vs.
MIGRATE_MOVABLE conflict on memory hot-remove. If I understand it
correctly, the kernel wouldn't be able to use the reserved pages in
ZONE_MOVABLE for __GFP_HIGH and PF_MEMALLOC allocations anyway, right?

At the moment, ZONE_MOVABLE pages will also account for the lowmem_pages
calculation in setup_per_zone_pages_min(). The recalculation will then
redistribute and reduce the amount of reserved pages for the other zones.
Won't this effectively reduce the amount of reserved min_free_kbytes memory
that is available to the kernel, even getting worse the more memory is
added to ZONE_MOVABLE?

With the following patch, ZONE_MOVABLE will be skipped for the
lowmem_pages calculation, just like it is already done for highmem.
It will also set pages_min to 0 for ZONE_MOVABLE. But I have an uneasy
feeling about this, because I may be missing side effects from this.
Any opinions?

Thanks,
Gerald

---
 include/linux/mmzone.h |    5 +++++
 mm/page_alloc.c        |    4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/mmzone.h
===================================================================
--- linux-2.6.orig/include/linux/mmzone.h
+++ linux-2.6/include/linux/mmzone.h
@@ -660,6 +660,11 @@ static inline int is_dma(struct zone *zo
 #endif
 }
 
+static inline int is_movable(struct zone *zone)
+{
+	return zone == zone->zone_pgdat->node_zones + ZONE_MOVABLE;
+}
+
 /* These two functions are used to setup the per zone pages min values */
 struct ctl_table;
 struct file;
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -4210,7 +4210,7 @@ void setup_per_zone_pages_min(void)
 
 	/* Calculate total number of !ZONE_HIGHMEM pages */
 	for_each_zone(zone) {
-		if (!is_highmem(zone))
+		if (!is_highmem(zone) && !is_movable(zone))
 			lowmem_pages += zone->present_pages;
 	}
 
@@ -4243,7 +4243,7 @@ void setup_per_zone_pages_min(void)
 			 * If it's a lowmem zone, reserve a number of pages
 			 * proportionate to the zone's size.
 			 */
-			zone->pages_min = tmp;
+			zone->pages_min = is_movable(zone) ? 0 : tmp;
 		}
 
 		zone->pages_low   = zone->pages_min + (tmp >> 2);


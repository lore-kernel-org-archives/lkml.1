Return-Path: <linux-kernel-owner+w=401wt.eu-S964838AbYEIGEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838AbYEIGEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbYEIGEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:04:31 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:63556 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168AbYEIGEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:04:30 -0400
Date: Fri, 9 May 2008 08:04:25 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] memory hotplug: memmap_init_zone called twice.
Message-ID: <20080509060425.GA9840@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] memory hotplug: memmap_init_zone called twice.

From: Heiko Carstens <heiko.carstens@de.ibm.com>

__add_zone calls memmap_init_zone twice if memory gets attached to
an empty zone. Once via init_currently_empty_zone and once explictly
right after that call.
Looks like this is currently not a bug, however the call is
superfluous and might lead to subtle bugs if memmap_init_zone gets
changed. So make sure it is called only once.

Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 mm/memory_hotplug.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: linux-2.6/mm/memory_hotplug.c
===================================================================
--- linux-2.6.orig/mm/memory_hotplug.c
+++ linux-2.6/mm/memory_hotplug.c
@@ -167,13 +167,9 @@ static int __add_zone(struct zone *zone,
 	int zone_type;
 
 	zone_type = zone - pgdat->node_zones;
-	if (!zone->wait_table) {
-		int ret = 0;
-		ret = init_currently_empty_zone(zone, phys_start_pfn,
-						nr_pages, MEMMAP_HOTPLUG);
-		if (ret < 0)
-			return ret;
-	}
+	if (!zone->wait_table)
+		return init_currently_empty_zone(zone, phys_start_pfn,
+						 nr_pages, MEMMAP_HOTPLUG);
 	memmap_init_zone(nr_pages, nid, zone_type,
 			 phys_start_pfn, MEMMAP_HOTPLUG);
 	return 0;

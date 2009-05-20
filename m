Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZETHUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZETHUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbZETHUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:20:10 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:33857 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZETHUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=SUui1NpDDqYfI8Hv9YlZr66oifSXHZjjKJbJ61Tqs9qTujLXqAPHaLyr6rQmNmRqaW
         1HQJY0++t3sz1ZUFpwmiyeUXSTMj0tUEm9m0C9DII2ViaNE6P87E7WekvqBdFfykMKD9
         3B+HHt/s9ijBR1F26ztVWUL34FiPr22ByTJX4=
Date: Wed, 20 May 2009 16:20:01 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 3/3] reset wmark_min and inactive ratio of zone when hotplug
 happens
Message-Id: <20090520162001.3f3bbe5c.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch solve two problems.

Whenever memory hotplug sucessfully happens, zone->present_pages
have to be changed.

1) Now, memory hotplug calls setup_per_zone_wmark_min only when
online_pages called, not offline_pages.

It breaks balance.

2) If zone->present_pages is changed, we also have to change
zone->inactive_ratio. That's because inactive_ratio depends
on zone->present_pages.

CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/memory_hotplug.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 40bf385..1611010 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -423,6 +423,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages)
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 
 	setup_per_zone_wmark_min();
+	calculate_per_zone_inactive_ratio(zone);
 	if (onlined_pages) {
 		kswapd_run(zone_to_nid(zone));
 		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
@@ -832,6 +833,9 @@ repeat:
 	totalram_pages -= offlined_pages;
 	num_physpages -= offlined_pages;
 
+	setup_per_zone_wmark_min();
+	calculate_per_zone_inactive_ratio(zone);
+
 	vm_total_pages = nr_free_pagecache_pages();
 	writeback_set_ratelimit();
 
-- 
1.5.4.3



-- 
Kinds Regards
Minchan Kim

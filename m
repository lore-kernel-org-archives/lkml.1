Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbZHRPdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbZHRPdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758025AbZHRPdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:33:41 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46134 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbZHRPdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:33:40 -0400
Message-Id: <4A8AE5F50200007800010536@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 18 Aug 2009 16:33:41 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Cc: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: [PATCH] fix updating of num_physpages for hot plugged memory
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sizing of memory allocations shouldn't depend on the number of physical
pages found in a system, as that generally includes (perhaps a huge
amount of) non-RAM pages. The amount of what actually is usable as
storage should instead be used as a basis here.

In line with that, the memory hotplug code should update num_physpages
in a way that it retains its original (post-boot) meaning; in
particular, decreasing the value should at best be done with great care
- this patch doesn't try to ever decrease this value at all as it
doesn't really seem meaningful to do so.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>

---
 mm/memory_hotplug.c               |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.31-rc6/mm/memory_hotplug.c	2009-08-18 15:31:56.000000000 +0200
+++ 2.6.31-rc6-use-totalram_pages/mm/memory_hotplug.c	2009-08-17 15:21:19.000000000 +0200
@@ -339,8 +339,11 @@ EXPORT_SYMBOL_GPL(__remove_pages);
 
 void online_page(struct page *page)
 {
+	unsigned long pfn = page_to_pfn(page);
+
 	totalram_pages++;
-	num_physpages++;
+	if (pfn >= num_physpages)
+		num_physpages = pfn + 1;
 
 #ifdef CONFIG_HIGHMEM
 	if (PageHighMem(page))
@@ -831,7 +834,6 @@ repeat:
 	zone->present_pages -= offlined_pages;
 	zone->zone_pgdat->node_present_pages -= offlined_pages;
 	totalram_pages -= offlined_pages;
-	num_physpages -= offlined_pages;
 
 	setup_per_zone_wmarks();
 	calculate_zone_inactive_ratio(zone);




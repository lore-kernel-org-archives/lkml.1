Return-Path: <linux-kernel-owner+w=401wt.eu-S1762265AbXIKGNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762265AbXIKGNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965654AbXIKGFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:05:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50595 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761494AbXIKGEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:32 -0400
Message-Id: <20070911060430.797813790@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:13 -0700
From: Christoph Lameter <clameter@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com
Cc: joern@lazybastard.org
Subject: [23/41] compound pages: vmstat support
Content-Disposition: inline; filename=0023-compound-pages-vmstat-support.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for compound pages so that

inc_xxxx_state() and dec_xxx_state()

will increment the ZVCs by the number of base pages of the compound page.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/vmstat.h |    5 ++---
 mm/vmstat.c            |   18 +++++++++++++-----
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 75370ec..6d03a5a 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -234,7 +234,7 @@ static inline void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 static inline void __inc_zone_page_state(struct page *page,
 			enum zone_stat_item item)
 {
-	__inc_zone_state(page_zone(page), item);
+	__mod_zone_page_state(page_zone(page), item, compound_pages(page));
 }
 
 static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
@@ -246,8 +246,7 @@ static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 static inline void __dec_zone_page_state(struct page *page,
 			enum zone_stat_item item)
 {
-	atomic_long_dec(&page_zone(page)->vm_stat[item]);
-	atomic_long_dec(&vm_stat[item]);
+	__mod_zone_page_state(page_zone(page), item, -compound_pages(page));
 }
 
 /*
diff --git a/mm/vmstat.c b/mm/vmstat.c
index c64d169..3e07215 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -225,7 +225,12 @@ void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 
 void __inc_zone_page_state(struct page *page, enum zone_stat_item item)
 {
-	__inc_zone_state(page_zone(page), item);
+	struct zone *z = page_zone(page);
+
+	if (likely(!PageHead(page)))
+		__inc_zone_state(z, item);
+	else
+		__mod_zone_page_state(z, item, compound_pages(page));
 }
 EXPORT_SYMBOL(__inc_zone_page_state);
 
@@ -246,7 +251,12 @@ void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 
 void __dec_zone_page_state(struct page *page, enum zone_stat_item item)
 {
-	__dec_zone_state(page_zone(page), item);
+	struct zone *z = page_zone(page);
+
+	if (likely(!PageHead(page)))
+		__dec_zone_state(z, item);
+	else
+		__mod_zone_page_state(z, item, -compound_pages(page));
 }
 EXPORT_SYMBOL(__dec_zone_page_state);
 
@@ -262,11 +272,9 @@ void inc_zone_state(struct zone *zone, enum zone_stat_item item)
 void inc_zone_page_state(struct page *page, enum zone_stat_item item)
 {
 	unsigned long flags;
-	struct zone *zone;
 
-	zone = page_zone(page);
 	local_irq_save(flags);
-	__inc_zone_state(zone, item);
+	__inc_zone_page_state(page, item);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(inc_zone_page_state);
-- 
1.5.2.5

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762669AbXFTSlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762669AbXFTSlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758037AbXFTSbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54794 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757735AbXFTSaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:12 -0400
Message-Id: <20070620183011.831089388@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:32 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [25/37] compound pages: vmstat support
Content-Disposition: inline; filename=compound_vmstat
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for compound pages so that

inc_xxxx and dec_xxx

will increment the ZVCs by the number of pages of the compound page.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/vmstat.h |    5 ++---
 mm/vmstat.c            |   18 +++++++++++++-----
 2 files changed, 15 insertions(+), 8 deletions(-)

Index: vps/include/linux/vmstat.h
===================================================================
--- vps.orig/include/linux/vmstat.h	2007-06-11 15:56:37.000000000 -0700
+++ vps/include/linux/vmstat.h	2007-06-12 19:06:32.000000000 -0700
@@ -234,7 +234,7 @@ static inline void __inc_zone_state(stru
 static inline void __inc_zone_page_state(struct page *page,
 			enum zone_stat_item item)
 {
-	__inc_zone_state(page_zone(page), item);
+	__mod_zone_page_state(page_zone(page), item, compound_pages(page));
 }
 
 static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
@@ -246,8 +246,7 @@ static inline void __dec_zone_state(stru
 static inline void __dec_zone_page_state(struct page *page,
 			enum zone_stat_item item)
 {
-	atomic_long_dec(&page_zone(page)->vm_stat[item]);
-	atomic_long_dec(&vm_stat[item]);
+	__mod_zone_page_state(page_zone(page), item, -compound_pages(page));
 }
 
 /*
Index: vps/mm/vmstat.c
===================================================================
--- vps.orig/mm/vmstat.c	2007-06-11 15:56:37.000000000 -0700
+++ vps/mm/vmstat.c	2007-06-12 19:06:32.000000000 -0700
@@ -225,7 +225,12 @@ void __inc_zone_state(struct zone *zone,
 
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
 
@@ -246,7 +251,12 @@ void __dec_zone_state(struct zone *zone,
 
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
 
@@ -262,11 +272,9 @@ void inc_zone_state(struct zone *zone, e
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

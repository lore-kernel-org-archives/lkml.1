Return-Path: <linux-kernel-owner+w=401wt.eu-S1761761AbXH1TL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761AbXH1TL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761007AbXH1THw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:07:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58811 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756857AbXH1THh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:37 -0400
Message-Id: <20070828190733.411372399@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:14 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [23/36] compound pages: vmstat support
Content-Disposition: inline; filename=0023-compound-pages-vmstat-support.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for compound pages so that

inc_xxxx and dec_xxx

will increment the ZVCs by the number of base pages of the compound page.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/vmstat.h |    5 ++---
 mm/vmstat.c            |   18 +++++++++++++-----
 2 files changed, 15 insertions(+), 8 deletions(-)

Index: linux-2.6/include/linux/vmstat.h
===================================================================
--- linux-2.6.orig/include/linux/vmstat.h	2007-08-27 19:22:13.000000000 -0700
+++ linux-2.6/include/linux/vmstat.h	2007-08-27 20:59:42.000000000 -0700
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
Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2007-08-27 19:22:13.000000000 -0700
+++ linux-2.6/mm/vmstat.c	2007-08-27 20:59:42.000000000 -0700
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

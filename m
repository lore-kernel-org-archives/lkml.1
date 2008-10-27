Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbYJ0RTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbYJ0RTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYJ0RTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:19:12 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:42808 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYJ0RTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:19:11 -0400
Subject: [PATCH] memory hotplug: fix page_zone() calculation in
	test_pages_isolated()
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       y-goto@jp.fujitsu.com
In-Reply-To: <4905F114.3030406@de.ibm.com>
References: <4905F114.3030406@de.ibm.com>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 18:19:09 +0100
Message-Id: <1225127949.20384.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

My last bugfix here (adding zone->lock) introduced a new problem: Using
pfn_to_page(pfn) to get the zone after the for() loop is wrong. pfn then
points to the first pfn after end_pfn, which may be in a different zone
or not present at all. This may lead to an addressing exception in
page_zone() or spin_lock_irqsave().

Using the last valid page that was found inside the for() loop, instead
of pfn_to_page(), should fix this.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>

---
 mm/page_isolation.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/page_isolation.c
===================================================================
--- linux-2.6.orig/mm/page_isolation.c
+++ linux-2.6/mm/page_isolation.c
@@ -115,7 +115,7 @@ __test_page_isolated_in_pageblock(unsign
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long pfn, flags;
-	struct page *page;
+	struct page *page = NULL;
 	struct zone *zone;
 	int ret;
 
@@ -130,10 +130,10 @@ int test_pages_isolated(unsigned long st
 		if (page && get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 			break;
 	}
-	if (pfn < end_pfn)
+	if ((pfn < end_pfn) || !page)
 		return -EBUSY;
 	/* Check all pages are free or Marked as ISOLATED */
-	zone = page_zone(pfn_to_page(pfn));
+	zone = page_zone(page);
 	spin_lock_irqsave(&zone->lock, flags);
 	ret = __test_page_isolated_in_pageblock(start_pfn, end_pfn);
 	spin_unlock_irqrestore(&zone->lock, flags);


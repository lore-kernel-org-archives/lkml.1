Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYJ2R2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYJ2R2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 13:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYJ2R2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 13:28:39 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54168 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbYJ2R2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 13:28:38 -0400
Message-ID: <49089D46.1090609@austin.ibm.com>
Date: Wed, 29 Oct 2008 12:28:38 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Badari Pulavarty <badari@us.ibm.com>
Subject: [PATCH] Use correct page frame number to grab page zone lock
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are situations in which the 'pfn' variable used to calculate the
page zone can be invalid.  One case is in the hotplug memory remove path
where we are trying to remove memory the last valid page frame for the
system.  Passing an invalid page frame number to the pfn_to_page() macro
will cause the system to oops.

Additionally I think this also solves an issue where we may be grabbing
the wrong zone->lock.  This would occur when 'pfn' refers to a page
frame beyond what we are examining and lies in a different zone.

Using the starting page frame number passed in appears to resolve
both of these issues.  This patch also removes the redundant
initialization of 'pfn', it is set explicitly and then again in the for loop.


Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---

Index: linux-2.6/mm/page_isolation.c
===================================================================
--- linux-2.6.orig/mm/page_isolation.c	2008-10-13 12:00:46.000000000 -0500
+++ linux-2.6/mm/page_isolation.c	2008-10-29 11:18:39.000000000 -0500
@@ -119,7 +119,6 @@
 	struct zone *zone;
 	int ret;
 
-	pfn = start_pfn;
 	/*
 	 * Note: pageblock_nr_page != MAX_ORDER. Then, chunks of free page
 	 * is not aligned to pageblock_nr_pages.
@@ -133,7 +132,7 @@
 	if (pfn < end_pfn)
 		return -EBUSY;
 	/* Check all pages are free or Marked as ISOLATED */
-	zone = page_zone(pfn_to_page(pfn));
+	zone = page_zone(pfn_to_page(start_pfn));
 	spin_lock_irqsave(&zone->lock, flags);
 	ret = __test_page_isolated_in_pageblock(start_pfn, end_pfn);
 	spin_unlock_irqrestore(&zone->lock, flags);

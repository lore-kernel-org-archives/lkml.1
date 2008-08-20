Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbYHTRJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbYHTRJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYHTRI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:08:56 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56668 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbYHTRIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:08:55 -0400
Subject: [BUG] Make setup_zone_migrate_reserve() aware of overlapping nodes
From: Adam Litke <agl@us.ibm.com>
To: linux-mm <linux-mm@kvack.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       nacc <nacc@linux.vnet.ibm.com>, mel@csn.ul.ie, apw <apw@shadowen.org>,
       agl <agl@linux.vnet.ibm.com>
In-Reply-To: <1218837685.12953.11.camel@localhost.localdomain>
References: <1218837685.12953.11.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Wed, 20 Aug 2008 12:08:54 -0500
Message-Id: <1219252134.13885.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have gotten to the root cause of the hugetlb badness I reported back
on August 15th.  My system has the following memory topology (note the
overlapping node):

	﻿Node 0 Memory: 0x8000000-0x44000000
	﻿Node 1 Memory: 0x0-0x8000000 0x44000000-0x80000000

setup_zone_migrate_reserve() scans the address range 0x0-0x8000000
looking for a pageblock to move onto the MIGRATE_RESERVE list.  Finding
no candidates, it happily continues the scan into 0x8000000-0x44000000.
When a pageblock is found, the pages are moved to the MIGRATE_RESERVE
list on the wrong zone.  Oops.

(Andrew: once the proper fix is agreed upon, this should also be a
candidate for -stable.)

setup_zone_migrate_reserve() should skip pageblocks in overlapping
nodes.

Signed-off-by: Adam Litke <agl@us.ibm.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index af982f7..f297a9b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2512,6 +2512,10 @@ static void setup_zone_migrate_reserve(struct zone *zone)
 							pageblock_order;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
+		/* Watch out for overlapping nodes */
+		if (!early_pfn_in_nid(pfn, zone->node))
+			continue;
+
 		if (!pfn_valid(pfn))
 			continue;
 		page = pfn_to_page(pfn);

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center


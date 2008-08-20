Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbYHTT4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbYHTT4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYHTTzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:55:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49207 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbYHTTzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:55:55 -0400
Subject: [BUG] [PATCH v2] Make setup_zone_migrate_reserve() aware of
	overlapping nodes
From: Adam Litke <agl@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       nacc <nacc@linux.vnet.ibm.com>, mel@csn.ul.ie, apw <apw@shadowen.org>,
       agl <agl@linux.vnet.ibm.com>
In-Reply-To: <1219255911.8960.41.camel@nimitz>
References: <1218837685.12953.11.camel@localhost.localdomain>
	 <1219252134.13885.25.camel@localhost.localdomain>
	 <1219255911.8960.41.camel@nimitz>
Content-Type: text/plain
Organization: IBM
Date: Wed, 20 Aug 2008 14:55:52 -0500
Message-Id: <1219262152.13885.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Changes since V1
     - Fix build for !NUMA
     - Add VM_BUG_ON() to catch this problem at the source
    
    I have gotten to the root cause of the hugetlb badness I reported back on
    August 15th.  My system has the following memory topology (note the
    overlapping node):
    
            Node 0 Memory: 0x8000000-0x44000000
            Node 1 Memory: 0x0-0x8000000 0x44000000-0x80000000
    
    setup_zone_migrate_reserve() scans the address range 0x0-0x8000000 looking
    for a pageblock to move onto the MIGRATE_RESERVE list.  Finding no
    candidates, it happily continues the scan into 0x8000000-0x44000000.  When
    a pageblock is found, the pages are moved to the MIGRATE_RESERVE list on
    the wrong zone.  Oops.
    
    (Andrew: once the proper fix is agreed upon, this should also be a
    candidate for -stable.)
    
    setup_zone_migrate_reserve() should skip pageblocks in overlapping nodes.
    
    Signed-off-by: Adam Litke <agl@us.ibm.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index af982f7..feb7916 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -694,6 +694,9 @@ static int move_freepages(struct zone *zone,
 #endif
 
 	for (page = start_page; page <= end_page;) {
+		/* Make sure we are not inadvertently changing nodes */
+		VM_BUG_ON(page_to_nid(page) != zone_to_nid(zone));
+
 		if (!pfn_valid_within(page_to_pfn(page))) {
 			page++;
 			continue;
@@ -2516,6 +2519,10 @@ static void setup_zone_migrate_reserve(struct zone *zone)
 			continue;
 		page = pfn_to_page(pfn);
 
+		/* Watch out for overlapping nodes */
+		if (page_to_nid(page) != zone_to_nid(zone))
+			continue;
+
 		/* Blocks with reserved pages will never free, skip them. */
 		if (PageReserved(page))
 			continue;

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center


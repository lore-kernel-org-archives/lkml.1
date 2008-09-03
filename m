Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbYICRu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbYICRu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbYICRuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:50:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:58590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756928AbYICRuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:50:44 -0400
Date: Wed, 3 Sep 2008 10:32:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Adam Litke <agl@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>
Subject: [patch 06/16] mm: make setup_zone_migrate_reserve() aware of
	overlapping nodes
Message-ID: <20080903173254.GG10429@suse.de>
References: <20080903172849.927077124@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-make-setup_zone_migrate_reserve-aware-of-overlapping-nodes.patch"
In-Reply-To: <20080903173218.GA10429@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Adam Litke <agl@us.ibm.com>

commit 344c790e3821dac37eb742ddd0b611a300f78b9a upstream

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

setup_zone_migrate_reserve() should skip pageblocks in overlapping nodes.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -717,6 +717,9 @@ int move_freepages(struct zone *zone,
 #endif
 
 	for (page = start_page; page <= end_page;) {
+		/* Make sure we are not inadvertently changing nodes */
+		VM_BUG_ON(page_to_nid(page) != zone_to_nid(zone));
+
 		if (!pfn_valid_within(page_to_pfn(page))) {
 			page++;
 			continue;
@@ -2476,6 +2479,10 @@ static void setup_zone_migrate_reserve(s
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

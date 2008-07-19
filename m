Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYGSRc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYGSRc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 13:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbYGSRcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 13:32:20 -0400
Received: from saeurebad.de ([85.214.36.134]:49855 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbYGSRcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 13:32:20 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] mm: more likely reclaim MADV_SEQUENTIAL mappings
CC: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Nossum <vegard.nossum@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Date: Sat, 19 Jul 2008 19:31:49 +0200
Message-ID: <87y73x4w6y.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File pages accessed only once through sequential-read mappings between
fault and scan time are perfect candidates for reclaim.

This patch makes page_referenced() ignore these singular references and
the pages stay on the inactive list where they likely fall victim to the
next reclaim phase.

Already activated pages are still treated normally.  If they were
accessed multiple times and therefor promoted to the active list, we
probably want to keep them.

Benchmarks show that big (relative to the system's memory)
MADV_SEQUENTIAL mappings read sequentially cause much less kernel
activity.  Especially less LRU moving-around because we never activate
read-once pages in the first place just to demote them again.

And leaving these perfect reclaim candidates on the inactive list makes
it more likely for the real working set to survive the next reclaim
scan.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 mm/rmap.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

Benchmark graphs and the test-application can be found here:

	http://hannes.saeurebad.de/madvseq/

Patch is against -mm, although only tested on good ol' linus-tree as
-mmotm wouldn't compile at the moment.

--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -333,8 +333,18 @@ static int page_referenced_one(struct pa
 		goto out_unmap;
 	}
 
-	if (ptep_clear_flush_young_notify(vma, address, pte))
-		referenced++;
+	if (ptep_clear_flush_young_notify(vma, address, pte)) {
+		/*
+		 * If there was just one sequential access to the
+		 * page, ignore it.  Otherwise, mark_page_accessed()
+		 * will have promoted the page to the active list and
+		 * it should be kept.
+		 */
+		if (VM_SequentialReadHint(vma) && !PageActive(page))
+			ClearPageReferenced(page);
+		else
+			referenced++;
+	}
 
 	/* Pretend the page is referenced if the task has the
 	   swap token and is in the middle of a page fault. */
@@ -455,9 +465,6 @@ int page_referenced(struct page *page, i
 {
 	int referenced = 0;
 
-	if (TestClearPageReferenced(page))
-		referenced++;
-
 	if (page_mapped(page) && page->mapping) {
 		if (PageAnon(page))
 			referenced += page_referenced_anon(page, mem_cont);
@@ -473,6 +480,9 @@ int page_referenced(struct page *page, i
 		}
 	}
 
+	if (TestClearPageReferenced(page))
+		referenced++;
+
 	if (page_test_and_clear_young(page))
 		referenced++;
 

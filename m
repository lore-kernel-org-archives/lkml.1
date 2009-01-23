Return-Path: <linux-kernel-owner+w=401wt.eu-S1762976AbZAWBa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762976AbZAWBa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756380AbZAWBP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:58 -0500
Received: from kroah.org ([198.145.64.141]:50767 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760255AbZAWBPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:12 -0500
Date: Thu, 22 Jan 2009 17:12:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>,
       Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>
Subject: [patch 34/46] mm: write_cache_pages cyclic fix
Message-ID: <20090123011244.GI19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-write_cache_pages-cyclic-fix.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 31a12666d8f0c22235297e1c1575f82061480029 upstream.

In write_cache_pages, scanned == 1 is supposed to mean that cyclic
writeback has circled through zero, thus we should not circle again.
However it gets set to 1 after the first successful pagevec lookup.  This
leads to cases where not enough data gets written.

Counterexample: file with first 10 pages dirty, writeback_index == 5,
nr_to_write == 10.  Then the 5 last pages will be found, and scanned will
be set to 1, after writing those out, we will not cycle back to get the
first 5.

Rework this logic, now we'll always cycle unless we started off from index
0.  When cycling, only write out as far as 1 page before the start page
from the first cycle (so we don't write parts of the file twice).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page-writeback.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -868,9 +868,10 @@ int write_cache_pages(struct address_spa
 	int done = 0;
 	struct pagevec pvec;
 	int nr_pages;
+	pgoff_t uninitialized_var(writeback_index);
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
-	int scanned = 0;
+	int cycled;
 	int range_whole = 0;
 	long nr_to_write = wbc->nr_to_write;
 
@@ -881,14 +882,19 @@ int write_cache_pages(struct address_spa
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
-		index = mapping->writeback_index; /* Start from prev offset */
+		writeback_index = mapping->writeback_index; /* prev offset */
+		index = writeback_index;
+		if (index == 0)
+			cycled = 1;
+		else
+			cycled = 0;
 		end = -1;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		scanned = 1;
+		cycled = 1; /* ignore range_cyclic tests */
 	}
 retry:
 	while (!done && (index <= end) &&
@@ -897,7 +903,6 @@ retry:
 					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
 		unsigned i;
 
-		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
@@ -915,7 +920,11 @@ retry:
 				continue;
 			}
 
-			if (!wbc->range_cyclic && page->index > end) {
+			if (page->index > end) {
+				/*
+				 * can't be range_cyclic (1st pass) because
+				 * end == -1 in that case.
+				 */
 				done = 1;
 				unlock_page(page);
 				continue;
@@ -946,13 +955,15 @@ retry:
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	if (!scanned && !done) {
+	if (!cycled) {
 		/*
+		 * range_cyclic:
 		 * We hit the last page and there is more work to be done: wrap
 		 * back to the start of the file
 		 */
-		scanned = 1;
+		cycled = 1;
 		index = 0;
+		end = writeback_index - 1;
 		goto retry;
 	}
 	if (!wbc->no_nrwrite_index_update) {


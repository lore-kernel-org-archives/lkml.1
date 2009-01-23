Return-Path: <linux-kernel-owner+w=401wt.eu-S1762050AbZAWG2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050AbZAWG2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761228AbZAWGQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:56 -0500
Received: from kroah.org ([198.145.64.141]:36444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761200AbZAWGQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:53 -0500
Date: Thu, 22 Jan 2009 22:14:38 -0800
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
Subject: [patch 32/40] mm: write_cache_pages cleanups
Message-ID: <20090123061438.GF2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-write_cache_pages-cleanups.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 5a3d5c9813db56a75934eb1015367fda23a8b0b4 upstream.

Get rid of some complex expressions from flow control statements, add a
comment, remove some duplicate code.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page-writeback.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -902,11 +902,14 @@ int write_cache_pages(struct address_spa
 	}
 retry:
 	done_index = index;
-	while (!done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-					      PAGECACHE_TAG_DIRTY,
-					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
-		unsigned i;
+	while (!done && (index <= end)) {
+		int i;
+
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			      PAGECACHE_TAG_DIRTY,
+			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		if (nr_pages == 0)
+			break;
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
@@ -922,7 +925,16 @@ retry:
 			 */
 			lock_page(page);
 
+			/*
+			 * Page truncated or invalidated. We can freely skip it
+			 * then, even for data integrity operations: the page
+			 * has disappeared concurrently, so there could be no
+			 * real expectation of this data interity operation
+			 * even if there is now a new, dirty page at the same
+			 * pagecache address.
+			 */
 			if (unlikely(page->mapping != mapping)) {
+continue_unlock:
 				unlock_page(page);
 				continue;
 			}
@@ -933,18 +945,15 @@ retry:
 				 * end == -1 in that case.
 				 */
 				done = 1;
-				unlock_page(page);
-				continue;
+				goto continue_unlock;
 			}
 
 			if (wbc->sync_mode != WB_SYNC_NONE)
 				wait_on_page_writeback(page);
 
 			if (PageWriteback(page) ||
-			    !clear_page_dirty_for_io(page)) {
-				unlock_page(page);
-				continue;
-			}
+			    !clear_page_dirty_for_io(page))
+				goto continue_unlock;
 
 			ret = (*writepage)(page, wbc, data);
 
@@ -968,7 +977,8 @@ retry:
  			}
 
 			if (wbc->sync_mode == WB_SYNC_NONE) {
-				if (--wbc->nr_to_write <= 0)
+				wbc->nr_to_write--;
+				if (wbc->nr_to_write <= 0)
 					done = 1;
 			}
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {


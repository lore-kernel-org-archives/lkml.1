Return-Path: <linux-kernel-owner+w=401wt.eu-S1764099AbZAWG11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764099AbZAWG11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761236AbZAWGQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:53 -0500
Received: from kroah.org ([198.145.64.141]:36435 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752146AbZAWGQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:50 -0500
Date: Thu, 22 Jan 2009 22:14:30 -0800
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
Subject: [patch 29/40] mm: write_cache_pages early loop termination
Message-ID: <20090123061430.GC2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-write_cache_pages-early-loop-termination.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit bd19e012f6fd3b7309689165ea865cbb7bb88c1e upstream.

We'd like to break out of the loop early in many situations, however the
existing code has been setting mapping->writeback_index past the final
page in the pagevec lookup for cyclic writeback.  This is a problem if we
don't process all pages up to the final page.

Currently the code mostly keeps writeback_index reasonable and hacked
around this by not breaking out of the loop or writing pages outside the
range in these cases.  Keep track of a real "done index" that enables us
to terminate the loop in a much more flexible manner.

Needed by the subsequent patch to preserve writepage errors, and then
further patches to break out of the loop early for other reasons.  However
there are no functional changes with this patch alone.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page-writeback.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -875,6 +875,7 @@ int write_cache_pages(struct address_spa
 	pgoff_t uninitialized_var(writeback_index);
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
+	pgoff_t done_index;
 	int cycled;
 	int range_whole = 0;
 
@@ -900,6 +901,7 @@ int write_cache_pages(struct address_spa
 		cycled = 1; /* ignore range_cyclic tests */
 	}
 retry:
+	done_index = index;
 	while (!done && (index <= end) &&
 	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
 					      PAGECACHE_TAG_DIRTY,
@@ -909,6 +911,8 @@ retry:
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
+			done_index = page->index + 1;
+
 			/*
 			 * At this point we hold neither mapping->tree_lock nor
 			 * lock on the page itself: the page may be truncated or
@@ -970,7 +974,7 @@ retry:
 		goto retry;
 	}
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
-		mapping->writeback_index = index;
+		mapping->writeback_index = done_index;
 
 	if (wbc->range_cont)
 		wbc->range_start = index << PAGE_CACHE_SHIFT;


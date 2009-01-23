Return-Path: <linux-kernel-owner+w=401wt.eu-S1763287AbZAWB0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763287AbZAWB0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760138AbZAWBPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:34 -0500
Received: from kroah.org ([198.145.64.141]:50788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756349AbZAWBPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:17 -0500
Date: Thu, 22 Jan 2009 17:12:55 -0800
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
Subject: [patch 37/46] mm: write_cache_pages integrity fix
Message-ID: <20090123011255.GM19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-write_cache_pages-integrity-fix.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 05fe478dd04e02fa230c305ab9b5616669821dd3 upstream.

In write_cache_pages, nr_to_write is heeded even for data-integrity syncs,
so the function will return success after writing out nr_to_write pages,
even if that was not sufficient to guarantee data integrity.

The callers tend to set it to values that could break data interity
semantics easily in practice.  For example, nr_to_write can be set to
mapping->nr_pages * 2, however if a file has a single, dirty page, then
fsync is called, subsequent pages might be concurrently added and dirtied,
then write_cache_pages might writeout two of these newly dirty pages,
while not writing out the old page that should have been written out.

Fix this by ignoring nr_to_write if it is a data integrity sync.

This is a data integrity bug.

The reason this has been done in the past is to avoid stalling sync
operations behind page dirtiers.

 "If a file has one dirty page at offset 1000000000000000 then someone
  does an fsync() and someone else gets in first and starts madly writing
  pages at offset 0, we want to write that page at 1000000000000000.
  Somehow."

What we do today is return success after an arbitrary amount of pages are
written, whether or not we have provided the data-integrity semantics that
the caller has asked for.  Even this doesn't actually fix all stall cases
completely: in the above situation, if the file has a huge number of pages
in pagecache (but not dirty), then mapping->nrpages is going to be huge,
even if pages are being dirtied.

This change does indeed make the possibility of long stalls lager, and
that's not a good thing, but lying about data integrity is even worse.  We
have to either perform the sync, or return -ELINUXISLAME so at least the
caller knows what has happened.

There are subsequent competing approaches in the works to solve the stall
problems properly, without compromising data integrity.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/filemap.c        |    2 +-
 mm/page-writeback.c |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -210,7 +210,7 @@ int __filemap_fdatawrite_range(struct ad
 	int ret;
 	struct writeback_control wbc = {
 		.sync_mode = sync_mode,
-		.nr_to_write = mapping->nrpages * 2,
+		.nr_to_write = LONG_MAX,
 		.range_start = start,
 		.range_end = end,
 	};
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -963,8 +963,10 @@ retry:
 				}
  			}
 
-			if (--nr_to_write <= 0)
-				done = 1;
+			if (wbc->sync_mode == WB_SYNC_NONE) {
+				if (--wbc->nr_to_write <= 0)
+					done = 1;
+			}
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;
 				done = 1;


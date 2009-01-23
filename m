Return-Path: <linux-kernel-owner+w=401wt.eu-S1763984AbZAWB37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763984AbZAWB37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbZAWBPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:53 -0500
Received: from kroah.org ([198.145.64.141]:50788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760226AbZAWBPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:15 -0500
Date: Thu, 22 Jan 2009 17:12:48 -0800
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
Subject: [patch 36/46] mm: write_cache_pages writepage error fix
Message-ID: <20090123011248.GK19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-write_cache_pages-writepage-error-fix.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 00266770b8b3a6a77f896ca501a0613739086832 upstream.

In write_cache_pages, if ret signals a real error, but we still have some
pages left in the pagevec, done would be set to 1, but the remaining pages
would continue to be processed and ret will be overwritten in the process.

It could easily be overwritten with success, and thus success will be
returned even if there is an error.  Thus the caller is told all writes
succeeded, wheras in reality some did not.

Fix this by bailing immediately if there is an error, and retaining the
first error code.

This is a data integrity bug.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page-writeback.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -944,12 +944,26 @@ retry:
 			}
 
 			ret = (*writepage)(page, wbc, data);
+			if (unlikely(ret)) {
+				if (ret == AOP_WRITEPAGE_ACTIVATE) {
+					unlock_page(page);
+					ret = 0;
+				} else {
+					/*
+					 * done_index is set past this page,
+					 * so media errors will not choke
+					 * background writeout for the entire
+					 * file. This has consequences for
+					 * range_cyclic semantics (ie. it may
+					 * not be suitable for data integrity
+					 * writeout).
+					 */
+					done = 1;
+					break;
+				}
+ 			}
 
-			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
-				unlock_page(page);
-				ret = 0;
-			}
-			if (ret || (--nr_to_write <= 0))
+			if (--nr_to_write <= 0)
 				done = 1;
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;


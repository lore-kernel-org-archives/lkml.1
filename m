Return-Path: <linux-kernel-owner+w=401wt.eu-S1764192AbZAWG1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764192AbZAWG1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761240AbZAWGQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:54 -0500
Received: from kroah.org ([198.145.64.141]:36444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761226AbZAWGQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:51 -0500
Date: Thu, 22 Jan 2009 22:14:32 -0800
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
Subject: [patch 30/40] mm: write_cache_pages writepage error fix
Message-ID: <20090123061432.GD2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-write_cache_pages-writepage-error-fix.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
 mm/page-writeback.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -948,11 +948,26 @@ retry:
 
 			ret = (*writepage)(page, wbc, data);
 
-			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
-				unlock_page(page);
-				ret = 0;
-			}
-			if (ret || (--(wbc->nr_to_write) <= 0))
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
+
+			if (--(wbc->nr_to_write) <= 0)
 				done = 1;
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;


Return-Path: <linux-kernel-owner+w=401wt.eu-S1765396AbZBNBcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765396AbZBNBcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762723AbZBNBQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:15 -0500
Received: from kroah.org ([198.145.64.141]:50263 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762583AbZBNBQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:09 -0500
Date: Fri, 13 Feb 2009 17:12:41 -0800
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
       alan@lxorguk.ukuu.org.uk, Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [patch 11/48] write-back: fix nr_to_write counter
Message-ID: <20090214011241.GL17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="write-back-fix-nr_to_write-counter.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit dcf6a79dda5cc2a2bec183e50d829030c0972aaa upstream.

Commit 05fe478dd04e02fa230c305ab9b5616669821dd3 introduced some
@wbc->nr_to_write breakage.

It made the following changes:
 1. Decrement wbc->nr_to_write instead of nr_to_write
 2. Decrement wbc->nr_to_write _only_ if wbc->sync_mode == WB_SYNC_NONE
 3. If synced nr_to_write pages, stop only if if wbc->sync_mode ==
    WB_SYNC_NONE, otherwise keep going.

However, according to the commit message, the intention was to only make
change 3.  Change 1 is a bug.  Change 2 does not seem to be necessary,
and it breaks UBIFS expectations, so if needed, it should be done
separately later.  And change 2 does not seem to be documented in the
commit message.

This patch does the following:
 1. Undo changes 1 and 2
 2. Add a comment explaining change 3 (it very useful to have comments
    in _code_, not only in the commit).

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page-writeback.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -981,13 +981,22 @@ continue_unlock:
 				}
  			}
 
-			if (wbc->sync_mode == WB_SYNC_NONE) {
-				wbc->nr_to_write--;
-				if (wbc->nr_to_write <= 0) {
-					done = 1;
-					break;
-				}
+			if (nr_to_write > 0)
+				nr_to_write--;
+			else if (wbc->sync_mode == WB_SYNC_NONE) {
+				/*
+				 * We stop writing back only if we are not
+				 * doing integrity sync. In case of integrity
+				 * sync we have to keep going because someone
+				 * may be concurrently dirtying pages, and we
+				 * might have synced a lot of newly appeared
+				 * dirty pages, but have not synced all of the
+				 * old dirty pages.
+				 */
+				done = 1;
+				break;
 			}
+
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;
 				done = 1;


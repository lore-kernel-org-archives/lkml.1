Return-Path: <linux-kernel-owner+w=401wt.eu-S1761749AbZAWB1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761749AbZAWB1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760062AbZAWBPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:35 -0500
Received: from kroah.org ([198.145.64.141]:50857 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756811AbZAWBPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:17 -0500
Date: Thu, 22 Jan 2009 17:12:58 -0800
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
Subject: [patch 39/46] mm: write_cache_pages optimise page cleaning
Message-ID: <20090123011258.GN19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-write_cache_pages-optimise-page-cleaning.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 515f4a037fb9ab736f8bad733fcd2ffd350cf265 upstream.

In write_cache_pages, if we get stuck behind another process that is
cleaning pages, we will be forced to wait for them to finish, then perform
our own writeout (if it was redirtied during the long wait), then wait for
that.

If a page under writeout is still clean, we can skip waiting for it (if
we're part of a data integrity sync, we'll be waiting for all writeout
pages afterwards, so we'll still be waiting for the other guy's write
that's cleaned the page).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page-writeback.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -945,11 +945,20 @@ continue_unlock:
 				goto continue_unlock;
 			}
 
-			if (wbc->sync_mode != WB_SYNC_NONE)
-				wait_on_page_writeback(page);
+			if (!PageDirty(page)) {
+				/* someone wrote it for us */
+				goto continue_unlock;
+			}
+
+			if (PageWriteback(page)) {
+				if (wbc->sync_mode != WB_SYNC_NONE)
+					wait_on_page_writeback(page);
+				else
+					goto continue_unlock;
+			}
 
-			if (PageWriteback(page) ||
-			    !clear_page_dirty_for_io(page))
+			BUG_ON(PageWriteback(page));
+			if (!clear_page_dirty_for_io(page))
 				goto continue_unlock;
 
 			ret = (*writepage)(page, wbc, data);


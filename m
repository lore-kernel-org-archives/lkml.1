Return-Path: <linux-kernel-owner+w=401wt.eu-S1762672AbZBNBFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762672AbZBNBFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbZBNBBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:35 -0500
Received: from kroah.org ([198.145.64.141]:39525 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755440AbZBNBBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:34 -0500
Date: Fri, 13 Feb 2009 16:58:28 -0800
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
Subject: [patch 12/47] writeback: fix break condition
Message-ID: <20090214005828.GM11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="writeback-fix-break-condition.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Federico Cuello <fedux@lugmen.org.ar>

commit 89e1219004b3657cc014521663eeef0744f1c99d upstream.

Commit dcf6a79dda5cc2a2bec183e50d829030c0972aaa ("write-back: fix
nr_to_write counter") fixed nr_to_write counter, but didn't set the break
condition properly.

If nr_to_write == 0 after being decremented it will loop one more time
before setting done = 1 and breaking the loop.

[akpm@linux-foundation.org: coding-style fixes]
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page-writeback.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -985,20 +985,23 @@ continue_unlock:
 				}
  			}
 
-			if (wbc->nr_to_write > 0)
+			if (wbc->nr_to_write > 0) {
 				wbc->nr_to_write--;
-			else if (wbc->sync_mode == WB_SYNC_NONE) {
-				/*
-				 * We stop writing back only if we are not
-				 * doing integrity sync. In case of integrity
-				 * sync we have to keep going because someone
-				 * may be concurrently dirtying pages, and we
-				 * might have synced a lot of newly appeared
-				 * dirty pages, but have not synced all of the
-				 * old dirty pages.
-				 */
-				done = 1;
-				break;
+				if (wbc->nr_to_write == 0 &&
+				    wbc->sync_mode == WB_SYNC_NONE) {
+					/*
+					 * We stop writing back only if we are
+					 * not doing integrity sync. In case of
+					 * integrity sync we have to keep going
+					 * because someone may be concurrently
+					 * dirtying pages, and we might have
+					 * synced a lot of newly appeared dirty
+					 * pages, but have not synced all of the
+					 * old dirty pages.
+					 */
+					done = 1;
+					break;
+				}
 			}
 
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {


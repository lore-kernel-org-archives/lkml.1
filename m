Return-Path: <linux-kernel-owner+w=401wt.eu-S1946283AbXBCCok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946283AbXBCCok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946291AbXBCCo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:44:26 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53572 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946280AbXBCCnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:43:55 -0500
Message-Id: <20070203023948.151061000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:19 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Drake <dsd@gentoo.org>, torvalds@osdl.org,
       Steve French <smfltc@us.ibm.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: [patch 15/59] Fix up CIFS for "test_clear_page_dirty()" removal
Content-Disposition: inline; filename=fix-up-cifs-for-test_clear_page_dirty-removal.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Linus Torvalds <torvalds@osdl.org>

Fix up CIFS for "test_clear_page_dirty()" removal

This also adds he required page "writeback" flag handling, that cifs
hasn't been doing and that the page dirty flag changes made obvious.

Acked-by: Steve French <smfltc@us.ibm.com>
Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
This fixes a long term corruption bug when copying large files to a CIFS 
mount. Thanks Linus!

---
 fs/cifs/file.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

--- linux-2.6.19.2.orig/fs/cifs/file.c
+++ linux-2.6.19.2/fs/cifs/file.c
@@ -1244,14 +1244,21 @@ retry:
 				wait_on_page_writeback(page);
 
 			if (PageWriteback(page) ||
-					!test_clear_page_dirty(page)) {
+					!clear_page_dirty_for_io(page)) {
 				unlock_page(page);
 				break;
 			}
 
+			/*
+			 * This actually clears the dirty bit in the radix tree.
+			 * See cifs_writepage() for more commentary.
+			 */
+			set_page_writeback(page);
+
 			if (page_offset(page) >= mapping->host->i_size) {
 				done = 1;
 				unlock_page(page);
+				end_page_writeback(page);
 				break;
 			}
 
@@ -1315,6 +1322,7 @@ retry:
 					SetPageError(page);
 				kunmap(page);
 				unlock_page(page);
+				end_page_writeback(page);
 				page_cache_release(page);
 			}
 			if ((wbc->nr_to_write -= n_iov) <= 0)
@@ -1351,11 +1359,23 @@ static int cifs_writepage(struct page* p
         if (!PageUptodate(page)) {
 		cFYI(1, ("ppw - page not up to date"));
 	}
-	
+
+	/*
+	 * Set the "writeback" flag, and clear "dirty" in the radix tree.
+	 *
+	 * A writepage() implementation always needs to do either this,
+	 * or re-dirty the page with "redirty_page_for_writepage()" in
+	 * the case of a failure.
+	 *
+	 * Just unlocking the page will cause the radix tree tag-bits
+	 * to fail to update with the state of the page correctly.
+	 */
+	set_page_writeback(page);		
 	rc = cifs_partialpagewrite(page, 0, PAGE_CACHE_SIZE);
 	SetPageUptodate(page); /* BB add check for error and Clearuptodate? */
 	unlock_page(page);
-	page_cache_release(page);	
+	end_page_writeback(page);
+	page_cache_release(page);
 	FreeXid(xid);
 	return rc;
 }

--

Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbXIJKYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbXIJKYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXIJKYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:24:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35776 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbXIJKYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:24:23 -0400
Date: Mon, 10 Sep 2007 19:25:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: mark.fasheh@oracle.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [28/35] changes in
 OCFS2
Message-Id: <20070910192505.f8832cfe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes page->mapping handling in OCFS2

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/ocfs2/aops.c |    8 ++++----
 fs/ocfs2/mmap.c |    3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

Index: test-2.6.23-rc4-mm1/fs/ocfs2/aops.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/ocfs2/aops.c
+++ test-2.6.23-rc4-mm1/fs/ocfs2/aops.c
@@ -208,7 +208,7 @@ bail:
 
 static int ocfs2_readpage(struct file *file, struct page *page)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	loff_t start = (loff_t)page->index << PAGE_CACHE_SHIFT;
 	int ret, unlock = 1;
 
@@ -540,14 +540,14 @@ static void ocfs2_dio_end_io(struct kioc
  */
 static void ocfs2_invalidatepage(struct page *page, unsigned long offset)
 {
-	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
+	journal_t *journal = OCFS2_SB(page_inode(page)->i_sb)->journal->j_journal;
 
 	journal_invalidatepage(journal, page, offset);
 }
 
 static int ocfs2_releasepage(struct page *page, gfp_t wait)
 {
-	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
+	journal_t *journal = OCFS2_SB(page_inode(page)->i_sb)->journal->j_journal;
 
 	if (!page_has_buffers(page))
 		return 0;
@@ -1065,7 +1065,7 @@ static int ocfs2_grab_pages_for_write(st
 			 */
 			lock_page(mmap_page);
 
-			if (mmap_page->mapping != mapping) {
+			if (!pagecache_consistent(mmap_page, mapping)) {
 				unlock_page(mmap_page);
 				/*
 				 * Sanity check - the locking in
Index: test-2.6.23-rc4-mm1/fs/ocfs2/mmap.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/ocfs2/mmap.c
+++ test-2.6.23-rc4-mm1/fs/ocfs2/mmap.c
@@ -112,7 +112,8 @@ static int __ocfs2_page_mkwrite(struct i
 	 * page mapping after taking the page lock inside of
 	 * ocfs2_write_begin_nolock().
 	 */
-	if (!PageUptodate(page) || page->mapping != inode->i_mapping) {
+	if (!PageUptodate(page) ||
+	    !pagecache_consistent(page, inode->i_mapping)) {
 		ret = -EINVAL;
 		goto out;
 	}


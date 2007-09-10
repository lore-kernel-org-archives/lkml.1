Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXIJKfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXIJKfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbXIJKfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:35:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36528 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbXIJKfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:35:05 -0400
Date: Mon, 10 Sep 2007 19:36:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [35/35] changes in XFS
Message-Id: <20070910193649.3c3097ee.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change page->mapping handling in XFS

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


---
 fs/xfs/linux-2.6/xfs_aops.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: test-2.6.23-rc4-mm1/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/xfs/linux-2.6/xfs_aops.c
+++ test-2.6.23-rc4-mm1/fs/xfs/linux-2.6/xfs_aops.c
@@ -595,7 +595,7 @@ xfs_probe_page(
 	if (PageWriteback(page))
 		return 0;
 
-	if (page->mapping && PageDirty(page)) {
+	if (page_mapping_cache(page) && PageDirty(page)) {
 		if (page_has_buffers(page)) {
 			struct buffer_head	*bh, *head;
 
@@ -697,7 +697,7 @@ xfs_is_delayed_page(
 	if (PageWriteback(page))
 		return 0;
 
-	if (page->mapping && page_has_buffers(page)) {
+	if (page_mapping_cache(page) && page_has_buffers(page)) {
 		struct buffer_head	*bh, *head;
 		int			acceptable = 0;
 
@@ -752,7 +752,7 @@ xfs_convert_page(
 		goto fail;
 	if (PageWriteback(page))
 		goto fail_unlock_page;
-	if (page->mapping != inode->i_mapping)
+	if (pagecache_consistent(page, inode->i_mapping))
 		goto fail_unlock_page;
 	if (!xfs_is_delayed_page(page, (*ioendp)->io_type))
 		goto fail_unlock_page;
@@ -1178,7 +1178,7 @@ xfs_vm_writepage(
 	int			error;
 	int			need_trans;
 	int			delalloc, unmapped, unwritten;
-	struct inode		*inode = page->mapping->host;
+	struct inode		*inode = page_inode(page);
 
 	xfs_page_trace(XFS_WRITEPAGE_ENTER, inode, page, 0);
 
@@ -1270,7 +1270,7 @@ xfs_vm_releasepage(
 	struct page		*page,
 	gfp_t			gfp_mask)
 {
-	struct inode		*inode = page->mapping->host;
+	struct inode		*inode = page_inode(page);
 	int			dirty, delalloc, unmapped, unwritten;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_ALL,
@@ -1562,7 +1562,7 @@ xfs_vm_invalidatepage(
 	unsigned long		offset)
 {
 	xfs_page_trace(XFS_INVALIDPAGE_ENTER,
-			page->mapping->host, page, offset);
+			page_inode(page), page, offset);
 	block_invalidatepage(page, offset);
 }
 


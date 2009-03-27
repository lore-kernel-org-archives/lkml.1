Return-Path: <linux-kernel-owner+w=401wt.eu-S1762748AbZC0UZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762748AbZC0UZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761658AbZC0UYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:24:40 -0400
Received: from THUNK.ORG ([69.25.196.29]:45716 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761413AbZC0UYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:24:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 3/3] ext3: Avoid starting a transaction in writepage when not necessary
Date: Fri, 27 Mar 2009 16:24:31 -0400
Message-Id: <1238185471-31152-4-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1238185471-31152-3-git-send-email-tytso@mit.edu>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu>
 <1238185471-31152-2-git-send-email-tytso@mit.edu>
 <1238185471-31152-3-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

We don't have to start a transaction in writepage() when all the blocks
are a properly allocated. Even in ordered mode either the data has been
written via write() and they are thus already added to transaction's list
or the data was written via mmap and then it's random in which transaction
they get written anyway.

This should help VM to pageout dirty memory without blocking on transaction
commits.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext3/inode.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5fa453b..a9c12b1 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1435,6 +1435,10 @@ static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
+static int buffer_unmapped(handle_t *handle, struct buffer_head *bh)
+{
+	return !buffer_mapped(bh);
+}
 /*
  * Note that we always start a transaction even if we're not journalling
  * data.  This is to preserve ordering: any hole instantiation within
@@ -1505,6 +1509,16 @@ static int ext3_ordered_writepage(struct page *page,
 	if (ext3_journal_current_handle())
 		goto out_fail;
 
+	if (!page_has_buffers(page)) {
+		create_empty_buffers(page, inode->i_sb->s_blocksize,
+				(1 << BH_Dirty)|(1 << BH_Uptodate));
+	} else if (!walk_page_buffers(NULL, page_buffers(page), 0, PAGE_CACHE_SIZE, NULL, buffer_unmapped)) {
+		/* Provide NULL instead of get_block so that we catch bugs if buffers weren't really mapped */
+		return block_write_full_page(page, NULL, wbc);
+	}
+	page_bufs = page_buffers(page);
+
+
 	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
 
 	if (IS_ERR(handle)) {
@@ -1512,11 +1526,6 @@ static int ext3_ordered_writepage(struct page *page,
 		goto out_fail;
 	}
 
-	if (!page_has_buffers(page)) {
-		create_empty_buffers(page, inode->i_sb->s_blocksize,
-				(1 << BH_Dirty)|(1 << BH_Uptodate));
-	}
-	page_bufs = page_buffers(page);
 	walk_page_buffers(handle, page_bufs, 0,
 			PAGE_CACHE_SIZE, NULL, bget_one);
 
-- 
1.5.6.3


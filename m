Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbZFHTbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbZFHTbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbZFHTXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:50 -0400
Received: from thunk.org ([69.25.196.29]:39524 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbZFHTXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:12 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 47/49] ext4: Avoid leaking blocks after a block allocation failure
Date: Mon,  8 Jun 2009 15:23:05 -0400
Message-Id: <1244488987-32564-48-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-47-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
 <1244488987-32564-22-git-send-email-tytso@mit.edu>
 <1244488987-32564-23-git-send-email-tytso@mit.edu>
 <1244488987-32564-24-git-send-email-tytso@mit.edu>
 <1244488987-32564-25-git-send-email-tytso@mit.edu>
 <1244488987-32564-26-git-send-email-tytso@mit.edu>
 <1244488987-32564-27-git-send-email-tytso@mit.edu>
 <1244488987-32564-28-git-send-email-tytso@mit.edu>
 <1244488987-32564-29-git-send-email-tytso@mit.edu>
 <1244488987-32564-30-git-send-email-tytso@mit.edu>
 <1244488987-32564-31-git-send-email-tytso@mit.edu>
 <1244488987-32564-32-git-send-email-tytso@mit.edu>
 <1244488987-32564-33-git-send-email-tytso@mit.edu>
 <1244488987-32564-34-git-send-email-tytso@mit.edu>
 <1244488987-32564-35-git-send-email-tytso@mit.edu>
 <1244488987-32564-36-git-send-email-tytso@mit.edu>
 <1244488987-32564-37-git-send-email-tytso@mit.edu>
 <1244488987-32564-38-git-send-email-tytso@mit.edu>
 <1244488987-32564-39-git-send-email-tytso@mit.edu>
 <1244488987-32564-40-git-send-email-tytso@mit.edu>
 <1244488987-32564-41-git-send-email-tytso@mit.edu>
 <1244488987-32564-42-git-send-email-tytso@mit.edu>
 <1244488987-32564-43-git-send-email-tytso@mit.edu>
 <1244488987-32564-44-git-send-email-tytso@mit.edu>
 <1244488987-32564-45-git-send-email-tytso@mit.edu>
 <1244488987-32564-46-git-send-email-tytso@mit.edu>
 <1244488987-32564-47-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We should add inode to the orphan list in the same transaction
as block allocation.  This ensures that if we crash after a failed
block allocation and before we do a vmtruncate we don't leak block
(ie block marked as used in bitmap but not claimed by the inode).

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
CC:  Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 95a3f45..036552a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1462,7 +1462,7 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 				struct page **pagep, void **fsdata)
 {
 	struct inode *inode = mapping->host;
-	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
+	int ret, needed_blocks;
 	handle_t *handle;
 	int retries = 0;
 	struct page *page;
@@ -1473,6 +1473,11 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 		   "dev %s ino %lu pos %llu len %u flags %u",
 		   inode->i_sb->s_id, inode->i_ino,
 		   (unsigned long long) pos, len, flags);
+	/*
+	 * Reserve one block more for addition to orphan list in case
+	 * we allocate blocks but write fails for some reason
+	 */
+	needed_blocks = ext4_writepage_trans_blocks(inode) + 1;
  	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
@@ -1506,15 +1511,30 @@ retry:
 
 	if (ret) {
 		unlock_page(page);
-		ext4_journal_stop(handle);
 		page_cache_release(page);
 		/*
 		 * block_write_begin may have instantiated a few blocks
 		 * outside i_size.  Trim these off again. Don't need
 		 * i_size_read because we hold i_mutex.
+		 *
+		 * Add inode to orphan list in case we crash before
+		 * truncate finishes
 		 */
 		if (pos + len > inode->i_size)
+			ext4_orphan_add(handle, inode);
+
+		ext4_journal_stop(handle);
+		if (pos + len > inode->i_size) {
 			vmtruncate(inode, inode->i_size);
+			/* 
+			 * If vmtruncate failed early the inode might
+			 * still be on the orphan list; we need to
+			 * make sure the inode is removed from the
+			 * orphan list in that case.
+			 */
+			if (inode->i_nlink)
+				ext4_orphan_del(NULL, inode);
+		}
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-- 
1.6.3.2.1.gb9f7d.dirty


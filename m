Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098Ab0AZT3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab0AZT3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072Ab0AZT3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:29:01 -0500
Received: from kroah.org ([198.145.64.141]:33578 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab0AZT3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:29:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 11:16:24 2010
Message-Id: <20100126191624.151291187@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 11:14:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>
Subject: [03/11] reiserfs: truncate blocks not used by a write
In-Reply-To: <20100126191730.GA20872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit ec8e2f7466ca370f5e09000ca40a71759afc9ac8 upstream.

It can happen that write does not use all the blocks allocated in
write_begin either because of some filesystem error (like ENOSPC) or
because page with data to write has been removed from memory.  We truncate
these blocks so that we don't have dangling blocks beyond i_size.

Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/reiserfs/inode.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2545,6 +2545,12 @@ static int reiserfs_writepage(struct pag
 	return reiserfs_write_full_page(page, wbc);
 }
 
+static void reiserfs_truncate_failed_write(struct inode *inode)
+{
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	reiserfs_truncate_file(inode, 0);
+}
+
 static int reiserfs_write_begin(struct file *file,
 				struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
@@ -2611,6 +2617,8 @@ static int reiserfs_write_begin(struct f
 	if (ret) {
 		unlock_page(page);
 		page_cache_release(page);
+		/* Truncate allocated blocks */
+		reiserfs_truncate_failed_write(inode);
 	}
 	return ret;
 }
@@ -2703,8 +2711,7 @@ static int reiserfs_write_end(struct fil
 	 ** transaction tracking stuff when the size changes.  So, we have
 	 ** to do the i_size updates here.
 	 */
-	pos += copied;
-	if (pos > inode->i_size) {
+	if (pos + copied > inode->i_size) {
 		struct reiserfs_transaction_handle myth;
 		reiserfs_write_lock(inode->i_sb);
 		/* If the file have grown beyond the border where it
@@ -2722,7 +2729,7 @@ static int reiserfs_write_end(struct fil
 			goto journal_error;
 		}
 		reiserfs_update_inode_transaction(inode);
-		inode->i_size = pos;
+		inode->i_size = pos + copied;
 		/*
 		 * this will just nest into our transaction.  It's important
 		 * to use mark_inode_dirty so the inode gets pushed around on the
@@ -2749,6 +2756,10 @@ static int reiserfs_write_end(struct fil
       out:
 	unlock_page(page);
 	page_cache_release(page);
+
+	if (pos + len > inode->i_size)
+		reiserfs_truncate_failed_write(inode);
+
 	return ret == 0 ? copied : ret;
 
       journal_error:



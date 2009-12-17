Return-Path: <linux-kernel-owner+w=401wt.eu-S1763834AbZLQB0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763834AbZLQB0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763799AbZLQB0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:26:16 -0500
Received: from kroah.org ([198.145.64.141]:41501 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763710AbZLQBVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:21:03 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:08 2009
Message-Id: <20091217011608.568487962@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>
Subject: [81/90] ext3: Fix data / filesystem corruption when write fails to copy data
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit 68eb3db08344286733adac48304d9fb7a0e53b27 upstream.

When ext3_write_begin fails after allocating some blocks or
generic_perform_write fails to copy data to write, we truncate blocks already
instantiated beyond i_size. Although these blocks were never inside i_size, we
have to truncate pagecache of these blocks so that corresponding buffers get
unmapped. Otherwise subsequent __block_prepare_write (called because we are
retrying the write) will find the buffers mapped, not call ->get_block, and
thus the page will be backed by already freed blocks leading to filesystem and
data corruption.

Reported-by: James Y Knight <foom@fuhm.net>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext3/inode.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1137,6 +1137,16 @@ static int do_journal_get_write_access(h
 	return ext3_journal_get_write_access(handle, bh);
 }
 
+/*
+ * Truncate blocks that were not used by write. We have to truncate the
+ * pagecache as well so that corresponding buffers get properly unmapped.
+ */
+static void ext3_truncate_failed_write(struct inode *inode)
+{
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	ext3_truncate(inode);
+}
+
 static int ext3_write_begin(struct file *file, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
@@ -1195,7 +1205,7 @@ write_begin_failed:
 		unlock_page(page);
 		page_cache_release(page);
 		if (pos + len > inode->i_size)
-			ext3_truncate(inode);
+			ext3_truncate_failed_write(inode);
 	}
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
@@ -1290,7 +1300,7 @@ static int ext3_ordered_write_end(struct
 	page_cache_release(page);
 
 	if (pos + len > inode->i_size)
-		ext3_truncate(inode);
+		ext3_truncate_failed_write(inode);
 	return ret ? ret : copied;
 }
 
@@ -1316,7 +1326,7 @@ static int ext3_writeback_write_end(stru
 	page_cache_release(page);
 
 	if (pos + len > inode->i_size)
-		ext3_truncate(inode);
+		ext3_truncate_failed_write(inode);
 	return ret ? ret : copied;
 }
 
@@ -1369,7 +1379,7 @@ static int ext3_journalled_write_end(str
 	page_cache_release(page);
 
 	if (pos + len > inode->i_size)
-		ext3_truncate(inode);
+		ext3_truncate_failed_write(inode);
 	return ret ? ret : copied;
 }
 



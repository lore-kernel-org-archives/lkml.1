Return-Path: <linux-kernel-owner+w=401wt.eu-S933506AbZLKFb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506AbZLKFb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbZLKFby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:31:54 -0500
Received: from kroah.org ([198.145.64.141]:53572 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078AbZLKFaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:30:03 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:54 2009
Message-Id: <20091211052554.355331485@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [26/34] ext4: Avoid data / filesystem corruption when write fails to copy data
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0022-ext4-Avoid-data-filesystem-corruption-when-write-fai.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit b9a4207d5e911b938f73079a83cc2ae10524ec7f)

When ext4_write_begin fails after allocating some blocks or
generic_perform_write fails to copy data to write, we truncate blocks
already instantiated beyond i_size.  Although these blocks were never
inside i_size, we have to truncate the pagecache of these blocks so
that corresponding buffers get unmapped.  Otherwise subsequent
__block_prepare_write (called because we are retrying the write) will
find the buffers mapped, not call ->get_block, and thus the page will
be backed by already freed blocks leading to filesystem and data
corruption.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1534,6 +1534,16 @@ static int do_journal_get_write_access(h
 	return ext4_journal_get_write_access(handle, bh);
 }
 
+/*
+ * Truncate blocks that were not used by write. We have to truncate the
+ * pagecache as well so that corresponding buffers get properly unmapped.
+ */
+static void ext4_truncate_failed_write(struct inode *inode)
+{
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	ext4_truncate(inode);
+}
+
 static int ext4_write_begin(struct file *file, struct address_space *mapping,
 			    loff_t pos, unsigned len, unsigned flags,
 			    struct page **pagep, void **fsdata)
@@ -1599,7 +1609,7 @@ retry:
 
 		ext4_journal_stop(handle);
 		if (pos + len > inode->i_size) {
-			ext4_truncate(inode);
+			ext4_truncate_failed_write(inode);
 			/*
 			 * If truncate failed early the inode might
 			 * still be on the orphan list; we need to
@@ -1709,7 +1719,7 @@ static int ext4_ordered_write_end(struct
 		ret = ret2;
 
 	if (pos + len > inode->i_size) {
-		ext4_truncate(inode);
+		ext4_truncate_failed_write(inode);
 		/*
 		 * If truncate failed early the inode might still be
 		 * on the orphan list; we need to make sure the inode
@@ -1751,7 +1761,7 @@ static int ext4_writeback_write_end(stru
 		ret = ret2;
 
 	if (pos + len > inode->i_size) {
-		ext4_truncate(inode);
+		ext4_truncate_failed_write(inode);
 		/*
 		 * If truncate failed early the inode might still be
 		 * on the orphan list; we need to make sure the inode
@@ -1814,7 +1824,7 @@ static int ext4_journalled_write_end(str
 	if (!ret)
 		ret = ret2;
 	if (pos + len > inode->i_size) {
-		ext4_truncate(inode);
+		ext4_truncate_failed_write(inode);
 		/*
 		 * If truncate failed early the inode might still be
 		 * on the orphan list; we need to make sure the inode
@@ -3091,7 +3101,7 @@ retry:
 		 * i_size_read because we hold i_mutex.
 		 */
 		if (pos + len > inode->i_size)
-			ext4_truncate(inode);
+			ext4_truncate_failed_write(inode);
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))



Return-Path: <linux-kernel-owner+w=401wt.eu-S933323AbZLKEoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbZLKEoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762559AbZLKEoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:44:01 -0500
Received: from kroah.org ([198.145.64.141]:37105 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762275AbZLKEgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:43 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:16 2009
Message-Id: <20091211042816.324947251@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [78/90] ext4: Avoid data / filesystem corruption when write fails to copy data
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0078-ext4-Avoid-data-filesystem-corruption-when-write-fai.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1535,6 +1535,16 @@ static int do_journal_get_write_access(h
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
@@ -1600,7 +1610,7 @@ retry:
 
 		ext4_journal_stop(handle);
 		if (pos + len > inode->i_size) {
-			ext4_truncate(inode);
+			ext4_truncate_failed_write(inode);
 			/*
 			 * If truncate failed early the inode might
 			 * still be on the orphan list; we need to
@@ -1710,7 +1720,7 @@ static int ext4_ordered_write_end(struct
 		ret = ret2;
 
 	if (pos + len > inode->i_size) {
-		ext4_truncate(inode);
+		ext4_truncate_failed_write(inode);
 		/*
 		 * If truncate failed early the inode might still be
 		 * on the orphan list; we need to make sure the inode
@@ -1752,7 +1762,7 @@ static int ext4_writeback_write_end(stru
 		ret = ret2;
 
 	if (pos + len > inode->i_size) {
-		ext4_truncate(inode);
+		ext4_truncate_failed_write(inode);
 		/*
 		 * If truncate failed early the inode might still be
 		 * on the orphan list; we need to make sure the inode
@@ -1815,7 +1825,7 @@ static int ext4_journalled_write_end(str
 	if (!ret)
 		ret = ret2;
 	if (pos + len > inode->i_size) {
-		ext4_truncate(inode);
+		ext4_truncate_failed_write(inode);
 		/*
 		 * If truncate failed early the inode might still be
 		 * on the orphan list; we need to make sure the inode
@@ -3087,7 +3097,7 @@ retry:
 		 * i_size_read because we hold i_mutex.
 		 */
 		if (pos + len > inode->i_size)
-			ext4_truncate(inode);
+			ext4_truncate_failed_write(inode);
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))



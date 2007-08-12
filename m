Return-Path: <linux-kernel-owner+w=401wt.eu-S933246AbXHLJVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246AbXHLJVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760375AbXHLJVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:21:14 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37055 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757117AbXHLJVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:21:12 -0400
Message-ID: <386910468.27584@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070812092052.704326603@mail.ustc.edu.cn>
References: <20070812091120.189651872@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 17:11:22 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: "Cc: Ken Chen" <kenchen@google.com>, Anton Altaparmakov <aia21@cantab.net>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/6] writeback: fix ntfs with sb_has_dirty_inodes()
Content-Disposition: inline; filename=nfs-dirty-inodes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NTFS's if-condition on dirty inodes is not complete.
Fix it with sb_has_dirty_inodes().

Cc: Anton Altaparmakov <aia21@cantab.net>
Cc: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
---
 fs/fs-writeback.c  |   10 +++++++++-
 fs/ntfs/super.c    |    4 ++--
 include/linux/fs.h |    1 +
 3 files changed, 12 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc2-mm2.orig/fs/ntfs/super.c
+++ linux-2.6.23-rc2-mm2/fs/ntfs/super.c
@@ -2381,14 +2381,14 @@ static void ntfs_put_super(struct super_
 	 */
 	ntfs_commit_inode(vol->mft_ino);
 	write_inode_now(vol->mft_ino, 1);
-	if (!list_empty(&sb->s_dirty)) {
+	if (sb_has_dirty_inodes(sb)) {
 		const char *s1, *s2;
 
 		mutex_lock(&vol->mft_ino->i_mutex);
 		truncate_inode_pages(vol->mft_ino->i_mapping, 0);
 		mutex_unlock(&vol->mft_ino->i_mutex);
 		write_inode_now(vol->mft_ino, 1);
-		if (!list_empty(&sb->s_dirty)) {
+		if (sb_has_dirty_inodes(sb)) {
 			static const char *_s1 = "inodes";
 			static const char *_s2 = "";
 			s1 = _s1;
--- linux-2.6.23-rc2-mm2.orig/include/linux/fs.h
+++ linux-2.6.23-rc2-mm2/include/linux/fs.h
@@ -1712,6 +1712,7 @@ extern int bdev_read_only(struct block_d
 extern int set_blocksize(struct block_device *, int);
 extern int sb_set_blocksize(struct super_block *, int);
 extern int sb_min_blocksize(struct super_block *, int);
+extern int sb_has_dirty_inodes(struct super_block *);
 
 extern int generic_file_mmap(struct file *, struct vm_area_struct *);
 extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
--- linux-2.6.23-rc2-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc2-mm2/fs/fs-writeback.c
@@ -199,6 +199,14 @@ static void queue_io(struct super_block 
 	move_expired_inodes(&sb->s_dirty, &sb->s_io, older_than_this);
 }
 
+int sb_has_dirty_inodes(struct super_block *sb)
+{
+	return !list_empty(&sb->s_dirty) ||
+	       !list_empty(&sb->s_io) ||
+	       !list_empty(&sb->s_more_io);
+}
+EXPORT_SYMBOL(sb_has_dirty_inodes);
+
 /*
  * Write a single inode's dirty pages and inode data out to disk.
  * If `wait' is set, wait on the writeout.
@@ -492,7 +500,7 @@ writeback_inodes(struct writeback_contro
 restart:
 	sb = sb_entry(super_blocks.prev);
 	for (; sb != sb_entry(&super_blocks); sb = sb_entry(sb->s_list.prev)) {
-		if (!list_empty(&sb->s_dirty) || !list_empty(&sb->s_io)) {
+		if (sb_has_dirty_inodes(sb)) {
 			/* we're making our own get_super here */
 			sb->s_count++;
 			spin_unlock(&sb_lock);

-- 

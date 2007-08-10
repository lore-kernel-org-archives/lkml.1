Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbXHJGfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbXHJGfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 02:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbXHJGe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 02:34:26 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53387 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752182AbXHJGeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 02:34:25 -0400
Message-ID: <386727660.64743@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070810063419.786586676@mail.ustc.edu.cn>
References: <20070810063412.238042387@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 10 Aug 2007 14:34:16 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Ken Chen <kenchen@google.com>, Anton Altaparmakov <aia21@cantab.net>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/4] writeback: fix ntfs with sb_has_dirty_inodes()
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
--- linux-2.6.23-rc1-mm2.orig/fs/ntfs/super.c
+++ linux-2.6.23-rc1-mm2/fs/ntfs/super.c
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
--- linux-2.6.23-rc1-mm2.orig/include/linux/fs.h
+++ linux-2.6.23-rc1-mm2/include/linux/fs.h
@@ -1772,6 +1772,7 @@ extern int bdev_read_only(struct block_d
 extern int set_blocksize(struct block_device *, int);
 extern int sb_set_blocksize(struct super_block *, int);
 extern int sb_min_blocksize(struct super_block *, int);
+extern int sb_has_dirty_inodes(struct super_block *);
 
 extern int generic_file_mmap(struct file *, struct vm_area_struct *);
 extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);

-- 

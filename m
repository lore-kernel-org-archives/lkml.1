Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbZFQQFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbZFQQFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbZFQQFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:05:30 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:11537
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753969AbZFQQF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:05:29 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
To: Jeff Garzik <jeff@garzik.org>, open-osd <osd-dev@open-osd.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] exofs: Avoid using file_fsync()
Date: Wed, 17 Jun 2009 19:05:30 +0300
Message-Id: <1245254730-8644-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <4A391373.3050301@panasas.com>
References: <4A391373.3050301@panasas.com>
X-OriginalArrivalTime: 17 Jun 2009 16:05:32.0492 (UTC) FILETIME=[711840C0:01C9EF65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of file_fsync() in exofs_file_sync() is not necessary since it
does some extra stuff not used by exofs. Open code just the parts that
are currently needed.

TODO: Farther optimization can be done to sync the sb only on inode
update of new files, Usually the sb update is not needed in exofs.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/exofs.h |    3 +++
 fs/exofs/file.c  |   17 ++++++++++++-----
 fs/exofs/super.c |    2 +-
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index c413b74..5ec72e0 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -154,6 +154,9 @@ ino_t exofs_parent_ino(struct dentry *child);
 int exofs_set_link(struct inode *, struct exofs_dir_entry *, struct page *,
 		    struct inode *);
 
+/* super.c               */
+int exofs_sync_fs(struct super_block *sb, int wait);
+
 /*********************
  * operation vectors *
  *********************/
diff --git a/fs/exofs/file.c b/fs/exofs/file.c
index c681003..839b9dc 100644
--- a/fs/exofs/file.c
+++ b/fs/exofs/file.c
@@ -45,16 +45,23 @@ static int exofs_file_fsync(struct file *filp, struct dentry *dentry,
 {
 	int ret;
 	struct address_space *mapping = filp->f_mapping;
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb;
 
 	ret = filemap_write_and_wait(mapping);
 	if (ret)
 		return ret;
 
-	/*Note: file_fsync below also calles sync_blockdev, which is a no-op
-	 *      for exofs, but other then that it does sync_inode and
-	 *      sync_superblock which is what we need here.
-	 */
-	return file_fsync(filp, dentry, datasync);
+	/* sync the inode attributes */
+	ret = write_inode_now(inode, 1);
+
+	/* This is a good place to write the sb */
+	/* TODO: Sechedule an sb-sync on create */
+	sb = inode->i_sb;
+	if (sb->s_dirt)
+		exofs_sync_fs(sb, 1);
+
+	return ret;
 }
 
 static int exofs_flush(struct file *file, fl_owner_t id)
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index e47b38e..a343b4e 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -198,7 +198,7 @@ static const struct export_operations exofs_export_ops;
 /*
  * Write the superblock to the OSD
  */
-static int exofs_sync_fs(struct super_block *sb, int wait)
+int exofs_sync_fs(struct super_block *sb, int wait)
 {
 	struct exofs_sb_info *sbi;
 	struct exofs_fscb *fscb;
-- 
1.6.2.1


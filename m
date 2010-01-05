Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508Ab0AEAkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0AEAkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540Ab0AEAkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:40:15 -0500
Received: from kroah.org ([198.145.64.141]:42444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab0AEAgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:05 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dmitry Monakhov <dmonakhov@openvz.org>,
       Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 82/97] ext4: Convert to generic reserved quota's space management.
Date: Mon,  4 Jan 2010 16:33:35 -0800
Message-Id: <1262651630-7354-82-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit a9e7f4472075fb6937c545af3f6329e9946bbe66 upstream.

This patch also fixes write vs chown race condition.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4.h  |    6 +++++-
 fs/ext4/inode.c |   16 +++++++---------
 fs/ext4/super.c |    5 +++++
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bd2a9dd..d0a2afb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -698,6 +698,10 @@ struct ext4_inode_info {
 	__u16 i_extra_isize;
 
 	spinlock_t i_block_reservation_lock;
+#ifdef CONFIG_QUOTA
+	/* quota space reservation, managed internally by quota code */
+	qsize_t i_reserved_quota;
+#endif
 
 	/* completed async DIOs that might need unwritten extents handling */
 	struct list_head i_aio_dio_complete_list;
@@ -1432,7 +1436,7 @@ extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
-extern qsize_t ext4_get_reserved_space(struct inode *inode);
+extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern int flush_aio_dio_completed_IO(struct inode *inode);
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1dae9a4..374d38c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1045,17 +1045,12 @@ out:
 	return err;
 }
 
-qsize_t ext4_get_reserved_space(struct inode *inode)
+#ifdef CONFIG_QUOTA
+qsize_t *ext4_get_reserved_space(struct inode *inode)
 {
-	unsigned long long total;
-
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-	total = EXT4_I(inode)->i_reserved_data_blocks +
-		EXT4_I(inode)->i_reserved_meta_blocks;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-
-	return (total << inode->i_blkbits);
+	return &EXT4_I(inode)->i_reserved_quota;
 }
+#endif
 /*
  * Calculate the number of metadata blocks need to reserve
  * to allocate @blocks for non extent file based file
@@ -4850,6 +4845,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
 	inode->i_size = ext4_isize(raw_inode);
 	ei->i_disksize = inode->i_size;
+#ifdef CONFIG_QUOTA
+	ei->i_reserved_quota = 0;
+#endif
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
 	ei->i_block_group = iloc.block_group;
 	ei->i_last_alloc_group = ~0;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9ae5217..92943f2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -704,6 +704,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_allocated_meta_blocks = 0;
 	ei->i_delalloc_reserved_flag = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
+#ifdef CONFIG_QUOTA
+	ei->i_reserved_quota = 0;
+#endif
 	INIT_LIST_HEAD(&ei->i_aio_dio_complete_list);
 	ei->cur_aio_dio = NULL;
 	ei->i_sync_tid = 0;
@@ -1001,7 +1004,9 @@ static const struct dquot_operations ext4_quota_operations = {
 	.reserve_space	= dquot_reserve_space,
 	.claim_space	= dquot_claim_space,
 	.release_rsv	= dquot_release_reserved_space,
+#ifdef CONFIG_QUOTA
 	.get_reserved_space = ext4_get_reserved_space,
+#endif
 	.alloc_inode	= dquot_alloc_inode,
 	.free_space	= dquot_free_space,
 	.free_inode	= dquot_free_inode,
-- 
1.6.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265Ab0AEUH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0AEUH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179Ab0AEUHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:07:42 -0500
Received: from kroah.org ([198.145.64.141]:50093 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab0AEUGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:31 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:03 2010
Message-Id: <20100105200303.803308932@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: "Theodore Tso" <tytso@mit.edu>, Dmitry Monakhov <dmonakhov@openvz.org>,
       Jan Kara <jack@suse.cz>
Subject: [37/39] ext4: Convert to generic reserved quotas space management.
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

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

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -695,6 +695,10 @@ struct ext4_inode_info {
 	__u16 i_extra_isize;
 
 	spinlock_t i_block_reservation_lock;
+#ifdef CONFIG_QUOTA
+	/* quota space reservation, managed internally by quota code */
+	qsize_t i_reserved_quota;
+#endif
 
 	/* completed async DIOs that might need unwritten extents handling */
 	struct list_head i_aio_dio_complete_list;
@@ -1439,7 +1443,7 @@ extern int ext4_chunk_trans_blocks(struc
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
-extern qsize_t ext4_get_reserved_space(struct inode *inode);
+extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern int flush_aio_dio_completed_IO(struct inode *inode);
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1046,17 +1046,12 @@ out:
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
@@ -4840,6 +4835,9 @@ struct inode *ext4_iget(struct super_blo
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
 	inode->i_size = ext4_isize(raw_inode);
 	ei->i_disksize = inode->i_size;
+#ifdef CONFIG_QUOTA
+	ei->i_reserved_quota = 0;
+#endif
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
 	ei->i_block_group = iloc.block_group;
 	ei->i_last_alloc_group = ~0;
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -711,6 +711,9 @@ static struct inode *ext4_alloc_inode(st
 	ei->i_allocated_meta_blocks = 0;
 	ei->i_delalloc_reserved_flag = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
+#ifdef CONFIG_QUOTA
+	ei->i_reserved_quota = 0;
+#endif
 	INIT_LIST_HEAD(&ei->i_aio_dio_complete_list);
 	ei->cur_aio_dio = NULL;
 	ei->i_sync_tid = 0;
@@ -1008,7 +1011,9 @@ static struct dquot_operations ext4_quot
 	.reserve_space	= dquot_reserve_space,
 	.claim_space	= dquot_claim_space,
 	.release_rsv	= dquot_release_reserved_space,
+#ifdef CONFIG_QUOTA
 	.get_reserved_space = ext4_get_reserved_space,
+#endif
 	.alloc_inode	= dquot_alloc_inode,
 	.free_space	= dquot_free_space,
 	.free_inode	= dquot_free_inode,



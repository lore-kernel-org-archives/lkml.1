Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbXLLCzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbXLLCzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 21:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbXLLCzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 21:55:44 -0500
Received: from mx01.svc.telus.net ([204.209.205.52]:36367 "EHLO
	defout.telus.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751695AbXLLCzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 21:55:42 -0500
X-Greylist: delayed 1627 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 21:55:42 EST
From: Steven Cavanagh <steven.cavanagh@secretlab.ca>
Subject: [PATCH] fat: Editions to support fat_fallocate()
Date: Tue, 11 Dec 2007 17:20:09 -0700
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca
Message-Id: <20071212002009.7639.43568.stgit@jpe-laptop>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Cavanagh <steven.cavanagh@secretlab.ca>

Added support for fallocate for a msdos fat driver. This allows
preallocation of clusters to an inode before writes to reduce
file fragmentation

Signed-off-by: Steven.Cavanagh <steven.cavanagh@secretlab.ca>
---

 fs/fat/cache.c           |    9 ++
 fs/fat/file.c            |  167 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/fat/inode.c           |   21 ++++++
 include/linux/msdos_fs.h |    5 +
 4 files changed, 201 insertions(+), 1 deletions(-)

diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index 639b3b4..1a69ce4 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -8,6 +8,8 @@
  *  May 1999. AV. Fixed the bogosity with FAT32 (read "FAT28"). Fscking lusers.
  */
 
+#undef DEBUG
+
 #include <linux/fs.h>
 #include <linux/msdos_fs.h>
 #include <linux/buffer_head.h>
@@ -316,6 +318,10 @@ int fat_bmap(struct inode *inode, sector
 
 	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
 	offset  = sector & (sbi->sec_per_clus - 1);
+
+	pr_debug("fat_bmap():cluster:%d, offset:%d, last_block:%llu\n",
+		cluster, offset, last_block);
+
 	cluster = fat_bmap_cluster(inode, cluster);
 	if (cluster < 0)
 		return cluster;
@@ -324,6 +330,9 @@ int fat_bmap(struct inode *inode, sector
 		*mapped_blocks = sbi->sec_per_clus - offset;
 		if (*mapped_blocks > last_block - sector)
 			*mapped_blocks = last_block - sector;
+
+			pr_debug("fat_bmap():cluster:%d, phys:%llu\n",
+				cluster, *phys);
 	}
 	return 0;
 }
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 69a83b5..9698d42 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -6,6 +6,8 @@
  *  regular file handling primitives for fat-based filesystems
  */
 
+#undef DEBUG
+
 #include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/time.h>
@@ -15,6 +17,7 @@ #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
+#include <linux/falloc.h>
 
 int fat_generic_ioctl(struct inode *inode, struct file *filp,
 		      unsigned int cmd, unsigned long arg)
@@ -312,8 +315,172 @@ int fat_getattr(struct vfsmount *mnt, st
 }
 EXPORT_SYMBOL_GPL(fat_getattr);
 
+/*
+ * preallocate space for a file. This implements fat fallocate inode
+ * operation, which gets called from sys_fallocate system call. User
+ * space requests len bytes at offset.
+ */
+long fat_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
+{
+	unsigned int blkbits = inode->i_blkbits;
+	int ret = 0, err;
+	unsigned long offset_block, new_blocks;
+	unsigned long max_blocks, nblocks = 0;
+	unsigned long mapped_blocks = 0, cluster_offset = 0;
+
+	struct buffer_head bh;
+
+	loff_t newsize = 0;
+
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	sector_t phys;
+	struct timespec now;
+
+	/* preallocation to directories is currently not supported */
+	if (S_ISDIR(inode->i_mode)) {
+		printk(KERN_ERR
+		"fat_fallocate(): Directory prealloc not supported\n");
+		return -ENODEV;
+	}
+
+	offset_block = offset >> blkbits;
+	pr_debug("fat_fallocate:offset block:%lu\n", offset_block);
+
+	/* Determine new allocation block */
+	new_blocks = (MSDOS_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
+					- offset_block;
+	pr_debug("fat_fallocate:allocate block:%lu\n", new_blocks);
+
+	if ((offset_block + new_blocks) <=
+		(MSDOS_BLOCK_ALIGN(i_size_read(inode), blkbits)
+			>> blkbits)) {
+		printk(KERN_ERR
+			"fat_fallocate():Blocks already allocated\n");
+			return -EIO;
+	}
+	if (offset_block >
+		(MSDOS_BLOCK_ALIGN(i_size_read(inode), blkbits)
+				>> blkbits)) {
+			printk(KERN_ERR
+			"fat_fallocate():Offset error\n");
+			return -EIO;
+	}
+	while (ret >= 0 && nblocks < new_blocks) {
+
+		/* Allocate a new cluster after all the available
+		 * blocks(sectors) have been allocated.
+		 */
+		cluster_offset =
+			(unsigned long)offset_block & (sbi->sec_per_clus - 1);
+		if (!cluster_offset) {
+
+			ret = fat_add_cluster(inode);
+			if (ret) {
+				pr_debug("msdos_fallocate():Add cluster err\
+				inode#%lu, block = %lu, max_blocks = %lu\n",
+				inode->i_ino, offset_block, new_blocks);
+				break;
+			}
+		}
+
+		/* mapped blocks = 4 blocks/sector - offset into cluster */
+		mapped_blocks = sbi->sec_per_clus - cluster_offset;
+		pr_debug("msdos_fallocate():mapped_blocks:%lu\n",
+					mapped_blocks);
+
+		/*mapped_blocks and dos_max_blocks should
+		 *be the same because mapped_blocks used to
+		 *be calculated in __fat_get_block() as
+		 * sbi->sec_per_clus - offset(sector offset)
+		 */
+		max_blocks = min(mapped_blocks, (new_blocks-nblocks));
+
+		MSDOS_I(inode)->mmu_private +=
+				max_blocks << sb->s_blocksize_bits;
+
+		pr_debug("msdos_fallocate():MSDOS_I(inode)->mmu_private:%llu\n",
+				MSDOS_I(inode)->mmu_private);
+
+		pr_debug("msdos_fallocate():mapped_blocks:%lu,max_blocks:%lu\n",
+				mapped_blocks, max_blocks);
+
+		err = fat_bmap(inode, offset_block, &phys, &mapped_blocks);
+		if (err) {
+			printk(KERN_ERR
+			"msdos_fallocate():fat_bmap() error:%d\n", err);
+			return err;
+		}
+		pr_debug("msdos_fallocate():sector: %lu, phys: %llu\n",
+			offset_block, phys);
+
+		if (!phys) {
+			printk(KERN_ERR
+			"msdos_fallocate():Bad disk sector number\n");
+			return -EIO;
+		}
+		if (!mapped_blocks) {
+			printk(KERN_ERR
+			"msdos_fallocate():Block mapping error\n");
+			return -EIO;
+		}
+		set_buffer_new(&bh);
+		map_bh(&bh, sb, phys);
+		pr_debug("msdos_fallocate():b_size:%d, b_blocknr:%llu\n",
+			bh.b_size, bh.b_blocknr);
+
+		now = current_fs_time(inode->i_sb);
+		if (!timespec_equal(&inode->i_ctime, &now))
+				inode->i_ctime = now;
+
+		/*Increment the cluster block count*/
+		nblocks += mapped_blocks;
+		offset_block += mapped_blocks;
+	}
+
+	pr_debug("msdos_fallocate():fat_bmap():nblocks:%lu\n",
+			nblocks);
+	mark_inode_dirty(inode);
+
+	/*
+	 * Time to update the file size.
+	 * Update only when preallocation was requested beyond the file size.
+	 */
+	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+		(offset + len) > i_size_read(inode)) {
+		if (!ret) {
+			/*
+			 * if no error, we assume preallocation succeeded
+			 * completely
+			 */
+			mutex_lock(&inode->i_mutex);
+			i_size_write(inode, offset + len);
+			mutex_unlock(&inode->i_mutex);
+			pr_debug("msdos_fallocate():INODE SIZE:%llu\n",
+					i_size_read(inode));
+
+		} else if (ret && nblocks) {
+
+			printk(KERN_ERR
+			"msdos_fallocate(): Errors, updating inode size\n");
+			/* Handle partial allocation scenario */
+			mutex_lock(&inode->i_mutex);
+			newsize  = (nblocks << blkbits) + i_size_read(inode);
+			i_size_write(inode,
+				MSDOS_BLOCK_ALIGN(newsize, blkbits));
+			mutex_unlock(&inode->i_mutex);
+			pr_debug("msdos_fallocate():INODE SIZE:%llu\n",
+					i_size_read(inode));
+		}
+	}
+
+	return ret;
+
+}
+
 const struct inode_operations fat_file_inode_operations = {
 	.truncate	= fat_truncate,
 	.setattr	= fat_notify_change,
 	.getattr	= fat_getattr,
+	.fallocate	= fat_fallocate,
 };
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 920a576..463ead5 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -10,6 +10,8 @@
  *	Max Cohan: Fixed invalid FSINFO offset when info_sector is 0
  */
 
+#undef DEBUG
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/time.h>
@@ -38,7 +40,7 @@ static int fat_default_codepage = CONFIG
 static char fat_default_iocharset[] = CONFIG_FAT_DEFAULT_IOCHARSET;
 
 
-static int fat_add_cluster(struct inode *inode)
+int fat_add_cluster(struct inode *inode)
 {
 	int err, cluster;
 
@@ -64,6 +66,11 @@ static inline int __fat_get_block(struct
 	int err, offset;
 
 	err = fat_bmap(inode, iblock, &phys, &mapped_blocks);
+
+	pr_debug(
+	"__fat_get_block():phys: %llu, mapped_blocks:%lu,sector: %llu\n",
+		phys, mapped_blocks, iblock);
+
 	if (err)
 		return err;
 	if (phys) {
@@ -90,10 +97,18 @@ static inline int __fat_get_block(struct
 	/* available blocks on this cluster */
 	mapped_blocks = sbi->sec_per_clus - offset;
 
+	pr_debug(
+	"__fat_get_block(): max_blocks: %lu, mapped_blocks:%lu\n",
+		*max_blocks, mapped_blocks);
+
 	*max_blocks = min(mapped_blocks, *max_blocks);
 	MSDOS_I(inode)->mmu_private += *max_blocks << sb->s_blocksize_bits;
 
 	err = fat_bmap(inode, iblock, &phys, &mapped_blocks);
+	pr_debug(
+	"__fat_get_block():phys: %llu, mapped_blocks:%lu,sector: %llu\n",
+		phys, mapped_blocks, iblock);
+
 	if (err)
 		return err;
 
@@ -116,6 +131,10 @@ static int fat_get_block(struct inode *i
 	if (err)
 		return err;
 	bh_result->b_size = max_blocks << sb->s_blocksize_bits;
+
+	printk(KERN_INFO "fat_get_block():bh_result->b_size:%d\n",
+	       bh_result->b_size);
+
 	return 0;
 }
 
diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index f950921..034a2a4 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -109,6 +109,8 @@ #define VFAT_SFN_DISPLAY_WINNT	0x0004 /*
 #define VFAT_SFN_CREATE_WIN95	0x0100 /* emulate win95 rule for create */
 #define VFAT_SFN_CREATE_WINNT	0x0200 /* emulate winnt rule for create */
 
+#define MSDOS_BLOCK_ALIGN(size, blkbits)	ALIGN((size), (1 << (blkbits)))
+
 struct fat_boot_sector {
 	__u8	ignored[3];	/* Boot strap short or near jump */
 	__u8	system_id[8];	/* Name - can be used to special case
@@ -350,6 +352,9 @@ extern int fat_add_entries(struct inode 
 			   struct fat_slot_info *sinfo);
 extern int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo);
 
+/* fat/inode.c */
+extern int fat_add_cluster(struct inode *inode);
+
 /* fat/fatent.c */
 struct fat_entry {
 	int entry;

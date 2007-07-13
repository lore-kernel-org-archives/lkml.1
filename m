Return-Path: <linux-kernel-owner+w=401wt.eu-S934394AbXGMGCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934394AbXGMGCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbXGMGBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:01:51 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:50817 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbXGMGBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=W7lt1i9gQnhLirWAXvNqVRNDcPE1Wt9+csPUXLjH2AdhHu34GCZnteE54XskZbP9Z7N5z4Mm6cqCRbqG+z7WFpO3ptycZJY6o9xa9J06DGwl9vuBW2fTE2gWRY7CXn8PtnlnpeVPAspWByGx/ZXR5ohoW/Xi/sHc2i3502u19Tc=
Message-ID: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com>
Date: Fri, 13 Jul 2007 16:01:48 +1000
From: "Lindsay Roberts" <lindsay.roberts.os@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs: Add romfs version 2
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Increases romfs partition size limit from 2GB to 4GB.
* Adds new derivative of romfs filesystem (rom2fs) with
  block aligned regular file data to bring performance
  parity with ext2/3. This is about 225% of the read
  speed of the existing romfs.

Signed-off-by: Lindsay Roberts <lindsay.roberts.os@gmail.com>
---
genromfs patch available at http://rom2fs.googlepages.com .

 Documentation/filesystems/romfs.txt |   34 +++++--
 fs/romfs/inode.c                    |  195 +++++++++++++++++++++++++++++------
 include/linux/romfs_fs.h            |    1 +
 3 files changed, 187 insertions(+), 43 deletions(-)

diff --git a/Documentation/filesystems/romfs.txt
b/Documentation/filesystems/romfs.txt
index 2d2a7b2..170b1cc 100644
--- a/Documentation/filesystems/romfs.txt
+++ b/Documentation/filesystems/romfs.txt
@@ -7,6 +7,10 @@ similar feature, and even the possibility of a small
kernel, with a
 file system which doesn't take up useful memory from the router
 functions in the basement of your office.

+The romfs version 2 filesystem is a slight derivation created to fix
+performance issues with file data unaligned to logical disk blocks.
+It differs only in its placement of regular file data.
+
 For comparison, both the older minix and xiafs (the latter is now
 defunct) filesystems, compiled as module need more than 20000 bytes,
 while romfs is less than a page, about 4000 bytes (assuming i586
@@ -18,7 +22,10 @@ with romfs, it needed 3079 blocks.

 To create such a file system, you'll need a user program named
 genromfs.  It is available via anonymous ftp on sunsite.unc.edu and
-its mirrors, in the /pub/Linux/system/recovery/ directory.
+its mirrors, in the /pub/Linux/system/recovery/ directory, as well as
+at the sourceforge project http://romfs.sourceforge.net/ . A genromfs
+patch to support version 2 is available at
+http://rom2fs.googlepages.com/ .

 As the name suggests, romfs could be also used (space-efficiently) on
 various read-only media, like (E)EPROM disks if someone will have the
@@ -43,6 +50,11 @@ from the network, and you will have all the
tools/modules available
 from a nearby server, so you don't want to carry two disks for this
 purpose, just because it won't fit into ext2.

+romfs also has a secondary use in reproducibility. The absence of
+both timestamps and permission information coupled with the read-only
+nature of the file system gives it amazing capability as a byte
+reproducible medium for a given directory structure.
+
 romfs operates on block devices as you can expect, and the underlying
 structure is very simple.  Every accessible structure begins on 16
 byte boundaries for fast access.  The minimum space a file will take
@@ -50,7 +62,8 @@ is 32 bytes (this is an empty file, with a less than
16 character
 name).  The maximum overhead for any non-empty file is the header, and
 the 16 byte padding for the name and the contents, also 16+14+15 = 45
 bytes.  This is quite rare however, since most file names are longer
-than 3 bytes, and shorter than 15 bytes.
+than 3 bytes, and shorter than 15 bytes. romfs version 2 adds
+additional overhead in order to align file data to (1k) disk blocks.

 The layout of the filesystem is the following:

@@ -59,7 +72,7 @@ offset	    content
 	+---+---+---+---+
   0	| - | r | o | m |  \
 	+---+---+---+---+	The ASCII representation of those bytes
-  4	| 1 | f | s | - |  /	(i.e. "-rom1fs-")
+  4	| 1 | f | s | - |  /	(i.e. "-rom1fs-" or "-rom2fs-")
 	+---+---+---+---+
   8	|   full size	|	The number of accessible bytes in this fs.
 	+---+---+---+---+
@@ -101,8 +114,10 @@ offset	    content
  16	| file name     |	The zero terminated name of the file,
 	:               :	padded to 16 byte boundary
 	+---+---+---+---+
- xx	| file data	|
-	:		:
+ xx	| file data	|       In the case of romfs version 2 - regular
+	:		:       files, this offset is padded to the next
+                                1024 byte block relative to the start of
+                                the filesystem.

 Since the file headers begin always at a 16 byte boundary, the lowest
 4 bits would be always zero in the next filehdr pointer.  These four
@@ -169,11 +184,12 @@ solutions: implement write access as a
compile-time option, or a new,
 similarly small writable filesystem for RAM disks.

 - Since the files are only required to have alignment on a 16 byte
-boundary, it is currently possibly suboptimal to read or execute files
-from the filesystem.  It might be resolved by reordering file data to
-have most of it (i.e. except the start and the end) laying at "natural"
+boundary, it is currently suboptimal to read or execute files from the
+filesystem.  It might be resolved by reordering file data to have most
+of it (i.e. except the start and the end) laying at "natural"
 boundaries, thus it would be possible to directly map a big portion of
-the file contents to the mm subsystem.
+the file contents to the mm subsystem. This is addressed by romfs
+version 2.

 - Compression might be an useful feature, but memory is quite a
 limiting factor in my eyes.
diff --git a/fs/romfs/inode.c b/fs/romfs/inode.c
index 2284e03..9fa99d2 100644
--- a/fs/romfs/inode.c
+++ b/fs/romfs/inode.c
@@ -49,6 +49,7 @@
  *	Aug 1999	2.3.16		__initfunc() => __init change
  *	Oct 1999	2.3.24		page->owner hack obsoleted
  *	Nov 1999	2.3.27		2.3.25+ page->offset => index change
+ *	Jul 2007			added romfs version 2
  */

 /* todo:
@@ -75,6 +76,7 @@
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
+#include <linux/mpage.h>

 #include <asm/uaccess.h>

@@ -84,10 +86,25 @@ struct romfs_inode_info {
 	struct inode vfs_inode;
 };

-/* instead of private superblock data */
-static inline unsigned long romfs_maxsize(struct super_block *sb)
+struct romfs_fs_info {
+	u32 version;
+	u32 size;
+};
+
+enum {
+	ROMFS_VERSION_1 = 1,
+	ROMFS_VERSION_2 = 2,
+};
+
+/* access private superblock data */
+static inline struct romfs_fs_info *get_romfs_priv(struct super_block *sb)
 {
-	return (unsigned long)sb->s_fs_info;
+	return (struct romfs_fs_info *) sb->s_fs_info;
+}
+
+static inline u32 romfs_maxsize(struct super_block *sb)
+{
+	return get_romfs_priv(sb)->size;
 }

 static inline struct romfs_inode_info *ROMFS_I(struct inode *inode)
@@ -95,6 +112,13 @@ static inline struct romfs_inode_info
*ROMFS_I(struct inode *inode)
 	return list_entry(inode, struct romfs_inode_info, vfs_inode);
 }

+/* Returns the block number containing the given byte offset */
+static __u32
+romfs_blocknum(struct super_block *sb, __u32 offset)
+{
+	return (offset - 1) >> sb->s_blocksize_bits;
+}
+
 static __u32
 romfs_checksum(void *data, int size)
 {
@@ -117,7 +141,8 @@ static int romfs_fill_super(struct super_block *s,
void *data, int silent)
 	struct buffer_head *bh;
 	struct romfs_super_block *rsb;
 	struct inode *root;
-	int sz;
+	u32 sz;
+	struct romfs_fs_info * rom_info = NULL;

 	/* I would parse the options here, but there are none.. :) */

@@ -127,39 +152,51 @@ static int romfs_fill_super(struct super_block
*s, void *data, int silent)
 	bh = sb_bread(s, 0);
 	if (!bh) {
 		/* XXX merge with other printk? */
-                printk ("romfs: unable to read superblock\n");
+		printk ("romfs: unable to read superblock\n");
 		goto outnobh;
 	}

 	rsb = (struct romfs_super_block *)bh->b_data;
 	sz = be32_to_cpu(rsb->size);
-	if (rsb->word0 != ROMSB_WORD0 || rsb->word1 != ROMSB_WORD1
+	if (rsb->word0 != ROMSB_WORD0
+	   ||   (rsb->word1 != ROMSB_WORD1
+	      && rsb->word1 != ROM2SB_WORD1)
 	   || sz < ROMFH_SIZE) {
 		if (!silent)
 			printk ("VFS: Can't find a romfs filesystem on dev "
 				"%s.\n", s->s_id);
 		goto out;
 	}
-	if (romfs_checksum(rsb, min_t(int, sz, 512))) {
+	if (romfs_checksum(rsb, min_t(u32, sz, 512))) {
 		printk ("romfs: bad initial checksum on dev "
 			"%s.\n", s->s_id);
 		goto out;
 	}

 	s->s_magic = ROMFS_MAGIC;
-	s->s_fs_info = (void *)(long)sz;
+
+	rom_info = kmalloc (sizeof(struct romfs_fs_info), GFP_KERNEL);
+	if (!rom_info) {
+		printk ("romfs: not enough memory\n");
+		goto out;
+	}
+	s->s_fs_info = rom_info;
+	rom_info->size = sz;
+	rom_info->version = ROMFS_VERSION_1; /* Default to original romfs */
+
+	if (rsb->word1 == ROM2SB_WORD1) {
+		rom_info->version = ROMFS_VERSION_2;
+	}
+
+	sz=ROMFH_SIZE+((ROMFH_PAD+strnlen(rsb->name,ROMFS_MAXFN)+1)&ROMFH_MASK);

 	s->s_flags |= MS_RDONLY;

-	/* Find the start of the fs */
-	sz = (ROMFH_SIZE +
-	      strnlen(rsb->name, ROMFS_MAXFN) + 1 + ROMFH_PAD)
-	     & ROMFH_MASK;

 	s->s_op	= &romfs_ops;
 	root = iget(s, sz);
 	if (!root)
-		goto out;
+		goto outkfree;

 	s->s_root = d_alloc_root(root);
 	if (!s->s_root)
@@ -170,12 +207,21 @@ static int romfs_fill_super(struct super_block
*s, void *data, int silent)

 outiput:
 	iput(root);
+outkfree:
+	kfree(rom_info);
 out:
 	brelse(bh);
 outnobh:
 	return -EINVAL;
 }

+static void
+romfs_put_super(struct super_block * sb)
+{
+	kfree(sb->s_fs_info);
+	sb->s_fs_info = NULL;
+}
+
 /* That's simple too. */

 static int
@@ -233,6 +279,36 @@ romfs_strnlen(struct inode *i, unsigned long
offset, unsigned long count)
 	return res;
 }

+/* Fills the private romfs inode struct with version specific data */
+static void
+romfs_fill_private_inode(struct inode *inode, int is_regular)
+{
+	struct romfs_inode_info *romfs_inode = ROMFS_I(inode);
+	int info_len;
+
+	info_len = romfs_strnlen(inode,
+				 (inode->i_ino & ROMFH_MASK) + ROMFH_SIZE,
+				 ROMFS_MAXFN);
+
+	if (likely(info_len >= 0))
+		info_len = ((ROMFH_SIZE+info_len+1+ROMFH_PAD)&ROMFH_MASK);
+	else
+		info_len = 0;
+
+	romfs_inode->i_metasize = info_len;
+
+	if (get_romfs_priv(inode->i_sb)->version > ROMFS_VERSION_1
+	&& is_regular) {
+		/* Data is on logical block directly after end of header */
+		romfs_inode->i_dataoffset =
+			romfs_blocknum(inode->i_sb,
+				       inode->i_ino+romfs_inode->i_metasize)+1;
+	} else {
+		/* Data is on 16 byte boundry after header */
+		romfs_inode->i_dataoffset = info_len+(inode->i_ino&ROMFH_MASK);
+	}
+}
+
 static int
 romfs_copyfrom(struct inode *i, void *dest, unsigned long offset,
unsigned long count)
 {
@@ -240,11 +316,13 @@ romfs_copyfrom(struct inode *i, void *dest,
unsigned long offset, unsigned long
 	unsigned long avail, maxsize, res;

 	maxsize = romfs_maxsize(i->i_sb);
-	if (offset >= maxsize || count > maxsize || offset+count>maxsize)
+	if (unlikely(	offset >= maxsize
+		     || count > maxsize
+		     || offset + count > maxsize))
 		return -1;

 	bh = sb_bread(i->i_sb, offset>>ROMBSBITS);
-	if (!bh)
+	if (unlikely(!bh))
 		return -1;		/* error */

 	avail = ROMBSIZE - (offset & ROMBMASK);
@@ -259,7 +337,7 @@ romfs_copyfrom(struct inode *i, void *dest,
unsigned long offset, unsigned long
 		dest += maxsize;

 		bh = sb_bread(i->i_sb, offset>>ROMBSBITS);
-		if (!bh)
+		if (unlikely(!bh))
 			return -1;
 		maxsize = min_t(unsigned long, count - res, ROMBSIZE);
 		memcpy(dest, bh->b_data, maxsize);
@@ -410,8 +488,8 @@ out:	unlock_kernel();
 }

 /*
- * Ok, we do readpage, to be able to execute programs.  Unfortunately,
- * we can't use bmap, since we may have looser alignments.
+ * romfs version one readpage function. File data is unaligned
+ * to logical block, must manually copy to kmap'd page.
  */

 static int
@@ -457,12 +535,64 @@ err_out:
 	return result;
 }

+/*
+ * Retrieves the disk logical block given a block relative to a file.
+ * Conforms to include/linux/fs.h:get_block_t
+ */
+int rom2fs_get_block(struct inode *inode, sector_t iblock, struct
buffer_head *bh_result, int create)
+{
+	sector_t disk_block = iblock + ROMFS_I(inode)->i_dataoffset;
+	map_bh(bh_result, inode->i_sb, disk_block);
+	return 0;
+}
+
+
+static int
+rom2fs_readpage(struct file *file, struct page * page)
+{
+	return mpage_readpage(page, rom2fs_get_block);
+}
+
+static int
+rom2fs_readpages(struct file *file, struct address_space * addr_space,
+		 struct list_head *pages, unsigned nr_pages)
+{
+	return mpage_readpages(addr_space, pages, nr_pages, rom2fs_get_block);
+}
+
+static sector_t
+rom2fs_bmap(struct address_space *mapping, sector_t block)
+{
+	return generic_block_bmap(mapping, block, rom2fs_get_block);
+}
+
+static ssize_t
+rom2fs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
+			loff_t offset, unsigned long nr_segs)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+
+	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
+				  offset, nr_segs, rom2fs_get_block, NULL);
+}
+
 /* Mapping from our types to the kernel */

 static const struct address_space_operations romfs_aops = {
 	.readpage = romfs_readpage
 };

+
+/* Operations for rom2fs - make use of block aligned file data */
+
+static const struct address_space_operations rom2fs_aops = {
+	.readpage 	= rom2fs_readpage,
+	.readpages 	= rom2fs_readpages,
+	.bmap 		= rom2fs_bmap,
+	.direct_IO 	= rom2fs_direct_IO,
+};
+
 static const struct file_operations romfs_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= romfs_readdir,
@@ -508,21 +638,14 @@ romfs_read_inode(struct inode *i)
 	i->i_mtime.tv_nsec = i->i_atime.tv_nsec = i->i_ctime.tv_nsec = 0;
 	i->i_uid = i->i_gid = 0;

-        /* Precalculate the data offset */
-        ino = romfs_strnlen(i, ino+ROMFH_SIZE, ROMFS_MAXFN);
-        if (ino >= 0)
-                ino = ((ROMFH_SIZE+ino+1+ROMFH_PAD)&ROMFH_MASK);
-        else
-                ino = 0;
-
-        ROMFS_I(i)->i_metasize = ino;
-        ROMFS_I(i)->i_dataoffset = ino+(i->i_ino&ROMFH_MASK);
+	/* Precalculate the data offset */
+	romfs_fill_private_inode(i, ((nextfh & ROMFH_TYPE) == ROMFH_REG));

-        /* Compute permissions */
-        ino = romfs_modemap[nextfh & ROMFH_TYPE];
+	/* Compute permissions */
+	ino = romfs_modemap[nextfh & ROMFH_TYPE];
 	/* only "normal" files have ops */
 	switch (nextfh & ROMFH_TYPE) {
-		case 1:
+		case ROMFH_DIR:
 			i->i_size = ROMFS_I(i)->i_metasize;
 			i->i_op = &romfs_dir_inode_operations;
 			i->i_fop = &romfs_dir_operations;
@@ -530,14 +653,17 @@ romfs_read_inode(struct inode *i)
 				ino |= S_IXUGO;
 			i->i_mode = ino;
 			break;
-		case 2:
+		case ROMFH_REG:
 			i->i_fop = &generic_ro_fops;
-			i->i_data.a_ops = &romfs_aops;
+			if (get_romfs_priv(i->i_sb)->version == ROMFS_VERSION_1)
+				i->i_data.a_ops = &romfs_aops;
+			else
+				i->i_data.a_ops = &rom2fs_aops;
 			if (nextfh & ROMFH_EXEC)
 				ino |= S_IXUGO;
 			i->i_mode = ino;
 			break;
-		case 3:
+		case ROMFH_SYM:
 			i->i_op = &page_symlink_inode_operations;
 			i->i_data.a_ops = &romfs_aops;
 			i->i_mode = ino | S_IRWXUGO;
@@ -602,6 +728,7 @@ static const struct super_operations romfs_ops = {
 	.read_inode	= romfs_read_inode,
 	.statfs		= romfs_statfs,
 	.remount_fs	= romfs_remount,
+	.put_super	= romfs_put_super,
 };

 static int romfs_get_sb(struct file_system_type *fs_type,
@@ -624,7 +751,7 @@ static int __init init_romfs_fs(void)
 	int err = init_inodecache();
 	if (err)
 		goto out1;
-        err = register_filesystem(&romfs_fs_type);
+	err = register_filesystem(&romfs_fs_type);
 	if (err)
 		goto out;
 	return 0;
diff --git a/include/linux/romfs_fs.h b/include/linux/romfs_fs.h
index e20bbf9..ab7164b 100644
--- a/include/linux/romfs_fs.h
+++ b/include/linux/romfs_fs.h
@@ -15,6 +15,7 @@
 #define __mk4(a,b,c,d) cpu_to_be32(__mkl(__mkw(a,b),__mkw(c,d)))
 #define ROMSB_WORD0 __mk4('-','r','o','m')
 #define ROMSB_WORD1 __mk4('1','f','s','-')
+#define ROM2SB_WORD1 __mk4('2','f','s','-')

 /* On-disk "super block" */

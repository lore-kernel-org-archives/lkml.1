Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYHUFqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYHUFqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 01:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbYHUFpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 01:45:00 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:6219 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbYHUFo6 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 01:44:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=KbneJ5jB5cKf50LpRdPraA3L5/oK0HRzcTuN3AbBj9ckwPa/Oe6jjrEaYlnrVOlvXg
         8DDaO2vqwzK5OHZnyUsOektDnDGEojOATNeUsvzvLVfcszlejE0d359BXt+ZnL4UjUB6
         AqDLPkEtkJDWzST0RvxDnKm4vvWrHxQKiEMtk=
Message-ID: <48AD00E6.2070505@gmail.com>
Date: Wed, 20 Aug 2008 22:45:10 -0700
From: Jared Hulbert <jaredeh@gmail.com>
Reply-To: jaredeh@gmail.com
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: [PATCH 03/10] AXFS: axfs.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AXFS header.

Signed-off-by: Jared Hulbert <jaredeh@gmail.com>
---
diff --git a/include/linux/axfs.h b/include/linux/axfs.h
new file mode 100644
index 0000000..87af84a
--- /dev/null
+++ b/include/linux/axfs.h
@@ -0,0 +1,360 @@
+/*
+ * Advanced XIP File System for Linux - AXFS
+ *   Readonly, compressed, and XIP filesystem for Linux systems big and small
+ *
+ * Copyright(c) 2008 Numonyx
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * Authors:
+ *  Eric Anderson
+ *  Jared Hulbert <jaredeh@gmail.com>
+ *  Sujaya Srinivasan
+ *  Justin Treon
+ *
+ * Project url: http://axfs.sourceforge.net
+ */
+
+#ifndef __AXFS_H
+#define __AXFS_H
+
+
+#ifdef __KERNEL__
+#include <linux/rwsem.h>
+#endif
+#include <linux/errno.h>
+#include <linux/time.h>
+
+#define AXFS_MAGIC	0x48A0E4CD	/* some random number */
+#define AXFS_SIGNATURE	"Advanced XIP FS"
+#define AXFS_MAXPATHLEN 255
+
+/* Uncompression interfaces to the underlying zlib */
+int axfs_uncompress_block(void *, int, void *, int);
+int axfs_uncompress_init(void);
+int axfs_uncompress_exit(void);
+
+struct axfs_profiling_data {
+	u64 inode_number;
+	unsigned long count;
+};
+
+enum axfs_node_types {
+	XIP = 0,
+	Compressed,
+	Byte_Aligned,
+};
+
+enum axfs_compression_types {
+	ZLIB = 0
+};
+
+/*
+ *  on media struct describing a data region
+ */
+struct axfs_region_desc_onmedia {
+	u64 fsoffset;
+	u64 size;
+	u64 compressed_size;
+	u64 max_index;
+	u8 table_byte_depth;
+	u8 incore;
+};
+
+struct axfs_region_desc {
+	u64 fsoffset;
+	u64 size;
+	u64 compressed_size;
+	u64 max_index;
+	void *virt_addr;
+	u8 table_byte_depth;
+	u8 incore;
+};
+
+/*
+ * axfs_super is the on media format for the super block it must be big endian
+ */
+struct axfs_super_onmedia {
+	u32 magic;		/* 0x48A0E4CD - random number */
+	u8 signature[16];	/* "Advanced XIP FS" */
+	u8 digest[40];		/* sha1 digest for checking data integrity */
+	u32 cblock_size;	/* maximum size of the block being compressed */
+	u64 files;		/* number of inodes/files in fs */
+	u64 size;		/* total image size */
+	u64 blocks;		/* number of nodes in fs */
+	u64 mmap_size;		/* size of the memory mapped part of image */
+	u64 strings;		/* offset to strings region descriptor */
+	u64 xip;		/* offset to xip region descriptor */
+	u64 byte_aligned;	/* offset to the byte aligned region desc */
+	u64 compressed;		/* offset to the compressed region desc */
+	u64 node_type;		/* offset to node type region desc */
+	u64 node_index;		/* offset to node index region desc */
+	u64 cnode_offset;	/* offset to cnode offset region desc */
+	u64 cnode_index;	/* offset to cnode index region desc */
+	u64 banode_offset;	/* offset to banode offset region desc */
+	u64 cblock_offset;	/* offset to cblock offset region desc */
+	u64 inode_file_size;	/* offset to inode file size desc*/
+	u64 inode_name_offset;	/* offset to inode num_entries region desc */
+	u64 inode_num_entries;	/* offset to inode num_entries region desc */
+	u64 inode_mode_index;	/* offset to inode mode index region desc */
+	u64 inode_array_index;	/* offset to inode node index region desc */
+	u64 modes;		/* offset to mode mode region desc */
+	u64 uids;		/* offset to mode uid index region desc */
+	u64 gids;		/* offset to mode gid index region desc */
+	u8 version_major;
+	u8 version_minor;
+	u8 version_sub;
+	u8 compression_type;	/* Identifies type of compression used on FS */
+	u64 timestamp;		/* UNIX time_t of filesystem build time */
+};
+
+/*
+ * axfs super-block data in core
+ */
+struct axfs_super {
+	u32 magic;
+	u8 version_major;
+	u8 version_minor;
+	u8 version_sub;
+	u8 padding;
+	u64 files;
+	u64 size;
+	u64 blocks;
+	u64 mmap_size;
+	struct axfs_region_desc strings;
+	struct axfs_region_desc xip;
+	struct axfs_region_desc compressed;
+	struct axfs_region_desc byte_aligned;
+	struct axfs_region_desc node_type;
+	struct axfs_region_desc node_index;
+	struct axfs_region_desc cnode_offset;
+	struct axfs_region_desc cnode_index;
+	struct axfs_region_desc banode_offset;
+	struct axfs_region_desc cblock_offset;
+	struct axfs_region_desc inode_file_size;
+	struct axfs_region_desc inode_name_offset;
+	struct axfs_region_desc inode_num_entries;
+	struct axfs_region_desc inode_mode_index;
+	struct axfs_region_desc inode_array_index;
+	struct axfs_region_desc modes;
+	struct axfs_region_desc uids;
+	struct axfs_region_desc gids;
+	unsigned long phys_start_addr;
+	unsigned long virt_start_addr;
+	char *second_dev;
+	unsigned long iomem_size;
+	void *mtd0;		/* primary device */
+	void *mtd1;		/* secondary device */
+	u32 cblock_size;
+	u64 current_cnode_index;
+	void *cblock_buffer[2];
+	struct rw_semaphore lock;
+	struct axfs_profiling_data *profile_data_ptr;
+	u8 profiling_on;	/* Determines if profiling is on or off */
+	u8 mtd_pointed;
+	u8 compression_type;
+	struct timespec timestamp;
+};
+
+#define AXFS_PAGE_SIZE 4096
+
+#define AXFS_SB(sb) (struct axfs_super *)((sb)->s_fs_info)
+#define AXFS_MTD(sb) (void *)((sb)->s_mtd)
+#define AXFS_MTD0(sb) (((AXFS_SB(sb))->mtd0) ? \
+  ((AXFS_SB(sb))->mtd0) : (AXFS_MTD(sb)))
+#define AXFS_MTD1(sb) ((AXFS_SB(sb))->mtd1)
+
+#define AXFS_BDEV(sb) ((sb)->s_bdev)
+
+#define AXFS_HAS_BDEV(sb) \
+  ((AXFS_BDEV(sb) != NULL) ? TRUE : FALSE)
+#define AXFS_HAS_MTD(sb) \
+  (((AXFS_MTD0(sb) != NULL) || \
+    (AXFS_MTD1(sb) != NULL) || \
+    (AXFS_MTD(sb) != NULL)) ? TRUE : FALSE)
+
+#define AXFS_NODEV(sb) \
+  ((!AXFS_HAS_MTD(sb) && !AXFS_HAS_BDEV(sb)) ? TRUE : FALSE)
+
+static inline u64 axfs_bytetable_stitch(u8 depth, u8 *table, u64 index)
+{
+	u64 i;
+	u64 output = 0;
+	u64 byte = 0;
+	u64 j;
+	u64 bits;
+
+	for (i = 0; i < depth; i++) {
+		j = index * depth + i;
+		bits = 8 * (depth - i - 1);
+		byte = table[j];
+		output += byte << bits;
+	}
+	return output;
+}
+
+#define AXFS_GET_BYTETABLE_VAL(desc,index) \
+  axfs_bytetable_stitch(((struct axfs_region_desc)(desc)).table_byte_depth,\
+  (u8 *)((struct axfs_region_desc)(desc)).virt_addr, index)
+
+#define AXFS_GET_NODE_TYPE(sbi,node_index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->node_type,\
+   (node_index))
+
+#define AXFS_GET_NODE_INDEX(sbi,node__index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->node_index,\
+   (node__index))
+
+#define AXFS_IS_NODE_XIP(sbi,node_index) \
+  (AXFS_GET_NODE_TYPE(sbi, (node_index)) == XIP)
+
+#define AXFS_GET_CNODE_INDEX(sbi,node_index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->cnode_index,\
+   (node_index))
+
+#define AXFS_GET_CNODE_OFFSET(desc,node_index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->cnode_offset,\
+   (node_index))
+
+#define AXFS_GET_BANODE_OFFSET(desc,node_index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->banode_offset,\
+   (node_index))
+
+#define AXFS_GET_CBLOCK_OFFSET(desc,node_index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->cblock_offset,\
+   (node_index))
+
+#define AXFS_GET_INODE_FILE_SIZE(sbi,inode_index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->inode_file_size,\
+   (inode_index))
+
+#define AXFS_GET_INODE_NAME_OFFSET(sbi,inode_index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->inode_name_offset,\
+	(inode_index))
+
+#define AXFS_GET_INODE_NUM_ENTRIES(sbi,inode_index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->inode_num_entries,\
+	(inode_index))
+
+#define AXFS_GET_INODE_MODE_INDEX(sbi,inode_index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->inode_mode_index,\
+   (inode_index))
+
+#define AXFS_GET_INODE_ARRAY_INDEX(sbi,inode_index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->inode_array_index,\
+   (inode_index))
+
+#define AXFS_GET_MODE(sbi,mode_index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->modes,\
+  (AXFS_GET_INODE_MODE_INDEX(sbi, (mode_index))))
+
+#define AXFS_GET_UID(sbi,mode_index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->uids,\
+  (AXFS_GET_INODE_MODE_INDEX(sbi, (mode_index))))
+
+#define AXFS_GET_GID(sbi,mode_index) \
+  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->gids,\
+  (AXFS_GET_INODE_MODE_INDEX(sbi, (mode_index))))
+
+#define AXFS_IS_REGION_COMPRESSED(_region) \
+    (( \
+     ((struct axfs_region_desc *)(_region))->compressed_size > \
+     0 \
+    ) ? TRUE : FALSE)
+
+#define AXFS_PHYSADDR_IS_VALID(sbi) \
+    (((((struct axfs_super *)(sbi))->phys_start_addr) > 0 \
+	) ? TRUE : FALSE)
+
+#define AXFS_VIRTADDR_IS_VALID(sbi) \
+    (((((struct axfs_super *)(sbi))->virt_start_addr) > 0 \
+	) ? TRUE : FALSE)
+
+#define AXFS_IS_IOMEM(sbi) \
+    (((((struct axfs_super *)(sbi))->iomem_size) > 0) ? TRUE : FALSE)
+
+#define AXFS_IS_POINTED(sbi) \
+    (((((struct axfs_super *)(sbi))->mtd_pointed) > 0) ? TRUE : FALSE)
+
+#define AXFS_IS_PHYSMEM(sbi) \
+    (( \
+      AXFS_PHYSADDR_IS_VALID(sbi) \
+      && !AXFS_IS_IOMEM(sbi) \
+      && !AXFS_IS_POINTED(sbi) \
+    ) ? TRUE : FALSE)
+
+#define AXFS_IS_MMAPABLE(sbi,offset) \
+    ((\
+       (((struct axfs_super *)(sbi))->mmap_size) > (offset) \
+    ) ? TRUE : FALSE)
+
+#define AXFS_IS_OFFSET_MMAPABLE(sbi,offset) \
+    (( \
+       AXFS_IS_MMAPABLE(sbi, offset) && AXFS_VIRTADDR_IS_VALID(sbi) \
+     ) ? TRUE : FALSE)
+
+#define AXFS_IS_REGION_MMAPABLE(sbi,_region) \
+    (( \
+      AXFS_IS_MMAPABLE(sbi, ((struct axfs_region_desc *)(_region))->fsoffset) \
+      && AXFS_VIRTADDR_IS_VALID(sbi) \
+     ) ? TRUE : FALSE)
+
+#define AXFS_IS_REGION_INCORE(_region) \
+    (((_region)->incore > 0) ? TRUE : FALSE)
+
+#define AXFS_IS_REGION_XIP(sbi,_region) \
+    (( \
+     !AXFS_IS_REGION_COMPRESSED(_region) && \
+     !AXFS_IS_REGION_INCORE(_region) && \
+     AXFS_IS_REGION_MMAPABLE(sbi,_region) \
+    ) ? TRUE : FALSE)
+
+#define AXFS_GET_XIP_REGION_PHYSADDR(sbi) \
+    (unsigned long)((sbi)->phys_start_addr + (sbi)->xip.fsoffset)
+
+#define AXFS_GET_INODE_NAME(sbi,inode_index) \
+     (char *)( \
+	(sbi)->strings.virt_addr \
+	+ AXFS_GET_INODE_NAME_OFFSET(sbi,inode_index) \
+     )
+
+#define AXFS_GET_CBLOCK_ADDRESS(sbi, cnode_index)\
+    (unsigned long)( \
+       (sbi)->compressed.virt_addr \
+       + AXFS_GET_CBLOCK_OFFSET(sbi, cnode_index) \
+    )
+
+#define AXFS_GET_NODE_ADDRESS(sbi,node__index) \
+    (unsigned long)( \
+       (sbi)->node_index.virt_addr \
+       + AXFS_GET_NODE_INDEX(sbi, node__index) \
+    )
+
+#define AXFS_GET_BANODE_ADDRESS(sbi,banode_index) \
+    (unsigned long)( \
+       (sbi)->byte_aligned.virt_addr \
+       + AXFS_GET_BANODE_OFFSET(sbi, banode_index) \
+    )
+
+#define AXFS_FSOFFSET_2_DEVOFFSET(sbi,fsoffset) \
+    (( \
+      ((sbi)->phys_start_addr == 0) && ((sbi)->virt_start_addr == 0) \
+      ) ? (fsoffset) : (fsoffset - (sbi)->mmap_size) \
+    )
+
+#define AXFS_GET_CBLOCK_LENGTH(sbi,cblock_index) \
+    (u64)( \
+      (u64)AXFS_GET_CBLOCK_OFFSET(sbi, ((u64)(cblock_index)+(u64)1)) \
+      - (u64)AXFS_GET_CBLOCK_OFFSET(sbi, (cblock_index)) \
+    )
+
+#ifndef TRUE
+#define TRUE 1
+#endif
+#ifndef FALSE
+#define FALSE 0
+#endif
+
+#endif



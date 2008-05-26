Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbYEZM3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbYEZM3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbYEZMYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:24:21 -0400
Received: from smtp.nokia.com ([192.100.122.230]:57061 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbYEZMYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:24:05 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH take 3 27/29] UBIFS: add header files
Date: Mon, 26 May 2008 17:05:41 +0300
Message-Id: <1211810743-18936-28-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 May 2008 12:23:59.0729 (UTC) FILETIME=[60205610:01C8BF2B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ubifs.h contains the internal stuff. ubifs-media.h contains the
on-flash format definition and might be copied to user-space
if needed. misc.h contains various inline helpers.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/misc.h        |  310 ++++++++++
 fs/ubifs/ubifs-media.h |  725 ++++++++++++++++++++++
 fs/ubifs/ubifs.h       | 1576 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 2611 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/misc.h b/fs/ubifs/misc.h
new file mode 100644
index 0000000..ad0b495
--- /dev/null
+++ b/fs/ubifs/misc.h
@@ -0,0 +1,310 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Artem Bityutskiy (Битюцкий Артём)
+ *          Adrian Hunter
+ */
+
+/*
+ * This file contains miscellaneous helper functions.
+ */
+
+#ifndef __UBIFS_MISC_H__
+#define __UBIFS_MISC_H__
+
+/**
+ * ubifs_zn_dirty - check if znode is dirty.
+ * @znode: znode to check
+ *
+ * This helper function returns %1 if @znode is dirty and %0 otherwise.
+ */
+static inline int ubifs_zn_dirty(const struct ubifs_znode *znode)
+{
+	return !!test_bit(DIRTY_ZNODE, &znode->flags);
+}
+
+/**
+ * ubifs_wake_up_bgt - wake up background thread.
+ * @c: UBIFS file-system description object
+ */
+static inline void ubifs_wake_up_bgt(struct ubifs_info *c)
+{
+	if (c->bgt && !c->need_bgt) {
+		c->need_bgt = 1;
+		wake_up_process(c->bgt);
+	}
+}
+
+/**
+ * ubifs_tnc_find_child - find next child in znode.
+ * @znode: znode to search at
+ * @start: the zbranch index to start at
+ *
+ * This helper function looks for znode child starting at index @start. Returns
+ * the child or %NULL if no children were found.
+ */
+static inline struct ubifs_znode *
+ubifs_tnc_find_child(struct ubifs_znode *znode, int start)
+{
+	while (start < znode->child_cnt) {
+		if (znode->zbranch[start].znode)
+			return znode->zbranch[start].znode;
+		start += 1;
+	}
+
+	return NULL;
+}
+
+/**
+ * ubifs_inode - get UBIFS inode information by VFS 'struct inode' object.
+ * @inode: the VFS 'struct inode' pointer
+ */
+static inline struct ubifs_inode *ubifs_inode(const struct inode *inode)
+{
+	return container_of(inode, struct ubifs_inode, vfs_inode);
+}
+
+/**
+ * ubifs_ro_mode - switch UBIFS to read read-only mode.
+ * @c: UBIFS file-system description object
+ * @err: error code which is the reason of switching to R/O mode
+ */
+static inline void ubifs_ro_mode(struct ubifs_info *c, int err)
+{
+	if (!c->ro_media) {
+		c->ro_media = 1;
+		ubifs_warn("switched to read-only mode, error %d", err);
+		dbg_dump_stack();
+	}
+}
+
+/**
+ * ubifs_compr_present - check if compressor was compiled in.
+ * @compr_type: compressor type to check
+ *
+ * This function returns %1 of compressor of type @compr_type is present, and
+ * %0 if not.
+ */
+static inline int ubifs_compr_present(int compr_type)
+{
+	ubifs_assert(compr_type >= 0 && compr_type < UBIFS_COMPR_TYPES_CNT);
+	return !!ubifs_compressors[compr_type]->capi_name;
+}
+
+/**
+ * ubifs_compr_name - get compressor name string by its type.
+ * @compr_type: compressor type
+ *
+ * This function returns compressor type string.
+ */
+static inline const char *ubifs_compr_name(int compr_type)
+{
+	ubifs_assert(compr_type >= 0 && compr_type < UBIFS_COMPR_TYPES_CNT);
+	return ubifs_compressors[compr_type]->name;
+}
+
+/**
+ * ubifs_wbuf_sync - synchronize write-buffer.
+ * @wbuf: write-buffer to synchronize
+ *
+ * This is the same as as 'ubifs_wbuf_sync_nolock()' but it does not assume
+ * that the write-buffer is already locked.
+ */
+static inline int ubifs_wbuf_sync(struct ubifs_wbuf *wbuf)
+{
+	int err;
+
+	mutex_lock_nested(&wbuf->io_mutex, wbuf->jhead);
+	err = ubifs_wbuf_sync_nolock(wbuf);
+	mutex_unlock(&wbuf->io_mutex);
+	return err;
+}
+
+/**
+ * ubifs_leb_unmap - unmap an LEB.
+ * @c: UBIFS file-system description object
+ * @lnum: LEB number to unmap
+ *
+ * This function returns %0 on success and a negative error code on failure.
+ */
+static inline int ubifs_leb_unmap(const struct ubifs_info *c, int lnum)
+{
+	int err;
+
+	err = ubi_leb_unmap(c->ubi, lnum);
+	if (err) {
+		ubifs_err("unmap LEB %d failed, error %d", lnum, err);
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * ubifs_leb_write - write to a LEB.
+ * @c: UBIFS file-system description object
+ * @lnum: LEB number to write
+ * @buf: buffer to write from
+ * @offs: offset within LEB to write to
+ * @len: length to write
+ * @dtype: data type
+ *
+ * This function returns %0 on success and a negative error code on failure.
+ */
+static inline int ubifs_leb_write(const struct ubifs_info *c, int lnum,
+				  const void *buf, int offs, int len, int dtype)
+{
+	int err;
+
+	err = ubi_leb_write(c->ubi, lnum, buf, offs, len, dtype);
+	if (err) {
+		ubifs_err("writing %d bytes at %d:%d, error %d",
+			  len, lnum, offs, err);
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * ubifs_encode_dev - encode device node IDs.
+ * @dev: UBIFS device node information
+ * @rdev: device IDs to encode
+ *
+ * This is a helper function which encodes major/minor numbers of a device node
+ * into UBIFS device node description. We use standard Linux "new" and "huge"
+ * encodings.
+ */
+static inline int ubifs_encode_dev(union ubifs_dev_desc *dev, dev_t rdev)
+{
+	if (new_valid_dev(rdev)) {
+		dev->new = cpu_to_le32(new_encode_dev(rdev));
+		return sizeof(dev->new);
+	} else {
+		dev->huge = cpu_to_le64(huge_encode_dev(rdev));
+		return sizeof(dev->huge);
+	}
+}
+
+/**
+ * ubifs_add_dirt - add dirty space to LEB properties.
+ * @c: the UBIFS file-system description object
+ * @lnum: LEB to add dirty space for
+ * @dirty: dirty space to add
+ *
+ * This is a helper function which increased amount of dirty LEB space. Returns
+ * zero in case of success and a negative error code in case of failure.
+ */
+static inline int ubifs_add_dirt(struct ubifs_info *c, int lnum, int dirty)
+{
+	return ubifs_update_one_lp(c, lnum, -1, dirty, 0, 0);
+}
+
+/**
+ * ubifs_return_leb - return LEB to lprops.
+ * @c: the UBIFS file-system description object
+ * @lnum: LEB to return
+ *
+ * This helper function cleans the "taken" flag of a logical eraseblock in the
+ * lprops. Returns zero in case of success and a negative error code in case of
+ * failure.
+ */
+static inline int ubifs_return_leb(struct ubifs_info *c, int lnum)
+{
+	return ubifs_change_one_lp(c, lnum, -1, -1, 0, LPROPS_TAKEN, 0);
+}
+
+/**
+ * ubifs_idx_node_sz - return index node size.
+ * @c: the UBIFS file-system description object
+ * @child_cnt: number of children of this index node
+ */
+static inline int ubifs_idx_node_sz(const struct ubifs_info *c, int child_cnt)
+{
+	return UBIFS_IDX_NODE_SZ + (UBIFS_BRANCH_SZ + c->key_len) * child_cnt;
+}
+
+/**
+ * ubifs_idx_branch - return pointer to an index branch.
+ * @c: the UBIFS file-system description object
+ * @idx: index node
+ * @bnum: branch number
+ */
+static inline
+struct ubifs_branch *ubifs_idx_branch(const struct ubifs_info *c,
+				      const struct ubifs_idx_node *idx,
+				      int bnum)
+{
+	return (struct ubifs_branch *)((void *)idx->branches +
+				       (UBIFS_BRANCH_SZ + c->key_len) * bnum);
+}
+
+/**
+ * ubifs_idx_key - return pointer to an index key.
+ * @c: the UBIFS file-system description object
+ * @idx: index node
+ */
+static inline void *ubifs_idx_key(const struct ubifs_info *c,
+				  const struct ubifs_idx_node *idx)
+{
+	return (void *)((struct ubifs_branch *)idx->branches)->key;
+}
+
+/**
+ * ubifs_reported_space - calculate reported free space.
+ * @c: the UBIFS file-system description object
+ * @free: amount of free space
+ *
+ * This function calculates amount of free space which will be reported to
+ * user-space. User-space application tend to expect that if the file-system
+ * (e.g., via the 'statfs()' call) reports that it has N bytes available, they
+ * are able to write a file of size N. UBIFS attaches node headers to each data
+ * node and it has to write indexind nodes as well. This introduces additional
+ * overhead, and UBIFS it has to report sligtly less free space to meet the
+ * above expectetion.
+ *
+ * This function assumes free space is made up of uncompressed data nodes and
+ * full index nodes (one per data node, doubled because we always allow enough
+ * space to write the index twice).
+ *
+ * Note, the calculation is pessimistic, which means that most of the time
+ * UBIFS reports less space than it actually has.
+ */
+static inline long long ubifs_reported_space(const struct ubifs_info *c,
+					     uint64_t free)
+{
+	int divisor, factor;
+
+	divisor = UBIFS_MAX_DATA_NODE_SZ + (c->max_idx_node_sz << 1);
+	factor = UBIFS_MAX_DATA_NODE_SZ - UBIFS_DATA_NODE_SZ;
+	do_div(free, divisor);
+
+	return free * factor;
+}
+
+/**
+ * ubifs_current_time - round current time to time granularity.
+ * @inode: inode
+ */
+static inline struct timespec ubifs_current_time(struct inode *inode)
+{
+	return (inode->i_sb->s_time_gran < NSEC_PER_SEC) ?
+		current_fs_time(inode->i_sb) : CURRENT_TIME_SEC;
+}
+
+#endif /* __UBIFS_MISC_H__ */
diff --git a/fs/ubifs/ubifs-media.h b/fs/ubifs/ubifs-media.h
new file mode 100644
index 0000000..ff7680a
--- /dev/null
+++ b/fs/ubifs/ubifs-media.h
@@ -0,0 +1,725 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Artem Bityutskiy (Битюцкий Артём)
+ *          Adrian Hunter
+ */
+
+/*
+ * This file describes UBIFS on-flash format and contains definitions of all the
+ * relevant data structures and constants.
+ *
+ * All UBIFS on-flash objects are stored in the form of nodes. All nodes start
+ * with the UBIFS node magic number and have the same common header. Nodes
+ * always sit at 8-byte aligned positions on the media and node header sizes are
+ * also 8-byte aligned (except for the indexing node and the padding node).
+ */
+
+#ifndef __UBIFS_MEDIA_H__
+#define __UBIFS_MEDIA_H__
+
+/* UBIFS node magic number (must not have the padding byte first or last) */
+#define UBIFS_NODE_MAGIC  0x06101831
+
+/* UBIFS on-flash format version */
+#define UBIFS_FORMAT_VERSION 2
+
+/* Minimum logical eraseblock size in bytes */
+#define UBIFS_MIN_LEB_SZ (15*1024)
+
+/* Initial CRC32 value used when calculating CRC checksums */
+#define UBIFS_CRC32_INIT 0xFFFFFFFFU
+
+/*
+ * UBIFS does not try to compress data if its length is less than the below
+ * constant.
+ */
+#define UBIFS_MIN_COMPR_LEN 128
+
+/* Root inode number */
+#define UBIFS_ROOT_INO 1
+
+/* Lowest inode number used for regular inodes (not UBIFS-only internal ones) */
+#define UBIFS_FIRST_INO 64
+
+/*
+ * Maximum file name and extended attribute length (must be a multiple of 8,
+ * minus 1).
+ */
+#define UBIFS_MAX_NLEN 255
+
+/* Maximum number of data journal heads */
+#define UBIFS_MAX_JHEADS 1
+
+/*
+ * Size of UBIFS data block. Note, UBIFS is not a block oriented file-system,
+ * which means that it does not treat the underlying media as consisting of
+ * blocks like in case of hard drives. Do not be confused. UBIFS block is just
+ * the maximum amount of data which one data node can have or which can be
+ * attached to an inode node.
+ */
+#define UBIFS_BLOCK_SIZE  4096
+#define UBIFS_BLOCK_SHIFT 12
+#define UBIFS_BLOCK_MASK  0x00000FFF
+
+/* UBIFS padding byte pattern (must not be first or last byte of node magic) */
+#define UBIFS_PADDING_BYTE 0xCE
+
+/* Maximum possible key length */
+#define UBIFS_MAX_KEY_LEN 16
+
+/* Key length ("simple" format) */
+#define UBIFS_SK_LEN 8
+
+/* Minimum index tree fanout */
+#define UBIFS_MIN_FANOUT 2
+
+/* Maximum number of levels in UBIFS indexing B-tree */
+#define UBIFS_MAX_LEVELS 512
+
+/* Maximum amount of data attached to an inode in bytes */
+#define UBIFS_MAX_INO_DATA UBIFS_BLOCK_SIZE
+
+/* LEB Properties Tree fanout (must be power of 2) and fanout shift */
+#define UBIFS_LPT_FANOUT 4
+#define UBIFS_LPT_FANOUT_SHIFT 2
+
+/* LEB Properties Tree bit field sizes */
+#define UBIFS_LPT_CRC_BITS 16
+#define UBIFS_LPT_CRC_BYTES 2
+#define UBIFS_LPT_TYPE_BITS 4
+
+/* The key is always at the same position in all keyed nodes */
+#define UBIFS_KEY_OFFSET offsetof(struct ubifs_ino_node, key)
+
+/*
+ * LEB Properties Tree node types.
+ *
+ * UBIFS_LPT_PNODE: LPT leaf node (contains LEB properties)
+ * UBIFS_LPT_NNODE: LPT internal node
+ * UBIFS_LPT_LTAB: LPT's own lprops table
+ * UBIFS_LPT_LSAVE: LPT's save table (big model only)
+ * UBIFS_LPT_NODE_CNT: count of LPT node types
+ * UBIFS_LPT_NOT_A_NODE: all ones (15 for 4 bits) is never a valid node type
+ */
+enum {
+	UBIFS_LPT_PNODE,
+	UBIFS_LPT_NNODE,
+	UBIFS_LPT_LTAB,
+	UBIFS_LPT_LSAVE,
+	UBIFS_LPT_NODE_CNT,
+	UBIFS_LPT_NOT_A_NODE = (1 << UBIFS_LPT_TYPE_BITS) - 1,
+};
+
+/*
+ * UBIFS inode types.
+ *
+ * UBIFS_ITYPE_REG: regular file
+ * UBIFS_ITYPE_DIR: directory
+ * UBIFS_ITYPE_LNK: soft link
+ * UBIFS_ITYPE_BLK: block device node
+ * UBIFS_ITYPE_CHR: character device node
+ * UBIFS_ITYPE_FIFO: fifo
+ * UBIFS_ITYPE_SOCK: socket
+ * UBIFS_ITYPES_CNT: count of supported file types
+ */
+enum {
+	UBIFS_ITYPE_REG,
+	UBIFS_ITYPE_DIR,
+	UBIFS_ITYPE_LNK,
+	UBIFS_ITYPE_BLK,
+	UBIFS_ITYPE_CHR,
+	UBIFS_ITYPE_FIFO,
+	UBIFS_ITYPE_SOCK,
+	UBIFS_ITYPES_CNT,
+};
+
+/*
+ * Supported key hash functions.
+ *
+ * UBIFS_KEY_HASH_R5: R5 hash
+ * UBIFS_KEY_HASH_TEST: test hash which just returns first 4 bytes of the name
+ */
+enum {
+	UBIFS_KEY_HASH_R5,
+	UBIFS_KEY_HASH_TEST,
+};
+
+/*
+ * Supported key formats.
+ *
+ * UBIFS_SIMPLE_KEY_FMT: simple key format
+ */
+enum {
+	UBIFS_SIMPLE_KEY_FMT,
+};
+
+/*
+ * The simple key format uses 29 bits for storing UBIFS block number and hash
+ * value.
+ */
+#define UBIFS_S_KEY_BLOCK_BITS 29
+#define UBIFS_S_KEY_BLOCK_MASK 0x01FFFFFF
+#define UBIFS_S_KEY_HASH_BITS  UBIFS_S_KEY_BLOCK_BITS
+#define UBIFS_S_KEY_HASH_MASK  UBIFS_S_KEY_BLOCK_MASK
+
+/*
+ * Key types.
+ *
+ * UBIFS_INO_KEY: inode node key
+ * UBIFS_DATA_KEY: data node key
+ * UBIFS_DENT_KEY: directory entry node key
+ * UBIFS_XENT_KEY: extended attribute entry key
+ * UBIFS_TRUN_KEY: truncation node key
+ * UBIFS_KEY_TYPES_CNT: number of supported key types
+ */
+enum {
+	UBIFS_INO_KEY,
+	UBIFS_DATA_KEY,
+	UBIFS_DENT_KEY,
+	UBIFS_XENT_KEY,
+	UBIFS_TRUN_KEY,
+	UBIFS_KEY_TYPES_CNT,
+};
+
+/* Count of LEBs reserved for the superblock area */
+#define UBIFS_SB_LEBS 1
+/* Count of LEBs reserved for the master area */
+#define UBIFS_MST_LEBS 2
+
+/* First LEB of the superblock area */
+#define UBIFS_SB_LNUM 0
+/* First LEB of the master area */
+#define UBIFS_MST_LNUM (UBIFS_SB_LNUM + UBIFS_SB_LEBS)
+/* First LEB of the log area */
+#define UBIFS_LOG_LNUM (UBIFS_MST_LNUM + UBIFS_MST_LEBS)
+
+/* Minimum number of logical eraseblocks in the log */
+#define UBIFS_MIN_LOG_LEBS 2
+/* Minimum number of bud logical eraseblocks */
+#define UBIFS_MIN_BUD_LEBS 2
+/* Minimum number of journal logical eraseblocks */
+#define UBIFS_MIN_JNL_LEBS (UBIFS_MIN_LOG_LEBS + UBIFS_MIN_BUD_LEBS)
+/* Minimum number of LPT area logical eraseblocks */
+#define UBIFS_MIN_LPT_LEBS 2
+/* Minimum number of orphan area logical eraseblocks */
+#define UBIFS_MIN_ORPH_LEBS 1
+/* Minimum number of main area logical eraseblocks */
+#define UBIFS_MIN_MAIN_LEBS 8
+
+/* Minimum number of logical eraseblocks */
+#define UBIFS_MIN_LEB_CNT (UBIFS_SB_LEBS + UBIFS_MST_LEBS + \
+			   UBIFS_MIN_LOG_LEBS + UBIFS_MIN_BUD_LEBS  + \
+			   UBIFS_MIN_LPT_LEBS + UBIFS_MIN_ORPH_LEBS + \
+			   UBIFS_MIN_MAIN_LEBS)
+
+/* Node sizes (N.B. these are guaranteed to be multiples of 8) */
+#define UBIFS_CH_SZ        sizeof(struct ubifs_ch)
+#define UBIFS_INO_NODE_SZ  sizeof(struct ubifs_ino_node)
+#define UBIFS_DATA_NODE_SZ sizeof(struct ubifs_data_node)
+#define UBIFS_DENT_NODE_SZ sizeof(struct ubifs_dent_node)
+#define UBIFS_TRUN_NODE_SZ sizeof(struct ubifs_trun_node)
+#define UBIFS_PAD_NODE_SZ  sizeof(struct ubifs_pad_node)
+#define UBIFS_SB_NODE_SZ   sizeof(struct ubifs_sb_node)
+#define UBIFS_MST_NODE_SZ  sizeof(struct ubifs_mst_node)
+#define UBIFS_REF_NODE_SZ  sizeof(struct ubifs_ref_node)
+#define UBIFS_IDX_NODE_SZ  sizeof(struct ubifs_idx_node)
+#define UBIFS_CS_NODE_SZ   sizeof(struct ubifs_cs_node)
+#define UBIFS_ORPH_NODE_SZ sizeof(struct ubifs_orph_node)
+/* Extended attribute entry nodes are identical to directory entry nodes */
+#define UBIFS_XENT_NODE_SZ UBIFS_DENT_NODE_SZ
+/* Only this does not have to be multiple of 8 bytes */
+#define UBIFS_BRANCH_SZ    sizeof(struct ubifs_branch)
+
+/* Maximum node sizes (N.B. these are guaranteed to be multiples of 8) */
+#define UBIFS_MAX_DATA_NODE_SZ  (UBIFS_DATA_NODE_SZ + UBIFS_BLOCK_SIZE)
+#define UBIFS_MAX_INO_NODE_SZ   (UBIFS_INO_NODE_SZ + UBIFS_MAX_INO_DATA)
+#define UBIFS_MAX_DENT_NODE_SZ  (UBIFS_DENT_NODE_SZ + UBIFS_MAX_NLEN + 1)
+#define UBIFS_MAX_XENT_NODE_SZ  UBIFS_MAX_DENT_NODE_SZ
+
+/* The largest UBIFS node */
+#define UBIFS_MAX_NODE_SZ UBIFS_MAX_INO_NODE_SZ
+
+/*
+ * On-flash inode flags.
+ *
+ * UBIFS_COMPR_FL: use compression for this inode
+ * UBIFS_SYNC_FL:  I/O on this inode has to be synchronous
+ * UBIFS_IMMUTABLE_FL: inode is immutable
+ * UBIFS_APPEND_FL: writes to the inode may only append data
+ * UBIFS_DIRSYNC_FL: I/O on this directory inode has to be synchronous
+ *
+ * Note, these are on-flash flags which correspond to ioctl flags
+ * (@FS_COMPR_FL, etc). They have the same values now, but generally, do not
+ * have to be the same.
+ */
+enum {
+	UBIFS_COMPR_FL     = 0x01,
+	UBIFS_SYNC_FL      = 0x02,
+	UBIFS_IMMUTABLE_FL = 0x04,
+	UBIFS_APPEND_FL    = 0x08,
+	UBIFS_DIRSYNC_FL   = 0x10,
+};
+
+/* Inode flag bits used by UBIFS */
+#define UBIFS_FL_MASK 0x0000001F
+
+/*
+ * UBIFS compression algorithms.
+ *
+ * UBIFS_COMPR_NONE: no compression
+ * UBIFS_COMPR_LZO: LZO compression
+ * UBIFS_COMPR_ZLIB: ZLIB compression
+ * UBIFS_COMPR_TYPES_CNT: count of supported compression types
+ */
+enum {
+	UBIFS_COMPR_NONE,
+	UBIFS_COMPR_LZO,
+	UBIFS_COMPR_ZLIB,
+	UBIFS_COMPR_TYPES_CNT,
+};
+
+/*
+ * UBIFS node types.
+ *
+ * UBIFS_INO_NODE: inode node
+ * UBIFS_DATA_NODE: data node
+ * UBIFS_DENT_NODE: directory entry node
+ * UBIFS_XENT_NODE: extended attribute node
+ * UBIFS_TRUN_NODE: truncation node
+ * UBIFS_PAD_NODE: padding node
+ * UBIFS_SB_NODE: superblock node
+ * UBIFS_MST_NODE: master node
+ * UBIFS_REF_NODE: LEB reference node
+ * UBIFS_IDX_NODE: index node
+ * UBIFS_CS_NODE: commit start node
+ * UBIFS_ORPH_NODE: orphan node
+ * UBIFS_NODE_TYPES_CNT: count of supported node types
+ *
+ * Note, we index arrays by these numbers, so keep them low and contiguous.
+ * Node type constants for inodes, direntries and so on have to be the same as
+ * corresponding key type constants.
+ */
+enum {
+	UBIFS_INO_NODE,
+	UBIFS_DATA_NODE,
+	UBIFS_DENT_NODE,
+	UBIFS_XENT_NODE,
+	UBIFS_TRUN_NODE,
+	UBIFS_PAD_NODE,
+	UBIFS_SB_NODE,
+	UBIFS_MST_NODE,
+	UBIFS_REF_NODE,
+	UBIFS_IDX_NODE,
+	UBIFS_CS_NODE,
+	UBIFS_ORPH_NODE,
+	UBIFS_NODE_TYPES_CNT,
+};
+
+/*
+ * Master node flags.
+ *
+ * UBIFS_MST_DIRTY: rebooted uncleanly - master node is dirty
+ * UBIFS_MST_NO_ORPHS: no orphan inodes present
+ * UBIFS_MST_RCVRY: written by recovery
+ */
+enum {
+	UBIFS_MST_DIRTY = 1,
+	UBIFS_MST_NO_ORPHS = 2,
+	UBIFS_MST_RCVRY = 4,
+};
+
+/*
+ * Node group type (used by recovery to recover whole group or none).
+ *
+ * UBIFS_NO_NODE_GROUP: this node is not part of a group
+ * UBIFS_IN_NODE_GROUP: this node is a part of a group
+ * UBIFS_LAST_OF_NODE_GROUP: this node is the last in a group
+ */
+enum {
+	UBIFS_NO_NODE_GROUP = 0,
+	UBIFS_IN_NODE_GROUP,
+	UBIFS_LAST_OF_NODE_GROUP,
+};
+
+/*
+ * Superblock flags.
+ *
+ * UBIFS_FLG_BIGLPT: if "big" LPT model is used if set
+ */
+enum {
+	UBIFS_FLG_BIGLPT = 0x02,
+};
+
+/**
+ * struct ubifs_ch - common header node.
+ * @magic: UBIFS node magic number (%UBIFS_NODE_MAGIC)
+ * @crc: CRC-32 checksum of the node header
+ * @sqnum: sequence number
+ * @len: full node length
+ * @node_type: node type
+ * @group_type: node group type
+ * @padding: reserved for future, zeroes
+ *
+ * Every UBIFS node starts with this common part. If the node has a key, the
+ * key always goes next.
+ */
+struct ubifs_ch {
+	__le32 magic;
+	__le32 crc;
+	__le64 sqnum;
+	__le32 len;
+	__u8 node_type;
+	__u8 group_type;
+	__u8 padding[2];
+} __attribute__ ((packed));
+
+/**
+ * union ubifs_dev_desc - device node descriptor.
+ * @new: new type device descriptor
+ * @huge: huge type device descriptor
+ *
+ * This data structure describes major/minor numbers of a device node. In an
+ * inode is a device node then its data contains an object of this type. UBIFS
+ * uses standard Linux "new" and "huge" device node encodings.
+ */
+union ubifs_dev_desc {
+	__le32 new;
+	__le64 huge;
+} __attribute__ ((packed));
+
+/**
+ * struct ubifs_ino_node - inode node.
+ * @ch: common header
+ * @key: node key
+ * @creat_sqnum: sequence number at time of creation
+ * @size: inode size in bytes (amount of uncompressed data)
+ * @atime_sec: access time seconds
+ * @ctime_sec: creation time seconds
+ * @mtime_sec: modification time seconds
+ * @atime_nsec: access time nanoseconds
+ * @ctime_nsec: creation time nanoseconds
+ * @mtime_nsec: modification time nanoseconds
+ * @nlink: number of hard links
+ * @uid: owner ID
+ * @gid: group ID
+ * @mode: access flags
+ * @flags: per-inode flags (%UBIFS_COMPR_FL, %UBIFS_SYNC_FL, etc)
+ * @data_len: inode data length
+ * @xattr_cnt: count of extended attributes this inode has
+ * @xattr_size: summarized size of all extended attributes in bytes
+ * @xattr_names: sum of lengths of all extended attribute names belonging to
+ *               this inode
+ * @compr_type: compression type used for this inode
+ * @padding: reserved for future, zeroes
+ * @data: data attached to the inode
+ *
+ * Note, even though inode compression type is defined by @compr_type, some
+ * nodes of this inode may be compressed with different compressor - this
+ * happens if compression type is changed while the inode already has data
+ * nodes. But @compr_type will be use for further writes to the inode.
+ *
+ * Note, do not forget to amend 'zero_ino_node_unused()' function when changing
+ * the padding fields.
+ */
+struct ubifs_ino_node {
+	struct ubifs_ch ch;
+	__u8 key[UBIFS_MAX_KEY_LEN];
+	__le64 creat_sqnum;
+	__le64 size;
+	__le64 atime_sec;
+	__le64 ctime_sec;
+	__le64 mtime_sec;
+	__le32 atime_nsec;
+	__le32 ctime_nsec;
+	__le32 mtime_nsec;
+	__le32 nlink;
+	__le32 uid;
+	__le32 gid;
+	__le32 mode;
+	__le32 flags;
+	__le32 data_len;
+	__le32 xattr_cnt;
+	__le64 xattr_size;
+	__le32 xattr_names;
+	__le16 compr_type;
+	__u8 padding[26]; /* Watch 'zero_ino_node_unused()' if changing! */
+	__u8 data[];
+} __attribute__ ((packed));
+
+/**
+ * struct ubifs_dent_node - directory entry node.
+ * @ch: common header
+ * @key: node key
+ * @inum: target inode number
+ * @padding1: reserved for future, zeroes
+ * @type: type of the target inode (%UBIFS_ITYPE_REG, %UBIFS_ITYPE_DIR, etc)
+ * @nlen: name length
+ * @padding2: reserved for future, zeroes
+ * @name: zero-terminated name
+ *
+ * Note, do not forget to amend 'zero_dent_node_unused()' function when
+ * changing the padding fields.
+ */
+struct ubifs_dent_node {
+	struct ubifs_ch ch;
+	__u8 key[UBIFS_MAX_KEY_LEN];
+	__le64 inum;
+	__u8 padding1;
+	__u8 type;
+	__le16 nlen;
+	__u8 padding2[4]; /* Watch 'zero_dent_node_unused()' if changing! */
+	__u8 name[];
+} __attribute__ ((packed));
+
+/**
+ * struct ubifs_data_node - data node.
+ * @ch: common header
+ * @key: node key
+ * @size: uncompressed data size in bytes
+ * @compr_type: compression type (%UBIFS_COMPR_NONE, %UBIFS_COMPR_LZO, etc)
+ * @padding: reserved for future, zeroes
+ * @data: data
+ *
+ * Note, do not forget to amend 'zero_data_node_unused()' function when
+ * changing the padding fields.
+ */
+struct ubifs_data_node {
+	struct ubifs_ch ch;
+	__u8 key[UBIFS_MAX_KEY_LEN];
+	__le32 size;
+	__le16 compr_type;
+	__u8 padding[2]; /* Watch 'zero_data_node_unused()' if changing! */
+	__u8 data[];
+} __attribute__ ((packed));
+
+/**
+ * struct ubifs_trun_node - truncation node.
+ * @ch: common header
+ * @key: truncation node key
+ * @old_size: size before truncation
+ * @new_size: size after truncation
+ *
+ * This node exists only in the journal and never goes to the main area.
+ */
+struct ubifs_trun_node {
+	struct ubifs_ch ch;
+	__u8 key[UBIFS_MAX_KEY_LEN];
+	__le64 old_size;
+	__le64 new_size;
+} __attribute__ ((packed));
+
+/**
+ * struct ubifs_pad_node - padding node.
+ * @ch: common header
+ * @pad_len: how many bytes after this node are unused (because padded)
+ * @padding: reserved for future, zeroes
+ */
+struct ubifs_pad_node {
+	struct ubifs_ch ch;
+	__le32 pad_len;
+} __attribute__ ((packed));
+
+/**
+ * struct ubifs_sb_node - superblock node.
+ * @ch: common header
+ * @padding: reserved for future, zeroes
+ * @key_hash: type of hash function used in keys
+ * @key_fmt: format of the key
+ * @flags: file-system flags (%UBIFS_FLG_BIGLPT, etc)
+ * @min_io_size: minimal input/output unit size
+ * @leb_size: logical eraseblock size in bytes
+ * @leb_cnt: count of LEBs used by filesystem
+ * @max_leb_cnt: maximum count of LEBs used by filesystem
+ * @max_bud_bytes: maximum amount of data stored in buds
+ * @log_lebs: log size in logical eraseblocks
+ * @lpt_lebs: number of LEBs used for lprops table
+ * @orph_lebs: number of LEBs used for recording orphans
+ * @jhead_cnt: count of journal heads
+ * @fanout: tree fanout (max. number of links per indexing node)
+ * @lsave_cnt: number of LEB numbers in LPT's save table
+ * @fmt_vers: UBIFS on-flash format version
+ * @default_compr: default compression algorithm (%UBIFS_COMPR_LZO, etc)
+ * @padding1: reserved for future, zeroes
+ * @rp_uid: reserve pool UID
+ * @rp_gid: reserve pool GID
+ * @rp_size: size of the reserved pool in bytes
+ * @padding2: reserved for future, zeroes
+ * @time_gran: time granularity in nanoseconds
+ */
+struct ubifs_sb_node {
+	struct ubifs_ch ch;
+	__u8 padding[2];
+	__u8 key_hash;
+	__u8 key_fmt;
+	__le32 flags;
+	__le32 min_io_size;
+	__le32 leb_size;
+	__le32 leb_cnt;
+	__le32 max_leb_cnt;
+	__le64 max_bud_bytes;
+	__le32 log_lebs;
+	__le32 lpt_lebs;
+	__le32 orph_lebs;
+	__le32 jhead_cnt;
+	__le32 fanout;
+	__le32 lsave_cnt;
+	__le32 fmt_vers;
+	__le16 default_compr;
+	__u8 padding1[2];
+	__le32 rp_uid;
+	__le32 rp_gid;
+	__le64 rp_size;
+	__le32 time_gran;
+	__u8 padding2[3988];
+} __attribute__ ((packed));
+
+/**
+ * struct ubifs_mst_node - master node.
+ * @ch: common header
+ * @highest_inum: highest inode number in the committed index
+ * @cmt_no: commit number
+ * @flags: various flags (%UBIFS_MST_DIRTY, etc)
+ * @log_lnum: start of the log
+ * @root_lnum: LEB number of the root indexing node
+ * @root_offs: offset within @root_lnum
+ * @root_len: root indexing node length
+ * @gc_lnum: LEB reserved for garbage collection (%-1 value means the LEB was
+ * not reserved and should be reserved on mount)
+ * @ihead_lnum: LEB number of index head
+ * @ihead_offs: offset of index head
+ * @index_size: size of index on flash
+ * @total_free: total free space in bytes
+ * @total_dirty: total dirty space in bytes
+ * @total_used: total used space in bytes (includes only data LEBs)
+ * @total_dead: total dead space in bytes (includes only data LEBs)
+ * @total_dark: total dark space in bytes (includes only data LEBs)
+ * @lpt_lnum: LEB number of LPT root nnode
+ * @lpt_offs: offset of LPT root nnode
+ * @nhead_lnum: LEB number of LPT head
+ * @nhead_offs: offset of LPT head
+ * @ltab_lnum: LEB number of LPT's own lprops table
+ * @ltab_offs: offset of LPT's own lprops table
+ * @lsave_lnum: LEB number of LPT's save table (big model only)
+ * @lsave_offs: offset of LPT's save table (big model only)
+ * @lscan_lnum: LEB number of last LPT scan
+ * @empty_lebs: number of empty logical eraseblocks
+ * @idx_lebs: number of indexing logical eraseblocks
+ * @leb_cnt: count of LEBs used by filesystem
+ * @padding: reserved for future, zeroes
+ */
+struct ubifs_mst_node {
+	struct ubifs_ch ch;
+	__le64 highest_inum;
+	__le64 cmt_no;
+	__le32 flags;
+	__le32 log_lnum;
+	__le32 root_lnum;
+	__le32 root_offs;
+	__le32 root_len;
+	__le32 gc_lnum;
+	__le32 ihead_lnum;
+	__le32 ihead_offs;
+	__le64 index_size;
+	__le64 total_free;
+	__le64 total_dirty;
+	__le64 total_used;
+	__le64 total_dead;
+	__le64 total_dark;
+	__le32 lpt_lnum;
+	__le32 lpt_offs;
+	__le32 nhead_lnum;
+	__le32 nhead_offs;
+	__le32 ltab_lnum;
+	__le32 ltab_offs;
+	__le32 lsave_lnum;
+	__le32 lsave_offs;
+	__le32 lscan_lnum;
+	__le32 empty_lebs;
+	__le32 idx_lebs;
+	__le32 leb_cnt;
+	__u8 padding[344];
+} __attribute__ ((packed));
+
+/**
+ * struct ubifs_ref_node - logical eraseblock reference node.
+ * @ch: common header
+ * @lnum: the referred logical eraseblock number
+ * @offs: start offset in the referred LEB
+ * @jhead: journal head number
+ * @padding: reserved for future, zeroes
+ */
+struct ubifs_ref_node {
+	struct ubifs_ch ch;
+	__le32 lnum;
+	__le32 offs;
+	__le32 jhead;
+	__u8 padding[28];
+} __attribute__ ((packed));
+
+/**
+ * struct ubifs_branch - key/reference/length branch
+ * @lnum: LEB number of the target node
+ * @offs: offset within @lnum
+ * @len: target node length
+ * @key: key
+ */
+struct ubifs_branch {
+	__le32 lnum;
+	__le32 offs;
+	__le32 len;
+	__u8 key[];
+} __attribute__ ((packed));
+
+/**
+ * struct ubifs_idx_node - indexing node.
+ * @ch: common header
+ * @child_cnt: number of child index nodes
+ * @level: tree level
+ * @branches: LEB number / offset / length / key branches
+ */
+struct ubifs_idx_node {
+	struct ubifs_ch ch;
+	__le16 child_cnt;
+	__le16 level;
+	__u8 branches[];
+} __attribute__ ((packed));
+
+/**
+ * struct ubifs_cs_node - commit start node.
+ * @ch: common header
+ * @cmt_no: commit number
+ */
+struct ubifs_cs_node {
+	struct ubifs_ch ch;
+	__le64 cmt_no;
+} __attribute__ ((packed));
+
+/**
+ * struct ubifs_orph_node - orphan node.
+ * @ch: common header
+ * @cmt_no: commit number (also top bit is set on the last node of the commit)
+ * @inos: inode numbers of orphans
+ */
+struct ubifs_orph_node {
+	struct ubifs_ch ch;
+	__le64 cmt_no;
+	__le64 inos[];
+} __attribute__ ((packed));
+
+#endif /* __UBIFS_MEDIA_H__ */
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
new file mode 100644
index 0000000..389eb70
--- /dev/null
+++ b/fs/ubifs/ubifs.h
@@ -0,0 +1,1576 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Artem Bityutskiy (Битюцкий Артём)
+ *          Adrian Hunter
+ */
+
+/* Implementation version 0.6 */
+
+#ifndef __UBIFS_H__
+#define __UBIFS_H__
+
+#include <asm/div64.h>
+#include <linux/statfs.h>
+#include <linux/fs.h>
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <linux/vmalloc.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/rwsem.h>
+#include <linux/mtd/ubi.h>
+#include <linux/pagemap.h>
+#include <linux/backing-dev.h>
+#include "ubifs-media.h"
+
+/* Version of this UBIFS implementation */
+#define UBIFS_VERSION 1
+
+/* Normal UBIFS messages */
+#define ubifs_msg(fmt, ...) \
+		printk(KERN_NOTICE "UBIFS: " fmt "\n", ##__VA_ARGS__)
+/* UBIFS error messages */
+#define ubifs_err(fmt, ...)                                                  \
+	printk(KERN_ERR "UBIFS error (pid %d): %s: " fmt "\n", current->pid, \
+	       __func__, ##__VA_ARGS__)
+/* UBIFS warning messages */
+#define ubifs_warn(fmt, ...)                                         \
+	printk(KERN_WARNING "UBIFS warning (pid %d): %s: " fmt "\n", \
+	       current->pid, __func__, ##__VA_ARGS__)
+
+/* UBIFS file system VFS magic number */
+#define UBIFS_SUPER_MAGIC 0x24051905
+
+/* Number of UBIFS blocks per VFS page */
+#define UBIFS_BLOCKS_PER_PAGE (PAGE_CACHE_SIZE / UBIFS_BLOCK_SIZE)
+#define UBIFS_BLOCKS_PER_PAGE_SHIFT (PAGE_CACHE_SHIFT - UBIFS_BLOCK_SHIFT)
+
+/* "File system end of life" sequence number watermark */
+#define SQNUM_WARN_WATERMARK 0xFFFFFFFF00000000ULL
+#define SQNUM_WATERMARK      0xFFFFFFFFFF000000ULL
+
+/* Minimum amount of data UBIFS writes to the flash */
+#define MIN_WRITE_SZ (UBIFS_DATA_NODE_SZ + 8)
+
+/*
+ * Currently we do not support inode number overlapping and re-using, so this
+ * watermark defines dangerous inode number level. This should be fixed later,
+ * although it is difficult to exceed current limit. Another option is to use
+ * 64-bit inode numbers, but this means more overhead.
+ */
+#define INUM_WARN_WATERMARK 0xFFF00000
+#define INUM_WATERMARK      0xFFFFFF00
+
+/* Largest key size supported in this implementation */
+#define CUR_MAX_KEY_LEN UBIFS_SK_LEN
+
+/* Maximum number of entries in each LPT (LEB category) heap */
+#define LPT_HEAP_SZ 256
+
+/*
+ * Background thread name pattern. The numbers are UBI device and volume
+ * numbers.
+ */
+#define BGT_NAME_PATTERN "ubifs_bgt%d_%d"
+
+/* Default write-buffer synchronization timeout (5 secs) */
+#define DEFAULT_WBUF_TIMEOUT (5 * HZ)
+
+/* Maximum possible inode number (only 32-bit inodes are supported now) */
+#define MAX_INUM 0xFFFFFFFF
+
+/* Number of non-data journal heads */
+#define NONDATA_JHEADS_CNT 2
+
+/* Garbage collector head */
+#define GCHD   0
+/* Base journal head number */
+#define BASEHD 1
+/* First "general purpose" journal head */
+#define DATAHD 2
+
+/*
+ * How much a directory entry/extended attribute entry adds to the parent/host
+ * inode.
+ */
+#define CALC_DENT_SIZE(name_len) ALIGN(UBIFS_DENT_NODE_SZ + (name_len) + 1, 8)
+
+/*
+ * Znodes which were not touched for 'OLD_ZNODE_AGE' seconds are considered
+ * "old", and znode which were touched last 'YOUNG_ZNODE_AGE' seconds ago are
+ * considered "young". This is used by shrinker when selecting znode to trim
+ * off.
+ */
+#define OLD_ZNODE_AGE 20
+#define YOUNG_ZNODE_AGE 5
+
+/*
+ * Some compressors, like LZO, may end up with more data then the input buffer.
+ * So UBIFS always allocates larger output buffer, to be sure the compressor
+ * will not corrupt memory in case of worst case compression.
+ */
+#define WORST_COMPR_FACTOR 2
+
+/* Maximum expected tree height for use by bottom_up_buf */
+#define BOTTOM_UP_HEIGHT 64
+
+/*
+ * Znode flags (actually, bit numbers which store the flags).
+ *
+ * DIRTY_ZNODE: znode is dirty
+ * COW_ZNODE: znode is being committed and a new instance of this znode has to
+ *            be created before changing this znode
+ * OBSOLETE_ZNODE: znode is obsolete, which means it was deleted, but it is
+ *                 still in the commit list and the ongoing commit operation
+ *                 will commit it, and delete this znode after it is done
+ */
+enum {
+	DIRTY_ZNODE    = 0,
+	COW_ZNODE      = 1,
+	OBSOLETE_ZNODE = 2
+};
+
+/*
+ * Commit states.
+ *
+ * COMMIT_RESTING: commit is not wanted
+ * COMMIT_BACKGROUND: background commit has been requested
+ * COMMIT_REQUIRED: commit is required
+ * COMMIT_RUNNING_BACKGROUND: background commit is running
+ * COMMIT_RUNNING_REQUIRED: commit is running and it is required
+ * COMMIT_BROKEN: commit failed
+ */
+enum {
+	COMMIT_RESTING = 0,
+	COMMIT_BACKGROUND,
+	COMMIT_REQUIRED,
+	COMMIT_RUNNING_BACKGROUND,
+	COMMIT_RUNNING_REQUIRED,
+	COMMIT_BROKEN,
+};
+
+/*
+ * 'ubifs_scan_a_node()' return values.
+ *
+ * SCANNED_GARBAGE:  scanned garbage
+ * SCANNED_EMPTY_SPACE: scanned empty space
+ * SCANNED_A_NODE: scanned a valid node
+ * SCANNED_A_CORRUPT_NODE: scanned a corrupted node
+ * SCANNED_A_BAD_PAD_NODE: scanned a padding node with invalid pad length
+ *
+ * Greater than zero means: 'scanned that number of padding bytes'
+ */
+enum {
+	SCANNED_GARBAGE        = 0,
+	SCANNED_EMPTY_SPACE    = -1,
+	SCANNED_A_NODE         = -2,
+	SCANNED_A_CORRUPT_NODE = -3,
+	SCANNED_A_BAD_PAD_NODE = -4,
+};
+
+/*
+ * LPT cnode flag bits.
+ *
+ * DIRTY_CNODE: cnode is dirty
+ * COW_CNODE: cnode is being committed and must be copied before writing
+ * OBSOLETE_CNODE: cnode is being committed and has been copied (or deleted),
+ * so it can (and must) be freed when the commit is finished
+ */
+enum {
+	DIRTY_CNODE    = 0,
+	COW_CNODE      = 1,
+	OBSOLETE_CNODE = 2,
+};
+
+/*
+ * Dirty flag bits (lpt_drty_flgs) for LPT special nodes.
+ *
+ * LTAB_DIRTY: ltab node is dirty
+ * LSAVE_DIRTY: lsave node is dirty
+ */
+enum {
+	LTAB_DIRTY  = 1,
+	LSAVE_DIRTY = 2,
+};
+
+/*
+ * Return codes used by the garbage collector.
+ * @LEB_FREED: the logical eraseblock was freed and is ready to use
+ * @LEB_FREED_IDX: indexing LEB was freed and can be used only after the commit
+ * @LEB_RETAINED: the logical eraseblock was freed and retained for GC purposes
+ */
+enum {
+	LEB_FREED,
+	LEB_FREED_IDX,
+	LEB_RETAINED,
+};
+
+/**
+ * struct ubifs_old_idx - index node obsoleted since last commit start.
+ * @rb: rb-tree node
+ * @lnum: LEB number of obsoleted index node
+ * @offs: offset of obsoleted index node
+ */
+struct ubifs_old_idx {
+	struct rb_node rb;
+	int lnum;
+	int offs;
+};
+
+/* The below union makes it easier to deal with keys */
+union ubifs_key {
+	uint8_t u8[CUR_MAX_KEY_LEN];
+	uint32_t u32[CUR_MAX_KEY_LEN/4];
+	uint64_t u64[CUR_MAX_KEY_LEN/8];
+	__le32 j32[CUR_MAX_KEY_LEN/4];
+};
+
+/**
+ * struct ubifs_scan_node - UBIFS scanned node information.
+ * @list: list of scanned nodes
+ * @key: key of node scanned (if it has one)
+ * @sqnum: sequence number
+ * @type: type of node scanned
+ * @offs: offset with LEB of node scanned
+ * @len: length of node scanned
+ * @node: raw node
+ */
+struct ubifs_scan_node {
+	struct list_head list;
+	union ubifs_key key;
+	unsigned long long sqnum;
+	int type;
+	int offs;
+	int len;
+	void *node;
+};
+
+/**
+ * struct ubifs_scan_leb - UBIFS scanned LEB information.
+ * @lnum: logical eraseblock number
+ * @nodes_cnt: number of nodes scanned
+ * @nodes: list of struct ubifs_scan_node
+ * @endpt: end point (and therefore the start of empty space)
+ * @ecc: read returned -EBADMSG
+ * @buf: buffer containing entire LEB scanned
+ */
+struct ubifs_scan_leb {
+	int lnum;
+	int nodes_cnt;
+	struct list_head nodes;
+	int endpt;
+	int ecc;
+	void *buf;
+};
+
+/**
+ * struct ubifs_gced_idx_leb - garbage-collected indexing LEB.
+ * @list: list
+ * @lnum: LEB number
+ * @unmap: OK to unmap this LEB
+ *
+ * This data structure is used to temporary store garbage-collected indexing
+ * LEBs - they are not released immediately, but only after the next commit.
+ * This is needed to guarantee recoverability.
+ */
+struct ubifs_gced_idx_leb {
+	struct list_head list;
+	int lnum;
+	int unmap;
+};
+
+/**
+ * struct ubifs_inode - UBIFS in-memory inode description.
+ * @vfs_inode: VFS inode description object
+ * @creat_sqnum: sequence number at time of creation
+ * @xattr_size: summarized size of all extended attributes in bytes, protected
+ *              by @inode->i_lock
+ * @xattr_cnt: count of extended attributes this inode has
+ * @xattr_names: sum of lengths of all extended attribute names belonging to
+ *               this inode
+ * @dirty: non-zero if the inode is dirty
+ * @xattr: non-zero if this is an extended attribute inode
+ * @budgeted: non-zero if the inode has been budgeted (used for debugging)
+ * @budg_mutex: serializes inode budgeting and write-back
+ * @flags: inode flags (@UBIFS_COMPR_FL, etc)
+ * @compr_type: default compression type used for this inode
+ * @data_len: length of the data attached to the inode
+ * @data: inode's data
+ *
+ * UBIFS has its own inode mutex, besides the VFS 'i_mutex'. The reason for
+ * this is budgeting - UBIFS has to budget each operation. So, if an operation
+ * is going to mark an inode dirty, it has to allocate budget for this. It
+ * cannot just mark it dirty because there is no guarantee there will be enough
+ * flash space when it is time to write the inode back. This means that UBIFS
+ * has to have full control over "clean <-> dirty" transitions of inodes (and
+ * pages actually, but it is easy for pages, because we have
+ * 'ubifs_prepare_write()' which is called _before_ every page change). But
+ * unfortunately, VFS marks inodes dirty in many places, and it does not ask
+ * the file-system if it is allowed to do so (there is a notifier, but it is
+ * not enough), i.e., there is no mechanism to synchronize with this. So we
+ * introduce our own dirty flag to UBIFS inodes and our own inode mutex to
+ * serialize "clean <-> dirty" transitions.
+ */
+struct ubifs_inode {
+	struct inode vfs_inode;
+	unsigned long long creat_sqnum;
+	long long xattr_size;
+	int xattr_cnt;
+	int xattr_names;
+	unsigned int dirty:1;
+	unsigned int xattr:1;
+#ifdef CONFIG_UBIFS_FS_DEBUG
+	unsigned int budgeted:1;
+#endif
+	struct mutex budg_mutex;
+	int flags;
+	int compr_type;
+	int data_len;
+	void *data;
+};
+
+/**
+ * struct ubifs_unclean_leb - records a LEB recovered under read-only mode.
+ * @list: list
+ * @lnum: LEB number of recovered LEB
+ * @endpt: offset where recovery ended
+ *
+ * This structure records a LEB identified during recovery that needs to be
+ * cleaned but was not because UBIFS was mounted read-only. The information
+ * is used to clean the LEB when remounting to read-write mode.
+ */
+struct ubifs_unclean_leb {
+	struct list_head list;
+	int lnum;
+	int endpt;
+};
+
+/*
+ * LEB properties flags.
+ *
+ * LPROPS_UNCAT: not categorized
+ * LPROPS_DIRTY: dirty > 0, not index
+ * LPROPS_DIRTY_IDX: dirty + free > UBIFS_CH_SZ and index
+ * LPROPS_FREE: free > 0, not empty, not index
+ * LPROPS_HEAP_CNT: number of heaps used for storing categorized LEBs
+ * LPROPS_EMPTY: LEB is empty, not taken
+ * LPROPS_FREEABLE: free + dirty == leb_size, not index, not taken
+ * LPROPS_FRDI_IDX: free + dirty == leb_size and index, may be taken
+ * LPROPS_CAT_MASK: mask for the LEB categories above
+ * LPROPS_TAKEN: LEB was taken (this flag is not saved on the media)
+ * LPROPS_INDEX: LEB contains indexing nodes (this flag also exists on flash)
+ */
+enum {
+	LPROPS_UNCAT     =  0,
+	LPROPS_DIRTY     =  1,
+	LPROPS_DIRTY_IDX =  2,
+	LPROPS_FREE      =  3,
+	LPROPS_HEAP_CNT  =  3,
+	LPROPS_EMPTY     =  4,
+	LPROPS_FREEABLE  =  5,
+	LPROPS_FRDI_IDX  =  6,
+	LPROPS_CAT_MASK  = 15,
+	LPROPS_TAKEN     = 16,
+	LPROPS_INDEX     = 32,
+};
+
+/**
+ * struct ubifs_lprops - logical eraseblock properties.
+ * @free: amount of free space in bytes
+ * @dirty: amount of dirty space in bytes
+ * @flags: LEB properties flags (see above)
+ * @lnum: LEB number
+ * @list: list of same-category lprops (for LPROPS_EMPTY and LPROPS_FREEABLE)
+ * @hpos: heap position in heap of same-category lprops (other categories)
+ */
+struct ubifs_lprops {
+	int free;
+	int dirty;
+	int flags;
+	int lnum;
+	union {
+		struct list_head list;
+		int hpos;
+	};
+};
+
+/**
+ * struct ubifs_lpt_lprops - LPT logical eraseblock properties.
+ * @free: amount of free space in bytes
+ * @dirty: amount of dirty space in bytes
+ * @tgc: trivial GC flag (1 => unmap after commit end)
+ * @cmt: commit flag (1 => reserved for commit)
+ */
+struct ubifs_lpt_lprops {
+	int free;
+	int dirty;
+	unsigned tgc : 1;
+	unsigned cmt : 1;
+};
+
+/**
+ * struct ubifs_lp_stats - statistics of eraseblocks in the main area.
+ * @empty_lebs: number of empty LEBs
+ * @taken_empty_lebs: number of taken LEBs
+ * @idx_lebs: number of indexing LEBs
+ * @total_free: total free space in bytes
+ * @total_dirty: total dirty space in bytes
+ * @total_used: total used space in bytes (includes only data LEBs)
+ * @total_dead: total dead space in bytes (includes only data LEBs)
+ * @total_dark: total dark space in bytes (includes only data LEBs)
+ *
+ * N.B. total_dirty and total_used are different to other total_* fields,
+ * because they account _all_ LEBs, not just data LEBs.
+ *
+ * 'taken_empty_lebs' counts the LEBs that are in the transient state of having
+ * been 'taken' for use but not yet written to. 'taken_empty_lebs' is needed
+ * to account correctly for gc_lnum, otherwise 'empty_lebs' could be used
+ * by itself (in which case 'unused_lebs' would be a better name). In the case
+ * of gc_lnum, it is 'taken' at mount time or whenever a LEB is retained by GC,
+ * but unlike other empty LEBs that are 'taken', it may not be written straight
+ * away (i.e. before the next commit start or unmount), so either gc_lnum must
+ * be specially accounted for, or the current approach followed i.e. count it
+ * under 'taken_empty_lebs'.
+ */
+struct ubifs_lp_stats {
+	int empty_lebs;
+	int taken_empty_lebs;
+	int idx_lebs;
+	long long total_free;
+	long long total_dirty;
+	long long total_used;
+	long long total_dead;
+	long long total_dark;
+};
+
+struct ubifs_nnode;
+
+/**
+ * struct ubifs_cnode - LEB Properties Tree common node.
+ * @parent: parent nnode
+ * @cnext: next cnode to commit
+ * @flags: flags (%DIRTY_LPT_NODE or %OBSOLETE_LPT_NODE)
+ * @iip: index in parent
+ * @level: level in the tree (zero for pnodes, greater than zero for nnodes)
+ * @num: node number
+ */
+struct ubifs_cnode {
+	struct ubifs_nnode *parent;
+	struct ubifs_cnode *cnext;
+	unsigned long flags;
+	int iip;
+	int level;
+	int num;
+};
+
+/**
+ * struct ubifs_pnode - LEB Properties Tree leaf node.
+ * @parent: parent nnode
+ * @cnext: next cnode to commit
+ * @flags: flags (%DIRTY_LPT_NODE or %OBSOLETE_LPT_NODE)
+ * @iip: index in parent
+ * @level: level in the tree (always zero for pnodes)
+ * @num: node number
+ * @lprops: LEB properties array
+ */
+struct ubifs_pnode {
+	struct ubifs_nnode *parent;
+	struct ubifs_cnode *cnext;
+	unsigned long flags;
+	int iip;
+	int level;
+	int num;
+	struct ubifs_lprops lprops[UBIFS_LPT_FANOUT];
+};
+
+/**
+ * struct ubifs_nbranch - LEB Properties Tree internal node branch.
+ * @lnum: LEB number of child
+ * @offs: offset of child
+ * @nnode: nnode child
+ * @pnode: pnode child
+ * @cnode: cnode child
+ */
+struct ubifs_nbranch {
+	int lnum;
+	int offs;
+	union {
+		struct ubifs_nnode *nnode;
+		struct ubifs_pnode *pnode;
+		struct ubifs_cnode *cnode;
+	};
+};
+
+/**
+ * struct ubifs_nnode - LEB Properties Tree internal node.
+ * @parent: parent nnode
+ * @cnext: next cnode to commit
+ * @flags: flags (%DIRTY_LPT_NODE or %OBSOLETE_LPT_NODE)
+ * @iip: index in parent
+ * @level: level in the tree (always greater than zero for nnodes)
+ * @num: node number
+ * @nbranch: branches to child nodes
+ */
+struct ubifs_nnode {
+	struct ubifs_nnode *parent;
+	struct ubifs_cnode *cnext;
+	unsigned long flags;
+	int iip;
+	int level;
+	int num;
+	struct ubifs_nbranch nbranch[UBIFS_LPT_FANOUT];
+};
+
+/**
+ * struct ubifs_lpt_heap - heap of categorized lprops.
+ * @arr: heap array
+ * @cnt: number in heap
+ * @max_cnt: maximum number allowed in heap
+ *
+ * There are %LPROPS_HEAP_CNT heaps.
+ */
+struct ubifs_lpt_heap {
+	struct ubifs_lprops **arr;
+	int cnt;
+	int max_cnt;
+};
+
+/*
+ * Return codes for LPT scan callback function.
+ *
+ * LPT_SCAN_CONTINUE: continue scanning
+ * LPT_SCAN_ADD: add the LEB properties scanned to the tree in memory
+ * LPT_SCAN_STOP: stop scanning
+ */
+enum {
+	LPT_SCAN_CONTINUE = 0,
+	LPT_SCAN_ADD = 1,
+	LPT_SCAN_STOP = 2,
+};
+
+struct ubifs_info;
+
+/* Callback used by the 'ubifs_lpt_scan_nolock()' function */
+typedef int (*ubifs_lpt_scan_callback)(struct ubifs_info *c,
+				       const struct ubifs_lprops *lprops,
+				       int in_tree, void *data);
+
+/**
+ * struct ubifs_wbuf - UBIFS write-buffer.
+ * @c: UBIFS file-system description object
+ * @buf: write-buffer (of min. flash I/O unit size)
+ * @lnum: logical eraseblock number the write-buffer points to
+ * @offs: write-buffer offset in this logical eraseblock
+ * @avail: number of bytes available in the write-buffer
+ * @used:  number of used bytes in the write-buffer
+ * @dtype: type of data stored in this LEB (%UBI_LONGTERM, %UBI_SHORTTERM,
+ * %UBI_UNKNOWN)
+ * @jhead: journal head the mutex belongs to (note, needed only to shut lockdep
+ * up by 'mutex_lock_nested()).
+ * @sync_callback: write-buffer synchronization callback
+ * @io_mutex: serializes write-buffer I/O
+ * @lock: serializes @buf, @lnum, @offs, @avail, @used, @next_ino and @inodes
+ * fields
+ * @timer: write-buffer timer
+ * @timeout: timer expire interval in jiffies
+ * @need_sync: it is set if its timer expired and needs sync
+ * @next_ino: points to the next position of the following inode number
+ * @inodes: stores the inode numbers of the nodes which are in wbuf
+ *
+ * The write-buffer synchronization callback is called when the write-buffer is
+ * synchronized in order to notify how much space was wasted due to
+ * write-buffer padding and how much free space is left in the LEB.
+ *
+ * Note: the fields @buf, @lnum, @offs, @avail and @used can be read under
+ * spin-lock or mutex because they are written under both mutex and spin-lock.
+ * @buf is appended to under mutex but overwritten under both mutex and
+ * spin-lock. Thus the data between @buf and @buf + @used can be read under
+ * spinlock.
+ */
+struct ubifs_wbuf {
+	struct ubifs_info *c;
+	void *buf;
+	int lnum;
+	int offs;
+	int avail;
+	int used;
+	int dtype;
+	int jhead;
+	int (*sync_callback)(struct ubifs_info *c, int lnum, int free, int pad);
+	struct mutex io_mutex;
+	spinlock_t lock;
+	struct timer_list timer;
+	int timeout;
+	int need_sync;
+	int next_ino;
+	ino_t *inodes;
+};
+
+/**
+ * struct ubifs_bud - bud logical eraseblock.
+ * @lnum: logical eraseblock number
+ * @start: where the (uncommitted) bud data starts
+ * @jhead: journal head number this bud belongs to
+ * @list: link in the list buds belonging to the same journal head
+ * @rb: link in the tree of all buds
+ */
+struct ubifs_bud {
+	int lnum;
+	int start;
+	int jhead;
+	struct list_head list;
+	struct rb_node rb;
+};
+
+/**
+ * struct ubifs_jhead - journal head.
+ * @wbuf: head's write-buffer
+ * @buds_list: list of bud LEBs belonging to this journal head
+ *
+ * Note, the @buds list is protected by the @c->buds_lock.
+ */
+struct ubifs_jhead {
+	struct ubifs_wbuf wbuf;
+	struct list_head buds_list;
+};
+
+/**
+ * struct ubifs_zbranch - key/coordinate/length branch stored in znodes.
+ * @key: key
+ * @znode: znode address in memory
+ * @lnum: LEB number of the indexing node
+ * @offs: offset of the indexing node within @lnum
+ * @len: target node length
+ */
+struct ubifs_zbranch {
+	union ubifs_key key;
+	union {
+		struct ubifs_znode *znode;
+		void *leaf;
+	};
+	int lnum;
+	int offs;
+	int len;
+};
+
+/**
+ * struct ubifs_znode - in-memory representation of an indexing node.
+ * @parent: parent znode or NULL if it is the root
+ * @cnext: next znode to commit
+ * @flags: znode flags (%DIRTY_ZNODE, %COW_ZNODE or %OBSOLETE_ZNODE)
+ * @time: last access time (seconds)
+ * @level: level of the entry in the TNC tree
+ * @child_cnt: count of child znodes
+ * @iip: index in parent's zbranch array
+ * @alt: lower bound of key range has altered i.e. child inserted at slot 0
+ * @lnum: LEB number of the corresponding indexing node
+ * @offs: offset of the corresponding indexing node
+ * @len: length  of the corresponding indexing node
+ * @zbranch: array of znode branches (@c->fanout elements)
+ */
+struct ubifs_znode {
+	struct ubifs_znode *parent;
+	struct ubifs_znode *cnext;
+	unsigned long flags;
+	unsigned long time;
+	int level;
+	int child_cnt;
+	int iip;
+	int alt;
+#ifdef CONFIG_UBIFS_FS_DEBUG
+	int lnum, offs, len;
+#endif
+	struct ubifs_zbranch zbranch[];
+};
+
+/**
+ * struct ubifs_node_range - node length range description data structure.
+ * @len: fixed node length
+ * @min_len: minimum possible node length
+ * @max_len: maximum possible node length
+ *
+ * If @max_len is %0, the node has fixed length @len.
+ */
+struct ubifs_node_range {
+	union {
+		int len;
+		int min_len;
+	};
+	int max_len;
+};
+
+/**
+ * struct ubifs_compressor - UBIFS compressor description structure.
+ * @compr_type: compressor type (%UBIFS_COMPR_LZO, etc)
+ * @cc: cryptoapi compressor handle
+ * @comp_mutex: mutex used during compression
+ * @decomp_mutex: mutex used during decompression
+ * @name: compressor name
+ * @capi_name: cryptoapi compressor name
+ */
+struct ubifs_compressor {
+	int compr_type;
+	struct crypto_comp *cc;
+	struct mutex *comp_mutex;
+	struct mutex *decomp_mutex;
+	const char *name;
+	const char *capi_name;
+};
+
+/**
+ * struct ubifs_budget_req - budget requirements of an operation.
+ *
+ * @new_ino: non-zero if the operation adds a new inode
+ * @dirtied_ino: how many inodes the operation makes dirty
+ * @new_page: non-zero if the operation adds a new page
+ * @dirtied_page: non-zero if the operation makes a page dirty
+ * @new_dent: non-zero if the operation adds a new directory entry
+ * @mod_dent: non-zero if the operation removes or modifies an existing
+ *            directory entry
+ * @new_ino_d: now much data newly created inode contains
+ * @dirtied_ino_d: now much data dirtied inode contains
+ * @idx_growth: how much the index will supposedly grow
+ * @data_growth: how much new data the operation will supposedly add
+ * @dd_growth: how much data that makes other data dirty the operation will
+ *             supposedly add
+ *
+ * @idx_growth, @data_growth and @dd_growth are not used in budget request. The
+ * budgeting subsystem caches index and data growth values there to avoid
+ * re-calculating them when the budget is released. However, if @idx_growth is
+ * %-1, it is calculated by the release function using other fields.
+ *
+ * An inode may contain 4KiB of data at max., thus the widths of @new_ino_d
+ * is 13 bits, and @dirtied_ino_d - 15, because up to 4 inodes may be made
+ * dirty by the re-name operation.
+ */
+struct ubifs_budget_req {
+	unsigned int new_ino:1;
+	unsigned int dirtied_ino:4;
+	unsigned int new_page:1;
+	unsigned int dirtied_page:1;
+	unsigned int new_dent:1;
+	unsigned int mod_dent:1;
+	unsigned int new_ino_d:13;
+	unsigned int dirtied_ino_d:15;
+	int idx_growth;
+	int data_growth;
+	int dd_growth;
+};
+
+/**
+ * struct ubifs_orphan - stores the inode number of an orphan.
+ * @rb: rb-tree node of rb-tree of orphans sorted by inode number
+ * @list: list head of list of orphans in order added
+ * @new_list: list head of list of orphans added since the last commit
+ * @cnext: next orphan to commit
+ * @dnext: next orphan to delete
+ * @inum: inode number
+ * @new: %1 => added since the last commit, otherwise %0
+ */
+struct ubifs_orphan {
+	struct rb_node rb;
+	struct list_head list;
+	struct list_head new_list;
+	struct ubifs_orphan *cnext;
+	struct ubifs_orphan *dnext;
+	ino_t inum;
+	int new;
+};
+
+/**
+ * struct ubifs_mount_opts - UBIFS-specific mount options information.
+ * @unmount_mode: selected unmount mode (%0 default, %1 normal, %2 fast)
+ */
+struct ubifs_mount_opts {
+	unsigned int unmount_mode:2;
+};
+
+/**
+ * struct ubifs_info - UBIFS file-system description data structure
+ * (per-superblock).
+ * @vfs_sb: VFS @struct super_block object
+ *
+ * @highest_inum: highest used inode number
+ * @vfs_gen: VFS inode generation counter
+ * @max_sqnum: current global sequence number
+ * @cmt_no: commit number (last successfully completed commit)
+ * @cnt_lock: protects @highest_inum, @vfs_gen, and @max_sqnum counters
+ * @fmt_vers: UBIFS on-flash format version
+ *
+ * @lhead_lnum: log head logical eraseblock number
+ * @lhead_offs: log head offset
+ * @ltail_lnum: log tail logical eraseblock number (offset is always 0)
+ * @log_mutex: protects the log, @lhead_lnum, @lhead_offs, @ltail_lnum, and
+ *             @bud_bytes
+ * @min_log_bytes: minimum required number of bytes in the log
+ * @cmt_bud_bytes: used during commit to temporarily amount of bytes in
+ *                 committed buds
+ *
+ * @buds: tree of all buds indexed by bud LEB number
+ * @bud_bytes: how many bytes of flash is used by buds
+ * @buds_lock: protects the @buds tree, @bud_bytes, and per-journal head bud
+ *             lists
+ * @jhead_cnt: count of journal heads
+ * @jheads: journal heads (head zero is base head)
+ * @max_bud_bytes: maximum number of bytes allowed in buds
+ * @bg_bud_bytes: number of bud bytes when background commit is initiated
+ * @old_buds: buds to be released after commit ends
+ * @max_bud_cnt: maximum number of buds
+ *
+ * @commit_sem: synchronizes committer with other processes
+ * @cmt_state: commit state
+ * @cs_lock: commit state lock
+ * @cmt_wq: wait queue to sleep on if the log is full and a commit is running
+ * @fast_unmount: do not run journal commit before unmounting
+ * @big_lpt: flag that LPT is too big to write whole during commit
+ *
+ * @tnc_mutex: protects the Tree Node Cache (TNC), @zroot, @cnext, @enext, and
+ *             @calc_idx_sz
+ * @zroot: zbranch which points to the root index node and znode
+ * @cnext: next znode to commit
+ * @enext: next znode to commit to empty space
+ * @gap_lebs: array of LEBs used by the in-gaps commit method
+ * @cbuf: commit buffer
+ * @ileb_buf: buffer for commit in-the-gaps method
+ * @ileb_len: length of data in ileb_buf
+ * @ihead_lnum: LEB number of index head
+ * @ihead_offs: offset of index head
+ * @ilebs: pre-allocated index LEBs
+ * @ileb_cnt: number of pre-allocated index LEBs
+ * @ileb_nxt: next pre-allocated index LEBs
+ * @old_idx: tree of index nodes obsoleted since the last commit start
+ * @bottom_up_buf: a buffer which is used by 'dirty_cow_bottom_up()' in tnc.c
+ * @new_ihead_lnum: used by debugging to check ihead_lnum
+ * @new_ihead_offs: used by debugging to check ihead_offs
+ *
+ * @mst_node: master node
+ * @mst_offs: offset of valid master node
+ * @mst_mutex: protects the master node area, @mst_node, and @mst_offs
+ *
+ * @log_lebs: number of logical eraseblocks in the log
+ * @log_bytes: log size in bytes
+ * @log_last: last LEB of the log
+ * @lpt_lebs: number of LEBs used for lprops table
+ * @lpt_first: first LEB of the lprops table area
+ * @lpt_last: last LEB of the lprops table area
+ * @orph_lebs: number of LEBs used for the orphan area
+ * @orph_first: first LEB of the orphan area
+ * @orph_last: last LEB of the orphan area
+ * @main_lebs: count of LEBs in the main area
+ * @main_first: first LEB of the main area
+ * @main_bytes: main area size in bytes
+ * @default_compr: default compression algorighm (%UBIFS_COMPR_LZO, etc)
+ *
+ * @key_hash_type: type of the key hash
+ * @key_hash: direntry key hash function
+ * @key_fmt: key format
+ * @key_len: key length
+ * @fanout: fanout of the index tree (number of links per indexing node)
+ *
+ * @min_io_size: minimal input/output unit size
+ * @min_io_shift: number of bits in @min_io_size minus one
+ * @leb_size: logical eraseblock size in bytes
+ * @half_leb_size: half LEB size
+ * @leb_cnt: count of logical eraseblocks
+ * @max_leb_cnt: maximum count of logical eraseblocks
+ * @old_leb_cnt: count of logical eraseblocks before resize
+ * @ro_media: the underlying UBI volume is read-only
+ *
+ * @dirty_pg_cnt: number of dirty pages (not used)
+ * @dirty_ino_cnt: number of dirty inodes (not used)
+ * @dirty_zn_cnt: number of dirty znodes
+ * @clean_zn_cnt: number of clean znodes
+ *
+ * @budg_idx_growth: amount of bytes budgeted for index growth
+ * @budg_data_growth: amount of bytes budgeted for cached data
+ * @budg_dd_growth: amount of bytes budgeted for cached data that will make
+ *                  other data dirty
+ * @budg_uncommitted_idx: amount of bytes were budgeted for growth of the index,
+ *                        but which still have to be taken into account because
+ *                        the index has not been committed so far
+ * @space_lock: protects @budg_idx_growth, @budg_data_growth, @budg_dd_growth,
+ *              @budg_uncommited_idx, @min_idx_lebs, @old_idx_sz, and @lst;
+ * @min_idx_lebs: minimum number of LEBs required for the index
+ * @old_idx_sz: size of index on flash
+ * @calc_idx_sz: temporary variable which is used to calculate new index size
+ *               (contains accurate new index size at end of TNC commit start)
+ * @lst: lprops statistics
+ *
+ * @page_budget: budget for a page
+ * @inode_budget: budget for an inode
+ * @dent_budget: budget for a directory entry
+ *
+ * @ref_node_alsz: size of the LEB reference node aligned to the min. flash
+ * I/O unit
+ * @mst_node_alsz: master node aligned size
+ * @min_idx_node_sz: minimum indexing node aligned on 8-bytes boundary
+ * @max_idx_node_sz: maximum indexing node aligned on 8-bytes boundary
+ * @max_inode_sz: maximum possible inode size in bytes
+ * @max_znode_sz: size of znode in bytes
+ * @dead_wm: LEB dead space watermark
+ * @dark_wm: LEB dark space watermark
+ * @block_cnt: count of 4KiB blocks on the FS
+ *
+ * @ranges: UBIFS node length ranges
+ * @ubi: UBI volume descriptor
+ * @di: UBI device information
+ * @vi: UBI volume information
+ *
+ * @orph_tree: rb-tree of orphan inode numbers
+ * @orph_list: list of orphan inode numbers in order added
+ * @orph_new: list of orphan inode numbers added since last commit
+ * @orph_cnext: next orphan to commit
+ * @orph_dnext: next orphan to delete
+ * @orphan_lock: lock for orph_tree and orph_new
+ * @orph_buf: buffer for orphan nodes
+ * @new_orphans: number of orphans since last commit
+ * @cmt_orphans: number of orphans being committed
+ * @tot_orphans: number of orphans in the rb_tree
+ * @max_orphans: maximum number of orphans allowed
+ * @ohead_lnum: orphan head LEB number
+ * @ohead_offs: orphan head offset
+ * @no_orphs: non-zero if there are no orphans
+ *
+ * @bgt: UBIFS background thread
+ * @bgt_name: background thread name
+ * @need_bgt: if background thread should run
+ * @need_wbuf_sync: if write-buffers have to be synchronized
+ *
+ * @gc_lnum: LEB number used for garbage collection
+ * @sbuf: a buffer of LEB size used by GC and replay for scanning
+ * @idx_gc: list of index LEBs that have been garbage collected
+ * @idx_gc_cnt: number of elements on the idx_gc list
+ *
+ * @infos_list: links all 'ubifs_info' objects
+ * @umount_mutex: serializes shrinker and un-mount
+ * @shrinker_run_no: shrinker run number
+ *
+ * @space_bits: number of bits needed to record free or dirty space
+ * @lpt_lnum_bits: number of bits needed to record a LEB number in the LPT
+ * @lpt_offs_bits: number of bits needed to record an offset in the LPT
+ * @lpt_spc_bits: number of bits needed to space in the LPT
+ * @pcnt_bits: number of bits needed to record pnode or nnode number
+ * @lnum_bits: number of bits needed to record LEB number
+ * @nnode_sz: size of on-flash nnode
+ * @pnode_sz: size of on-flash pnode
+ * @ltab_sz: size of on-flash LPT lprops table
+ * @lsave_sz: size of on-flash LPT save table
+ * @pnode_cnt: number of pnodes
+ * @nnode_cnt: number of nnodes
+ * @lpt_hght: height of the LPT
+ * @pnodes_have: number of pnodes in memory
+ *
+ * @lp_mutex: protects lprops table and all the other lprops-related fields
+ * @lpt_lnum: LEB number of the root nnode of the LPT
+ * @lpt_offs: offset of the root nnode of the LPT
+ * @nhead_lnum: LEB number of LPT head
+ * @nhead_offs: offset of LPT head
+ * @lpt_drty_flgs: dirty flags for LPT special nodes e.g. ltab
+ * @dirty_nn_cnt: number of dirty nnodes
+ * @dirty_pn_cnt: number of dirty pnodes
+ * @lpt_sz: LPT size
+ * @lpt_nod_buf: buffer for an on-flash nnode or pnode
+ * @lpt_buf: buffer of LEB size used by LPT
+ * @nroot: address in memory of the root nnode of the LPT
+ * @lpt_cnext: next LPT node to commit
+ * @lpt_heap: array of heaps of categorized lprops
+ * @dirty_idx: a (reverse sorted) copy of the LPROPS_DIRTY_IDX heap as at
+ *             previous commit start
+ * @uncat_list: list of un-categorized LEBs
+ * @empty_list: list of empty LEBs
+ * @freeable_list: list of freeable non-index LEBs (free + dirty == leb_size)
+ * @frdi_idx_list: list of freeable index LEBs (free + dirty == leb_size)
+ * @freeable_cnt: number of freeable LEBs in @freeable_list
+ *
+ * @ltab_lnum: LEB number of LPT's own lprops table
+ * @ltab_offs: offset of LPT's own lprops table
+ * @ltab: LPT's own lprops table
+ * @ltab_cmt: LPT's own lprops table (commit copy)
+ * @lsave_cnt: number of LEB numbers in LPT's save table
+ * @lsave_lnum: LEB number of LPT's save table
+ * @lsave_offs: offset of LPT's save table
+ * @lsave: LPT's save table
+ * @lscan_lnum: LEB number of last LPT scan
+ *
+ * @rp_size: size of the reserved pool in bytes
+ * @report_rp_size: size of the reserved pool reported to userspace
+ * @rp_uid: reserved pool user ID
+ * @rp_gid: reserved pool group ID
+ *
+ * @empty: if the UBI device is empty
+ * @replay_tree: temporary tree used during journal replay
+ * @replay_list: temporary list used during journal replay
+ * @replay_buds: list of buds to replay
+ * @cs_sqnum: sequence number of first node in the log (commit start node)
+ * @replay_sqnum: sequence number of node currently being replayed
+ * @need_recovery: file-system needs recovery
+ * @replaying: set to %1 during journal replay
+ * @unclean_leb_list: LEBs to recover when mounting ro to rw
+ * @rcvrd_mst_node: recovered master node to write when mounting ro to rw
+ * @size_tree: inode size information for recovery
+ * @recovery_needs_commit: a commit must be done before unmounting
+ * @remounting_rw: set while remounting from ro to rw (sb flags have MS_RDONLY)
+ * @mount_opts: UBIFS-specific mount options
+ *
+ * @dbg_buf: a buffer of LEB size used for debugging purposes
+ * @old_zroot: old index root - used by 'dbg_check_old_index()'
+ * @old_zroot_level: old index root level - used by 'dbg_check_old_index()'
+ * @old_zroot_sqnum: old index root sqnum - used by 'dbg_check_old_index()'
+ * @failure_mode: failure mode for recovery testing
+ */
+struct ubifs_info {
+	struct super_block *vfs_sb;
+
+	ino_t highest_inum;
+	unsigned int vfs_gen;
+	unsigned long long max_sqnum;
+	unsigned long long cmt_no;
+	spinlock_t cnt_lock;
+	int fmt_vers;
+
+	int lhead_lnum;
+	int lhead_offs;
+	int ltail_lnum;
+	struct mutex log_mutex;
+	int min_log_bytes;
+	long long cmt_bud_bytes;
+
+	struct rb_root buds;
+	long long bud_bytes;
+	spinlock_t buds_lock;
+	int jhead_cnt;
+	struct ubifs_jhead *jheads;
+	long long max_bud_bytes;
+	long long bg_bud_bytes;
+	struct list_head old_buds;
+	int max_bud_cnt;
+
+	struct rw_semaphore commit_sem;
+	int cmt_state;
+	spinlock_t cs_lock;
+	wait_queue_head_t cmt_wq;
+	unsigned int fast_unmount:1;
+	unsigned int big_lpt:1;
+
+	struct mutex tnc_mutex;
+	struct ubifs_zbranch zroot;
+	struct ubifs_znode *cnext;
+	struct ubifs_znode *enext;
+	int *gap_lebs;
+	void *cbuf;
+	void *ileb_buf;
+	int ileb_len;
+	int ihead_lnum;
+	int ihead_offs;
+	int *ilebs;
+	int ileb_cnt;
+	int ileb_nxt;
+	struct rb_root old_idx;
+	int *bottom_up_buf;
+#ifdef CONFIG_UBIFS_FS_DEBUG
+	int new_ihead_lnum;
+	int new_ihead_offs;
+#endif
+
+	struct ubifs_mst_node *mst_node;
+	int mst_offs;
+	struct mutex mst_mutex;
+
+	int log_lebs;
+	long long log_bytes;
+	int log_last;
+	int lpt_lebs;
+	int lpt_first;
+	int lpt_last;
+	int orph_lebs;
+	int orph_first;
+	int orph_last;
+	int main_lebs;
+	int main_first;
+	long long main_bytes;
+	int default_compr;
+
+	uint8_t key_hash_type;
+	uint32_t (*key_hash)(const char *str, int len);
+	int key_fmt;
+	int key_len;
+	int fanout;
+
+	int min_io_size;
+	int min_io_shift;
+	int leb_size;
+	int half_leb_size;
+	int leb_cnt;
+	int max_leb_cnt;
+	int old_leb_cnt;
+	int ro_media;
+
+	atomic_long_t dirty_pg_cnt;
+	atomic_long_t dirty_ino_cnt;
+	atomic_long_t dirty_zn_cnt;
+	atomic_long_t clean_zn_cnt;
+
+	long long budg_idx_growth;
+	long long budg_data_growth;
+	long long budg_dd_growth;
+	long long budg_uncommitted_idx;
+	spinlock_t space_lock;
+	int min_idx_lebs;
+	unsigned long long old_idx_sz;
+	unsigned long long calc_idx_sz;
+	struct ubifs_lp_stats lst;
+
+	int page_budget;
+	int inode_budget;
+	int dent_budget;
+
+	int ref_node_alsz;
+	int mst_node_alsz;
+	int min_idx_node_sz;
+	int max_idx_node_sz;
+	long long max_inode_sz;
+	int max_znode_sz;
+	int dead_wm;
+	int dark_wm;
+	int block_cnt;
+
+	struct ubifs_node_range ranges[UBIFS_NODE_TYPES_CNT];
+	struct ubi_volume_desc *ubi;
+	struct ubi_device_info di;
+	struct ubi_volume_info vi;
+
+	struct rb_root orph_tree;
+	struct list_head orph_list;
+	struct list_head orph_new;
+	struct ubifs_orphan *orph_cnext;
+	struct ubifs_orphan *orph_dnext;
+	spinlock_t orphan_lock;
+	void *orph_buf;
+	int new_orphans;
+	int cmt_orphans;
+	int tot_orphans;
+	int max_orphans;
+	int ohead_lnum;
+	int ohead_offs;
+	int no_orphs;
+
+	struct task_struct *bgt;
+	char bgt_name[sizeof(BGT_NAME_PATTERN) + 9];
+	int need_bgt;
+	int need_wbuf_sync;
+
+	int gc_lnum;
+	void *sbuf;
+	struct list_head idx_gc;
+	int idx_gc_cnt;
+
+	struct list_head infos_list;
+	struct mutex umount_mutex;
+	unsigned int shrinker_run_no;
+
+	int space_bits;
+	int lpt_lnum_bits;
+	int lpt_offs_bits;
+	int lpt_spc_bits;
+	int pcnt_bits;
+	int lnum_bits;
+	int nnode_sz;
+	int pnode_sz;
+	int ltab_sz;
+	int lsave_sz;
+	int pnode_cnt;
+	int nnode_cnt;
+	int lpt_hght;
+	int pnodes_have;
+
+	struct mutex lp_mutex;
+	int lpt_lnum;
+	int lpt_offs;
+	int nhead_lnum;
+	int nhead_offs;
+	int lpt_drty_flgs;
+	int dirty_nn_cnt;
+	int dirty_pn_cnt;
+	long long lpt_sz;
+	void *lpt_nod_buf;
+	void *lpt_buf;
+	struct ubifs_nnode *nroot;
+	struct ubifs_cnode *lpt_cnext;
+	struct ubifs_lpt_heap lpt_heap[LPROPS_HEAP_CNT];
+	struct ubifs_lpt_heap dirty_idx;
+	struct list_head uncat_list;
+	struct list_head empty_list;
+	struct list_head freeable_list;
+	struct list_head frdi_idx_list;
+	int freeable_cnt;
+
+	int ltab_lnum;
+	int ltab_offs;
+	struct ubifs_lpt_lprops *ltab;
+	struct ubifs_lpt_lprops *ltab_cmt;
+	int lsave_cnt;
+	int lsave_lnum;
+	int lsave_offs;
+	int *lsave;
+	int lscan_lnum;
+
+	long long rp_size;
+	long long report_rp_size;
+	uid_t rp_uid;
+	gid_t rp_gid;
+
+	/* The below fields are used only during mounting and re-mounting */
+	int empty;
+	struct rb_root replay_tree;
+	struct list_head replay_list;
+	struct list_head replay_buds;
+	unsigned long long cs_sqnum;
+	unsigned long long replay_sqnum;
+	int need_recovery;
+	int replaying;
+	struct list_head unclean_leb_list;
+	struct ubifs_mst_node *rcvrd_mst_node;
+	struct rb_root size_tree;
+	int recovery_needs_commit;
+	int remounting_rw;
+	struct ubifs_mount_opts mount_opts;
+
+#ifdef CONFIG_UBIFS_FS_DEBUG
+	void *dbg_buf;
+	struct ubifs_zbranch old_zroot;
+	int old_zroot_level;
+	unsigned long long old_zroot_sqnum;
+	int failure_mode;
+#endif
+};
+
+extern struct list_head ubifs_infos;
+extern spinlock_t ubifs_infos_lock;
+extern atomic_long_t ubifs_clean_zn_cnt;
+extern struct kmem_cache *ubifs_inode_slab;
+extern struct super_operations ubifs_super_operations;
+extern struct address_space_operations ubifs_file_address_operations;
+extern struct file_operations ubifs_file_operations;
+extern struct inode_operations ubifs_file_inode_operations;
+extern struct file_operations ubifs_dir_operations;
+extern struct inode_operations ubifs_dir_inode_operations;
+extern struct inode_operations ubifs_symlink_inode_operations;
+extern struct backing_dev_info ubifs_backing_dev_info;
+extern struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_TYPES_CNT];
+
+/* io.c */
+int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len);
+int ubifs_wbuf_seek_nolock(struct ubifs_wbuf *wbuf, int lnum, int offs,
+			   int dtype);
+int ubifs_wbuf_init(struct ubifs_info *c, struct ubifs_wbuf *wbuf);
+int ubifs_read_node(const struct ubifs_info *c, void *buf, int type, int len,
+		    int lnum, int offs);
+int ubifs_read_node_wbuf(struct ubifs_wbuf *wbuf, void *buf, int type, int len,
+			 int lnum, int offs);
+int ubifs_write_node(struct ubifs_info *c, void *node, int len, int lnum,
+		     int offs, int dtype);
+int ubifs_check_node(const struct ubifs_info *c, const void *buf, int lnum,
+		     int offs, int quiet);
+void ubifs_prepare_node(struct ubifs_info *c, void *buf, int len, int pad);
+void ubifs_prep_grp_node(struct ubifs_info *c, void *node, int len, int last);
+int ubifs_io_init(struct ubifs_info *c);
+void ubifs_pad(const struct ubifs_info *c, void *buf, int pad);
+int ubifs_wbuf_sync_nolock(struct ubifs_wbuf *wbuf);
+int ubifs_bg_wbufs_sync(struct ubifs_info *c);
+void ubifs_wbuf_add_ino_nolock(struct ubifs_wbuf *wbuf, ino_t inum);
+int ubifs_sync_wbufs_by_inodes(struct ubifs_info *c,
+			       struct inode * const *inodes, int count);
+
+/* scan.c */
+struct ubifs_scan_leb *ubifs_scan(const struct ubifs_info *c, int lnum,
+				  int offs, void *sbuf);
+void ubifs_scan_destroy(struct ubifs_scan_leb *sleb);
+int ubifs_scan_a_node(const struct ubifs_info *c, void *buf, int len, int lnum,
+		      int offs, int quiet);
+struct ubifs_scan_leb *ubifs_start_scan(const struct ubifs_info *c, int lnum,
+					int offs, void *sbuf);
+void ubifs_end_scan(const struct ubifs_info *c, struct ubifs_scan_leb *sleb,
+		    int lnum, int offs);
+int ubifs_add_snod(const struct ubifs_info *c, struct ubifs_scan_leb *sleb,
+		   void *buf, int offs);
+void ubifs_scanned_corruption(const struct ubifs_info *c, int lnum, int offs,
+			      void *buf);
+
+/* log.c */
+void ubifs_add_bud(struct ubifs_info *c, struct ubifs_bud *bud);
+void ubifs_create_buds_lists(struct ubifs_info *c);
+int ubifs_add_bud_to_log(struct ubifs_info *c, int jhead, int lnum, int offs);
+struct ubifs_bud *ubifs_search_bud(struct ubifs_info *c, int lnum);
+struct ubifs_wbuf *ubifs_get_wbuf(struct ubifs_info *c, int lnum);
+int ubifs_log_start_commit(struct ubifs_info *c, int *ltail_lnum);
+int ubifs_log_end_commit(struct ubifs_info *c, int new_ltail_lnum);
+int ubifs_log_post_commit(struct ubifs_info *c, int old_ltail_lnum);
+int ubifs_consolidate_log(struct ubifs_info *c);
+
+/* journal.c */
+int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
+		     const struct qstr *nm, const struct inode *inode,
+		     int deletion, int sync, int xent);
+int ubifs_jnl_write_data(struct ubifs_info *c, const struct inode *inode,
+			 const union ubifs_key *key, const void *buf, int len);
+int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode,
+			  int last_reference, int sync);
+int ubifs_jnl_rename(struct ubifs_info *c, const struct inode *old_dir,
+		     const struct dentry *old_dentry,
+		     const struct inode *new_dir,
+		     const struct dentry *new_dentry, int sync);
+int ubifs_jnl_truncate(struct ubifs_info *c, ino_t inum,
+		       loff_t old_size, loff_t new_size);
+int ubifs_jnl_delete_xattr(struct ubifs_info *c, const struct inode *host,
+			   const struct inode *inode, const struct qstr *nm,
+			   int sync);
+int ubifs_jnl_write_2_inodes(struct ubifs_info *c, const struct inode *inode1,
+			     const struct inode *inode2, int sync);
+
+/* budget.c */
+int ubifs_budget_space(struct ubifs_info *c, struct ubifs_budget_req *req);
+void ubifs_release_budget(struct ubifs_info *c, struct ubifs_budget_req *req);
+int ubifs_budget_inode_op(struct ubifs_info *c, struct inode *inode,
+			  struct ubifs_budget_req *req);
+void ubifs_release_ino_dirty(struct ubifs_info *c, struct inode *inode,
+				struct ubifs_budget_req *req);
+void ubifs_cancel_ino_op(struct ubifs_info *c, struct inode *inode,
+			 struct ubifs_budget_req *req);
+int ubifs_budget_ino_cleaning(struct ubifs_info *c, struct inode *inode,
+			      struct ubifs_budget_req *req);
+void ubifs_release_ino_clean(struct ubifs_info *c, struct inode *inode,
+			     struct ubifs_budget_req *req);
+long long ubifs_budg_get_free_space(struct ubifs_info *c);
+int ubifs_calc_min_idx_lebs(struct ubifs_info *c);
+void ubifs_convert_page_budget(struct ubifs_info *c);
+void ubifs_release_new_page_budget(struct ubifs_info *c);
+long long ubifs_calc_available(const struct ubifs_info *c);
+
+/* find.c */
+int ubifs_find_free_space(struct ubifs_info *c, int min_space, int *free,
+			  int squeeze);
+int ubifs_find_free_leb_for_idx(struct ubifs_info *c);
+int ubifs_find_dirty_leb(struct ubifs_info *c, struct ubifs_lprops *ret_lp,
+			 int min_space, int pick_free);
+int ubifs_find_dirty_idx_leb(struct ubifs_info *c);
+int ubifs_save_dirty_idx_lnums(struct ubifs_info *c);
+
+/* tnc.c */
+int ubifs_tnc_lookup(struct ubifs_info *c, const union ubifs_key *key,
+		     void *node);
+int ubifs_tnc_locate(struct ubifs_info *c, const union ubifs_key *key,
+		     void *node, int *lnum, int *offs);
+int ubifs_tnc_lookup_nm(struct ubifs_info *c, const union ubifs_key *key,
+			void *node, const struct qstr *nm);
+int ubifs_tnc_add(struct ubifs_info *c, const union ubifs_key *key, int lnum,
+		  int offs, int len);
+int ubifs_tnc_replace(struct ubifs_info *c, const union ubifs_key *key,
+		      int old_lnum, int old_offs, int lnum, int offs, int len);
+int ubifs_tnc_add_nm(struct ubifs_info *c, const union ubifs_key *key,
+		     int lnum, int offs, int len, const struct qstr *nm);
+int ubifs_tnc_remove(struct ubifs_info *c, const union ubifs_key *key);
+int ubifs_tnc_remove_nm(struct ubifs_info *c, const union ubifs_key *key,
+			const struct qstr *nm);
+int ubifs_tnc_remove_range(struct ubifs_info *c, union ubifs_key *from_key,
+			   union ubifs_key *to_key);
+int ubifs_tnc_remove_ino(struct ubifs_info *c, ino_t inum);
+struct ubifs_dent_node *ubifs_tnc_next_ent(struct ubifs_info *c,
+					   union ubifs_key *key,
+					   const struct qstr *nm);
+void ubifs_tnc_close(struct ubifs_info *c);
+int ubifs_tnc_has_node(struct ubifs_info *c, union ubifs_key *key, int level,
+		       int lnum, int offs, int is_idx);
+int ubifs_dirty_idx_node(struct ubifs_info *c, union ubifs_key *key, int level,
+			 int lnum, int offs);
+int ubifs_validate_entry(struct ubifs_info *c,
+			 const struct ubifs_dent_node *dent);
+/* Shared by tnc.c for tnc_commit.c */
+void destroy_old_idx(struct ubifs_info *c);
+int is_idx_node_in_tnc(struct ubifs_info *c, union ubifs_key *key, int level,
+		       int lnum, int offs);
+int insert_old_idx_znode(struct ubifs_info *c, struct ubifs_znode *znode);
+
+/* tnc_misc.c */
+struct ubifs_znode *ubifs_tnc_levelorder_next(struct ubifs_znode *zr,
+					      struct ubifs_znode *znode);
+int ubifs_search_zbranch(const struct ubifs_info *c,
+			 const struct ubifs_znode *znode,
+			 const union ubifs_key *key, int *n);
+struct ubifs_znode *ubifs_tnc_postorder_first(struct ubifs_znode *znode);
+struct ubifs_znode *ubifs_tnc_postorder_next(struct ubifs_znode *znode);
+long ubifs_destroy_tnc_subtree(struct ubifs_znode *zr);
+
+/* tnc_commit.c */
+int ubifs_tnc_start_commit(struct ubifs_info *c, struct ubifs_zbranch *zroot);
+int ubifs_tnc_end_commit(struct ubifs_info *c);
+
+/* shrinker.c */
+int ubifs_shrinker(int nr_to_scan, gfp_t gfp_mask);
+
+/* commit.c */
+int ubifs_bg_thread(void *info);
+void ubifs_commit_required(struct ubifs_info *c);
+void ubifs_request_bg_commit(struct ubifs_info *c);
+int ubifs_run_commit(struct ubifs_info *c);
+void ubifs_recovery_commit(struct ubifs_info *c);
+int ubifs_gc_should_commit(struct ubifs_info *c);
+void ubifs_wait_for_commit(struct ubifs_info *c);
+
+/* master.c */
+int ubifs_read_master(struct ubifs_info *c);
+int ubifs_write_master(struct ubifs_info *c);
+
+/* sb.c */
+int ubifs_read_superblock(struct ubifs_info *c);
+struct ubifs_sb_node *ubifs_read_sb_node(struct ubifs_info *c);
+int ubifs_write_sb_node(struct ubifs_info *c, struct ubifs_sb_node *sup);
+
+/* replay.c */
+int ubifs_replay_journal(struct ubifs_info *c);
+
+/* gc.c */
+int ubifs_garbage_collect(struct ubifs_info *c, int anyway);
+int ubifs_gc_start_commit(struct ubifs_info *c);
+int ubifs_gc_end_commit(struct ubifs_info *c);
+void ubifs_destroy_idx_gc(struct ubifs_info *c);
+int ubifs_get_idx_gc_leb(struct ubifs_info *c);
+int ubifs_garbage_collect_leb(struct ubifs_info *c, struct ubifs_lprops *lp);
+
+/* orphan.c */
+int ubifs_add_orphan(struct ubifs_info *c, ino_t inum);
+void ubifs_delete_orphan(struct ubifs_info *c, ino_t inum);
+int ubifs_orphan_start_commit(struct ubifs_info *c);
+int ubifs_orphan_end_commit(struct ubifs_info *c);
+int ubifs_mount_orphans(struct ubifs_info *c, int unclean);
+
+/* lpt.c */
+int ubifs_calc_lpt_geom(struct ubifs_info *c);
+int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
+			  int *lpt_lebs, int *big_lpt);
+int ubifs_lpt_init(struct ubifs_info *c, int rd, int wr);
+struct ubifs_lprops *ubifs_lpt_lookup(struct ubifs_info *c, int lnum);
+struct ubifs_lprops *ubifs_lpt_lookup_dirty(struct ubifs_info *c, int lnum);
+int ubifs_lpt_scan_nolock(struct ubifs_info *c, int start_lnum, int end_lnum,
+			  ubifs_lpt_scan_callback scan_cb, void *data);
+
+/* Shared by lpt.c for lpt_commit.c */
+void ubifs_pack_lsave(struct ubifs_info *c, void *buf, int *lsave);
+void ubifs_pack_ltab(struct ubifs_info *c, void *buf,
+		     struct ubifs_lpt_lprops *ltab);
+void ubifs_pack_pnode(struct ubifs_info *c, void *buf,
+		      struct ubifs_pnode *pnode);
+void ubifs_pack_nnode(struct ubifs_info *c, void *buf,
+		      struct ubifs_nnode *nnode);
+struct ubifs_pnode *ubifs_get_pnode(struct ubifs_info *c,
+				    struct ubifs_nnode *parent, int iip);
+struct ubifs_nnode *ubifs_get_nnode(struct ubifs_info *c,
+				    struct ubifs_nnode *parent, int iip);
+int ubifs_read_nnode(struct ubifs_info *c, struct ubifs_nnode *parent, int iip);
+void ubifs_add_lpt_dirt(struct ubifs_info *c, int lnum, int dirty);
+void ubifs_add_nnode_dirt(struct ubifs_info *c, struct ubifs_nnode *nnode);
+uint32_t ubifs_unpack_bits(uint8_t **addr, int *pos, int nrbits);
+struct ubifs_nnode *ubifs_first_nnode(struct ubifs_info *c, int *hght);
+
+/* lpt_commit.c */
+int ubifs_lpt_start_commit(struct ubifs_info *c);
+int ubifs_lpt_end_commit(struct ubifs_info *c);
+int ubifs_lpt_post_commit(struct ubifs_info *c);
+void ubifs_lpt_free(struct ubifs_info *c, int wr_only);
+
+/* lprops.c */
+void ubifs_get_lprops(struct ubifs_info *c);
+const struct ubifs_lprops *ubifs_change_lp(struct ubifs_info *c,
+					   const struct ubifs_lprops *lp,
+					   int free, int dirty, int flags,
+					   int idx_gc_cnt);
+void ubifs_release_lprops(struct ubifs_info *c);
+void ubifs_get_lp_stats(struct ubifs_info *c, struct ubifs_lp_stats *stats);
+void ubifs_add_to_cat(struct ubifs_info *c, struct ubifs_lprops *lprops,
+		      int cat);
+void ubifs_replace_cat(struct ubifs_info *c, struct ubifs_lprops *old_lprops,
+		       struct ubifs_lprops *new_lprops);
+void ubifs_ensure_cat(struct ubifs_info *c, struct ubifs_lprops *lprops);
+int ubifs_categorize_lprops(const struct ubifs_info *c,
+			    const struct ubifs_lprops *lprops);
+int ubifs_change_one_lp(struct ubifs_info *c, int lnum, int free, int dirty,
+			int flags_set, int flags_clean, int idx_gc_cnt);
+int ubifs_update_one_lp(struct ubifs_info *c, int lnum, int free, int dirty,
+			int flags_set, int flags_clean);
+int ubifs_read_one_lp(struct ubifs_info *c, int lnum, struct ubifs_lprops *lp);
+const struct ubifs_lprops *ubifs_fast_find_free(struct ubifs_info *c);
+const struct ubifs_lprops *ubifs_fast_find_empty(struct ubifs_info *c);
+const struct ubifs_lprops *ubifs_fast_find_freeable(struct ubifs_info *c);
+const struct ubifs_lprops *ubifs_fast_find_frdi_idx(struct ubifs_info *c);
+
+/* file.c */
+int ubifs_fsync(struct file *file, struct dentry *dentry, int datasync);
+int ubifs_setattr(struct dentry *dentry, struct iattr *attr);
+
+/* dir.c */
+struct inode *ubifs_new_inode(struct ubifs_info *c, const struct inode *dir,
+			      int mode);
+int ubifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		  struct kstat *stat);
+
+/* xattr.c */
+int ubifs_setxattr(struct dentry *dentry, const char *name,
+		   const void *value, size_t size, int flags);
+ssize_t ubifs_getxattr(struct dentry *dentry, const char *name, void *buf,
+		       size_t size);
+ssize_t ubifs_listxattr(struct dentry *dentry, char *buffer, size_t size);
+int ubifs_removexattr(struct dentry *dentry, const char *name);
+
+/* super.c */
+struct inode *ubifs_iget(struct super_block *sb, unsigned long inum);
+
+/* recovery.c */
+int ubifs_recover_master_node(struct ubifs_info *c);
+int ubifs_write_rcvrd_mst_node(struct ubifs_info *c);
+struct ubifs_scan_leb *ubifs_recover_leb(struct ubifs_info *c, int lnum,
+					 int offs, void *sbuf, int grouped);
+struct ubifs_scan_leb *ubifs_recover_log_leb(struct ubifs_info *c, int lnum,
+					     int offs, void *sbuf);
+int ubifs_recover_inl_heads(const struct ubifs_info *c, void *sbuf);
+int ubifs_clean_lebs(const struct ubifs_info *c, void *sbuf);
+int ubifs_recover_gc_lnum(struct ubifs_info *c);
+int ubifs_recover_size_accum(struct ubifs_info *c, union ubifs_key *key,
+			     int deletion, loff_t new_size);
+int ubifs_recover_size(struct ubifs_info *c);
+void ubifs_destroy_size_tree(struct ubifs_info *c);
+
+/* ioctl.c */
+long ubifs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+void ubifs_set_inode_flags(struct inode *inode);
+#ifdef CONFIG_COMPAT
+long ubifs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+#endif
+
+/* compressor.c */
+int __init ubifs_compressors_init(void);
+void __exit ubifs_compressors_exit(void);
+void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int *out_len,
+		    int *compr_type);
+int ubifs_decompress(const void *buf, int len, void *out, int *out_len,
+		     int compr_type);
+
+#include "debug.h"
+#include "misc.h"
+#include "key.h"
+
+#endif /* !__UBIFS_H__ */
-- 
1.5.4.1


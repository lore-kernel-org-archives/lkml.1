Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbYDCRLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbYDCRLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759908AbYDCRKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:10:23 -0400
Received: from lazybastard.de ([212.112.238.170]:43585 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467AbYDCRKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:10:15 -0400
Message-Id: <20080401181332.853833003@logfs.org>
References: <20080401181308.512473173@logfs.org>
Date: Tue, 01 Apr 2008 20:13:08 +0200
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [patch 3/15] fs/logfs/logfs.h
From: joern@logfs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2008-04-02 16:29:12.813336657 +0200
+++ linux-2.6.24logfs/fs/logfs/logfs.h	2008-04-01 21:00:59.600247674 +0200
@@ -0,0 +1,555 @@
+/*
+ * fs/logfs/logfs.h
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ *
+ * Private header for logfs.
+ */
+#ifndef fs_logfs_logfs_h
+#define fs_logfs_logfs_h
+
+#define __CHECK_ENDIAN__
+
+#include <linux/crc32.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/mempool.h>
+#include <linux/pagemap.h>
+#include <linux/mtd/mtd.h>
+#include "logfs_abi.h"
+
+#define PG_zero			PG_owner_priv_1
+#define PageZero(page)		test_bit(PG_zero, &(page)->flags)
+#define SetPageZero(page)	set_bit(PG_zero, &(page)->flags)
+#define ClearPageZero(page)	clear_bit(PG_zero, &(page)->flags)
+
+/*
+ * There is no generic kernel btree library yet.  When such a thing gets
+ * introduced, this definition and the corresponding source file should
+ * get removed.
+ */
+struct btree_head {
+	struct btree_node *node;
+	int height;
+	void *null_ptr;
+};
+
+static inline void build_bug_on_needs_a_function(void)
+{
+	BUILD_BUG_ON(sizeof(struct logfs_object_header) != LOGFS_HEADERSIZE);
+	BUILD_BUG_ON(sizeof(struct logfs_segment_header)
+			!= LOGFS_SEGMENT_HEADERSIZE);
+}
+
+/* FIXME: This should really be somewhere in the 64bit area. */
+#define LOGFS_LINK_MAX		(1<<30)
+
+/*
+ * Private errno for accessed beyond end-of-file.  Only used internally to
+ * logfs.  If this ever gets exposed to userspace or even other parts of the
+ * kernel, it is a bug.  256 was chosen as a number sufficiently above all
+ * used errno #defines.
+ *
+ * It can be argued that this is a hack and should be replaced with something
+ * else.  My last attempt to do this failed spectacularly and there are more
+ * urgent problems that users actually care about.  This will remain for the
+ * moment.  Patches are welcome, of course.
+ */
+#define EOF			(512)
+
+/* Read-only filesystem */
+#define LOGFS_SB_FLAG_RO	1
+
+/* Write Control Flags */
+#define WF_LOCK		0x01	/* take write lock */
+#define WF_WRITE	0x02	/* write block */
+#define WF_DELETE	0x04	/* delete old block */
+#define WF_SYNC		0x08	/* sync every indirect block */
+#define WF_GC		0x10	/* GC write, move to GC list */
+
+/**
+ * struct logfs_area - area management information
+ *
+ * @a_sb:			the superblock this area belongs to
+ * @a_is_open:			1 if the area is currently open, else 0
+ * @a_segno:			segment number of area
+ * @a_used_bytes:		number of used bytes
+ * @a_ops:			area operations (either journal or ostore)
+ * @a_wbuf:			write buffer
+ * @a_erase_count:		erase count
+ * @a_level:			GC level
+ */
+struct logfs_area { /* a segment open for writing */
+	struct super_block *a_sb;
+	int	a_is_open;
+	u32	a_segno;
+	u32	a_used_bytes;
+	const struct logfs_area_ops *a_ops;
+	void			*a_wbuf;
+	u32	a_erase_count;
+	u8	a_level;
+};
+
+/**
+ * struct logfs_area_ops - area operations
+ *
+ * @get_free_segment:		fill area->ofs with the offset of a free segment
+ * @get_erase_count:		fill area->erase_count (needs area->ofs)
+ * @erase_segment:		erase and setup segment
+ * @finish_area:		flush buffers, etc.
+ */
+struct logfs_area_ops {
+	void	(*get_free_segment)(struct logfs_area *area);
+	void	(*get_erase_count)(struct logfs_area *area);
+	int	(*erase_segment)(struct logfs_area *area);
+	void	(*finish_area)(struct logfs_area *area);
+};
+
+/**
+ * struct logfs_device_ops - device access operations
+ *
+ * @read:			read from the device
+ * @write:			write to the device
+ * @erase:			erase part of the device
+ */
+struct logfs_device_ops {
+	s64 (*find_sb)(struct super_block *sb);
+	int (*read)(struct super_block *sb, loff_t ofs, size_t len, void *buf);
+	int (*write)(struct super_block *sb, loff_t ofs, size_t len, void *buf);
+	int (*erase)(struct super_block *sb, loff_t ofs, size_t len);
+	void (*sync)(struct super_block *sb);
+};
+
+/**
+ * struct gc_candidate - "candidate" segment to be garbage collected next
+ *
+ * @list:			list (either free of low)
+ * @segno:			segment number
+ * @valid:			number of valid bytes
+ * @erase_count:		erase count of segment
+ * @dist:			distance from tree root
+ *
+ * Candidates can be on two lists.  The free list contains electees rather
+ * than candidates - segments that no longer contain any valid data.  The
+ * low list contains candidates to be picked for GC.  It should be kept
+ * short.  It is not required to always pick a perfect candidate.  In the
+ * worst case GC will have to move more data than absolutely necessary.
+ */
+struct gc_candidate {
+	struct list_head list;
+	u64	gec;
+	u32	segno;
+	u32	valid;
+	u32	erase_count;
+	u8	dist;
+};
+
+/**
+ * struct candidate_list - list of similar candidates
+ */
+struct candidate_list {
+	struct list_head list;
+	int count;
+	int maxcount;
+	int sort_by_ec;
+};
+
+/**
+ * struct logfs_journal_entry - temporary structure used during journal scan
+ *
+ * @used:
+ * @version:			normalized version
+ * @len:			length
+ * @offset:			offset
+ */
+struct logfs_journal_entry {
+	int used;
+	s16 version;
+	u16 len;
+	u16 datalen;
+	u64 offset;
+};
+
+enum transaction_state {
+	CREATE_1 = 1,
+	CREATE_2,
+	UNLINK_1,
+	UNLINK_2,
+	CROSS_RENAME_1,
+	CROSS_RENAME_2,
+	TARGET_RENAME_1,
+	TARGET_RENAME_2,
+	TARGET_RENAME_3
+};
+
+/**
+ * struct logfs_transaction - essential fields to support atomic dirops
+ *
+ * @ino:			target inode
+ * @dir:			inode of directory containing dentry
+ * @pos:			pos of dentry in directory
+ */
+struct logfs_transaction {
+	enum transaction_state state;
+	u64	 ino;
+	u64	 dir;
+	u64	 pos;
+};
+
+/**
+ * struct logfs_shadow - old block in the shadow of a not-yet-committed new one
+ * @old_ofs:			offset of old block on medium
+ * @new_ofs:			offset of new block on medium
+ * @ino:			inode number
+ * @bix:			block index
+ * @old_len:			size of old block, including header
+ * @new_len:			size of new block, including header
+ * @level:			block level
+ */
+struct logfs_shadow {
+	u64 old_ofs;
+	u64 new_ofs;
+	u64 ino;
+	u64 bix;
+	int old_len;
+	int new_len;
+	u8 level;
+};
+
+/**
+ * struct shadow_tree
+ * @new:			shadows where old_ofs==0, indexed by new_ofs
+ * @old:			shadows where old_ofs!=0, indexed by old_ofs
+ */
+struct shadow_tree {
+	struct btree_head new;
+	struct btree_head old;
+};
+
+/**
+ * struct logfs_block - contains any block state
+ * @tree:			btree of shadows, indexed by old_ofs
+ */
+struct logfs_block {
+	struct list_head dirty_list;
+	struct shadow_tree shadow_tree;
+	struct page *page;
+	struct logfs_transaction *ta;
+};
+
+struct mtd_inode {
+	struct mtd_info *mtd;
+	long openers;
+	struct inode vfs_inode;
+};
+
+struct logfs_super {
+	struct mtd_inode *s_mtd;		/* underlying device */
+	struct block_device *s_bdev;		/* underlying device */
+	int	 s_sync;			/* sync on next io? */
+	const struct logfs_device_ops *s_devops;/* device access */
+	struct inode	*s_master_inode;	/* ifile */
+	long	 s_flags;
+	/* dir.c fields */
+	struct mutex s_dirop_mutex;		/* for creat/unlink/rename */
+	u64	 s_victim_ino;			/* used for atomic dir-ops */
+	u64	 s_rename_dir;			/* source directory ino */
+	u64	 s_rename_pos;			/* position of source dd */
+	/* gc.c fields */
+	long	 s_segsize;			/* size of a segment */
+	int	 s_segshift;			/* log2 of segment size */
+	long	 s_no_segs;			/* segments on device */
+	long	 s_no_blocks;			/* blocks per segment */
+	long	 s_writesize;			/* minimum write size */
+	int	 s_writeshift;			/* log2 of write size */
+	u64	 s_size;			/* filesystem size */
+	struct logfs_area *s_area[LOGFS_NO_AREAS];	/* open segment array */
+	u64	 s_gec;				/* global erase count */
+	u64	 s_sweeper;			/* current sweeper pos */
+	u8	 s_ifile_levels;		/* max level of ifile */
+	u8	 s_iblock_levels;		/* max level of regular files */
+	u8	 s_data_levels;			/* # of segments to leaf block*/
+	u8	 s_total_levels;		/* sum of above three */
+	struct candidate_list s_free_list;	/* 100% free segments */
+	struct candidate_list s_low_list[LOGFS_NO_AREAS];/* good candidates */
+	struct candidate_list s_ec_list;	/* wear level candidates */
+	struct btree_head s_reserved_segments;	/* sb, journal, bad, etc. */
+	struct list_head s_dirty_list;		/* list of dirty blocks */
+	struct list_head s_gc_dirty_list[LOGFS_NO_AREAS];/* blocks dirtied during GC */
+	/* inode.c fields */
+	spinlock_t s_ino_lock;			/* lock s_last_ino on 32bit */
+	u64	 s_last_ino;			/* highest ino used */
+	struct list_head s_freeing_list;	/* inodes being freed */
+	/* journal.c fields */
+	struct mutex s_journal_mutex;
+	void	*s_je;				/* journal entry to compress */
+	void	*s_compressed_je;		/* block to write to journal */
+	u64	 s_journal_seg[LOGFS_JOURNAL_SEGS]; /* journal segments */
+	u32	 s_journal_ec[LOGFS_JOURNAL_SEGS]; /* journal erasecounts */
+	u64	 s_last_version;
+	struct logfs_area *s_journal_area;	/* open journal segment */
+	struct logfs_journal_entry s_retired[JE_LAST+1]; /* for journal scan */
+	struct logfs_journal_entry s_speculative[JE_LAST+1]; /* dito */
+	struct logfs_journal_entry s_first;		/* dito */
+	int	 s_sum_index;			/* for the 12 summaries */
+	__be32	*s_bb_array;			/* bad segments */
+	/* readwrite.c fields */
+	struct mutex s_w_mutex;
+	struct page *s_write_page;		/* page under writeback now */
+	mempool_t *s_block_pool;		/* struct logfs_block pool */
+	mempool_t *s_shadow_pool;		/* struct logfs_shadow pool */
+	/*
+	 * Space accounting in LogFS:
+	 * - s_used_bytes specifies space used to store valid data objects.
+	 * - s_dirty_used_bytes is space used to store non-committed data
+	 *   objects.  Those objects have already been written themselves,
+	 *   but they don't become valid until all indirect blocks up to the
+	 *   journal have been written as well.
+	 * - s_dirty_free_bytes is space used to store the old copy of a
+	 *   replaced object, as long as the replacement is non-committed.
+	 *   In other words, it is the amount of space freed when all dirty
+	 *   blocks are written back.
+	 * - s_free_bytes is the amount of free space available for any
+	 *   purpose.
+	 * - s_root_reserve is the amount of free space available only to
+	 *   the root user.
+	 * - s_gc_reserve is currently a mess.
+	 */
+	u64	 s_free_bytes;			/* free space */
+	u64	 s_used_bytes;			/* used (valid) data */
+	u64	 s_dirty_free_bytes;		/* space freed on commit */
+	u64	 s_dirty_used_bytes;		/* space used on commit */
+	u64	 s_gc_reserve;			/* space reserved for GC */
+	u64	 s_root_reserve;	/* FIXME: currently unused */
+	u32	 s_bad_segments;		/* number of bad segments */
+};
+
+/**
+ * struct logfs_inode - in-memory inode
+ *
+ * @vfs_inode:			struct inode
+ * @li_data:			data pointers
+ * @li_used_bytes:		number of used bytes
+ * @li_freeing_list:		used to track inodes currently being freed
+ * @li_flags:			inode flags
+ */
+struct logfs_inode {
+	struct inode vfs_inode;
+	u64	li_data[LOGFS_EMBEDDED_FIELDS];
+	u64	li_used_bytes;
+	struct list_head li_freeing_list;
+	struct logfs_transaction *li_transaction;
+	struct shadow_tree li_shadow_tree;
+	u32	li_flags;
+	u8	li_height;
+};
+
+#define journal_for_each(__i) for (__i = 0; __i < LOGFS_JOURNAL_SEGS; __i++)
+#define for_each_area(__i) for (__i = 0; __i < LOGFS_NO_AREAS; __i++)
+
+/* compr.c */
+int logfs_compress(void *in, void *out, size_t inlen, size_t outlen);
+int logfs_uncompress(void *in, void *out, size_t inlen, size_t outlen);
+int __init logfs_compr_init(void);
+void logfs_compr_exit(void);
+
+/* dev_bdev.c */
+#ifdef CONFIG_BLOCK
+int logfs_get_sb_bdev(struct file_system_type *type, int flags,
+		const char *devname, struct vfsmount *mnt);
+
+static inline void logfs_put_bdev(struct block_device *bdev)
+{
+	if (bdev)
+		close_bdev_excl(bdev);
+}
+#else
+static inline int logfs_get_sb_bdev(struct file_system_type *type, int flags,
+		const char *devname, struct vfsmount *mnt)
+{
+	return -ENODEV;
+}
+
+static inline void logfs_put_bdev(struct block_device *bdev)
+{
+}
+#endif
+
+/* dev_mtd.c */
+#ifdef CONFIG_MTD
+int logfs_get_sb_mtd(struct file_system_type *type, int flags,
+		int mtdnr, struct vfsmount *mnt);
+void logfs_put_mtd(struct mtd_inode *mi);
+#else
+static inline int logfs_get_sb_mtd(struct file_system_type *type, int flags,
+		int mtdnr, struct vfsmount *mnt)
+{
+	return -ENODEV;
+}
+
+static inline void logfs_put_mtd(struct mtd_inode *mi)
+{
+}
+#endif
+
+/* dir.c */
+extern const struct inode_operations logfs_symlink_iops;
+extern const struct inode_operations logfs_dir_iops;
+extern const struct file_operations logfs_dir_fops;
+int logfs_replay_journal(struct super_block *sb);
+
+/* file.c */
+extern const struct inode_operations logfs_reg_iops;
+extern const struct file_operations logfs_reg_fops;
+extern const struct address_space_operations logfs_reg_aops;
+int logfs_readpage(struct file *file, struct page *page);
+int logfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+		unsigned long arg);
+int logfs_fsync(struct file *file, struct dentry *dentry, int datasync);
+
+/* gc.c */
+int logfs_safe_to_write_block(struct super_block *sb, u8 level);
+struct gc_candidate *get_best_cand(struct candidate_list *list);
+int add_free_segments_from_journal(struct super_block *sb,
+		struct logfs_je_free_segments *segs, int count);
+void logfs_dirty_for_gc(struct super_block *sb, struct logfs_block *block);
+void logfs_gc_pass(struct super_block *sb);
+int logfs_check_areas(struct super_block *sb);
+int logfs_init_gc(struct logfs_super *super);
+void logfs_cleanup_gc(struct logfs_super *super);
+
+/* inode.c */
+extern const struct super_operations logfs_super_operations;
+struct inode *logfs_iget(struct super_block *sb, ino_t ino, int *cookie);
+void logfs_iput(struct inode *inode, int cookie);
+struct inode *logfs_new_inode(struct inode *dir, int mode);
+struct inode *logfs_new_meta_inode(struct super_block *sb, u64 ino);
+int logfs_init_inode_cache(void);
+void logfs_destroy_inode_cache(void);
+int __logfs_write_inode(struct inode *inode, long flags);
+void __logfs_destroy_inode(struct inode *inode);
+void logfs_set_blocks(struct inode *inode, u64 no);
+
+/* journal.c */
+int logfs_write_anchor(struct inode *inode);
+int logfs_init_journal(struct super_block *sb);
+void logfs_cleanup_journal(struct super_block *sb);
+
+/* memtree.c */
+void btree_init(struct btree_head *head);
+void *btree_lookup(struct btree_head *head, u64 val);
+int btree_insert(struct btree_head *head, u64 val, void *ptr);
+void *btree_remove(struct btree_head *head, u64 val);
+int btree_merge(struct btree_head *target, struct btree_head *victim);
+void btree_visitor(struct btree_head *head, long opaque,
+		void (*func)(void *elem, long opaque, u64 val));
+void btree_grim_visitor(struct btree_head *head, long opaque,
+		void (*func)(void *elem, long opaque, u64 val));
+
+/* readwrite.c */
+void logfs_unpack_index(pgoff_t index, u64 *bix, u8 *level);
+void logfs_flush_dirty(struct super_block *sb, int sync);
+int logfs_inode_read(struct inode *inode, void *buf, size_t n, loff_t _pos);
+int logfs_inode_write(struct inode *inode, const void *buf, size_t count,
+		loff_t bix, long flags, struct logfs_transaction *ta,
+		struct shadow_tree *shadow_tree);
+int logfs_readpage_nolock(struct page *page);
+int logfs_write_buf(struct inode *inode, struct page *page,
+		struct logfs_transaction *ta, long flags);
+int logfs_delete(struct inode *inode, pgoff_t index,
+		struct shadow_tree *shadow_tree, struct logfs_transaction *ta);
+int logfs_rewrite_block(struct inode *inode, u64 bix, u64 ofs, int level,
+		long flags);
+int logfs_is_valid_block(struct super_block *sb, u64 ofs, u64 ino, u64 pos,
+		u8 level);
+int logfs_truncate(struct inode *inode, u64 size);
+u64 logfs_seek_hole(struct inode *inode, u64 bix);
+u64 logfs_seek_data(struct inode *inode, u64 bix);
+int logfs_init_rw(struct logfs_super *super);
+void logfs_cleanup_rw(struct logfs_super *super);
+
+/* segment.c */
+int logfs_erase_segment(struct super_block *sb, u32 ofs);
+int wbuf_read(struct super_block *sb, u64 ofs, size_t len, void *buf);
+int logfs_segment_read(struct inode *inode, struct page *page, u64 ofs, u64 bix,
+		u8 level);
+int logfs_segment_write(struct inode *inode, struct page *page,
+		struct logfs_shadow *shadow);
+int logfs_segment_delete(struct inode *inode, struct logfs_shadow *shadow);
+void logfs_buf_write(struct logfs_area *area, u64 ofs, void *data, size_t len);
+
+/* area handling */
+int logfs_init_areas(struct super_block *sb);
+void logfs_cleanup_areas(struct logfs_super *super);
+int logfs_open_area(struct logfs_area *area);
+void logfs_close_area(struct logfs_area *area);
+
+/* super.c */
+void logfs_crash_dump(struct super_block *sb);
+void *memchr_inv(const void *s, int c, size_t n);
+int logfs_statfs(struct dentry *dentry, struct kstatfs *stats);
+int logfs_get_sb_device(struct file_system_type *type, int flags,
+		struct mtd_inode *mtd, struct block_device *bdev,
+		const struct logfs_device_ops *devops, struct vfsmount *mnt);
+
+static inline struct logfs_super *logfs_super(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+static inline struct logfs_inode *logfs_inode(struct inode *inode)
+{
+	return container_of(inode, struct logfs_inode, vfs_inode);
+}
+
+static inline void logfs_set_ro(struct super_block *sb)
+{
+	logfs_super(sb)->s_flags |= LOGFS_SB_FLAG_RO;
+}
+
+#define LOGFS_BUG(sb) do {					\
+	struct super_block *__sb = sb;				\
+	logfs_crash_dump(__sb);					\
+	logfs_super(__sb)->s_flags |= LOGFS_SB_FLAG_RO;		\
+	BUG();							\
+} while (0)
+
+#define LOGFS_BUG_ON(condition, sb) \
+	do { if (unlikely(condition)) LOGFS_BUG((sb)); } while (0)
+
+static inline __be32 logfs_crc32(void *data, size_t len, size_t skip)
+{
+	return cpu_to_be32(crc32(~0, data+skip, len-skip));
+}
+
+static inline u8 logfs_type(struct inode *inode)
+{
+	return (inode->i_mode >> 12) & 15;
+}
+
+static inline pgoff_t logfs_index(struct super_block *sb, u64 pos)
+{
+	return pos >> sb->s_blocksize_bits;
+}
+
+static inline u64 dev_ofs(struct super_block *sb, u32 segno, u32 ofs)
+{
+	return ((u64)segno << logfs_super(sb)->s_segshift) + ofs;
+}
+
+static inline int device_read(struct super_block *sb, u32 segno, u32 ofs,
+		size_t len, void *buf)
+{
+	struct logfs_super *super = logfs_super(sb);
+
+	return super->s_devops->read(sb, dev_ofs(sb, segno, ofs), len, buf);
+}
+
+static inline struct logfs_block *logfs_block(struct page *page)
+{
+	return (void *)page->private;
+}
+
+#endif


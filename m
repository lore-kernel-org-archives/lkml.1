Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbXFCSrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbXFCSrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbXFCSrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:47:43 -0400
Received: from lazybastard.de ([212.112.238.170]:34677 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbXFCSrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:47:41 -0400
Date: Sun, 3 Jun 2007 20:43:03 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Cc: akpm@osdl.org, Sam Ravnborg <sam@ravnborg.org>,
       John Stoffel <john@stoffel.org>, David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Arnd Bergmann <arnd@arndb.de>,
       Willy Tarreau <w@1wt.eu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Dongjun Shin <djshin90@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Bill Davidsen <davidsen@tmr.com>, Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: [Patch 05/18] fs/logfs/logfs.h
Message-ID: <20070603184303.GF8952@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070603183845.GA8952@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-03-13 19:15:28.862769062 +0100
+++ linux-2.6.21logfs/fs/logfs/logfs.h	2007-06-03 19:34:07.000000000 +0200
@@ -0,0 +1,398 @@
+/*
+ * fs/logfs/logfs.h
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ *
+ * Private header for logfs.
+ */
+#ifndef fs_logfs_logfs_h
+#define fs_logfs_logfs_h
+
+#define __CHECK_ENDIAN__
+
+
+#include <linux/crc32.h>
+#include <linux/fs.h>
+#include <linux/kallsyms.h>
+#include <linux/kernel.h>
+#include <linux/logfs.h>
+#include <linux/pagemap.h>
+#include <linux/statfs.h>
+#include <linux/mtd/mtd.h>
+
+
+static inline void build_bug_on_needs_a_function(void)
+{
+	BUILD_BUG_ON(sizeof(struct logfs_object_header) != LOGFS_HEADERSIZE);
+	BUILD_BUG_ON(sizeof(struct logfs_segment_header) != LOGFS_HEADERSIZE);
+}
+
+
+/* FIXME: This should really be somewhere in the 64bit area. */
+#define LOGFS_LINK_MAX		(1<<30)
+
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
+ * moment.  Patches are wellcome, of course.
+ */
+#define EOF			(512)
+
+
+/* Read-only filesystem */
+#define LOGFS_SB_FLAG_RO	1
+
+
+/**
+ * struct logfs_area - area management information
+ *
+ * @a_sb:			the superblock this area belongs to
+ * @a_is_open:			1 if the area is currently open, else 0
+ * @a_segno:			segment number of area
+ * @a_used_objects:		number of used objects (XXX: should get removed)
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
+	u32	a_used_objects;
+	u32	a_used_bytes;
+	const struct logfs_area_ops *a_ops;
+	void			*a_wbuf;
+	u32	a_erase_count;
+	u8	a_level;
+};
+
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
+
+/**
+ * struct logfs_device_ops - device access operations
+ *
+ * @read:			read from the device
+ * @write:			write to the device
+ * @erase:			erase part of the device
+ */
+struct logfs_device_ops {
+	int (*read)(struct super_block *sb, loff_t ofs, size_t len, void *buf);
+	int (*write)(struct super_block *sb, loff_t ofs, size_t len, void *buf);
+	int (*erase)(struct super_block *sb, loff_t ofs, size_t len);
+};
+
+
+/**
+ * struct gc_candidate - "candidate" segment to be garbage collected next
+ *
+ * @list:			list (either free of low)
+ * @erase_count:		erase count of segment
+ * @valid:			number of valid bytes
+ * @write_time:			GEC at time of writing
+ * @segno:			segment number
+ *
+ * Candidates can be on two lists.  The free list contains electees rather
+ * than candidates - segments that no longer contain any valid data.  The
+ * low list contains candidates to be picked for GC.  It should be kept
+ * short.  It is not required to always pick a perfect candidate.  In the
+ * worst case GC will have to move more data than absolutely necessary.
+ */
+struct gc_candidate {
+	struct list_head list;
+	u32	erase_count;
+	u32	valid;
+	u64	write_time;
+	u32	segno;
+};
+
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
+	u64 offset;
+};
+
+
+struct logfs_super {
+	struct mtd_info	*s_mtd;			/* underlying device */
+	struct block_device *s_bdev;		/* underlying device */
+	const struct logfs_device_ops *s_devops;/* device access */
+	struct inode	*s_master_inode;	/* ifile */
+	struct inode	*s_dev_inode;		/* device caching */
+	long	 s_flags;
+	/* dir.c fields */
+	struct mutex s_victim_mutex;		/* only one victim at once */
+	u64	 s_victim_ino;			/* used for atomic dir-ops */
+	struct mutex s_rename_mutex;		/* only one rename at once */
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
+	struct list_head s_free_list;		/* 100% free segments */
+	struct list_head s_low_list;		/* low-resistance segments */
+	int	 s_free_count;			/* # of 100% free segments */
+	int	 s_low_count;			/* # of low-resistance segs */
+	struct btree_head s_reserved_segments;	/* sb, journal, bad, etc. */
+	/* inode.c fields */
+	spinlock_t s_ino_lock;			/* lock s_last_ino on 32bit */
+	u64	 s_last_ino;			/* highest ino used */
+	struct list_head s_freeing_list;	/* inodes being freed */
+	/* journal.c fields */
+	struct mutex s_log_mutex;
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
+	struct mutex s_r_mutex;
+	struct mutex s_w_mutex;
+	__be64	*s_rblock;
+	__be64	*s_wblock[LOGFS_MAX_LEVELS];
+	u64	 s_free_bytes;			/* number of free bytes */
+	u64	 s_used_bytes;			/* number of bytes used */
+	u64	 s_gc_reserve;
+	u64	 s_root_reserve;
+	u32	 s_bad_segments;		/* number of bad segments */
+};
+
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
+	u32	li_flags;
+	u8	li_height;
+};
+
+
+#define journal_for_each(__i) for (__i=0; __i<LOGFS_JOURNAL_SEGS; __i++)
+
+
+/* compr.c */
+int logfs_compress(void *in, void *out, size_t inlen, size_t outlen);
+int logfs_uncompress(void *in, void *out, size_t inlen, size_t outlen);
+int __init logfs_compr_init(void);
+void __exit logfs_compr_exit(void);
+
+
+/* dir.c */
+extern const struct inode_operations logfs_dir_iops;
+extern const struct file_operations logfs_dir_fops;
+int logfs_replay_journal(struct super_block *sb);
+
+
+/* file.c */
+extern const struct inode_operations logfs_reg_iops;
+extern const struct file_operations logfs_reg_fops;
+extern const struct address_space_operations logfs_reg_aops;
+
+
+/* gc.c */
+void logfs_gc_pass(struct super_block *sb);
+int logfs_init_gc(struct logfs_super *super);
+void logfs_cleanup_gc(struct logfs_super *super);
+
+
+/* inode.c */
+extern const struct super_operations logfs_super_operations;
+struct inode *logfs_iget(struct super_block *sb, ino_t ino, int *cookie);
+void logfs_iput(struct inode *inode, int cookie);
+struct inode *logfs_new_inode(struct inode *dir, int mode);
+struct inode *logfs_new_meta_inode(struct super_block *sb, u64 ino);
+int logfs_init_inode_cache(void);
+void logfs_destroy_inode_cache(void);
+int __logfs_write_inode(struct inode *inode, int lock);
+void __logfs_destroy_inode(struct inode *inode);
+
+
+/* journal.c */
+int logfs_write_anchor(struct inode *inode);
+int logfs_init_journal(struct super_block *sb);
+void logfs_cleanup_journal(struct super_block *sb);
+
+
+/* memtree.c */
+void btree_init(struct btree_head *head);
+void *btree_lookup(struct btree_head *head, long val);
+int btree_insert(struct btree_head *head, long val, void *ptr);
+int btree_remove(struct btree_head *head, long val);
+
+
+/* readwrite.c */
+int logfs_inode_read(struct inode *inode, void *buf, size_t n, loff_t _pos);
+int logfs_inode_write(struct inode *inode, const void *buf, size_t n,
+		loff_t pos, int lock);
+int logfs_readpage_nolock(struct page *page);
+int logfs_write_buf(struct inode *inode, pgoff_t index, void *buf);
+int logfs_delete(struct inode *inode, pgoff_t index);
+int logfs_rewrite_block(struct inode *inode, pgoff_t index, u64 ofs, int level);
+int logfs_is_valid_block(struct super_block *sb, u64 ofs, u64 ino, u64 pos);
+void logfs_truncate(struct inode *inode);
+u64 logfs_seek_data(struct inode *inode, u64 pos);
+int logfs_init_rw(struct logfs_super *super);
+void logfs_cleanup_rw(struct logfs_super *super);
+
+/* segment.c */
+int logfs_erase_segment(struct super_block *sb, u32 ofs);
+int wbuf_read(struct super_block *sb, u64 ofs, size_t len, void *buf);
+int logfs_segment_read(struct super_block *sb, void *buf, u64 ofs);
+s64 logfs_segment_write(struct inode *inode, void *buf, u64 pos, int level,
+		int alloc);
+int logfs_segment_delete(struct inode *inode, u64 ofs, u64 pos, int level);
+void logfs_set_blocks(struct inode *inode, u64 no);
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
+
+
+/* progs/fsck.c */
+#ifdef CONFIG_LOGFS_FSCK
+int logfs_fsck(struct super_block *sb);
+#else
+static inline int logfs_fsck(struct super_block *sb)
+{
+	return 0;
+}
+#endif
+
+
+/* progs/mkfs.c */
+int logfs_mkfs(struct super_block *sb, struct logfs_disk_super *ds);
+
+
+#define LOGFS_BUG(sb) do {					\
+	struct super_block *__sb = sb;				\
+	logfs_crash_dump(__sb);					\
+	logfs_super(__sb)->s_flags |= LOGFS_SB_FLAG_RO;		\
+	BUG();							\
+} while(0)
+
+#define LOGFS_BUG_ON(condition, sb) \
+	do { if (unlikely((condition)!=0)) LOGFS_BUG((sb)); } while(0)
+
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
+
+static inline __be32 logfs_crc32(void *data, size_t len, size_t skip)
+{
+	return cpu_to_be32(crc32(~0, data+skip, len-skip));
+}
+
+
+static inline u8 logfs_type(struct inode *inode)
+{
+	return (inode->i_mode >> 12) & 15;
+}
+
+
+static inline pgoff_t logfs_index(struct super_block *sb, u64 pos)
+{
+	return pos >> sb->s_blocksize_bits;
+}
+
+
+static inline u64 logfs_block_ofs(struct super_block *sb, u32 segno,
+		u32 blockno)
+{
+	return (segno << logfs_super(sb)->s_segshift)
+		+ (blockno << sb->s_blocksize_bits);
+}
+
+
+static inline u64 dev_ofs(struct super_block *sb, u32 segno, u32 ofs)
+{
+	return ((u64)segno << logfs_super(sb)->s_segshift) + ofs;
+}
+
+
+static inline int device_read(struct super_block *sb, u32 segno, u32 ofs,
+		size_t len, void *buf)
+{
+	struct logfs_super *super = logfs_super(sb);
+
+	return super->s_devops->read(sb, dev_ofs(sb, segno, ofs), len, buf);
+}
+
+
+#endif

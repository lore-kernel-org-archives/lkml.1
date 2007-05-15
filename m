Return-Path: <linux-kernel-owner+w=401wt.eu-S933165AbXEOPYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbXEOPYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 11:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbXEOPXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 11:23:52 -0400
Received: from lazybastard.de ([212.112.238.170]:52198 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbXEOPXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 11:23:44 -0400
Date: Tue, 15 May 2007 17:19:20 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Cc: akpm@osdl.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>,
       =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Subject: [PATCH] LogFS take three
Message-ID: <20070515151919.GA32510@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ I have put everyone that gave comments to the last patch on Cc:.  Hope
that doesn't offend anyone. ]


Add LogFS, a scalable flash filesystem.


Motivation 1:

Linux currently has 1-2 flash filesystems to choose from, JFFS2 and
YAFFS.  The latter has never made a serious attempt of kernel
integration, which may disqualify it to some.

The two main problems of JFFS2 are memory consumption and mount time.
Unlike most filesystems, there is no tree structure of any sorts on
the medium, so the complete medium needs to be scanned at mount time
and a tree structure kept in-memory while the filesystem is mounted.
With bigger devices, both mount time and memory consumption increase
linearly.

JFFS2 has recently gained summary support, which helps reduce mount
time by a constant factor.  Linear scalability remains.  YAFFS
appears to be better by a constant factor, yet still scales linearly.

LogFS has an on-medium tree, fairly similar to Ext2 in structure, so
mount times are O(1).  In absolute terms, the OLPC system has mount
times of ~3.3s for JFFS2 and ~60ms for LogFS.


Motivation 2:

Flash is becoming increasingly common in standard PC hardware.  Nearly
a dozen different manufacturers have announced Solid State Disks
(SSDs), the OLPC and the Intel Classmate no longer contain hard disks
and ASUS announced a flash-only Laptop series for regular consumers.
And that doesn't even mention the ubiquitous USB-Sticks, SD-Cards,
etc.

Flash behaves significantly different to hard disks.  In order to use
flash, the current standard practice is to add an emulation layer and
an old-fashioned hard disk filesystem.  As can be expected, this is
eating up some of the benefits flash can offer over hard disks.

In principle it is possible to achieve better performance with a flash
filesystem than with the current emulated approach.  In practice our
current flash filesystems are not even near that theoretical goal.
LogFS in its current state is already closer.

Signed-off-by: Jörn Engel <joern@wohnheim.fh-wedel.de>
---

 fs/Kconfig            |   26 +
 fs/Makefile           |    1 
 fs/logfs/Locking      |   45 ++
 fs/logfs/Makefile     |   14 
 fs/logfs/compr.c      |  107 ++++
 fs/logfs/dir.c        |  725 ++++++++++++++++++++++++++++++++
 fs/logfs/file.c       |   81 +++
 fs/logfs/gc.c         |  369 ++++++++++++++++
 fs/logfs/inode.c      |  521 +++++++++++++++++++++++
 fs/logfs/journal.c    |  731 ++++++++++++++++++++++++++++++++
 fs/logfs/logfs.h      |  373 ++++++++++++++++
 fs/logfs/memtree.c    |  267 ++++++++++++
 fs/logfs/progs/fsck.c |  332 ++++++++++++++
 fs/logfs/progs/mkfs.c |  334 +++++++++++++++
 fs/logfs/readwrite.c  | 1110 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/logfs/segment.c    |  553 ++++++++++++++++++++++++
 fs/logfs/super.c      |  419 ++++++++++++++++++
 include/linux/logfs.h |  477 +++++++++++++++++++++
 18 files changed, 6485 insertions(+)

--- linux-2.6.21logfs/fs/Kconfig~logfs	2007-05-10 19:07:24.000000000 +0200
+++ linux-2.6.21logfs/fs/Kconfig	2007-05-15 16:00:42.000000000 +0200
@@ -1351,6 +1351,32 @@ config JFFS2_CMODE_SIZE
 
 endchoice
 
+config LOGFS
+	tristate "Log Filesystem (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	select ZLIB_INFLATE
+	select ZLIB_DEFLATE
+	help
+	  Flash filesystem aimed to scale efficiently to large devices.
+	  In comparison to JFFS2 it offers significantly faster mount
+	  times and potentially less RAM usage, although the latter has
+	  not been measured yet.
+
+	  In its current state it is still very experimental and should
+	  not be used for other than testing purposes.
+
+	  If unsure, say N.
+
+config LOGFS_FSCK
+	bool "Run LogFS fsck at mount time"
+	depends on LOGFS
+	help
+	  Run a full filesystem check on every mount.  If any errors are
+	  found, mounting the filesystem will fail.  This is a debug option
+	  for developers.
+
+	  If unsure, say N.
+
 config CRAMFS
 	tristate "Compressed ROM file system support (cramfs)"
 	depends on BLOCK
--- linux-2.6.21logfs/fs/Makefile~logfs	2007-05-10 19:07:24.000000000 +0200
+++ linux-2.6.21logfs/fs/Makefile	2007-05-10 19:07:24.000000000 +0200
@@ -95,6 +95,7 @@ obj-$(CONFIG_NTFS_FS)		+= ntfs/
 obj-$(CONFIG_UFS_FS)		+= ufs/
 obj-$(CONFIG_EFS_FS)		+= efs/
 obj-$(CONFIG_JFFS2_FS)		+= jffs2/
+obj-$(CONFIG_LOGFS)		+= logfs/
 obj-$(CONFIG_AFFS_FS)		+= affs/
 obj-$(CONFIG_ROMFS_FS)		+= romfs/
 obj-$(CONFIG_QNX4FS_FS)		+= qnx4/
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/Makefile	2007-05-10 19:07:24.000000000 +0200
@@ -0,0 +1,14 @@
+obj-$(CONFIG_LOGFS)	+= logfs.o
+
+logfs-y	+= compr.o
+logfs-y	+= dir.o
+logfs-y	+= file.o
+logfs-y	+= gc.o
+logfs-y	+= inode.o
+logfs-y	+= journal.o
+logfs-y	+= memtree.o
+logfs-y	+= readwrite.o
+logfs-y	+= segment.o
+logfs-y	+= super.o
+logfs-y	+= progs/fsck.o
+logfs-y	+= progs/mkfs.o
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/logfs.h	2007-05-15 16:04:07.000000000 +0200
@@ -0,0 +1,373 @@
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
+/* FIXME: This should really be somewhere in the 64bit area. */
+#define LOGFS_LINK_MAX (1<<30)
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
+#define EOF	256
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
+	struct logfs_area_ops *a_ops;
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
+	struct inode	*s_master_inode;	/* ifile */
+	struct inode	*s_dev_inode;		/* device caching */
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
+	u64 li_data[LOGFS_EMBEDDED_FIELDS];
+	u64 li_used_bytes;
+	struct list_head li_freeing_list;
+	u32 li_flags;
+};
+
+
+#define journal_for_each(__i) for (__i=0; __i<LOGFS_JOURNAL_SEGS; __i++)
+
+
+/* compr.c */
+int logfs_memcpy(void *in, void *out, size_t inlen, size_t outlen);
+int logfs_compress(void *in, void *out, size_t inlen, size_t outlen);
+int logfs_uncompress(void *in, void *out, size_t inlen, size_t outlen);
+int __init logfs_compr_init(void);
+void __exit logfs_compr_exit(void);
+
+
+/* dir.c */
+extern struct inode_operations logfs_dir_iops;
+extern struct file_operations logfs_dir_fops;
+int logfs_replay_journal(struct super_block *sb);
+
+
+/* file.c */
+extern struct inode_operations logfs_reg_iops;
+extern struct file_operations logfs_reg_fops;
+extern struct address_space_operations logfs_reg_aops;
+
+int logfs_setattr(struct dentry *dentry, struct iattr *iattr);
+
+
+/* gc.c */
+void logfs_gc_pass(struct super_block *sb);
+int logfs_init_gc(struct logfs_super *super);
+void logfs_cleanup_gc(struct logfs_super *super);
+
+
+/* inode.c */
+extern struct super_operations logfs_super_operations;
+
+struct inode *logfs_iget(struct super_block *sb, ino_t ino, int *cookie);
+void logfs_iput(struct inode *inode, int cookie);
+struct inode *logfs_new_inode(struct inode *dir, int mode);
+struct inode *logfs_new_meta_inode(struct super_block *sb, u64 ino);
+int logfs_init_inode_cache(void);
+void logfs_destroy_inode_cache(void);
+int __logfs_write_inode(struct inode *inode);
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
+		loff_t pos);
+
+int logfs_readpage_nolock(struct page *page);
+int logfs_write_buf(struct inode *inode, pgoff_t index, void *buf);
+int logfs_delete(struct inode *inode, pgoff_t index);
+int logfs_rewrite_block(struct inode *inode, pgoff_t index, u64 ofs, int level);
+int logfs_is_valid_block(struct super_block *sb, u64 ofs, u64 ino, u64 pos);
+void logfs_truncate(struct inode *inode);
+u64 logfs_seek_data(struct inode *inode, u64 pos);
+
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
+void __logfs_set_blocks(struct inode *inode);
+/* area handling */
+int logfs_init_areas(struct super_block *sb);
+void logfs_cleanup_areas(struct logfs_super *super);
+int logfs_open_area(struct logfs_area *area);
+void logfs_close_area(struct logfs_area *area);
+
+/* super.c */
+int mtdread(struct super_block *sb, loff_t ofs, size_t len, void *buf);
+int mtdwrite(struct super_block *sb, loff_t ofs, size_t len, void *buf);
+int mtderase(struct super_block *sb, loff_t ofs, size_t len);
+void logfs_crash_dump(struct super_block *sb);
+int all_ff(void *buf, size_t len);
+int logfs_statfs(struct dentry *dentry, struct kstatfs *stats);
+
+
+/* progs/fsck.c */
+#ifdef CONFIG_LOGFS_FSCK
+int logfs_fsck(struct super_block *sb);
+#else
+#define logfs_fsck(sb) ({ 0; })
+#endif
+
+
+/* progs/mkfs.c */
+int logfs_mkfs(struct super_block *sb, struct logfs_disk_super *ds);
+
+
+#define LOGFS_BUG(sb) do {		\
+	struct super_block *__sb = sb;	\
+	logfs_crash_dump(__sb);		\
+	BUG();				\
+} while(0)
+
+#define LOGFS_BUG_ON(condition, sb) \
+	do { if (unlikely((condition)!=0)) LOGFS_BUG((sb)); } while(0)
+
+
+static inline struct logfs_super *LOGFS_SUPER(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+static inline struct logfs_inode *LOGFS_INODE(struct inode *inode)
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
+static inline pgoff_t logfs_index(u64 pos)
+{
+	return pos / LOGFS_BLOCKSIZE;
+}
+
+
+static inline u64 logfs_block_ofs(struct super_block *sb, u32 segno,
+		u32 blockno)
+{
+	return (segno << LOGFS_SUPER(sb)->s_segshift)
+		+ (blockno << sb->s_blocksize_bits);
+}
+
+
+static inline u64 dev_ofs(struct super_block *sb, u32 segno, u32 ofs)
+{
+	return ((u64)segno << LOGFS_SUPER(sb)->s_segshift) + ofs;
+}
+
+
+static inline int device_read(struct super_block *sb, u32 segno, u32 ofs,
+		size_t len, void *buf)
+{
+	return mtdread(sb, dev_ofs(sb, segno, ofs), len, buf);
+}
+
+
+#endif
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/compr.c	2007-05-10 19:07:24.000000000 +0200
@@ -0,0 +1,107 @@
+/*
+ * fs/logfs/compr.c	- compression routines
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ */
+#include "logfs.h"
+#include <linux/vmalloc.h>
+#include <linux/zlib.h>
+
+#define COMPR_LEVEL 3
+
+static DEFINE_MUTEX(compr_mutex);
+static struct z_stream_s stream;
+
+
+int logfs_memcpy(void *in, void *out, size_t inlen, size_t outlen)
+{
+	if (outlen < inlen)
+		return -EIO;
+	memcpy(out, in, inlen);
+	return inlen;
+}
+
+
+int logfs_compress(void *in, void *out, size_t inlen, size_t outlen)
+{
+	int err, ret;
+
+	ret = -EIO;
+	mutex_lock(&compr_mutex);
+	err = zlib_deflateInit(&stream, COMPR_LEVEL);
+	if (err != Z_OK)
+		goto error;
+
+	stream.next_in = in;
+	stream.avail_in = inlen;
+	stream.total_in = 0;
+	stream.next_out = out;
+	stream.avail_out = outlen;
+	stream.total_out = 0;
+
+	err = zlib_deflate(&stream, Z_FINISH);
+	if (err != Z_STREAM_END)
+		goto error;
+
+	err = zlib_deflateEnd(&stream);
+	if (err != Z_OK)
+		goto error;
+
+	if (stream.total_out >= stream.total_in)
+		goto error;
+
+	ret = stream.total_out;
+error:
+	mutex_unlock(&compr_mutex);
+	return ret;
+}
+
+
+int logfs_uncompress(void *in, void *out, size_t inlen, size_t outlen)
+{
+	int err, ret;
+
+	ret = -EIO;
+	mutex_lock(&compr_mutex);
+	err = zlib_inflateInit(&stream);
+	if (err != Z_OK)
+		goto error;
+
+	stream.next_in = in;
+	stream.avail_in = inlen;
+	stream.total_in = 0;
+	stream.next_out = out;
+	stream.avail_out = outlen;
+	stream.total_out = 0;
+
+	err = zlib_inflate(&stream, Z_FINISH);
+	if (err != Z_STREAM_END)
+		goto error;
+
+	err = zlib_inflateEnd(&stream);
+	if (err != Z_OK)
+		goto error;
+
+	ret = 0;
+error:
+	mutex_unlock(&compr_mutex);
+	return ret;
+}
+
+
+int __init logfs_compr_init(void)
+{
+	size_t size = max(zlib_deflate_workspacesize(),
+			zlib_inflate_workspacesize());
+	stream.workspace = vmalloc(size);
+	if (!stream.workspace)
+		return -ENOMEM;
+	return 0;
+}
+
+void __exit logfs_compr_exit(void)
+{
+	vfree(stream.workspace);
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/dir.c	2007-05-10 19:57:46.000000000 +0200
@@ -0,0 +1,725 @@
+/*
+ * fs/logfs/dir.c	- directory-related code
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ */
+#include "logfs.h"
+
+
+/*
+ * Atomic dir operations
+ *
+ * Directory operations are by default not atomic.  Dentries and Inodes are
+ * created/removed/altered in seperate operations.  Therefore we need to do
+ * a small amount of journaling.
+ *
+ * Create, link, mkdir, mknod and symlink all share the same function to do
+ * the work: __logfs_create.  This function works in two atomic steps:
+ * 1. allocate inode (remember in journal)
+ * 2. allocate dentry (clear journal)
+ *
+ * As we can only get interrupted between the two, we the inode we just
+ * created is simply stored in the anchor.  On next mount, if we were
+ * interrupted, we delete the inode.  From a users point of view the
+ * operation never happened.
+ *
+ * Unlink and rmdir also share the same function: unlink.  Again, this
+ * function works in two atomic steps
+ * 1. remove dentry (remember inode in journal)
+ * 2. unlink inode (clear journal)
+ *
+ * And again, on the next mount, if we were interrupted, we delete the inode.
+ * From a users point of view the operation succeeded.
+ *
+ * Rename is the real pain to deal with, harder than all the other methods
+ * combined.  Depending on the circumstances we can run into three cases.
+ * A "target rename" where the target dentry already existed, a "local
+ * rename" where both parent directories are identical or a "cross-directory
+ * rename" in the remaining case.
+ *
+ * Local rename is atomic, as the old dentry is simply rewritten with a new
+ * name.
+ *
+ * Cross-directory rename works in two steps, similar to __logfs_create and
+ * logfs_unlink:
+ * 1. Write new dentry (remember old dentry in journal)
+ * 2. Remove old dentry (clear journal)
+ *
+ * Here we remember a dentry instead of an inode.  On next mount, if we were
+ * interrupted, we delete the dentry.  From a users point of view, the
+ * operation succeeded.
+ *
+ * Target rename works in three atomic steps:
+ * 1. Attach old inode to new dentry (remember old dentry and new inode)
+ * 2. Remove old dentry (still remember the new inode)
+ * 3. Remove new inode
+ *
+ * Here we remember both an inode an a dentry.  If we get interrupted
+ * between steps 1 and 2, we delete both the dentry and the inode.  If
+ * we get interrupted between steps 2 and 3, we delete just the inode.
+ * In either case, the remaining objects are deleted on next mount.  From
+ * a users point of view, the operation succeeded.
+ */
+
+
+typedef int (*dir_callback)(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, loff_t pos);
+
+
+static inline void logfs_inc_count(struct inode *inode)
+{
+	inode->i_nlink++;
+	mark_inode_dirty(inode);
+}
+
+
+static inline void logfs_dec_count(struct inode *inode)
+{
+	inode->i_nlink--;
+	mark_inode_dirty(inode);
+}
+
+
+static int read_dir(struct inode *dir, struct logfs_disk_dentry *dd, loff_t pos)
+{
+	return logfs_inode_read(dir, dd, sizeof(*dd), pos);
+}
+
+
+static int write_dir(struct inode *dir, struct logfs_disk_dentry *dd,
+		loff_t pos)
+{
+	return logfs_inode_write(dir, dd, sizeof(*dd), pos);
+}
+
+
+static s64 dir_seek_data(struct inode *inode, s64 pos)
+{
+	s64 new_pos = logfs_seek_data(inode, pos);
+
+	return max(pos, new_pos - 1);
+}
+
+
+static int __logfs_dir_walk(struct inode *dir, struct dentry *dentry,
+		dir_callback handler, struct logfs_disk_dentry *dd, loff_t *pos)
+{
+	struct qstr *name = dentry ? &dentry->d_name : NULL;
+	int ret;
+
+	for (; ; (*pos)++) {
+		ret = read_dir(dir, dd, *pos);
+		if (ret == -EOF)
+			return 0;
+		if (ret == -ENODATA) {
+			/* deleted dentry */
+			*pos = dir_seek_data(dir, *pos);
+			continue;
+		}
+		if (ret)
+			return ret;
+		BUG_ON(dd->namelen == 0);
+
+		if (name) {
+			if (name->len != be16_to_cpu(dd->namelen))
+				continue;
+			if (memcmp(name->name, dd->name, name->len))
+				continue;
+		}
+
+		return handler(dir, dentry, dd, *pos);
+	}
+	return ret;
+}
+
+
+static int logfs_dir_walk(struct inode *dir, struct dentry *dentry,
+		dir_callback handler)
+{
+	struct logfs_disk_dentry dd;
+	loff_t pos = 0;
+
+	return __logfs_dir_walk(dir, dentry, handler, &dd, &pos);
+}
+
+
+static int logfs_lookup_handler(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, loff_t pos)
+{
+	struct inode *inode;
+
+	inode = iget(dir->i_sb, be64_to_cpu(dd->ino));
+	if (!inode)
+		return -EIO;
+	return PTR_ERR(d_splice_alias(inode, dentry));
+}
+
+
+static struct dentry *logfs_lookup(struct inode *dir, struct dentry *dentry,
+		struct nameidata *nd)
+{
+	return ERR_PTR(logfs_dir_walk(dir, dentry, logfs_lookup_handler));
+}
+
+
+/* unlink currently only makes the name length zero */
+static int logfs_unlink_handler(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, loff_t pos)
+{
+	return logfs_delete(dir, pos);
+}
+
+
+static int logfs_remove_inode(struct inode *inode)
+{
+	int ret;
+
+	inode->i_nlink--;
+	if (inode->i_mode & S_IFDIR)
+		inode->i_nlink--;
+	ret = __logfs_write_inode(inode);
+	LOGFS_BUG_ON(ret, inode->i_sb);
+	return ret;
+}
+
+
+static int logfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct logfs_super *super = LOGFS_SUPER(dir->i_sb);
+	struct inode *inode = dentry->d_inode;
+	int ret;
+
+	mutex_lock(&super->s_victim_mutex);
+	super->s_victim_ino = inode->i_ino;
+
+	if (inode->i_mode & S_IFDIR)
+		dir->i_nlink--;
+	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	ret = logfs_dir_walk(dir, dentry, logfs_unlink_handler);
+	super->s_victim_ino = 0;
+
+	if (!ret)
+		ret = logfs_remove_inode(inode);
+
+	mutex_unlock(&super->s_victim_mutex);
+	return ret;
+}
+
+
+static int logfs_empty_handler(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, loff_t pos)
+{
+	return -ENOTEMPTY;
+}
+static inline int logfs_empty_dir(struct inode *dir)
+{
+	return logfs_dir_walk(dir, NULL, logfs_empty_handler) == 0;
+}
+
+
+static int logfs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+
+	if (!logfs_empty_dir(inode))
+		return -ENOTEMPTY;
+
+	return logfs_unlink(dir, dentry);
+}
+
+
+/* FIXME: readdir currently has it's own dir_walk code.  I don't see a good
+ * way to combine the two copies */
+#define IMPLICIT_NODES 2
+static int __logfs_readdir(struct file *file, void *buf, filldir_t filldir)
+{
+	struct logfs_disk_dentry dd;
+	struct inode *dir = file->f_dentry->d_inode;
+	loff_t pos = file->f_pos - IMPLICIT_NODES;
+	int err;
+
+	BUG_ON(pos<0);
+	for (;; pos++) {
+		err = read_dir(dir, &dd, pos);
+		if (err == -EOF)
+			break;
+		if (err == -ENODATA) {
+			/* deleted dentry */
+			pos = dir_seek_data(dir, pos);
+			continue;
+		}
+		if (err)
+			return err;
+		BUG_ON(dd.namelen == 0);
+
+		if (filldir(buf, dd.name, be16_to_cpu(dd.namelen), pos,
+					be64_to_cpu(dd.ino), dd.type))
+			break;
+	}
+
+	file->f_pos = pos + IMPLICIT_NODES;
+	return 0;
+}
+
+
+static int logfs_readdir(struct file *file, void *buf, filldir_t filldir)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	ino_t pino = parent_ino(file->f_dentry);
+	int err;
+
+	if (file->f_pos < 0)
+		return -EINVAL;
+
+	if (file->f_pos == 0) {
+		if (filldir(buf, ".", 1, 1, inode->i_ino, DT_DIR) < 0)
+			return 0;
+		file->f_pos++;
+	}
+	if (file->f_pos == 1) {
+		if (filldir(buf, "..", 2, 2, pino, DT_DIR) < 0)
+			return 0;
+		file->f_pos++;
+	}
+
+	err = __logfs_readdir(file, buf, filldir);
+	return err;
+}
+
+
+static inline loff_t file_end(struct inode *inode)
+{
+	return (i_size_read(inode) + inode->i_sb->s_blocksize - 1)
+		>> inode->i_sb->s_blocksize_bits;
+}
+static void logfs_set_name(struct logfs_disk_dentry *dd, struct qstr *name)
+{
+	BUG_ON(name->len > LOGFS_MAX_NAMELEN);
+	dd->namelen = cpu_to_be16(name->len);
+	memcpy(dd->name, name->name, name->len);
+}
+static int logfs_write_dir(struct inode *dir, struct dentry *dentry,
+		struct inode *inode)
+{
+	struct logfs_disk_dentry dd;
+	int err;
+
+	memset(&dd, 0, sizeof(dd));
+	dd.ino = cpu_to_be64(inode->i_ino);
+	dd.type = logfs_type(inode);
+	logfs_set_name(&dd, &dentry->d_name);
+
+	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	/*
+	 * FIXME: the file size should actually get aligned when writing,
+	 * not when reading.
+	 */
+	err = write_dir(dir, &dd, file_end(dir));
+	if (err)
+		return err;
+	d_instantiate(dentry, inode);
+	return 0;
+}
+
+
+static int __logfs_create(struct inode *dir, struct dentry *dentry,
+		struct inode *inode, const char *dest, long destlen)
+{
+	struct logfs_super *super = LOGFS_SUPER(dir->i_sb);
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	int ret;
+
+	mutex_lock(&super->s_victim_mutex);
+	super->s_victim_ino = inode->i_ino;
+	if (inode->i_mode & S_IFDIR)
+		inode->i_nlink++;
+
+	if (dest) {
+		/* symlink */
+		ret = logfs_inode_write(inode, dest, destlen, 0);
+	} else {
+		/* creat/mkdir/mknod */
+		ret = __logfs_write_inode(inode);
+	}
+	super->s_victim_ino = 0;
+	if (ret) {
+		if (!dest)
+			li->li_flags |= LOGFS_IF_STILLBORN;
+		/* FIXME: truncate symlink */
+		inode->i_nlink--;
+		iput(inode);
+		goto out;
+	}
+
+	if (inode->i_mode & S_IFDIR)
+		dir->i_nlink++;
+	ret = logfs_write_dir(dir, dentry, inode);
+
+	if (ret) {
+		if (inode->i_mode & S_IFDIR)
+			dir->i_nlink--;
+		logfs_remove_inode(inode);
+		iput(inode);
+	}
+out:
+	mutex_unlock(&super->s_victim_mutex);
+	return ret;
+}
+
+
+static int logfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	struct inode *inode;
+
+	if (dir->i_nlink >= LOGFS_LINK_MAX)
+		return -EMLINK;
+
+	/*
+	 * FIXME: why do we have to fill in S_IFDIR, while the mode is
+	 * correct for mknod, creat, etc.?  Smells like the vfs *should*
+	 * do it for us but for some reason fails to do so.
+	 */
+	inode = logfs_new_inode(dir, S_IFDIR | mode);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	inode->i_op = &logfs_dir_iops;
+	inode->i_fop = &logfs_dir_fops;
+
+	return __logfs_create(dir, dentry, inode, NULL, 0);
+}
+
+
+static int logfs_create(struct inode *dir, struct dentry *dentry, int mode,
+		struct nameidata *nd)
+{
+	struct inode *inode;
+
+	inode = logfs_new_inode(dir, mode);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	inode->i_op = &logfs_reg_iops;
+	inode->i_fop = &logfs_reg_fops;
+	inode->i_mapping->a_ops = &logfs_reg_aops;
+
+	return __logfs_create(dir, dentry, inode, NULL, 0);
+}
+
+
+static int logfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
+		dev_t rdev)
+{
+	struct inode *inode;
+
+	BUG_ON(dentry->d_name.len > LOGFS_MAX_NAMELEN);
+
+	inode = logfs_new_inode(dir, mode);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	init_special_inode(inode, mode, rdev);
+
+	return __logfs_create(dir, dentry, inode, NULL, 0);
+}
+
+
+static struct inode_operations logfs_symlink_iops = {
+	.readlink	= generic_readlink,
+	.follow_link	= page_follow_link_light,
+};
+
+static int logfs_symlink(struct inode *dir, struct dentry *dentry,
+		const char *target)
+{
+	struct inode *inode;
+	size_t destlen = strlen(target) + 1;
+
+	if (destlen > dir->i_sb->s_blocksize)
+		return -ENAMETOOLONG;
+
+	inode = logfs_new_inode(dir, S_IFLNK | S_IRWXUGO);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	inode->i_op = &logfs_symlink_iops;
+	inode->i_mapping->a_ops = &logfs_reg_aops;
+
+	return __logfs_create(dir, dentry, inode, target, destlen);
+}
+
+
+static int logfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+{
+	return generic_permission(inode, mask, NULL);
+}
+
+
+static int logfs_link(struct dentry *old_dentry, struct inode *dir,
+		struct dentry *dentry)
+{
+	struct inode *inode = old_dentry->d_inode;
+
+	if (inode->i_nlink >= LOGFS_LINK_MAX)
+		return -EMLINK;
+
+	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	atomic_inc(&inode->i_count);
+	inode->i_nlink++;
+
+	return __logfs_create(dir, dentry, inode, NULL, 0);
+}
+
+
+static int logfs_nop_handler(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, loff_t pos)
+{
+	return 0;
+}
+
+
+static inline int logfs_get_dd(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, loff_t *pos)
+{
+	*pos = 0;
+	return __logfs_dir_walk(dir, dentry, logfs_nop_handler, dd, pos);
+}
+
+
+/* Easiest case, a local rename and the target doesn't exist.  Just change
+ * the name in the old dd.
+ */
+static int logfs_rename_local(struct inode *dir, struct dentry *old_dentry,
+		struct dentry *new_dentry)
+{
+	struct logfs_disk_dentry dd;
+	loff_t pos;
+	int err;
+
+	err = logfs_get_dd(dir, old_dentry, &dd, &pos);
+	if (err)
+		return err;
+
+	logfs_set_name(&dd, &new_dentry->d_name);
+	return write_dir(dir, &dd, pos);
+}
+
+
+static int logfs_delete_dd(struct inode *dir, struct logfs_disk_dentry *dd,
+		loff_t pos)
+{
+	int err;
+
+	err = read_dir(dir, dd, pos);
+
+	/*
+	 * Getting called with pos somewhere beyond eof is either a goofup
+	 * within this file or means someone maliciously edited the
+	 * (crc-protected) journal.
+	 */
+	LOGFS_BUG_ON(err == -EOF, dir->i_sb);
+	if (err)
+		return err;
+
+	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	if (dd->type == DT_DIR)
+		dir->i_nlink--;
+	return logfs_delete(dir, pos);
+}
+
+
+/*
+ * Cross-directory rename, target does not exist.  Just a little nasty.
+ * Create a new dentry in the target dir, then remove the old dentry,
+ * all the while taking care to remember our operation in the journal.
+ */
+static int logfs_rename_cross(struct inode *old_dir, struct dentry *old_dentry,
+		struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct logfs_super *super = LOGFS_SUPER(old_dir->i_sb);
+	struct logfs_disk_dentry dd;
+	loff_t pos;
+	int err;
+
+	/* 1. locate source dd */
+	err = logfs_get_dd(old_dir, old_dentry, &dd, &pos);
+	if (err)
+		return err;
+	mutex_lock(&super->s_rename_mutex);
+	super->s_rename_dir = old_dir->i_ino;
+	super->s_rename_pos = pos;
+
+	/*
+	 * FIXME: this cannot be right but it does "fix" a bug of i_count
+	 * dropping too low.  Needs more thought.
+	 */
+	atomic_inc(&old_dentry->d_inode->i_count);
+
+	/* 2. write target dd */
+	if (dd.type == DT_DIR)
+		new_dir->i_nlink++;
+	err = logfs_write_dir(new_dir, new_dentry, old_dentry->d_inode);
+	super->s_rename_dir = 0;
+	super->s_rename_pos = 0;
+	if (err)
+		goto out;
+
+	/* 3. remove source dd */
+	err = logfs_delete_dd(old_dir, &dd, pos);
+	LOGFS_BUG_ON(err, old_dir->i_sb);
+out:
+	mutex_unlock(&super->s_rename_mutex);
+	return err;
+}
+
+
+static int logfs_replace_inode(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, struct inode *inode)
+{
+	loff_t pos;
+	int err;
+
+	err = logfs_get_dd(dir, dentry, dd, &pos);
+	if (err)
+		return err;
+	dd->ino = cpu_to_be64(inode->i_ino);
+	dd->type = logfs_type(inode);
+
+	return write_dir(dir, dd, pos);
+}
+
+
+/* Target dentry exists - the worst case.  We need to attach the source
+ * inode to the target dentry, then remove the orphaned target inode and
+ * source dentry.
+ */
+static int logfs_rename_target(struct inode *old_dir, struct dentry *old_dentry,
+		struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct logfs_super *super = LOGFS_SUPER(old_dir->i_sb);
+	struct inode *old_inode = old_dentry->d_inode;
+	struct inode *new_inode = new_dentry->d_inode;
+	int isdir = S_ISDIR(old_inode->i_mode);
+	struct logfs_disk_dentry dd;
+	loff_t pos;
+	int err;
+
+	BUG_ON(isdir != S_ISDIR(new_inode->i_mode));
+	if (isdir) {
+		if (!logfs_empty_dir(new_inode))
+			return -ENOTEMPTY;
+	}
+
+	/* 1. locate source dd */
+	err = logfs_get_dd(old_dir, old_dentry, &dd, &pos);
+	if (err)
+		return err;
+
+	mutex_lock(&super->s_rename_mutex);
+	mutex_lock(&super->s_victim_mutex);
+	super->s_rename_dir = old_dir->i_ino;
+	super->s_rename_pos = pos;
+	super->s_victim_ino = new_inode->i_ino;
+
+	/* 2. attach source inode to target dd */
+	err = logfs_replace_inode(new_dir, new_dentry, &dd, old_inode);
+	super->s_rename_dir = 0;
+	super->s_rename_pos = 0;
+	if (err) {
+		super->s_victim_ino = 0;
+		goto out;
+	}
+
+	/* 3. remove source dd */
+	err = logfs_delete_dd(old_dir, &dd, pos);
+	LOGFS_BUG_ON(err, old_dir->i_sb);
+
+	/* 4. remove target inode */
+	super->s_victim_ino = 0;
+	err = logfs_remove_inode(new_inode);
+
+out:
+	mutex_unlock(&super->s_victim_mutex);
+	mutex_unlock(&super->s_rename_mutex);
+	return err;
+}
+
+
+static int logfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+		struct inode *new_dir, struct dentry *new_dentry)
+{
+	if (new_dentry->d_inode)
+		return logfs_rename_target(old_dir, old_dentry, new_dir, new_dentry);
+	else if (old_dir == new_dir)
+		return logfs_rename_local(old_dir, old_dentry, new_dentry);
+	return logfs_rename_cross(old_dir, old_dentry, new_dir, new_dentry);
+}
+
+
+/* No locking done here, as this is called before .get_sb() returns. */
+int logfs_replay_journal(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_disk_dentry dd;
+	struct inode *inode;
+	u64 ino, pos;
+	int err;
+
+	if (super->s_victim_ino) {
+		/* delete victim inode */
+		ino = super->s_victim_ino;
+		inode = iget(sb, ino);
+		if (!inode)
+			goto fail;
+
+		super->s_victim_ino = 0;
+		err = logfs_remove_inode(inode);
+		iput(inode);
+		if (err) {
+			super->s_victim_ino = ino;
+			goto fail;
+		}
+	}
+	if (super->s_rename_dir) {
+		/* delete old dd from rename */
+		ino = super->s_rename_dir;
+		pos = super->s_rename_pos;
+		inode = iget(sb, ino);
+		if (!inode)
+			goto fail;
+
+		super->s_rename_dir = 0;
+		super->s_rename_pos = 0;
+		err = logfs_delete_dd(inode, &dd, pos);
+		iput(inode);
+		if (err) {
+			super->s_rename_dir = ino;
+			super->s_rename_pos = pos;
+			goto fail;
+		}
+	}
+	return 0;
+fail:
+	LOGFS_BUG(sb);
+	return -EIO;
+}
+
+
+struct inode_operations logfs_dir_iops = {
+	.create		= logfs_create,
+	.link		= logfs_link,
+	.lookup		= logfs_lookup,
+	.mkdir		= logfs_mkdir,
+	.mknod		= logfs_mknod,
+	.rename		= logfs_rename,
+	.rmdir		= logfs_rmdir,
+	.permission	= logfs_permission,
+	.symlink	= logfs_symlink,
+	.unlink		= logfs_unlink,
+};
+struct file_operations logfs_dir_fops = {
+	.readdir	= logfs_readdir,
+	.read		= generic_read_dir,
+};
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/file.c	2007-05-10 19:46:21.000000000 +0200
@@ -0,0 +1,81 @@
+/*
+ * fs/logfs/file.c	- prepare_write, commit_write and friends
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ */
+#include "logfs.h"
+
+
+static int logfs_prepare_write(struct file *file, struct page *page,
+		unsigned start, unsigned end)
+{
+	if (PageUptodate(page))
+		return 0;
+
+	if ((start == 0) && (end == PAGE_CACHE_SIZE))
+		return 0;
+
+	return logfs_readpage_nolock(page);
+}
+
+
+static int logfs_commit_write(struct file *file, struct page *page,
+		unsigned start, unsigned end)
+{
+	struct inode *inode = page->mapping->host;
+	pgoff_t index = page->index;
+	void *buf;
+	int ret;
+
+	BUG_ON(PAGE_CACHE_SIZE != inode->i_sb->s_blocksize);
+	BUG_ON(page->index > I3_BLOCKS);
+
+	if (start == end)
+		return 0; /* FIXME: do we need to update inode? */
+
+	if (i_size_read(inode) < (index << PAGE_CACHE_SHIFT) + end) {
+		i_size_write(inode, (index << PAGE_CACHE_SHIFT) + end);
+		mark_inode_dirty(inode);
+	}
+
+	buf = kmap(page);
+	ret = logfs_write_buf(inode, index, buf);
+	kunmap(page);
+	return ret;
+}
+
+
+static int logfs_readpage(struct file *file, struct page *page)
+{
+	int ret;
+
+	ret = logfs_readpage_nolock(page);
+	unlock_page(page);
+	return ret;
+}
+
+
+struct inode_operations logfs_reg_iops = {
+	.truncate	= logfs_truncate,
+};
+
+
+struct file_operations logfs_reg_fops = {
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
+	.llseek		= generic_file_llseek,
+	.mmap		= generic_file_readonly_mmap,
+	.open		= generic_file_open,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+};
+
+
+struct address_space_operations logfs_reg_aops = {
+	.commit_write	= logfs_commit_write,
+	.prepare_write	= logfs_prepare_write,
+	.readpage	= logfs_readpage,
+	.set_page_dirty	= __set_page_dirty_nobuffers,
+};
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/gc.c	2007-05-14 23:01:11.000000000 +0200
@@ -0,0 +1,369 @@
+/*
+ * fs/logfs/gc.c	- garbage collection code
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ */
+#include "logfs.h"
+
+#if 0
+/*
+ * When deciding which segment to use next, calculate the resistance
+ * of each segment and pick the lowest.  Segments try to resist usage
+ * if
+ * o they are full,
+ * o they have a high erase count or
+ * o they have recently been written.
+ *
+ * Full segments should not get reused, as there is little space to
+ * gain from them.  Segments with high erase count should be left
+ * aside as they can wear out sooner than others.  Freshly-written
+ * segments contain many blocks that will get obsoleted fairly soon,
+ * so it helps to wait a little before reusing them.
+ *
+ * Total resistance is expressed in erase counts.  Formula is:
+ *
+ * R = EC + K1*F + K2*e^(-t/theta)
+ *
+ * R:	Resistance
+ * EC:	Erase count
+ * K1:	Constant, 10,000 might be a good value
+ * K2:	Constant,  1,000 might be a good value
+ * F:	Segment fill level
+ * t:	Time since segment was written to (in number of segments written)
+ * theta: Time constant.  Total number of segments might be a good value
+ *
+ * Since the kernel is not allowed to use floating point, the function
+ * decay() is used to approximate exponential decay in fixed point.
+ */
+static long decay(long t0, long t, long theta)
+{
+	long shift, fac;
+
+	if (t >= 32*theta)
+		return 0;
+
+	shift = t/theta;
+	fac = theta - (t%theta)/2;
+	return (t0 >> shift) * fac / theta;
+}
+#endif
+
+
+/* Only valid objects are accounted as valid bytes, including their headers */
+static u32 logfs_valid_bytes(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_object_header h;
+	u64 ofs, ino, pos;
+	u32 seg_ofs, valid, size;
+	void *reserved;
+	int i, err;
+
+	/* Some segments are reserved.  Just pretend they were all valid */
+	reserved = btree_lookup(&super->s_reserved_segments, segno);
+	if (reserved)
+		return super->s_segsize;
+
+	/* Currently open segments */
+	/* FIXME: just reserve open areas and remove this code */
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		struct logfs_area *area = super->s_area[i];
+		if (area->a_is_open && (area->a_segno == segno)) {
+			return super->s_segsize;
+		}
+	}
+
+	err = device_read(sb, segno, 0, sizeof(h), &h);
+	BUG_ON(err);
+	if (all_ff(&h, sizeof(h)))
+		return 0;
+
+	valid = 0;
+	for (seg_ofs = sizeof(h); seg_ofs + sizeof(h) < super->s_segsize; ) {
+		err = device_read(sb, segno, seg_ofs, sizeof(h), &h);
+		BUG_ON(err);
+		if (all_ff(&h, sizeof(h)))
+			break;
+
+		ofs = dev_ofs(sb, segno, seg_ofs);
+		ino = be64_to_cpu(h.ino);
+		pos = be64_to_cpu(h.pos);
+		size = (u32)be16_to_cpu(h.len) + sizeof(h);
+		if (logfs_is_valid_block(sb, ofs, ino, pos))
+			valid += size;
+		seg_ofs += size;
+	}
+	pr_debug(KERN_INFO "LOGFS valid(%x) = %x\n", segno, valid);
+	return valid;
+}
+
+
+static void logfs_cleanse_block(struct super_block *sb, u64 ofs, u64 ino,
+		u64 pos, int level)
+{
+	struct inode *inode;
+	int err, cookie;
+
+	inode = logfs_iget(sb, ino, &cookie);
+	BUG_ON(!inode);
+	err = logfs_rewrite_block(inode, pos, ofs, level);
+	BUG_ON(err);
+	logfs_iput(inode, cookie);
+}
+
+
+static void __logfs_gc_segment(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_object_header h;
+	struct logfs_segment_header *sh;
+	u64 ofs, ino, pos;
+	u32 seg_ofs;
+	int level, err;
+
+	err = device_read(sb, segno, 0, sizeof(h), &h);
+	BUG_ON(err);
+	sh = (void*)&h;
+	level = sh->level;
+
+	for (seg_ofs = sizeof(h); seg_ofs + sizeof(h) < super->s_segsize; ) {
+		ofs = dev_ofs(sb, segno, seg_ofs);
+		err = device_read(sb, segno, seg_ofs, sizeof(h), &h);
+		BUG_ON(err);
+		ino = be64_to_cpu(h.ino);
+		pos = be64_to_cpu(h.pos);
+		if (logfs_is_valid_block(sb, ofs, ino, pos))
+			logfs_cleanse_block(sb, ofs, ino, pos, level);
+		seg_ofs += sizeof(h);
+		seg_ofs += be16_to_cpu(h.len);
+	}
+}
+
+
+static void logfs_gc_segment(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int i;
+	void *reserved;
+
+	/* Some segments are reserved.  Just pretend they were all valid */
+	reserved = btree_lookup(&super->s_reserved_segments, segno);
+	LOGFS_BUG_ON(reserved, sb);
+
+	/* Currently open segments */
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		struct logfs_area *area = super->s_area[i];
+		BUG_ON(area->a_is_open && (area->a_segno == segno));
+	}
+	__logfs_gc_segment(sb, segno);
+}
+
+
+static void __add_segment(struct list_head *list, int *count, u32 segno,
+		int valid)
+{
+	struct gc_candidate *cand;
+
+	cand = kzalloc(sizeof(*cand), GFP_KERNEL);
+	if (!cand)
+		return;
+
+	cand->segno = segno;
+	cand->valid = valid;
+	list_add(&cand->list, list);
+	*count += 1;
+}
+
+
+static void add_segment(struct list_head *list, int *count, u32 segno,
+		int valid)
+{
+	struct gc_candidate *cand;
+
+	list_for_each_entry(cand, list, list)
+		if (cand->segno == segno)
+			return;
+	__add_segment(list, count, segno, valid);
+}
+
+
+static void del_segment(struct list_head *list, int *count, u32 segno)
+{
+	struct gc_candidate *cand;
+
+	list_for_each_entry(cand, list, list)
+		if (cand->segno == segno) {
+			list_del(&cand->list);
+			*count -= 1;
+			kfree(cand);
+			return;
+		}
+}
+
+
+static void add_free_segment(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	add_segment(&super->s_free_list, &super->s_free_count, segno, 0);
+}
+
+
+static void add_low_segment(struct super_block *sb, u32 segno, int valid)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	add_segment(&super->s_low_list, &super->s_low_count, segno, valid);
+}
+
+
+static void del_low_segment(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	del_segment(&super->s_low_list, &super->s_low_count, segno);
+}
+
+
+static void scan_segment(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	u32 full = super->s_segsize - LOGFS_SEGMENT_RESERVE;
+	int valid;
+
+	valid = logfs_valid_bytes(sb, segno);
+	if (valid == 0) {
+		del_low_segment(sb, segno);
+		add_free_segment(sb, segno);
+	} else if (valid < full)
+		add_low_segment(sb, segno, valid);
+}
+
+
+static void logfs_scan_pass(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int i;
+
+	for (i = super->s_sweeper+1; i != super->s_sweeper; i++) {
+		if (i >= super->s_no_segs)
+			i = 0;
+
+		scan_segment(sb, i);
+
+		if (super->s_free_count >= super->s_total_levels) {
+			super->s_sweeper = i;
+			return;
+		}
+	}
+	scan_segment(sb, super->s_sweeper);
+}
+
+
+static void logfs_gc_once(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct gc_candidate *cand, *next;
+	unsigned min_valid = super->s_segsize;
+	u32 segno;
+
+	BUG_ON(list_empty(&super->s_low_list));
+	list_for_each_entry_safe(cand, next, &super->s_low_list, list) {
+		if (cand->valid >= min_valid)
+			continue;
+		min_valid = cand->valid;
+		list_del(&cand->list);
+		list_add(&cand->list, &super->s_low_list);
+	}
+
+	cand = list_entry(super->s_low_list.next, struct gc_candidate, list);
+	list_del(&cand->list);
+	super->s_low_count -= 1;
+
+	segno = cand->segno;
+	logfs_gc_segment(sb, segno);
+	kfree(cand);
+	add_free_segment(sb, segno);
+}
+
+
+/* GC all the low-count segments.  If necessary, rescan the medium.
+ * If we made enough room, return */
+static void logfs_gc_several(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int rounds;
+
+	rounds = super->s_low_count;
+
+	for (; rounds; rounds--) {
+		if (super->s_free_count >= super->s_total_levels)
+			return;
+		if (super->s_free_count < 3)
+			logfs_scan_pass(sb);
+		logfs_gc_once(sb);
+	}
+}
+
+
+/*
+ * In principle, this function should loop forever, looking for GC candidates
+ * and moving data.  LogFS is designed in such a way that this loop is
+ * guaranteed to terminate.
+ *
+ * Limiting the loop to four iterations serves purely to catch cases when
+ * these guarantees have failed.  An actual endless loop is an obvious bug
+ * and should be reported as such.
+ *
+ * But there is another nasty twist to this.  As I have described in my LCA
+ * presentation, Garbage collection would have to limit itself to higher
+ * levels if the number of available free segments goes down.  This code
+ * doesn't and should fail spectacularly.  Yet - hard as I tried I haven't
+ * been able to make it fail (short of a bug elsewhere).
+ *
+ * So in a way this code is intentionally wrong as a desperate cry for a
+ * better testcase.  And I do expect to get blamed for it one day. :(
+ */
+void logfs_gc_pass(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int i;
+
+	for (i=4; i; i--) {
+		if (super->s_free_count >= super->s_total_levels)
+			return;
+		logfs_scan_pass(sb);
+
+		if (super->s_free_count >= super->s_total_levels)
+			return;
+		logfs_gc_several(sb);
+		cond_resched();
+	}
+	logfs_fsck(sb);
+	LOGFS_BUG(sb);
+}
+
+
+int logfs_init_gc(struct logfs_super *super)
+{
+	INIT_LIST_HEAD(&super->s_free_list);
+	INIT_LIST_HEAD(&super->s_low_list);
+	super->s_free_count = 0;
+	super->s_low_count = 0;
+
+	return 0;
+}
+
+
+void logfs_cleanup_gc(struct logfs_super *super)
+{
+	struct gc_candidate *cand, *next;
+
+	list_for_each_entry_safe(cand, next, &super->s_free_list, list) {
+		list_del(&cand->list);
+		kfree(cand);
+	}
+	list_for_each_entry_safe(cand, next, &super->s_low_list, list) {
+		list_del(&cand->list);
+		kfree(cand);
+	}
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/inode.c	2007-05-10 20:00:02.000000000 +0200
@@ -0,0 +1,521 @@
+/*
+ * fs/logfs/inode.c	- inode handling code
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ */
+#include "logfs.h"
+#include <linux/writeback.h>
+
+/*
+ * We need to include <linux/writeback.h> - a header we normally shouldn't
+ * be mucking with.  If life only were that easy!
+ *
+ * As it is, LogFS' requirement to read inodes for garbage collection keeps
+ * breaking Linux assumptions.  In particular, an inode can get be in
+ * I_DELETING state when being written out.  Logfs then notices that it
+ * needs some space, does a little GC and tries to read just the inode in
+ * I_DELETING state.  So the code is waiting for itself to finish, lovely.
+ *
+ * Our strategy to solve this problem is to overload the generic drop_inode()
+ * and destroy_inode() methods.  Writeback happens between those two calls,
+ * so add the inode to a list in drop_inode() and remove it again in
+ * destroy_inode().  Any iget() in the GC path is replaced with logfs_iget(),
+ * which will check the list and only call the blocking iget() if the inode
+ * in question cannot deadlock.
+ *
+ * And of course this would be racy if we didn't take inode_lock in a few
+ * key moments.
+ */
+
+static struct kmem_cache *logfs_inode_cache;
+
+
+static int __logfs_read_inode(struct inode *inode);
+
+
+static struct inode *__logfs_iget(struct super_block *sb, unsigned long ino)
+{
+	struct inode *inode = iget_locked(sb, ino);
+	int err;
+
+	if (inode && (inode->i_state & I_NEW)) {
+		err = __logfs_read_inode(inode);
+		unlock_new_inode(inode);
+		if (err) {
+			/* set i_nlink to 0 to prevent caching */
+			inode->i_nlink = 0;
+			LOGFS_INODE(inode)->li_flags |= LOGFS_IF_ZOMBIE;
+			iput(inode);
+			return NULL;
+		}
+	}
+
+	return inode;
+}
+
+
+/*
+ * cookie is set to 1 if we hand out a cached inode, 0 otherwise.
+ * this allows logfs_iput to do the right thing later
+ */
+struct inode *logfs_iget(struct super_block *sb, ino_t ino, int *cookie)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_inode *li;
+
+	if (ino == LOGFS_INO_MASTER)
+		return super->s_master_inode;
+
+	spin_lock(&inode_lock);
+	list_for_each_entry(li, &super->s_freeing_list, li_freeing_list)
+		if (li->vfs_inode.i_ino == ino) {
+			spin_unlock(&inode_lock);
+			*cookie = 1;
+			return &li->vfs_inode;
+		}
+	spin_unlock(&inode_lock);
+
+	*cookie = 0;
+	return __logfs_iget(sb, ino);
+}
+
+
+void logfs_iput(struct inode *inode, int cookie)
+{
+	if (inode->i_ino == LOGFS_INO_MASTER)
+		return;
+
+	if (cookie)
+		return;
+
+	iput(inode);
+}
+
+
+static void logfs_init_inode(struct inode *inode)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	int i;
+
+	li->li_flags	= LOGFS_IF_VALID;
+	li->li_used_bytes = 0;
+	inode->i_uid	= 0;
+	inode->i_gid	= 0;
+	inode->i_size	= 0;
+	inode->i_blocks	= 0;
+	inode->i_ctime	= CURRENT_TIME;
+	inode->i_mtime	= CURRENT_TIME;
+	inode->i_nlink	= 1;
+	INIT_LIST_HEAD(&li->li_freeing_list);
+
+	for (i=0; i<LOGFS_EMBEDDED_FIELDS; i++)
+		li->li_data[i] = 0;
+
+	return;
+}
+
+
+static struct inode *logfs_alloc_inode(struct super_block *sb)
+{
+	struct logfs_inode *li;
+
+	li = kmem_cache_alloc(logfs_inode_cache, GFP_KERNEL);
+	if (!li)
+		return NULL;
+	logfs_init_inode(&li->vfs_inode);
+	return &li->vfs_inode;
+}
+
+
+struct inode *logfs_new_meta_inode(struct super_block *sb, u64 ino)
+{
+	struct inode *inode;
+
+	inode = logfs_alloc_inode(sb);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	logfs_init_inode(inode);
+	inode->i_mode = 0;
+	inode->i_ino = ino;
+	inode->i_sb = sb;
+
+	/* This is a blatant copy of alloc_inode code.  We'd need alloc_inode
+	 * to be nonstatic, alas. */
+	{
+		static const struct address_space_operations empty_aops;
+		struct address_space * const mapping = &inode->i_data;
+
+		mapping->a_ops = &empty_aops;
+		mapping->host = inode;
+		mapping->flags = 0;
+		mapping_set_gfp_mask(mapping, GFP_HIGHUSER);
+		mapping->assoc_mapping = NULL;
+		mapping->backing_dev_info = &default_backing_dev_info;
+		inode->i_mapping = mapping;
+	}
+
+	return inode;
+}
+
+
+/*
+ * We depend on the kernel to hand us proper time here.  If it has more
+ * nanoseconds than fit in a second, something's fishy.  Either the currently
+ * running kernel is confused or we read a wrong value.  The latter could be
+ * because whoever wrote the value messed up or we have undetected data
+ * corruption.
+ * Whatever the case, give a warning.
+ */
+static struct timespec be64_to_timespec(__be64 betime)
+{
+	u64 time = be64_to_cpu(betime);
+	struct timespec tsp;
+
+	tsp.tv_sec = time >> 32;
+	tsp.tv_nsec = time & 0xffffffff;
+	WARN_ON(tsp.tv_nsec > 999999999);
+	return tsp;
+}
+
+
+static __be64 timespec_to_be64(struct timespec tsp)
+{
+	u64 time = ((u64)tsp.tv_sec << 32) + (tsp.tv_nsec & 0xffffffff);
+
+	WARN_ON(tsp.tv_nsec > 999999999);
+	return cpu_to_be64(time);
+}
+
+
+static void logfs_disk_to_inode(struct logfs_disk_inode *di, struct inode*inode)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	int i;
+
+	inode->i_mode	= be16_to_cpu(di->di_mode);
+	li->li_flags	= be32_to_cpu(di->di_flags);
+	inode->i_uid	= be32_to_cpu(di->di_uid);
+	inode->i_gid	= be32_to_cpu(di->di_gid);
+	inode->i_size	= be64_to_cpu(di->di_size);
+	logfs_set_blocks(inode, be64_to_cpu(di->di_used_bytes));
+	inode->i_ctime	= be64_to_timespec(di->di_ctime);
+	inode->i_mtime	= be64_to_timespec(di->di_mtime);
+	inode->i_nlink	= be32_to_cpu(di->di_refcount);
+	inode->i_generation = be32_to_cpu(di->di_generation);
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFCHR: /* fall through */
+	case S_IFBLK: /* fall through */
+	case S_IFIFO:
+		inode->i_rdev = be64_to_cpu(di->di_data[0]);
+		break;
+	default:
+		for (i=0; i<LOGFS_EMBEDDED_FIELDS; i++)
+			li->li_data[i] = be64_to_cpu(di->di_data[i]);
+		break;
+	}
+}
+
+
+static void logfs_inode_to_disk(struct inode *inode, struct logfs_disk_inode*di)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	int i;
+
+	di->di_mode	= cpu_to_be16(inode->i_mode);
+	di->di_pad	= 0;
+	di->di_flags	= cpu_to_be32(li->li_flags);
+	di->di_uid	= cpu_to_be32(inode->i_uid);
+	di->di_gid	= cpu_to_be32(inode->i_gid);
+	di->di_size	= cpu_to_be64(i_size_read(inode));
+	di->di_used_bytes = cpu_to_be64(li->li_used_bytes);
+	di->di_ctime	= timespec_to_be64(inode->i_ctime);
+	di->di_mtime	= timespec_to_be64(inode->i_mtime);
+	di->di_refcount	= cpu_to_be32(inode->i_nlink);
+	di->di_generation = cpu_to_be32(inode->i_generation);
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFCHR: /* fall through */
+	case S_IFBLK: /* fall through */
+	case S_IFIFO:
+		di->di_data[0] = cpu_to_be64(inode->i_rdev);
+		break;
+	default:
+		for (i=0; i<LOGFS_EMBEDDED_FIELDS; i++)
+			di->di_data[i] = cpu_to_be64(li->li_data[i]);
+		break;
+	}
+}
+
+
+#define VALID_MASK (LOGFS_IF_VALID | LOGFS_IF_INVALID)
+static int logfs_read_disk_inode(struct logfs_disk_inode *di,
+		struct inode *inode)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	ino_t ino = inode->i_ino;
+	int ret;
+
+	BUG_ON(!super->s_master_inode);
+	ret = logfs_inode_read(super->s_master_inode, di, sizeof(*di), ino);
+	if (ret)
+		return ret;
+
+	if ((be32_to_cpu(di->di_flags) & VALID_MASK) != LOGFS_IF_VALID) {
+		/*
+		 * We read wrong data, someone scribbled over it or we
+		 * have a bug.  Worth mentioning in the logs.
+		 */
+		printk(KERN_WARNING"LOGFS: read corrupt inode #%lx\n", ino);
+		WARN_ON(1);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+
+static int __logfs_read_inode(struct inode *inode)
+{
+	struct logfs_disk_inode di;
+	int ret;
+
+	ret = logfs_read_disk_inode(&di, inode);
+	/* FIXME: move back to mkfs when format has settled */
+	if (ret == -ENODATA && inode->i_ino == LOGFS_INO_ROOT) {
+		memset(&di, 0, sizeof(di));
+		di.di_flags	= cpu_to_be32(LOGFS_IF_VALID);
+		di.di_mode	= cpu_to_be16(S_IFDIR | 0755);
+		di.di_refcount	= cpu_to_be32(2);
+		ret = 0;
+	}
+	if (ret)
+		return ret;
+	logfs_disk_to_inode(&di, inode);
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFDIR:
+		inode->i_op = &logfs_dir_iops;
+		inode->i_fop = &logfs_dir_fops;
+		break;
+	case S_IFREG:
+		inode->i_op = &logfs_reg_iops;
+		inode->i_fop = &logfs_reg_fops;
+		inode->i_mapping->a_ops = &logfs_reg_aops;
+		break;
+	default:
+		;
+	}
+
+	return 0;
+}
+
+
+static void logfs_read_inode(struct inode *inode)
+{
+	int ret;
+
+	BUG_ON(inode->i_ino == LOGFS_INO_MASTER);
+
+	ret = __logfs_read_inode(inode);
+
+	/* What else can we do here? */
+	BUG_ON(ret);
+}
+
+
+static int logfs_write_disk_inode(struct logfs_disk_inode *di,
+		struct inode *inode)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+
+	return logfs_inode_write(super->s_master_inode, di, sizeof(*di),
+			inode->i_ino);
+}
+
+
+int __logfs_write_inode(struct inode *inode)
+{
+	/*
+	 * FIXME: Those two inodes are 512 bytes in total.  Not good to
+	 * have on the stack.  Possibly the best solution would be to bite
+	 * the bullet and do another format change before release and
+	 * shrink the inodes.
+	 */
+	struct logfs_disk_inode old, new;
+
+	BUG_ON(inode->i_ino == LOGFS_INO_MASTER);
+
+	/* read and compare the inode first.  If it hasn't changed, don't
+	 * bother writing it. */
+	logfs_inode_to_disk(inode, &new);
+	if (logfs_read_disk_inode(&old, inode))
+		return logfs_write_disk_inode(&new, inode);
+	if (memcmp(&old, &new, sizeof(old)))
+		return logfs_write_disk_inode(&new, inode);
+	return 0;
+}
+
+
+static int logfs_write_inode(struct inode *inode, int do_sync)
+{
+	int ret;
+
+	/* Can only happen if creat() failed.  Safe to skip. */
+	if (LOGFS_INODE(inode)->li_flags & LOGFS_IF_STILLBORN)
+		return 0;
+
+	ret = __logfs_write_inode(inode);
+	LOGFS_BUG_ON(ret, inode->i_sb);
+	return ret;
+}
+
+
+static void logfs_truncate_inode(struct inode *inode)
+{
+	i_size_write(inode, 0);
+	logfs_truncate(inode);
+	truncate_inode_pages(&inode->i_data, 0);
+}
+
+
+/*
+ * ZOMBIE inodes have already been deleted before and should remain dead,
+ * if it weren't for valid checking.  No need to kill them again here.
+ */
+static void logfs_delete_inode(struct inode *inode)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+
+	if (! (LOGFS_INODE(inode)->li_flags & LOGFS_IF_ZOMBIE)) {
+		if (i_size_read(inode) > 0)
+			logfs_truncate_inode(inode);
+		logfs_delete(super->s_master_inode, inode->i_ino);
+	}
+	clear_inode(inode);
+}
+
+
+void __logfs_destroy_inode(struct inode *inode)
+{
+	kmem_cache_free(logfs_inode_cache, LOGFS_INODE(inode));
+}
+
+
+/*
+ * We need to remember which inodes are currently being dropped.  They
+ * would deadlock the cleaner, if it were to iget() them.  So
+ * logfs_drop_inode() adds them to super->s_freeing_list,
+ * logfs_destroy_inode() removes them again and logfs_iget() checks the
+ * list.
+ */
+static void logfs_destroy_inode(struct inode *inode)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	BUG_ON(list_empty(&li->li_freeing_list));
+	spin_lock(&inode_lock);
+	list_del(&li->li_freeing_list);
+	spin_unlock(&inode_lock);
+	kmem_cache_free(logfs_inode_cache, LOGFS_INODE(inode));
+}
+
+
+/* called with inode_lock held */
+static void logfs_drop_inode(struct inode *inode)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	list_move(&li->li_freeing_list, &super->s_freeing_list);
+	generic_drop_inode(inode);
+}
+
+
+static u64 logfs_get_ino(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	u64 ino;
+
+	/*
+	 * FIXME: ino allocation should work in two modes:
+	 * o nonsparse - ifile is mostly occupied, just append
+	 * o sparse - ifile has lots of holes, fill them up
+	 *
+	 * SEEK_HOLE would obviously help a lot here.
+	 */
+	spin_lock(&super->s_ino_lock);
+	ino = super->s_last_ino;
+	super->s_last_ino++;
+	spin_unlock(&super->s_ino_lock);
+	return ino;
+}
+
+
+struct inode *logfs_new_inode(struct inode *dir, int mode)
+{
+	struct super_block *sb = dir->i_sb;
+	struct inode *inode;
+
+	inode = new_inode(sb);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	logfs_init_inode(inode);
+
+	inode->i_mode = mode;
+	inode->i_ino = logfs_get_ino(sb);
+
+	insert_inode_hash(inode);
+
+	return inode;
+}
+
+
+static void logfs_init_once(void *_li, struct kmem_cache *cachep,
+		unsigned long flags)
+{
+	struct logfs_inode *li = _li;
+	int i;
+
+	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
+			SLAB_CTOR_CONSTRUCTOR) {
+		li->li_flags = 0;
+		li->li_used_bytes = 0;
+		for (i=0; i<LOGFS_EMBEDDED_FIELDS; i++)
+			li->li_data[i] = 0;
+		inode_init_once(&li->vfs_inode);
+	}
+
+}
+
+
+struct super_operations logfs_super_operations = {
+	.alloc_inode	= logfs_alloc_inode,
+	.delete_inode	= logfs_delete_inode,
+	.destroy_inode	= logfs_destroy_inode,
+	.drop_inode	= logfs_drop_inode,
+	.read_inode	= logfs_read_inode,
+	.write_inode	= logfs_write_inode,
+	.statfs		= logfs_statfs,
+};
+
+
+int logfs_init_inode_cache(void)
+{
+	logfs_inode_cache = kmem_cache_create("logfs_inode_cache",
+			sizeof(struct logfs_inode), 0, SLAB_RECLAIM_ACCOUNT,
+			logfs_init_once, NULL);
+	if (!logfs_inode_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+
+void logfs_destroy_inode_cache(void)
+{
+	kmem_cache_destroy(logfs_inode_cache);
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/journal.c	2007-05-14 22:46:11.000000000 +0200
@@ -0,0 +1,731 @@
+/*
+ * fs/logfs/journal.c	- journal handling code
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ */
+#include "logfs.h"
+
+
+static void clear_retired(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int i;
+
+	for (i=0; i<JE_LAST; i++)
+		super->s_retired[i].used = 0;
+	super->s_first.used = 0;
+}
+
+
+static void clear_speculatives(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int i;
+
+	for (i=0; i<JE_LAST; i++)
+		super->s_speculative[i].used = 0;
+}
+
+
+static void retire_speculatives(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_journal_entry *spec, *retired;
+	int i;
+
+	for (i=0; i<JE_LAST; i++) {
+		spec = super->s_speculative + i;
+		retired = super->s_retired + i;
+		if (! spec->used)
+			continue;
+		if (retired->used && (spec->version <= retired->version))
+			continue;
+		retired->used = 1;
+		retired->version = spec->version;
+		retired->offset = spec->offset;
+		retired->len = spec->len;
+	}
+	clear_speculatives(sb);
+}
+
+
+/*
+ * Journal entries are versioned and highest version always wins.  To save
+ * some bytes, the version is only be16 instead of be64.  This means versions
+ * can and regularly will wrap.  However, all versions should be in a strict
+ * sequence and the total number of entries significantly lower than 2^16.
+ *
+ * So we read the first entry, store its version and substract that from
+ * any version read to normalize them.  Normalized versions should all be
+ * fairly close to zero and we can again easily judge which is the highest
+ * number.
+ */
+static void __logfs_scan_journal(struct super_block *sb, void *block,
+		u32 segno, u64 block_ofs, int block_index)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_journal_header *h;
+	struct logfs_area *area = super->s_journal_area;
+
+	for (h = block; (void*)h - block < sb->s_blocksize; h++) {
+		struct logfs_journal_entry *spec, *retired;
+		unsigned long ofs = (void*)h - block;
+		unsigned long remainder = sb->s_blocksize - ofs;
+		u16 len = be16_to_cpu(h->h_len);
+		u16 type = be16_to_cpu(h->h_type);
+		s16 version = be16_to_cpu(h->h_version);
+
+		if ((len < 16) || (len > remainder))
+			continue;
+		if ((type < JE_FIRST) || (type > JE_LAST))
+			continue;
+		if (h->h_crc != logfs_crc32(h, len, 4))
+			continue;
+
+		if (!super->s_first.used) {
+			super->s_first.used = 1;
+			super->s_first.version = version;
+		}
+		version -= super->s_first.version;
+
+		if (abs(version) > 1<<14)
+			LOGFS_BUG(sb);
+
+		spec = &super->s_speculative[type];
+		retired = &super->s_retired[type];
+		switch (type) {
+		default:
+			/* store speculative entry */
+			if (spec->used && (version <= spec->version))
+				break;
+			spec->used = 1;
+			spec->version = version;
+			spec->offset = block_ofs + ofs;
+			spec->len = len;
+			break;
+		case JE_COMMIT:
+			/* retire speculative entries */
+			if (retired->used && (version <= retired->version))
+				break;
+			retired->used = 1;
+			retired->version = version;
+			retired->offset = block_ofs + ofs;
+			retired->len = len;
+			retire_speculatives(sb);
+			/* and set up journal area */
+			area->a_segno = segno;
+			area->a_used_objects = block_index;
+			/*
+			 * On every mount we switch to a new segment instead
+			 * of writing further in the current one.  While safe
+			 * this method is quite wasteful and get changed
+			 * sooner or later.
+			 */
+			area->a_is_open = 0;
+			break;
+		}
+	}
+}
+
+
+static int logfs_scan_journal(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	void *block = super->s_compressed_je;
+	u64 ofs;
+	u32 segno;
+	int i, k, err;
+
+	clear_speculatives(sb);
+	clear_retired(sb);
+	journal_for_each(i) {
+		segno = super->s_journal_seg[i];
+		if (!segno)
+			continue;
+		for (k=0; k<super->s_no_blocks; k++) {
+			ofs = logfs_block_ofs(sb, segno, k);
+			err = mtdread(sb, ofs, sb->s_blocksize, block);
+			if (err)
+				return err;
+			__logfs_scan_journal(sb, block, segno, ofs, k);
+		}
+	}
+	return 0;
+}
+
+
+static void logfs_read_commit(struct logfs_super *super,
+		struct logfs_journal_header *h)
+{
+	super->s_last_version = be16_to_cpu(h->h_version);
+}
+
+
+static void logfs_calc_free(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	u64 no_segs = super->s_no_segs;
+	u64 free;
+	int i;
+
+	/* superblock segment */
+	no_segs -= 1;
+	/* bad blocks */
+	no_segs -= super->s_bad_segments;
+	/* journal */
+	journal_for_each(i)
+		if (super->s_journal_seg[i])
+			no_segs--;
+
+	free = no_segs * (super->s_segsize - LOGFS_SEGMENT_RESERVE);
+	free -= super->s_used_bytes;
+	super->s_free_bytes = free;
+}
+
+
+static void reserve_sb_and_journal(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct btree_head *head = &super->s_reserved_segments;
+	int i, err;
+
+	err = btree_insert(head, 0, (void*)1);
+	BUG_ON(err);
+
+	journal_for_each(i) {
+		if (! super->s_journal_seg[i])
+			continue;
+		err = btree_insert(head, super->s_journal_seg[i], (void*)1);
+		BUG_ON(err);
+	}
+}
+
+
+static void logfs_read_dynsb(struct super_block *sb,
+		struct logfs_je_dynsb *dynsb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+
+	super->s_gec		= be64_to_cpu(dynsb->ds_gec);
+	super->s_sweeper	= be64_to_cpu(dynsb->ds_sweeper);
+	super->s_victim_ino	= be64_to_cpu(dynsb->ds_victim_ino);
+	super->s_rename_dir	= be64_to_cpu(dynsb->ds_rename_dir);
+	super->s_rename_pos	= be64_to_cpu(dynsb->ds_rename_pos);
+	super->s_used_bytes	= be64_to_cpu(dynsb->ds_used_bytes);
+}
+
+
+static void logfs_read_anchor(struct super_block *sb,
+		struct logfs_je_anchor *da)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct inode *inode = super->s_master_inode;
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	int i;
+
+	super->s_last_ino = be64_to_cpu(da->da_last_ino);
+	li->li_flags	= LOGFS_IF_VALID;
+	i_size_write(inode, be64_to_cpu(da->da_size));
+	li->li_used_bytes = be64_to_cpu(da->da_used_bytes);
+
+	for (i=0; i<LOGFS_EMBEDDED_FIELDS; i++)
+		li->li_data[i] = be64_to_cpu(da->da_data[i]);
+}
+
+
+static void logfs_read_erasecount(struct super_block *sb,
+		struct logfs_je_journal_ec *ec)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int i;
+
+	journal_for_each(i)
+		super->s_journal_ec[i] = be32_to_cpu(ec->ec[i]);
+}
+
+
+static void logfs_read_badsegments(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct btree_head *head = &super->s_reserved_segments;
+	__be32 *seg, *bad = super->s_bb_array;
+	int err;
+
+	super->s_bad_segments = 0;
+	for (seg = bad; seg - bad < sb->s_blocksize >> 2; seg++) {
+		if (*seg == 0)
+			continue;
+		err = btree_insert(head, be32_to_cpu(*seg), (void*)1);
+		BUG_ON(err);
+		super->s_bad_segments++;
+	}
+}
+
+
+static void logfs_read_areas(struct super_block *sb, struct logfs_je_areas *a)
+{
+	struct logfs_area *area;
+	int i;
+
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		area = LOGFS_SUPER(sb)->s_area[i];
+		area->a_used_bytes = be32_to_cpu(a->used_bytes[i]);
+		area->a_segno = be32_to_cpu(a->segno[i]);
+		if (area->a_segno)
+			area->a_is_open = 1;
+	}
+}
+
+
+static void *unpack(void *from, void *to)
+{
+	struct logfs_journal_header *h = from;
+	void *data = from + sizeof(struct logfs_journal_header);
+	int err;
+	size_t inlen, outlen;
+
+	if (h->h_compr == COMPR_NONE)
+		return data;
+
+	inlen = be16_to_cpu(h->h_len) - sizeof(*h);
+	outlen = be16_to_cpu(h->h_datalen);
+	err = logfs_uncompress(data, to, inlen, outlen);
+	BUG_ON(err);
+	return to;
+}
+
+
+/*
+ * Journal entries come in groups of 16.  The first group contains unique
+ * entries, the second group contains the write buffers for all levels.
+ * As of now, there are only two groups.
+ * The outer switch statement deals with groups (high nibble), the inner
+ * one with unique entries
+ */
+/* FIXME: make sure there are enough per-area objects in journal */
+static int logfs_read_journal(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	void *block = super->s_compressed_je;
+	void *scratch = super->s_je;
+	int i, err, level;
+	struct logfs_area *area;
+
+	for (i=0; i<JE_LAST; i++) {
+		struct logfs_journal_entry *je = super->s_retired + i;
+		if (!super->s_retired[i].used) {
+			switch (i) {
+			case JE_COMMIT:
+			case JE_DYNSB:
+			case JE_ANCHOR:
+				printk(KERN_WARNING "LogFS: Missing journal "
+						"entry %x?\n", i);
+				return -EIO;
+			default:
+				continue;
+			}
+		}
+		err = mtdread(sb, je->offset, sb->s_blocksize, block);
+		if (err)
+			return err;
+
+		level = i & 0xf;
+		area = super->s_area[level];
+		switch (i & ~0xf) {
+		case JEG_BASE:
+			switch (i) {
+			case JE_COMMIT:
+				/* just reads the latest version number */
+				logfs_read_commit(super, block);
+				break;
+			case JE_DYNSB:
+				logfs_read_dynsb(sb, unpack(block, scratch));
+				break;
+			case JE_ANCHOR:
+				logfs_read_anchor(sb, unpack(block, scratch));
+				break;
+			case JE_ERASECOUNT:
+				logfs_read_erasecount(sb,unpack(block,scratch));
+				break;
+			case JE_BADSEGMENTS:
+				unpack(block, super->s_bb_array);
+				logfs_read_badsegments(sb);
+				break;
+			case JE_AREAS:
+				logfs_read_areas(sb, unpack(block, scratch));
+				break;
+			default:
+				LOGFS_BUG(sb);
+				return -EIO;
+			}
+			break;
+		case JEG_WBUF:
+			unpack(block, area->a_wbuf);
+			break;
+		default:
+			LOGFS_BUG(sb);
+			return -EIO;
+		}
+
+	}
+	return 0;
+}
+
+
+/*
+ * First search the current segment (outer loop), then pick the next segment
+ * in the array, skipping any zero entries (inner loop).
+ */
+static void journal_get_free_segment(struct logfs_area *area)
+{
+	struct logfs_super *super = LOGFS_SUPER(area->a_sb);
+	int i;
+
+	journal_for_each(i) {
+		if (area->a_segno != super->s_journal_seg[i])
+			continue;
+
+		do {
+			i++;
+			if (i == LOGFS_JOURNAL_SEGS)
+				i = 0;
+		} while (!super->s_journal_seg[i]);
+
+		area->a_segno = super->s_journal_seg[i];
+		++(super->s_journal_ec[i]);
+		return;
+	}
+	BUG();
+}
+
+
+static void journal_get_erase_count(struct logfs_area *area)
+{
+	/* erase count is stored globally and incremented in
+	 * journal_get_free_segment() - nothing to do here */
+}
+
+
+static int joernal_erase_segment(struct logfs_area *area)
+{
+	return logfs_erase_segment(area->a_sb, area->a_segno);
+}
+
+
+static void journal_finish_area(struct logfs_area *area)
+{
+	if (area->a_used_objects < LOGFS_SUPER(area->a_sb)->s_no_blocks)
+		return;
+	area->a_is_open = 0;
+}
+
+
+static s64 __logfs_get_free_entry(struct super_block *sb)
+{
+	struct logfs_area *area = LOGFS_SUPER(sb)->s_journal_area;
+	u64 ofs;
+	int err;
+
+	err = logfs_open_area(area);
+	BUG_ON(err);
+
+	ofs = logfs_block_ofs(sb, area->a_segno, area->a_used_objects);
+	area->a_used_objects++;
+	logfs_close_area(area);
+
+	BUG_ON(ofs >= LOGFS_SUPER(sb)->s_size);
+	return ofs;
+}
+
+
+/*
+ * logfs_get_free_entry - return free space for journal entry
+ */
+static s64 logfs_get_free_entry(struct super_block *sb)
+{
+	s64 ret;
+
+	mutex_lock(&LOGFS_SUPER(sb)->s_log_mutex);
+	ret = __logfs_get_free_entry(sb);
+	mutex_unlock(&LOGFS_SUPER(sb)->s_log_mutex);
+	BUG_ON(ret <= 0);
+	/* FIXME: the error handling needs better testing instead of a BUG() */
+	return ret;
+}
+
+
+static size_t __logfs_write_header(struct logfs_super *super,
+		struct logfs_journal_header *h, size_t len, size_t datalen,
+		u16 type, u8 compr)
+{
+	h->h_len	= cpu_to_be16(len);
+	h->h_type	= cpu_to_be16(type);
+	h->h_version	= cpu_to_be16(++super->s_last_version);
+	h->h_datalen	= cpu_to_be16(datalen);
+	h->h_compr	= compr;
+	h->h_pad[0]	= 'H';
+	h->h_pad[1]	= 'A';
+	h->h_pad[2]	= 'T';
+	h->h_crc	= logfs_crc32(h, len, 4);
+	return len;
+}
+
+
+static size_t logfs_write_header(struct logfs_super *super,
+		struct logfs_journal_header *h, size_t datalen, u16 type)
+{
+	size_t len = datalen + sizeof(*h);
+
+	return __logfs_write_header(super, h, len, datalen, type, COMPR_NONE);
+}
+
+
+static void *logfs_write_bb(struct super_block *sb, void *h,
+		u16 *type, size_t *len)
+{
+	*type = JE_BADSEGMENTS;
+	*len = sb->s_blocksize;
+	return LOGFS_SUPER(sb)->s_bb_array;
+}
+
+
+static inline size_t logfs_journal_erasecount_size(struct logfs_super *super)
+{
+	return LOGFS_JOURNAL_SEGS * sizeof(__be32);
+}
+
+
+static void *logfs_write_erasecount(struct super_block *sb, void *_ec,
+		u16 *type, size_t *len)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_je_journal_ec *ec = _ec;
+	int i;
+
+	journal_for_each(i)
+		ec->ec[i] = cpu_to_be32(super->s_journal_ec[i]);
+	*type = JE_ERASECOUNT;
+	*len = logfs_journal_erasecount_size(super);
+	return ec;
+}
+
+
+static void *logfs_write_wbuf(struct super_block *sb, void *h,
+		u16 *type, size_t *len)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_area *area = super->s_area[super->s_sum_index];
+
+	*type = JEG_WBUF + super->s_sum_index;
+	*len = super->s_writesize;
+	return area->a_wbuf;
+}
+
+
+static void *__logfs_write_anchor(struct super_block *sb, void *_da,
+		u16 *type, size_t *len)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_je_anchor *da = _da;
+	struct inode *inode = super->s_master_inode;
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	int i;
+
+	da->da_last_ino = cpu_to_be64(super->s_last_ino);
+	da->da_size	= cpu_to_be64(i_size_read(inode));
+	da->da_used_bytes = cpu_to_be64(li->li_used_bytes);
+	for (i=0; i<LOGFS_EMBEDDED_FIELDS; i++)
+		da->da_data[i] = cpu_to_be64(li->li_data[i]);
+	*type = JE_ANCHOR;
+	*len = sizeof(*da);
+	return da;
+}
+
+
+static void *logfs_write_dynsb(struct super_block *sb, void *_dynsb,
+		u16 *type, size_t *len)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_je_dynsb *dynsb = _dynsb;
+
+	dynsb->ds_gec		= cpu_to_be64(super->s_gec);
+	dynsb->ds_sweeper	= cpu_to_be64(super->s_sweeper);
+	dynsb->ds_victim_ino	= cpu_to_be64(super->s_victim_ino);
+	dynsb->ds_rename_dir	= cpu_to_be64(super->s_rename_dir);
+	dynsb->ds_rename_pos	= cpu_to_be64(super->s_rename_pos);
+	dynsb->ds_used_bytes	= cpu_to_be64(super->s_used_bytes);
+	*type = JE_DYNSB;
+	*len = sizeof(*dynsb);
+	return dynsb;
+}
+
+
+static void *logfs_write_areas(struct super_block *sb, void *_a,
+		u16 *type, size_t *len)
+{
+	struct logfs_area *area;
+	struct logfs_je_areas *a = _a;
+	int i;
+
+	for (i=0; i<16; i++) {
+		/* FIXME: have all 16 areas */
+		a->used_bytes[i] = 0;
+		a->segno[i] = 0;
+	}
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		area = LOGFS_SUPER(sb)->s_area[i];
+		a->used_bytes[i] = cpu_to_be32(area->a_used_bytes);
+		a->segno[i] = cpu_to_be32(area->a_segno);
+	}
+	*type = JE_AREAS;
+	*len = sizeof(*a);
+	return a;
+}
+
+
+static void *logfs_write_commit(struct super_block *sb, void *h,
+		u16 *type, size_t *len)
+{
+	*type = JE_COMMIT;
+	*len = 0;
+	return NULL;
+}
+
+
+static size_t logfs_write_je(struct super_block *sb, size_t jpos,
+		void* (*write)(struct super_block *sb, void *scratch,
+			u16 *type, size_t *len))
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	void *scratch = super->s_je;
+	void *header = super->s_compressed_je + jpos;
+	void *data = header + sizeof(struct logfs_journal_header);
+	ssize_t max, compr_len, pad_len, full_len;
+	size_t len;
+	u16 type;
+	u8 compr = COMPR_ZLIB;
+
+	scratch = write(sb, scratch, &type, &len);
+	if (len == 0)
+		return logfs_write_header(super, header, 0, type);
+
+	max = sb->s_blocksize - jpos;
+	compr_len = logfs_compress(scratch, data, len, max);
+	if (compr_len < 0 || type == JE_ANCHOR) {
+		compr_len = logfs_memcpy(scratch, data, len, max);
+		compr = COMPR_NONE;
+	}
+	BUG_ON(compr_len < 0);
+
+	pad_len = ALIGN(compr_len, 16);
+	memset(data + compr_len, 0, pad_len - compr_len);
+	full_len = pad_len + sizeof(struct logfs_journal_header);
+
+	return __logfs_write_header(super, header, full_len, len, type, compr);
+}
+
+
+int logfs_write_anchor(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	void *block = super->s_compressed_je;
+	u64 ofs;
+	size_t jpos;
+	int i;
+
+	ofs = logfs_get_free_entry(sb);
+	BUG_ON(ofs >= super->s_size);
+
+	memset(block, 0, sb->s_blocksize);
+	jpos = 0;
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		super->s_sum_index = i;
+		jpos += logfs_write_je(sb, jpos, logfs_write_wbuf);
+	}
+	jpos += logfs_write_je(sb, jpos, logfs_write_bb);
+	jpos += logfs_write_je(sb, jpos, logfs_write_erasecount);
+	jpos += logfs_write_je(sb, jpos, __logfs_write_anchor);
+	jpos += logfs_write_je(sb, jpos, logfs_write_dynsb);
+	jpos += logfs_write_je(sb, jpos, logfs_write_areas);
+	jpos += logfs_write_je(sb, jpos, logfs_write_commit);
+
+	BUG_ON(jpos > sb->s_blocksize);
+
+	return mtdwrite(sb, ofs, sb->s_blocksize, block);
+}
+
+
+static struct logfs_area_ops journal_area_ops = {
+	.get_free_segment	= journal_get_free_segment,
+	.get_erase_count	= journal_get_erase_count,
+	.erase_segment		= joernal_erase_segment,
+	.finish_area		= journal_finish_area,
+};
+
+
+int logfs_init_journal(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int ret = -ENOMEM;
+
+	mutex_init(&super->s_log_mutex);
+
+	super->s_je = kzalloc(sb->s_blocksize, GFP_KERNEL);
+	if (!super->s_je)
+		goto err0;
+
+	super->s_compressed_je = kzalloc(sb->s_blocksize, GFP_KERNEL);
+	if (!super->s_compressed_je)
+		goto err1;
+
+	super->s_bb_array = kzalloc(sb->s_blocksize, GFP_KERNEL);
+	if (!super->s_bb_array)
+		goto err2;
+
+	super->s_master_inode = logfs_new_meta_inode(sb, LOGFS_INO_MASTER);
+	if (!super->s_master_inode)
+		goto err3;
+
+	/* make sure noone tries to evict this inode */
+	super->s_master_inode->i_nlink = 1;
+
+	/* logfs_scan_journal() is looking for the latest journal entries, but
+	 * doesn't copy them into data structures yet.  logfs_read_journal()
+	 * then re-reads those entries and copies their contents over. */
+	ret = logfs_scan_journal(sb);
+	if (ret)
+		goto err3;
+	ret = logfs_read_journal(sb);
+	if (ret)
+		goto err3;
+
+	reserve_sb_and_journal(sb);
+	logfs_calc_free(sb);
+
+	super->s_journal_area->a_ops = &journal_area_ops;
+	return 0;
+err3:
+	kfree(super->s_bb_array);
+err2:
+	kfree(super->s_compressed_je);
+err1:
+	kfree(super->s_je);
+err0:
+	return ret;
+}
+
+
+void logfs_cleanup_journal(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+
+	__logfs_destroy_inode(super->s_master_inode);
+	super->s_master_inode = NULL;
+
+	kfree(super->s_bb_array);
+	kfree(super->s_compressed_je);
+	kfree(super->s_je);
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/memtree.c	2007-05-10 19:42:00.000000000 +0200
@@ -0,0 +1,267 @@
+/*
+ * fs/logfs/memtree.c	- Simple In-memory B+Tree
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2007 Joern Engel
+ *
+ *
+ * This could possibly get moved to lib/.
+ *
+ * A relatively simple B+Tree implementation.  I have written it as a learning
+ * excercise to understand how B+Trees work.  Turned out to be useful as well.
+ *
+ * B+Trees can be used similar to Linux radix trees (which don't have anything
+ * in common with textbook radix trees, beware).  Prerequisite for them working
+ * well is that access to a random tree node is much faster than a large number
+ * of operations within each node.
+ *
+ * Disks have fulfilled the prerequite for a long time.  More recently DRAM
+ * has gained similar properties, as memory access times, when measured in cpu
+ * cycles, have increased.  Cacheline sizes have increased as well, which also
+ * helps B+Trees.
+ *
+ * Compared to radix trees, B+Trees are more efficient when dealing with a
+ * sparsely populated address space.  Between 25% and 50% of the memory is
+ * occupied with valid pointers.  When densely populated, radix trees contain
+ * ~98% pointers - hard to beat.  Very sparse radix trees contain only ~2%
+ * pointers.
+ *
+ * This particular implementation stores pointers identified by a long value.
+ * Storing NULL pointers is illegal, lookup will return NULL when no entry
+ * was found.
+ *
+ * Two tricks were used that are not commonly found in textbooks.  First, the
+ * lowest values are to the right, not to the left.  All used slots within a
+ * node are on the left, all unused slots contain NUL values.  Most operations
+ * simply loop once over all slots and terminate on the first NUL.
+ *
+ * Second trick is to special-case the key "0" or NUL.  As seen above, this
+ * value indicates an unused slot, so such a value should not be stored in the
+ * tree itself.  Instead it is stored in the null_ptr field in the btree_head.
+ */
+#include "logfs.h"
+
+/*
+ * Prerequisite of B+Trees performing well is that node lookup is much slower
+ * than a large number of operations within a node.  That can be true if the
+ * node size is identical to cacheline size.  All that is highly
+ * machine-dependent, just like the #define below is not.
+ *
+ * Patches to do something smarter are welcome.  Just beware that too small
+ * node with less than 8 slots have a bad fan-out and won't perform well
+ * either.
+ */
+#define BTREE_NODES 16	/* 32bit, 128 byte cacheline */
+
+struct btree_node {
+	long val;
+	struct btree_node *node;
+};
+
+
+void btree_init(struct btree_head *head)
+{
+	head->node = NULL;
+	head->height = 0;
+	head->null_ptr = NULL;
+}
+
+
+void *btree_lookup(struct btree_head *head, long val)
+{
+	int i, height = head->height;
+	struct btree_node *node = head->node;
+
+	if (val == 0)
+		return head->null_ptr;
+
+	if (height == 0)
+		return NULL;
+
+	for ( ; height > 1; height--) {
+		for (i=0; i<BTREE_NODES; i++)
+			if (node[i].val <= val)
+				break;
+		node = node[i].node;
+	}
+
+	for (i=0; i<BTREE_NODES; i++)
+		if (node[i].val == val)
+			return node[i].node;
+
+	return NULL;
+}
+
+
+static void find_pos(struct btree_node *node, long val, int *pos, int *fill)
+{
+	int i;
+
+	for (i=0; i<BTREE_NODES; i++)
+		if (node[i].val <= val)
+			break;
+	*pos = i;
+	for (i=*pos; i<BTREE_NODES; i++)
+		if (node[i].val == 0)
+			break;
+	*fill = i;
+}
+
+
+static struct btree_node *find_level(struct btree_head *head, long val,
+		int level)
+{
+	struct btree_node *node = head->node;
+	int i, height = head->height;
+
+	for ( ; height > level; height--) {
+		for (i=0; i<BTREE_NODES; i++)
+			if (node[i].val <= val)
+				break;
+		node = node[i].node;
+	}
+	return node;
+}
+
+
+static int btree_grow(struct btree_head *head)
+{
+	struct btree_node *node;
+
+	node = kcalloc(BTREE_NODES, sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+	if (head->node) {
+		node->val = head->node[BTREE_NODES-1].val;
+		node->node = head->node;
+	}
+	head->node = node;
+	head->height++;
+	return 0;
+}
+
+
+static int btree_insert_level(struct btree_head *head, long val, void *ptr,
+		int level)
+{
+	struct btree_node *node;
+	int i, pos, fill, err;
+
+	if (val == 0) {
+		/* 0 identifies empty slots, so special-case this */
+		BUG_ON(level != 1);
+		head->null_ptr = ptr;
+		return 0;
+	}
+
+	if (head->height < level) {
+		err = btree_grow(head);
+		if (err)
+			return err;
+	}
+
+retry:
+	node = find_level(head, val, level);
+	find_pos(node, val, &pos, &fill);
+	BUG_ON(node[pos].val == val);
+
+	if (fill == BTREE_NODES) {
+		/* need to split node */
+		struct btree_node *new;
+
+		new = kcalloc(BTREE_NODES, sizeof(*node), GFP_KERNEL);
+		if (!new)
+			return -ENOMEM;
+		err = btree_insert_level(head, node[BTREE_NODES/2 - 1].val, new,
+				level+1);
+		if (err) {
+			kfree(new);
+			return err;
+		}
+		for (i=0; i<BTREE_NODES/2; i++) {
+			new[i].val = node[i].val;
+			new[i].node = node[i].node;
+			node[i].val = node[i + BTREE_NODES/2].val;
+			node[i].node = node[i + BTREE_NODES/2].node;
+			node[i + BTREE_NODES/2].val = 0;
+			node[i + BTREE_NODES/2].node = NULL;
+		}
+		goto retry;
+	}
+	BUG_ON(fill >= BTREE_NODES);
+
+	/* shift and insert */
+	for (i=fill; i>pos; i--) {
+		node[i].val = node[i-1].val;
+		node[i].node = node[i-1].node;
+	}
+	node[pos].val = val;
+	node[pos].node = ptr;
+
+	return 0;
+}
+
+
+int btree_insert(struct btree_head *head, long val, void *ptr)
+{
+	return btree_insert_level(head, val, ptr, 1);
+}
+
+
+static int btree_remove_level(struct btree_head *head, long val, int level)
+{
+	struct btree_node *node;
+	int i, pos, fill;
+
+	if (val == 0) {
+		/* 0 identifies empty slots, so special-case this */
+		head->null_ptr = NULL;
+		return 0;
+	}
+
+	node = find_level(head, val, level);
+	find_pos(node, val, &pos, &fill);
+	if (level == 1)
+		BUG_ON(node[pos].val != val);
+
+	/* remove and shift */
+	for (i=pos; i<fill-1; i++) {
+		node[i].val = node[i+1].val;
+		node[i].node = node[i+1].node;
+	}
+	node[fill-1].val = 0;
+	node[fill-1].node = NULL;
+
+	if (fill-1 < BTREE_NODES/2) {
+		/*
+		 * At this point there *should* be code to either merge with
+		 * a neighboring node or steal some entries from it to preserve
+		 * the btree invariant of only having nodes with n/2..n
+		 * elements.
+		 *
+		 * As you can see, that code is left as an excercise to the
+		 * reader or anyone noticing severe performance problems in
+		 * very rare cases.
+		 *
+		 * As-is this code "implements" a method called lazy deletion,
+		 * which according to text books is relatively common in
+		 * databases and usually works quite well.
+		 * Not so usually, the btree can degrade into very long lists
+		 * of 1-element nodes and perform accordingly.
+		 */
+	}
+	if (fill-1 == 0) {
+		btree_remove_level(head, val, level+1);
+		kfree(node);
+		return 0;
+	}
+
+	return 0;
+}
+
+
+int btree_remove(struct btree_head *head, long val)
+{
+	return btree_remove_level(head, val, 1);
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/readwrite.c	2007-05-10 20:19:50.000000000 +0200
@@ -0,0 +1,1110 @@
+/*
+ * fs/logfs/readwrite.c
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ *
+ *
+ * Actually contains five sets of very similar functions:
+ * read		read blocks from a file
+ * write	write blocks to a file
+ * valid	check whether a block still belongs to a file
+ * truncate	truncate a file
+ * rewrite	move existing blocks of a file to a new location (gc helper)
+ */
+#include "logfs.h"
+
+
+static int logfs_read_empty(void *buf, int read_zero)
+{
+	if (!read_zero)
+		return -ENODATA;
+
+	memset(buf, 0, PAGE_CACHE_SIZE);
+	return 0;
+}
+
+
+static int logfs_read_embedded(struct inode *inode, void *buf)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	memcpy(buf, li->li_data, LOGFS_EMBEDDED_SIZE);
+	return 0;
+}
+
+
+static int logfs_read_direct(struct inode *inode, pgoff_t index, void *buf,
+		int read_zero)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	u64 block;
+
+	block = li->li_data[index];
+	if (!block)
+		return logfs_read_empty(buf, read_zero);
+
+	return logfs_segment_read(inode->i_sb, buf, block);
+}
+
+
+static __be64 *logfs_get_rblock(struct logfs_super *super)
+{
+	mutex_lock(&super->s_r_mutex);
+	return super->s_rblock;
+}
+
+
+static void logfs_put_rblock(struct logfs_super *super)
+{
+	mutex_unlock(&super->s_r_mutex);
+}
+
+
+static __be64 **logfs_get_wblocks(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+
+	mutex_lock(&super->s_w_mutex);
+	logfs_gc_pass(sb);
+	return super->s_wblock;
+}
+
+
+static void logfs_put_wblocks(struct super_block *sb)
+{
+	mutex_unlock(&LOGFS_SUPER(sb)->s_w_mutex);
+}
+
+
+static unsigned long get_bits(u64 val, int skip, int no)
+{
+	u64 ret = val;
+
+	ret >>= skip * no;
+	ret <<= 64 - no;
+	ret >>= 64 - no;
+	return ret;
+}
+
+
+static int logfs_read_loop(struct inode *inode, pgoff_t index, void *buf,
+		int read_zero, int count)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	__be64 *rblock;
+	u64 bofs = li->li_data[I1_INDEX + count];
+	int bits = LOGFS_BLOCK_BITS;
+	int i, ret;
+
+	if (!bofs)
+		return logfs_read_empty(buf, read_zero);
+
+	rblock = logfs_get_rblock(super);
+
+	for (i=count; i>=0; i--) {
+		ret = logfs_segment_read(inode->i_sb, rblock, bofs);
+		if (ret)
+			goto out;
+		bofs = be64_to_cpu(rblock[get_bits(index, i, bits)]);
+
+		if (!bofs) {
+			ret = logfs_read_empty(buf, read_zero);
+			goto out;
+		}
+	}
+
+	ret = logfs_segment_read(inode->i_sb, buf, bofs);
+out:
+	logfs_put_rblock(super);
+	return ret;
+}
+
+
+static int logfs_read_block(struct inode *inode, pgoff_t index, void *buf,
+		int read_zero)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED) {
+		if (index != 0)
+			return logfs_read_empty(buf, read_zero);
+		else
+			return logfs_read_embedded(inode, buf);
+	} else if (index < I0_BLOCKS)
+		return logfs_read_direct(inode, index, buf, read_zero);
+	else if (index < I1_BLOCKS)
+		return logfs_read_loop(inode, index, buf, read_zero, 0);
+	else if (index < I2_BLOCKS)
+		return logfs_read_loop(inode, index, buf, read_zero, 1);
+	else if (index < I3_BLOCKS)
+		return logfs_read_loop(inode, index, buf, read_zero, 2);
+
+	BUG();
+	return -EIO;
+}
+
+
+static u64 seek_data_direct(struct inode *inode, u64 pos)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	for (; pos < I0_BLOCKS; pos++)
+		if (li->li_data[pos])
+			return pos;
+	return I0_BLOCKS;
+}
+
+
+static u64 seek_data_loop(struct inode *inode, u64 pos, int count)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	__be64 *rblock;
+	u64 bofs = li->li_data[I1_INDEX + count];
+	int bits = LOGFS_BLOCK_BITS;
+	int i, ret, slot;
+
+	BUG_ON(!bofs);
+
+	rblock = logfs_get_rblock(super);
+
+	for (i=count; i>=0; i--) {
+		ret = logfs_segment_read(inode->i_sb, rblock, bofs);
+		if (ret)
+			break;
+		slot = get_bits(pos, i, bits);
+		while (slot < LOGFS_BLOCK_FACTOR && rblock[slot] == 0) {
+			slot++;
+			pos += 1 << (LOGFS_BLOCK_BITS * i);
+		}
+		if (slot >= LOGFS_BLOCK_FACTOR)
+			break;
+		bofs = be64_to_cpu(rblock[slot]);
+	}
+	logfs_put_rblock(super);
+	return pos;
+}
+
+
+static u64 __logfs_seek_data(struct inode *inode, u64 pos)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED)
+		return pos;
+	if (pos < I0_BLOCKS) {
+		pos = seek_data_direct(inode, pos);
+		if (pos < I0_BLOCKS)
+			return pos;
+	}
+	if (pos < I1_BLOCKS) {
+		if (!li->li_data[I1_INDEX])
+			pos = I1_BLOCKS;
+		else
+			return seek_data_loop(inode, pos, 0);
+	}
+	if (pos < I2_BLOCKS) {
+		if (!li->li_data[I2_INDEX])
+			pos = I2_BLOCKS;
+		else
+			return seek_data_loop(inode, pos, 1);
+	}
+	if (pos < I3_BLOCKS) {
+		if (!li->li_data[I3_INDEX])
+			pos = I3_BLOCKS;
+		else
+			return seek_data_loop(inode, pos, 2);
+	}
+	return pos;
+}
+
+
+u64 logfs_seek_data(struct inode *inode, u64 pos)
+{
+	struct super_block *sb = inode->i_sb;
+	u64 ret, end;
+
+	ret = __logfs_seek_data(inode, pos);
+	end = i_size_read(inode) >> sb->s_blocksize_bits;
+	if (ret >= end)
+		ret = max(pos, end);
+	return ret;
+}
+
+
+static int logfs_is_valid_direct(struct logfs_inode *li, pgoff_t index, u64 ofs)
+{
+	return li->li_data[index] == ofs;
+}
+
+
+static int __logfs_is_valid_loop(struct inode *inode, pgoff_t index,
+		int count, u64 ofs, u64 bofs, __be64 *rblock)
+{
+	int bits = LOGFS_BLOCK_BITS;
+	int i, ret;
+
+	for (i=count; i>=0; i--) {
+		ret = logfs_segment_read(inode->i_sb, rblock, bofs);
+		if (ret)
+			return 0;
+
+		bofs = be64_to_cpu(rblock[get_bits(index, i, bits)]);
+		if (!bofs)
+			return 0;
+
+		if (bofs == ofs)
+			return 1;
+	}
+	return 0;
+}
+
+
+static int logfs_is_valid_loop(struct inode *inode, pgoff_t index,
+		int count, u64 ofs)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	__be64 *rblock;
+	u64 bofs = li->li_data[I1_INDEX + count];
+	int ret;
+
+	if (!bofs)
+		return 0;
+
+	if (bofs == ofs)
+		return 1;
+
+	rblock = logfs_get_rblock(super);
+	ret = __logfs_is_valid_loop(inode, index, count, ofs, bofs, rblock);
+	logfs_put_rblock(super);
+	return ret;
+}
+
+
+static int __logfs_is_valid_block(struct inode *inode, pgoff_t index, u64 ofs)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	if ((inode->i_nlink == 0) && atomic_read(&inode->i_count) == 1)
+		return 0;
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED)
+		return 0;
+
+	if (index < I0_BLOCKS)
+		return logfs_is_valid_direct(li, index, ofs);
+	else if (index < I1_BLOCKS)
+		return logfs_is_valid_loop(inode, index, 0, ofs);
+	else if (index < I2_BLOCKS)
+		return logfs_is_valid_loop(inode, index, 1, ofs);
+	else if (index < I3_BLOCKS)
+		return logfs_is_valid_loop(inode, index, 2, ofs);
+
+	BUG();
+	return 0;
+}
+
+
+int logfs_is_valid_block(struct super_block *sb, u64 ofs, u64 ino, u64 pos)
+{
+	struct inode *inode;
+	int ret, cookie;
+
+	/* Umount closes a segment with free blocks remaining.  Those
+	 * blocks are by definition invalid. */
+	if (ino == -1)
+		return 0;
+
+	LOGFS_BUG_ON((u64)(u_long)ino != ino, sb);
+
+	inode = logfs_iget(sb, ino, &cookie);
+	if (!inode)
+		return 0;
+
+#if 0
+	/* Any data belonging to dirty inodes must be considered valid until
+	 * the inode is written back.  If we prematurely deleted old blocks
+	 * and crashed before the inode is written, the filesystem goes boom.
+	 */
+	if (inode->i_state & I_DIRTY)
+		ret = 2;
+	else
+#endif
+		ret = __logfs_is_valid_block(inode, pos, ofs);
+
+	logfs_iput(inode, cookie);
+	return ret;
+}
+
+
+int logfs_readpage_nolock(struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	void *buf;
+	int ret = -EIO;
+
+	buf = kmap(page);
+	ret = logfs_read_block(inode, page->index, buf, 1);
+	kunmap(page);
+
+	if (ret) {
+		ClearPageUptodate(page);
+		SetPageError(page);
+	} else {
+		SetPageUptodate(page);
+		ClearPageError(page);
+	}
+	flush_dcache_page(page);
+
+	return ret;
+}
+
+
+/*
+ * logfs_file_read - generic_file_read for in-kernel buffers
+ */
+static ssize_t __logfs_inode_read(struct inode *inode, char *buf, size_t count,
+		loff_t *ppos, int read_zero)
+{
+	void *block_data = NULL;
+	loff_t size = i_size_read(inode);
+	int err = -ENOMEM;
+
+	if (*ppos >= size)
+		return 0;
+	if (count > size - *ppos)
+		count = size - *ppos;
+
+	BUG_ON(logfs_index(*ppos) != logfs_index(*ppos + count - 1));
+
+	block_data = kzalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
+	if (!block_data)
+		goto fail;
+
+	err = logfs_read_block(inode, logfs_index(*ppos), block_data,
+			read_zero);
+	if (err)
+		goto fail;
+
+	memcpy(buf, block_data + (*ppos % LOGFS_BLOCKSIZE), count);
+	*ppos += count;
+	err = count;
+fail:
+	kfree(block_data);
+	return err;
+}
+
+
+static s64 logfs_segment_write_pos(struct inode *inode, void *buf, u64 pos,
+		int level, int alloc)
+{
+	return logfs_segment_write(inode, buf, logfs_index(pos), level, alloc);
+}
+
+
+static int logfs_reserve_bytes(struct inode *inode, int bytes)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+
+	if (!bytes)
+		return 0;
+
+	if (super->s_free_bytes < bytes + super->s_gc_reserve)
+		return -ENOSPC;
+
+	return 0;
+}
+
+
+/*
+ * Not strictly a reservation, but rather a check that we still have enough
+ * space to satisfy the write.
+ */
+static int logfs_reserve_blocks(struct inode *inode, int blocks)
+{
+	return logfs_reserve_bytes(inode, blocks * LOGFS_MAX_OBJECTSIZE);
+}
+
+
+static int logfs_dirty_inode(struct inode *inode)
+{
+	if (inode->i_ino == LOGFS_INO_MASTER)
+		return logfs_write_anchor(inode);
+
+	mark_inode_dirty(inode);
+	return 0;
+}
+
+
+/*
+ * File is too large for embedded data when called.  Move data to first
+ * block and clear embedded area
+ */
+static int logfs_move_embedded(struct inode *inode, __be64 **wblocks)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	void *buf;
+	s64 block;
+	int i;
+
+	if (! (li->li_flags & LOGFS_IF_EMBEDDED))
+		return 0;
+
+	if (logfs_reserve_blocks(inode, 1))
+		return -ENOSPC;
+
+	buf = wblocks[0];
+
+	memcpy(buf, li->li_data, LOGFS_EMBEDDED_SIZE);
+	block = logfs_segment_write(inode, buf, 0, 0, 1);
+	if (block < 0)
+		return block;
+
+	li->li_data[0] = block;
+
+	li->li_flags &= ~LOGFS_IF_EMBEDDED;
+	for (i=1; i<LOGFS_EMBEDDED_FIELDS; i++)
+		li->li_data[i] = 0;
+
+	return logfs_dirty_inode(inode);
+}
+
+
+static int logfs_write_embedded(struct inode *inode, void *buf)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	void *dst = li->li_data;
+
+	memcpy(dst, buf, max((long long)LOGFS_EMBEDDED_SIZE, i_size_read(inode)));
+
+	li->li_flags |= LOGFS_IF_EMBEDDED;
+	logfs_set_blocks(inode, 0);
+
+	return logfs_dirty_inode(inode);
+}
+
+
+static int logfs_write_direct(struct inode *inode, pgoff_t index, void *buf)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	s64 block;
+
+	if (li->li_data[index] == 0) {
+		if (logfs_reserve_blocks(inode, 1)) {
+			return -ENOSPC;
+		}
+	}
+	block = logfs_segment_write(inode, buf, index, 0, 1);
+	if (block < 0)
+		return block;
+
+	if (li->li_data[index])
+		logfs_segment_delete(inode, li->li_data[index], index, 0);
+	li->li_data[index] = block;
+
+	return logfs_dirty_inode(inode);
+}
+
+
+static int logfs_write_loop(struct inode *inode, pgoff_t index, void *buf,
+		__be64 **wblocks, int count)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	u64 bofs = li->li_data[I1_INDEX + count];
+	s64 block;
+	int bits = LOGFS_BLOCK_BITS;
+	int allocs = 0;
+	int i, ret;
+
+	for (i=count; i>=0; i--) {
+		if (bofs) {
+			ret = logfs_segment_read(inode->i_sb, wblocks[i], bofs);
+			if (ret)
+				return ret;
+		} else {
+			allocs++;
+			memset(wblocks[i], 0, LOGFS_BLOCKSIZE);
+		}
+		bofs = be64_to_cpu(wblocks[i][get_bits(index, i, bits)]);
+	}
+
+	if (! wblocks[0][get_bits(index, 0, bits)])
+		allocs++;
+	if (logfs_reserve_blocks(inode, allocs))
+		return -ENOSPC;
+
+	block = logfs_segment_write(inode, buf, index, 0, allocs);
+	allocs = allocs ? allocs-1 : 0;
+	if (block < 0)
+		return block;
+
+	for (i=0; i<=count; i++) {
+		wblocks[i][get_bits(index, i, bits)] = cpu_to_be64(block);
+		block = logfs_segment_write(inode, wblocks[i], index, i+1,
+				allocs);
+		allocs = allocs ? allocs-1 : 0;
+		if (block < 0)
+			return block;
+	}
+
+	li->li_data[I1_INDEX + count] = block;
+
+	return logfs_dirty_inode(inode);
+}
+
+
+static int __logfs_write_buf(struct inode *inode, pgoff_t index, void *buf,
+		__be64 **wblocks)
+{
+	u64 size = i_size_read(inode);
+	int err;
+
+	inode->i_ctime.tv_sec = inode->i_mtime.tv_sec = get_seconds();
+
+	if (size <= LOGFS_EMBEDDED_SIZE)
+		return logfs_write_embedded(inode, buf);
+
+	err = logfs_move_embedded(inode, wblocks);
+	if (err)
+		return err;
+
+	if (index < I0_BLOCKS)
+		return logfs_write_direct(inode, index, buf);
+	if (index < I1_BLOCKS)
+		return logfs_write_loop(inode, index, buf, wblocks, 0);
+	if (index < I2_BLOCKS)
+		return logfs_write_loop(inode, index, buf, wblocks, 1);
+	if (index < I3_BLOCKS)
+		return logfs_write_loop(inode, index, buf, wblocks, 2);
+
+	BUG();
+	return -EIO;
+}
+
+
+int logfs_write_buf(struct inode *inode, pgoff_t index, void *buf)
+{
+	struct super_block *sb = inode->i_sb;
+	__be64 **wblocks;
+	int ret;
+
+	wblocks = logfs_get_wblocks(sb);
+	ret = __logfs_write_buf(inode, index, buf, wblocks);
+	logfs_put_wblocks(sb);
+	return ret;
+}
+
+
+static int logfs_delete_direct(struct inode *inode, pgoff_t index)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	if (li->li_data[index])
+		logfs_segment_delete(inode, li->li_data[index], index, 0);
+	li->li_data[index] = 0;
+	return logfs_dirty_inode(inode);
+}
+
+
+static int mem_zero(void *buf, size_t len)
+{
+	long *lmap;
+	char *cmap;
+
+	lmap = buf;
+	while (len >= sizeof(long)) {
+		if (*lmap)
+			return 0;
+		lmap++;
+		len -= sizeof(long);
+	}
+	cmap = (void*)lmap;
+	while (len) {
+		if (*cmap)
+			return 0;
+		cmap++;
+		len--;
+	}
+	return 1;
+}
+
+
+static int logfs_delete_loop(struct inode *inode, pgoff_t index,
+		__be64 **wblocks, int count)
+{
+	struct super_block *sb = inode->i_sb;
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	u64 bofs = li->li_data[I1_INDEX + count];
+	u64 ofs_array[LOGFS_MAX_LEVELS];
+	s64 block;
+	int bits = LOGFS_BLOCK_BITS;
+	int i, ret;
+
+	if (!bofs)
+		return 0;
+
+	for (i=count; i>=0; i--) {
+		ret = logfs_segment_read(sb, wblocks[i], bofs);
+		if (ret)
+			return ret;
+
+		bofs = be64_to_cpu(wblocks[i][get_bits(index, i, bits)]);
+		ofs_array[i+1] = bofs;
+		if (!bofs)
+			return 0;
+	}
+	logfs_segment_delete(inode, bofs, index, 0);
+	block = 0;
+
+	for (i=0; i<=count; i++) {
+		wblocks[i][get_bits(index, i, bits)] = cpu_to_be64(block);
+		if ((block == 0) && mem_zero(wblocks[i], sb->s_blocksize)) {
+			logfs_segment_delete(inode, ofs_array[i+1], index, i+1);
+			continue;
+		}
+		block = logfs_segment_write(inode, wblocks[i], index, i+1, 0);
+		if (block < 0)
+			return block;
+	}
+
+	li->li_data[I1_INDEX + count] = block;
+
+	return logfs_dirty_inode(inode);
+}
+
+
+static int __logfs_delete(struct inode *inode, pgoff_t index, __be64 **wblocks)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	inode->i_ctime.tv_sec = inode->i_mtime.tv_sec = get_seconds();
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED) {
+		i_size_write(inode, 0);
+		mark_inode_dirty(inode);
+		return 0;
+	}
+
+	if (index < I0_BLOCKS)
+		return logfs_delete_direct(inode, index);
+	if (index < I1_BLOCKS)
+		return logfs_delete_loop(inode, index, wblocks, 0);
+	if (index < I2_BLOCKS)
+		return logfs_delete_loop(inode, index, wblocks, 1);
+	if (index < I3_BLOCKS)
+		return logfs_delete_loop(inode, index, wblocks, 2);
+	return 0;
+}
+
+
+int logfs_delete(struct inode *inode, pgoff_t index)
+{
+	struct super_block *sb = inode->i_sb;
+	__be64 **wblocks;
+	int ret;
+
+	wblocks = logfs_get_wblocks(sb);
+	ret = __logfs_delete(inode, index, wblocks);
+	logfs_put_wblocks(sb);
+	return ret;
+}
+
+
+static int logfs_rewrite_direct(struct inode *inode, int index, pgoff_t pos,
+		void *buf, int level)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	s64 block;
+	int err;
+
+	block = li->li_data[index];
+	BUG_ON(block == 0);
+
+	err = logfs_segment_read(inode->i_sb, buf, block);
+	if (err)
+		return err;
+
+	block = logfs_segment_write(inode, buf, pos, level, 0);
+	if (block < 0)
+		return block;
+
+	li->li_data[index] = block;
+
+	return logfs_dirty_inode(inode);
+}
+
+
+static int logfs_rewrite_loop(struct inode *inode, pgoff_t index, void *buf,
+		__be64 **wblocks, int count, int level)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	u64 bofs = li->li_data[I1_INDEX + count];
+	s64 block;
+	int bits = LOGFS_BLOCK_BITS;
+	int i, err;
+
+	if (level > count)
+		return logfs_rewrite_direct(inode, I1_INDEX + count, index, buf,
+				level);
+
+	for (i=count; i>=level; i--) {
+		if (bofs) {
+			err = logfs_segment_read(inode->i_sb, wblocks[i], bofs);
+			if (err)
+				return err;
+		} else {
+			BUG();
+		}
+		bofs = be64_to_cpu(wblocks[i][get_bits(index, i, bits)]);
+	}
+
+	block = be64_to_cpu(wblocks[level][get_bits(index, level, bits)]);
+	LOGFS_BUG_ON(!block, inode->i_sb);
+
+	err = logfs_segment_read(inode->i_sb, buf, block);
+	if (err)
+		return err;
+
+	block = logfs_segment_write(inode, buf, index, level, 0);
+	if (block < 0)
+		return block;
+
+	for (i=level; i<=count; i++) {
+		wblocks[i][get_bits(index, i, bits)] = cpu_to_be64(block);
+		block = logfs_segment_write(inode, wblocks[i], index, i+1, 0);
+		if (block < 0)
+			return block;
+	}
+
+	li->li_data[I1_INDEX + count] = block;
+
+	return logfs_dirty_inode(inode);
+}
+
+
+static int __logfs_rewrite_block(struct inode *inode, pgoff_t index, void *buf,
+		__be64 **wblocks, int level)
+{
+	if (level >= LOGFS_MAX_LEVELS)
+		level -= LOGFS_MAX_LEVELS;
+	BUG_ON(level >= LOGFS_MAX_LEVELS);
+
+	if (index < I0_BLOCKS)
+		return logfs_rewrite_direct(inode, index, index, buf, level);
+	if (index < I1_BLOCKS)
+		return logfs_rewrite_loop(inode, index, buf, wblocks, 0, level);
+	if (index < I2_BLOCKS)
+		return logfs_rewrite_loop(inode, index, buf, wblocks, 1, level);
+	if (index < I3_BLOCKS)
+		return logfs_rewrite_loop(inode, index, buf, wblocks, 2, level);
+
+	BUG();
+	return -EIO;
+}
+
+
+int logfs_rewrite_block(struct inode *inode, pgoff_t index, u64 ofs, int level)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	__be64 **wblocks;
+	void *buf;
+	int ret;
+
+	wblocks = super->s_wblock;
+	buf = wblocks[LOGFS_MAX_INDIRECT];
+	ret = __logfs_rewrite_block(inode, index, buf, wblocks, level);
+	return ret;
+}
+
+
+/*
+ * Three cases exist:
+ * size <= pos			- remove full block
+ * size >= pos + chunk		- do nothing
+ * pos < size < pos + chunk	- truncate, rewrite
+ */
+static s64 __logfs_truncate_i0(struct inode *inode, u64 size, u64 bofs,
+		u64 pos, __be64 **wblocks)
+{
+	size_t len = size - pos;
+	void *buf = wblocks[LOGFS_MAX_INDIRECT];
+	int err;
+
+	if (size <= pos) {
+		/* remove whole block */
+		logfs_segment_delete(inode, bofs,
+				pos >> inode->i_sb->s_blocksize_bits, 0);
+		return 0;
+	}
+
+	/* truncate this block, rewrite it */
+	err = logfs_segment_read(inode->i_sb, buf, bofs);
+	if (err)
+		return err;
+
+	memset(buf + len, 0, LOGFS_BLOCKSIZE - len);
+	return logfs_segment_write_pos(inode, buf, pos, 0, 0);
+}
+
+
+/* FIXME: these need to become per-sb once we support different blocksizes */
+static u64 logfs_factor[] = {
+	LOGFS_BLOCKSIZE,
+	LOGFS_I1_SIZE,
+	LOGFS_I2_SIZE,
+	LOGFS_I3_SIZE
+};
+
+
+static u64 logfs_start[] = {
+	LOGFS_I0_SIZE,
+	LOGFS_I1_SIZE,
+	LOGFS_I2_SIZE,
+	LOGFS_I3_SIZE
+};
+
+
+/*
+ * One recursion per indirect block.  Logfs supports 5fold indirect blocks.
+ */
+static s64 __logfs_truncate_loop(struct inode *inode, u64 size, u64 old_bofs,
+		u64 pos, __be64 **wblocks, int i)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	s64 ofs;
+	int e, ret;
+
+	ret = logfs_segment_read(inode->i_sb, wblocks[i], old_bofs);
+	if (ret)
+		return ret;
+
+	for (e = LOGFS_BLOCK_FACTOR-1; e>=0; e--) {
+		u64 bofs;
+		u64 new_pos = pos + e*logfs_factor[i];
+
+		if (size >= new_pos + logfs_factor[i])
+			break;
+
+		bofs = be64_to_cpu(wblocks[i][e]);
+		if (!bofs)
+			continue;
+
+		LOGFS_BUG_ON(bofs > super->s_size, inode->i_sb);
+
+		if (i)
+			ofs = __logfs_truncate_loop(inode, size, bofs, new_pos,
+					wblocks, i-1);
+		else
+			ofs = __logfs_truncate_i0(inode, size, bofs, new_pos,
+					wblocks);
+		if (ofs < 0)
+			return ofs;
+
+		wblocks[i][e] = cpu_to_be64(ofs);
+	}
+
+	if (size <= max(pos, logfs_start[i])) {
+		/* complete indirect block is removed */
+		logfs_segment_delete(inode, old_bofs, logfs_index(pos), i+1);
+		return 0;
+	}
+
+	/* partially removed - write back */
+	return logfs_segment_write_pos(inode, wblocks[i], pos, i, 0);
+}
+
+
+static int logfs_truncate_direct(struct inode *inode, u64 size,
+		__be64 **wblocks)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	int e;
+	s64 bofs, ofs;
+
+	for (e = I1_INDEX-1; e>=0; e--) {
+		u64 new_pos = e*logfs_factor[0];
+
+		if (size > e*logfs_factor[0])
+			break;
+
+		bofs = li->li_data[e];
+		if (!bofs)
+			continue;
+
+		ofs = __logfs_truncate_i0(inode, size, bofs, new_pos, wblocks);
+		if (ofs < 0)
+			return ofs;
+
+		li->li_data[e] = ofs;
+	}
+	return 0;
+}
+
+
+static int logfs_truncate_loop(struct inode *inode, u64 size, __be64 **wblocks,
+		int i)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	u64 bofs = li->li_data[I1_INDEX + i];
+	s64 ofs;
+
+	if (!bofs)
+		return 0;
+
+	ofs = __logfs_truncate_loop(inode, size, bofs, 0, wblocks, i);
+	if (ofs < 0)
+		return ofs;
+
+	li->li_data[I1_INDEX + i] = ofs;
+	return 0;
+}
+
+
+static void logfs_truncate_embedded(struct inode *inode, u64 size)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	void *buf = (void*)li->li_data + size;
+	size_t len = LOGFS_EMBEDDED_SIZE - size;
+
+	if (size >= LOGFS_EMBEDDED_SIZE)
+		return;
+	memset(buf, 0, len);
+}
+
+
+/* TODO: might make sense to turn inode into embedded again */
+static void __logfs_truncate(struct inode *inode, __be64 **wblocks)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	u64 size = i_size_read(inode);
+	int ret;
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED)
+		return logfs_truncate_embedded(inode, size);
+
+	if (size >= logfs_factor[3])
+		return;
+	ret = logfs_truncate_loop(inode, size, wblocks, 2);
+	BUG_ON(ret);
+
+	if (size >= logfs_factor[2])
+		return;
+	ret = logfs_truncate_loop(inode, size, wblocks, 1);
+	BUG_ON(ret);
+
+	if (size >= logfs_factor[1])
+		return;
+	ret = logfs_truncate_loop(inode, size, wblocks, 0);
+	BUG_ON(ret);
+
+	ret = logfs_truncate_direct(inode, size, wblocks);
+	BUG_ON(ret);
+}
+
+
+void logfs_truncate(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	__be64 **wblocks;
+
+	wblocks = logfs_get_wblocks(sb);
+	__logfs_truncate(inode, wblocks);
+	logfs_put_wblocks(sb);
+	mark_inode_dirty(inode);
+}
+
+
+static ssize_t __logfs_inode_write(struct inode *inode, const char *buf,
+		size_t count, loff_t *ppos)
+{
+	void *block_data = NULL;
+	int err = -ENOMEM;
+
+	BUG_ON(logfs_index(*ppos) != logfs_index(*ppos + count - 1));
+
+	block_data = kzalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
+	if (!block_data)
+		goto fail;
+
+	err = logfs_read_block(inode, logfs_index(*ppos), block_data, 1);
+	if (err)
+		goto fail;
+
+	memcpy(block_data + (*ppos % LOGFS_BLOCKSIZE), buf, count);
+
+	if (i_size_read(inode) < *ppos + count)
+		i_size_write(inode, *ppos + count);
+
+	err = logfs_write_buf(inode, logfs_index(*ppos), block_data);
+	if (err)
+		goto fail;
+
+	*ppos += count;
+	err = count;
+fail:
+	kfree(block_data);
+	return err;
+}
+
+
+int logfs_inode_read(struct inode *inode, void *buf, size_t n, loff_t _pos)
+{
+	loff_t pos = _pos << inode->i_sb->s_blocksize_bits;
+	ssize_t ret;
+
+	if (pos >= i_size_read(inode))
+		return -EOF;
+	ret = __logfs_inode_read(inode, buf, n, &pos, 0);
+	if (ret < 0)
+		return ret;
+	ret = ret==n ? 0 : -EIO;
+	return ret;
+}
+
+
+int logfs_inode_write(struct inode *inode, const void *buf, size_t n,
+		loff_t _pos)
+{
+	loff_t pos = _pos << inode->i_sb->s_blocksize_bits;
+	ssize_t ret;
+
+	ret = __logfs_inode_write(inode, buf, n, &pos);
+	if (ret < 0)
+		return ret;
+	return ret==n ? 0 : -EIO;
+}
+
+
+int logfs_init_rw(struct logfs_super *super)
+{
+	int i;
+
+	mutex_init(&super->s_r_mutex);
+	mutex_init(&super->s_w_mutex);
+	super->s_rblock = kmalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
+	if (!super->s_wblock)
+		return -ENOMEM;
+	for (i=0; i<=LOGFS_MAX_INDIRECT; i++) {
+		super->s_wblock[i] = kmalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
+		if (!super->s_wblock) {
+			logfs_cleanup_rw(super);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+
+void logfs_cleanup_rw(struct logfs_super *super)
+{
+	int i;
+
+	for (i=0; i<=LOGFS_MAX_INDIRECT; i++)
+		kfree(super->s_wblock[i]);
+	kfree(super->s_rblock);
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/segment.c	2007-05-14 23:00:42.000000000 +0200
@@ -0,0 +1,553 @@
+/*
+ * fs/logfs/segment.c	- Handling the Object Store
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ *
+ * Object store or ostore makes up the complete device with exception of
+ * the superblock and journal areas.  Apart from its own metadata it stores
+ * three kinds of objects: inodes, dentries and blocks, both data and indirect.
+ */
+#include "logfs.h"
+
+/* FIXME: combine with per-sb journal variant */
+static unsigned char compressor_buf[LOGFS_MAX_OBJECTSIZE];
+static DEFINE_MUTEX(compr_mutex);
+
+
+int logfs_erase_segment(struct super_block *sb, u32 index)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+
+	super->s_gec++;
+
+	return mtderase(sb, index << super->s_segshift, super->s_segsize);
+}
+
+
+static s32 __logfs_get_free_bytes(struct logfs_area *area, u64 ino, u64 pos,
+		size_t bytes)
+{
+	s32 ofs;
+	int ret;
+
+	ret = logfs_open_area(area);
+	BUG_ON(ret>0);
+	if (ret)
+		return ret;
+
+	ofs = area->a_used_bytes;
+	area->a_used_bytes += bytes;
+	BUG_ON(area->a_used_bytes >= LOGFS_SUPER(area->a_sb)->s_segsize);
+
+	return dev_ofs(area->a_sb, area->a_segno, ofs);
+}
+
+
+void __logfs_set_blocks(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	inode->i_blocks = ULONG_MAX;
+	if (li->li_used_bytes >> sb->s_blocksize_bits < ULONG_MAX)
+		inode->i_blocks = li->li_used_bytes >> sb->s_blocksize_bits;
+}
+
+
+void logfs_set_blocks(struct inode *inode, u64 bytes)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	li->li_used_bytes = bytes;
+	__logfs_set_blocks(inode);
+}
+
+
+static void logfs_consume_bytes(struct inode *inode, int bytes)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	BUG_ON(li->li_used_bytes + bytes < bytes);
+	super->s_free_bytes	-= bytes;
+	super->s_used_bytes	+= bytes;
+	li->li_used_bytes	+= bytes;
+	__logfs_set_blocks(inode);
+}
+
+
+static void logfs_remove_bytes(struct inode *inode, int bytes)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	BUG_ON(li->li_used_bytes < bytes);
+	super->s_free_bytes	+= bytes;
+	super->s_used_bytes	-= bytes;
+	li->li_used_bytes	-= bytes;
+	__logfs_set_blocks(inode);
+}
+
+
+static int buf_write(struct logfs_area *area, u64 ofs, void *data, size_t len)
+{
+	struct super_block *sb = area->a_sb;
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	long write_mask = super->s_writesize - 1;
+	u64 buf_start;
+	size_t space, buf_ofs;
+	int err;
+
+	buf_ofs = (long)ofs & write_mask;
+	if (buf_ofs) {
+		/* buf already used - fill it */
+		space = super->s_writesize - buf_ofs;
+		if (len < space) {
+			/* not enough to fill it - just copy */
+			memcpy(area->a_wbuf + buf_ofs, data, len);
+			return 0;
+		}
+		/* enough data to fill and flush the buffer */
+		memcpy(area->a_wbuf + buf_ofs, data, space);
+		buf_start = ofs & ~write_mask;
+		err = mtdwrite(sb, buf_start, super->s_writesize, area->a_wbuf);
+		if (err)
+			return err;
+		ofs += space;
+		data += space;
+		len -= space;
+	}
+
+	/* write complete hunks */
+	space = len & ~write_mask;
+	if (space) {
+		err = mtdwrite(sb, ofs, space, data);
+		if (err)
+			return err;
+		ofs += space;
+		data += space;
+		len -= space;
+	}
+
+	/* store anything remaining in wbuf */
+	if (len)
+		memcpy(area->a_wbuf, data, len);
+	return 0;
+}
+
+
+static int adj_level(u64 ino, int level)
+{
+	BUG_ON(level >= LOGFS_MAX_LEVELS);
+
+	if (ino == LOGFS_INO_MASTER) {
+		/* ifile has seperate areas */
+		level += LOGFS_MAX_LEVELS;
+	}
+	return level;
+}
+
+
+static struct logfs_area *get_area(struct super_block *sb, int level)
+{
+	return LOGFS_SUPER(sb)->s_area[level];
+}
+
+
+s64 __logfs_segment_write(struct inode *inode, void *buf, u64 pos, int level,
+		int alloc, int len, int compr)
+{
+	struct logfs_area *area;
+	struct super_block *sb = inode->i_sb;
+	u64 ofs;
+	u64 ino = inode->i_ino;
+	int err;
+	struct logfs_object_header h;
+
+	h.crc	= cpu_to_be32(0xcccccccc);
+	h.len	= cpu_to_be16(len);
+	h.type	= OBJ_BLOCK;
+	h.compr	= compr;
+	h.ino	= cpu_to_be64(inode->i_ino);
+	h.pos	= cpu_to_be64(pos);
+
+	level = adj_level(ino, level);
+	area = get_area(sb, level);
+	ofs = __logfs_get_free_bytes(area, ino, pos, len + LOGFS_HEADERSIZE);
+	LOGFS_BUG_ON(ofs <= 0, sb);
+
+	err = buf_write(area, ofs, &h, sizeof(h));
+	if (!err)
+		err = buf_write(area, ofs + LOGFS_HEADERSIZE, buf, len);
+	BUG_ON(err);
+	if (err)
+		return err;
+	if (alloc) {
+		int acc_len = (level==0) ? len : sb->s_blocksize;
+		logfs_consume_bytes(inode, acc_len + LOGFS_HEADERSIZE);
+	}
+
+	/* FIXME merge with open_area */
+	logfs_close_area(area);
+
+	return ofs;
+}
+
+
+s64 logfs_segment_write(struct inode *inode, void *buf, u64 pos, int level,
+		int alloc)
+{
+	int bs = inode->i_sb->s_blocksize;
+	int compr_len;
+	s64 ofs;
+
+	if (level != 0) {
+		/* temporary disable compression for indirect blocks */
+		return __logfs_segment_write(inode, buf, pos, level, alloc, bs,
+				COMPR_NONE);
+	}
+
+	mutex_lock(&compr_mutex);
+	compr_len = logfs_compress(buf, compressor_buf, bs, bs);
+
+	if (compr_len >= 0) {
+		ofs = __logfs_segment_write(inode, compressor_buf, pos, level,
+				alloc, compr_len, COMPR_ZLIB);
+	} else {
+		ofs = __logfs_segment_write(inode, buf, pos, level, alloc, bs,
+				COMPR_NONE);
+	}
+	mutex_unlock(&compr_mutex);
+	return ofs;
+}
+
+
+/* FIXME: all this mess should get replaced by using the page cache */
+static void fixup_from_wbuf(struct super_block *sb, struct logfs_area *area,
+		void *read, u64 ofs, size_t readlen)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	u32 read_start = ofs & (super->s_segsize - 1);
+	u32 read_end = read_start + readlen;
+	u32 writemask = super->s_writesize - 1;
+	u32 buf_start = area->a_used_bytes & ~writemask;
+	u32 buf_end = area->a_used_bytes;
+	void *buf = area->a_wbuf;
+	size_t buflen = buf_end - buf_start;
+
+	if (read_end < buf_start)
+		return;
+	if ((ofs & (super->s_segsize - 1)) >= area->a_used_bytes) {
+		memset(read, 0xff, readlen);
+		return;
+	}
+
+	if (buf_start > read_start) {
+		read += buf_start - read_start;
+		readlen -= buf_start - read_start;
+	} else {
+		buf += read_start - buf_start;
+		buflen -= read_start - buf_start;
+	}
+	memcpy(read, buf, min(readlen, buflen));
+	if (buflen < readlen)
+		memset(read + buflen, 0xff, readlen - buflen);
+}
+
+
+int wbuf_read(struct super_block *sb, u64 ofs, size_t len, void *buf)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_area *area;
+	u32 segno = ofs >> super->s_segshift;
+	int i, err;
+
+	err = mtdread(sb, ofs, len, buf);
+	if (err)
+		return err;
+
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		area = super->s_area[i];
+		if (area->a_segno == segno) {
+			fixup_from_wbuf(sb, area, buf, ofs, len);
+			break;
+		}
+	}
+	return 0;
+}
+
+
+int logfs_segment_read(struct super_block *sb, void *buf, u64 ofs)
+{
+	struct logfs_object_header *h;
+	u16 len;
+	int err, bs = sb->s_blocksize;
+
+	mutex_lock(&compr_mutex);
+	err = wbuf_read(sb, ofs, bs + LOGFS_HEADERSIZE, compressor_buf);
+	if (err)
+		goto out;
+	h = (void*)compressor_buf;
+	len = be16_to_cpu(h->len);
+
+	switch (h->compr) {
+	case COMPR_NONE:
+		logfs_memcpy(compressor_buf + LOGFS_HEADERSIZE, buf, bs, bs);
+		break;
+	case COMPR_ZLIB:
+		err = logfs_uncompress(compressor_buf + LOGFS_HEADERSIZE, buf,
+				len, bs);
+		BUG_ON(err);
+		break;
+	default:
+		LOGFS_BUG(sb);
+	}
+out:
+	mutex_unlock(&compr_mutex);
+	return err;
+}
+
+
+static u64 logfs_block_mask[] = {
+	~0,
+	~(I1_BLOCKS-1),
+	~(I2_BLOCKS-1),
+	~(I3_BLOCKS-1)
+};
+
+
+/*
+ * The "position" of indirect blocks is ambiguous.  It can be the position
+ * of any data block somewhere behind this indirect block.  So we need to
+ * normalize the positions through logfs_block_mask[level] before comparing.
+ */
+static void check_pos(struct super_block *sb, u64 pos1, u64 pos2, int level)
+{
+	LOGFS_BUG_ON(	(pos1 & logfs_block_mask[level]) !=
+			(pos2 & logfs_block_mask[level]), sb);
+}
+
+
+int logfs_segment_delete(struct inode *inode, u64 ofs, u64 pos, int level)
+{
+	struct super_block *sb = inode->i_sb;
+	struct logfs_object_header *h;
+	u16 len;
+	int err;
+
+
+	mutex_lock(&compr_mutex);
+	err = wbuf_read(sb, ofs, LOGFS_MAX_OBJECTSIZE, compressor_buf);
+	LOGFS_BUG_ON(err, sb);
+	h = (void*)compressor_buf;
+	len = be16_to_cpu(h->len);
+	check_pos(sb, pos, be64_to_cpu(h->pos), level);
+	mutex_unlock(&compr_mutex);
+
+	level = adj_level(inode->i_ino, level);
+	len = (level==0) ? len : sb->s_blocksize;
+	logfs_remove_bytes(inode, len + sizeof(*h));
+	return 0;
+}
+
+
+int logfs_open_area(struct logfs_area *area)
+{
+	size_t writesize = LOGFS_SUPER(area->a_sb)->s_writesize;
+
+	if (area->a_is_open)
+		return 0;
+
+	area->a_ops->get_free_segment(area);
+	area->a_used_objects = 0;
+	area->a_used_bytes = 0;
+	area->a_ops->get_erase_count(area);
+
+	if (area->a_wbuf)
+		memset(area->a_wbuf, 0, writesize);
+	area->a_is_open = 1;
+
+	return area->a_ops->erase_segment(area);
+}
+
+
+void logfs_close_area(struct logfs_area *area)
+{
+	if (!area->a_is_open)
+		return;
+
+	area->a_ops->finish_area(area);
+}
+
+
+/*
+ * Pick a free segment to be used for this area.  Effectively takes a
+ * candidate from the free list (not really a candidate anymore).
+ */
+static void ostore_get_free_segment(struct logfs_area *area)
+{
+	struct logfs_super *super = LOGFS_SUPER(area->a_sb);
+	struct gc_candidate *cand;
+
+	BUG_ON(list_empty(&super->s_free_list));
+
+	cand = list_entry(super->s_free_list.prev, struct gc_candidate, list);
+	list_del(&cand->list);
+	area->a_segno = cand->segno;
+	kfree(cand);
+	super->s_free_count -= 1;
+}
+
+
+static void ostore_get_erase_count(struct logfs_area *area)
+{
+	struct logfs_segment_header h;
+	int err;
+
+	err = device_read(area->a_sb, area->a_segno, 0, sizeof(h), &h);
+	BUG_ON(err);
+	area->a_erase_count = be32_to_cpu(h.ec) + 1;
+}
+
+
+static int ostore_erase_segment(struct logfs_area *area)
+{
+	struct logfs_segment_header h;
+	u64 ofs;
+	int err;
+
+	err = logfs_erase_segment(area->a_sb, area->a_segno);
+	if (err)
+		return err;
+
+	h.len = 0;
+	h.type = OBJ_OSTORE;
+	h.level = area->a_level;
+	h.segno = cpu_to_be32(area->a_segno);
+	h.ec = cpu_to_be32(area->a_erase_count);
+	h.gec = cpu_to_be64(LOGFS_SUPER(area->a_sb)->s_gec);
+	h.crc = logfs_crc32(&h, sizeof(h), 4);
+
+	ofs = dev_ofs(area->a_sb, area->a_segno, 0);
+	area->a_used_bytes = sizeof(h);
+	return buf_write(area, ofs, &h, sizeof(h));
+}
+
+
+static void flush_buf(struct logfs_area *area)
+{
+	struct super_block *sb = area->a_sb;
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	u32 used, free;
+	u64 ofs;
+	u32 writemask = super->s_writesize - 1;
+	int err;
+
+	ofs = dev_ofs(sb, area->a_segno, area->a_used_bytes);
+	ofs &= ~writemask;
+	used = area->a_used_bytes & writemask;
+	free = super->s_writesize - area->a_used_bytes;
+	free &= writemask;
+	if (used == 0)
+		return;
+
+	memset(area->a_wbuf + used, 0xff, free);
+	err = mtdwrite(sb, ofs, super->s_writesize, area->a_wbuf);
+	LOGFS_BUG_ON(err, sb);
+}
+
+
+static void ostore_finish_area(struct logfs_area *area)
+{
+	struct super_block *sb = area->a_sb;
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	u32 remaining = super->s_segsize - area->a_used_bytes;
+	u32 needed = sb->s_blocksize + sizeof(struct logfs_segment_header);
+
+	if (remaining > needed)
+		return;
+
+	flush_buf(area);
+
+	area->a_segno = 0;
+	area->a_is_open = 0;
+}
+
+
+static struct logfs_area_ops ostore_area_ops = {
+	.get_free_segment	= ostore_get_free_segment,
+	.get_erase_count	= ostore_get_erase_count,
+	.erase_segment		= ostore_erase_segment,
+	.finish_area		= ostore_finish_area,
+};
+
+
+static void cleanup_ostore_area(struct logfs_area *area)
+{
+	kfree(area->a_wbuf);
+	kfree(area);
+}
+
+
+static void *init_ostore_area(struct super_block *sb, int level)
+{
+	struct logfs_area *area;
+	size_t writesize;
+
+	writesize = LOGFS_SUPER(sb)->s_writesize;
+
+	area = kzalloc(sizeof(*area), GFP_KERNEL);
+	if (!area)
+		return NULL;
+	if (writesize > 1) {
+		area->a_wbuf = kmalloc(writesize, GFP_KERNEL);
+		if (!area->a_wbuf)
+			goto err;
+	}
+
+	area->a_sb = sb;
+	area->a_level = level;
+	area->a_ops = &ostore_area_ops;
+	return area;
+
+err:
+	cleanup_ostore_area(area);
+	return NULL;
+}
+
+
+int logfs_init_areas(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int i;
+
+	super->s_journal_area = kzalloc(sizeof(struct logfs_area), GFP_KERNEL);
+	if (!super->s_journal_area)
+		return -ENOMEM;
+	super->s_journal_area->a_sb = sb;
+
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		super->s_area[i] = init_ostore_area(sb, i);
+		if (!super->s_area[i])
+			goto err;
+	}
+	return 0;
+
+err:
+	for (i--; i>=0; i--)
+		cleanup_ostore_area(super->s_area[i]);
+	kfree(super->s_journal_area);
+	return -ENOMEM;
+}
+
+
+void logfs_cleanup_areas(struct logfs_super *super)
+{
+	int i;
+
+	for (i=0; i<LOGFS_NO_AREAS; i++)
+		cleanup_ostore_area(super->s_area[i]);
+	kfree(super->s_journal_area);
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/super.c	2007-05-10 19:55:06.000000000 +0200
@@ -0,0 +1,419 @@
+/*
+ * fs/logfs/super.c
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ *
+ * Generally contains mount/umount code and also serves and a dump area for
+ * any functions that don't fit elsewhere and neither justify a file of their
+ * own.
+ */
+#include "logfs.h"
+
+
+int mtdread(struct super_block *sb, loff_t ofs, size_t len, void *buf)
+{
+	struct mtd_info *mtd = LOGFS_SUPER(sb)->s_mtd;
+	size_t retlen;
+	int ret;
+
+	ret = mtd->read(mtd, ofs, len, &retlen, buf);
+	BUG_ON(ret == -EINVAL);
+	if (ret)
+		return ret;
+
+	/* Not sure if we should loop instead. */
+	if (retlen != len)
+		return -EIO;
+
+	return 0;
+}
+
+
+int mtdwrite(struct super_block *sb, loff_t ofs, size_t len, void *buf)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct mtd_info *mtd = super->s_mtd;
+	struct inode *inode = super->s_dev_inode;
+	size_t retlen;
+	loff_t page_start, page_end;
+	int ret;
+
+	BUG_ON((ofs >= mtd->size) || (len > mtd->size - ofs));
+	BUG_ON(ofs != (ofs >> super->s_writeshift) << super->s_writeshift);
+	BUG_ON(len > PAGE_CACHE_SIZE);
+	page_start = ofs & PAGE_CACHE_MASK;
+	page_end = PAGE_CACHE_ALIGN(ofs + len) - 1;
+	truncate_inode_pages_range(&inode->i_data, page_start, page_end);
+	ret = mtd->write(mtd, ofs, len, &retlen, buf);
+	if (ret || (retlen != len))
+		return -EIO;
+
+	return 0;
+}
+
+
+/*
+ * For as long as I can remember (since about 2001) mtd->erase has been an
+ * asynchronous interface lacking the first driver to actually use the
+ * asynchronous properties.  So just to prevent the first implementor of such
+ * a thing from breaking logfs in 2350, we do the usual pointless dance to
+ * declare a completion variable and wait for completion before returning
+ * from mtderase().  What an excercise in futility!
+ */
+static DECLARE_COMPLETION(logfs_erase_complete);
+
+
+static void logfs_erase_callback(struct erase_info *ei)
+{
+	complete(&logfs_erase_complete);
+}
+
+
+int mtderase(struct super_block *sb, loff_t ofs, size_t len)
+{
+	struct mtd_info *mtd = LOGFS_SUPER(sb)->s_mtd;
+	struct inode *inode = LOGFS_SUPER(sb)->s_dev_inode;
+	struct erase_info ei;
+	int ret;
+
+	BUG_ON(len % mtd->erasesize);
+
+	truncate_inode_pages_range(&inode->i_data, ofs, ofs+len-1);
+	memset(&ei, 0, sizeof(ei));
+	ei.mtd = mtd;
+	ei.addr = ofs;
+	ei.len = len;
+	ei.callback = logfs_erase_callback;
+	ret = mtd->erase(mtd, &ei);
+	if (ret)
+		return -EIO;
+
+	wait_for_completion(&logfs_erase_complete);
+	if (ei.state != MTD_ERASE_DONE)
+		return -EIO;
+	return 0;
+}
+
+
+static void dump_write(struct super_block *sb, int ofs, void *buf)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+
+	if (ofs << sb->s_blocksize_bits >= super->s_segsize)
+		return;
+	mtdwrite(sb, ofs << sb->s_blocksize_bits, sb->s_blocksize, buf);
+}
+
+
+/*
+ * logfs_crash_dump - dump debug information to device
+ *
+ * The LogFS superblock only occupies part of a segment.  This function will
+ * write as much debug information as it can gather into the spare space.
+ */
+void logfs_crash_dump(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int i, ofs = 2, bs = sb->s_blocksize;
+	void *scratch = super->s_wblock[0];
+	void *stack = (void *) ((ulong)current & ~0x1fffUL);
+
+	/* all wbufs */
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		void *wbuf = super->s_area[i]->a_wbuf;
+		u64 ofs = sb->s_blocksize + i*super->s_writesize;
+		mtdwrite(sb, ofs, super->s_writesize, wbuf);
+	}
+	/* both superblocks */
+	memset(scratch, 0, bs);
+	memcpy(scratch, super, sizeof(*super));
+	memcpy(scratch + sizeof(*super) + 32, sb, sizeof(*sb));
+	dump_write(sb, ofs++, scratch);
+	/* process stack */
+	dump_write(sb, ofs++, stack);
+	dump_write(sb, ofs++, stack + 0x1000);
+	/* wblocks are interesting whenever readwrite.c causes problems */
+	for (i=0; i<LOGFS_MAX_LEVELS; i++)
+		dump_write(sb, ofs++, super->s_wblock[i]);
+}
+
+
+int all_ff(void *buf, size_t len)
+{
+	unsigned char *c = buf;
+	int i;
+
+	for (i=0; i<len; i++)
+		if (c[i] != 0xff)
+			return 0;
+	return 1;
+}
+
+
+/*
+ * FIXME: There should be a reserve for root, similar to ext2.
+ */
+int logfs_statfs(struct dentry *dentry, struct kstatfs *stats)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct logfs_super *super = LOGFS_SUPER(sb);
+
+	stats->f_type	= LOGFS_MAGIC_U32;
+	stats->f_bsize	= sb->s_blocksize;
+	stats->f_blocks	= super->s_size >> LOGFS_BLOCK_BITS >> 3;
+	stats->f_bfree	= super->s_free_bytes >> sb->s_blocksize_bits;
+	stats->f_bavail	= super->s_free_bytes >> sb->s_blocksize_bits;
+	stats->f_files	= 0;
+	stats->f_ffree	= 0;
+	stats->f_namelen= LOGFS_MAX_NAMELEN;
+	return 0;
+}
+
+
+static int logfs_sb_set(struct super_block *sb, void *_super)
+{
+	struct logfs_super *super = _super;
+
+	sb->s_fs_info = super;
+	sb->s_dev = MKDEV(MTD_BLOCK_MAJOR, super->s_mtd->index);
+
+	return 0;
+}
+
+
+static int logfs_get_sb_final(struct super_block *sb, struct vfsmount *mnt)
+{
+	struct inode *rootdir;
+	int err;
+
+	/* root dir */
+	rootdir = iget(sb, LOGFS_INO_ROOT);
+	if (!rootdir)
+		goto fail;
+
+	sb->s_root = d_alloc_root(rootdir);
+	if (!sb->s_root)
+		goto fail;
+
+#if 1
+	err = logfs_fsck(sb);
+#else
+	err = 0;
+#endif
+	if (err) {
+		printk(KERN_ERR "LOGFS: fsck failed, refusing to mount\n");
+		goto fail;
+	}
+
+	return simple_set_mnt(mnt, sb);
+
+fail:
+	iput(LOGFS_SUPER(sb)->s_master_inode);
+	return -EIO;
+}
+
+
+static int logfs_read_sb(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_disk_super ds;
+	int i, ret;
+
+	ret = mtdread(sb, 0, sizeof(ds), &ds);
+	if (ret)
+		return ret;
+
+	super->s_dev_inode = logfs_new_meta_inode(sb, 0);
+	if (IS_ERR(super->s_dev_inode))
+		return PTR_ERR(super->s_dev_inode);
+
+	if (be64_to_cpu(ds.ds_magic) != LOGFS_MAGIC) {
+		ret = logfs_mkfs(sb, &ds);
+		if (ret)
+			goto out0;
+	}
+	super->s_size = be64_to_cpu(ds.ds_filesystem_size);
+	super->s_root_reserve = be64_to_cpu(ds.ds_root_reserve);
+	super->s_segsize = 1 << ds.ds_segment_shift;
+	super->s_segshift = ds.ds_segment_shift;
+	sb->s_blocksize = 1 << ds.ds_block_shift;
+	sb->s_blocksize_bits = ds.ds_block_shift;
+	super->s_writesize = 1 << ds.ds_write_shift;
+	super->s_writeshift = ds.ds_write_shift;
+	super->s_no_segs = super->s_size >> super->s_segshift;
+	super->s_no_blocks = super->s_segsize >> sb->s_blocksize_bits;
+
+	journal_for_each(i)
+		super->s_journal_seg[i] = be64_to_cpu(ds.ds_journal_seg[i]);
+
+	super->s_ifile_levels = ds.ds_ifile_levels;
+	super->s_iblock_levels = ds.ds_iblock_levels;
+	super->s_data_levels = ds.ds_data_levels;
+	super->s_total_levels = super->s_ifile_levels + super->s_iblock_levels
+		+ super->s_data_levels;
+	super->s_gc_reserve = super->s_total_levels * (2*super->s_no_blocks -1);
+	super->s_gc_reserve <<= sb->s_blocksize_bits;
+
+	mutex_init(&super->s_victim_mutex);
+	mutex_init(&super->s_rename_mutex);
+	spin_lock_init(&super->s_ino_lock);
+	INIT_LIST_HEAD(&super->s_freeing_list);
+
+	ret = logfs_init_rw(super);
+	if (ret)
+		goto out0;
+
+	ret = logfs_init_areas(sb);
+	if (ret)
+		goto out1;
+
+	ret = logfs_init_journal(sb);
+	if (ret)
+		goto out2;
+
+	ret = logfs_init_gc(super);
+	if (ret)
+		goto out3;
+
+	/* after all initializations are done, replay the journal
+	 * for rw-mounts, if necessary */
+	ret = logfs_replay_journal(sb);
+	if (ret)
+		goto out4;
+	return 0;
+
+out4:
+	logfs_cleanup_gc(super);
+out3:
+	logfs_cleanup_journal(sb);
+out2:
+	logfs_cleanup_areas(super);
+out1:
+	logfs_cleanup_rw(super);
+out0:
+	__logfs_destroy_inode(super->s_dev_inode);
+	return ret;
+}
+
+
+static void logfs_kill_sb(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+
+	generic_shutdown_super(sb);
+	logfs_cleanup_gc(super);
+	logfs_cleanup_journal(sb);
+	logfs_cleanup_areas(super);
+	logfs_cleanup_rw(super);
+	__logfs_destroy_inode(super->s_dev_inode);
+	put_mtd_device(super->s_mtd);
+	kfree(super);
+}
+
+
+static int logfs_get_sb_mtd(struct file_system_type *type, int flags,
+		struct mtd_info *mtd, struct vfsmount *mnt)
+{
+	struct logfs_super *super = NULL;
+	struct super_block *sb;
+	int err = -ENOMEM;
+
+	super = kzalloc(sizeof*super, GFP_KERNEL);
+	if (!super)
+		goto err0;
+
+	super->s_mtd = mtd;
+	err = -EINVAL;
+	sb = sget(type, NULL, logfs_sb_set, super);
+	if (IS_ERR(sb))
+		goto err0;
+
+	sb->s_maxbytes	= LOGFS_I3_SIZE;
+	sb->s_op	= &logfs_super_operations;
+	sb->s_flags	= flags | MS_NOATIME;
+
+	err = logfs_read_sb(sb);
+	if (err)
+		goto err1;
+
+	sb->s_flags |= MS_ACTIVE;
+	err = logfs_get_sb_final(sb, mnt);
+	if (err)
+		goto err1;
+	return 0;
+
+err1:
+	up_write(&sb->s_umount);
+	deactivate_super(sb);
+	return err;
+err0:
+	kfree(super);
+	put_mtd_device(mtd);
+	return err;
+}
+
+
+static int logfs_get_sb(struct file_system_type *type, int flags,
+		const char *devname, void *data, struct vfsmount *mnt)
+{
+	ulong mtdnr;
+	struct mtd_info *mtd;
+
+	if (!devname)
+		return -EINVAL;
+	if (strncmp(devname, "mtd", 3))
+		return -EINVAL;
+
+	{
+		char *garbage;
+		mtdnr = simple_strtoul(devname+3, &garbage, 0);
+		if (*garbage)
+			return -EINVAL;
+	}
+
+	mtd = get_mtd_device(NULL, mtdnr);
+	if (!mtd)
+		return -EINVAL;
+
+	return logfs_get_sb_mtd(type, flags, mtd, mnt);
+}
+
+
+static struct file_system_type logfs_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "logfs",
+	.get_sb		= logfs_get_sb,
+	.kill_sb	= logfs_kill_sb,
+};
+
+
+static int __init logfs_init(void)
+{
+	int ret;
+
+	ret = logfs_compr_init();
+	if (ret)
+		return ret;
+
+	ret = logfs_init_inode_cache();
+	if (ret) {
+		logfs_compr_exit();
+		return ret;
+	}
+
+	return register_filesystem(&logfs_fs_type);
+}
+
+
+static void __exit logfs_exit(void)
+{
+	unregister_filesystem(&logfs_fs_type);
+	logfs_destroy_inode_cache();
+	logfs_compr_exit();
+}
+
+
+module_init(logfs_init);
+module_exit(logfs_exit);
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/progs/fsck.c	2007-05-15 00:54:22.000000000 +0200
@@ -0,0 +1,332 @@
+/*
+ * fs/logfs/prog/fsck.c	- filesystem check
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ *
+ * In principle this could get moved to userspace.  However it might still
+ * make some sense to keep it in the kernel.  It is a pure checker and will
+ * only report problems, not attempt to repair them.
+ */
+#include "../logfs.h"
+
+static u64 used_bytes;
+static u64 free_bytes;
+static u64 last_ino;
+static u64 *inode_bytes;
+static u64 *inode_links;
+
+
+/*
+ * Pass 1: blocks
+ */
+
+
+static u32 logfs_free_bytes(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_segment_header sh;
+	struct logfs_object_header h;
+	u64 ofs, ino, pos;
+	u32 seg_ofs, free, size;
+	u16 len;
+	int err;
+	void *reserved;
+
+	/* Some segments are reserved.  Just pretend they were all valid */
+	reserved = btree_lookup(&super->s_reserved_segments, segno);
+	if (reserved)
+		return 0;
+
+	err = wbuf_read(sb, dev_ofs(sb, segno, 0), sizeof(sh), &sh);
+	BUG_ON(err);
+	if (all_ff(&sh, sizeof(sh)))
+		return super->s_segsize;
+
+	free = super->s_segsize;
+	for (seg_ofs = sizeof(h); seg_ofs + sizeof(h) < super->s_segsize; ) {
+		wbuf_read(sb, dev_ofs(sb, segno, seg_ofs), sizeof(h), &h);
+		BUG_ON(err);
+		if (all_ff(&h, sizeof(h)))
+			break;
+
+		ofs = dev_ofs(sb, segno, seg_ofs);
+		ino = be64_to_cpu(h.ino);
+		pos = be64_to_cpu(h.pos);
+		len = be16_to_cpu(h.len);
+		size = (u32)be16_to_cpu(h.len) + sizeof(h);
+		if (logfs_is_valid_block(sb, ofs, ino, pos)) {
+			if (sh.level != 0)
+				len = sb->s_blocksize;
+			inode_bytes[ino] += len + sizeof(h);
+			free -= len + sizeof(h);
+		}
+		seg_ofs += size;
+	}
+	return free;
+}
+
+
+static void logfsck_blocks(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int i;
+	int free;
+
+	printk(KERN_INFO);
+	for (i=0; i<super->s_no_segs; i++) {
+		free = logfs_free_bytes(sb, i);
+		free_bytes += free;
+		printk(" %5x", free);
+		if (i % 8 == 7)
+			printk("\n" KERN_INFO);
+	}
+	printk("\n");
+}
+
+
+/*
+ * Pass 2: directories
+ */
+
+
+static noinline int read_one_dd(struct inode *dir, loff_t pos, u64 *ino,
+		u8 *type)
+{
+	struct logfs_disk_dentry dd;
+	int err;
+
+	err = logfs_inode_read(dir, &dd, sizeof(dd), pos);
+	if (err)
+		return err;
+	*ino = be64_to_cpu(dd.ino);
+	*type = dd.type;
+	return 0;
+}
+
+
+static s64 dir_seek_data(struct inode *inode, s64 pos)
+{
+	s64 new_pos = logfs_seek_data(inode, pos);
+
+	return max((s64)pos, new_pos - 1);
+}
+
+
+static int __logfsck_dirs(struct inode *dir)
+{
+	struct inode *inode;
+	loff_t pos;
+	u64 ino;
+	u8 type;
+	int cookie, err, ret = 0;
+
+	for (pos=0; ; pos++) {
+		err = read_one_dd(dir, pos, &ino, &type);
+		if (err == -ENODATA) {
+			/* dentry was deleted */
+			pos = dir_seek_data(dir, pos);
+			continue;
+		}
+		if (err == -EOF)
+			break;
+		if (err)
+			goto error0;
+
+		err = -EIO;
+		if (ino > last_ino) {
+			printk(KERN_INFO "ino %llx > last_ino %llx\n",
+					ino, last_ino);
+			goto error0;
+		}
+		inode = logfs_iget(dir->i_sb, ino, &cookie);
+		if (!inode) {
+			printk(KERN_INFO "Could not find inode #%llx\n", ino);
+			goto error0;
+		}
+		if (type != logfs_type(inode)) {
+			printk(KERN_INFO "dd type %x != inode type %x\n",
+					type, logfs_type(inode));
+			goto error1;
+		}
+		inode_links[ino]++;
+		err = 0;
+		if (type == DT_DIR) {
+			inode_links[dir->i_ino]++;
+			inode_links[ino]++;
+			err = __logfsck_dirs(inode);
+		}
+error1:
+		logfs_iput(inode, cookie);
+error0:
+		if (!ret)
+			ret = err;
+		continue;
+	}
+	return 1;
+}
+
+
+static int logfsck_dirs(struct super_block *sb)
+{
+	struct inode *dir;
+	int cookie;
+
+	dir = logfs_iget(sb, LOGFS_INO_ROOT, &cookie);
+	if (!dir)
+		return 0;
+
+	inode_links[LOGFS_INO_MASTER] += 1;
+	inode_links[LOGFS_INO_ROOT] += 2;
+	__logfsck_dirs(dir);
+
+	logfs_iput(dir, cookie);
+	return 1;
+}
+
+
+/*
+ * Pass 3: inodes
+ */
+
+
+static int logfs_check_inode(struct inode *inode)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	u64 bytes0 = li->li_used_bytes;
+	u64 bytes1 = inode_bytes[inode->i_ino];
+	u64 links0 = inode->i_nlink;
+	u64 links1 = inode_links[inode->i_ino];
+
+	if (bytes0 || bytes1 || links0 || links1
+			|| inode->i_ino == LOGFS_SUPER(inode->i_sb)->s_last_ino)
+		printk(KERN_INFO "%lx: %llx(%llx) bytes, %llx(%llx) links\n",
+				inode->i_ino, bytes0, bytes1, links0, links1);
+	used_bytes += bytes0;
+	return (bytes0 == bytes1) && (links0 == links1);
+}
+
+
+static int logfs_check_ino(struct super_block *sb, u64 ino)
+{
+	struct inode *inode;
+	int ret, cookie;
+
+	inode = logfs_iget(sb, ino, &cookie);
+	if (!inode)
+		return 1;
+	ret = logfs_check_inode(inode);
+	logfs_iput(inode, cookie);
+	return ret;
+}
+
+
+static int logfsck_inodes(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	s64 i;
+	int ret = 1;
+
+	if (!logfs_check_ino(sb, LOGFS_INO_MASTER))
+		ret = 0;;
+	if (!logfs_check_ino(sb, LOGFS_INO_ROOT))
+		ret = 0;
+	for (i=16; i<super->s_last_ino; i++) {
+		i = dir_seek_data(super->s_master_inode, i);
+		if (!logfs_check_ino(sb, i))
+			ret = 0;;
+	}
+	return ret;
+}
+
+
+/*
+ * Pass 4: Total blocks
+ */
+
+
+static int logfsck_stats(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	u64 ostore_segs, total, expected;
+	int i, reserved_segs;
+
+	/* one for the superblock */
+	reserved_segs = 1;
+	journal_for_each(i)
+		if (super->s_journal_seg[i])
+			reserved_segs++;
+	reserved_segs += super->s_bad_segments;
+
+	ostore_segs = super->s_no_segs - reserved_segs;
+	expected = ostore_segs << super->s_segshift;
+	total = free_bytes + used_bytes;
+
+	printk(KERN_INFO "free:%8llx, used:%8llx, total:%8llx",
+			free_bytes, used_bytes, expected);
+	if (total > expected)
+		printk(" + %llx\n", total - expected);
+	else if (total < expected)
+		printk(" - %llx\n", expected - total);
+	else
+		printk("\n");
+
+	return total == expected;
+}
+
+
+static int __logfs_fsck(struct super_block *sb)
+{
+	int ret;
+	int err = 0;
+
+	/* pass 1: check blocks */
+	logfsck_blocks(sb);
+	/* pass 2: check directories */
+	ret = logfsck_dirs(sb);
+	if (!ret) {
+		printk(KERN_ERR "Pass 2: directory check failed\n");
+		err = -EIO;
+	}
+	/* pass 3: check inodes */
+	ret = logfsck_inodes(sb);
+	if (!ret) {
+		printk(KERN_ERR "Pass 3: inode check failed\n");
+		err = -EIO;
+	}
+	/* Pass 4: Total blocks */
+	ret = logfsck_stats(sb);
+	if (!ret) {
+		printk(KERN_ERR "Pass 4: statistic check failed\n");
+		err = -EIO;
+	}
+
+	return err;
+}
+
+
+int logfs_fsck(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int ret = -ENOMEM;
+
+	used_bytes = 0;
+	free_bytes = 0;
+	last_ino = super->s_last_ino;
+	inode_bytes = kzalloc(last_ino * sizeof(u64), GFP_KERNEL);
+	if (!inode_bytes)
+		return ret;
+	inode_links = kzalloc(last_ino * sizeof(u64), GFP_KERNEL);
+	if (!inode_links)
+		goto err;
+
+	ret = __logfs_fsck(sb);
+
+	kfree(inode_links);
+	inode_links = NULL;
+err:
+	kfree(inode_bytes);
+	inode_bytes = NULL;
+	return ret;
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/progs/mkfs.c	2007-05-14 22:16:32.000000000 +0200
@@ -0,0 +1,334 @@
+/*
+ * fs/logfs/prog/mkfs.c	- filesystem generation
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ *
+ * Should get moved to userspace.
+ */
+#include "../logfs.h"
+
+enum {
+	OFS_SB = 0,
+	OFS_JOURNAL,
+	OFS_ROOTDIR,
+	OFS_IFILE,
+	OFS_COUNT
+};
+
+static u64 segment_offset[OFS_COUNT];
+
+static u64 fssize;
+static u64 no_segs;
+static u64 free_blocks;
+
+static u32 segsize;
+static u32 blocksize;
+static int segshift;
+static int blockshift;
+static int writeshift;
+
+static u32 blocks_per_seg;
+static u16 version;
+
+static __be32 bb_array[1024];
+static int bb_count;
+
+
+#if 0
+/* rootdir */
+static int make_rootdir(struct super_block *sb)
+{
+	struct logfs_disk_inode *di;
+	int ret;
+
+	di = kzalloc(blocksize, GFP_KERNEL);
+	if (!di)
+		return -ENOMEM;
+
+	di->di_flags	= cpu_to_be32(LOGFS_IF_VALID);
+	di->di_mode	= cpu_to_be16(S_IFDIR | 0755);
+	di->di_refcount	= cpu_to_be32(2);
+	ret = mtdwrite(sb, segment_offset[OFS_ROOTDIR], blocksize, di);
+	kfree(di);
+	return ret;
+}
+
+
+/* summary */
+static int make_summary(struct super_block *sb)
+{
+	struct logfs_disk_sum *sum;
+	u64 sum_ofs;
+	int ret;
+
+	sum = kzalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
+	if (!sum)
+		return -ENOMEM;
+	memset(sum, 0xff, LOGFS_BLOCKSIZE);
+
+	sum->oids[0].ino = cpu_to_be64(LOGFS_INO_MASTER);
+	sum->oids[0].pos = cpu_to_be64(LOGFS_INO_ROOT);
+	sum_ofs = segment_offset[OFS_ROOTDIR];
+	sum_ofs += segsize - blocksize;
+	sum->level = LOGFS_MAX_LEVELS;
+	ret = mtdwrite(sb, sum_ofs, LOGFS_BLOCKSIZE, sum);
+	kfree(sum);
+	return ret;
+}
+#endif
+
+
+/* journal */
+static size_t __write_header(struct logfs_journal_header *h, size_t len,
+		size_t datalen, u16 type, u8 compr)
+{
+	h->h_len	= cpu_to_be16(len);
+	h->h_type	= cpu_to_be16(type);
+	h->h_version	= cpu_to_be16(++version);
+	h->h_datalen	= cpu_to_be16(datalen);
+	h->h_compr	= compr;
+	h->h_pad[0]	= 'h';
+	h->h_pad[1]	= 'a';
+	h->h_pad[2]	= 't';
+	h->h_crc	= logfs_crc32(h, len, 4);
+	return len;
+}
+
+
+static size_t write_header(struct logfs_journal_header *h, size_t datalen,
+		u16 type)
+{
+	size_t len = datalen + sizeof(*h);
+	return __write_header(h, len, datalen, type, COMPR_NONE);
+}
+
+
+static size_t je_badsegments(void *data, u16 *type)
+{
+	memcpy(data, bb_array, blocksize);
+	*type = JE_BADSEGMENTS;
+	return blocksize;
+}
+
+
+static size_t je_anchor(void *_da, u16 *type)
+{
+	struct logfs_je_anchor *da = _da;
+
+	memset(da, 0, sizeof(*da));
+	da->da_last_ino	= cpu_to_be64(LOGFS_RESERVED_INOS);
+	da->da_size	= cpu_to_be64((LOGFS_INO_ROOT+1) * blocksize);
+#if 0
+	da->da_used_bytes = cpu_to_be64(blocksize);
+	da->da_data[LOGFS_INO_ROOT] = cpu_to_be64(3*segsize);
+#else
+	da->da_data[LOGFS_INO_ROOT] = 0;
+#endif
+	*type = JE_ANCHOR;
+	return sizeof(*da);
+}
+
+
+static size_t je_dynsb(void *_dynsb, u16 *type)
+{
+	struct logfs_je_dynsb *dynsb = _dynsb;
+
+	memset(dynsb, 0, sizeof(*dynsb));
+	dynsb->ds_used_bytes	= cpu_to_be64(blocksize);
+	*type = JE_DYNSB;
+	return sizeof(*dynsb);
+}
+
+
+static size_t je_commit(void *h, u16 *type)
+{
+	*type = JE_COMMIT;
+	return 0;
+}
+
+
+static size_t write_je(size_t jpos, void *scratch, void *header,
+		size_t (*write)(void *scratch, u16 *type))
+{
+	void *data;
+	ssize_t len, max, compr_len, pad_len, full_len;
+	u16 type;
+	u8 compr = COMPR_ZLIB;
+
+	header += jpos;
+	data = header + sizeof(struct logfs_journal_header);
+
+	len = write(scratch, &type);
+	if (len == 0)
+		return write_header(header, 0, type);
+
+	max = blocksize - jpos;
+	compr_len = logfs_compress(scratch, data, len, max);
+	if ((compr_len < 0) || (type == JE_ANCHOR)) {
+		compr_len = logfs_memcpy(scratch, data, len, max);
+		compr = COMPR_NONE;
+	}
+	BUG_ON(compr_len < 0);
+
+	pad_len = ALIGN(compr_len, 16);
+	memset(data + compr_len, 0, pad_len - compr_len);
+	full_len = pad_len + sizeof(struct logfs_journal_header);
+
+	return __write_header(header, full_len, len, type, compr);
+}
+
+
+static int make_journal(struct super_block *sb)
+{
+	void *journal, *scratch;
+	size_t jpos;
+	int ret;
+
+	journal = kzalloc(2*blocksize, GFP_KERNEL);
+	if (!journal)
+		return -ENOMEM;
+
+	scratch = journal + blocksize;
+
+	jpos = 0;
+	/* erasecount is not written - implicitly set to 0 */
+	/* neither are summary, index, wbuf */
+	jpos += write_je(jpos, scratch, journal, je_badsegments);
+	jpos += write_je(jpos, scratch, journal, je_anchor);
+	jpos += write_je(jpos, scratch, journal, je_dynsb);
+	jpos += write_je(jpos, scratch, journal, je_commit);
+	ret = mtdwrite(sb, segment_offset[OFS_JOURNAL], blocksize, journal);
+	kfree(journal);
+	return ret;
+}
+
+
+/* superblock */
+static int make_super(struct super_block *sb, struct logfs_disk_super *ds)
+{
+	void *sector;
+	int ret;
+
+	sector = kzalloc(4096, GFP_KERNEL);
+	if (!sector)
+		return -ENOMEM;
+
+	memset(ds, 0, sizeof(*ds));
+
+	ds->ds_magic		= cpu_to_be64(LOGFS_MAGIC);
+	ds->ds_ifile_levels	= 1; /* 2+1, 1GiB */
+	ds->ds_iblock_levels	= 4; /* 3+1, 512GiB */
+	ds->ds_data_levels	= 1; /* old, young, unknown */
+
+	ds->ds_feature_incompat	= 0;
+	ds->ds_feature_ro_compat= 0;
+
+	ds->ds_feature_compat	= 0;
+	ds->ds_flags		= 0;
+
+	ds->ds_filesystem_size	= cpu_to_be64(fssize);
+	ds->ds_segment_shift	= segshift;
+	ds->ds_block_shift	= blockshift;
+	ds->ds_write_shift	= writeshift;
+
+	ds->ds_journal_seg[0]	= cpu_to_be64(1);
+	ds->ds_journal_seg[1]	= cpu_to_be64(2);
+	ds->ds_journal_seg[2]	= 0;
+	ds->ds_journal_seg[3]	= 0;
+
+	ds->ds_root_reserve	= 0;
+
+	ds->ds_crc = logfs_crc32(ds, sizeof(*ds), 12);
+
+	memcpy(sector, ds, sizeof(*ds));
+	ret = mtdwrite(sb, segment_offset[OFS_SB], 4096, sector);
+	kfree(sector);
+	return ret;
+}
+
+
+/* main */
+static void getsize(struct super_block *sb, u64 *size,
+		u64 *no_segs)
+{
+	*no_segs = LOGFS_SUPER(sb)->s_mtd->size >> segshift;
+	*size = *no_segs << segshift;
+}
+
+
+static int bad_block_scan(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct mtd_info *mtd = super->s_mtd;
+	int k, seg=0;
+	u64 ofs;
+
+	bb_count = 0;
+	for (ofs=0; ofs<fssize; ofs+=segsize) {
+		int bad = 0;
+
+		for (k=0; k<segsize; k+=mtd->erasesize) {
+			/* iterate subblocks */
+			bad = bad ? : mtd->block_isbad(mtd, ofs+k);
+		}
+		if (!bad) {
+			if (seg < OFS_COUNT)
+				segment_offset[seg++] = ofs;
+			continue;
+		}
+
+		if (bb_count > 512)
+			return -EIO;
+		bb_array[bb_count++] = cpu_to_be32(ofs >> segshift);
+	}
+	return 0;
+}
+
+
+int logfs_mkfs(struct super_block *sb, struct logfs_disk_super *ds)
+{
+	int ret = 0;
+
+	segshift = 17;
+	blockshift = 12;
+	writeshift = 8;
+
+	segsize = 1 << segshift;
+	blocksize = 1 << blockshift;
+	version = 0;
+
+	getsize(sb, &fssize, &no_segs);
+
+	/* 3 segs for sb and journal,
+	 * 1 block per seg extra,
+	 * 1 block for rootdir
+	 */
+	blocks_per_seg = 1 << (segshift - blockshift);
+	free_blocks = (no_segs - 3) * (blocks_per_seg - 1) - 1;
+
+	ret = bad_block_scan(sb);
+	if (ret)
+		return ret;
+
+#if 0
+	ret = make_rootdir(sb);
+	if (ret)
+		return ret;
+
+	ret = make_summary(sb);
+	if (ret)
+		return ret;
+#endif
+
+	ret = make_journal(sb);
+	if (ret)
+		return ret;
+
+	ret = make_super(sb, ds);
+	if (ret)
+		return ret;
+
+	return 0;
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/Locking	2007-05-10 19:07:24.000000000 +0200
@@ -0,0 +1,45 @@
+Locks:
+
+s_victim_mutex
+Protects victim inode for create, unlink, mkdir, rmdir, mknod, link,
+symlink and one variant of rename.  Only one victim inode may exist at
+a time.  In case of unclean unmount, victim inode has to be deleted
+before next read-writable mount.
+
+s_rename_mutex
+Protects victim dd for rename.  Only one victim dd may exist at a
+time.  In case of unclean unmount, victim dd has to be deleted before
+next read-writable mount.
+
+s_write_inode_mutex
+Taken when writing an inode.  Deleted inodes can be locked, preventing
+further iget operations during writeout.  Logfs may need to iget the
+inode for garbage collection, so the inode in question needs to be
+stored in the superblock and used directly without calling iget.
+
+s_log_sem
+Used for allocating space in journal.
+
+s_r_sem
+Protects the memory required for reads from the filesystem.
+
+s_w_sem
+Protects the memory required for writes to the filesystem.
+
+s_ino_lock
+Protects s_last_ino.
+
+
+Lock order:
+s_rename_mutex --> s_victim_mutex
+s_rename_mutex --> s_write_inode_mutex
+s_rename_mutex --> s_w_sem
+
+s_victim_mutex --> s_write_inode_mutex
+s_victim_mutex --> s_w_sem
+s_victim_mutex --> s_ino_lock
+
+s_write_inode_mutex --> s_w_sem
+
+s_w_sem --> s_log_sem
+s_w_sem --> s_r_sem
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/include/linux/logfs.h	2007-05-15 15:52:04.000000000 +0200
@@ -0,0 +1,477 @@
+/*
+ * fs/logfs/logfs.h
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ *
+ * Public header for logfs.
+ */
+#ifndef linux_logfs_h
+#define linux_logfs_h
+
+
+/*
+ * Throughout the logfs code, we're constantly dealing with blocks at
+ * various positions or offsets.  To remove confusion, we stricly
+ * distinguish between a "position" - the logical position within a
+ * file and an "offset" - the physical location within the device.
+ *
+ * Any usage of the term offset for a logical location or position for
+ * a physical one is a bug and should get fixed.
+ */
+
+/*
+ * Block are allocated in one of several segments depending on their
+ * level.  The following levels are used:
+ *  0	- regular data block
+ *  1	- i1 indirect blocks
+ *  2	- i2 indirect blocks
+ *  3	- i3 indirect blocks
+ *  4	- i4 indirect blocks
+ *  5	- i5 indirect blocks
+ *  6	- ifile data blocks
+ *  7	- ifile i1 indirect blocks
+ *  8	- ifile i2 indirect blocks
+ *  9	- ifile i3 indirect blocks
+ * 10	- ifile i4 indirect blocks
+ * 11	- ifile i5 indirect blocks
+ * Potential levels to be used in the future:
+ * 12	- gc recycled blocks, long-lived data
+ * 13	- replacement blocks, short-lived data
+ *
+ * Levels 1-11 are necessary for robust gc operations and help seperate
+ * short-lived metadata from longer-lived file data.  In the future,
+ * file data should get seperated into several segments based on simple
+ * heuristics.  Old data recycled during gc operation is expected to be
+ * long-lived.  New data is of uncertain life expectancy.  New data
+ * used to replace older blocks in existing files is expected to be
+ * short-lived.
+ */
+
+
+struct btree_head {
+	struct btree_node *node;
+	int height;
+	void *null_ptr;
+};
+
+
+/* Magic numbers.  64bit for superblock, 32bit for statfs f_type */
+#define LOGFS_MAGIC		0xb21f205ac97e8168ull
+#define LOGFS_MAGIC_U32		0xc97e8168u
+
+/*
+ * Various blocksize related macros.  Blocksize is currently fixed at 4KiB.
+ * Sooner or later that should become configurable and the macros replaced
+ * by something superblock-dependent.  Pointers in indirect blocks are and
+ * will remain 64bit.
+ *
+ * LOGFS_BLOCKSIZE	- self-explaining
+ * LOGFS_BLOCK_FACTOR	- number of pointers per indirect block
+ * LOGFS_BLOCK_BITS	- log2 of LOGFS_BLOCK_FACTOR, used for shifts
+ */
+#define LOGFS_BLOCKSIZE		(4096ull)
+#define LOGFS_BLOCK_FACTOR	(LOGFS_BLOCKSIZE / sizeof(u64))
+#define LOGFS_BLOCK_BITS	(9)	/* 512 pointers, used for shifts */
+
+/*
+ * Number of blocks at various levels of indirection.  Each inode originally
+ * had 9 block pointers.  Later the inode size was doubled and there are now
+ * 9+16 pointers - the notation is just historical.
+ *
+ * I0_BLOCKS is the number of direct block pointer in each inode.  The
+ * remaining five pointers are for indirect pointers, up to 5x indirect.
+ * Only 3x is tested and supported at the moment.  5x would allow for truly
+ * humongous files if the need ever arises.
+ * I1_BLOCKS is the number of blocks behind a 1x indirect block,
+ * I2_BLOCKS is the number of blocks behind a 2x indirect block, not counting
+ * the 1x indirect blocks.  etc.
+ */
+#define I0_BLOCKS		(4+16)
+#define I1_BLOCKS		LOGFS_BLOCK_FACTOR
+#define I2_BLOCKS		(LOGFS_BLOCK_FACTOR * I1_BLOCKS)
+#define I3_BLOCKS		(LOGFS_BLOCK_FACTOR * I2_BLOCKS)
+#define I4_BLOCKS		(LOGFS_BLOCK_FACTOR * I3_BLOCKS)
+#define I5_BLOCKS		(LOGFS_BLOCK_FACTOR * I4_BLOCKS)
+
+/* The indices in the block array where the Nx indirect block pointers reside */
+#define I1_INDEX		(4+16)
+#define I2_INDEX		(5+16)
+#define I3_INDEX		(6+16)
+#define I4_INDEX		(7+16)
+#define I5_INDEX		(8+16)
+
+/* The total number of block pointers in each inode */
+#define LOGFS_EMBEDDED_FIELDS	(9+16)
+
+/*
+ * Sizes at which files require another level of indirection.  Files smaller
+ * than LOGFS_EMBEDDED_SIZE can be completely stored in the inode itself,
+ * similar like ext2 fast symlinks.
+ *
+ * Data at a position smaller than LOGFS_I0_SIZE is accessed through the
+ * direct pointers, else through the 1x indirect pointer and so forth.
+ */
+#define LOGFS_EMBEDDED_SIZE	(LOGFS_EMBEDDED_FIELDS * sizeof(u64))
+#define LOGFS_I0_SIZE		(I0_BLOCKS * LOGFS_BLOCKSIZE)
+#define LOGFS_I1_SIZE		(I1_BLOCKS * LOGFS_BLOCKSIZE)
+#define LOGFS_I2_SIZE		(I2_BLOCKS * LOGFS_BLOCKSIZE)
+#define LOGFS_I3_SIZE		(I3_BLOCKS * LOGFS_BLOCKSIZE)
+#define LOGFS_I4_SIZE		(I4_BLOCKS * LOGFS_BLOCKSIZE)
+#define LOGFS_I5_SIZE		(I5_BLOCKS * LOGFS_BLOCKSIZE)
+
+/*
+ * LogFS needs to seperate data into levels.  Each level is defined as the
+ * maximal possible distance from the master inode (inode of the inode file).
+ * Data blocks reside on level 0, 1x indirect block on level 1, etc.
+ * Inodes reside on level 6, indirect blocks for the inode file on levels 7-11.
+ * This effort is necessary to guarantee garbage collection to always make
+ * progress.
+ *
+ * LOGFS_MAX_INDIRECT is the maximal indirection through indirect blocks,
+ * LOGFS_MAX_LEVELS is one more for the actual data level of a file.  It is
+ * the maximal number of levels for one file.
+ * LOGFS_NO_AREAS is twice that, as the inode file and regular files are
+ * effectively stacked on top of each other.
+ */
+#define LOGFS_MAX_INDIRECT	(5)
+#define LOGFS_MAX_LEVELS	(LOGFS_MAX_INDIRECT + 1)
+#define LOGFS_NO_AREAS		(2 * LOGFS_MAX_LEVELS)
+
+/* Maximum size of filenames */
+#define LOGFS_MAX_NAMELEN	(255)
+
+/* Number of segments in the primary journal. */
+#define LOGFS_JOURNAL_SEGS	(4)
+
+
+/*
+ * LOGFS_HEADERSIZE is the size of a single header in the object store,
+ * LOGFS_MAX_OBJECTSIZE the size of the largest possible object, including
+ * its header,
+ * LOGFS_SEGMENT_RESERVE is the amount of space reserved for each segment for
+ * its segment header and the padded space at the end when no further objects
+ * fit.
+ */
+#define LOGFS_HEADERSIZE	(0x18)
+#define LOGFS_MAX_OBJECTSIZE	(LOGFS_HEADERSIZE + LOGFS_BLOCKSIZE)
+#define LOGFS_SEGMENT_RESERVE	(LOGFS_HEADERSIZE + LOGFS_MAX_OBJECTSIZE - 1)
+
+
+/* FIXME: why do these not work? */
+#if 0
+BUILD_BUG_ON(sizeof(struct logfs_object_header) != LOGFS_HEADERSIZE);
+BUILD_BUG_ON(sizeof(struct logfs_segment_header) != LOGFS_HEADERSIZE);
+#endif
+
+
+/**
+ * struct logfs_disk_super - on-medium superblock
+ *
+ * @ds_magic:			magic number, must equal LOGFS_MAGIC
+ * @ds_crc:			crc32 of structure starting with the next field
+ * @ds_ifile_levels:		maximum number of levels for ifile
+ * @ds_iblock_levels:		maximum number of levels for regular files
+ * @ds_data_levels:		number of seperate levels for data
+ * @pad0:			reserved, must be 0
+ * @ds_feature_incompat:	incompatible filesystem features
+ * @ds_feature_ro_compat:	read-only compatible filesystem features
+ * @ds_feature_compat:		compatible filesystem features
+ * @ds_flags:			flags
+ * @ds_segment_shift:		log2 of segment size
+ * @ds_block_shift:		log2 of block size
+ * @ds_write_shift:		log2 of write size
+ * @pad1:			reserved, must be 0
+ * @ds_journal_seg:		segments used by primary journal
+ * @ds_root_reserve:		bytes reserved for the superuser
+ * @pad2:			reserved, must be 0
+ *
+ * Contains only read-only fields.  Read-write fields like the amount of used
+ * space is tracked in the dynamic superblock, which is stored in the journal.
+ */
+struct logfs_disk_super {
+	__be64	ds_magic;
+	__be32	ds_crc;
+	u8	ds_ifile_levels;
+	u8	ds_iblock_levels;
+	u8	ds_data_levels;
+	u8	pad0;
+
+	__be64	ds_feature_incompat;
+	__be64	ds_feature_ro_compat;
+
+	__be64	ds_feature_compat;
+	__be64	ds_flags;
+
+	__be64	ds_filesystem_size;
+	u8	ds_segment_shift;
+	u8	ds_block_shift;
+	u8	ds_write_shift;
+	u8	pad1[5];
+
+	__be64	ds_journal_seg[LOGFS_JOURNAL_SEGS];
+
+	__be64	ds_root_reserve;
+
+	__be64	pad2[19];
+}__packed;
+
+
+/*
+ * Inode flags.  High bits should never be written to the medium.  Used either
+ * to catch obviously corrupt data (all 0xff) or for flags that are used
+ * in-memory only.
+ *
+ * LOGFS_IF_VALID	Inode is valid, must be 1 (catch all 0x00 case)
+ * LOGFS_IF_EMBEDDED	Inode is a fast inode (data embedded in pointers)
+ * LOGFS_IF_ZOMBIE	Inode has been deleted
+ * LOGFS_IF_STILLBORN	-ENOSPC happened when creating inode
+ * LOGFS_IF_INVALID	Inode is invalid, must be 0 (catch all 0xff case)
+ */
+#define LOGFS_IF_VALID		0x00000001
+#define LOGFS_IF_EMBEDDED	0x00000002
+#define LOGFS_IF_ZOMBIE		0x20000000
+#define LOGFS_IF_STILLBORN	0x40000000
+#define LOGFS_IF_INVALID	0x80000000
+
+
+/**
+ * struct logfs_disk_inode - on-medium inode
+ *
+ * @di_mode:			file mode
+ * @di_pad:			reserved, must be 0
+ * @di_flags:			inode flags, see above
+ * @di_uid:			user id
+ * @di_gid:			group id
+ * @di_ctime:			change time
+ * @di_mtime:			modify time
+ * @di_refcount:		reference count (aka nlink or link count)
+ * @di_generation:		inode generation, for nfs
+ * @di_used_bytes:		number of bytes used
+ * @di_size:			file size
+ * @di_data:			data pointers
+ */
+struct logfs_disk_inode {
+	__be16	di_mode;
+	__be16	di_pad;
+	__be32	di_flags;
+	__be32	di_uid;
+	__be32	di_gid;
+
+	__be64	di_ctime;
+	__be64	di_mtime;
+
+	__be32	di_refcount;
+	__be32	di_generation;
+	__be64	di_used_bytes;
+
+	__be64	di_size;
+	__be64	di_data[LOGFS_EMBEDDED_FIELDS];
+}__packed;
+
+
+/**
+ * struct logfs_disk_dentry - on-medium dentry structure
+ *
+ * @ino:			inode number
+ * @namelen:			length of file name
+ * @type:			file type, identical to bits 12..15 of mode
+ * @name:			file name
+ */
+struct logfs_disk_dentry {
+	__be64	ino;
+	__be16	namelen;
+	u8	type;
+	u8	name[LOGFS_MAX_NAMELEN];
+}__packed;
+
+
+#define OBJ_TOP_JOURNAL	1	/* segment header for master journal */
+#define OBJ_JOURNAL	2	/* segment header for journal */
+#define OBJ_OSTORE	3	/* segment header for ostore */
+#define OBJ_BLOCK	4	/* data block */
+#define OBJ_INODE	5	/* inode */
+#define OBJ_DENTRY	6	/* dentry */
+
+
+/**
+ * struct logfs_object_header - per-object header in the ostore
+ *
+ * @crc:			crc32 of header and data
+ * @len:			length of data
+ * @type:			object type, see above
+ * @compr:			compression type
+ * @ino:			inode number the object belongs to
+ * @pos:			file position the object belongs to
+ */
+struct logfs_object_header {
+	__be32	crc;
+	__be16	len;
+	u8	type;
+	u8	compr;
+	__be64	ino;
+	__be64	pos;
+}__packed;
+
+
+/**
+ * struct logfs_segment_header - per-segment header in the ostore
+ *
+ * @crc:			crc32 of header (there is no data)
+ * @len:			length of data, must be 0
+ * @type:			object type, see above
+ * @level:			GC level for all objects in this segment
+ * @segno:			segment number
+ * @ec:				erase count for this segment
+ * @gec:			global erase count at time of writing
+ */
+struct logfs_segment_header {
+	__be32	crc;
+	__be16	len;
+	u8	type;
+	u8	level;
+	__be32	segno;
+	__be32	ec;
+	__be64	gec;
+}__packed;
+
+
+/**
+ * struct logfs_journal_header - header for journal entries (JEs)
+ *
+ * @h_crc:			crc32 of journal entry
+ * @h_len:			length of compressed journal entry
+ * @h_datalen:			length of uncompressed data
+ * @h_type:			JE type
+ * @h_version:			unnormalized version of journal entry
+ * @h_compr:			compression type
+ * @h_pad:			reserved
+ */
+struct logfs_journal_header {
+	__be32	h_crc;
+	__be16	h_len;
+	__be16	h_datalen;
+	__be16	h_type;
+	__be16	h_version;
+	u8	h_compr;
+	u8	h_pad[3];
+}__packed;
+
+
+/**
+ * struct logfs_je_dynsb - dynamic superblock
+ *
+ * @ds_gec:			global erase count
+ * @ds_sweeper:			current position of GC "sweeper"
+ * @ds_rename_dir:		source directory ino (see dir.c documentation)
+ * @ds_rename_pos:		position of source dd (see dir.c documentation)
+ * @ds_victim_ino:		victims of incomplete dir operation (see dir.c)
+ * @ds_used_bytes:		number of used bytes
+ */
+struct logfs_je_dynsb {
+	__be64	ds_gec;
+	__be64	ds_sweeper;
+
+	__be64	ds_rename_dir;
+	__be64	ds_rename_pos;
+
+	__be64	ds_victim_ino;
+	__be64	ds_used_bytes;
+};
+
+
+/**
+ * struct logfs_je_anchor - anchor of filesystem tree, aka master inode
+ *
+ * @da_size:			size of inode file
+ * @da_last_ino:		last created inode
+ * @da_used_bytes:		number of bytes used
+ * @da_data:			data pointers
+ */
+struct logfs_je_anchor {
+	__be64	da_size;
+	__be64	da_last_ino;
+
+	__be64	da_used_bytes;
+	__be64	da_data[LOGFS_EMBEDDED_FIELDS];
+}__packed;
+
+
+/**
+ * struct logfs_je_spillout - spillout entry (from 1st to 2nd journal)
+ *
+ * @so_segment:			segments used for 2nd journal
+ *
+ * Length of the array is given by h_len field in the header.
+ */
+struct logfs_je_spillout {
+	__be64	so_segment[0];
+}__packed;
+
+
+/**
+ * struct logfs_je_journal_ec - erase counts for all journal segments
+ *
+ * @ec:				erase count
+ *
+ * Length of the array is given by h_len field in the header.
+ */
+struct logfs_je_journal_ec {
+	__be32	ec[0];
+}__packed;
+
+
+/**
+ * struct logfs_je_areas - management information for current areas
+ *
+ * @used_bytes:			number of bytes already used
+ * @segno:			segment number of area
+ *
+ * "Areas" are segments currently being used for writing.  There is one area
+ * per GC level.  Each erea also has a write buffer that is stored in the
+ * journal, in entries 0x10..0x1f.
+ */
+struct logfs_je_areas {
+	__be32	used_bytes[16];
+	__be32	segno[16];
+};
+
+
+enum {
+	COMPR_NONE	= 0,
+	COMPR_ZLIB	= 1,
+};
+
+
+/* Journal entries come in groups of 16.  First group contains individual
+ * entries, next groups contain one entry per level */
+enum {
+	JEG_BASE	= 0,
+	JE_FIRST	= 1,
+
+	JE_COMMIT	= 1,	/* commits all previous entries */
+	JE_ABORT	= 2,	/* aborts all previous entries */
+	JE_DYNSB	= 3,
+	JE_ANCHOR	= 4,
+	JE_ERASECOUNT	= 5,
+	JE_SPILLOUT	= 6,
+	JE_DELTA	= 7,
+	JE_BADSEGMENTS	= 8,
+	JE_AREAS	= 9,	/* area description sans wbuf */
+	JEG_WBUF	= 0x10,	/* write buffer for segments */
+
+	JE_LAST		= 0x1f,
+};
+
+
+			/*	0	reserved for gc markers */
+#define LOGFS_INO_MASTER	1	/* inode file */
+#define LOGFS_INO_ROOT		2	/* root directory */
+#define LOGFS_INO_ATIME		4	/* atime for all inodes */
+#define LOGFS_INO_BAD_BLOCKS	5	/* bad blocks */
+#define LOGFS_INO_OBSOLETE	6	/* obsolete block count */
+#define LOGFS_INO_ERASE_COUNT	7	/* erase count */
+#define LOGFS_RESERVED_INOS	16
+
+#endif

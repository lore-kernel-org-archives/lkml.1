Return-Path: <linux-kernel-owner+w=401wt.eu-S966845AbXEGWOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966845AbXEGWOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966778AbXEGWOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:14:33 -0400
Received: from lazybastard.de ([212.112.238.170]:58694 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966589AbXEGWO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:14:28 -0400
Date: Tue, 8 May 2007 00:10:15 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] LogFS proper
Message-ID: <20070507221011.GD15054@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org> <20070507220036.GB15054@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070507220036.GB15054@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 00:00:36 +0200, Jörn Engel wrote:
> 
> Signed-off-by: Jörn Engel <joern@wohnheim.fh-wedel.de>
> ---
> 
>  fs/Kconfig            |   15 
>  fs/Makefile           |    1 
>  fs/logfs/Locking      |   45 ++
>  fs/logfs/Makefile     |   14 
>  fs/logfs/NAMES        |   32 +
>  fs/logfs/compr.c      |  198 ++++++++
>  fs/logfs/dir.c        |  705 +++++++++++++++++++++++++++++++
>  fs/logfs/file.c       |   82 +++
>  fs/logfs/gc.c         |  350 +++++++++++++++
>  fs/logfs/inode.c      |  468 ++++++++++++++++++++
>  fs/logfs/journal.c    |  696 ++++++++++++++++++++++++++++++
>  fs/logfs/logfs.h      |  626 +++++++++++++++++++++++++++
>  fs/logfs/memtree.c    |  199 ++++++++
>  fs/logfs/progs/fsck.c |  323 ++++++++++++++
>  fs/logfs/progs/mkfs.c |  319 ++++++++++++++
>  fs/logfs/readwrite.c  | 1125 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/logfs/segment.c    |  533 +++++++++++++++++++++++
>  fs/logfs/super.c      |  490 +++++++++++++++++++++
>  19 files changed, 6237 insertions(+)

Looks like the mail size limit caught the patch.  For review, here's the
first half...

--- linux-2.6.21logfs/fs/Kconfig~logfs	2007-05-07 13:23:51.000000000 +0200
+++ linux-2.6.21logfs/fs/Kconfig	2007-05-07 13:32:12.000000000 +0200
@@ -1351,6 +1351,21 @@ config JFFS2_CMODE_SIZE
 
 endchoice
 
+config LOGFS
+	tristate "Log Filesystem (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	select ZLIB_INFLATE
+	select ZLIB_DEFLATE
+	help
+	  Successor of JFFS2, using explicit filesystem hierarchy.
+	  Continuing with the long tradition of calling the filesystem
+	  exactly what it is not, LogFS is a journaled filesystem,
+	  while JFFS and JFFS2 were true log-structured filesystems.
+	  The hybrid structure of journaled filesystems promise to
+	  scale better to larger sized.
+
+	  If unsure, say N.
+
 config CRAMFS
 	tristate "Compressed ROM file system support (cramfs)"
 	depends on BLOCK
--- linux-2.6.21logfs/fs/Makefile~logfs	2007-05-07 10:28:48.000000000 +0200
+++ linux-2.6.21logfs/fs/Makefile	2007-05-07 13:32:12.000000000 +0200
@@ -95,6 +95,7 @@ obj-$(CONFIG_NTFS_FS)		+= ntfs/
 obj-$(CONFIG_UFS_FS)		+= ufs/
 obj-$(CONFIG_EFS_FS)		+= efs/
 obj-$(CONFIG_JFFS2_FS)		+= jffs2/
+obj-$(CONFIG_LOGFS)		+= logfs/
 obj-$(CONFIG_AFFS_FS)		+= affs/
 obj-$(CONFIG_ROMFS_FS)		+= romfs/
 obj-$(CONFIG_QNX4FS_FS)		+= qnx4/
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/NAMES	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,32 @@
+This filesystem started with the codename "Logfs", which was actually
+a joke at the time.  Logfs was to replace JFFS2, the journaling flash
+filesystem (version 2).  JFFS2 was actually a log structured
+filesystem in its purest form, so the name described just what it was
+not.  Logfs was planned as a journaling filesystem, so its name would
+be in the same tradition of non-description.
+
+Apart from the joke, "Logfs" was only intended as a codename, later to
+be replaced by something better.  Some ideas from various people were:
+logfs
+jffs3
+jefs
+engelfs
+poofs
+crapfs
+sweetfs
+cutefs
+dynamic journaling fs - djofs
+tfsfkal - the file system formerly known as logfs
+
+Later it turned out that while having a journal, Logfs has borrowed so
+many concepts from log structured filesystems that the name actually
+made some sense.
+
+Yet later, Arnd noticed that Logfs was to scale logarithmically with
+increasing flash sizes, where JFFS2 scales linearly.  What a nice
+coincidence.  Even better, its successor can be called Log2fs,
+emphasizing this point.
+
+So to this day, I still like "Logfs" and cannot come up with a better
+name.  And unless someone has the stroke of a genius or there is
+massive opposition against this name, I'd like to just keep it.
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/Makefile	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,14 @@
+obj-$(CONFIG_LOGFS)	+= logfs.o
+
+logfs-y += compr.o
+logfs-y	+= dir.o
+logfs-y	+= file.o
+logfs-y	+= gc.o
+logfs-y	+= inode.o
+logfs-y	+= journal.o
+logfs-y += memtree.o
+logfs-y	+= readwrite.o
+logfs-y	+= segment.o
+logfs-y	+= super.o
+logfs-y += progs/fsck.o
+logfs-y += progs/mkfs.o
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/logfs.h	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,626 @@
+#ifndef logfs_h
+#define logfs_h
+
+#define __CHECK_ENDIAN__
+
+
+#include <linux/crc32.h>
+#include <linux/fs.h>
+#include <linux/kallsyms.h>
+#include <linux/kernel.h>
+#include <linux/mtd/mtd.h>
+#include <linux/pagemap.h>
+#include <linux/statfs.h>
+
+
+/**
+ * Throughout the logfs code, we're constantly dealing with blocks at
+ * various positions or offsets.  To remove confusion, we stricly
+ * distinguish between a "position" - the logical position within a
+ * file and an "offset" - the physical location within the device.
+ *
+ * Any usage of the term offset for a logical location or position for
+ * a physical one is a bug and should get fixed.
+ */
+
+/**
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
+typedef __be16 be16;
+typedef __be32 be32;
+typedef __be64 be64;
+
+struct btree_head {
+	struct btree_node *node;
+	int height;
+	void *null_ptr;
+};
+
+#define packed __attribute__((__packed__))
+
+
+#define TRACE() do {						\
+	printk("trace: %s:%d: ", __FILE__, __LINE__);		\
+	printk("->%s\n", __func__);				\
+} while(0)
+
+
+#define LOGFS_MAGIC 0xb21f205ac97e8168ull
+#define LOGFS_MAGIC_U32 0xc97e8168ull
+
+
+#define LOGFS_BLOCK_SECTORS	(8)
+#define LOGFS_BLOCK_BITS	(9)	/* 512 pointers, used for shifts */
+#define LOGFS_BLOCKSIZE		(4096ull)
+#define LOGFS_BLOCK_FACTOR (LOGFS_BLOCKSIZE / sizeof(u64))
+#define LOGFS_BLOCK_MASK (LOGFS_BLOCK_FACTOR-1)
+
+#define I0_BLOCKS	(4+16)
+#define I1_BLOCKS LOGFS_BLOCK_FACTOR
+#define I2_BLOCKS (LOGFS_BLOCK_FACTOR * I1_BLOCKS)
+#define I3_BLOCKS (LOGFS_BLOCK_FACTOR * I2_BLOCKS)
+#define I4_BLOCKS (LOGFS_BLOCK_FACTOR * I3_BLOCKS)
+#define I5_BLOCKS (LOGFS_BLOCK_FACTOR * I4_BLOCKS)
+
+#define I1_INDEX	(4+16)
+#define I2_INDEX	(5+16)
+#define I3_INDEX	(6+16)
+#define I4_INDEX	(7+16)
+#define I5_INDEX	(8+16)
+
+#define LOGFS_EMBEDDED_FIELDS	(9+16)
+
+#define LOGFS_EMBEDDED_SIZE	(LOGFS_EMBEDDED_FIELDS * sizeof(u64))
+#define LOGFS_I0_SIZE (I0_BLOCKS * LOGFS_BLOCKSIZE)
+#define LOGFS_I1_SIZE (I1_BLOCKS * LOGFS_BLOCKSIZE)
+#define LOGFS_I2_SIZE (I2_BLOCKS * LOGFS_BLOCKSIZE)
+#define LOGFS_I3_SIZE (I3_BLOCKS * LOGFS_BLOCKSIZE)
+#define LOGFS_I4_SIZE (I4_BLOCKS * LOGFS_BLOCKSIZE)
+#define LOGFS_I5_SIZE (I5_BLOCKS * LOGFS_BLOCKSIZE)
+
+#define LOGFS_MAX_INDIRECT	(5)
+#define LOGFS_MAX_LEVELS	(LOGFS_MAX_INDIRECT + 1)
+#define LOGFS_NO_AREAS		(2 * LOGFS_MAX_LEVELS)
+
+
+struct logfs_disk_super {
+	be64	ds_magic;
+	be32	ds_crc;			/* crc32 of everything below */
+	u8	ds_ifile_levels;	/* max level of ifile */
+	u8	ds_iblock_levels;	/* max level of regular files */
+	u8	ds_data_levels;		/* number of segments to leaf blocks */
+	u8	pad0;
+
+	be64	ds_feature_incompat;
+	be64	ds_feature_ro_compat;
+
+	be64	ds_feature_compat;
+	be64	ds_flags;
+
+	be64	ds_filesystem_size;	/* filesystem size in bytes */
+	u8	ds_segment_shift;	/* log2 of segment size */
+	u8	ds_block_shift;		/* log2 if block size */
+	u8	ds_write_shift;		/* log2 of write size */
+	u8	pad1[5];
+
+	/* the segments of the primary journal.  if fewer than 4 segments are
+	 * used, some fields are set to 0 */
+#define LOGFS_JOURNAL_SEGS 4
+	be64	ds_journal_seg[LOGFS_JOURNAL_SEGS];
+
+	be64	ds_root_reserve;	/* bytes reserved for root */
+
+	be64	pad2[19];		/* align to 256 bytes */
+}packed;
+
+
+#define LOGFS_IF_VALID		0x00000001 /* inode exists */
+#define LOGFS_IF_EMBEDDED	0x00000002 /* data embedded in block pointers */
+#define LOGFS_IF_ZOMBIE		0x00000004 /* inode was already deleted */
+#define LOGFS_IF_STILLBORN	0x40000000 /* couldn't write inode in creat() */
+#define LOGFS_IF_INVALID	0x80000000 /* inode does not exist */
+struct logfs_disk_inode {
+	be16	di_mode;
+	be16	di_pad;
+	be32	di_flags;
+	be32	di_uid;
+	be32	di_gid;
+
+	be64	di_ctime;
+	be64	di_mtime;
+
+	be32	di_refcount;
+	be32	di_generation;
+	be64	di_used_bytes;
+
+	be64	di_size;
+	be64	di_data[LOGFS_EMBEDDED_FIELDS];
+}packed;
+
+
+#define LOGFS_MAX_NAMELEN 255
+struct logfs_disk_dentry {
+	be64	ino;		/* inode pointer */
+	be16	namelen;
+	u8	type;
+	u8	name[LOGFS_MAX_NAMELEN];
+}packed;
+
+
+#define OBJ_TOP_JOURNAL	1	/* segment header for master journal */
+#define OBJ_JOURNAL	2	/* segment header for journal */
+#define OBJ_OSTORE	3	/* segment header for ostore */
+#define OBJ_BLOCK	4	/* data block */
+#define OBJ_INODE	5	/* inode */
+#define OBJ_DENTRY	6	/* dentry */
+struct logfs_object_header {
+	be32	crc;		/* checksum */
+	be16	len;		/* length of object, header not included */
+	u8	type;		/* node type */
+	u8	compr;		/* compression type */
+	be64	ino;		/* inode number */
+	be64	pos;		/* file position */
+}packed;
+
+
+struct logfs_segment_header {
+	be32	crc;		/* checksum */
+	be16	len;		/* length of object, header not included */
+	u8	type;		/* node type */
+	u8	level;		/* GC level */
+	be32	segno;		/* segment number */
+	be32	ec;		/* erase count */
+	be64	gec;		/* global erase count (write time) */
+}packed;
+
+
+struct logfs_object_id {
+	be64	ino;
+	be64	pos;
+}packed;
+
+
+struct logfs_disk_sum {
+	/* footer */
+	be32	erase_count;
+	u8	level;
+	u8	pad[3];
+	union {
+		be64	segno;
+		be64	gec;
+	};
+	struct logfs_object_id oids[0];
+}packed;
+
+
+struct logfs_journal_header {
+	be32	h_crc;		/* crc32 of everything */
+	be16	h_len;		/* length of compressed journal entry */
+	be16	h_datalen;	/* length of uncompressed data */
+	be16	h_type;		/* anchor, spillout or delta */
+	be16	h_version;	/* a counter, effectively */
+	u8	h_compr;	/* compression type */
+	u8	h_pad[3];
+}packed;
+
+
+struct logfs_dynsb {
+	be64	ds_gec;		/* global erase count */
+	be64	ds_sweeper;	/* current position of gc "sweeper" */
+
+	be64	ds_rename_dir;	/* source directory ino */
+	be64	ds_rename_pos;	/* position of source dd */
+
+	be64	ds_victim_ino;	/* victims of incomplete dir operation, */
+	be64	ds_used_bytes;	/* number of used bytes */
+};
+
+
+struct logfs_anchor {
+	be64	da_size;	/* size of inode file */
+	be64	da_last_ino;
+
+	be64	da_used_bytes;	/* blocks used for inode file */
+	be64	da_data[LOGFS_EMBEDDED_FIELDS];
+}packed;
+
+
+struct logfs_spillout {
+	be64	so_segment[0];	/* length given by h_len field */
+}packed;
+
+
+struct logfs_delta {
+	be64	d_ofs;		/* offset of changed block */
+	u8	d_data[0];	/* XOR between on-medium and actual block,
+				   zlib compressed */
+}packed;
+
+
+struct logfs_journal_ec {
+	be32	ec[0];		/* length given by h_len field */
+}packed;
+
+
+struct logfs_journal_sum {
+	struct logfs_disk_sum sum[0]; /* length given by h_len field */
+}packed;
+
+
+struct logfs_je_areas {
+	be32 used_bytes[16];
+	be32 segno[16];
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
+////////////////////////////////////////////////////////////////////////////////
+////////////////////////////////////////////////////////////////////////////////
+
+
+#define LOGFS_SUPER(sb) ((struct logfs_super*)(sb->s_fs_info))
+#define LOGFS_INODE(inode) container_of(inode, struct logfs_inode, vfs_inode)
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
+
+struct logfs_object {
+	u64	ino;	/* inode number */
+	u64	pos;	/* position in file */
+};
+
+
+struct logfs_area { /* a segment open for writing */
+	struct super_block *a_sb;
+	int	a_is_open;
+	u32	a_segno;		/* segment number */
+	u32	a_used_objects;		/* number of objects already used */
+	u32	a_used_bytes;		/* number of bytes already used */
+	struct logfs_area_ops *a_ops;
+	/* on-medium information */
+	void			*a_wbuf;
+	u32	a_erase_count;
+	u8	a_level;
+};
+
+
+struct logfs_area_ops {
+	/* fill area->ofs with the offset of a free segment */
+	void	(*get_free_segment)(struct logfs_area *area);
+	/* fill area->erase_count (needs area->ofs) */
+	void	(*get_erase_count)(struct logfs_area *area);
+	/* clear area->blocks */
+	void	(*clear_blocks)(struct logfs_area *area);
+	/* erase and setup segment */
+	int	(*erase_segment)(struct logfs_area *area);
+	/* write summary on tree segments */
+	void	(*finish_area)(struct logfs_area *area);
+};
+
+
+struct logfs_segment {
+	struct list_head list;
+	u32	erase_count;
+	u32	valid;
+	u64	write_time;
+	u32	segno;
+};
+
+
+struct logfs_journal_entry {
+	int used;
+	s16 version;
+	u16 len;
+	u64 offset;
+};
+
+
+struct logfs_super {
+	//struct super_block *s_sb;		/* should get removed... */
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
+	be32	*s_bb_array;			/* bad segments */
+	/* readwrite.c fields */
+	struct mutex s_r_mutex;
+	struct mutex s_w_mutex;
+	be64	*s_rblock;
+	be64	*s_wblock[LOGFS_MAX_LEVELS];
+	u64	 s_free_bytes;			/* number of free bytes */
+	u64	 s_used_bytes;			/* number of bytes used */
+	u64	 s_gc_reserve;
+	u64	 s_root_reserve;
+	u32	 s_bad_segments;		/* number of bad segments */
+};
+
+
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
+void logfs_crash_dump(struct super_block *sb);
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
+static inline be32 logfs_crc32(void *data, size_t len, size_t skip)
+{
+	/* The first four bytes hold the crc, so skip those */
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
+static inline struct logfs_disk_sum *alloc_disk_sum(struct super_block *sb)
+{
+	return kzalloc(sb->s_blocksize, GFP_ATOMIC);
+}
+static inline void free_disk_sum(struct logfs_disk_sum *sum)
+{
+	kfree(sum);
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
+/* compr.c */
+#define logfs_compress_none logfs_memcpy
+#define logfs_uncompress_none logfs_memcpy
+int logfs_memcpy(void *in, void *out, size_t inlen, size_t outlen);
+int logfs_compress(void *in, void *out, size_t inlen, size_t outlen);
+int logfs_compress_vec(struct kvec *vec, int count, void *out, size_t outlen);
+int logfs_uncompress(void *in, void *out, size_t inlen, size_t outlen);
+int logfs_uncompress_vec(void *in, size_t inlen, struct kvec *vec, int count);
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
+void *logfs_device_getpage(struct super_block *sb, u64 offset,
+		struct page **page);
+void logfs_device_putpage(void *buf, struct page *page);
+int logfs_cached_read(struct super_block *sb, u64 ofs, size_t len, void *buf);
+int all_ff(void *buf, size_t len);
+int logfs_statfs(struct dentry *dentry, struct kstatfs *stats);
+
+
+/* progs/mkfs.c */
+int logfs_mkfs(struct super_block *sb, struct logfs_disk_super *ds);
+
+
+/* progs/mkfs.c */
+int logfs_fsck(struct super_block *sb);
+
+
+static inline u64 dev_ofs(struct super_block *sb, u32 segno, u32 ofs)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	return ((u64)segno << super->s_segshift) + ofs;
+}
+
+
+static inline void device_read(struct super_block *sb, u32 segno, u32 ofs,
+		size_t len, void *buf)
+{
+	int err = mtdread(sb, dev_ofs(sb, segno, ofs), len, buf);
+	LOGFS_BUG_ON(err, sb);
+}
+
+
+#define EOF	256
+
+
+#endif
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/dir.c	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,705 @@
+/**
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
+#include "logfs.h"
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
+typedef int (*dir_callback)(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, loff_t pos);
+
+
+static s64 dir_seek_data(struct inode *inode, s64 pos)
+{
+	s64 new_pos = logfs_seek_data(inode, pos);
+	return max((s64)pos, new_pos - 1);
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
+		if (ret == -ENODATA) {/* deleted dentry */
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
+	struct dentry *ret;
+
+	ret = ERR_PTR(logfs_dir_walk(dir, dentry, logfs_lookup_handler));
+	return ret;
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
+	/* remove dentry */
+	if (inode->i_mode & S_IFDIR)
+		dir->i_nlink--;
+	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	ret = logfs_dir_walk(dir, dentry, logfs_unlink_handler);
+	super->s_victim_ino = 0;
+	if (ret)
+		goto out;
+
+	/* remove inode */
+	ret = logfs_remove_inode(inode);
+
+out:
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
+	loff_t pos = file->f_pos - IMPLICIT_NODES;
+	int err;
+
+	BUG_ON(pos<0);
+	for (;; pos++) {
+		struct inode *dir = file->f_dentry->d_inode;
+		err = read_dir(dir, &dd, pos);
+		if (err == -EOF)
+			break;
+		if (err == -ENODATA) {/* deleted dentry */
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
+		ino_t pino = parent_ino(file->f_dentry);
+		if (filldir(buf, "..", 2, 2, pino, DT_DIR) < 0)
+			return 0;
+		file->f_pos++;
+	}
+
+	err = __logfs_readdir(file, buf, filldir);
+	if (err)
+		printk("LOGFS readdir error=%x, pos=%llx\n", err, file->f_pos);
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
+	/* FIXME: the file size should actually get aligned when writing,
+	 * not when reading. */
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
+	if (dest) /* symlink */
+		ret = logfs_inode_write(inode, dest, destlen, 0);
+	else /* creat/mkdir/mknod */
+		ret = __logfs_write_inode(inode);
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
+/* FIXME: This should really be somewhere in the 64bit area. */
+#define LOGFS_LINK_MAX (1<<30)
+static int logfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	struct inode *inode;
+
+	if (dir->i_nlink >= LOGFS_LINK_MAX)
+		return -EMLINK;
+
+	/* FIXME: why do we have to fill in S_IFDIR, while the mode is
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
+static struct inode_operations ext2_symlink_iops = {
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
+	inode->i_op = &ext2_symlink_iops;
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
+	if (err == -EOF) /* don't expose internal errnos */
+		err = -EIO;
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
+/* Cross-directory rename, target does not exist.  Just a little nasty.
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
+	/* FIXME: this cannot be right but it does "fix" a bug of i_count
+	 * dropping too low.  Needs more thought. */
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
+	if (new_dentry->d_inode) /* target exists */
+		return logfs_rename_target(old_dir, old_dentry, new_dir, new_dentry);
+	else if (old_dir == new_dir) /* local rename */
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
+	if (super->s_victim_ino) { /* delete victim inode */
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
+	if (super->s_rename_dir) { /* delete old dd from rename */
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
+++ linux-2.6.21logfs/fs/logfs/file.c	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,82 @@
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
+	pr_debug("ino: %lu, page:%lu, start: %d, len:%d\n", inode->i_ino,
+			page->index, start, end-start);
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
+	int ret = logfs_readpage_nolock(page);
+	unlock_page(page);
+	return ret;
+}
+
+
+static int logfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	BUG();
+	return 0;
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
+	.writepage	= logfs_writepage,
+};
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/gc.c	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,350 @@
+#include "logfs.h"
+
+#if 0
+/**
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
+static u32 logfs_valid_bytes(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_object_header h;
+	u64 ofs, ino, pos;
+	u32 seg_ofs, valid, size;
+	void *reserved;
+	int i;
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
+	device_read(sb, segno, 0, sizeof(h), &h);
+	if (all_ff(&h, sizeof(h)))
+		return 0;
+
+	valid = 0; /* segment header not counted as valid bytes */
+	for (seg_ofs = sizeof(h); seg_ofs + sizeof(h) < super->s_segsize; ) {
+		device_read(sb, segno, seg_ofs, sizeof(h), &h);
+		if (all_ff(&h, sizeof(h)))
+			break;
+
+		ofs = dev_ofs(sb, segno, seg_ofs);
+		ino = be64_to_cpu(h.ino);
+		pos = be64_to_cpu(h.pos);
+		size = (u32)be16_to_cpu(h.len) + sizeof(h);
+		//printk("%x %x (%llx, %llx, %llx)(%x, %x)\n", h.type, h.compr, ofs, ino, pos, valid, size);
+		if (logfs_is_valid_block(sb, ofs, ino, pos))
+			valid += size;
+		seg_ofs += size;
+	}
+	printk("valid(%x) = %x\n", segno, valid);
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
+	int level;
+
+	device_read(sb, segno, 0, sizeof(h), &h);
+	sh = (void*)&h;
+	level = sh->level;
+
+	for (seg_ofs = sizeof(h); seg_ofs + sizeof(h) < super->s_segsize; ) {
+		ofs = dev_ofs(sb, segno, seg_ofs);
+		device_read(sb, segno, seg_ofs, sizeof(h), &h);
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
+	struct logfs_segment *seg = kzalloc(sizeof(*seg), GFP_KERNEL);
+	if (!seg)
+		return;
+
+	seg->segno = segno;
+	seg->valid = valid;
+	list_add(&seg->list, list);
+	*count += 1;
+}
+
+
+static void add_segment(struct list_head *list, int *count, u32 segno,
+		int valid)
+{
+	struct logfs_segment *seg;
+	list_for_each_entry(seg, list, list)
+		if (seg->segno == segno)
+			return;
+	__add_segment(list, count, segno, valid);
+}
+
+
+static void del_segment(struct list_head *list, int *count, u32 segno)
+{
+	struct logfs_segment *seg;
+	list_for_each_entry(seg, list, list)
+		if (seg->segno == segno) {
+			list_del(&seg->list);
+			*count -= 1;
+			kfree(seg);
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
+static void add_low_segment(struct super_block *sb, u32 segno, int valid)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	add_segment(&super->s_low_list, &super->s_low_count, segno, valid);
+}
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
+	u32 full = super->s_segsize - sb->s_blocksize - 0x18; /* one header */
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
+static void free_all_segments(struct logfs_super *super)
+{
+	struct logfs_segment *seg, *next;
+
+	list_for_each_entry_safe(seg, next, &super->s_free_list, list) {
+		list_del(&seg->list);
+		kfree(seg);
+	}
+	list_for_each_entry_safe(seg, next, &super->s_low_list, list) {
+		list_del(&seg->list);
+		kfree(seg);
+	}
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
+			i=1;	/* skip superblock */
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
+	struct logfs_segment *seg, *next;
+	unsigned min_valid = super->s_segsize;
+	u32 segno;
+
+	BUG_ON(list_empty(&super->s_low_list));
+	list_for_each_entry_safe(seg, next, &super->s_low_list, list) {
+		if (seg->valid >= min_valid)
+			continue;
+		min_valid = seg->valid;
+		list_del(&seg->list);
+		list_add(&seg->list, &super->s_low_list);
+	}
+
+	seg = list_entry(super->s_low_list.next, struct logfs_segment, list);
+	list_del(&seg->list);
+	super->s_low_count -= 1;
+
+	segno = seg->segno;
+	logfs_gc_segment(sb, segno);
+	kfree(seg);
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
+		if (super->s_free_count < 3) {
+			logfs_scan_pass(sb);
+			printk("s");
+		}
+		logfs_gc_once(sb);
+#if 1
+		if (super->s_free_count >= super->s_total_levels)
+			return;
+		printk(".");
+#endif
+	}
+}
+
+
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
+		printk("free:%8d, low:%8d, sweeper:%8lld\n",
+				super->s_free_count, super->s_low_count,
+				super->s_sweeper);
+		logfs_gc_several(sb);
+		printk("free:%8d, low:%8d, sweeper:%8lld\n",
+				super->s_free_count, super->s_low_count,
+				super->s_sweeper);
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
+	free_all_segments(super);
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/inode.c	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,468 @@
+#include "logfs.h"
+#include <linux/backing-dev.h>
+#include <linux/writeback.h> /* for inode_lock */
+
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
+			inode->i_nlink = 0; /* don't cache the inode */
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
+struct inode *logfs_iget(struct super_block *sb, ino_t ino, int *cookie)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_inode *li;
+
+	if (ino == LOGFS_INO_MASTER) /* never iget this "inode"! */
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
+	if (inode->i_ino == LOGFS_INO_MASTER) /* never iput it either! */
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
+static struct timespec be64_to_timespec(be64 betime)
+{
+	u64 time = be64_to_cpu(betime);
+	struct timespec tsp;
+	tsp.tv_sec = time >> 32;
+	tsp.tv_nsec = time & 0xffffffff;
+	return tsp;
+}
+
+
+static be64 timespec_to_be64(struct timespec tsp)
+{
+	u64 time = ((u64)tsp.tv_sec << 32) + (tsp.tv_nsec & 0xffffffff);
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
+	if ( !(be32_to_cpu(di->di_flags) & LOGFS_IF_VALID))
+		return -EIO;
+
+	if (be32_to_cpu(di->di_flags) & LOGFS_IF_INVALID)
+		return -EIO;
+
+	return 0;
+}
+
+
+static int __logfs_read_inode(struct inode *inode)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
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
+	if ( !(li->li_flags&LOGFS_IF_VALID) || (li->li_flags&LOGFS_IF_INVALID))
+		return -EIO;
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
+	if (ret) {
+		printk("%lx, %x\n", inode->i_ino, -ret);
+		BUG();
+	}
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
+	struct logfs_disk_inode old, new; /* FIXME: move these off the stack */
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
+/**
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
+/**
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
+	/* FIXME: ino allocation should work in two modes:
+	 * o nonsparse - ifile is mostly occupied, just append
+	 * o sparse - ifile has lots of holes, fill them up
+	 */
+	spin_lock(&super->s_ino_lock);
+	ino = super->s_last_ino; /* ifile shouldn't be too sparse */
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
+++ linux-2.6.21logfs/fs/logfs/journal.c	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,696 @@
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
+	int i;
+
+	for (i=0; i<JE_LAST; i++) {
+		struct logfs_journal_entry *spec = super->s_speculative + i;
+		struct logfs_journal_entry *retired = super->s_retired + i;
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
+		if (!super->s_first.used) { /* remember first version */
+			super->s_first.used = 1;
+			super->s_first.version = version;
+		}
+		version -= super->s_first.version;
+
+		if (abs(version) > 1<<14) /* all versions should be near */
+			LOGFS_BUG(sb);
+
+		spec = &super->s_speculative[type];
+		retired = &super->s_retired[type];
+		switch (type) {
+		default: /* store speculative entry */
+			if (spec->used && (version <= spec->version))
+				break;
+			spec->used = 1;
+			spec->version = version;
+			spec->offset = block_ofs + ofs;
+			spec->len = len;
+			break;
+		case JE_COMMIT: /* retire speculative entries */
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
+			area->a_is_open = 0; /* never reuse same segment after
+						mount - wasteful but safe */
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
+	u64 no_blocks = super->s_no_blocks;
+	u64 blocksize = sb->s_blocksize;
+	u64 free;
+	int i, reserved_segs;
+
+	reserved_segs = 1; /* super_block */
+	reserved_segs += super->s_bad_segments;
+	journal_for_each(i)
+		if (super->s_journal_seg[i])
+			reserved_segs++;
+
+	free = no_segs * no_blocks * blocksize;		/* total size */
+	free -= reserved_segs * no_blocks * blocksize;	/* sb & journal */
+	free -= (no_segs - reserved_segs) * blocksize;	/* block summary */
+	free -= super->s_used_bytes;			/* stored data */
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
+static void logfs_read_dynsb(struct super_block *sb, struct logfs_dynsb *dynsb)
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
+static void logfs_read_anchor(struct super_block *sb, struct logfs_anchor *da)
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
+		struct logfs_journal_ec *ec)
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
+	be32 *seg, *bad = super->s_bb_array;
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
+		if (!super->s_retired[i].used)
+			switch (i) {
+			case JE_COMMIT:
+			case JE_DYNSB:
+			case JE_ANCHOR:
+				printk("LogFS: Missing journal entry %x?\n",
+						i);
+				return -EIO;
+			default:
+				continue;
+			}
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
+static void journal_get_free_segment(struct logfs_area *area)
+{
+	struct logfs_super *super = LOGFS_SUPER(area->a_sb);
+	int i;
+
+	journal_for_each(i) {
+		if (area->a_segno != super->s_journal_seg[i])
+			continue;
+empty_seg:
+		i++;
+		if (i == LOGFS_JOURNAL_SEGS)
+			i = 0;
+		if (!super->s_journal_seg[i])
+			goto empty_seg;
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
+static void journal_clear_blocks(struct logfs_area *area)
+{
+	/* nothing needed for journal segments */
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
+/**
+ * logfs_get_free_entry - return free space for journal entry
+ */
+static s64 logfs_get_free_entry(struct super_block *sb)
+{
+	s64 ret;
+
+	mutex_lock(&LOGFS_SUPER(sb)->s_log_mutex);
+	ret = __logfs_get_free_entry(sb);
+	mutex_unlock(&LOGFS_SUPER(sb)->s_log_mutex);
+	BUG_ON(ret <= 0); /* not sure, but it's safer to BUG than to accept */
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
+	return LOGFS_JOURNAL_SEGS * sizeof(be32);
+}
+static void *logfs_write_erasecount(struct super_block *sb, void *_ec,
+		u16 *type, size_t *len)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_journal_ec *ec = _ec;
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
+	struct logfs_anchor *da = _da;
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
+	struct logfs_dynsb *dynsb = _dynsb;
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
+	for (i=0; i<16; i++) { /* FIXME: have all 16 areas */
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
+	int i, ret;
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
+	ret = mtdwrite(sb, ofs, sb->s_blocksize, block);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+
+static struct logfs_area_ops journal_area_ops = {
+	.get_free_segment	= journal_get_free_segment,
+	.get_erase_count	= journal_get_erase_count,
+	.clear_blocks		= journal_clear_blocks,
+	.erase_segment		= joernal_erase_segment,
+	.finish_area		= journal_finish_area,
+};
+
+
+int logfs_init_journal(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int ret;
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
+	super->s_master_inode->i_nlink = 1; /* lock it in ram */
+
+	/* logfs_scan_journal() is looking for the latest journal entries, but
+	 * doesn't copy them into data structures yet.  logfs_read_journal()
+	 * then re-reads those entries and copies their contents over. */
+	ret = logfs_scan_journal(sb);
+	if (ret)
+		return ret;
+	ret = logfs_read_journal(sb);
+	if (ret)
+		return ret;
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
+	return -ENOMEM;
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

Jörn

-- 
Time? What's that? Time is only worth what you do with it.
-- Theo de Raadt

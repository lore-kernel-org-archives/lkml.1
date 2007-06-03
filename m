Return-Path: <linux-kernel-owner+w=401wt.eu-S1751284AbXFCSq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbXFCSq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXFCSqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:46:45 -0400
Received: from lazybastard.de ([212.112.238.170]:34648 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbXFCSqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:46:43 -0400
Date: Sun, 3 Jun 2007 20:42:05 +0200
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
Subject: [Patch 04/18] include/linux/logfs.h
Message-ID: <20070603184205.GE8952@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070603183845.GA8952@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-03-13 19:15:28.862769062 +0100
+++ linux-2.6.21logfs/include/linux/logfs.h	2007-06-03 19:18:57.000000000 +0200
@@ -0,0 +1,471 @@
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
+#define LOGFS_BLOCK_BITS	(9)
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
+	u8	di_height;
+	u8	di_pad;
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

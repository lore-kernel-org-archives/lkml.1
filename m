Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbXFCSwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbXFCSwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbXFCSvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:51:49 -0400
Received: from lazybastard.de ([212.112.238.170]:55823 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbXFCSvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:51:47 -0400
Date: Sun, 3 Jun 2007 20:47:08 +0200
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
Subject: [Patch 11/18] fs/logfs/journal.c
Message-ID: <20070603184708.GL8952@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070603183845.GA8952@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-03-13 19:15:28.862769062 +0100
+++ linux-2.6.21logfs/fs/logfs/journal.c	2007-06-03 19:18:57.000000000 +0200
@@ -0,0 +1,696 @@
+/*
+ * fs/logfs/journal.c	- journal handling code
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ */
+#include "logfs.h"
+
+static void clear_retired(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	int i;
+
+	for (i=0; i<JE_LAST; i++)
+		super->s_retired[i].used = 0;
+	super->s_first.used = 0;
+}
+
+static void clear_speculatives(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	int i;
+
+	for (i=0; i<JE_LAST; i++)
+		super->s_speculative[i].used = 0;
+}
+
+static void retire_speculatives(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+	struct logfs_super *super = logfs_super(sb);
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
+static int logfs_scan_journal(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+			err = super->s_devops->read(sb, ofs, sb->s_blocksize, block);
+			if (err)
+				return err;
+			__logfs_scan_journal(sb, block, segno, ofs, k);
+		}
+	}
+	return 0;
+}
+
+static void logfs_read_commit(struct logfs_super *super,
+		struct logfs_journal_header *h)
+{
+	super->s_last_version = be16_to_cpu(h->h_version);
+}
+
+static void logfs_calc_free(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+static void reserve_sb_and_journal(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+static void logfs_read_dynsb(struct super_block *sb,
+		struct logfs_je_dynsb *dynsb)
+{
+	struct logfs_super *super = logfs_super(sb);
+
+	super->s_gec		= be64_to_cpu(dynsb->ds_gec);
+	super->s_sweeper	= be64_to_cpu(dynsb->ds_sweeper);
+	super->s_victim_ino	= be64_to_cpu(dynsb->ds_victim_ino);
+	super->s_rename_dir	= be64_to_cpu(dynsb->ds_rename_dir);
+	super->s_rename_pos	= be64_to_cpu(dynsb->ds_rename_pos);
+	super->s_used_bytes	= be64_to_cpu(dynsb->ds_used_bytes);
+}
+
+static void logfs_read_anchor(struct super_block *sb,
+		struct logfs_je_anchor *da)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct inode *inode = super->s_master_inode;
+	struct logfs_inode *li = logfs_inode(inode);
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
+static void logfs_read_erasecount(struct super_block *sb,
+		struct logfs_je_journal_ec *ec)
+{
+	struct logfs_super *super = logfs_super(sb);
+	int i;
+
+	journal_for_each(i)
+		super->s_journal_ec[i] = be32_to_cpu(ec->ec[i]);
+}
+
+static void logfs_read_badsegments(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+static void logfs_read_areas(struct super_block *sb, struct logfs_je_areas *a)
+{
+	struct logfs_area *area;
+	int i;
+
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		area = logfs_super(sb)->s_area[i];
+		area->a_used_bytes = be32_to_cpu(a->used_bytes[i]);
+		area->a_segno = be32_to_cpu(a->segno[i]);
+		if (area->a_segno)
+			area->a_is_open = 1;
+	}
+}
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
+	struct logfs_super *super = logfs_super(sb);
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
+		err = super->s_devops->read(sb, je->offset, sb->s_blocksize, block);
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
+/*
+ * First search the current segment (outer loop), then pick the next segment
+ * in the array, skipping any zero entries (inner loop).
+ */
+static void journal_get_free_segment(struct logfs_area *area)
+{
+	struct logfs_super *super = logfs_super(area->a_sb);
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
+static void journal_get_erase_count(struct logfs_area *area)
+{
+	/* erase count is stored globally and incremented in
+	 * journal_get_free_segment() - nothing to do here */
+}
+
+static int journal_erase_segment(struct logfs_area *area)
+{
+	return logfs_erase_segment(area->a_sb, area->a_segno);
+}
+
+static void journal_finish_area(struct logfs_area *area)
+{
+	if (area->a_used_objects < logfs_super(area->a_sb)->s_no_blocks)
+		return;
+	area->a_is_open = 0;
+}
+
+static s64 __logfs_get_free_entry(struct super_block *sb)
+{
+	struct logfs_area *area = logfs_super(sb)->s_journal_area;
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
+	BUG_ON(ofs >= logfs_super(sb)->s_size);
+	return ofs;
+}
+
+/*
+ * logfs_get_free_entry - return free space for journal entry
+ */
+static s64 logfs_get_free_entry(struct super_block *sb)
+{
+	s64 ret;
+
+	mutex_lock(&logfs_super(sb)->s_log_mutex);
+	ret = __logfs_get_free_entry(sb);
+	mutex_unlock(&logfs_super(sb)->s_log_mutex);
+	BUG_ON(ret <= 0);
+	/* FIXME: the error handling needs better testing instead of a BUG() */
+	return ret;
+}
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
+static size_t logfs_write_header(struct logfs_super *super,
+		struct logfs_journal_header *h, size_t datalen, u16 type)
+{
+	size_t len = datalen + sizeof(*h);
+
+	return __logfs_write_header(super, h, len, datalen, type, COMPR_NONE);
+}
+
+static void *logfs_write_bb(struct super_block *sb, void *h,
+		u16 *type, size_t *len)
+{
+	*type = JE_BADSEGMENTS;
+	*len = sb->s_blocksize;
+	return logfs_super(sb)->s_bb_array;
+}
+
+static inline size_t logfs_journal_erasecount_size(struct logfs_super *super)
+{
+	return LOGFS_JOURNAL_SEGS * sizeof(__be32);
+}
+
+static void *logfs_write_erasecount(struct super_block *sb, void *_ec,
+		u16 *type, size_t *len)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+static void *logfs_write_wbuf(struct super_block *sb, void *h,
+		u16 *type, size_t *len)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_area *area = super->s_area[super->s_sum_index];
+
+	*type = JEG_WBUF + super->s_sum_index;
+	*len = super->s_writesize;
+	return area->a_wbuf;
+}
+
+static void *__logfs_write_anchor(struct super_block *sb, void *_da,
+		u16 *type, size_t *len)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_je_anchor *da = _da;
+	struct inode *inode = super->s_master_inode;
+	struct logfs_inode *li = logfs_inode(inode);
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
+static void *logfs_write_dynsb(struct super_block *sb, void *_dynsb,
+		u16 *type, size_t *len)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+		area = logfs_super(sb)->s_area[i];
+		a->used_bytes[i] = cpu_to_be32(area->a_used_bytes);
+		a->segno[i] = cpu_to_be32(area->a_segno);
+	}
+	*type = JE_AREAS;
+	*len = sizeof(*a);
+	return a;
+}
+
+static void *logfs_write_commit(struct super_block *sb, void *h,
+		u16 *type, size_t *len)
+{
+	*type = JE_COMMIT;
+	*len = 0;
+	return NULL;
+}
+
+static size_t logfs_write_je(struct super_block *sb, size_t jpos,
+		void* (*write)(struct super_block *sb, void *scratch,
+			u16 *type, size_t *len))
+{
+	struct logfs_super *super = logfs_super(sb);
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
+		BUG_ON(len > max);
+		memcpy(data, scratch, len);
+		compr_len = len;
+		compr = COMPR_NONE;
+	}
+
+	pad_len = ALIGN(compr_len, 16);
+	memset(data + compr_len, 0, pad_len - compr_len);
+	full_len = pad_len + sizeof(struct logfs_journal_header);
+
+	return __logfs_write_header(super, header, full_len, len, type, compr);
+}
+
+int logfs_write_anchor(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct logfs_super *super = logfs_super(sb);
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
+	return super->s_devops->write(sb, ofs, sb->s_blocksize, block);
+}
+
+static const struct logfs_area_ops journal_area_ops = {
+	.get_free_segment	= journal_get_free_segment,
+	.get_erase_count	= journal_get_erase_count,
+	.erase_segment		= journal_erase_segment,
+	.finish_area		= journal_finish_area,
+};
+
+int logfs_init_journal(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+void logfs_cleanup_journal(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+
+	__logfs_destroy_inode(super->s_master_inode);
+	super->s_master_inode = NULL;
+
+	kfree(super->s_bb_array);
+	kfree(super->s_compressed_je);
+	kfree(super->s_je);
+}

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbXFCSzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbXFCSzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXFCSzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:55:24 -0400
Received: from lazybastard.de ([212.112.238.170]:58095 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbXFCSzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:55:21 -0400
Date: Sun, 3 Jun 2007 20:50:42 +0200
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
Subject: [Patch 17/18] fs/logfs/progs/mkfs.c
Message-ID: <20070603185041.GR8952@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070603183845.GA8952@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-03-13 19:15:28.862769062 +0100
+++ linux-2.6.21logfs/fs/logfs/progs/mkfs.c	2007-06-03 19:18:57.000000000 +0200
@@ -0,0 +1,324 @@
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
+static size_t write_header(struct logfs_journal_header *h, size_t datalen,
+		u16 type)
+{
+	size_t len = datalen + sizeof(*h);
+	return __write_header(h, len, datalen, type, COMPR_NONE);
+}
+
+static size_t je_badsegments(void *data, u16 *type)
+{
+	memcpy(data, bb_array, blocksize);
+	*type = JE_BADSEGMENTS;
+	return blocksize;
+}
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
+static size_t je_commit(void *h, u16 *type)
+{
+	*type = JE_COMMIT;
+	return 0;
+}
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
+	return __write_header(header, full_len, len, type, compr);
+}
+
+static int make_journal(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+	ret = super->s_devops->write(sb, segment_offset[OFS_JOURNAL], blocksize, journal);
+	kfree(journal);
+	return ret;
+}
+
+/* superblock */
+static int make_super(struct super_block *sb, struct logfs_disk_super *ds)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+	ret = super->s_devops->write(sb, segment_offset[OFS_SB], 4096, sector);
+	kfree(sector);
+	return ret;
+}
+
+/* main */
+static void getsize(struct super_block *sb, u64 *size,
+		u64 *no_segs)
+{
+	*no_segs = logfs_super(sb)->s_mtd->size >> segshift;
+	*size = *no_segs << segshift;
+}
+
+static int bad_block_scan(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
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

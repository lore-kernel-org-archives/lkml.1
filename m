Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbXFCSzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbXFCSzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXFCSyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:54:53 -0400
Received: from lazybastard.de ([212.112.238.170]:58079 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbXFCSyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:54:51 -0400
Date: Sun, 3 Jun 2007 20:50:13 +0200
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
Subject: [Patch 16/18] fs/logfs/progs/fsck.c
Message-ID: <20070603185012.GQ8952@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070603183845.GA8952@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-03-13 19:15:28.862769062 +0100
+++ linux-2.6.21logfs/fs/logfs/progs/fsck.c	2007-06-03 19:18:57.000000000 +0200
@@ -0,0 +1,316 @@
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
+/*
+ * Pass 1: blocks
+ */
+
+static u32 logfs_free_bytes(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+	if (!memchr_inv(&sh, 0xff, sizeof(sh)))
+		return super->s_segsize;
+
+	free = super->s_segsize;
+	for (seg_ofs = sizeof(h); seg_ofs + sizeof(h) < super->s_segsize; ) {
+		wbuf_read(sb, dev_ofs(sb, segno, seg_ofs), sizeof(h), &h);
+		BUG_ON(err);
+		if (!memchr_inv(&h, 0xff, sizeof(h)))
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
+static void logfsck_blocks(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+/*
+ * Pass 2: directories
+ */
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
+static s64 dir_seek_data(struct inode *inode, s64 pos)
+{
+	s64 new_pos = logfs_seek_data(inode, pos);
+
+	return max((s64)pos, new_pos - 1);
+}
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
+/*
+ * Pass 3: inodes
+ */
+
+static int logfs_check_inode(struct inode *inode)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	u64 bytes0 = li->li_used_bytes;
+	u64 bytes1 = inode_bytes[inode->i_ino];
+	u64 links0 = inode->i_nlink;
+	u64 links1 = inode_links[inode->i_ino];
+
+	if (bytes0 || bytes1 || links0 || links1
+			|| inode->i_ino == logfs_super(inode->i_sb)->s_last_ino)
+		printk(KERN_INFO "%lx: %llx(%llx) bytes, %llx(%llx) links\n",
+				inode->i_ino, bytes0, bytes1, links0, links1);
+	used_bytes += bytes0;
+	return (bytes0 == bytes1) && (links0 == links1);
+}
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
+static int logfsck_inodes(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+/*
+ * Pass 4: Total blocks
+ */
+
+static int logfsck_stats(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
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
+int logfs_fsck(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
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

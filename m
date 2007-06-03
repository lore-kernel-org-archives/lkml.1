Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbXFCSt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbXFCSt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbXFCStt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:49:49 -0400
Received: from lazybastard.de ([212.112.238.170]:34737 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbXFCSts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:49:48 -0400
Date: Sun, 3 Jun 2007 20:45:10 +0200
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
Subject: [Patch 08/18] fs/logfs/file.c
Message-ID: <20070603184510.GI8952@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070603183845.GA8952@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-03-13 19:15:28.862769062 +0100
+++ linux-2.6.21logfs/fs/logfs/file.c	2007-06-03 19:55:14.000000000 +0200
@@ -0,0 +1,75 @@
+/*
+ * fs/logfs/file.c	- prepare_write, commit_write and friends
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
+ */
+#include "logfs.h"
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
+		mark_inode_dirty_sync(inode);
+	}
+
+	buf = kmap(page);
+	ret = logfs_write_buf(inode, index, buf);
+	kunmap(page);
+	return ret;
+}
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
+const struct inode_operations logfs_reg_iops = {
+	.truncate	= logfs_truncate,
+};
+
+const struct file_operations logfs_reg_fops = {
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
+	.llseek		= generic_file_llseek,
+	.mmap		= generic_file_readonly_mmap,
+	.open		= generic_file_open,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+};
+
+const struct address_space_operations logfs_reg_aops = {
+	.commit_write	= logfs_commit_write,
+	.prepare_write	= logfs_prepare_write,
+	.readpage	= logfs_readpage,
+	.set_page_dirty	= __set_page_dirty_nobuffers,
+};

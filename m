Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbXB0XSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbXB0XSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXB0XSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:18:42 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:54988 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbXB0XSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:18:20 -0500
Message-Id: <20070227231737.946840361@szeredi.hu>
References: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:15:03 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 21/22] fuse: limit dirty pages
Content-Disposition: inline; filename=fuse_dirty_limit.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a per-filesystem limit for the number of dirty pages.  If half the
limit is reached, background writeback is started.  If the limit is
reached, then start some writeback and wait until the the number goes
below the limit again.

The dirty limit is currently hardcoded at 1MB.  This limiting is
necessary, so that buggy or unfriendly filesystems don't hurt system
performance too badly.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-02-27 14:41:12.000000000 +0100
+++ linux/fs/fuse/file.c	2007-02-27 14:41:13.000000000 +0100
@@ -780,10 +780,35 @@ static void fuse_vma_close(struct vm_are
 	filemap_write_and_wait(vma->vm_file->f_mapping);
 }
 
+static int fuse_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	long nr_dirty = atomic_long_read(&fc->bdi.nr_dirty);
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_NONE,
+		.nr_to_write = FUSE_MAX_PAGES_PER_REQ,
+		.range_cyclic = 1,
+	};
+
+	while (nr_dirty >= fc->max_dirty) {
+		sync_sb(inode->i_sb, &wbc);
+		congestion_wait(WRITE, HZ / 10);
+		nr_dirty = atomic_long_read(&fc->bdi.nr_dirty);
+		wbc.nr_to_write = FUSE_MAX_PAGES_PER_REQ;
+	}
+	if (nr_dirty >= fc->max_dirty / 2) {
+		wbc.nonblocking = 1;
+		sync_sb(inode->i_sb, &wbc);
+	}
+	return 0;
+}
+
 static struct vm_operations_struct fuse_file_vm_ops = {
 	.close		= fuse_vma_close,
 	.nopage		= filemap_nopage,
 	.populate	= filemap_populate,
+	.page_mkwrite	= fuse_page_mkwrite,
 };
 
 static void fuse_send_writepages(struct fuse_req *req, struct inode *inode)
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-02-27 14:41:13.000000000 +0100
+++ linux/fs/fuse/fuse_i.h	2007-02-27 14:41:13.000000000 +0100
@@ -397,6 +397,9 @@ struct fuse_conn {
 
 	/** Reserved request for the DESTROY message */
 	struct fuse_req *destroy_req;
+
+	/** Maximum number of dirty pages in this fs */
+	unsigned long max_dirty;
 };
 
 static inline struct fuse_conn *get_fuse_conn_super(struct super_block *sb)
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-02-27 14:41:11.000000000 +0100
+++ linux/fs/fuse/inode.c	2007-02-27 14:41:13.000000000 +0100
@@ -425,6 +425,7 @@ static struct fuse_conn *new_conn(void)
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
 		fc->reqctr = 0;
 		fc->blocked = 1;
+		fc->max_dirty = (1024 * 1024) / PAGE_CACHE_SIZE;
 		get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
 	}
 	return fc;

--

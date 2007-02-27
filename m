Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbXB0XSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbXB0XSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbXB0XSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:18:46 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:51148 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbXB0XSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:18:16 -0500
Message-Id: <20070227231733.804160667@szeredi.hu>
References: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:15:02 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 20/22] fuse: make dirty stats available
Content-Disposition: inline; filename=fuse_queue_stats.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Make per-filesystem statistics about dirty and under-writeback pages
available through the fuse control filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/control.c
===================================================================
--- linux.orig/fs/fuse/control.c	2007-02-27 14:40:54.000000000 +0100
+++ linux/fs/fuse/control.c	2007-02-27 14:41:13.000000000 +0100
@@ -41,24 +41,60 @@ static ssize_t fuse_conn_abort_write(str
 	return count;
 }
 
-static ssize_t fuse_conn_waiting_read(struct file *file, char __user *buf,
-				      size_t len, loff_t *ppos)
+enum fusectl_type {
+	FUSECTL_WAITING,
+	FUSECTL_NR_DIRTY,
+	FUSECTL_NR_WRITEBACK
+};
+
+static ssize_t fuse_conn_read(struct file *file, char __user *buf,
+			      size_t len, loff_t *ppos, enum fusectl_type sel)
 {
 	char tmp[32];
 	size_t size;
 
 	if (!*ppos) {
+		long val = 0;
 		struct fuse_conn *fc = fuse_ctl_file_conn_get(file);
 		if (!fc)
 			return 0;
 
-		file->private_data=(void *)(long)atomic_read(&fc->num_waiting);
+		switch (sel) {
+		case FUSECTL_WAITING:
+			val = atomic_read(&fc->num_waiting);
+			break;
+		case FUSECTL_NR_DIRTY:
+			val = atomic_long_read(&fc->bdi.nr_dirty);
+			break;
+		case FUSECTL_NR_WRITEBACK:
+			val = atomic_long_read(&fc->bdi.nr_writeback);
+			break;
+		}
+		file->private_data = (void *) val;
 		fuse_conn_put(fc);
 	}
 	size = sprintf(tmp, "%ld\n", (long)file->private_data);
 	return simple_read_from_buffer(buf, len, ppos, tmp, size);
 }
 
+static ssize_t fuse_conn_waiting_read(struct file *file, char __user *buf,
+				      size_t len, loff_t *ppos)
+{
+	return fuse_conn_read(file, buf, len, ppos, FUSECTL_WAITING);
+}
+
+static ssize_t fuse_conn_nr_dirty_read(struct file *file, char __user *buf,
+				       size_t len, loff_t *ppos)
+{
+	return fuse_conn_read(file, buf, len, ppos, FUSECTL_NR_DIRTY);
+}
+
+static ssize_t fuse_conn_nr_writeback_read(struct file *file, char __user *buf,
+					   size_t len, loff_t *ppos)
+{
+	return fuse_conn_read(file, buf, len, ppos, FUSECTL_NR_WRITEBACK);
+}
+
 static const struct file_operations fuse_ctl_abort_ops = {
 	.open = nonseekable_open,
 	.write = fuse_conn_abort_write,
@@ -69,6 +105,16 @@ static const struct file_operations fuse
 	.read = fuse_conn_waiting_read,
 };
 
+static const struct file_operations fuse_ctl_nr_dirty_ops = {
+	.open = nonseekable_open,
+	.read = fuse_conn_nr_dirty_read,
+};
+
+static const struct file_operations fuse_ctl_nr_writeback_ops = {
+	.open = nonseekable_open,
+	.read = fuse_conn_nr_writeback_read,
+};
+
 static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 					  struct fuse_conn *fc,
 					  const char *name,
@@ -127,7 +173,11 @@ int fuse_ctl_add_conn(struct fuse_conn *
 	if (!fuse_ctl_add_dentry(parent, fc, "waiting", S_IFREG | 0400, 1,
 				NULL, &fuse_ctl_waiting_ops) ||
 	    !fuse_ctl_add_dentry(parent, fc, "abort", S_IFREG | 0200, 1,
-				 NULL, &fuse_ctl_abort_ops))
+				 NULL, &fuse_ctl_abort_ops) ||
+	    !fuse_ctl_add_dentry(parent, fc, "nr_dirty", S_IFREG | 0444, 1,
+				 NULL, &fuse_ctl_nr_dirty_ops) ||
+	    !fuse_ctl_add_dentry(parent, fc, "nr_writeback", S_IFREG | 0444, 1,
+				 NULL, &fuse_ctl_nr_writeback_ops))
 		goto err;
 
 	return 0;
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-02-27 14:41:11.000000000 +0100
+++ linux/fs/fuse/fuse_i.h	2007-02-27 14:41:13.000000000 +0100
@@ -30,7 +30,7 @@
 #define FUSE_NAME_MAX 1024
 
 /** Number of dentries for each connection in the control filesystem */
-#define FUSE_CTL_NUM_DENTRIES 3
+#define FUSE_CTL_NUM_DENTRIES 5
 
 /** If the FUSE_DEFAULT_PERMISSIONS flag is given, the filesystem
     module will check permissions based on the file mode.  Otherwise no

--

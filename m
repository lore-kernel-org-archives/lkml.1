Return-Path: <linux-kernel-owner+w=401wt.eu-S1752977Ab0AKJPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab0AKJPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 04:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928Ab0AKJPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 04:15:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab0AKJPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 04:15:37 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/4] GFS2: Ensure uptodate inode size when using O_APPEND
Date: Mon, 11 Jan 2010 09:11:37 +0000
Message-Id: <1263201100-6904-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1263201100-6904-1-git-send-email-swhiteho@redhat.com>
References: <1263201100-6904-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VFS reads the inode size during generic_file_aio_write() but
with no locking around it. In order to get the expected result
from O_APPEND opens, this patch updated the inode size before
calling generic_file_aio_write()

There is of course still a race here, in that there is nothing to
prevent another node coming in and extending the file in the
mean time. On the other hand, when used with file locking this
will ensure that the expected results are obtained.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/file.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 4eb308a..a6abbae 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -569,6 +569,40 @@ static int gfs2_fsync(struct file *file, struct dentry *dentry, int datasync)
 	return ret;
 }
 
+/**
+ * gfs2_file_aio_write - Perform a write to a file
+ * @iocb: The io context
+ * @iov: The data to write
+ * @nr_segs: Number of @iov segments
+ * @pos: The file position
+ *
+ * We have to do a lock/unlock here to refresh the inode size for
+ * O_APPEND writes, otherwise we can land up writing at the wrong
+ * offset. There is still a race, but provided the app is using its
+ * own file locking, this will make O_APPEND work as expected.
+ *
+ */
+
+static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
+				   unsigned long nr_segs, loff_t pos)
+{
+	struct file *file = iocb->ki_filp;
+
+	if (file->f_flags & O_APPEND) {
+		struct dentry *dentry = file->f_dentry;
+		struct gfs2_inode *ip = GFS2_I(dentry->d_inode);
+		struct gfs2_holder gh;
+		int ret;
+
+		ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+		if (ret)
+			return ret;
+		gfs2_glock_dq_uninit(&gh);
+	}
+
+	return generic_file_aio_write(iocb, iov, nr_segs, pos);
+}
+
 #ifdef CONFIG_GFS2_FS_LOCKING_DLM
 
 /**
@@ -711,7 +745,7 @@ const struct file_operations gfs2_file_fops = {
 	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
 	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
+	.aio_write	= gfs2_file_aio_write,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.mmap		= gfs2_mmap,
 	.open		= gfs2_open,
@@ -741,7 +775,7 @@ const struct file_operations gfs2_file_fops_nolock = {
 	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
 	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
+	.aio_write	= gfs2_file_aio_write,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.mmap		= gfs2_mmap,
 	.open		= gfs2_open,
-- 
1.6.2.5


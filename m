Return-Path: <linux-kernel-owner+w=401wt.eu-S1763536AbYALLUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763536AbYALLUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 06:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762211AbYALLUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 06:20:42 -0500
Received: from namei.org ([69.55.235.186]:55759 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762205AbYALLUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 06:20:40 -0500
Date: Sat, 12 Jan 2008 22:20:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH][RFC] security: call security_file_permission from rw_verify_area
Message-ID: <Xine.LNX.4.64.0801122217390.26179@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please review.  

Tested with SELinux in enforcing mode.

---

All instances of rw_verify_area() are followed by a call to
security_file_permission(), so just call the latter from the former.

Signed-off-by: James Morris <jmorris@namei.org>
---
 fs/compat.c     |    4 ---
 fs/read_write.c |   63 +++++++++++++++++++++----------------------------------
 fs/splice.c     |    8 -------
 3 files changed, 24 insertions(+), 51 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 15078ce..5216c3f 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1104,10 +1104,6 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 	if (ret < 0)
 		goto out;
 
-	ret = security_file_permission(file, type == READ ? MAY_READ:MAY_WRITE);
-	if (ret)
-		goto out;
-
 	fnv = NULL;
 	if (type == READ) {
 		fn = file->f_op->read;
diff --git a/fs/read_write.c b/fs/read_write.c
index ea1f94c..c4d3d17 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -197,25 +197,27 @@ int rw_verify_area(int read_write, struct file *file, loff_t *ppos, size_t count
 {
 	struct inode *inode;
 	loff_t pos;
+	int retval = -EINVAL;
 
 	inode = file->f_path.dentry->d_inode;
 	if (unlikely((ssize_t) count < 0))
-		goto Einval;
+		return retval;
 	pos = *ppos;
 	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
-		goto Einval;
+		return retval;
 
 	if (unlikely(inode->i_flock && mandatory_lock(inode))) {
-		int retval = locks_mandatory_area(
+		retval = locks_mandatory_area(
 			read_write == READ ? FLOCK_VERIFY_READ : FLOCK_VERIFY_WRITE,
 			inode, file, pos, count);
 		if (retval < 0)
 			return retval;
 	}
+	retval = security_file_permission(file,
+				read_write == READ ? MAY_READ : MAY_WRITE);
+	if (retval)
+		return retval;
 	return count > MAX_RW_COUNT ? MAX_RW_COUNT : count;
-
-Einval:
-	return -EINVAL;
 }
 
 static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
@@ -267,18 +269,15 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 	ret = rw_verify_area(READ, file, pos, count);
 	if (ret >= 0) {
 		count = ret;
-		ret = security_file_permission (file, MAY_READ);
-		if (!ret) {
-			if (file->f_op->read)
-				ret = file->f_op->read(file, buf, count, pos);
-			else
-				ret = do_sync_read(file, buf, count, pos);
-			if (ret > 0) {
-				fsnotify_access(file->f_path.dentry);
-				add_rchar(current, ret);
-			}
-			inc_syscr(current);
+		if (file->f_op->read)
+			ret = file->f_op->read(file, buf, count, pos);
+		else
+			ret = do_sync_read(file, buf, count, pos);
+		if (ret > 0) {
+			fsnotify_access(file->f_path.dentry);
+			add_rchar(current, ret);
 		}
+		inc_syscr(current);
 	}
 
 	return ret;
@@ -325,18 +324,15 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 	ret = rw_verify_area(WRITE, file, pos, count);
 	if (ret >= 0) {
 		count = ret;
-		ret = security_file_permission (file, MAY_WRITE);
-		if (!ret) {
-			if (file->f_op->write)
-				ret = file->f_op->write(file, buf, count, pos);
-			else
-				ret = do_sync_write(file, buf, count, pos);
-			if (ret > 0) {
-				fsnotify_modify(file->f_path.dentry);
-				add_wchar(current, ret);
-			}
-			inc_syscw(current);
+		if (file->f_op->write)
+			ret = file->f_op->write(file, buf, count, pos);
+		else
+			ret = do_sync_write(file, buf, count, pos);
+		if (ret > 0) {
+			fsnotify_modify(file->f_path.dentry);
+			add_wchar(current, ret);
 		}
+		inc_syscw(current);
 	}
 
 	return ret;
@@ -603,9 +599,6 @@ static ssize_t do_readv_writev(int type, struct file *file,
 	ret = rw_verify_area(type, file, pos, tot_len);
 	if (ret < 0)
 		goto out;
-	ret = security_file_permission(file, type == READ ? MAY_READ : MAY_WRITE);
-	if (ret)
-		goto out;
 
 	fnv = NULL;
 	if (type == READ) {
@@ -737,10 +730,6 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 		goto fput_in;
 	count = retval;
 
-	retval = security_file_permission (in_file, MAY_READ);
-	if (retval)
-		goto fput_in;
-
 	/*
 	 * Get output file, and verify that it is ok..
 	 */
@@ -759,10 +748,6 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 		goto fput_out;
 	count = retval;
 
-	retval = security_file_permission (out_file, MAY_WRITE);
-	if (retval)
-		goto fput_out;
-
 	if (!max)
 		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
 
diff --git a/fs/splice.c b/fs/splice.c
index 6bdcb61..56b802b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -908,10 +908,6 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
 	if (unlikely(ret < 0))
 		return ret;
 
-	ret = security_file_permission(out, MAY_WRITE);
-	if (unlikely(ret < 0))
-		return ret;
-
 	return out->f_op->splice_write(pipe, out, ppos, len, flags);
 }
 
@@ -934,10 +930,6 @@ static long do_splice_to(struct file *in, loff_t *ppos,
 	if (unlikely(ret < 0))
 		return ret;
 
-	ret = security_file_permission(in, MAY_READ);
-	if (unlikely(ret < 0))
-		return ret;
-
 	return in->f_op->splice_read(in, ppos, pipe, len, flags);
 }
 
-- 
1.5.3.7


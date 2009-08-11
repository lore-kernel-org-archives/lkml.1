Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZHKQa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZHKQa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbZHKQa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:30:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55877 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbZHKQaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:30:22 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/8] fsnotify: pass a file instead of an inode to open, read,
	and write
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Date: Tue, 11 Aug 2009 12:30:23 -0400
Message-ID: <20090811163022.8648.88326.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
References: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify, the upcoming notification system actually needs a struct path so it can
do opens in the context of listeners, and it needs a file so it can get f_flags
from the original process.  Close was the only operation that already was passing
a struct file to the notification hook.  This patch passes a file for access,
modify, and open as well as they are easily available to these hooks.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/compat.c              |    5 ++---
 fs/exec.c                |    4 ++--
 fs/nfsd/vfs.c            |    4 ++--
 fs/open.c                |    2 +-
 fs/read_write.c          |    8 ++++----
 include/linux/fsnotify.h |   15 +++++++++------
 6 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 94502da..1465b80 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1177,11 +1177,10 @@ out:
 	if (iov != iovstack)
 		kfree(iov);
 	if ((ret + (type == READ)) > 0) {
-		struct dentry *dentry = file->f_path.dentry;
 		if (type == READ)
-			fsnotify_access(dentry);
+			fsnotify_access(file);
 		else
-			fsnotify_modify(dentry);
+			fsnotify_modify(file);
 	}
 	return ret;
 }
diff --git a/fs/exec.c b/fs/exec.c
index 4a8849e..12b1d4e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -128,7 +128,7 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 	if (file->f_path.mnt->mnt_flags & MNT_NOEXEC)
 		goto exit;
 
-	fsnotify_open(file->f_path.dentry);
+	fsnotify_open(file);
 
 	error = -ENOEXEC;
 	if(file->f_op) {
@@ -663,7 +663,7 @@ struct file *open_exec(const char *name)
 	if (file->f_path.mnt->mnt_flags & MNT_NOEXEC)
 		goto exit;
 
-	fsnotify_open(file->f_path.dentry);
+	fsnotify_open(file);
 
 	err = deny_write_access(file);
 	if (err)
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 23341c1..5c8f67e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -948,7 +948,7 @@ nfsd_vfs_read(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 		nfsdstats.io_read += host_err;
 		*count = host_err;
 		err = 0;
-		fsnotify_access(file->f_path.dentry);
+		fsnotify_access(file);
 	} else 
 		err = nfserrno(host_err);
 out:
@@ -1059,7 +1059,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 		goto out_nfserr;
 	*cnt = host_err;
 	nfsdstats.io_write += host_err;
-	fsnotify_modify(file->f_path.dentry);
+	fsnotify_modify(file);
 
 	/* clear setuid/setgid flag after write */
 	if (inode->i_mode & (S_ISUID | S_ISGID))
diff --git a/fs/open.c b/fs/open.c
index dd98e80..650ae9f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1038,7 +1038,7 @@ long do_sys_open(int dfd, const char __user *filename, int flags, int mode)
 				put_unused_fd(fd);
 				fd = PTR_ERR(f);
 			} else {
-				fsnotify_open(f->f_path.dentry);
+				fsnotify_open(f);
 				fd_install(fd, f);
 			}
 		}
diff --git a/fs/read_write.c b/fs/read_write.c
index 6c8c55d..c7479e9 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -293,7 +293,7 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 		else
 			ret = do_sync_read(file, buf, count, pos);
 		if (ret > 0) {
-			fsnotify_access(file->f_path.dentry);
+			fsnotify_access(file);
 			add_rchar(current, ret);
 		}
 		inc_syscr(current);
@@ -348,7 +348,7 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 		else
 			ret = do_sync_write(file, buf, count, pos);
 		if (ret > 0) {
-			fsnotify_modify(file->f_path.dentry);
+			fsnotify_modify(file);
 			add_wchar(current, ret);
 		}
 		inc_syscw(current);
@@ -656,9 +656,9 @@ out:
 		kfree(iov);
 	if ((ret + (type == READ)) > 0) {
 		if (type == READ)
-			fsnotify_access(file->f_path.dentry);
+			fsnotify_access(file);
 		else
-			fsnotify_modify(file->f_path.dentry);
+			fsnotify_modify(file);
 	}
 	return ret;
 }
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 936f9aa..36357a4 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -183,8 +183,9 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 /*
  * fsnotify_access - file was read
  */
-static inline void fsnotify_access(struct dentry *dentry)
+static inline void fsnotify_access(struct file *file)
 {
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	__u32 mask = FS_ACCESS;
 
@@ -194,14 +195,15 @@ static inline void fsnotify_access(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
 /*
  * fsnotify_modify - file was modified
  */
-static inline void fsnotify_modify(struct dentry *dentry)
+static inline void fsnotify_modify(struct file *file)
 {
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	__u32 mask = FS_MODIFY;
 
@@ -211,14 +213,15 @@ static inline void fsnotify_modify(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
 /*
  * fsnotify_open - file was opened
  */
-static inline void fsnotify_open(struct dentry *dentry)
+static inline void fsnotify_open(struct file *file)
 {
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	__u32 mask = FS_OPEN;
 
@@ -228,7 +231,7 @@ static inline void fsnotify_open(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
 /*


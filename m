Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbYKLQL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbYKLQL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYKLQLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:11:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47105 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbYKLQLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:11:14 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 02/21] fsnotify: pass a file instead of an inode to open,
	read, and write
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:10:37 -0500
Message-ID: <20081112161037.25434.13592.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify, the upcoming notification system actually needs a f_path so it can
do opens in the context of listeners, and it needs a file so it can get f_flags
from the original process.  Close already was passing a file.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/compat.c              |    5 ++---
 fs/nfsd/vfs.c            |    4 ++--
 fs/open.c                |    2 +-
 fs/read_write.c          |    8 ++++----
 include/linux/fsnotify.h |    9 ++++++---
 5 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index e5f49f5..4a7788f 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1158,11 +1158,10 @@ out:
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
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 4433c8f..f4bc1e6 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -940,7 +940,7 @@ nfsd_vfs_read(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 		nfsdstats.io_read += host_err;
 		*count = host_err;
 		err = 0;
-		fsnotify_access(file->f_path.dentry);
+		fsnotify_access(file);
 	} else 
 		err = nfserrno(host_err);
 out:
@@ -1007,7 +1007,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 	set_fs(oldfs);
 	if (host_err >= 0) {
 		nfsdstats.io_write += cnt;
-		fsnotify_modify(file->f_path.dentry);
+		fsnotify_modify(file);
 	}
 
 	/* clear setuid/setgid flag after write */
diff --git a/fs/open.c b/fs/open.c
index 83cdb9d..9d69dd9 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1020,7 +1020,7 @@ long do_sys_open(int dfd, const char __user *filename, int flags, int mode)
 				put_unused_fd(fd);
 				fd = PTR_ERR(f);
 			} else {
-				fsnotify_open(f->f_path.dentry);
+				fsnotify_open(f);
 				fd_install(fd, f);
 			}
 		}
diff --git a/fs/read_write.c b/fs/read_write.c
index 969a6d9..7eb2949 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -280,7 +280,7 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 		else
 			ret = do_sync_read(file, buf, count, pos);
 		if (ret > 0) {
-			fsnotify_access(file->f_path.dentry);
+			fsnotify_access(file);
 			add_rchar(current, ret);
 		}
 		inc_syscr(current);
@@ -335,7 +335,7 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 		else
 			ret = do_sync_write(file, buf, count, pos);
 		if (ret > 0) {
-			fsnotify_modify(file->f_path.dentry);
+			fsnotify_modify(file);
 			add_wchar(current, ret);
 		}
 		inc_syscw(current);
@@ -626,9 +626,9 @@ out:
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
index 00fbd5b..dec1afb 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -136,8 +136,9 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 /*
  * fsnotify_access - file was read
  */
-static inline void fsnotify_access(struct dentry *dentry)
+static inline void fsnotify_access(struct file *file)
 {
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	u32 mask = IN_ACCESS;
 
@@ -152,8 +153,9 @@ static inline void fsnotify_access(struct dentry *dentry)
 /*
  * fsnotify_modify - file was modified
  */
-static inline void fsnotify_modify(struct dentry *dentry)
+static inline void fsnotify_modify(struct file *file)
 {
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	u32 mask = IN_MODIFY;
 
@@ -168,8 +170,9 @@ static inline void fsnotify_modify(struct dentry *dentry)
 /*
  * fsnotify_open - file was opened
  */
-static inline void fsnotify_open(struct dentry *dentry)
+static inline void fsnotify_open(struct file *file)
 {
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	u32 mask = IN_OPEN;
 


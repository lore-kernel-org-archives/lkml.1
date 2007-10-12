Return-Path: <linux-kernel-owner+w=401wt.eu-S1761518AbXJLQWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518AbXJLQWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbXJLQIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:08:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760292AbXJLQIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:08:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 32/52] CRED: Give the symlink() inode op a credentials pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:08:03 +0100
Message-ID: <20071012160802.15119.65706.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give the symlink() inode op a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/dir.c       |    4 ++--
 fs/autofs4/root.c  |    6 ++++--
 fs/bad_inode.c     |    2 +-
 fs/ext3/namei.c    |    3 +--
 fs/namei.c         |    3 ++-
 fs/nfs/dir.c       |    7 ++++---
 fs/ramfs/inode.c   |    4 ++--
 include/linux/fs.h |    3 ++-
 mm/shmem.c         |    4 ++--
 9 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 5f4ac2e..745c8cb 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -39,7 +39,7 @@ static int afs_unlink(struct inode *dir, struct dentry *dentry,
 static int afs_link(struct dentry *from, struct inode *dir,
 		    struct dentry *dentry, struct cred *cred);
 static int afs_symlink(struct inode *dir, struct dentry *dentry,
-		       const char *content);
+		       const char *content, struct cred *cred);
 static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		      struct inode *new_dir, struct dentry *new_dentry,
 		      struct cred *cred);
@@ -1030,7 +1030,7 @@ error:
  * create a symlink in an AFS filesystem
  */
 static int afs_symlink(struct inode *dir, struct dentry *dentry,
-		       const char *content)
+		       const char *content, struct cred *cred)
 {
 	struct afs_file_status status;
 	struct afs_server *server;
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 1743d38..50c0ec7 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -19,7 +19,8 @@
 #include <linux/time.h>
 #include "autofs_i.h"
 
-static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
+static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *,
+			       struct cred *);
 static int autofs4_dir_unlink(struct inode *,struct dentry *, struct cred *);
 static int autofs4_dir_rmdir(struct inode *,struct dentry *, struct cred *);
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int, struct cred *);
@@ -690,7 +691,8 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 
 static int autofs4_dir_symlink(struct inode *dir, 
 			       struct dentry *dentry,
-			       const char *symname)
+			       const char *symname,
+			       struct cred *cred)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 2511f29..2e25bfe 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -210,7 +210,7 @@ static int bad_inode_unlink(struct inode *dir, struct dentry *dentry,
 }
 
 static int bad_inode_symlink (struct inode *dir, struct dentry *dentry,
-		const char *symname)
+		const char *symname, struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index d682786..cd0fcde 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2196,9 +2196,8 @@ end_unlink:
 }
 
 static int ext3_symlink (struct inode * dir,
-		struct dentry *dentry, const char * symname)
+		struct dentry *dentry, const char * symname, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode * inode;
 	int l, err, retries = 0;
diff --git a/fs/namei.c b/fs/namei.c
index 4af97fd..9439e6e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2239,6 +2239,7 @@ asmlinkage long sys_unlink(const char __user *pathname)
 
 int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname, int mode)
 {
+	struct cred *cred = current->cred;
 	int error = may_create(dir, dentry, NULL);
 
 	if (error)
@@ -2252,7 +2253,7 @@ int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname, i
 		return error;
 
 	DQUOT_INIT(dir);
-	error = dir->i_op->symlink(dir, dentry, oldname);
+	error = dir->i_op->symlink(dir, dentry, oldname, cred);
 	if (!error)
 		fsnotify_create(dir, dentry);
 	return error;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 18cea2c..0dda7bb 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -49,7 +49,8 @@ static int nfs_create(struct inode *, struct dentry *, int, struct nameidata *,
 static int nfs_mkdir(struct inode *, struct dentry *, int, struct cred *);
 static int nfs_rmdir(struct inode *, struct dentry *, struct cred *);
 static int nfs_unlink(struct inode *, struct dentry *, struct cred *);
-static int nfs_symlink(struct inode *, struct dentry *, const char *);
+static int nfs_symlink(struct inode *, struct dentry *, const char *,
+		       struct cred *);
 static int nfs_link(struct dentry *, struct inode *, struct dentry *,
 		    struct cred *);
 static int nfs_mknod(struct inode *, struct dentry *, int, dev_t,
@@ -1539,9 +1540,9 @@ static int nfs_unlink(struct inode *dir, struct dentry *dentry,
  * now have a new file handle and can instantiate an in-core NFS inode
  * and move the raw page into its mapping.
  */
-static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
+static int nfs_symlink(struct inode *dir, struct dentry *dentry,
+		       const char *symname, struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct pagevec lru_pvec;
 	struct page *page;
 	char *kaddr;
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 53e917c..9903253 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -126,9 +126,9 @@ static int ramfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	return ramfs_mknod(dir, dentry, mode | S_IFREG, 0, cred);
 }
 
-static int ramfs_symlink(struct inode * dir, struct dentry *dentry, const char * symname)
+static int ramfs_symlink(struct inode * dir, struct dentry *dentry,
+			 const char * symname, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode *inode;
 	int error = -ENOSPC;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7fe8921..e321a7c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1141,7 +1141,8 @@ struct inode_operations {
 	int (*link) (struct dentry *,struct inode *,struct dentry *,
 		     struct cred *);
 	int (*unlink) (struct inode *,struct dentry *, struct cred *);
-	int (*symlink) (struct inode *,struct dentry *,const char *);
+	int (*symlink) (struct inode *,struct dentry *,const char *,
+			struct cred *);
 	int (*mkdir) (struct inode *,struct dentry *,int, struct cred *);
 	int (*rmdir) (struct inode *,struct dentry *, struct cred *);
 	int (*mknod) (struct inode *,struct dentry *,int,dev_t, struct cred *);
diff --git a/mm/shmem.c b/mm/shmem.c
index 9d2ebe2..fc834e7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1855,9 +1855,9 @@ static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry,
 	return 0;
 }
 
-static int shmem_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
+static int shmem_symlink(struct inode *dir, struct dentry *dentry,
+			 const char *symname, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	int error;
 	int len;
 	struct inode *inode;


Return-Path: <linux-kernel-owner+w=401wt.eu-S932820AbXJLQUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbXJLQUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758909AbXJLQHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:07:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760188AbXJLQHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:07:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 29/52] CRED: Give the unlink() inode op a credentials pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:07:47 +0100
Message-ID: <20071012160747.15119.71192.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give the unlink() inode op a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/dir.c                 |    6 ++++--
 fs/autofs4/root.c            |    5 +++--
 fs/bad_inode.c               |    3 ++-
 fs/ext3/namei.c              |    4 ++--
 fs/libfs.c                   |   10 +++++++---
 fs/namei.c                   |    3 ++-
 fs/nfs/dir.c                 |    6 +++---
 fs/vfat/namei.c              |    3 ++-
 include/linux/fs.h           |    4 ++--
 mm/shmem.c                   |    9 ++++++---
 net/sunrpc/rpc_pipe.c        |    6 ++++--
 security/inode.c             |    3 ++-
 security/selinux/selinuxfs.c |    3 ++-
 13 files changed, 41 insertions(+), 24 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 48f2759..b6d5abb 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -33,7 +33,8 @@ static int afs_create(struct inode *dir, struct dentry *dentry, int mode,
 static int afs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
 		     struct cred *cred);
 static int afs_rmdir(struct inode *dir, struct dentry *dentry);
-static int afs_unlink(struct inode *dir, struct dentry *dentry);
+static int afs_unlink(struct inode *dir, struct dentry *dentry,
+		      struct cred *cred);
 static int afs_link(struct dentry *from, struct inode *dir,
 		    struct dentry *dentry, struct cred *cred);
 static int afs_symlink(struct inode *dir, struct dentry *dentry,
@@ -839,7 +840,8 @@ error:
 /*
  * remove a file from an AFS filesystem
  */
-static int afs_unlink(struct inode *dir, struct dentry *dentry)
+static int afs_unlink(struct inode *dir, struct dentry *dentry,
+		      struct cred *cred)
 {
 	struct afs_vnode *dvnode, *vnode;
 	struct key *key;
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 63c0b62..747a51f 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -20,7 +20,7 @@
 #include "autofs_i.h"
 
 static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
-static int autofs4_dir_unlink(struct inode *,struct dentry *);
+static int autofs4_dir_unlink(struct inode *,struct dentry *, struct cred *);
 static int autofs4_dir_rmdir(struct inode *,struct dentry *);
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int, struct cred *);
 static int autofs4_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
@@ -755,7 +755,8 @@ static int autofs4_dir_symlink(struct inode *dir,
  *
  * Also see autofs4_dir_rmdir()..
  */
-static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
+static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry,
+			      struct cred *cred)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index a13970d..0b0a787 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -203,7 +203,8 @@ static int bad_inode_link (struct dentry *old_dentry, struct inode *dir,
 	return -EIO;
 }
 
-static int bad_inode_unlink(struct inode *dir, struct dentry *dentry)
+static int bad_inode_unlink(struct inode *dir, struct dentry *dentry,
+			    struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 4c19acf..f0e3303 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2140,9 +2140,9 @@ end_rmdir:
 	return retval;
 }
 
-static int ext3_unlink(struct inode * dir, struct dentry *dentry)
+static int ext3_unlink(struct inode * dir, struct dentry *dentry,
+		       struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	int retval;
 	struct inode * inode;
 	struct buffer_head * bh;
diff --git a/fs/libfs.c b/fs/libfs.c
index d82eaaa..d4cab7a 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -8,6 +8,7 @@
 #include <linux/mount.h>
 #include <linux/vfs.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 
@@ -283,7 +284,7 @@ out:
 	return ret;
 }
 
-int simple_unlink(struct inode *dir, struct dentry *dentry)
+int simple_unlink(struct inode *dir, struct dentry *dentry, struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 
@@ -295,11 +296,13 @@ int simple_unlink(struct inode *dir, struct dentry *dentry)
 
 int simple_rmdir(struct inode *dir, struct dentry *dentry)
 {
+	struct cred *cred = current->cred;
+
 	if (!simple_empty(dentry))
 		return -ENOTEMPTY;
 
 	drop_nlink(dentry->d_inode);
-	simple_unlink(dir, dentry);
+	simple_unlink(dir, dentry, cred);
 	drop_nlink(dir);
 	return 0;
 }
@@ -307,6 +310,7 @@ int simple_rmdir(struct inode *dir, struct dentry *dentry)
 int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
 		struct inode *new_dir, struct dentry *new_dentry)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = old_dentry->d_inode;
 	int they_are_dirs = S_ISDIR(old_dentry->d_inode->i_mode);
 
@@ -314,7 +318,7 @@ int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return -ENOTEMPTY;
 
 	if (new_dentry->d_inode) {
-		simple_unlink(new_dir, new_dentry);
+		simple_unlink(new_dir, new_dentry, cred);
 		if (they_are_dirs)
 			drop_nlink(old_dir);
 	} else if (they_are_dirs) {
diff --git a/fs/namei.c b/fs/namei.c
index 51e0322..fe94ef5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2138,6 +2138,7 @@ asmlinkage long sys_rmdir(const char __user *pathname)
 
 int vfs_unlink(struct inode *dir, struct dentry *dentry)
 {
+	struct cred *cred = current->cred;
 	int error = may_delete(dir, dentry, 0);
 
 	if (error)
@@ -2154,7 +2155,7 @@ int vfs_unlink(struct inode *dir, struct dentry *dentry)
 	else {
 		error = security_inode_unlink(dir, dentry);
 		if (!error)
-			error = dir->i_op->unlink(dir, dentry);
+			error = dir->i_op->unlink(dir, dentry, cred);
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 4e12cf7..5c1f1d4 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -48,7 +48,7 @@ static int nfs_create(struct inode *, struct dentry *, int, struct nameidata *,
 		      struct cred *);
 static int nfs_mkdir(struct inode *, struct dentry *, int, struct cred *);
 static int nfs_rmdir(struct inode *, struct dentry *);
-static int nfs_unlink(struct inode *, struct dentry *);
+static int nfs_unlink(struct inode *, struct dentry *, struct cred *);
 static int nfs_symlink(struct inode *, struct dentry *, const char *);
 static int nfs_link(struct dentry *, struct inode *, struct dentry *,
 		    struct cred *);
@@ -1487,9 +1487,9 @@ out:
  *
  *  If sillyrename() returns 0, we do nothing, otherwise we unlink.
  */
-static int nfs_unlink(struct inode *dir, struct dentry *dentry)
+static int nfs_unlink(struct inode *dir, struct dentry *dentry,
+		      struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	int error;
 	int need_rehash = 0;
 
diff --git a/fs/vfat/namei.c b/fs/vfat/namei.c
index 8784b57..434ffdf 100644
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -793,7 +793,8 @@ out:
 	return err;
 }
 
-static int vfat_unlink(struct inode *dir, struct dentry *dentry)
+static int vfat_unlink(struct inode *dir, struct dentry *dentry,
+		       struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	struct fat_slot_info sinfo;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d8cecd4..62df85a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1140,7 +1140,7 @@ struct inode_operations {
 	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata *);
 	int (*link) (struct dentry *,struct inode *,struct dentry *,
 		     struct cred *);
-	int (*unlink) (struct inode *,struct dentry *);
+	int (*unlink) (struct inode *,struct dentry *, struct cred *);
 	int (*symlink) (struct inode *,struct dentry *,const char *);
 	int (*mkdir) (struct inode *,struct dentry *,int, struct cred *);
 	int (*rmdir) (struct inode *,struct dentry *);
@@ -1797,7 +1797,7 @@ extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int simple_statfs(struct dentry *, struct kstatfs *);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *,
 		       struct cred *);
-extern int simple_unlink(struct inode *, struct dentry *);
+extern int simple_unlink(struct inode *, struct dentry *, struct cred *);
 extern int simple_rmdir(struct inode *, struct dentry *);
 extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
 extern int simple_sync_file(struct file *, struct dentry *, int);
diff --git a/mm/shmem.c b/mm/shmem.c
index 7358d14..1e3c4e7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1790,7 +1790,8 @@ static int shmem_link(struct dentry *old_dentry, struct inode *dir,
 	return 0;
 }
 
-static int shmem_unlink(struct inode *dir, struct dentry *dentry)
+static int shmem_unlink(struct inode *dir, struct dentry *dentry,
+			struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 
@@ -1812,12 +1813,13 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
 
 static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
 {
+	struct cred *cred = current->cred;
 	if (!simple_empty(dentry))
 		return -ENOTEMPTY;
 
 	drop_nlink(dentry->d_inode);
 	drop_nlink(dir);
-	return shmem_unlink(dir, dentry);
+	return shmem_unlink(dir, dentry, cred);
 }
 
 /*
@@ -1828,6 +1830,7 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
  */
 static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = old_dentry->d_inode;
 	int they_are_dirs = S_ISDIR(inode->i_mode);
 
@@ -1835,7 +1838,7 @@ static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct
 		return -ENOTEMPTY;
 
 	if (new_dentry->d_inode) {
-		(void) shmem_unlink(new_dir, new_dentry);
+		(void) shmem_unlink(new_dir, new_dentry, cred);
 		if (they_are_dirs)
 			drop_nlink(old_dir);
 	} else if (they_are_dirs) {
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 669e12a..1906ee1 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -514,6 +514,7 @@ rpc_get_inode(struct super_block *sb, int mode)
 static void
 rpc_depopulate(struct dentry *parent, int start, int eof)
 {
+	struct cred *cred = current->cred;
 	struct inode *dir = parent->d_inode;
 	struct list_head *pos, *next;
 	struct dentry *dentry, *dvec[10];
@@ -544,7 +545,7 @@ repeat:
 		do {
 			dentry = dvec[--n];
 			if (S_ISREG(dentry->d_inode->i_mode))
-				simple_unlink(dir, dentry);
+				simple_unlink(dir, dentry, cred);
 			else if (S_ISDIR(dentry->d_inode->i_mode))
 				simple_rmdir(dir, dentry);
 			d_delete(dentry);
@@ -765,6 +766,7 @@ err_dput:
 int
 rpc_unlink(struct dentry *dentry)
 {
+	struct cred *cred = current->cred;
 	struct dentry *parent;
 	struct inode *dir;
 	int error = 0;
@@ -774,7 +776,7 @@ rpc_unlink(struct dentry *dentry)
 	mutex_lock_nested(&dir->i_mutex, I_MUTEX_PARENT);
 	if (--RPC_I(dentry->d_inode)->nkern_readwriters == 0) {
 		rpc_close_pipes(dentry->d_inode);
-		error = simple_unlink(dir, dentry);
+		error = simple_unlink(dir, dentry, cred);
 		if (!error)
 			d_delete(dentry);
 	}
diff --git a/security/inode.c b/security/inode.c
index 307211a..1eaaf3d 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -292,6 +292,7 @@ EXPORT_SYMBOL_GPL(securityfs_create_dir);
 void securityfs_remove(struct dentry *dentry)
 {
 	struct dentry *parent;
+	struct cred *cred = current->cred;
 
 	if (!dentry)
 		return;
@@ -306,7 +307,7 @@ void securityfs_remove(struct dentry *dentry)
 			if (S_ISDIR(dentry->d_inode->i_mode))
 				simple_rmdir(parent->d_inode, dentry);
 			else
-				simple_unlink(parent->d_inode, dentry);
+				simple_unlink(parent->d_inode, dentry, cred);
 			dput(dentry);
 		}
 	}
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index c9e92da..728b631 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -963,6 +963,7 @@ static void sel_remove_entries(struct dentry *de)
 {
 	struct list_head *p, *node;
 	struct super_block *sb = de->d_sb;
+	struct cred *cred = current->cred;
 
 	spin_lock(&dcache_lock);
 	node = de->d_subdirs.next;
@@ -974,7 +975,7 @@ static void sel_remove_entries(struct dentry *de)
 			d = dget_locked(d);
 			spin_unlock(&dcache_lock);
 			d_delete(d);
-			simple_unlink(de->d_inode, d);
+			simple_unlink(de->d_inode, d, cred);
 			dput(d);
 			spin_lock(&dcache_lock);
 		}


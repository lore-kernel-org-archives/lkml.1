Return-Path: <linux-kernel-owner+w=401wt.eu-S1761938AbXJLQ2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938AbXJLQ2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760367AbXJLQJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:09:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760583AbXJLQJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:09:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 44/52] CRED: Pass credentials through the follow_link() inode
	op
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:09:04 +0100
Message-ID: <20071012160904.15119.43864.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the follow_link() inode operation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/mntpt.c        |    6 ++++--
 fs/autofs4/root.c     |    6 ++++--
 fs/autofs4/symlink.c  |    3 ++-
 fs/ext3/symlink.c     |    3 ++-
 fs/namei.c            |    9 ++++++---
 fs/nfs/namespace.c    |    5 +++--
 fs/nfs/symlink.c      |    4 ++--
 fs/proc/base.c        |    6 ++++--
 fs/proc/generic.c     |    3 ++-
 fs/proc/proc_net.c    |    3 ++-
 fs/sysfs/dir.c        |    2 +-
 fs/sysfs/symlink.c    |    3 ++-
 include/linux/fs.h    |    6 ++++--
 include/linux/sysfs.h |    6 ++++--
 mm/shmem.c            |    7 +++++--
 15 files changed, 47 insertions(+), 25 deletions(-)

diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index 21a04c0..864255e 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -26,7 +26,8 @@ static struct dentry *afs_mntpt_lookup(struct inode *dir,
 				       struct nameidata *nd,
 				       struct cred *cred);
 static int afs_mntpt_open(struct inode *inode, struct file *file);
-static void *afs_mntpt_follow_link(struct dentry *dentry, struct nameidata *nd);
+static void *afs_mntpt_follow_link(struct dentry *dentry, struct nameidata *nd,
+				   struct cred *cred);
 static void afs_mntpt_expiry_timed_out(struct work_struct *work);
 
 const struct file_operations afs_mntpt_file_operations = {
@@ -212,7 +213,8 @@ error:
 /*
  * follow a link from a mountpoint directory, thus causing it to be mounted
  */
-static void *afs_mntpt_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *afs_mntpt_follow_link(struct dentry *dentry, struct nameidata *nd,
+				   struct cred *cred)
 {
 	struct vfsmount *newmnt;
 	int err;
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index fd22c05..5ee7e2d 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -31,7 +31,8 @@ static int autofs4_dir_readdir(struct file * filp, void * dirent, filldir_t fill
 static int autofs4_root_readdir(struct file * filp, void * dirent, filldir_t filldir);
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *,
 				     struct nameidata *, struct cred *);
-static void *autofs4_follow_link(struct dentry *, struct nameidata *);
+static void *autofs4_follow_link(struct dentry *, struct nameidata *,
+				 struct cred *);
 
 const struct file_operations autofs4_root_operations = {
 	.open		= dcache_dir_open,
@@ -325,7 +326,8 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
 }
 
 /* For autofs direct mounts the follow link triggers the mount */
-static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd,
+				 struct cred *cred)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
diff --git a/fs/autofs4/symlink.c b/fs/autofs4/symlink.c
index b4ea829..767d760 100644
--- a/fs/autofs4/symlink.c
+++ b/fs/autofs4/symlink.c
@@ -12,7 +12,8 @@
 
 #include "autofs_i.h"
 
-static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd,
+				 struct cred *cred)
 {
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	nd_set_link(nd, (char *)ino->u.symlink);
diff --git a/fs/ext3/symlink.c b/fs/ext3/symlink.c
index ff7b4cc..b56a509 100644
--- a/fs/ext3/symlink.c
+++ b/fs/ext3/symlink.c
@@ -23,7 +23,8 @@
 #include <linux/namei.h>
 #include "xattr.h"
 
-static void * ext3_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void * ext3_follow_link(struct dentry *dentry, struct nameidata *nd,
+			       struct cred *cred)
 {
 	struct ext3_inode_info *ei = EXT3_I(dentry->d_inode);
 	nd_set_link(nd, (char*)ei->i_data);
diff --git a/fs/namei.c b/fs/namei.c
index 1703fd0..d77e045 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -595,6 +595,7 @@ static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
 
 static __always_inline int __do_follow_link(struct path *path, struct nameidata *nd)
 {
+	struct cred *cred = current->cred;
 	int error;
 	void *cookie;
 	struct dentry *dentry = path->dentry;
@@ -607,7 +608,7 @@ static __always_inline int __do_follow_link(struct path *path, struct nameidata
 		dget(dentry);
 	}
 	mntget(path->mnt);
-	cookie = dentry->d_inode->i_op->follow_link(dentry, nd);
+	cookie = dentry->d_inode->i_op->follow_link(dentry, nd, cred);
 	error = PTR_ERR(cookie);
 	if (!IS_ERR(cookie)) {
 		char *s = nd_get_link(nd);
@@ -2682,11 +2683,12 @@ out:
  */
 int generic_readlink(struct dentry *dentry, char __user *buffer, int buflen)
 {
+	struct cred *cred = current->cred;
 	struct nameidata nd;
 	void *cookie;
 
 	nd.depth = 0;
-	cookie = dentry->d_inode->i_op->follow_link(dentry, &nd);
+	cookie = dentry->d_inode->i_op->follow_link(dentry, &nd, cred);
 	if (!IS_ERR(cookie)) {
 		int res = vfs_readlink(dentry, buffer, buflen, nd_get_link(&nd));
 		if (dentry->d_inode->i_op->put_link)
@@ -2725,7 +2727,8 @@ int page_readlink(struct dentry *dentry, char __user *buffer, int buflen)
 	return res;
 }
 
-void *page_follow_link_light(struct dentry *dentry, struct nameidata *nd)
+void *page_follow_link_light(struct dentry *dentry, struct nameidata *nd,
+			     struct cred *cred)
 {
 	struct page *page = NULL;
 	nd_set_link(nd, page_getlink(dentry, &page));
diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index b8d3576..72f305f 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -85,6 +85,7 @@ Elong:
  * nfs_follow_mountpoint - handle crossing a mountpoint on the server
  * @dentry - dentry of mountpoint
  * @nd - nameidata info
+ * @acred - the credentials to use
  *
  * When we encounter a mountpoint on the server, we want to set up
  * a mountpoint on the client too, to prevent inode numbers from
@@ -94,9 +95,9 @@ Elong:
  * situation, and that different filesystems may want to use
  * different security flavours.
  */
-static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
+static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd,
+				    struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct vfsmount *mnt;
 	struct nfs_server *server = NFS_SERVER(dentry->d_inode);
 	struct dentry *parent;
diff --git a/fs/nfs/symlink.c b/fs/nfs/symlink.c
index cd1df31..1186339 100644
--- a/fs/nfs/symlink.c
+++ b/fs/nfs/symlink.c
@@ -53,10 +53,10 @@ error:
 	return -EIO;
 }
 
-static void *nfs_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *nfs_follow_link(struct dentry *dentry, struct nameidata *nd,
+			     struct cred *acred)
 {
 	struct inode *inode = dentry->d_inode;
-	struct cred *acred = current->cred;
 	struct page *page;
 	void *err;
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9262681..d26cf33 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -933,7 +933,8 @@ static const struct file_operations proc_pid_sched_operations = {
 
 #endif
 
-static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd,
+				  struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	int error = -EACCES;
@@ -1896,7 +1897,8 @@ static int proc_self_readlink(struct dentry *dentry, char __user *buffer,
 	return vfs_readlink(dentry,buffer,buflen,tmp);
 }
 
-static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd,
+				   struct cred *cred)
 {
 	char tmp[PROC_NUMBUF];
 	sprintf(tmp, "%d", current->tgid);
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index ef5fb3a..ea67aac 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -353,7 +353,8 @@ static void release_inode_number(unsigned int inum)
 	spin_unlock(&proc_inum_lock);
 }
 
-static void *proc_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *proc_follow_link(struct dentry *dentry, struct nameidata *nd,
+			      struct cred *cred)
 {
 	nd_set_link(nd, PDE(dentry->d_inode)->data);
 	return NULL;
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index a1a2fa9..7062644 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -84,7 +84,8 @@ out_de_put:
 	goto out;
 }
 
-static void *proc_net_follow_link(struct dentry *parent, struct nameidata *nd)
+static void *proc_net_follow_link(struct dentry *parent, struct nameidata *nd,
+				  struct cred *cred)
 {
 	struct net *net = current->nsproxy->net_ns;
 	struct dentry *shadow;
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 6a4bfb0..96e2fd8 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1199,7 +1199,7 @@ static loff_t sysfs_dir_lseek(struct file * file, loff_t offset, int origin)
  */
 
 int sysfs_make_shadowed_dir(struct kobject *kobj,
-	void * (*follow_link)(struct dentry *, struct nameidata *))
+			    sysfs_follow_link_t follow_link)
 {
 	struct dentry *dentry;
 	struct inode *inode;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 4ce687f..34e0e08 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -158,7 +158,8 @@ static int sysfs_getlink(struct dentry *dentry, char * path)
 	return error;
 }
 
-static void *sysfs_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *sysfs_follow_link(struct dentry *dentry, struct nameidata *nd,
+			       struct cred *cred)
 {
 	int error = -ENOMEM;
 	unsigned long page = get_zeroed_page(GFP_KERNEL);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2fec09a..9e7ac7c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1151,7 +1151,8 @@ struct inode_operations {
 		       struct inode *, struct dentry *,
 		       struct cred *);
 	int (*readlink) (struct dentry *, char __user *,int);
-	void * (*follow_link) (struct dentry *, struct nameidata *);
+	void * (*follow_link) (struct dentry *, struct nameidata *,
+			       struct cred *);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *, struct cred *);
 	int (*permission) (struct inode *, int, struct nameidata *,
@@ -1767,7 +1768,8 @@ extern const struct file_operations generic_ro_fops;
 extern int vfs_readlink(struct dentry *, char __user *, int, const char *);
 extern int vfs_follow_link(struct nameidata *, const char *);
 extern int page_readlink(struct dentry *, char __user *, int);
-extern void *page_follow_link_light(struct dentry *, struct nameidata *);
+extern void *page_follow_link_light(struct dentry *, struct nameidata *,
+				    struct cred *);
 extern void page_put_link(struct dentry *, struct nameidata *, void *);
 extern int __page_symlink(struct inode *inode, const char *symname, int len,
 		gfp_t gfp_mask);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index be8228e..d84c82b 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -20,6 +20,7 @@ struct module;
 struct nameidata;
 struct dentry;
 struct sysfs_dirent;
+struct cred;
 
 /* FIXME
  * The *owner field is no longer used, but leave around
@@ -138,9 +139,10 @@ void sysfs_remove_file_from_group(struct kobject *kobj,
 
 void sysfs_notify(struct kobject * k, char *dir, char *attr);
 
-
+typedef void *(*sysfs_follow_link_t)(struct dentry *, struct nameidata *,
+				     struct cred *);
 extern int sysfs_make_shadowed_dir(struct kobject *kobj,
-	void * (*follow_link)(struct dentry *, struct nameidata *));
+				   sysfs_follow_link_t follow_link);
 extern struct sysfs_dirent *sysfs_create_shadow_dir(struct kobject *kobj);
 extern void sysfs_remove_shadow_dir(struct sysfs_dirent *shadow_sd);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 432f023..a3c2007 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1912,13 +1912,16 @@ static int shmem_symlink(struct inode *dir, struct dentry *dentry,
 	return 0;
 }
 
-static void *shmem_follow_link_inline(struct dentry *dentry, struct nameidata *nd)
+static void *shmem_follow_link_inline(struct dentry *dentry,
+				      struct nameidata *nd,
+				      struct cred *cred)
 {
 	nd_set_link(nd, (char *)SHMEM_I(dentry->d_inode));
 	return NULL;
 }
 
-static void *shmem_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *shmem_follow_link(struct dentry *dentry, struct nameidata *nd,
+			       struct cred *cred)
 {
 	struct page *page = NULL;
 	int res = shmem_getpage(dentry->d_inode, 0, &page, SGP_READ, NULL);


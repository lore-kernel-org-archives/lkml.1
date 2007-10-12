Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbXJLQHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbXJLQHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759649AbXJLQFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:05:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756644AbXJLQFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:05:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/52] CRED: Prepare TMPFS for cred passing
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:05:45 +0100
Message-ID: <20071012160544.15119.38153.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare TMPFS for cred passing.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/shmem.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e1fa1c3..49a4b40 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1375,7 +1375,7 @@ static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 }
 
 static struct inode *
-shmem_get_inode(struct super_block *sb, int mode, dev_t dev)
+shmem_get_inode(struct super_block *sb, int mode, dev_t dev, struct cred *cred)
 {
 	struct inode *inode;
 	struct shmem_inode_info *info;
@@ -1394,8 +1394,8 @@ shmem_get_inode(struct super_block *sb, int mode, dev_t dev)
 	inode = new_inode(sb);
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->cred->uid;
-		inode->i_gid = current->cred->gid;
+		inode->i_uid = cred->uid;
+		inode->i_gid = cred->gid;
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_mapping->backing_dev_info = &shmem_backing_dev_info;
@@ -1708,7 +1708,8 @@ static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 static int
 shmem_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 {
-	struct inode *inode = shmem_get_inode(dir->i_sb, mode, dev);
+	struct cred *cred = current->cred;
+	struct inode *inode = shmem_get_inode(dir->i_sb, mode, dev, cred);
 	int error = -ENOSPC;
 
 	if (inode) {
@@ -1849,6 +1850,7 @@ static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct
 
 static int shmem_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
 {
+	struct cred *cred = current->cred;
 	int error;
 	int len;
 	struct inode *inode;
@@ -1860,7 +1862,7 @@ static int shmem_symlink(struct inode *dir, struct dentry *dentry, const char *s
 	if (len > PAGE_CACHE_SIZE)
 		return -ENAMETOOLONG;
 
-	inode = shmem_get_inode(dir->i_sb, S_IFLNK|S_IRWXUGO, 0);
+	inode = shmem_get_inode(dir->i_sb, S_IFLNK|S_IRWXUGO, 0, cred);
 	if (!inode)
 		return -ENOSPC;
 
@@ -2209,11 +2211,12 @@ static void shmem_put_super(struct super_block *sb)
 static int shmem_fill_super(struct super_block *sb,
 			    void *data, int silent)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode;
 	struct dentry *root;
 	int mode   = S_IRWXUGO | S_ISVTX;
-	uid_t uid = current->cred->uid;
-	gid_t gid = current->cred->gid;
+	uid_t uid = cred->uid;
+	gid_t gid = cred->gid;
 	int err = -ENOMEM;
 	struct shmem_sb_info *sbinfo;
 	unsigned long blocks = 0;
@@ -2267,7 +2270,7 @@ static int shmem_fill_super(struct super_block *sb,
 	sb->s_flags |= MS_POSIXACL;
 #endif
 
-	inode = shmem_get_inode(sb, S_IFDIR | mode, 0);
+	inode = shmem_get_inode(sb, S_IFDIR | mode, 0, cred);
 	if (!inode)
 		goto failed;
 	inode->i_uid = uid;
@@ -2480,6 +2483,7 @@ module_init(init_tmpfs)
  */
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
 {
+	struct cred *cred = current->cred;
 	int error;
 	struct file *file;
 	struct inode *inode;
@@ -2510,7 +2514,7 @@ struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
 		goto put_dentry;
 
 	error = -ENOSPC;
-	inode = shmem_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
+	inode = shmem_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0, cred);
 	if (!inode)
 		goto close_file;
 


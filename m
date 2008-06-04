Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbYFDFeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbYFDFeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 01:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYFDFed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 01:34:33 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62949 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYFDFeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 01:34:31 -0400
Message-Id: <200806040509.m5459F9E046168@www262.sakura.ne.jp>
Subject: Re: [patch 01/15] security: pass path to inode_create
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, eparis@redhat.com, casey@schaufler-ca.com,
       agruen@suse.de, jjohansen@suse.de, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Jun 2008 14:09:15 +0900
References: <20080529134903.615127628@szeredi.hu> <20080529134958.655985182@szeredi.hu> <1212500618.11369.11.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1212500618.11369.11.camel@moss-spartans.epoch.ncsc.mil>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley wrote:
> This may be moot given the vfs maintainers' objections, but if you were
> to make this change, then logically you'd push the struct path all the
> way down and set it in the avc_audit_data so that it could be used by
> avc_audit() for emitting a pathname in the audit record.  Likewise for
> the other hook changes.

Yes. That's one of improvements made possible by Miklos's patches.

----------
Subject: SELINUX: Set vfsmount field for audit logs.

By applying Miklos's patches which pass "struct vfsmount" to LSM
(posted at http://lkml.org/lkml/2008/5/29/207 ),
SELinux's audit logs can generate absolute pathnames for more operations.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/selinux/hooks.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- vfs.orig/security/selinux/hooks.c
+++ vfs/security/selinux/hooks.c
@@ -1427,10 +1427,11 @@ static int file_has_perm(struct task_str
 }
 
 /* Check whether a task can create a file. */
-static int may_create(struct inode *dir,
+static int may_create(struct path *dir_path,
 		      struct dentry *dentry,
 		      u16 tclass)
 {
+	struct inode *dir = dir_path->dentry->d_inode;
 	struct task_security_struct *tsec;
 	struct inode_security_struct *dsec;
 	struct superblock_security_struct *sbsec;
@@ -1443,6 +1444,7 @@ static int may_create(struct inode *dir,
 	sbsec = dir->i_sb->s_security;
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.mnt = dir_path->mnt;
 	ad.u.fs.path.dentry = dentry;
 
 	rc = avc_has_perm(tsec->sid, dsec->sid, SECCLASS_DIR,
@@ -1485,11 +1487,12 @@ static int may_create_key(u32 ksid,
 #define MAY_RMDIR	2
 
 /* Check whether a task can link, unlink, or rmdir a file/directory. */
-static int may_link(struct inode *dir,
+static int may_link(struct path *dir_path,
 		    struct dentry *dentry,
 		    int kind)
 
 {
+	struct inode *dir = dir_path->dentry->d_inode;
 	struct task_security_struct *tsec;
 	struct inode_security_struct *dsec, *isec;
 	struct avc_audit_data ad;
@@ -1501,6 +1504,7 @@ static int may_link(struct inode *dir,
 	isec = dentry->d_inode->i_security;
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.mnt = dir_path->mnt;
 	ad.u.fs.path.dentry = dentry;
 
 	av = DIR__SEARCH;
@@ -1529,11 +1533,13 @@ static int may_link(struct inode *dir,
 	return rc;
 }
 
-static inline int may_rename(struct inode *old_dir,
+static inline int may_rename(struct path *old_dir_path,
 			     struct dentry *old_dentry,
-			     struct inode *new_dir,
+			     struct path *new_dir_path,
 			     struct dentry *new_dentry)
 {
+	struct inode *old_dir = old_dir_path->dentry->d_inode;
+	struct inode *new_dir = new_dir_path->dentry->d_inode;
 	struct task_security_struct *tsec;
 	struct inode_security_struct *old_dsec, *new_dsec, *old_isec, *new_isec;
 	struct avc_audit_data ad;
@@ -1549,6 +1555,7 @@ static inline int may_rename(struct inod
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
 
+	ad.u.fs.path.mnt = old_dir_path->mnt;
 	ad.u.fs.path.dentry = old_dentry;
 	rc = avc_has_perm(tsec->sid, old_dsec->sid, SECCLASS_DIR,
 			  DIR__REMOVE_NAME | DIR__SEARCH, &ad);
@@ -1565,6 +1572,7 @@ static inline int may_rename(struct inod
 			return rc;
 	}
 
+	ad.u.fs.path.mnt = new_dir_path->mnt;
 	ad.u.fs.path.dentry = new_dentry;
 	av = DIR__ADD_NAME | DIR__SEARCH;
 	if (new_dentry->d_inode)
@@ -2485,7 +2493,7 @@ static int selinux_inode_init_security(s
 static int selinux_inode_create(struct path *dir, struct dentry *dentry,
 				int mask)
 {
-	return may_create(dir->dentry->d_inode, dentry, SECCLASS_FILE);
+	return may_create(dir, dentry, SECCLASS_FILE);
 }
 
 static int selinux_inode_link(struct dentry *old_dentry, struct path *dir,
@@ -2496,7 +2504,7 @@ static int selinux_inode_link(struct den
 	rc = secondary_ops->inode_link(old_dentry, dir, new_dentry);
 	if (rc)
 		return rc;
-	return may_link(dir->dentry->d_inode, old_dentry, MAY_LINK);
+	return may_link(dir, old_dentry, MAY_LINK);
 }
 
 static int selinux_inode_unlink(struct path *dir, struct dentry *dentry)
@@ -2506,24 +2514,24 @@ static int selinux_inode_unlink(struct p
 	rc = secondary_ops->inode_unlink(dir, dentry);
 	if (rc)
 		return rc;
-	return may_link(dir->dentry->d_inode, dentry, MAY_UNLINK);
+	return may_link(dir, dentry, MAY_UNLINK);
 }
 
 static int selinux_inode_symlink(struct path *dir, struct dentry *dentry,
 				 const char *name)
 {
-	return may_create(dir->dentry->d_inode, dentry, SECCLASS_LNK_FILE);
+	return may_create(dir, dentry, SECCLASS_LNK_FILE);
 }
 
 static int selinux_inode_mkdir(struct path *dir, struct dentry *dentry,
 			       int mask)
 {
-	return may_create(dir->dentry->d_inode, dentry, SECCLASS_DIR);
+	return may_create(dir, dentry, SECCLASS_DIR);
 }
 
 static int selinux_inode_rmdir(struct path *dir, struct dentry *dentry)
 {
-	return may_link(dir->dentry->d_inode, dentry, MAY_RMDIR);
+	return may_link(dir, dentry, MAY_RMDIR);
 }
 
 static int selinux_inode_mknod(struct path *dir, struct dentry *dentry,
@@ -2535,15 +2543,15 @@ static int selinux_inode_mknod(struct pa
 	if (rc)
 		return rc;
 
-	return may_create(dir->dentry->d_inode, dentry,
+	return may_create(dir, dentry,
 			  inode_mode_to_security_class(mode));
 }
 
 static int selinux_inode_rename(struct path *old_dir, struct dentry *old_dentry,
 				struct path *new_dir, struct dentry *new_dentry)
 {
-	return may_rename(old_dir->dentry->d_inode, old_dentry,
-			  new_dir->dentry->d_inode, new_dentry);
+	return may_rename(old_dir, old_dentry,
+			  new_dir, new_dentry);
 }
 
 static int selinux_inode_readlink(struct dentry *dentry)
@@ -2658,6 +2666,7 @@ static int selinux_inode_setxattr(struct
 		return -EPERM;
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.mnt = path->mnt;
 	ad.u.fs.path.dentry = dentry;
 
 	rc = avc_has_perm(tsec->sid, isec->sid, isec->sclass,

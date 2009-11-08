Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbZKHH1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbZKHH1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 02:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZKHH1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 02:27:36 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46931 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbZKHH1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 02:27:31 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 09/15] sysfs: Implement sysfs_getattr & sysfs_permission
Date: Sat,  7 Nov 2009 23:27:07 -0800
Message-Id: <1257665233-12468-9-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1pr7tmqb4.fsf@fess.ebiederm.org>
References: <m1pr7tmqb4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

With the implementation of sysfs_getattr and sysfs_permission
sysfs becomes able to lazily propogate inode attribute changes
from the sysfs_dirents to the vfs inodes.   This paves the way
for deleting significant chunks of now unnecessary code.

While doing this we did not reference sysfs_setattr from
sysfs_symlink_inode_operations so I added along with
sysfs_getattr and sysfs_permission.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c     |    2 +
 fs/sysfs/inode.c   |   64 ++++++++++++++++++++++++++++++++++++++-------------
 fs/sysfs/symlink.c |    3 ++
 fs/sysfs/sysfs.h   |    2 +
 4 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index fa37126..25d052a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -800,7 +800,9 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 
 const struct inode_operations sysfs_dir_inode_operations = {
 	.lookup		= sysfs_lookup,
+	.permission	= sysfs_permission,
 	.setattr	= sysfs_setattr,
+	.getattr	= sysfs_getattr,
 	.setxattr	= sysfs_setxattr,
 };
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index fccfb55..2dcafe8 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -37,7 +37,9 @@ static struct backing_dev_info sysfs_backing_dev_info = {
 };
 
 static const struct inode_operations sysfs_inode_operations ={
+	.permission	= sysfs_permission,
 	.setattr	= sysfs_setattr,
+	.getattr	= sysfs_getattr,
 	.setxattr	= sysfs_setxattr,
 };
 
@@ -196,7 +198,6 @@ static inline void set_default_inode_attr(struct inode * inode, mode_t mode)
 
 static inline void set_inode_attr(struct inode * inode, struct iattr * iattr)
 {
-	inode->i_mode = iattr->ia_mode;
 	inode->i_uid = iattr->ia_uid;
 	inode->i_gid = iattr->ia_gid;
 	inode->i_atime = iattr->ia_atime;
@@ -227,38 +228,56 @@ static int sysfs_count_nlink(struct sysfs_dirent *sd)
 	return nr + 2;
 }
 
+static void sysfs_refresh_inode(struct sysfs_dirent *sd, struct inode *inode)
+{
+	struct sysfs_inode_attrs *iattrs = sd->s_iattr;
+
+	inode->i_mode = sd->s_mode;
+	if (iattrs) {
+		/* sysfs_dirent has non-default attributes
+		 * get them from persistent copy in sysfs_dirent
+		 */
+		set_inode_attr(inode, &iattrs->ia_iattr);
+		security_inode_notifysecctx(inode,
+					    iattrs->ia_secdata,
+					    iattrs->ia_secdata_len);
+	}
+
+	if (sysfs_type(sd) == SYSFS_DIR)
+		inode->i_nlink = sysfs_count_nlink(sd);
+}
+
+int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+{
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct inode *inode = dentry->d_inode;
+
+	mutex_lock(&sysfs_mutex);
+	sysfs_refresh_inode(sd, inode);
+	mutex_unlock(&sysfs_mutex);
+
+	generic_fillattr(inode, stat);
+	return 0;
+}
+
 static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
 	struct bin_attribute *bin_attr;
-	struct sysfs_inode_attrs *iattrs;
 
 	inode->i_private = sysfs_get(sd);
 	inode->i_mapping->a_ops = &sysfs_aops;
 	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 	inode->i_op = &sysfs_inode_operations;
-	inode->i_ino = sd->s_ino;
 	lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
 
-	iattrs = sd->s_iattr;
-	if (iattrs) {
-		/* sysfs_dirent has non-default attributes
-		 * get them for the new inode from persistent copy
-		 * in sysfs_dirent
-		 */
-		set_inode_attr(inode, &iattrs->ia_iattr);
-		if (iattrs->ia_secdata)
-			security_inode_notifysecctx(inode,
-						iattrs->ia_secdata,
-						iattrs->ia_secdata_len);
-	} else
-		set_default_inode_attr(inode, sd->s_mode);
+	set_default_inode_attr(inode, sd->s_mode);
+	sysfs_refresh_inode(sd, inode);
 
 	/* initialize inode according to type */
 	switch (sysfs_type(sd)) {
 	case SYSFS_DIR:
 		inode->i_op = &sysfs_dir_inode_operations;
 		inode->i_fop = &sysfs_dir_operations;
-		inode->i_nlink = sysfs_count_nlink(sd);
 		break;
 	case SYSFS_KOBJ_ATTR:
 		inode->i_size = PAGE_SIZE;
@@ -341,3 +360,14 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 	else
 		return -ENOENT;
 }
+
+int sysfs_permission(struct inode *inode, int mask)
+{
+	struct sysfs_dirent *sd = inode->i_private;
+
+	mutex_lock(&sysfs_mutex);
+	sysfs_refresh_inode(sd, inode);
+	mutex_unlock(&sysfs_mutex);
+
+	return generic_permission(inode, mask, NULL);
+}
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 1137418..c5eff49 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -214,6 +214,9 @@ const struct inode_operations sysfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= sysfs_follow_link,
 	.put_link	= sysfs_put_link,
+	.setattr	= sysfs_setattr,
+	.getattr	= sysfs_getattr,
+	.permission	= sysfs_permission,
 };
 
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index a96d967..12ccc07 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -156,7 +156,9 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
 struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
 void sysfs_delete_inode(struct inode *inode);
 int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr);
+int sysfs_permission(struct inode *inode, int mask);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
+int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat);
 int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags);
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
-- 
1.6.5.2.143.g8cc62


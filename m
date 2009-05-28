Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZE1XHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZE1XHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZE1XDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:03:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:32885 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbZE1XCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:02:23 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Thu, 28 May 2009 16:00:54 -0700
Message-Id: <1243551665-23596-13-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0009]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 13/24] sysfs: Implement sysfs_getattr & sysfs_permission
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

With the implementation of sysfs_getattr and sysfs_permission
sysfs becomes able to lazily propogate inode attribute changes
from the sysfs_dirents to the vfs inodes.   This paves the way
for deleting significant chunks of now unnecessary code.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c     |    2 +
 fs/sysfs/inode.c   |   54 ++++++++++++++++++++++++++++++++++++++++-----------
 fs/sysfs/symlink.c |    3 ++
 fs/sysfs/sysfs.h   |    2 +
 4 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index c6472d8..b75c938 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -763,6 +763,8 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 const struct inode_operations sysfs_dir_inode_operations = {
 	.lookup		= sysfs_lookup,
 	.setattr	= sysfs_setattr,
+	.getattr	= sysfs_getattr,
+	.permission	= sysfs_permission,
 };
 
 static void remove_dir(struct sysfs_dirent *dir_sd)
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index dd154cb..1b7ed3c 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -35,6 +35,8 @@ static struct backing_dev_info sysfs_backing_dev_info = {
 
 static const struct inode_operations sysfs_inode_operations ={
 	.setattr	= sysfs_setattr,
+	.getattr	= sysfs_getattr,
+	.permission	= sysfs_permission,
 };
 
 int __init sysfs_inode_init(void)
@@ -123,7 +125,6 @@ static inline void set_default_inode_attr(struct inode * inode, mode_t mode)
 
 static inline void set_inode_attr(struct inode * inode, struct iattr * iattr)
 {
-	inode->i_mode = iattr->ia_mode;
 	inode->i_uid = iattr->ia_uid;
 	inode->i_gid = iattr->ia_gid;
 	inode->i_atime = iattr->ia_atime;
@@ -154,6 +155,33 @@ static int sysfs_count_nlink(struct sysfs_dirent *sd)
 	return nr + 2;
 }
 
+static void sysfs_refresh_inode(struct sysfs_dirent *sd, struct inode *inode)
+{
+	inode->i_mode = sd->s_mode;
+	if (sd->s_iattr) {
+		/* sysfs_dirent has non-default attributes
+		 * get them from persistent copy in sysfs_dirent
+		 */
+		set_inode_attr(inode, sd->s_iattr);
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
@@ -162,25 +190,16 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 	inode->i_mapping->a_ops = &sysfs_aops;
 	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 	inode->i_op = &sysfs_inode_operations;
-	inode->i_ino = sd->s_ino;
 	lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
 
-	if (sd->s_iattr) {
-		/* sysfs_dirent has non-default attributes
-		 * get them for the new inode from persistent copy
-		 * in sysfs_dirent
-		 */
-		set_inode_attr(inode, sd->s_iattr);
-	} else
-		set_default_inode_attr(inode, sd->s_mode);
-
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
@@ -263,3 +282,14 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
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
index 0367ed1..05e4984 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -201,6 +201,9 @@ const struct inode_operations sysfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= sysfs_follow_link,
 	.put_link	= sysfs_put_link,
+	.setattr	= sysfs_setattr,
+	.getattr	= sysfs_getattr,
+	.permission	= sysfs_permission,
 };
 
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 043bb13..f5b53cf 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -148,6 +148,8 @@ struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
 void sysfs_delete_inode(struct inode *inode);
 int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
+int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat);
+int sysfs_permission(struct inode *inode, int mask);
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
 int sysfs_inode_init(void);
 
-- 
1.6.3.1.54.g99dd.dirty


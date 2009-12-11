Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbZLKWZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbZLKWZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762711AbZLKWZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:25:30 -0500
Received: from kroah.org ([198.145.64.141]:32800 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761569AbZLKWZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:07 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/27] sysfs: Fix locking and factor out sysfs_sd_setattr
Date: Fri, 11 Dec 2009 14:24:39 -0800
Message-Id: <1260570289-6997-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Cleanly separate the work that is specific to setting the
attributes of a sysfs_dirent from what is needed to update
the attributes of a vfs inode.

Additionally grab the sysfs_mutex to keep any nasties from
surprising us when updating the sysfs_dirent.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |   51 +++++++++++++++++++++++++++++++--------------------
 fs/sysfs/sysfs.h |    1 +
 2 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 86fb230..76e977c 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -65,30 +65,14 @@ static struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
 	return attrs;
 }
 
-int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
+int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr * iattr)
 {
-	struct inode * inode = dentry->d_inode;
-	struct sysfs_dirent * sd = dentry->d_fsdata;
 	struct sysfs_inode_attrs *sd_attrs;
 	struct iattr *iattrs;
 	unsigned int ia_valid = iattr->ia_valid;
-	int error;
-
-	if (!sd)
-		return -EINVAL;
 
 	sd_attrs = sd->s_iattr;
 
-	error = inode_change_ok(inode, iattr);
-	if (error)
-		return error;
-
-	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
-
-	error = inode_setattr(inode, iattr);
-	if (error)
-		return error;
-
 	if (!sd_attrs) {
 		/* setting attributes for the first time, allocate now */
 		sd_attrs = sysfs_init_inode_attrs(sd);
@@ -111,12 +95,39 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 			iattrs->ia_ctime = iattr->ia_ctime;
 		if (ia_valid & ATTR_MODE) {
 			umode_t mode = iattr->ia_mode;
-
-			if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-				mode &= ~S_ISGID;
 			iattrs->ia_mode = sd->s_mode = mode;
 		}
 	}
+	return 0;
+}
+
+int sysfs_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	struct inode *inode = dentry->d_inode;
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	int error;
+
+	if (!sd)
+		return -EINVAL;
+
+	error = inode_change_ok(inode, iattr);
+	if (error)
+		return error;
+
+	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
+	if (iattr->ia_valid & ATTR_MODE) {
+		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+			iattr->ia_mode &= ~S_ISGID;
+	}
+
+	error = inode_setattr(inode, iattr);
+	if (error)
+		return error;
+
+	mutex_lock(&sysfs_mutex);
+	error = sysfs_sd_setattr(sd, iattr);
+	mutex_unlock(&sysfs_mutex);
+
 	return error;
 }
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index af4c4e7..a96d967 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -155,6 +155,7 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
  */
 struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
 void sysfs_delete_inode(struct inode *inode);
+int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags);
-- 
1.6.5.5


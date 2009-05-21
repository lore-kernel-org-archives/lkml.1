Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbZEUAbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbZEUAbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZEUA2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:28:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37158 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbZEUA2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:28:17 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 10/20] sysfs: Fix locking and factor out sysfs_sd_setattr
Date: Wed, 20 May 2009 17:28:04 -0700
Message-Id: <1242865694-2100-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.1.2.350.g88cc
In-Reply-To: <1242865694-2100-9-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
 <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-2-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-4-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-5-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-6-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-7-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-8-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-9-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Cleanly separate the work that is specific to setting the
attributes of a sysfs_dirent from what is needed to update
the attributes of a vfs inode.

Additionally grab the sysfs_mutex to keep any nasties from
surprising us when updating the sysfs_dirent.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/inode.c |   52 ++++++++++++++++++++++++++++++----------------------
 fs/sysfs/sysfs.h |    1 +
 2 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 5020a1d..dd154cb 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -42,33 +42,12 @@ int __init sysfs_inode_init(void)
 	return bdi_init(&sysfs_backing_dev_info);
 }
 
-int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
+int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr * iattr)
 {
-	struct inode * inode = dentry->d_inode;
-	struct sysfs_dirent * sd = dentry->d_fsdata;
 	struct iattr * sd_iattr;
 	unsigned int ia_valid = iattr->ia_valid;
-	int error;
-
-	if (!sd)
-		return -EINVAL;
 
 	sd_iattr = sd->s_iattr;
-
-	error = inode_change_ok(inode, iattr);
-	if (error)
-		return error;
-
-	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
-	if (iattr->ia_valid & ATTR_MODE) {
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			iattr->ia_mode &= ~S_ISGID;
-	}
-
-	error = inode_setattr(inode, iattr);
-	if (error)
-		return error;
-
 	if (!sd_iattr && (ia_valid & ~ATTR_MODE)) {
 		/* setting attributes for the first time, allocate now */
 		sd_iattr = kzalloc(sizeof(struct iattr), GFP_KERNEL);
@@ -103,6 +82,35 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 		sd_iattr->ia_ctime = iattr->ia_ctime;
 	if (ia_valid & ATTR_MODE)
 		sd_iattr->ia_mode = iattr->ia_mode;
+	return 0;
+}
+
+int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
+{
+	struct inode * inode = dentry->d_inode;
+	struct sysfs_dirent * sd = dentry->d_fsdata;
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
 
 	return error;
 }
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index abf05f4..043bb13 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -146,6 +146,7 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
  */
 struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
 void sysfs_delete_inode(struct inode *inode);
+int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
 int sysfs_inode_init(void);
-- 
1.6.1.2.350.g88cc


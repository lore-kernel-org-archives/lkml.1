Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbZKHHaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbZKHHaO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 02:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbZKHH3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 02:29:44 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55156 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbZKHH12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 02:27:28 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 06/15] sysfs: Fix locking and factor out sysfs_sd_setattr
Date: Sat,  7 Nov 2009 23:27:04 -0800
Message-Id: <1257665233-12468-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1pr7tmqb4.fsf@fess.ebiederm.org>
References: <m1pr7tmqb4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
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
---
 fs/sysfs/inode.c |   52 ++++++++++++++++++++++++++++++++--------------------
 fs/sysfs/sysfs.h |    1 +
 2 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index fed7a74..fccfb55 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -64,30 +64,15 @@ struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
 
 	return attrs;
 }
-int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
+
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
@@ -110,12 +95,39 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
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
1.6.5.2.143.g8cc62


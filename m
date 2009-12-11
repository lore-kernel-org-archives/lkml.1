Return-Path: <linux-kernel-owner+w=401wt.eu-S934217AbZLKWeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934217AbZLKWeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934173AbZLKWdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:33:55 -0500
Received: from kroah.org ([198.145.64.141]:32795 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762701AbZLKWZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:02 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@maxwell.aristanetworks.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/27] sysfs: Update sysfs_setxattr so it updates secdata under the sysfs_mutex
Date: Fri, 11 Dec 2009 14:24:34 -0800
Message-Id: <1260570289-6997-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>

The sysfs_mutex is required to ensure updates are and will remain
atomic with respect to other inode iattr updates, that do not happen
through the filesystem.

Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |   41 +++++++++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index e144351..000bd98 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -123,23 +123,39 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	return error;
 }
 
+static int sysfs_sd_setsecdata(struct sysfs_dirent *sd, void **secdata, u32 *secdata_len)
+{
+	struct sysfs_inode_attrs *iattrs;
+	void *old_secdata;
+	size_t old_secdata_len;
+
+	iattrs = sd->s_iattr;
+	if (!iattrs)
+		iattrs = sysfs_init_inode_attrs(sd);
+	if (!iattrs)
+		return -ENOMEM;
+
+	old_secdata = iattrs->ia_secdata;
+	old_secdata_len = iattrs->ia_secdata_len;
+
+	iattrs->ia_secdata = *secdata;
+	iattrs->ia_secdata_len = *secdata_len;
+
+	*secdata = old_secdata;
+	*secdata_len = old_secdata_len;
+	return 0;
+}
+
 int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags)
 {
 	struct sysfs_dirent *sd = dentry->d_fsdata;
-	struct sysfs_inode_attrs *iattrs;
 	void *secdata;
 	int error;
 	u32 secdata_len = 0;
 
 	if (!sd)
 		return -EINVAL;
-	if (!sd->s_iattr)
-		sd->s_iattr = sysfs_init_inode_attrs(sd);
-	if (!sd->s_iattr)
-		return -ENOMEM;
-
-	iattrs = sd->s_iattr;
 
 	if (!strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN)) {
 		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
@@ -151,12 +167,13 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 						&secdata, &secdata_len);
 		if (error)
 			goto out;
-		if (iattrs->ia_secdata)
-			security_release_secctx(iattrs->ia_secdata,
-						iattrs->ia_secdata_len);
-		iattrs->ia_secdata = secdata;
-		iattrs->ia_secdata_len = secdata_len;
 
+		mutex_lock(&sysfs_mutex);
+		error = sysfs_sd_setsecdata(sd, &secdata, &secdata_len);
+		mutex_unlock(&sysfs_mutex);
+
+		if (secdata)
+			security_release_secctx(secdata, secdata_len);
 	} else
 		return -EINVAL;
 out:
-- 
1.6.5.5


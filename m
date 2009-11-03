Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbZKCL5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbZKCL5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZKCL5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:57:16 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40715 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZKCL5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:57:15 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 01/13] sysfs: Update sysfs_setxattr so it updates secdata under the sysfs_mutex
Date: Tue,  3 Nov 2009 03:56:57 -0800
Message-Id: <1257249429-12384-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m13a4vbz8r.fsf@fess.ebiederm.org>
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

The sysfs_mutex is required to ensure updates are and will remain
atomic with respect to other inode iattr updates, that do not happen
through the filesystem.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/inode.c |   41 +++++++++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index e28cecf..8a08250 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -122,23 +122,39 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
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
@@ -150,12 +166,13 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
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
1.6.5.2.143.g8cc62


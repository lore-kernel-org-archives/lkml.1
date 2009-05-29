Return-Path: <linux-kernel-owner+w=401wt.eu-S1764302AbZE2UXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764302AbZE2UXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763529AbZE2UU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:20:29 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41780 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763408AbZE2UTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:54 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Fri, 29 May 2009 13:19:22 -0700
Message-Id: <1243628376-22905-12-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=2 Fuz1=2 Fuz2=2 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=2 Fuz1=2 Fuz2=2]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 12/26] sysfs: Fix locking and factor out sysfs_sd_setattr
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
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
1.6.3.1.54.g99dd.dirty


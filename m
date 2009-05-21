Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbZEUAcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbZEUAcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756712AbZEUA2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:28:51 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46339 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbZEUA2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:28:18 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 14/20] sysfs: In sysfs_chmod_file lazily propagate the mode change.
Date: Wed, 20 May 2009 17:28:08 -0700
Message-Id: <1242865694-2100-14-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.1.2.350.g88cc
In-Reply-To: <1242865694-2100-13-git-send-email-ebiederm@xmission.com>
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
 <1242865694-2100-10-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-11-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-12-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-13-git-send-email-ebiederm@xmission.com>
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

Now that sysfs_getattr and sysfs_permission refresh the vfs
inode there is no need to immediatly push the mode change
into the vfs cache.  Reducing the amount of work needed and
simplifying the locking.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/file.c |   31 ++++++++-----------------------
 1 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 0786b41..31cfe1d 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -577,38 +577,23 @@ EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
  */
 int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 {
-	struct sysfs_dirent *victim_sd = NULL;
-	struct dentry *victim = NULL;
-	struct inode * inode;
+	struct sysfs_dirent *sd;
 	struct iattr newattrs;
 	int rc;
 
-	rc = -ENOENT;
-	victim_sd = sysfs_get_dirent(kobj->sd, attr->name);
-	if (!victim_sd)
-		goto out;
+	mutex_lock(&sysfs_mutex);
 
-	mutex_lock(&sysfs_rename_mutex);
-	victim = sysfs_get_dentry(victim_sd);
-	mutex_unlock(&sysfs_rename_mutex);
-	if (IS_ERR(victim)) {
-		rc = PTR_ERR(victim);
-		victim = NULL;
+	rc = -ENOENT;
+	sd = sysfs_find_dirent(kobj->sd, attr->name);
+	if (!sd)
 		goto out;
-	}
-
-	inode = victim->d_inode;
 
-	mutex_lock(&inode->i_mutex);
-
-	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
+	newattrs.ia_mode = (mode & S_IALLUGO) | (sd->s_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE;
-	rc = sysfs_setattr(victim, &newattrs);
+	rc = sysfs_sd_setattr(sd, &newattrs);
 
-	mutex_unlock(&inode->i_mutex);
  out:
-	dput(victim);
-	sysfs_put(victim_sd);
+	mutex_unlock(&sysfs_mutex);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(sysfs_chmod_file);
-- 
1.6.1.2.350.g88cc


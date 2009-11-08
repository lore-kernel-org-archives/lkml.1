Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbZKHH3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbZKHH3C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 02:29:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbZKHH1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 02:27:34 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46940 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbZKHH1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 02:27:32 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 10/15] sysfs: In sysfs_chmod_file lazily propagate the mode change.
Date: Sat,  7 Nov 2009 23:27:08 -0800
Message-Id: <1257665233-12468-10-git-send-email-ebiederm@xmission.com>
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

Now that sysfs_getattr and sysfs_permission refresh the vfs
inode there is no need to immediatly push the mode change
into the vfs cache.  Reducing the amount of work needed and
simplifying the locking.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/file.c |   31 ++++++++-----------------------
 1 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index faa1a80..dc30d9e 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -579,38 +579,23 @@ EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
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
1.6.5.2.143.g8cc62


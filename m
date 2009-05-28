Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbZE1XHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbZE1XHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbZE1XDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:03:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:32878 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZE1XCX (ORCPT
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
Date: Thu, 28 May 2009 16:00:55 -0700
Message-Id: <1243551665-23596-14-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 14/24] sysfs: In sysfs_chmod_file lazily propagate the mode change.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sysfs_getattr and sysfs_permission refresh the vfs
inode there is no need to immediatly push the mode change
into the vfs cache.  Reducing the amount of work needed and
simplifying the locking.

Acked-by: Tejun Heo <tj@kernel.org>
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
1.6.3.1.54.g99dd.dirty


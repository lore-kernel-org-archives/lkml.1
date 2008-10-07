Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbYJGK4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbYJGK4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYJGK4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:56:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46200 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbYJGK4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:56:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
	<20081003101331.GH28946@ZenIV.linux.org.uk>
	<20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org>
	<m163o47kc5.fsf_-_@frodo.ebiederm.org>
Date: Tue, 07 Oct 2008 03:49:29 -0700
In-Reply-To: <m163o47kc5.fsf_-_@frodo.ebiederm.org> (Eric W. Biederman's
	message of "Tue, 07 Oct 2008 03:47:38 -0700")
Message-ID: <m11vys7k92.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 1/3] sysfs:  Remove lock ordering violation in sysfs_chmod_file.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is a wee bit subtle but sysfs_get_dentry grabs inode->i_mutex.
of potentially all of the parents of sd.  So I can not hold
the inode mutex of the directory while it is called.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/file.c |   37 ++++++++++++++++---------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 091c0de..8b572b6 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -582,7 +582,6 @@ int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 {
 	struct sysfs_dirent *victim_sd = NULL;
 	struct super_block *sb;
-	struct inode * inode = NULL;
 	struct iattr newattrs;
 	int rc;
 
@@ -591,42 +590,38 @@ int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 	if (!victim_sd)
 		goto out;
 
-	rc = -ENOENT;
-	mutex_lock(&sysfs_mutex);
-	inode = sysfs_get_inode(victim_sd);
-	mutex_unlock(&sysfs_mutex);
-	if (!inode)
- 		goto out;
-
 	mutex_lock(&sysfs_rename_mutex);
 	sysfs_grab_supers();
-	mutex_lock(&inode->i_mutex);
-
-	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
-	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	newattrs.ia_ctime = current_fs_time(inode->i_sb);
-	rc = sysfs_sd_setattr(victim_sd, inode, &newattrs);
-	if (rc)
-		goto out_unlock;
 
 	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
+		struct dentry *	victim;
+		struct inode * inode;
+
 		/* Ignore it when the dentry does not exist on the
 		 * target superblock.
 		 */
-		struct dentry *	victim = sysfs_get_dentry(sb, victim_sd);
+		mutex_lock(&sysfs_mutex);
+		victim = sysfs_get_dentry(sb, victim_sd);
+		mutex_unlock(&sysfs_mutex);
 		if (IS_ERR(victim))
 			continue;
 
-		fsnotify_change(victim, newattrs.ia_valid);
+		inode = victim->d_inode;
+		mutex_lock(&inode->i_mutex);
+		newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
+		newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
+		newattrs.ia_ctime = current_fs_time(inode->i_sb);
+		rc = sysfs_sd_setattr(victim_sd, inode, &newattrs);
+		if (!rc)
+			fsnotify_change(victim, newattrs.ia_valid);
+
+		mutex_unlock(&inode->i_mutex);
 		dput(victim);
 	}
 
- out_unlock:
-	mutex_unlock(&inode->i_mutex);
 	sysfs_release_supers();
 	mutex_unlock(&sysfs_rename_mutex);
  out:
-	iput(inode);
 	sysfs_put(victim_sd);
 	return rc;
 }
-- 
1.5.3.rc6.17.g1911


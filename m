Return-Path: <linux-kernel-owner+w=401wt.eu-S1758315AbYGDBWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315AbYGDBWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 21:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbYGDBVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 21:21:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57929 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbYGDBVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 21:21:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, <netdev@vger.kernel.org>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	<4869D314.5030403@gmail.com> <m1ej6enep7.fsf@frodo.ebiederm.org>
	<486A0751.9080602@gmail.com> <m1wsk5hjm0.fsf@frodo.ebiederm.org>
	<486AF4FA.8020805@gmail.com> <m1ej6d9c2r.fsf@frodo.ebiederm.org>
	<486B060C.7030607@gmail.com> <m14p78s02q.fsf@frodo.ebiederm.org>
	<486C4515.1070007@gmail.com> <m1hcb7o8lv.fsf@frodo.ebiederm.org>
	<486CB051.5000507@fr.ibm.com> <m14p77m9uy.fsf@frodo.ebiederm.org>
	<486CF71F.5090405@gmail.com> <m1y74iiidz.fsf_-_@frodo.ebiederm.org>
	<m1tzf6ihlz.fsf_-_@frodo.ebiederm.org>
	<m1prpuihjb.fsf_-_@frodo.ebiederm.org>
	<m1lk0iihhp.fsf_-_@frodo.ebiederm.org>
	<m1hcb6ihfz.fsf_-_@frodo.ebiederm.org>
	<m1d4luihea.fsf_-_@frodo.ebiederm.org>
	<m18wwiihbn.fsf_-_@frodo.ebiederm.org>
Date: Thu, 03 Jul 2008 18:13:05 -0700
In-Reply-To: <m18wwiihbn.fsf_-_@frodo.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 03 Jul 2008 18:11:40 -0700")
Message-ID: <m14p76ih9a.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 07/15] sysfs: sysfs_chmod_file handle multiple superblocks
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Teach sysfs_chmod_file how to handle multiple sysfs superblocks.
Since we only have one inode per sd the only thing we have to deal
with is multiple dentries for sending fs notifications.  This might
dup the inode notifications oh well.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/file.c |   39 +++++++++++++++++++++++++--------------
 1 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 1304b3a..5955ae9 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -574,8 +574,8 @@ EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
 int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 {
 	struct sysfs_dirent *victim_sd = NULL;
-	struct dentry *victim = NULL;
-	struct inode * inode;
+	struct super_block *sb;
+	struct inode * inode = NULL;
 	struct iattr newattrs;
 	int rc;
 
@@ -584,31 +584,42 @@ int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 	if (!victim_sd)
 		goto out;
 
-	mutex_lock(&sysfs_rename_mutex);
-	victim = sysfs_get_dentry(sysfs_sb, victim_sd);
-	mutex_unlock(&sysfs_rename_mutex);
-	if (IS_ERR(victim)) {
-		rc = PTR_ERR(victim);
-		victim = NULL;
-		goto out;
-	}
-
-	inode = victim->d_inode;
+	rc = -ENOENT;
+	mutex_lock(&sysfs_mutex);
+	inode = sysfs_get_inode(victim_sd);
+	mutex_unlock(&sysfs_mutex);
+	if (!inode)
+ 		goto out;
 
+	mutex_lock(&sysfs_rename_mutex);
+	sysfs_grab_supers();
 	mutex_lock(&inode->i_mutex);
 
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	newattrs.ia_ctime = current_fs_time(inode->i_sb);
 	rc = sysfs_sd_setattr(victim_sd, inode, &newattrs);
+	if (rc)
+		goto out_unlock;
+
+	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
+		/* Ignore it when the dentry does not exist on the
+		 * target superblock.
+		 */
+		struct dentry *	victim = sysfs_get_dentry(sb, victim_sd);
+		if (IS_ERR(victim))
+			continue;
 
-	if (rc == 0) {
 		fsnotify_change(victim, newattrs.ia_valid);
+		dput(victim);
 	}
 
+ out_unlock:
 	mutex_unlock(&inode->i_mutex);
+	sysfs_release_supers();
+	mutex_unlock(&sysfs_rename_mutex);
  out:
-	dput(victim);
+	iput(inode);
 	sysfs_put(victim_sd);
 	return rc;
 }
-- 
1.5.3.rc6.17.g1911


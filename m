Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbZE1XDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbZE1XDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZE1XCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:02:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:32848 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbZE1XCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:02:21 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Thu, 28 May 2009 16:00:45 -0700
Message-Id: <1243551665-23596-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0123]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 04/24] sysfs: Normalize removing sysfs directories.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Individually wrap each call to sysfs_remove_one with sysfs_addrm_start
and sysfs_addrm_finish this prepares for these functions to be removed.

I don't change the logic of which dirents we remove.  I do document
what we are doing and why what we are doing it.

A warning is added if we attempt to remove an non-empty directories
so that users that would prevsiosly have had leaks and other problems
like the scsi layer get a clear warning that there is a problem.

I don't hold sysfs_mutex across the entire operation as that is unneeded
for coherence at the sysfs level and some level of coordination is expected
at the upper layers.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |   62 +++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b95cc07..3e3a87f 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -732,12 +732,28 @@ const struct inode_operations sysfs_dir_inode_operations = {
 	.setattr	= sysfs_setattr,
 };
 
-static void remove_dir(struct sysfs_dirent *sd)
+static void remove_dir(struct sysfs_dirent *dir_sd)
 {
 	struct sysfs_addrm_cxt acxt;
 
-	sysfs_addrm_start(&acxt, sd->s_parent);
-	sysfs_remove_one(&acxt, sd);
+	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
+
+	/* Removing non-empty directories is not valid complain! */
+	if (unlikely(dir_sd->s_dir.children)) {
+		struct sysfs_dirent *sd;
+
+		WARN(1, KERN_WARNING "sysfs: removing non-empty dir: %s\n",
+			dir_sd->s_name);
+
+		mutex_lock(&sysfs_mutex);
+		for (sd = dir_sd->s_dir.children; sd; sd  = sd->s_sibling)
+			printk(KERN_WARNING "%s/%s\n",
+				dir_sd->s_name, sd->s_name);
+		mutex_unlock(&sysfs_mutex);
+	}
+
+	sysfs_addrm_start(&acxt, dir_sd->s_parent);
+	sysfs_remove_one(&acxt, dir_sd);
 	sysfs_addrm_finish(&acxt);
 }
 
@@ -746,27 +762,37 @@ void sysfs_remove_subdir(struct sysfs_dirent *sd)
 	remove_dir(sd);
 }
 
+static struct sysfs_dirent *get_dirent_to_remove(struct sysfs_dirent *dir_sd)
+{
+	struct sysfs_dirent *sd;
+
+	mutex_lock(&sysfs_mutex);
+	for (sd = dir_sd->s_dir.children; sd; sd = sd->s_sibling) {
+		/* Directories might be owned by someone else
+		 * making recursive directory removal unsafe.
+		 */
+		if (sysfs_type(sd) == SYSFS_DIR)
+			continue;
+		break;
+	}
+	sysfs_get(sd);
+	mutex_unlock(&sysfs_mutex);
+
+	return sd;
+}
 
 static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 {
 	struct sysfs_addrm_cxt acxt;
-	struct sysfs_dirent **pos;
-
-	if (!dir_sd)
-		return;
-
-	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
-	sysfs_addrm_start(&acxt, dir_sd);
-	pos = &dir_sd->s_dir.children;
-	while (*pos) {
-		struct sysfs_dirent *sd = *pos;
+	struct sysfs_dirent *sd;
 
-		if (sysfs_type(sd) != SYSFS_DIR)
-			sysfs_remove_one(&acxt, sd);
-		else
-			pos = &(*pos)->s_sibling;
+	/* Remove children that we think are safe */
+	while ((sd = get_dirent_to_remove(dir_sd))) {
+		sysfs_addrm_start(&acxt, sd->s_parent);
+		sysfs_remove_one(&acxt, sd);
+		sysfs_addrm_finish(&acxt);
+		sysfs_put(sd);
 	}
-	sysfs_addrm_finish(&acxt);
 
 	remove_dir(dir_sd);
 }
-- 
1.6.3.1.54.g99dd.dirty


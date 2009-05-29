Return-Path: <linux-kernel-owner+w=401wt.eu-S932220AbZE2U2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbZE2U2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbZE2UVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:21:16 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41814 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763379AbZE2UTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:55 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Fri, 29 May 2009 13:19:29 -0700
Message-Id: <1243628376-22905-19-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=2 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=2]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 19/26] sysfs: Merge sysfs_rename_dir and sysfs_move_dir
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

These two functions do 90% of the same work and it doesn't significantly
obfuscate the function to allow both the parent dir and the name to change
at the same time.  So merge them together to simplify maintenance, and
increase testing.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |   66 +++++++++++++++++++++++--------------------------------
 1 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 73dbc34..64c94ed 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -686,30 +686,42 @@ void sysfs_remove_dir(struct kobject * kobj)
 	__sysfs_remove_dir(sd);
 }
 
-int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
+static int sysfs_mv_dir(struct sysfs_dirent *sd,
+	struct sysfs_dirent *new_parent_sd, const char *new_name)
 {
-	struct sysfs_dirent *sd = kobj->sd;
 	const char *dup_name = NULL;
 	int error;
 
 	mutex_lock(&sysfs_mutex);
 
 	error = 0;
-	if (strcmp(sd->s_name, new_name) == 0)
+	if ((sd->s_parent == new_parent_sd) &&
+	    (strcmp(sd->s_name, new_name) == 0))
 		goto out;	/* nothing to rename */
 
 	error = -EEXIST;
-	if (sysfs_find_dirent(sd->s_parent, new_name))
+	if (sysfs_find_dirent(new_parent_sd, new_name))
 		goto out;
 
 	/* rename sysfs_dirent */
-	error = -ENOMEM;
-	new_name = dup_name = kstrdup(new_name, GFP_KERNEL);
-	if (!new_name)
-		goto out;
+	if (strcmp(sd->s_name, new_name) != 0) {
+		error = -ENOMEM;
+		new_name = dup_name = kstrdup(new_name, GFP_KERNEL);
+		if (!new_name)
+			goto out;
+
+		dup_name = sd->s_name;
+		sd->s_name = new_name;
+	}
 
-	dup_name = sd->s_name;
-	sd->s_name = new_name;
+	/* Remove from old parent's list and insert into new parent's list. */
+	if (sd->s_parent != new_parent_sd) {
+		sysfs_unlink_sibling(sd);
+		sysfs_get(new_parent_sd);
+		sysfs_put(sd->s_parent);
+		sd->s_parent = new_parent_sd;
+		sysfs_link_sibling(sd);
+	}
 
 	error = 0;
  out:
@@ -718,36 +730,14 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 	return error;
 }
 
-int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
+int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 {
-	struct sysfs_dirent *sd = kobj->sd;
-	struct sysfs_dirent *new_parent_sd;
-	int error;
-
-	BUG_ON(!sd->s_parent);
-
-	mutex_lock(&sysfs_mutex);
-	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : &sysfs_root;
-
-	error = 0;
-	if (sd->s_parent == new_parent_sd)
-		goto out;	/* nothing to move */
-
-	error = -EEXIST;
-	if (sysfs_find_dirent(new_parent_sd, sd->s_name))
-		goto out;
-
-	/* Remove from old parent's list and insert into new parent's list. */
-	sysfs_unlink_sibling(sd);
-	sysfs_get(new_parent_sd);
-	sysfs_put(sd->s_parent);
-	sd->s_parent = new_parent_sd;
-	sysfs_link_sibling(sd);
+	return sysfs_mv_dir(kobj->sd, kobj->sd->s_parent, new_name);
+}
 
-	error = 0;
-out:
-	mutex_unlock(&sysfs_mutex);
-	return error;
+int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
+{
+	return sysfs_mv_dir(kobj->sd, new_parent_kobj->sd, kobj->sd->s_name);
 }
 
 /* Relationship between s_mode and the DT_xxx types */
-- 
1.6.3.1.54.g99dd.dirty


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbZEUAcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbZEUAcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbZEUA3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:29:00 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46351 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbZEUA2S (ORCPT
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
Subject: [PATCH 17/20] sysfs: Merge sysfs_rename_dir and sysfs_move_dir
Date: Wed, 20 May 2009 17:28:11 -0700
Message-Id: <1242865694-2100-17-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.1.2.350.g88cc
In-Reply-To: <1242865694-2100-16-git-send-email-ebiederm@xmission.com>
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
 <1242865694-2100-14-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-15-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-16-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

These two functions do 90% of the same work and it doesn't significantly
obfuscate the function to allow both the parent dir and the name to change
at the same time.  So merge them together to simplify maintenance, and
increase testing.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |   66 +++++++++++++++++++++++--------------------------------
 1 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 3289fd8..3ed4489 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -660,30 +660,42 @@ void sysfs_remove_dir(struct kobject * kobj)
 	remove_dir(sd);
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
@@ -692,36 +704,14 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
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
1.6.1.2.350.g88cc


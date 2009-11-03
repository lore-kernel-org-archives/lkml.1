Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbZKCL5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbZKCL5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZKCL5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:57:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40783 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbZKCL5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:57:24 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 13/13] sysfs: Factor out sysfs_rename from sysfs_rename_dir and sysfs_move_dir
Date: Tue,  3 Nov 2009 03:57:09 -0800
Message-Id: <1257249429-12384-13-git-send-email-ebiederm@xmission.com>
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

From: Eric W. Biederman <ebiederm@xmission.com>

These two functions do 90% of the same work and it doesn't significantly
obfuscate the function to allow both the parent dir and the name to change
at the same time.  So merge them together to simplify maintenance, and
increase testing.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c   |   62 +++++++++++++++++++++++++----------------------------
 fs/sysfs/sysfs.h |    3 ++
 2 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 0b60212..e1a86d1 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -760,30 +760,42 @@ void sysfs_remove_dir(struct kobject * kobj)
 	__sysfs_remove_dir(sd);
 }
 
-int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
+int sysfs_rename(struct sysfs_dirent *sd,
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
@@ -792,37 +804,21 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 	return error;
 }
 
+int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
+{
+	return sysfs_rename(kobj->sd, kobj->sd->s_parent, new_name);
+}
+ 
 int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 {
 	struct sysfs_dirent *sd = kobj->sd;
 	struct sysfs_dirent *new_parent_sd;
-	int error;
 
 	BUG_ON(!sd->s_parent);
-
-	mutex_lock(&sysfs_mutex);
-	new_parent_sd = (new_parent_kobj && new_parent_kobj->sd) ?
+	new_parent_sd = new_parent_kobj && new_parent_kobj->sd ?
 		new_parent_kobj->sd : &sysfs_root;
 
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
-
-	error = 0;
-out:
-	mutex_unlock(&sysfs_mutex);
-	return error;
+	return sysfs_rename(sd, new_parent_sd, sd->s_name);
 }
 
 /* Relationship between s_mode and the DT_xxx types */
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 98a15bf..ca52e7b 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -130,6 +130,9 @@ int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			struct sysfs_dirent **p_sd);
 void sysfs_remove_subdir(struct sysfs_dirent *sd);
 
+int sysfs_rename(struct sysfs_dirent *sd,
+	struct sysfs_dirent *new_parent_sd, const char *new_name);
+
 static inline struct sysfs_dirent *__sysfs_get(struct sysfs_dirent *sd)
 {
 	if (sd) {
-- 
1.6.5.2.143.g8cc62


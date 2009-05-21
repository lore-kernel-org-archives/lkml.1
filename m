Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbZEUA3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbZEUA3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbZEUA2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:28:21 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46315 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbZEUA2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:28:16 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 04/20] sysfs: Handle the general case of removing of directories with subdirectories
Date: Wed, 20 May 2009 17:27:58 -0700
Message-Id: <1242865694-2100-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.1.2.350.g88cc
In-Reply-To: <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
 <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-2-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
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

Modify sysfs to properly remove directories containing attributes and
subdirectories.  The code is relatively simple and means we don't have
to worry about what might use this logic.

In a quick survey I have only found /sys/dev/char and /sys/dev/block that are
removing non-enmpty directories today (and they are exclusively filled with symlinks).
So only removing empty directories does not appear to be an option.

I don't hold sysfs_mutex across the entire operation as that is unneeded
for coherence at the sysfs level and some level of coordination is expected
at the upper layers.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |   54 ++++++++++++++++++++++++++----------------------------
 1 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b95cc07..50702b3 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -732,43 +732,41 @@ const struct inode_operations sysfs_dir_inode_operations = {
 	.setattr	= sysfs_setattr,
 };
 
-static void remove_dir(struct sysfs_dirent *sd)
+static struct sysfs_dirent *sysfs_get_one(struct sysfs_dirent *dir_sd)
 {
-	struct sysfs_addrm_cxt acxt;
-
-	sysfs_addrm_start(&acxt, sd->s_parent);
-	sysfs_remove_one(&acxt, sd);
-	sysfs_addrm_finish(&acxt);
-}
-
-void sysfs_remove_subdir(struct sysfs_dirent *sd)
-{
-	remove_dir(sd);
+	struct sysfs_dirent *sd = dir_sd;
+	mutex_lock(&sysfs_mutex);
+	while ((sysfs_type(sd) == SYSFS_DIR) && sd->s_dir.children)
+		sd = sd->s_dir.children;
+	if (sd != dir_sd)
+		sysfs_get(sd);
+	else
+		sd = NULL;
+	mutex_unlock(&sysfs_mutex);
+	return sd;
 }
 
-
-static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
+static void remove_dir(struct sysfs_dirent *dir_sd)
 {
 	struct sysfs_addrm_cxt acxt;
-	struct sysfs_dirent **pos;
-
-	if (!dir_sd)
-		return;
+	struct sysfs_dirent *sd;
 
 	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
-	sysfs_addrm_start(&acxt, dir_sd);
-	pos = &dir_sd->s_dir.children;
-	while (*pos) {
-		struct sysfs_dirent *sd = *pos;
 
-		if (sysfs_type(sd) != SYSFS_DIR)
-			sysfs_remove_one(&acxt, sd);
-		else
-			pos = &(*pos)->s_sibling;
+	while ((sd = sysfs_get_one(dir_sd))) {
+		sysfs_addrm_start(&acxt, sd->s_parent);
+		sysfs_remove_one(&acxt, sd);
+		sysfs_addrm_finish(&acxt);
+		sysfs_put(sd);
 	}
+	sysfs_addrm_start(&acxt, dir_sd->s_parent);
+	sysfs_remove_one(&acxt, dir_sd);
 	sysfs_addrm_finish(&acxt);
+}
 
-	remove_dir(dir_sd);
+void sysfs_remove_subdir(struct sysfs_dirent *sd)
+{
+	remove_dir(sd);
 }
 
 /**
@@ -788,7 +786,7 @@ void sysfs_remove_dir(struct kobject * kobj)
 	kobj->sd = NULL;
 	spin_unlock(&sysfs_assoc_lock);
 
-	__sysfs_remove_dir(sd);
+	remove_dir(sd);
 }
 
 int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
-- 
1.6.1.2.350.g88cc


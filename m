Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbXITIG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbXITIG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbXITIFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:05:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:41897 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbXITIFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=PTFR8naXyIOnrBHem2kU85JFjS/NbWTZx4aidpcHwC7IcnyCs+tUp4Zgo7gahU72A49IuIvPah4bEUQm+UzBysSZoppLGhQzn0AfuojCFKq3FSYKjGMHnJ2o1KuRuFsK1lSX7LpJp8cUXO6JwOS7umWUbZJyHwyxQOXpmbKvyo4=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 03/22] sysfs: make sysfs_new_dirent() normalize @mode and determine file type
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:39 +0900
Message-Id: <1190275539774-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently sysfs_new_dirent() takes @mode and @type.  @mode contains
S_IF* mask which is also duplicately indicated by @type.  This patch
sysfs_new_dirent() determine S_IF* mask and normalize @mode such that
only bits from S_IALLUGO is taken as @mode.

This is to allow later use of unused @mode bits as special flags.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c     |   36 +++++++++++++++++++++++++++++++++++-
 fs/sysfs/file.c    |    2 +-
 fs/sysfs/symlink.c |    2 +-
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index ba631eb..02918d3 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -298,17 +298,51 @@ static struct dentry_operations sysfs_dentry_ops = {
 	.d_iput		= sysfs_d_iput,
 };
 
+/**
+ *	sysfs_new_dirent - allocate and initialize sysfs_dirent
+ *	@name: name for the new sysfs_dirent
+ *	@mode: mask of bits from S_IRWXUGO
+ *	@type: one of SYSFS_{DIR|FILE|BIN|LINK}
+ *
+ *	Allocate and initialize a sysfs_dirent with the specified
+ *	parameters.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	Pointer to the new sysfs_dirent on success, NULL on allocation
+ *	failure.
+ */
 struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 {
 	char *dup_name = NULL;
 	struct sysfs_dirent *sd;
 
+	/* need to copy name? */
 	if (type & SYSFS_COPY_NAME) {
 		name = dup_name = kstrdup(name, GFP_KERNEL);
 		if (!name)
 			return NULL;
 	}
 
+	/* normalize mode */
+	mode &= S_IALLUGO;
+
+	switch (type) {
+	case SYSFS_DIR:
+		mode |= S_IFDIR;
+		break;
+	case SYSFS_KOBJ_ATTR:
+	case SYSFS_KOBJ_BIN_ATTR:
+		mode |= S_IFREG;
+		break;
+	case SYSFS_KOBJ_LINK:
+		mode |= S_IFLNK;
+		break;
+	}
+
+	/* allocate and initialize */
 	sd = kmem_cache_zalloc(sysfs_dir_cachep, GFP_KERNEL);
 	if (!sd)
 		goto err_out1;
@@ -607,7 +641,7 @@ struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 		      const char *name, struct sysfs_dirent **p_sd)
 {
-	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
+	umode_t mode = S_IRWXU | S_IRUGO | S_IXUGO;
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 	int rc;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 5d708ff..8d8e1ee 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -571,7 +571,7 @@ const struct file_operations sysfs_file_operations = {
 int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 		   int type)
 {
-	umode_t mode = (attr->mode & S_IALLUGO) | S_IFREG;
+	umode_t mode = attr->mode & S_IALLUGO;
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 	int rc;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 6b3358e..bf96bcd 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -82,7 +82,7 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 		goto out_put;
 
 	error = -ENOMEM;
-	sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
+	sd = sysfs_new_dirent(name, S_IRWXUGO, SYSFS_KOBJ_LINK);
 	if (!sd)
 		goto out_put;
 
-- 
1.5.0.3



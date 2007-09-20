Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbXITINn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbXITINn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759619AbXITIGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:25 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:33587 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019AbXITIGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=oBJNBb3rvQZyTPk0W/JCxubVIO4byU0b6GM2KeZGM/p+oCdOWH1oBDg8k5/UQrPgHy5EcAIm2Hxcoajn+M+yQkTy10glVWTtu1fGhRQ8DPv3ksKgyDaus3321GSCuHOLOIll0Ey7P1CRwJPT6xIyyi3ibM1UeqX5C+gR0jNYFSI=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 16/22] sysfs: convert group implementation to use sd-based interface
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:41 +0900
Message-Id: <1190275541414-git-send-email-htejun@gmail.com>
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

Reimplement group interface in terms of sd-based interface in
fs/sysfs/kobject.c.

This patch doesn't introduce any behavior change to the original API.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/Makefile  |    3 +-
 fs/sysfs/group.c   |   87 ----------------------------------------------------
 fs/sysfs/kobject.c |   72 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 89 deletions(-)
 delete mode 100644 fs/sysfs/group.c

diff --git a/fs/sysfs/Makefile b/fs/sysfs/Makefile
index f58bce9..b25ed0d 100644
--- a/fs/sysfs/Makefile
+++ b/fs/sysfs/Makefile
@@ -2,5 +2,4 @@
 # Makefile for the sysfs virtual filesystem
 #
 
-obj-y		:= inode.o file.o dir.o symlink.o mount.o bin.o \
-		   group.o kobject.o
+obj-y		:= inode.o file.o dir.o symlink.o mount.o bin.o kobject.o
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
deleted file mode 100644
index bb94f6a..0000000
--- a/fs/sysfs/group.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- * fs/sysfs/group.c - Operations for adding/removing multiple files at once.
- *
- * Copyright (c) 2003 Patrick Mochel
- * Copyright (c) 2003 Open Source Development Lab
- *
- * This file is released undert the GPL v2. 
- *
- */
-
-#include <linux/kobject.h>
-#include <linux/module.h>
-#include <linux/dcache.h>
-#include <linux/namei.h>
-#include <linux/err.h>
-#include "sysfs.h"
-
-
-static void remove_files(struct sysfs_dirent *dir_sd,
-			 const struct attribute_group *grp)
-{
-	struct attribute *const* attr;
-
-	for (attr = grp->attrs; *attr; attr++)
-		sysfs_hash_and_remove(dir_sd, (*attr)->name);
-}
-
-static int create_files(struct sysfs_dirent *dir_sd,
-			const struct attribute_group *grp)
-{
-	struct attribute *const* attr;
-	int error = 0;
-
-	for (attr = grp->attrs; *attr && !error; attr++)
-		error = __sysfs_add_file(dir_sd, *attr, SYSFS_FILE);
-	if (error)
-		remove_files(dir_sd, grp);
-	return error;
-}
-
-
-int sysfs_create_group(struct kobject * kobj,
-		       const struct attribute_group * grp)
-{
-	struct sysfs_dirent *sd;
-	int error;
-
-	BUG_ON(!kobj || !kobj->sd);
-
-	if (grp->name) {
-		sd = sysfs_add_dir(kobj->sd, grp->name, SYSFS_DIR_MODE, kobj);
-		if (IS_ERR(sd))
-			return PTR_ERR(sd);
-	} else
-		sd = kobj->sd;
-	sysfs_get(sd);
-	error = create_files(sd, grp);
-	if (error) {
-		if (grp->name)
-			sysfs_remove(sd);
-	}
-	sysfs_put(sd);
-	return error;
-}
-
-void sysfs_remove_group(struct kobject * kobj, 
-			const struct attribute_group * grp)
-{
-	struct sysfs_dirent *dir_sd = kobj->sd;
-	struct sysfs_dirent *sd;
-
-	if (grp->name) {
-		sd = sysfs_get_dirent(dir_sd, grp->name);
-		BUG_ON(!sd);
-	} else
-		sd = sysfs_get(dir_sd);
-
-	remove_files(sd, grp);
-	if (grp->name)
-		sysfs_remove(sd);
-
-	sysfs_put(sd);
-}
-
-
-EXPORT_SYMBOL_GPL(sysfs_create_group);
-EXPORT_SYMBOL_GPL(sysfs_remove_group);
diff --git a/fs/sysfs/kobject.c b/fs/sysfs/kobject.c
index 7400575..0a0d583 100644
--- a/fs/sysfs/kobject.c
+++ b/fs/sysfs/kobject.c
@@ -413,6 +413,78 @@ void sysfs_remove_link(struct kobject * kobj, const char * name)
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_link);
 
+/*
+ * group interface
+ */
+static void remove_files(struct sysfs_dirent *dir_sd,
+			 const struct attribute_group *grp)
+{
+	struct attribute *const* attr;
+
+	for (attr = grp->attrs; *attr; attr++)
+		sysfs_remove_child(dir_sd, (*attr)->name);
+}
+
+static int create_files(struct kobject *kobj, struct sysfs_dirent *dir_sd,
+			const struct attribute_group *grp)
+{
+	struct attribute *const* attr;
+	struct sysfs_dirent *sd;
+
+	for (attr = grp->attrs; *attr; attr++) {
+		sd = sysfs_add_file(dir_sd, (*attr)->name, (*attr)->mode,
+				    sysfs_attr_fops(kobj), (void *)*attr);
+		if (IS_ERR(sd)) {
+			remove_files(dir_sd, grp);
+			return PTR_ERR(sd);
+		}
+	}
+
+	return 0;
+}
+
+int sysfs_create_group(struct kobject *kobj, const struct attribute_group *grp)
+{
+	struct sysfs_dirent *sd;
+	int error;
+
+	BUG_ON(!kobj || !kobj->sd);
+
+	if (grp->name) {
+		sd = sysfs_add_dir(kobj->sd, grp->name,
+				   SYSFS_DIR_MODE | SYSFS_COPY_NAME, kobj);
+		if (IS_ERR(sd))
+			return PTR_ERR(sd);
+	} else
+		sd = kobj->sd;
+	sysfs_get(sd);
+	error = create_files(kobj, sd, grp);
+	if (error && grp->name)
+		sysfs_remove(sd);
+	sysfs_put(sd);
+	return error;
+}
+EXPORT_SYMBOL_GPL(sysfs_create_group);
+
+void sysfs_remove_group(struct kobject *kobj, const struct attribute_group *grp)
+{
+	struct sysfs_dirent *dir_sd = kobj->sd;
+	struct sysfs_dirent *sd;
+
+	if (grp->name) {
+		sd = sysfs_get_dirent(dir_sd, grp->name);
+		BUG_ON(!sd);
+	} else
+		sd = sysfs_get(dir_sd);
+
+	remove_files(sd, grp);
+	if (grp->name)
+		sysfs_remove(sd);
+
+	sysfs_put(sd);
+}
+EXPORT_SYMBOL_GPL(sysfs_remove_group);
+
 /**
  * sysfs_add_file_to_group - add an attribute file to a pre-existing group.
  * @kobj: object we're acting for.
-- 
1.5.0.3



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0CBX3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:29:23 -0500
Received: from kroah.org ([198.145.64.141]:38507 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab0CBX3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:13 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/62] sysfs: Add sysfs_add/remove_files utility functions
Date: Tue,  2 Mar 2010 15:28:07 -0800
Message-Id: <1267572541-410-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Adding/Removing a whole array of attributes is very common. Add a standard
utility function to do this with a simple function call, instead of
requiring drivers to open code this.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c       |   20 ++++++++++++++++++++
 include/linux/sysfs.h |   14 ++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index dc30d9e..50b725b 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -542,6 +542,18 @@ int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)
 
 }
 
+int sysfs_create_files(struct kobject *kobj, const struct attribute **ptr)
+{
+	int err = 0;
+	int i;
+
+	for (i = 0; ptr[i] && !err; i++)
+		err = sysfs_create_file(kobj, ptr[i]);
+	if (err)
+		while (--i >= 0)
+			sysfs_remove_file(kobj, ptr[i]);
+	return err;
+}
 
 /**
  * sysfs_add_file_to_group - add an attribute file to a pre-existing group.
@@ -614,6 +626,12 @@ void sysfs_remove_file(struct kobject * kobj, const struct attribute * attr)
 	sysfs_hash_and_remove(kobj->sd, attr->name);
 }
 
+void sysfs_remove_files(struct kobject * kobj, const struct attribute **ptr)
+{
+	int i;
+	for (i = 0; ptr[i]; i++)
+		sysfs_remove_file(kobj, ptr[i]);
+}
 
 /**
  * sysfs_remove_file_from_group - remove an attribute file from a group.
@@ -732,3 +750,5 @@ EXPORT_SYMBOL_GPL(sysfs_schedule_callback);
 
 EXPORT_SYMBOL_GPL(sysfs_create_file);
 EXPORT_SYMBOL_GPL(sysfs_remove_file);
+EXPORT_SYMBOL_GPL(sysfs_remove_files);
+EXPORT_SYMBOL_GPL(sysfs_create_files);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index cfa8308..3e85265 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -94,9 +94,12 @@ int __must_check sysfs_move_dir(struct kobject *kobj,
 
 int __must_check sysfs_create_file(struct kobject *kobj,
 				   const struct attribute *attr);
+int __must_check sysfs_create_files(struct kobject *kobj,
+				   const struct attribute **attr);
 int __must_check sysfs_chmod_file(struct kobject *kobj, struct attribute *attr,
 				  mode_t mode);
 void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr);
+void sysfs_remove_files(struct kobject *kobj, const struct attribute **attr);
 
 int __must_check sysfs_create_bin_file(struct kobject *kobj,
 				       const struct bin_attribute *attr);
@@ -164,6 +167,12 @@ static inline int sysfs_create_file(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_create_files(struct kobject *kobj,
+				    const struct attribute **attr)
+{
+	return 0;
+}
+
 static inline int sysfs_chmod_file(struct kobject *kobj,
 				   struct attribute *attr, mode_t mode)
 {
@@ -175,6 +184,11 @@ static inline void sysfs_remove_file(struct kobject *kobj,
 {
 }
 
+static inline void sysfs_remove_files(struct kobject *kobj,
+				     const struct attribute **attr)
+{
+}
+
 static inline int sysfs_create_bin_file(struct kobject *kobj,
 					const struct bin_attribute *attr)
 {
-- 
1.7.0.1


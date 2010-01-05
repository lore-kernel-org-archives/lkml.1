Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557Ab0AELs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab0AELs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877Ab0AELsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:48:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36325 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab0AELsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:48:04 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201001051247.104464547@firstfloor.org>
In-Reply-To: <201001051247.104464547@firstfloor.org>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] [4/12] SYSFS: Add sysfs_add/remove_files utility functions
Message-Id: <20100105114801.7F8B5B17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 12:48:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding/Removing a whole array of attributes is very common. Add a standard
utility function to do this with a simple function call, instead of
requiring drivers to open code this.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/sysfs/file.c       |   20 ++++++++++++++++++++
 include/linux/sysfs.h |   14 ++++++++++++++
 2 files changed, 34 insertions(+)

Index: linux-2.6.33-rc2-ak/fs/sysfs/file.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/fs/sysfs/file.c
+++ linux-2.6.33-rc2-ak/fs/sysfs/file.c
@@ -542,6 +542,18 @@ int sysfs_create_file(struct kobject * k
 
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
@@ -614,6 +626,12 @@ void sysfs_remove_file(struct kobject *
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
@@ -732,3 +750,5 @@ EXPORT_SYMBOL_GPL(sysfs_schedule_callbac
 
 EXPORT_SYMBOL_GPL(sysfs_create_file);
 EXPORT_SYMBOL_GPL(sysfs_remove_file);
+EXPORT_SYMBOL_GPL(sysfs_remove_files);
+EXPORT_SYMBOL_GPL(sysfs_create_files);
Index: linux-2.6.33-rc2-ak/include/linux/sysfs.h
===================================================================
--- linux-2.6.33-rc2-ak.orig/include/linux/sysfs.h
+++ linux-2.6.33-rc2-ak/include/linux/sysfs.h
@@ -94,9 +94,12 @@ int __must_check sysfs_move_dir(struct k
 
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
@@ -164,6 +167,12 @@ static inline int sysfs_create_file(stru
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
@@ -175,6 +184,11 @@ static inline void sysfs_remove_file(str
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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0CBX3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:29:54 -0500
Received: from kroah.org ([198.145.64.141]:38692 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab0CBX3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:46 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Thery <benjamin.thery@bull.net>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 51/62] sysfs: Implement sysfs_rename_link
Date: Tue,  2 Mar 2010 15:28:50 -0800
Message-Id: <1267572541-410-51-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Because of rename ordering problems we occassionally give false
warnings about invalid sysfs operations.  So using sysfs_rename
create a sysfs_rename_link function that doesn't need strange
workarounds.

Cc: Benjamin Thery <benjamin.thery@bull.net>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/symlink.c    |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |    9 +++++++++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index c5eff49..1b9a3a1 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -123,6 +123,44 @@ void sysfs_remove_link(struct kobject * kobj, const char * name)
 	sysfs_hash_and_remove(parent_sd, name);
 }
 
+/**
+ *	sysfs_rename_link - rename symlink in object's directory.
+ *	@kobj:	object we're acting for.
+ *	@targ:	object we're pointing to.
+ *	@old:	previous name of the symlink.
+ *	@new:	new name of the symlink.
+ *
+ *	A helper function for the common rename symlink idiom.
+ */
+int sysfs_rename_link(struct kobject *kobj, struct kobject *targ,
+			const char *old, const char *new)
+{
+	struct sysfs_dirent *parent_sd, *sd = NULL;
+	int result;
+
+	if (!kobj)
+		parent_sd = &sysfs_root;
+	else
+		parent_sd = kobj->sd;
+
+	result = -ENOENT;
+	sd = sysfs_get_dirent(parent_sd, old);
+	if (!sd)
+		goto out;
+
+	result = -EINVAL;
+	if (sysfs_type(sd) != SYSFS_KOBJ_LINK)
+		goto out;
+	if (sd->s_symlink.target_sd->s_dir.kobj != targ)
+		goto out;
+
+	result = sysfs_rename(sd, parent_sd, new);
+
+out:
+	sysfs_put(sd);
+	return result;
+}
+
 static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
 				 struct sysfs_dirent *target_sd, char *path)
 {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 5b8f80f..d77cde6 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -151,6 +151,9 @@ int __must_check sysfs_create_link_nowarn(struct kobject *kobj,
 					  const char *name);
 void sysfs_remove_link(struct kobject *kobj, const char *name);
 
+int sysfs_rename_link(struct kobject *kobj, struct kobject *target,
+			const char *old_name, const char *new_name);
+
 int __must_check sysfs_create_group(struct kobject *kobj,
 				    const struct attribute_group *grp);
 int sysfs_update_group(struct kobject *kobj,
@@ -255,6 +258,12 @@ static inline void sysfs_remove_link(struct kobject *kobj, const char *name)
 {
 }
 
+static inline int sysfs_rename_link(struct kobject *k, struct kobject *t,
+				    const char *old_name, const char *new_name)
+{
+	return 0;
+}
+
 static inline int sysfs_create_group(struct kobject *kobj,
 				     const struct attribute_group *grp)
 {
-- 
1.7.0.1


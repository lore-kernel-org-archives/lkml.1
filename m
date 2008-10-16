Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbYJPR3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbYJPR3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbYJPRPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:15:04 -0400
Received: from kroah.org ([198.145.64.141]:47036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755209AbYJPRPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:15:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 40/46] kobject: Cleanup kobject_rename and !CONFIG_SYSFS
Date: Thu, 16 Oct 2008 10:10:41 -0700
Message-Id: <1224177047-11859-40-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

It finally dawned on me what the clean fix to sysfs_rename_dir
calling kobject_set_name is.  Move the work into kobject_rename
where it belongs.  The callers serialize us anyway so this is
safe.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c        |    6 +-----
 include/linux/sysfs.h |    4 +---
 lib/kobject.c         |   17 +++++++++++++++--
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index c183426..3a05a59 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -829,16 +829,12 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 	if (!new_dentry)
 		goto out_unlock;
 
-	/* rename kobject and sysfs_dirent */
+	/* rename sysfs_dirent */
 	error = -ENOMEM;
 	new_name = dup_name = kstrdup(new_name, GFP_KERNEL);
 	if (!new_name)
 		goto out_unlock;
 
-	error = kobject_set_name(kobj, "%s", new_name);
-	if (error)
-		goto out_unlock;
-
 	dup_name = sd->s_name;
 	sd->s_name = new_name;
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 39924a9..b330e28 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -20,8 +20,6 @@
 struct kobject;
 struct module;
 
-extern int kobject_set_name(struct kobject *kobj, const char *name, ...)
-			    __attribute__((format(printf, 2, 3)));
 /* FIXME
  * The *owner field is no longer used, but leave around
  * until the tree gets cleaned up fully.
@@ -149,7 +147,7 @@ static inline void sysfs_remove_dir(struct kobject *kobj)
 
 static inline int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
 {
-	return kobject_set_name(kobj, "%s", new_name);
+	return 0;
 }
 
 static inline int sysfs_move_dir(struct kobject *kobj,
diff --git a/lib/kobject.c b/lib/kobject.c
index ae6bb90..0487d1f 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -397,6 +397,7 @@ int kobject_rename(struct kobject *kobj, const char *new_name)
 {
 	int error = 0;
 	const char *devpath = NULL;
+	const char *dup_name = NULL, *name;
 	char *devpath_string = NULL;
 	char *envp[2];
 
@@ -420,15 +421,27 @@ int kobject_rename(struct kobject *kobj, const char *new_name)
 	envp[0] = devpath_string;
 	envp[1] = NULL;
 
+	name = dup_name = kstrdup(new_name, GFP_KERNEL);
+	if (!name) {
+		error = -ENOMEM;
+		goto out;
+	}
+
 	error = sysfs_rename_dir(kobj, new_name);
+	if (error)
+		goto out;
+
+	/* Install the new kobject name */
+	dup_name = kobj->name;
+	kobj->name = name;
 
 	/* This function is mostly/only used for network interface.
 	 * Some hotplug package track interfaces by their name and
 	 * therefore want to know when the name is changed by the user. */
-	if (!error)
-		kobject_uevent_env(kobj, KOBJ_MOVE, envp);
+	kobject_uevent_env(kobj, KOBJ_MOVE, envp);
 
 out:
+	kfree(dup_name);
 	kfree(devpath_string);
 	kfree(devpath);
 	kobject_put(kobj);
-- 
1.6.0.2


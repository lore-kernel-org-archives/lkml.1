Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbYFBNry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbYFBNry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761692AbYFBNrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:47:22 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49706 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761660AbYFBNrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:47:21 -0400
Message-Id: <20080602134439.456399756@theryb.frec.bull.fr>
References: <20080602134438.224352910@theryb.frec.bull.fr>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 15:45:48 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Eric Biederman <ebiederm@xmission.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: [PATCH 07/10] sysfs: Implement sysfs_delete_link and
 sysfs_rename_link
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs: Implement sysfs_delete_link and sysfs_rename_link

When removing a symlink sysfs_remove_link does not provide
enough information to figure out which tagged directory the symlink
falls in.  So I need sysfs_delete_link which is passed the target
of the symlink to delete.

Further half the time when we are removing a symlink the code is
actually renaming the symlink but not doing so explicitly because
we don't have a symlink rename method. So I have added sysfs_rename_link
as well.

Both of these functions now have enough information to find a symlink
in a tagged directory.  The only restriction is that they must be called
before the target kobject is renamed or deleted.  If they are called
later I loose track of which tag the target kobject was marked with
and can no longer find the old symlink to remove it.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>
---
 fs/sysfs/symlink.c    |   31 +++++++++++++++++++++++++++++++
 include/linux/sysfs.h |   17 +++++++++++++++++
 2 files changed, 48 insertions(+)

Index: linux-mm/fs/sysfs/symlink.c
===================================================================
--- linux-mm.orig/fs/sysfs/symlink.c
+++ linux-mm/fs/sysfs/symlink.c
@@ -80,6 +80,21 @@ int sysfs_create_link(struct kobject * k
 }
 
 /**
+ *	sysfs_delete_link - remove symlink in object's directory.
+ *	@kobj:	object we're acting for.
+ *	@targ:	object we're pointing to.
+ *	@name:	name of the symlink to remove.
+ *
+ *	Unlike sysfs_remove_link sysfs_delete_link has enough information
+ *	to successfully delete symlinks in tagged directories.
+ */
+void sysfs_delete_link(struct kobject *kobj, struct kobject *targ,
+			const char *name)
+{
+	sysfs_hash_and_remove(targ, kobj->sd, name);
+}
+
+/**
  *	sysfs_remove_link - remove symlink in object's directory.
  *	@kobj:	object we're acting for.
  *	@name:	name of the symlink to remove.
@@ -97,6 +112,22 @@ void sysfs_remove_link(struct kobject * 
 	sysfs_hash_and_remove(kobj, parent_sd, name);
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
+	sysfs_delete_link(kobj, targ, old);
+	return sysfs_create_link(kobj, targ, new);
+}
+
 static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
 				 struct sysfs_dirent *target_sd, char *path)
 {
Index: linux-mm/include/linux/sysfs.h
===================================================================
--- linux-mm.orig/include/linux/sysfs.h
+++ linux-mm/include/linux/sysfs.h
@@ -111,6 +111,12 @@ int __must_check sysfs_create_link(struc
 				   const char *name);
 void sysfs_remove_link(struct kobject *kobj, const char *name);
 
+int sysfs_rename_link(struct kobject *kobj, struct kobject *target,
+			const char *old_name, const char *new_name);
+
+void sysfs_delete_link(struct kobject *dir, struct kobject *targ,
+			const char *name);
+
 int __must_check sysfs_create_group(struct kobject *kobj,
 				    const struct attribute_group *grp);
 int sysfs_update_group(struct kobject *kobj,
@@ -192,6 +198,17 @@ static inline void sysfs_remove_link(str
 {
 }
 
+static inline int sysfs_rename_link(struct kobject *k, struct kobject *t,
+				    const char *old_name, const char *new_name)
+{
+	return 0;
+}
+
+static inline void sysfs_delete_link(struct kobject *k, struct kobject *t,
+				     const char *name)
+{
+}
+
 static inline int sysfs_create_group(struct kobject *kobj,
 				     const struct attribute_group *grp)
 {

-- 

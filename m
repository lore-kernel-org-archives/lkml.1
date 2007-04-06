Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbXDFQwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbXDFQwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933320AbXDFQwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:52:30 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35011 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317AbXDFQw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:52:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH 4/5] sysfs: Implement sysfs_delete_link and sysfs_rename_link
References: <m164898ncw.fsf@ebiederm.dsl.xmission.com>
	<m11wix8n74.fsf@ebiederm.dsl.xmission.com>
	<m1wt0p78k5.fsf_-_@ebiederm.dsl.xmission.com>
	<m1slbd78h3.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 06 Apr 2007 10:51:57 -0600
In-Reply-To: <m1slbd78h3.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 06 Apr 2007 10:50:32 -0600")
Message-ID: <m1odm178eq.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When removing a symlink sysfs_remove_link does not provide enough
information to figure out which shadow directory the symlink falls in.
So I need sysfs_delete_link which is passed the target of the symlink
to delete. 

Further half the time when we are removing a symlink the code is
actually renaming the symlink but not doing so explicitly because we
don't have a symlink rename method.  So I have added sysfs_rename_link
as well.

Both of these functions now have enough information to find a symlink
in a shadow directory.  The only restriction is that they must be
called before the target kobject is renamed or deleted.  If they are
called later I loose track of which tag the target kobject was marked
with and can no longer find the old symlink to remove it.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/symlink.c    |   31 +++++++++++++++++++++++++++++++
 include/linux/sysfs.h |   18 ++++++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 2885ebb..faff190 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -110,6 +110,21 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 
 
 /**
+ *	sysfs_delete_link - remove symlink in object's directory.
+ *	@kobj:	object we're acting for.
+ *	@targ:	object we're pointing to.
+ *	@name:	name of the symlink to remove.
+ *
+ *	Unlike sysfs_remove_link sysfs_delete_link has enough information
+ *	to successfully delete symlinks in shadow directories.
+ */
+void sysfs_delete_link(struct kobject *kobj, struct kobject *targ,
+			const char *name)
+{
+	sysfs_hash_and_remove(targ, kobj->dentry,name);
+}
+
+/**
  *	sysfs_remove_link - remove symlink in object's directory.
  *	@kobj:	object we're acting for.
  *	@name:	name of the symlink to remove.
@@ -120,6 +135,22 @@ void sysfs_remove_link(struct kobject * kobj, const char * name)
 	sysfs_hash_and_remove(kobj, kobj->dentry,name);
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
 static int sysfs_get_target_path(struct kobject * kobj, struct kobject * target,
 				 char *path)
 {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index cda7b81..c29b38d 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -116,6 +116,13 @@ sysfs_create_link(struct kobject * kobj, struct kobject * target, const char * n
 extern void
 sysfs_remove_link(struct kobject *, const char * name);
 
+extern int
+sysfs_rename_link(struct kobject *kobj, struct kobject *target,
+			const char *old_name, const char *new_name);
+
+extern void
+sysfs_delete_link(struct kobject *dir, struct kobject *targ, const char *name);
+
 int __must_check sysfs_create_bin_file(struct kobject *kobj,
 					struct bin_attribute *attr);
 void sysfs_remove_bin_file(struct kobject *kobj, struct bin_attribute *attr);
@@ -191,6 +198,17 @@ static inline void sysfs_remove_link(struct kobject * k, const char * name)
 	;
 }
 
+static inline int
+sysfs_rename_link(struct kobject * k, struct kobject *t,
+			const char *old_name, const char * new_name)
+{
+	return 0;
+}
+
+static inline void
+sysfs_delete_link(struct kobject *k, struct kobject *t, const char *name)
+{
+}
 
 static inline int sysfs_create_bin_file(struct kobject * k, struct bin_attribute * a)
 {
-- 
1.5.0.g53756


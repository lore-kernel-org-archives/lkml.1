Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbYJPR3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbYJPR3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbYJPRPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:15:02 -0400
Received: from kroah.org ([198.145.64.141]:47033 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756495AbYJPRO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 39/46] kobject: Fix kobject_rename and !CONFIG_SYSFS
Date: Thu, 16 Oct 2008 10:10:40 -0700
Message-Id: <1224177047-11859-39-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

When looking at kobject_rename I found two bugs with
that exist when sysfs support is disabled in the kernel.

kobject_rename does not change the name on the kobject when
sysfs support is not compiled in.

kobject_rename without locking attempts to check the
validity of a rename operation, which the kobject layer
simply does not have the infrastructure to do.

This patch documents the previously unstated requirement of
kobject_rename that is the responsibility of the caller to
provide mutual exclusion and to be certain that the new_name
for the kobject is valid.

This patch modifies sysfs_rename_dir in !CONFIG_SYSFS case
to call kobject_set_name to actually change the kobject_name.

This patch removes the bogus and misleading check in kobject_rename
that attempts to see if a rename is valid.  The check is bogus
because we do not have the proper locking.  The check is misleading
because it looks like we can and do perform checking at the kobject
level that we don't.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kobject.txt |    4 ++++
 drivers/base/core.c       |    5 +++++
 include/linux/sysfs.h     |    4 +++-
 lib/kobject.c             |   18 +++++-------------
 4 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index 51a8021..f5d2aad 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -118,6 +118,10 @@ the name of the kobject, call kobject_rename():
 
     int kobject_rename(struct kobject *kobj, const char *new_name);
 
+Note kobject_rename does perform any locking or have a solid notion of
+what names are valid so the provide must provide their own sanity checking
+and serialization.
+
 There is a function called kobject_set_name() but that is legacy cruft and
 is being removed.  If your code needs to call this function, it is
 incorrect and needs to be fixed.
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 9649d1c..8c2cc26 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1327,6 +1327,11 @@ EXPORT_SYMBOL_GPL(device_destroy);
  * device_rename - renames a device
  * @dev: the pointer to the struct device to be renamed
  * @new_name: the new name of the device
+ *
+ * It is the responsibility of the caller to provide mutual
+ * exclusion between two different calls of device_rename
+ * on the same device to ensure that new_name is valid and
+ * won't conflict with other devices.
  */
 int device_rename(struct device *dev, char *new_name)
 {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index b330e28..39924a9 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -20,6 +20,8 @@
 struct kobject;
 struct module;
 
+extern int kobject_set_name(struct kobject *kobj, const char *name, ...)
+			    __attribute__((format(printf, 2, 3)));
 /* FIXME
  * The *owner field is no longer used, but leave around
  * until the tree gets cleaned up fully.
@@ -147,7 +149,7 @@ static inline void sysfs_remove_dir(struct kobject *kobj)
 
 static inline int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
 {
-	return 0;
+	return kobject_set_name(kobj, "%s", new_name);
 }
 
 static inline int sysfs_move_dir(struct kobject *kobj,
diff --git a/lib/kobject.c b/lib/kobject.c
index fbf0ae2..ae6bb90 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -387,6 +387,11 @@ EXPORT_SYMBOL_GPL(kobject_init_and_add);
  * kobject_rename - change the name of an object
  * @kobj: object in question.
  * @new_name: object's new name
+ *
+ * It is the responsibility of the caller to provide mutual
+ * exclusion between two different calls of kobject_rename
+ * on the same kobject and to ensure that new_name is valid and
+ * won't conflict with other kobjects.
  */
 int kobject_rename(struct kobject *kobj, const char *new_name)
 {
@@ -401,19 +406,6 @@ int kobject_rename(struct kobject *kobj, const char *new_name)
 	if (!kobj->parent)
 		return -EINVAL;
 
-	/* see if this name is already in use */
-	if (kobj->kset) {
-		struct kobject *temp_kobj;
-		temp_kobj = kset_find_obj(kobj->kset, new_name);
-		if (temp_kobj) {
-			printk(KERN_WARNING "kobject '%s' cannot be renamed "
-			       "to '%s' as '%s' is already in existence.\n",
-			       kobject_name(kobj), new_name, new_name);
-			kobject_put(temp_kobj);
-			return -EINVAL;
-		}
-	}
-
 	devpath = kobject_get_path(kobj, GFP_KERNEL);
 	if (!devpath) {
 		error = -ENOMEM;
-- 
1.6.0.2


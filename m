Return-Path: <linux-kernel-owner+w=401wt.eu-S932662AbYEMUv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbYEMUv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932269AbYEMUu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:50:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39833 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759389AbYEMUuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:50:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>,
       Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
References: <m163tocw43.fsf_-_@frodo.ebiederm.org>
	<20080512220232.GA16914@kroah.com> <m1prrqbseh.fsf@frodo.ebiederm.org>
	<4829A4BD.3020007@bull.net> <20080513164438.GA31563@kroah.com>
	<m18wyeay1q.fsf_-_@frodo.ebiederm.org>
	<20080513201602.GA31578@kroah.com>
Date: Tue, 13 May 2008 13:45:16 -0700
In-Reply-To: <20080513201602.GA31578@kroah.com> (Greg KH's message of "Tue, 13
	May 2008 13:16:02 -0700")
Message-ID: <m1od7a9bmr.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0471]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] Fix kobject_rename and !CONFIG_SYSFS v3
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

Changelog:
v3:	Documentation typo fixes

v2:	Added a declaration of kboject_set_name to sysfs.h
	so the code actually compiles with !CONFIG_SYSFS.

	Unscrambling the header dependencies so everything looks
	beautiful is a project for another day.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 Documentation/kobject.txt |    4 ++++
 drivers/base/core.c       |    5 +++++
 include/linux/sysfs.h     |    4 +++-
 lib/kobject.c             |   18 +++++-------------
 4 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index bf3256e..79184b4 100644
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
index be288b5..ad68f4c 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1171,6 +1171,11 @@ EXPORT_SYMBOL_GPL(device_destroy);
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
index 7858eac..6e61033 100644
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
@@ -137,7 +139,7 @@ static inline void sysfs_remove_dir(struct kobject *kobj)
 
 static inline int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
 {
-	return 0;
+	return kobject_set_name(kobj, "%s", new_name);
 }
 
 static inline int sysfs_move_dir(struct kobject *kobj,
diff --git a/lib/kobject.c b/lib/kobject.c
index 718e510..c7fb092 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -383,6 +383,11 @@ EXPORT_SYMBOL_GPL(kobject_init_and_add);
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
@@ -397,19 +402,6 @@ int kobject_rename(struct kobject *kobj, const char *new_name)
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
1.5.3.rc6.17.g1911


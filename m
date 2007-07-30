Return-Path: <linux-kernel-owner+w=401wt.eu-S969451AbXG3WO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969451AbXG3WO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969357AbXG3WK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:10:59 -0400
Received: from ns2.suse.de ([195.135.220.15]:53822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969351AbXG3WK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:10:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/11] kobject: update documentation
Date: Mon, 30 Jul 2007 15:09:32 -0700
Message-Id: <11858334123619-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1185833408744-git-send-email-gregkh@suse.de>
References: <20070730220829.GB5263@kroah.com>
 <1185833373286-git-send-email-gregkh@suse.de>
 <11858333772499-git-send-email-gregkh@suse.de>
 <11858333823900-git-send-email-gregkh@suse.de>
 <11858333853388-git-send-email-gregkh@suse.de>
 <11858333892232-git-send-email-gregkh@suse.de>
 <11858333931362-git-send-email-gregkh@suse.de>
 <11858334013561-git-send-email-gregkh@suse.de>
 <11858334042248-git-send-email-gregkh@suse.de>
 <1185833408744-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Update kobject documentation:

- Update structure definitions.
- Remove documentation of removed struct subsystem.

(First shot, uevent_ops probably need some documentation as well.)

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kobject.txt |  178 +++++++++++++++------------------------------
 1 files changed, 59 insertions(+), 119 deletions(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index e448555..8ee49ee 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -27,7 +27,6 @@ in detail, and briefly here:
 - kobjects	a simple object.
 - kset		a set of objects of a certain type.
 - ktype		a set of helpers for objects of a common type. 
-- subsystem	a controlling object for a number of ksets.
 
 
 The kobject infrastructure maintains a close relationship with the
@@ -54,13 +53,15 @@ embedded in larger data structures and replace fields they duplicate.
 1.2 Definition
 
 struct kobject {
+	const char		* k_name;
 	char			name[KOBJ_NAME_LEN];
-	atomic_t		refcount;
+	struct kref		kref;
 	struct list_head	entry;
 	struct kobject		* parent;
 	struct kset		* kset;
 	struct kobj_type	* ktype;
-	struct dentry		* dentry;
+	struct sysfs_dirent	* sd;
+	wait_queue_head_t	poll;
 };
 
 void kobject_init(struct kobject *);
@@ -137,8 +138,7 @@ If a kobject does not have a parent when it is registered, its parent
 becomes its dominant kset. 
 
 If a kobject does not have a parent nor a dominant kset, its directory
-is created at the top-level of the sysfs partition. This should only
-happen for kobjects that are embedded in a struct subsystem. 
+is created at the top-level of the sysfs partition.
 
 
 
@@ -150,10 +150,10 @@ A kset is a set of kobjects that are embedded in the same type.
 
 
 struct kset {
-	struct subsystem	* subsys;
 	struct kobj_type	* ktype;
 	struct list_head	list;
 	struct kobject		kobj;
+	struct kset_uevent_ops	* uevent_ops;
 };
 
 
@@ -169,8 +169,7 @@ struct kobject * kset_find_obj(struct kset *, char *);
 
 
 The type that the kobjects are embedded in is described by the ktype
-pointer. The subsystem that the kobject belongs to is pointed to by the
-subsys pointer. 
+pointer.
 
 A kset contains a kobject itself, meaning that it may be registered in
 the kobject hierarchy and exported via sysfs. More importantly, the
@@ -209,6 +208,58 @@ the hierarchy.
 kset_find_obj() may be used to locate a kobject with a particular
 name. The kobject, if found, is returned. 
 
+There are also some helper functions which names point to the formerly
+existing "struct subsystem", whose functions have been taken over by
+ksets.
+
+
+decl_subsys(name,type,uevent_ops)
+
+Declares a kset named '<name>_subsys' of type <type> with
+uevent_ops <uevent_ops>. For example,
+
+decl_subsys(devices, &ktype_device, &device_uevent_ops);
+
+is equivalent to doing:
+
+struct kset devices_subsys = {
+     .kobj = {
+	   .name = "devices",
+     },
+     .ktype = &ktype_devices,
+     .uevent_ops = &device_uevent_ops,
+};
+
+
+The objects that are registered with a subsystem that use the
+subsystem's default list must have their kset ptr set properly. These
+objects may have embedded kobjects or ksets. The
+following helpers make setting the kset easier:
+
+
+kobj_set_kset_s(obj,subsys)
+
+- Assumes that obj->kobj exists, and is a struct kobject.
+- Sets the kset of that kobject to the kset <subsys>.
+
+
+kset_set_kset_s(obj,subsys)
+
+- Assumes that obj->kset exists, and is a struct kset.
+- Sets the kset of the embedded kobject to the kset <subsys>.
+
+subsys_set_kset(obj,subsys)
+
+- Assumes obj->subsys exists, and is a struct subsystem.
+- Sets obj->subsys.kset.kobj.kset to the subsystem's embedded kset.
+
+void subsystem_init(struct kset *s);
+int subsystem_register(struct kset *s);
+void subsystem_unregister(struct kset *s);
+struct kset *subsys_get(struct kset *s);
+void kset_put(struct kset *s);
+
+These are just wrappers around the respective kset_* functions.
 
 2.3 sysfs
 
@@ -254,114 +305,3 @@ Instances of struct kobj_type are not registered; only referenced by
 the kset. A kobj_type may be referenced by an arbitrary number of
 ksets, as there may be disparate sets of identical objects. 
 
-
-
-4. subsystems
-
-4.1 Description
-
-A subsystem represents a significant entity of code that maintains an
-arbitrary number of sets of objects of various types. Since the number
-of ksets and the type of objects they contain are variable, a
-generic representation of a subsystem is minimal. 
-
-
-struct subsystem {
-	struct kset		kset;
-	struct rw_semaphore	rwsem;
-};
-
-int subsystem_register(struct subsystem *);
-void subsystem_unregister(struct subsystem *);
-
-struct subsystem * subsys_get(struct subsystem * s);
-void subsys_put(struct subsystem * s);
-
-
-A subsystem contains an embedded kset so:
-
-- It can be represented in the object hierarchy via the kset's
-  embedded kobject. 
-
-- It can maintain a default list of objects of one type. 
-
-Additional ksets may attach to the subsystem simply by referencing the
-subsystem before they are registered. (This one-way reference means
-that there is no way to determine the ksets that are attached to the
-subsystem.) 
-
-All ksets that are attached to a subsystem share the subsystem's R/W
-semaphore. 
-
-
-4.2 subsystem Programming Interface.
-
-The subsystem programming interface is simple and does not offer the
-flexibility that the kset and kobject programming interfaces do. They
-may be registered and unregistered, as well as reference counted. Each
-call forwards the calls to their embedded ksets (which forward the
-calls to their embedded kobjects).
-
-
-4.3 Helpers
-
-A number of macros are available to make dealing with subsystems and
-their embedded objects easier. 
-
-
-decl_subsys(name,type)
-
-Declares a subsystem named '<name>_subsys', with an embedded kset of
-type <type>. For example, 
-
-decl_subsys(devices,&ktype_devices);
-
-is equivalent to doing:
-
-struct subsystem device_subsys = {
-       .kset = {
-	     .kobj = {
-		   .name = "devices",
-	     },
-	     .ktype = &ktype_devices,
-	}
-}; 
-
-
-The objects that are registered with a subsystem that use the
-subsystem's default list must have their kset ptr set properly. These
-objects may have embedded kobjects, ksets, or other subsystems. The
-following helpers make setting the kset easier: 
-
-
-kobj_set_kset_s(obj,subsys)
-
-- Assumes that obj->kobj exists, and is a struct kobject. 
-- Sets the kset of that kobject to the subsystem's embedded kset.
-
-
-kset_set_kset_s(obj,subsys)
-
-- Assumes that obj->kset exists, and is a struct kset.
-- Sets the kset of the embedded kobject to the subsystem's 
-  embedded kset. 
-
-subsys_set_kset(obj,subsys)
-
-- Assumes obj->subsys exists, and is a struct subsystem.
-- Sets obj->subsys.kset.kobj.kset to the subsystem's embedded kset.
-
-
-4.4 sysfs
-
-subsystems are represented in sysfs via their embedded kobjects. They
-follow the same rules as previously mentioned with no exceptions. They
-typically receive a top-level directory in sysfs, except when their
-embedded kobject is part of another kset, or the parent of the
-embedded kobject is explicitly set. 
-
-Note that the subsystem's embedded kset must be 'attached' to the
-subsystem itself in order to use its rwsem. This is done after
-kset_add() has been called. (Not before, because kset_add() uses its
-subsystem for a default parent if it doesn't already have one).
-
-- 
1.5.2.2


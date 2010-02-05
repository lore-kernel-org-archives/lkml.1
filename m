Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab0BEGok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 01:44:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab0BEGoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 01:44:39 -0500
Date: Fri, 5 Feb 2010 01:42:56 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org
Message-Id: <20100205064622.4141.72867.sendpatchset@localhost.localdomain>
Subject: [Patch v2] sysfs: add lockdep class support to s_active
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently we met a lockdep warning from sysfs during s2ram or cpu hotplug.
As reported by several people, it is something like:

[ 6967.926563] ACPI: Preparing to enter system sleep state S3
[ 6967.956156] Disabling non-boot CPUs ...
[ 6967.970401]
[ 6967.970408] =============================================
[ 6967.970419] [ INFO: possible recursive locking detected ]
[ 6967.970431] 2.6.33-rc2-git6 #27
[ 6967.970439] ---------------------------------------------
[ 6967.970450] pm-suspend/22147 is trying to acquire lock:
[ 6967.970460]  (s_active){++++.+}, at: [<c10d2941>]
sysfs_hash_and_remove+0x3d/0x4f
[ 6967.970493]
[ 6967.970497] but task is already holding lock:
[ 6967.970506]  (s_active){++++.+}, at: [<c10d4110>]
sysfs_get_active_two+0x16/0x36
[...]

Eric already provides a patch for this[1], but it still can't fix the
problem. Based on his work and Peter's suggestion, I write this patch,
hopefully we can fix the warning completely.

This patch put sysfs s_active into two classes, one is for PM, the other
is for the rest, so lockdep will distinguish them.

1. http://lkml.org/lkml/2010/1/10/282


Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Miles Lane <miles.lane@gmail.com>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 699f371..d7de269 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -354,7 +354,6 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_active, 0);
-	sysfs_dirent_init_lockdep(sd);
 
 	sd->s_name = name;
 	sd->s_mode = mode;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index dc30d9e..97e397a 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -24,6 +24,8 @@
 
 #include "sysfs.h"
 
+static struct lock_class_key sysfs_classes[SYSFS_NR_CLASSES];
+
 /* used in crash dumps to help with debugging */
 static char last_sysfs_file[PATH_MAX];
 void sysfs_printk_last_file(void)
@@ -504,11 +506,16 @@ int sysfs_add_file_mode(struct sysfs_dirent *dir_sd,
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 	int rc;
+	int class;
 
 	sd = sysfs_new_dirent(attr->name, mode, type);
 	if (!sd)
 		return -ENOMEM;
 	sd->s_attr.attr = (void *)attr;
+	class = SYSFS_ATTR_NORMAL;
+	if (sysfs_type(sd) == SYSFS_KOBJ_ATTR)
+		class = sd->s_attr.attr->class;
+	lockdep_set_class_and_name(sd, &sysfs_classes[class], "s_active");
 
 	sysfs_addrm_start(&acxt, dir_sd);
 	rc = sysfs_add_one(&acxt, sd);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index cdd9377..dde4d73 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -88,17 +88,6 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 	return sd->s_flags & SYSFS_TYPE_MASK;
 }
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-#define sysfs_dirent_init_lockdep(sd)				\
-do {								\
-	static struct lock_class_key __key;			\
-								\
-	lockdep_init_map(&sd->dep_map, "s_active", &__key, 0);	\
-} while(0)
-#else
-#define sysfs_dirent_init_lockdep(sd) do {} while(0)
-#endif
-
 /*
  * Context structure to be used while adding/removing nodes.
  */
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index cfa8308..2b91b74 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -20,6 +20,12 @@
 struct kobject;
 struct module;
 
+enum sysfs_attr_lock_class {
+	SYSFS_ATTR_NORMAL,
+	SYSFS_ATTR_PM_CONTROL,
+	SYSFS_NR_CLASSES,
+};
+
 /* FIXME
  * The *owner field is no longer used.
  * x86 tree has been cleaned up. The owner
@@ -29,6 +35,7 @@ struct attribute {
 	const char		*name;
 	struct module		*owner;
 	mode_t			mode;
+	enum sysfs_attr_lock_class	class;
 };
 
 struct attribute_group {
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 46c5a26..67a6fe7 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -54,13 +54,14 @@ extern int hibernation_platform_enter(void);
 extern int pfn_is_nosave(unsigned long);
 
 #define power_attr(_name) \
-static struct kobj_attribute _name##_attr = {	\
-	.attr	= {				\
-		.name = __stringify(_name),	\
-		.mode = 0644,			\
-	},					\
-	.show	= _name##_show,			\
-	.store	= _name##_store,		\
+static struct kobj_attribute _name##_attr = {		\
+	.attr	= {					\
+		.name = __stringify(_name),		\
+		.mode = 0644,				\
+		.class = SYSFS_ATTR_PM_CONTROL,		\
+	},						\
+	.show	= _name##_show,				\
+	.store	= _name##_store,			\
 }
 
 /* Preferred image size in bytes (default 500 MB) */

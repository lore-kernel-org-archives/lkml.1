Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431Ab0A2HE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0A2HE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540Ab0A2HER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:04:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab0A2HEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:04:15 -0500
Date: Fri, 29 Jan 2010 02:02:04 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Miles Lane <miles.lane@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org
Message-Id: <20100129070527.4058.81663.sendpatchset@localhost.localdomain>
In-Reply-To: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
Subject: [Patch 1/2] sysfs: add support for lockdep subclasses to s_active
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>
Date: Fri, 29 Jan 2010 14:03:39 +0800
Subject: [PATCH 1/2] sysfs: add support for lockdep subclasses to s_active

We have apparently valid cases where the code for a sysfs attribute
removes other sysfs attributes.  Without support for subclasses
lockdep flags a possible recursive lock problem as it figures
the first sysfs attribute could be attempting to remove itself.

By adding support for sysfs subclasses we can teach lockdep to
distinguish between different types of sysfs attributes and not
get confused.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/sysfs/dir.c        |   14 ++++++++++++--
 include/linux/sysfs.h |    7 +++++++
 kernel/power/power.h  |   15 ++++++++-------
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 699f371..e0cd4a0 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -95,9 +95,14 @@ static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
  */
 static struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
 {
+	int subclass;
 	if (unlikely(!sd))
 		return NULL;
 
+	subclass = SYSFS_ATTR_NORMAL;
+	if (sysfs_type(sd) == SYSFS_KOBJ_ATTR)
+		subclass = sd->s_attr.attr->subclass;
+
 	while (1) {
 		int v, t;
 
@@ -107,7 +112,7 @@ static struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
 
 		t = atomic_cmpxchg(&sd->s_active, v, v + 1);
 		if (likely(t == v)) {
-			rwsem_acquire_read(&sd->dep_map, 0, 1, _RET_IP_);
+			rwsem_acquire_read(&sd->dep_map, subclass, 1, _RET_IP_);
 			return sd;
 		}
 		if (t < 0)
@@ -192,12 +197,17 @@ void sysfs_put_active_two(struct sysfs_dirent *sd)
 static void sysfs_deactivate(struct sysfs_dirent *sd)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
+	int subclass;
 	int v;
 
 	BUG_ON(sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED));
 	sd->s_sibling = (void *)&wait;
 
-	rwsem_acquire(&sd->dep_map, 0, 0, _RET_IP_);
+	subclass = SYSFS_ATTR_NORMAL;
+	if (sysfs_type(sd) == SYSFS_KOBJ_ATTR)
+		subclass = sd->s_attr.attr->subclass;
+
+	rwsem_acquire(&sd->dep_map, subclass, 0, _RET_IP_);
 	/* atomic_add_return() is a mb(), put_active() will always see
 	 * the updated sd->s_sibling.
 	 */
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index cfa8308..2f50fec 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -20,6 +20,12 @@
 struct kobject;
 struct module;
 
+enum sysfs_attr_lock_class
+{
+	SYSFS_ATTR_NORMAL,
+	SYSFS_ATTR_PM_CONTROL,
+};
+
 /* FIXME
  * The *owner field is no longer used.
  * x86 tree has been cleaned up. The owner
@@ -29,6 +35,7 @@ struct attribute {
 	const char		*name;
 	struct module		*owner;
 	mode_t			mode;
+	enum sysfs_attr_lock_class	subclass;
 };
 
 struct attribute_group {
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 46c5a26..0459f27 100644
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
+		.subclass = SYSFS_ATTR_PM_CONTROL,	\
+	},						\
+	.show	= _name##_show,				\
+	.store	= _name##_store,			\
 }
 
 /* Preferred image size in bytes (default 500 MB) */
-- 
1.5.5.6


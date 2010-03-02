Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0CBXeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:34:36 -0500
Received: from kroah.org ([198.145.64.141]:38659 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab0CBX3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 44/62] sysfs: Use one lockdep class per sysfs attribute.
Date: Tue,  2 Mar 2010 15:28:43 -0800
Message-Id: <1267572541-410-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Acknowledge that the logical sysfs rwsem has one instance per
sysfs attribute with different locking depencencies for different
attributes.

There is a sysfs idiom where writing to one sysfs file causes the
addition or removal of other sysfs files.   Lumping all of the
sysfs attributes together in one lock class causes lockdep to
generate lots of false positives.

This introduces the requirement that non-static sysfs attributes
need to be initialized with sysfs_attr_init or sysfs_bin_attr_init.
Strictly speaking this requirement only exists when lockdep is
enabled, and when lockdep is enabled we get a bit fat warning
if this requirement is not met.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/sysfs.h      |    7 +++++--
 include/linux/sysfs.h |   18 ++++++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 7db6884..37e0e08 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -92,9 +92,12 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define sysfs_dirent_init_lockdep(sd)				\
 do {								\
-	static struct lock_class_key __key;			\
+	struct attribute *attr = sd->s_attr.attr;		\
+	struct lock_class_key *key = attr->key;			\
+	if (!key)						\
+		key = &attr->skey;				\
 								\
-	lockdep_init_map(&sd->dep_map, "s_active", &__key, 0);	\
+	lockdep_init_map(&sd->dep_map, "s_active", key, 0);	\
 } while(0)
 #else
 #define sysfs_dirent_init_lockdep(sd) do {} while(0)
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 3e85265..006c359 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -15,6 +15,7 @@
 #include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/list.h>
+#include <linux/lockdep.h>
 #include <asm/atomic.h>
 
 struct kobject;
@@ -29,8 +30,23 @@ struct attribute {
 	const char		*name;
 	struct module		*owner;
 	mode_t			mode;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key	*key;
+	struct lock_class_key	skey;
+#endif
 };
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#define sysfs_attr_init(attr)				\
+do {							\
+	static struct lock_class_key __key;		\
+							\
+	(attr)->key = &__key;				\
+} while(0)
+#else
+#define sysfs_attr_init(attr) do {} while(0)
+#endif
+
 struct attribute_group {
 	const char		*name;
 	mode_t			(*is_visible)(struct kobject *,
@@ -74,6 +90,8 @@ struct bin_attribute {
 		    struct vm_area_struct *vma);
 };
 
+#define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&bin_attr->attr)
+
 struct sysfs_ops {
 	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
-- 
1.7.0.1


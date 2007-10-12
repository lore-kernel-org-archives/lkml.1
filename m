Return-Path: <linux-kernel-owner+w=401wt.eu-S932838AbXJLWfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbXJLWfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932544AbXJLWT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:49734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419AbXJLWTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:19:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/75] Driver core: exclude kobject_uevent.c for !CONFIG_HOTPLUG
Date: Fri, 12 Oct 2007 15:16:34 -0700
Message-Id: <11922275781508-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227574129-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Move uevent specific logic from the core into kobject_uevent.c, which
does no longer require to link the unused string array if hotplug
is not compiled in.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c     |   18 +++-----------
 include/linux/kobject.h |   10 +++++--
 lib/Makefile            |    3 +-
 lib/kobject_uevent.c    |   57 ++++++++++++++++++++++++++++++++++++----------
 4 files changed, 57 insertions(+), 31 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d487c03..65de221 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -234,13 +234,11 @@ static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
 
 	/* search the kset, the device belongs to */
 	top_kobj = &dev->kobj;
-	if (!top_kobj->kset && top_kobj->parent) {
-		do {
-			top_kobj = top_kobj->parent;
-		} while (!top_kobj->kset && top_kobj->parent);
-	}
+	while (!top_kobj->kset && top_kobj->parent)
+		top_kobj = top_kobj->parent;
 	if (!top_kobj->kset)
 		goto out;
+
 	kset = top_kobj->kset;
 	if (!kset->uevent_ops || !kset->uevent_ops->uevent)
 		goto out;
@@ -270,17 +268,9 @@ out:
 static ssize_t store_uevent(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	size_t len = count;
 	enum kobject_action action;
 
-	if (len && buf[len-1] == '\n')
-		len--;
-
-	for (action = 0; action < KOBJ_MAX; action++) {
-		if (strncmp(kobject_actions[action], buf, len) != 0)
-			continue;
-		if (kobject_actions[action][len] != '\0')
-			continue;
+	if (kobject_action_type(buf, count, &action) == 0) {
 		kobject_uevent(&dev->kobj, action);
 		goto out;
 	}
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 56f5eaf..0777b3f 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -58,9 +58,6 @@ enum kobject_action {
 	KOBJ_MAX
 };
 
-/* The list of strings defining the valid kobject actions as specified above */
-extern const char *kobject_actions[];
-
 struct kobject {
 	const char		* k_name;
 	struct kref		kref;
@@ -241,6 +238,9 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 
 int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
 	__attribute__((format (printf, 2, 3)));
+
+int kobject_action_type(const char *buf, size_t count,
+			enum kobject_action *type);
 #else
 static inline int kobject_uevent(struct kobject *kobj, enum kobject_action action)
 { return 0; }
@@ -251,6 +251,10 @@ static inline int kobject_uevent_env(struct kobject *kobj,
 
 static inline int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
 { return 0; }
+
+static inline int kobject_action_type(const char *buf, size_t count,
+			enum kobject_action *type)
+{ return -EINVAL; }
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/lib/Makefile b/lib/Makefile
index 4f3f3e2..6c4ea33 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -10,7 +10,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
-lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
+lib-y	+= kobject.o kref.o klist.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o
@@ -20,6 +20,7 @@ CFLAGS_kobject.o += -DDEBUG
 CFLAGS_kobject_uevent.o += -DDEBUG
 endif
 
+lib-$(CONFIG_HOTPLUG) += kobject_uevent.o
 obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 5ccda46..a8efb48 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -23,17 +23,6 @@
 #include <net/sock.h>
 
 
-/* the strings here must match the enum in include/linux/kobject.h */
-const char *kobject_actions[] = {
-	"add",
-	"remove",
-	"change",
-	"move",
-	"online",
-	"offline",
-};
-
-#if defined(CONFIG_HOTPLUG)
 u64 uevent_seqnum;
 char uevent_helper[UEVENT_HELPER_PATH_LEN] = CONFIG_UEVENT_HELPER_PATH;
 static DEFINE_SPINLOCK(sequence_lock);
@@ -41,6 +30,50 @@ static DEFINE_SPINLOCK(sequence_lock);
 static struct sock *uevent_sock;
 #endif
 
+/* the strings here must match the enum in include/linux/kobject.h */
+static const char *kobject_actions[] = {
+	[KOBJ_ADD] =		"add",
+	[KOBJ_REMOVE] =		"remove",
+	[KOBJ_CHANGE] =		"change",
+	[KOBJ_MOVE] =		"move",
+	[KOBJ_ONLINE] =		"online",
+	[KOBJ_OFFLINE] =	"offline",
+};
+
+/**
+ * kobject_action_type - translate action string to numeric type
+ *
+ * @buf: buffer containing the action string, newline is ignored
+ * @len: length of buffer
+ * @type: pointer to the location to store the action type
+ *
+ * Returns 0 if the action string was recognized.
+ */
+int kobject_action_type(const char *buf, size_t count,
+			enum kobject_action *type)
+{
+	enum kobject_action action;
+	int ret = -EINVAL;
+
+	if (count && buf[count-1] == '\n')
+		count--;
+
+	if (!count)
+		goto out;
+
+	for (action = 0; action < ARRAY_SIZE(kobject_actions); action++) {
+		if (strncmp(kobject_actions[action], buf, count) != 0)
+			continue;
+		if (kobject_actions[action][count] != '\0')
+			continue;
+		*type = action;
+		ret = 0;
+		break;
+	}
+out:
+	return ret;
+}
+
 /**
  * kobject_uevent_env - send an uevent with environmental data
  *
@@ -270,5 +303,3 @@ static int __init kobject_uevent_init(void)
 
 postcore_initcall(kobject_uevent_init);
 #endif
-
-#endif /* CONFIG_HOTPLUG */
-- 
1.5.3.4


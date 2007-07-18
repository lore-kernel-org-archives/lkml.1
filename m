Return-Path: <linux-kernel-owner+w=401wt.eu-S936418AbXGRX1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936418AbXGRX1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935956AbXGRX0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:26:31 -0400
Received: from mx1.suse.de ([195.135.220.2]:57409 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762662AbXGRX03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:26:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/14] Driver core: accept all valid action-strings in uevent-trigger
Date: Wed, 18 Jul 2007 16:25:38 -0700
Message-Id: <11848011551094-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11848011502972-git-send-email-gregkh@suse.de>
References: <20070718232400.GC4620@kroah.com>
 <11848011502972-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This allows the uevent file to handle any type of uevent action to be
triggered by userspace instead of just the "add" uevent.


Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c     |   23 ++++++++++++++++++++---
 include/linux/kobject.h |   25 +++++++++++++++++--------
 lib/kobject_uevent.c    |   30 ++++++++++--------------------
 3 files changed, 47 insertions(+), 31 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 0455aa7..91a0367 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -24,6 +24,8 @@
 #include "base.h"
 #include "power/power.h"
 
+extern const char *kobject_actions[];
+
 int (*platform_notify)(struct device * dev) = NULL;
 int (*platform_notify_remove)(struct device * dev) = NULL;
 
@@ -303,10 +305,25 @@ out:
 static ssize_t store_uevent(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	if (memcmp(buf, "add", 3) != 0)
-		dev_err(dev, "uevent: unsupported action-string; this will "
-			"be ignored in a future kernel version");
+	size_t len = count;
+	enum kobject_action action;
+
+	if (len && buf[len-1] == '\n')
+		len--;
+
+	for (action = 0; action < KOBJ_MAX; action++) {
+		if (strncmp(kobject_actions[action], buf, len) != 0)
+			continue;
+		if (kobject_actions[action][len] != '\0')
+			continue;
+		kobject_uevent(&dev->kobj, action);
+		goto out;
+	}
+
+	dev_err(dev, "uevent: unsupported action-string; this will "
+		     "be ignored in a future kernel version\n");
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
+out:
 	return count;
 }
 
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 06cbf41..aa2fe22 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -36,15 +36,24 @@ extern char uevent_helper[];
 /* counter to tag the uevent, read only except for the kobject core */
 extern u64 uevent_seqnum;
 
-/* the actions here must match the proper string in lib/kobject_uevent.c */
-typedef int __bitwise kobject_action_t;
+/*
+ * The actions here must match the index to the string array
+ * in lib/kobject_uevent.c
+ *
+ * Do not add new actions here without checking with the driver-core
+ * maintainers. Action strings are not meant to express subsystem
+ * or device specific properties. In most cases you want to send a
+ * kobject_uevent_env(kobj, KOBJ_CHANGE, env) with additional event
+ * specific variables added to the event environment.
+ */
 enum kobject_action {
-	KOBJ_ADD	= (__force kobject_action_t) 0x01,	/* exclusive to core */
-	KOBJ_REMOVE	= (__force kobject_action_t) 0x02,	/* exclusive to core */
-	KOBJ_CHANGE	= (__force kobject_action_t) 0x03,	/* device state change */
-	KOBJ_OFFLINE	= (__force kobject_action_t) 0x04,	/* device offline */
-	KOBJ_ONLINE	= (__force kobject_action_t) 0x05,	/* device online */
-	KOBJ_MOVE	= (__force kobject_action_t) 0x06,	/* device move */
+	KOBJ_ADD,
+	KOBJ_REMOVE,
+	KOBJ_CHANGE,
+	KOBJ_MOVE,
+	KOBJ_ONLINE,
+	KOBJ_OFFLINE,
+	KOBJ_MAX
 };
 
 struct kobject {
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index bd5ecbb..6a80c78 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -33,25 +33,15 @@ static DEFINE_SPINLOCK(sequence_lock);
 static struct sock *uevent_sock;
 #endif
 
-static char *action_to_string(enum kobject_action action)
-{
-	switch (action) {
-	case KOBJ_ADD:
-		return "add";
-	case KOBJ_REMOVE:
-		return "remove";
-	case KOBJ_CHANGE:
-		return "change";
-	case KOBJ_OFFLINE:
-		return "offline";
-	case KOBJ_ONLINE:
-		return "online";
-	case KOBJ_MOVE:
-		return "move";
-	default:
-		return NULL;
-	}
-}
+/* the strings here must match the enum in include/linux/kobject.h */
+const char *kobject_actions[] = {
+	"add",
+	"remove",
+	"change",
+	"move",
+	"online",
+	"offline",
+};
 
 /**
  * kobject_uevent_env - send an uevent with environmental data
@@ -83,7 +73,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 
 	pr_debug("%s\n", __FUNCTION__);
 
-	action_string = action_to_string(action);
+	action_string = kobject_actions[action];
 	if (!action_string) {
 		pr_debug("kobject attempted to send uevent without action_string!\n");
 		return -EINVAL;
-- 
1.5.2.2


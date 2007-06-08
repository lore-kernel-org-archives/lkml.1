Return-Path: <linux-kernel-owner+w=401wt.eu-S970851AbXFHUEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970851AbXFHUEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbXFHUEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:04:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:54240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXFHUEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:04:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/5] Driver core: keep PHYSDEV for old struct class_device
Date: Fri,  8 Jun 2007 13:04:40 -0700
Message-Id: <11813330873231-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <11813330832783-git-send-email-gregkh@suse.de>
References: <20070608200407.GA22825@kroah.com>
 <11813330832783-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Class-devices created by "struct class_device" are going to be replaced
by "struct device". Keep the deprecated PHYSDEV* variables for the already
"deprecated" struct class_device" devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c |   59 +++++++++++++++++--------------------------------
 drivers/base/core.c  |   10 +++++---
 2 files changed, 27 insertions(+), 42 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 20c4ea6..8c506db 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -369,36 +369,6 @@ char *make_class_name(const char *name, struct kobject *kobj)
 	return class_name;
 }
 
-static int deprecated_class_uevent(char **envp, int num_envp, int *cur_index,
-				   char *buffer, int buffer_size,
-				   int *cur_len,
-				   struct class_device *class_dev)
-{
-	struct device *dev = class_dev->dev;
-	char *path;
-
-	if (!dev)
-		return 0;
-
-	/* add device, backing this class device (deprecated) */
-	path = kobject_get_path(&dev->kobj, GFP_KERNEL);
-
-	add_uevent_var(envp, num_envp, cur_index, buffer, buffer_size,
-		       cur_len, "PHYSDEVPATH=%s", path);
-	kfree(path);
-
-	if (dev->bus)
-		add_uevent_var(envp, num_envp, cur_index,
-			       buffer, buffer_size, cur_len,
-			       "PHYSDEVBUS=%s", dev->bus->name);
-
-	if (dev->driver)
-		add_uevent_var(envp, num_envp, cur_index,
-			       buffer, buffer_size, cur_len,
-			       "PHYSDEVDRIVER=%s", dev->driver->name);
-	return 0;
-}
-
 static int make_deprecated_class_device_links(struct class_device *class_dev)
 {
 	char *class_name;
@@ -430,11 +400,6 @@ static void remove_deprecated_class_device_links(struct class_device *class_dev)
 	kfree(class_name);
 }
 #else
-static inline int deprecated_class_uevent(char **envp, int num_envp,
-					  int *cur_index, char *buffer,
-					  int buffer_size, int *cur_len,
-					  struct class_device *class_dev)
-{ return 0; }
 static inline int make_deprecated_class_device_links(struct class_device *cd)
 { return 0; }
 static void remove_deprecated_class_device_links(struct class_device *cd)
@@ -445,15 +410,13 @@ static int class_uevent(struct kset *kset, struct kobject *kobj, char **envp,
 			 int num_envp, char *buffer, int buffer_size)
 {
 	struct class_device *class_dev = to_class_dev(kobj);
+	struct device *dev = class_dev->dev;
 	int i = 0;
 	int length = 0;
 	int retval = 0;
 
 	pr_debug("%s - name = %s\n", __FUNCTION__, class_dev->class_id);
 
-	deprecated_class_uevent(envp, num_envp, &i, buffer, buffer_size,
-				&length, class_dev);
-
 	if (MAJOR(class_dev->devt)) {
 		add_uevent_var(envp, num_envp, &i,
 			       buffer, buffer_size, &length,
@@ -464,6 +427,26 @@ static int class_uevent(struct kset *kset, struct kobject *kobj, char **envp,
 			       "MINOR=%u", MINOR(class_dev->devt));
 	}
 
+	if (dev) {
+		const char *path = kobject_get_path(&dev->kobj, GFP_KERNEL);
+		if (path) {
+			add_uevent_var(envp, num_envp, &i,
+				       buffer, buffer_size, &length,
+				       "PHYSDEVPATH=%s", path);
+			kfree(path);
+		}
+
+		if (dev->bus)
+			add_uevent_var(envp, num_envp, &i,
+				       buffer, buffer_size, &length,
+				       "PHYSDEVBUS=%s", dev->bus->name);
+
+		if (dev->driver)
+			add_uevent_var(envp, num_envp, &i,
+				       buffer, buffer_size, &length,
+				       "PHYSDEVDRIVER=%s", dev->driver->name);
+	}
+
 	/* terminate, set to next free slot, shrink available space */
 	envp[i] = NULL;
 	envp = &envp[i];
diff --git a/drivers/base/core.c b/drivers/base/core.c
index b78fc1e..dd40d78 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -180,10 +180,12 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj, char **envp,
 			const char *path;
 
 			path = kobject_get_path(&parent->kobj, GFP_KERNEL);
-			add_uevent_var(envp, num_envp, &i,
-				       buffer, buffer_size, &length,
-				       "PHYSDEVPATH=%s", path);
-			kfree(path);
+			if (path) {
+				add_uevent_var(envp, num_envp, &i,
+					       buffer, buffer_size, &length,
+					       "PHYSDEVPATH=%s", path);
+				kfree(path);
+			}
 
 			add_uevent_var(envp, num_envp, &i,
 				       buffer, buffer_size, &length,
-- 
1.5.2.1


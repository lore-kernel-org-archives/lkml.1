Return-Path: <linux-kernel-owner+w=401wt.eu-S1422878AbXBHAfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422878AbXBHAfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161502AbXBHAdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:33:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:56437 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965678AbXBHAcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:48 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@novell.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/28] Driver core: add uevent vars for devices of a class
Date: Wed,  7 Feb 2007 16:30:12 -0800
Message-Id: <11708946993815-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946963110-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com> <11708946672133-git-send-email-greg@kroah.com> <1170894670676-git-send-email-greg@kroah.com> <11708946734097-git-send-email-greg@kroah.com> <11708946762594-git-send-email-greg@kroah.com> <11708946802786-git-send-email-greg@kroah.com> <11708946832214-git-send-email-greg@kroah.com> <11708946871208-git-send-email-greg@kroah.com> <1170894
 6903974-git-send-email-greg@kroah.com> <11708946932742-git-send-email-greg@kroah.com> <11708946963110-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@novell.com>

Devices converted from class_device to device should have
the same uevent keys as the original class_device had. We
search up the parents until we find the first bus device and
add the (already deprecated) PHYDEV* values.

Signed-off-by: Kay Sievers <kay.sievers@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |   46 ++++++++++++++++++++++++++++++++++------------
 1 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6fee3e6..7a5336f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -154,25 +154,47 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj, char **envp,
 			       "MINOR=%u", MINOR(dev->devt));
 	}
 
-#ifdef CONFIG_SYSFS_DEPRECATED
-	/* add bus name (same as SUBSYSTEM, deprecated) */
-	if (dev->bus)
-		add_uevent_var(envp, num_envp, &i,
-			       buffer, buffer_size, &length,
-			       "PHYSDEVBUS=%s", dev->bus->name);
-#endif
-
-	/* add driver name (PHYSDEV* values are deprecated)*/
-	if (dev->driver) {
+	if (dev->driver)
 		add_uevent_var(envp, num_envp, &i,
 			       buffer, buffer_size, &length,
 			       "DRIVER=%s", dev->driver->name);
+
 #ifdef CONFIG_SYSFS_DEPRECATED
+	if (dev->class) {
+		struct device *parent = dev->parent;
+
+		/* find first bus device in parent chain */
+		while (parent && !parent->bus)
+			parent = parent->parent;
+		if (parent && parent->bus) {
+			const char *path;
+
+			path = kobject_get_path(&parent->kobj, GFP_KERNEL);
+			add_uevent_var(envp, num_envp, &i,
+				       buffer, buffer_size, &length,
+				       "PHYSDEVPATH=%s", path);
+			kfree(path);
+
+			add_uevent_var(envp, num_envp, &i,
+				       buffer, buffer_size, &length,
+				       "PHYSDEVBUS=%s", parent->bus->name);
+
+			if (parent->driver)
+				add_uevent_var(envp, num_envp, &i,
+					       buffer, buffer_size, &length,
+					       "PHYSDEVDRIVER=%s", parent->driver->name);
+		}
+	} else if (dev->bus) {
 		add_uevent_var(envp, num_envp, &i,
 			       buffer, buffer_size, &length,
-			       "PHYSDEVDRIVER=%s", dev->driver->name);
-#endif
+			       "PHYSDEVBUS=%s", dev->bus->name);
+
+		if (dev->driver)
+			add_uevent_var(envp, num_envp, &i,
+				       buffer, buffer_size, &length,
+				       "PHYSDEVDRIVER=%s", dev->driver->name);
 	}
+#endif
 
 	/* terminate, set to next free slot, shrink available space */
 	envp[i] = NULL;
-- 
1.4.4.4


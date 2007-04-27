Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbXD0TLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbXD0TLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbXD0S5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:57:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029AbXD0S4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:56:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/46] Driver core: add name to device_type
Date: Fri, 27 Apr 2007 11:53:20 -0700
Message-Id: <1177700059319-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777000552084-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

If "name" of a device_type is specified, the uevent will
contain the device_type name in the DEVTYPE variable.
This helps userspace to distingiush between different types
of devices, belonging to the same subsystem.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c    |    5 +++++
 include/linux/device.h |   10 ++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index bb2cc37..bffb69e 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -157,6 +157,11 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj, char **envp,
 			       "MINOR=%u", MINOR(dev->devt));
 	}
 
+	if (dev->type && dev->type->name)
+		add_uevent_var(envp, num_envp, &i,
+			       buffer, buffer_size, &length,
+			       "DEVTYPE=%s", dev->type->name);
+
 	if (dev->driver)
 		add_uevent_var(envp, num_envp, &i,
 			       buffer, buffer_size, &length,
diff --git a/include/linux/device.h b/include/linux/device.h
index 3b64fde..7f63d4d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -331,7 +331,17 @@ extern struct class_device *class_device_create(struct class *cls,
 					__attribute__((format(printf,5,6)));
 extern void class_device_destroy(struct class *cls, dev_t devt);
 
+/*
+ * The type of device, "struct device" is embedded in. A class
+ * or bus can contain devices of different types
+ * like "partitions" and "disks", "mouse" and "event".
+ * This identifies the device type and carries type-specific
+ * information, equivalent to the kobj_type of a kobject.
+ * If "name" is specified, the uevent will contain it in
+ * the DEVTYPE variable.
+ */
 struct device_type {
+	const char *name;
 	struct attribute_group **groups;
 	int (*uevent)(struct device *dev, char **envp, int num_envp,
 		      char *buffer, int buffer_size);
-- 
1.5.1.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbZCYAmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbZCYAmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbZCYAaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:15 -0400
Received: from kroah.org ([198.145.64.141]:54131 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756863AbZCYAaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.miao@marvell.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Ben Dooks <ben-linux@fluff.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/61] platform: introduce module id table for platform devices
Date: Tue, 24 Mar 2009 17:26:38 -0700
Message-Id: <1237940825-22904-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@marvell.com>

Now platform_device is being widely used on SoC processors where the
peripherals are attached to the system bus, which is simple enough.

However, silicon IPs for these SoCs are usually shared heavily across
a family of processors, even products from different companies.  This
makes the original simple driver name based matching insufficient, or
simply not straight-forward.

Introduce a module id table for platform devices, and makes it clear
that a platform driver is able to support some shared IP and handle
slight differences across different platforms (by 'driver_data').
Module alias is handled automatically when a MODULE_DEVICE_TABLE()
is defined.

To not disturb the current platform drivers too much, the matched id
entry is recorded and can be retrieved by platform_get_device_id().

Signed-off-by: Eric Miao <eric.miao@marvell.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |   23 ++++++++++++++++++++++-
 include/linux/mod_devicetable.h |    9 +++++++++
 include/linux/platform_device.h |    6 ++++++
 scripts/mod/file2alias.c        |   12 ++++++++++++
 4 files changed, 49 insertions(+), 1 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 62a8768..ec993aa 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -584,10 +584,25 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct platform_device	*pdev = to_platform_device(dev);
 
-	add_uevent_var(env, "MODALIAS=platform:%s", pdev->name);
+	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
+		(pdev->id_entry) ? pdev->id_entry->name : pdev->name);
 	return 0;
 }
 
+static const struct platform_device_id *platform_match_id(
+			struct platform_device_id *id,
+			struct platform_device *pdev)
+{
+	while (id->name[0]) {
+		if (strcmp(pdev->name, id->name) == 0) {
+			pdev->id_entry = id;
+			return id;
+		}
+		id++;
+	}
+	return NULL;
+}
+
 /**
  * platform_match - bind platform device to platform driver.
  * @dev: device.
@@ -604,7 +619,13 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 static int platform_match(struct device *dev, struct device_driver *drv)
 {
 	struct platform_device *pdev = to_platform_device(dev);
+	struct platform_driver *pdrv = to_platform_driver(drv);
+
+	/* match against the id table first */
+	if (pdrv->id_table)
+		return platform_match_id(pdrv->id_table, pdev) != NULL;
 
+	/* fall-back to driver name match */
 	return (strcmp(pdev->name, drv->name) == 0);
 }
 
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index fde8667..1bf5900 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -454,4 +454,13 @@ struct dmi_system_id {
 
 #define DMI_MATCH(a, b)	{ a, b }
 
+#define PLATFORM_NAME_SIZE	20
+#define PLATFORM_MODULE_PREFIX	"platform:"
+
+struct platform_device_id {
+	char name[PLATFORM_NAME_SIZE];
+	kernel_ulong_t driver_data
+			__attribute__((aligned(sizeof(kernel_ulong_t))));
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 9a34269..76aef7b 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -12,6 +12,7 @@
 #define _PLATFORM_DEVICE_H_
 
 #include <linux/device.h>
+#include <linux/mod_devicetable.h>
 
 struct platform_device {
 	const char	* name;
@@ -19,8 +20,12 @@ struct platform_device {
 	struct device	dev;
 	u32		num_resources;
 	struct resource	* resource;
+
+	struct platform_device_id	*id_entry;
 };
 
+#define platform_get_device_id(pdev)	((pdev)->id_entry)
+
 #define to_platform_device(x) container_of((x), struct platform_device, dev)
 
 extern int platform_device_register(struct platform_device *);
@@ -56,6 +61,7 @@ struct platform_driver {
 	int (*resume_early)(struct platform_device *);
 	int (*resume)(struct platform_device *);
 	struct device_driver driver;
+	struct platform_device_id *id_table;
 };
 
 extern int platform_driver_register(struct platform_driver *);
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 4eea60b..a334428 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -710,6 +710,14 @@ static int do_dmi_entry(const char *filename, struct dmi_system_id *id,
 	strcat(alias, ":");
 	return 1;
 }
+
+static int do_platform_entry(const char *filename,
+			     struct platform_device_id *id, char *alias)
+{
+	sprintf(alias, PLATFORM_MODULE_PREFIX "%s", id->name);
+	return 1;
+}
+
 /* Ignore any prefix, eg. some architectures prepend _ */
 static inline int sym_is(const char *symbol, const char *name)
 {
@@ -849,6 +857,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 		do_table(symval, sym->st_size,
 			 sizeof(struct dmi_system_id), "dmi",
 			 do_dmi_entry, mod);
+	else if (sym_is(symname, "__mod_platform_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct platform_device_id), "platform",
+			 do_platform_entry, mod);
 	free(zeros);
 }
 
-- 
1.6.2


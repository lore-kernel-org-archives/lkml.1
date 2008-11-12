Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbYKLVeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbYKLVeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbYKLVdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:33:11 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:8933 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbYKLVdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:33:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=FOie8Gg7s1JRgHfTYtlq2ZibMCR4Yq+Gtntf+JTFBx5FFJkEN5dGqUpAgwxPhwfc1D
         Y5JL5xUsdlCNhJ1mDhICjgRlj9ojysiVkWjJEeDWEgc75yAZ8ka92QcTZDEBXYS1Yntt
         JbwoGNXRrerP4CcbY1izwz3GIoDKdJlOI2kPI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/6] ide: move sysfs support to ide-sysfs.c
Date: Wed, 12 Nov 2008 22:17:23 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122217.23385.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:
- media_string() -> ide_media_string()

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile    |    2 
 drivers/ide/ide-probe.c |   52 -------------------
 drivers/ide/ide-sysfs.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide.c       |   72 ---------------------------
 include/linux/ide.h     |    4 +
 5 files changed, 132 insertions(+), 123 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -5,7 +5,7 @@
 EXTRA_CFLAGS				+= -Idrivers/ide
 
 ide-core-y += ide.o ide-ioctls.o ide-io.o ide-iops.o ide-lib.o ide-probe.o \
-	      ide-taskfile.o ide-pm.o ide-park.o ide-pio-blacklist.o
+	      ide-taskfile.o ide-pm.o ide-park.o ide-pio-blacklist.o ide-sysfs.o
 
 # core IDE code
 ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1419,58 +1419,6 @@ static void ide_port_cable_detect(ide_hw
 	}
 }
 
-static ssize_t store_delete_devices(struct device *portdev,
-				    struct device_attribute *attr,
-				    const char *buf, size_t n)
-{
-	ide_hwif_t *hwif = dev_get_drvdata(portdev);
-
-	if (strncmp(buf, "1", n))
-		return -EINVAL;
-
-	ide_port_unregister_devices(hwif);
-
-	return n;
-};
-
-static DEVICE_ATTR(delete_devices, S_IWUSR, NULL, store_delete_devices);
-
-static ssize_t store_scan(struct device *portdev,
-			  struct device_attribute *attr,
-			  const char *buf, size_t n)
-{
-	ide_hwif_t *hwif = dev_get_drvdata(portdev);
-
-	if (strncmp(buf, "1", n))
-		return -EINVAL;
-
-	ide_port_unregister_devices(hwif);
-	ide_port_scan(hwif);
-
-	return n;
-};
-
-static DEVICE_ATTR(scan, S_IWUSR, NULL, store_scan);
-
-static struct device_attribute *ide_port_attrs[] = {
-	&dev_attr_delete_devices,
-	&dev_attr_scan,
-	NULL
-};
-
-static int ide_sysfs_register_port(ide_hwif_t *hwif)
-{
-	int i, uninitialized_var(rc);
-
-	for (i = 0; ide_port_attrs[i]; i++) {
-		rc = device_create_file(hwif->portdev, ide_port_attrs[i]);
-		if (rc)
-			break;
-	}
-
-	return rc;
-}
-
 static unsigned int ide_indexes;
 
 /**
Index: b/drivers/ide/ide-sysfs.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-sysfs.c
@@ -0,0 +1,125 @@
+#include <linux/kernel.h>
+#include <linux/ide.h>
+
+char *ide_media_string(ide_drive_t *drive)
+{
+	switch (drive->media) {
+	case ide_disk:
+		return "disk";
+	case ide_cdrom:
+		return "cdrom";
+	case ide_tape:
+		return "tape";
+	case ide_floppy:
+		return "floppy";
+	case ide_optical:
+		return "optical";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static ssize_t media_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	return sprintf(buf, "%s\n", ide_media_string(drive));
+}
+
+static ssize_t drivename_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	return sprintf(buf, "%s\n", drive->name);
+}
+
+static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	return sprintf(buf, "ide:m-%s\n", ide_media_string(drive));
+}
+
+static ssize_t model_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_PROD]);
+}
+
+static ssize_t firmware_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_FW_REV]);
+}
+
+static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_SERNO]);
+}
+
+struct device_attribute ide_dev_attrs[] = {
+	__ATTR_RO(media),
+	__ATTR_RO(drivename),
+	__ATTR_RO(modalias),
+	__ATTR_RO(model),
+	__ATTR_RO(firmware),
+	__ATTR(serial, 0400, serial_show, NULL),
+	__ATTR(unload_heads, 0644, ide_park_show, ide_park_store),
+	__ATTR_NULL
+};
+
+static ssize_t store_delete_devices(struct device *portdev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t n)
+{
+	ide_hwif_t *hwif = dev_get_drvdata(portdev);
+
+	if (strncmp(buf, "1", n))
+		return -EINVAL;
+
+	ide_port_unregister_devices(hwif);
+
+	return n;
+};
+
+static DEVICE_ATTR(delete_devices, S_IWUSR, NULL, store_delete_devices);
+
+static ssize_t store_scan(struct device *portdev,
+			  struct device_attribute *attr,
+			  const char *buf, size_t n)
+{
+	ide_hwif_t *hwif = dev_get_drvdata(portdev);
+
+	if (strncmp(buf, "1", n))
+		return -EINVAL;
+
+	ide_port_unregister_devices(hwif);
+	ide_port_scan(hwif);
+
+	return n;
+};
+
+static DEVICE_ATTR(scan, S_IWUSR, NULL, store_scan);
+
+static struct device_attribute *ide_port_attrs[] = {
+	&dev_attr_delete_devices,
+	&dev_attr_scan,
+	NULL
+};
+
+int ide_sysfs_register_port(ide_hwif_t *hwif)
+{
+	int i, uninitialized_var(rc);
+
+	for (i = 0; ide_port_attrs[i]; i++) {
+		rc = device_create_file(hwif->portdev, ide_port_attrs[i]);
+		if (rc)
+			break;
+	}
+
+	return rc;
+}
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -440,81 +440,13 @@ static int ide_bus_match(struct device *
 	return 1;
 }
 
-static char *media_string(ide_drive_t *drive)
-{
-	switch (drive->media) {
-	case ide_disk:
-		return "disk";
-	case ide_cdrom:
-		return "cdrom";
-	case ide_tape:
-		return "tape";
-	case ide_floppy:
-		return "floppy";
-	case ide_optical:
-		return "optical";
-	default:
-		return "UNKNOWN";
-	}
-}
-
-static ssize_t media_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	ide_drive_t *drive = to_ide_device(dev);
-	return sprintf(buf, "%s\n", media_string(drive));
-}
-
-static ssize_t drivename_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	ide_drive_t *drive = to_ide_device(dev);
-	return sprintf(buf, "%s\n", drive->name);
-}
-
-static ssize_t modalias_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	ide_drive_t *drive = to_ide_device(dev);
-	return sprintf(buf, "ide:m-%s\n", media_string(drive));
-}
-
-static ssize_t model_show(struct device *dev, struct device_attribute *attr,
-			  char *buf)
-{
-	ide_drive_t *drive = to_ide_device(dev);
-	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_PROD]);
-}
-
-static ssize_t firmware_show(struct device *dev, struct device_attribute *attr,
-			     char *buf)
-{
-	ide_drive_t *drive = to_ide_device(dev);
-	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_FW_REV]);
-}
-
-static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
-			   char *buf)
-{
-	ide_drive_t *drive = to_ide_device(dev);
-	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_SERNO]);
-}
-
-static struct device_attribute ide_dev_attrs[] = {
-	__ATTR_RO(media),
-	__ATTR_RO(drivename),
-	__ATTR_RO(modalias),
-	__ATTR_RO(model),
-	__ATTR_RO(firmware),
-	__ATTR(serial, 0400, serial_show, NULL),
-	__ATTR(unload_heads, 0644, ide_park_show, ide_park_store),
-	__ATTR_NULL
-};
-
 static int ide_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	ide_drive_t *drive = to_ide_device(dev);
 
-	add_uevent_var(env, "MEDIA=%s", media_string(drive));
+	add_uevent_var(env, "MEDIA=%s", ide_media_string(drive));
 	add_uevent_var(env, "DRIVENAME=%s", drive->name);
-	add_uevent_var(env, "MODALIAS=ide:m-%s", media_string(drive));
+	add_uevent_var(env, "MODALIAS=ide:m-%s", ide_media_string(drive));
 	return 0;
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1517,6 +1517,7 @@ void ide_unregister_region(struct gendis
 void ide_undecoded_slave(ide_drive_t *);
 
 void ide_port_apply_params(ide_hwif_t *);
+int ide_sysfs_register_port(ide_hwif_t *);
 
 struct ide_host *ide_host_alloc(const struct ide_port_info *, hw_regs_t **);
 void ide_host_free(struct ide_host *);
@@ -1611,6 +1612,9 @@ extern struct mutex ide_cfg_mtx;
 
 #define local_irq_set(flags)	do { local_save_flags((flags)); local_irq_enable_in_hardirq(); } while (0)
 
+char *ide_media_string(ide_drive_t *);
+
+extern struct device_attribute ide_dev_attrs[];
 extern struct bus_type ide_bus_type;
 extern struct class *ide_port_class;
 

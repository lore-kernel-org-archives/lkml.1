Return-Path: <linux-kernel-owner+w=401wt.eu-S932637AbYAYI36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbYAYI36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764043AbYAYIBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763880AbYAYIAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:00:02 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Swen Schillig <swen@vnet.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 147/196] zfcp: Use device_driver default attribute groups.
Date: Thu, 24 Jan 2008 23:32:56 -0800
Message-Id: <1201246425-5058-68-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

CC: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/s390/scsi/zfcp_ccw.c          |   14 ++++----------
 drivers/s390/scsi/zfcp_ext.h          |    3 +--
 drivers/s390/scsi/zfcp_sysfs_driver.c |   27 ++++-----------------------
 3 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_ccw.c b/drivers/s390/scsi/zfcp_ccw.c
index e01cbf1..86c3f65 100644
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -52,6 +52,9 @@ static struct ccw_driver zfcp_ccw_driver = {
 	.set_offline = zfcp_ccw_set_offline,
 	.notify      = zfcp_ccw_notify,
 	.shutdown    = zfcp_ccw_shutdown,
+	.driver = {
+		.groups = zfcp_driver_attr_groups,
+	},
 };
 
 MODULE_DEVICE_TABLE(ccw, zfcp_ccw_device_id);
@@ -251,16 +254,7 @@ zfcp_ccw_notify(struct ccw_device *ccw_device, int event)
 int __init
 zfcp_ccw_register(void)
 {
-	int retval;
-
-	retval = ccw_driver_register(&zfcp_ccw_driver);
-	if (retval)
-		goto out;
-	retval = zfcp_sysfs_driver_create_files(&zfcp_ccw_driver.driver);
-	if (retval)
-		ccw_driver_unregister(&zfcp_ccw_driver);
- out:
-	return retval;
+	return ccw_driver_register(&zfcp_ccw_driver);
 }
 
 /**
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 8534cf0..06b1079 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -27,8 +27,7 @@
 extern struct zfcp_data zfcp_data;
 
 /******************************** SYSFS  *************************************/
-extern int  zfcp_sysfs_driver_create_files(struct device_driver *);
-extern void zfcp_sysfs_driver_remove_files(struct device_driver *);
+extern struct attribute_group *zfcp_driver_attr_groups[];
 extern int  zfcp_sysfs_adapter_create_files(struct device *);
 extern void zfcp_sysfs_adapter_remove_files(struct device *);
 extern int  zfcp_sysfs_port_create_files(struct device *, u32);
diff --git a/drivers/s390/scsi/zfcp_sysfs_driver.c b/drivers/s390/scsi/zfcp_sysfs_driver.c
index 005e62f..651edd5 100644
--- a/drivers/s390/scsi/zfcp_sysfs_driver.c
+++ b/drivers/s390/scsi/zfcp_sysfs_driver.c
@@ -98,28 +98,9 @@ static struct attribute_group zfcp_driver_attr_group = {
 	.attrs = zfcp_driver_attrs,
 };
 
-/**
- * zfcp_sysfs_create_driver_files - create sysfs driver files
- * @dev: pointer to belonging device
- *
- * Create all sysfs attributes of the zfcp device driver
- */
-int
-zfcp_sysfs_driver_create_files(struct device_driver *drv)
-{
-	return sysfs_create_group(&drv->kobj, &zfcp_driver_attr_group);
-}
-
-/**
- * zfcp_sysfs_remove_driver_files - remove sysfs driver files
- * @dev: pointer to belonging device
- *
- * Remove all sysfs attributes of the zfcp device driver
- */
-void
-zfcp_sysfs_driver_remove_files(struct device_driver *drv)
-{
-	sysfs_remove_group(&drv->kobj, &zfcp_driver_attr_group);
-}
+struct attribute_group *zfcp_driver_attr_groups[] = {
+	&zfcp_driver_attr_group,
+	NULL,
+};
 
 #undef ZFCP_LOG_AREA
-- 
1.5.3.8


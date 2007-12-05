Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbXLELvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbXLELvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 06:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbXLELue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 06:50:34 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:52754 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbXLELud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 06:50:33 -0500
Date: Wed, 5 Dec 2007 12:50:31 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [patch 3/3] zfcp: Use device_driver default attribute groups.
Message-ID: <20071205125031.738e0627@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071205114119.905238262@de.ibm.com>
References: <20071205114119.905238262@de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/s390/scsi/zfcp_ccw.c          |   14 ++++----------
 drivers/s390/scsi/zfcp_ext.h          |    3 +--
 drivers/s390/scsi/zfcp_sysfs_driver.c |   27 ++++-----------------------
 3 files changed, 9 insertions(+), 35 deletions(-)

--- linux-2.6.orig/drivers/s390/scsi/zfcp_ccw.c
+++ linux-2.6/drivers/s390/scsi/zfcp_ccw.c
@@ -52,6 +52,9 @@ static struct ccw_driver zfcp_ccw_driver
 	.set_offline = zfcp_ccw_set_offline,
 	.notify      = zfcp_ccw_notify,
 	.shutdown    = zfcp_ccw_shutdown,
+	.driver = {
+		.groups = zfcp_driver_attr_groups,
+	},
 };
 
 MODULE_DEVICE_TABLE(ccw, zfcp_ccw_device_id);
@@ -251,16 +254,7 @@ zfcp_ccw_notify(struct ccw_device *ccw_d
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
--- linux-2.6.orig/drivers/s390/scsi/zfcp_ext.h
+++ linux-2.6/drivers/s390/scsi/zfcp_ext.h
@@ -27,8 +27,7 @@
 extern struct zfcp_data zfcp_data;
 
 /******************************** SYSFS  *************************************/
-extern int  zfcp_sysfs_driver_create_files(struct device_driver *);
-extern void zfcp_sysfs_driver_remove_files(struct device_driver *);
+extern struct attribute_group *zfcp_driver_attr_groups[];
 extern int  zfcp_sysfs_adapter_create_files(struct device *);
 extern void zfcp_sysfs_adapter_remove_files(struct device *);
 extern int  zfcp_sysfs_port_create_files(struct device *, u32);
--- linux-2.6.orig/drivers/s390/scsi/zfcp_sysfs_driver.c
+++ linux-2.6/drivers/s390/scsi/zfcp_sysfs_driver.c
@@ -98,28 +98,9 @@ static struct attribute_group zfcp_drive
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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbZFDQWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbZFDQWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbZFDQTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:19:23 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:59118 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbZFDQTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:19:03 -0400
Message-Id: <20090604161904.378820936@de.ibm.com>
References: <20090604161847.513682672@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 18:19:07 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Petermann <martin.petermann@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 20/38] pm: zfcp driver power management callbacks
Content-Disposition: inline; filename=pm_zfcp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Petermann <martin.petermann@de.ibm.com>

Signed-off-by: Martin Petermann <martin.petermann@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 drivers/s390/scsi/zfcp_ccw.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

Index: linux-2.6/drivers/s390/scsi/zfcp_ccw.c
===================================================================
--- linux-2.6.orig/drivers/s390/scsi/zfcp_ccw.c
+++ linux-2.6/drivers/s390/scsi/zfcp_ccw.c
@@ -199,6 +199,36 @@ static void zfcp_ccw_shutdown(struct ccw
 	up(&zfcp_data.config_sema);
 }
 
+static int zfcp_ccw_suspend(struct ccw_device *cdev)
+
+{
+	struct zfcp_adapter *adapter = dev_get_drvdata(&cdev->dev);
+
+	down(&zfcp_data.config_sema);
+
+	zfcp_erp_adapter_shutdown(adapter, 0, "ccsusp1", NULL);
+	zfcp_erp_wait(adapter);
+
+	up(&zfcp_data.config_sema);
+
+	return 0;
+}
+
+static int zfcp_ccw_activate(struct ccw_device *cdev)
+
+{
+	struct zfcp_adapter *adapter = dev_get_drvdata(&cdev->dev);
+
+	zfcp_erp_modify_adapter_status(adapter, "ccresu1", NULL,
+				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
+	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
+				"ccresu2", NULL);
+	zfcp_erp_wait(adapter);
+	flush_work(&adapter->scan_work);
+
+	return 0;
+}
+
 static struct ccw_device_id zfcp_ccw_device_id[] = {
 	{ CCW_DEVICE_DEVTYPE(0x1731, 0x3, 0x1732, 0x3) },
 	{ CCW_DEVICE_DEVTYPE(0x1731, 0x3, 0x1732, 0x4) }, /* priv. */
@@ -217,6 +247,9 @@ static struct ccw_driver zfcp_ccw_driver
 	.set_offline = zfcp_ccw_set_offline,
 	.notify      = zfcp_ccw_notify,
 	.shutdown    = zfcp_ccw_shutdown,
+	.freeze      = zfcp_ccw_suspend,
+	.thaw        = zfcp_ccw_activate,
+	.restore     = zfcp_ccw_activate,
 };
 
 /**

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


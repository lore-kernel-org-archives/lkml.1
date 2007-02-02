Return-Path: <linux-kernel-owner+w=401wt.eu-S1423044AbXBBMLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423044AbXBBMLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 07:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423043AbXBBMLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 07:11:37 -0500
Received: from mail-gw3.adaptec.com ([216.52.22.36]:34531 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423042AbXBBMLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 07:11:36 -0500
From: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
Organization: Adaptec
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.19.2] SCSI sd:  udev accessing an uninitialized scsi_disk results in a crash
Date: Fri, 2 Feb 2007 17:34:56 +0530
User-Agent: KMail/1.9.1
Cc: linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702021734.57161.nagendra_tomar@adaptec.com>
X-OriginalArrivalTime: 02 Feb 2007 12:11:33.0257 (UTC) FILETIME=[47537F90:01C746C3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	sd_probe() calls class_device_add() even before initializing the 
sdkp->device variable. class_device_add() eventually results in the user mode 
udev program to be called. udev program can read the the allow_restart 
attribute of the newly created scsi device. This is resulting in a crash as 
the show function for allow_restart (i.e sd_show_allow_restart) returns the 
attribute value by reading the sdkp->device->allow_restart variable. As the 
sdkp->device is not initialized before calling the user mode hotplug helper, 
this results in a crash.
	The patch below solves it by calling class_device_add() only after the 
necessary fields in the scsi_disk structure are initialized properly.


Thanx,
Tomar



Signed-off-by: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
---

--- linux-2.6.19.2/drivers/scsi/sd.c.orig	2007-02-02 17:03:03.000000000 +0530
+++ linux-2.6.19.2/drivers/scsi/sd.c	2007-02-02 17:04:04.000000000 +0530
@@ -1646,16 +1646,6 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_put;
 
-	class_device_initialize(&sdkp->cdev);
-	sdkp->cdev.dev = &sdp->sdev_gendev;
-	sdkp->cdev.class = &sd_disk_class;
-	strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
-
-	if (class_device_add(&sdkp->cdev))
-		goto out_put;
-
-	get_device(&sdp->sdev_gendev);
-
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
@@ -1669,6 +1659,16 @@ static int sd_probe(struct device *dev)
 			sdp->timeout = SD_MOD_TIMEOUT;
 	}
 
+	class_device_initialize(&sdkp->cdev);
+	sdkp->cdev.dev = &sdp->sdev_gendev;
+	sdkp->cdev.class = &sd_disk_class;
+	strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
+
+	if (class_device_add(&sdkp->cdev))
+		goto out_put;
+
+	get_device(&sdp->sdev_gendev);
+
 	gd->major = sd_major((index & 0xf0) >> 4);
 	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
 	gd->minors = 16;

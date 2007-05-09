Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbXEIXmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbXEIXmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760008AbXEIXlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:41:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:57912 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759955AbXEIXlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:41:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,512,1170662400"; 
   d="scan'208";a="226366729"
Date: Wed, 9 May 2007 16:38:21 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 3/7] scsi: expose AN to user space
Message-Id: <20070509163821.d2cb7732.kristen.c.accardi@intel.com>
In-Reply-To: <20070510072247.063476979@intel.com>
References: <20070510072247.063476979@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Get media change notification capability from disk and pass this information
to genhd by setting appropriate flag.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/drivers/scsi/sr.c
===================================================================
--- 2.6-git.orig/drivers/scsi/sr.c
+++ 2.6-git/drivers/scsi/sr.c
@@ -603,6 +603,8 @@ static int sr_probe(struct device *dev)
 
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
+	if (sdev->media_change_notify)
+		disk->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
 	add_disk(disk);
 
 	sdev_printk(KERN_DEBUG, sdev,
Index: 2.6-git/include/scsi/scsi_device.h
===================================================================
--- 2.6-git.orig/include/scsi/scsi_device.h
+++ 2.6-git/include/scsi/scsi_device.h
@@ -126,7 +126,7 @@ struct scsi_device {
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
 	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
-
+	unsigned media_change_notify:1; /* dev supports async media notify */
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
Index: 2.6-git/drivers/scsi/sd.c
===================================================================
--- 2.6-git.orig/drivers/scsi/sd.c
+++ 2.6-git/drivers/scsi/sd.c
@@ -1668,6 +1668,9 @@ static int sd_probe(struct device *dev)
 	if (sdp->removable)
 		gd->flags |= GENHD_FL_REMOVABLE;
 
+	if (sdp->media_change_notify)
+		gd->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
+
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
 

-- 

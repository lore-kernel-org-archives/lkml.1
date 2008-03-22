Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYCVDWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYCVDWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYCVDW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:22:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:14216 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbYCVDW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MG9RHdMTE+k83e1XJknT+DLTO+SnESo+KyLZ+u9vWFc6ttbeVdqKL0l/nqDaRNcGnwYmIPuyynE15YHfBGSBu3mGTYC0VvsxKFbKnxqvfz3yXWpCrANdTq9OnSwD/wUghWSWjUXxWhafJOXJpp4tbB03B8upmMtg0ktsU10oe9Q=
Date: Sat, 22 Mar 2008 12:14:14 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Adrian McMenamin <adrian@mcmen.demon.co.uk>,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 5/5] cdrom: make unregister_cdrom() return void
Message-ID: <20080322031413.GE3665@APFDCB5C>
References: <20080322030948.GA3665@APFDCB5C> <20080322031047.GB3665@APFDCB5C> <20080322031204.GC3665@APFDCB5C> <20080322031248.GD3665@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080322031248.GD3665@APFDCB5C>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now unregister_cdrom() always returns 0.
Make it return void and update all callers that check the return value.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 Documentation/cdrom/cdrom-standard.tex |    2 +-
 drivers/cdrom/cdrom.c                  |    3 +--
 drivers/cdrom/gdrom.c                  |    4 +++-
 drivers/cdrom/viocd.c                  |    5 +----
 drivers/ide/ide-cd.c                   |    5 ++---
 include/linux/cdrom.h                  |    2 +-
 6 files changed, 9 insertions(+), 12 deletions(-)

Index: 2.6-git/drivers/cdrom/cdrom.c
===================================================================
--- 2.6-git.orig/drivers/cdrom/cdrom.c
+++ 2.6-git/drivers/cdrom/cdrom.c
@@ -442,7 +442,7 @@ int register_cdrom(struct cdrom_device_i
 }
 #undef ENSURE
 
-int unregister_cdrom(struct cdrom_device_info *cdi)
+void unregister_cdrom(struct cdrom_device_info *cdi)
 {
 	cdinfo(CD_OPEN, "entering unregister_cdrom\n"); 
 
@@ -455,7 +455,6 @@ int unregister_cdrom(struct cdrom_device
 
 	cdi->ops->n_minors--;
 	cdinfo(CD_REG_UNREG, "drive \"/dev/%s\" unregistered\n", cdi->name);
-	return 0;
 }
 
 int cdrom_get_media_event(struct cdrom_device_info *cdi,
Index: 2.6-git/drivers/cdrom/gdrom.c
===================================================================
--- 2.6-git.orig/drivers/cdrom/gdrom.c
+++ 2.6-git/drivers/cdrom/gdrom.c
@@ -827,7 +827,9 @@ static int __devexit remove_gdrom(struct
 	del_gendisk(gd.disk);
 	if (gdrom_major)
 		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
-	return unregister_cdrom(gd.cd_info);
+	unregister_cdrom(gd.cd_info);
+
+	return 0;
 }
 
 static struct platform_driver gdrom_driver = {
Index: 2.6-git/drivers/cdrom/viocd.c
===================================================================
--- 2.6-git.orig/drivers/cdrom/viocd.c
+++ 2.6-git/drivers/cdrom/viocd.c
@@ -650,10 +650,7 @@ static int viocd_remove(struct vio_dev *
 {
 	struct disk_info *d = &viocd_diskinfo[vdev->unit_address];
 
-	if (unregister_cdrom(&d->viocd_info) != 0)
-		printk(VIOCD_KERN_WARNING
-				"Cannot unregister viocd CD-ROM %s!\n",
-				d->viocd_info.name);
+	unregister_cdrom(&d->viocd_info);
 	del_gendisk(d->viocd_disk);
 	blk_cleanup_queue(d->viocd_disk->queue);
 	put_disk(d->viocd_disk);
Index: 2.6-git/include/linux/cdrom.h
===================================================================
--- 2.6-git.orig/include/linux/cdrom.h
+++ 2.6-git/include/linux/cdrom.h
@@ -995,7 +995,7 @@ extern int cdrom_ioctl(struct file *file
 extern int cdrom_media_changed(struct cdrom_device_info *);
 
 extern int register_cdrom(struct cdrom_device_info *cdi);
-extern int unregister_cdrom(struct cdrom_device_info *cdi);
+extern void unregister_cdrom(struct cdrom_device_info *cdi);
 
 typedef struct {
     int data;
Index: 2.6-git/Documentation/cdrom/cdrom-standard.tex
===================================================================
--- 2.6-git.orig/Documentation/cdrom/cdrom-standard.tex
+++ 2.6-git/Documentation/cdrom/cdrom-standard.tex
@@ -777,7 +777,7 @@ Note that a driver must have one static 
 it may have as many structures $<device>_info$ as there are minor devices
 active. $Register_cdrom()$ builds a linked list from these. 
 
-\subsection{$Int\ unregister_cdrom(struct\ cdrom_device_info * cdi)$}
+\subsection{$Void\ unregister_cdrom(struct\ cdrom_device_info * cdi)$}
 
 Unregistering device $cdi$ with minor number $MINOR(cdi\to dev)$ removes
 the minor device from the list. If it was the last registered minor for
Index: 2.6-git/drivers/ide/ide-cd.c
===================================================================
--- 2.6-git.orig/drivers/ide/ide-cd.c
+++ 2.6-git/drivers/ide/ide-cd.c
@@ -2030,9 +2030,8 @@ static void ide_cd_release(struct kref *
 
 	kfree(info->buffer);
 	kfree(info->toc);
-	if (devinfo->handle == drive && unregister_cdrom(devinfo))
-		printk(KERN_ERR "%s: %s failed to unregister device from the cdrom "
-				"driver.\n", __FUNCTION__, drive->name);
+	if (devinfo->handle == drive)
+		unregister_cdrom(devinfo);
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
 	blk_queue_prep_rq(drive->queue, NULL);

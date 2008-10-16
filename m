Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYJPRT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYJPRT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYJPROS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:18 -0400
Received: from kroah.org ([198.145.64.141]:46942 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755254AbYJPROP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 10/46] device create: scsi: convert device_create_drvdata to device_create
Date: Thu, 16 Oct 2008 10:10:11 -0700
Message-Id: <1224177047-11859-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_create() has been audited, rename things back to the
original call to be sane.

Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/ch.c      |    6 +++---
 drivers/scsi/dpt_i2o.c |    2 +-
 drivers/scsi/osst.c    |    3 ++-
 drivers/scsi/sg.c      |   10 ++++------
 drivers/scsi/st.c      |   11 ++++-------
 5 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 3c257fe..88ecf94 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -914,9 +914,9 @@ static int ch_probe(struct device *dev)
 	ch->minor = minor;
 	sprintf(ch->name,"ch%d",ch->minor);
 
-	class_dev = device_create_drvdata(ch_sysfs_class, dev,
-					  MKDEV(SCSI_CHANGER_MAJOR, ch->minor),
-					  ch, "s%s", ch->name);
+	class_dev = device_create(ch_sysfs_class, dev,
+				  MKDEV(SCSI_CHANGER_MAJOR, ch->minor), ch,
+				  "s%s", ch->name);
 	if (IS_ERR(class_dev)) {
 		printk(KERN_WARNING "ch%d: device_create failed\n",
 		       ch->minor);
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 1fe0901..8aba4fd 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -271,7 +271,7 @@ rebuild_sys_tab:
 		pHba->initialized = TRUE;
 		pHba->state &= ~DPTI_STATE_RESET;
 		if (adpt_sysfs_class) {
-			struct device *dev = device_create_drvdata(adpt_sysfs_class,
+			struct device *dev = device_create(adpt_sysfs_class,
 				NULL, MKDEV(DPTI_I2O_MAJOR, pHba->unit), NULL,
 				"dpti%d", pHba->unit);
 			if (IS_ERR(dev)) {
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 1c79f97..0ea78d9 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5708,7 +5708,8 @@ static int osst_sysfs_add(dev_t dev, struct device *device, struct osst_tape * S
 	struct device *osst_member;
 	int err;
 
-	osst_member = device_create_drvdata(osst_sysfs_class, device, dev, STp, "%s", name);
+	osst_member = device_create(osst_sysfs_class, device, dev, STp,
+				    "%s", name);
 	if (IS_ERR(osst_member)) {
 		printk(KERN_WARNING "osst :W: Unable to add sysfs class member %s\n", name);
 		return PTR_ERR(osst_member);
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ba9b9bb..93bd59a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1450,12 +1450,10 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
 	if (sg_sysfs_valid) {
 		struct device *sg_class_member;
 
-		sg_class_member = device_create_drvdata(sg_sysfs_class,
-							cl_dev->parent,
-							MKDEV(SCSI_GENERIC_MAJOR,
-							      sdp->index),
-							sdp,
-							"%s", disk->disk_name);
+		sg_class_member = device_create(sg_sysfs_class, cl_dev->parent,
+						MKDEV(SCSI_GENERIC_MAJOR,
+						      sdp->index),
+						sdp, "%s", disk->disk_name);
 		if (IS_ERR(sg_class_member)) {
 			printk(KERN_ERR "sg_add: "
 			       "device_create failed\n");
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c2bb53e..5c28d08 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4428,13 +4428,10 @@ static int do_create_class_files(struct scsi_tape *STp, int dev_num, int mode)
 		snprintf(name, 10, "%s%s%s", rew ? "n" : "",
 			 STp->disk->disk_name, st_formats[i]);
 		st_class_member =
-			device_create_drvdata(st_sysfs_class,
-					      &STp->device->sdev_gendev,
-					      MKDEV(SCSI_TAPE_MAJOR,
-						    TAPE_MINOR(dev_num,
-							      mode, rew)),
-					      &STp->modes[mode],
-					      "%s", name);
+			device_create(st_sysfs_class, &STp->device->sdev_gendev,
+				      MKDEV(SCSI_TAPE_MAJOR,
+					    TAPE_MINOR(dev_num, mode, rew)),
+				      &STp->modes[mode], "%s", name);
 		if (IS_ERR(st_class_member)) {
 			printk(KERN_WARNING "st%d: device_create failed\n",
 			       dev_num);
-- 
1.6.0.2


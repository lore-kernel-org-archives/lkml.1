Return-Path: <linux-kernel-owner+w=401wt.eu-S934729AbYETWmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934729AbYETWmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934962AbYETWhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:37:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934994AbYETWhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:37:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Doug Gilbert <dgilbert@interlog.com>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 13/13] SCSI: fix race in device_create
Date: Tue, 20 May 2008 15:35:00 -0700
Message-Id: <1211322900-12705-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080520223237.GA12383@suse.de>
References: <20080520223237.GA12383@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race from when a device is created with device_create() and
then the drvdata is set with a call to dev_set_drvdata() in which a
sysfs file could be open, yet the drvdata will be NULL, causing all
sorts of bad things to happen.

This patch fixes the problem by using the new function,
device_create_drvdata().  It fixes the problem in all of the scsi
drivers that need it.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/ch.c   |    7 +++----
 drivers/scsi/osst.c |    3 +--
 drivers/scsi/sg.c   |   11 ++++++-----
 drivers/scsi/st.c   |   12 +++++++-----
 4 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 75c84d7..c4b938b 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -910,9 +910,9 @@ static int ch_probe(struct device *dev)
 	ch->minor = minor;
 	sprintf(ch->name,"ch%d",ch->minor);
 
-	class_dev = device_create(ch_sysfs_class, dev,
-				  MKDEV(SCSI_CHANGER_MAJOR,ch->minor),
-				  "s%s", ch->name);
+	class_dev = device_create_drvdata(ch_sysfs_class, dev,
+					  MKDEV(SCSI_CHANGER_MAJOR, ch->minor),
+					  ch, "s%s", ch->name);
 	if (IS_ERR(class_dev)) {
 		printk(KERN_WARNING "ch%d: device_create failed\n",
 		       ch->minor);
@@ -926,7 +926,6 @@ static int ch_probe(struct device *dev)
 	if (init)
 		ch_init_elem(ch);
 
-	dev_set_drvdata(dev, ch);
 	sdev_printk(KERN_INFO, sd, "Attached scsi changer %s\n", ch->name);
 
 	return 0;
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 31f7aec..243d8be 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5695,13 +5695,12 @@ static int osst_sysfs_add(dev_t dev, struct device *device, struct osst_tape * S
 	struct device *osst_member;
 	int err;
 
-	osst_member = device_create(osst_sysfs_class, device, dev, "%s", name);
+	osst_member = device_create_drvdata(osst_sysfs_class, device, dev, STp, "%s", name);
 	if (IS_ERR(osst_member)) {
 		printk(KERN_WARNING "osst :W: Unable to add sysfs class member %s\n", name);
 		return PTR_ERR(osst_member);
 	}
 
-	dev_set_drvdata(osst_member, STp);
 	err = device_create_file(osst_member, &dev_attr_ADR_rev);
 	if (err)
 		goto err_out;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c9d7f72..ea0edd1 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1441,17 +1441,18 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
 	if (sg_sysfs_valid) {
 		struct device *sg_class_member;
 
-		sg_class_member = device_create(sg_sysfs_class, cl_dev->parent,
-						MKDEV(SCSI_GENERIC_MAJOR,
-						      sdp->index),
-						"%s", disk->disk_name);
+		sg_class_member = device_create_drvdata(sg_sysfs_class,
+							cl_dev->parent,
+							MKDEV(SCSI_GENERIC_MAJOR,
+							      sdp->index),
+							sdp,
+							"%s", disk->disk_name);
 		if (IS_ERR(sg_class_member)) {
 			printk(KERN_ERR "sg_add: "
 			       "device_create failed\n");
 			error = PTR_ERR(sg_class_member);
 			goto cdev_add_err;
 		}
-		dev_set_drvdata(sg_class_member, sdp);
 		error = sysfs_create_link(&scsidp->sdev_gendev.kobj,
 					  &sg_class_member->kobj, "generic");
 		if (error)
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e8db66a..6e5a5bb 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4424,17 +4424,19 @@ static int do_create_class_files(struct scsi_tape *STp, int dev_num, int mode)
 		snprintf(name, 10, "%s%s%s", rew ? "n" : "",
 			 STp->disk->disk_name, st_formats[i]);
 		st_class_member =
-			device_create(st_sysfs_class, &STp->device->sdev_gendev,
-				      MKDEV(SCSI_TAPE_MAJOR,
-						TAPE_MINOR(dev_num, mode, rew)),
-				      "%s", name);
+			device_create_drvdata(st_sysfs_class,
+					      &STp->device->sdev_gendev,
+					      MKDEV(SCSI_TAPE_MAJOR,
+						    TAPE_MINOR(dev_num,
+							      mode, rew)),
+					      &STp->modes[mode],
+					      "%s", name);
 		if (IS_ERR(st_class_member)) {
 			printk(KERN_WARNING "st%d: device_create failed\n",
 			       dev_num);
 			error = PTR_ERR(st_class_member);
 			goto out;
 		}
-		dev_set_drvdata(st_class_member, &STp->modes[mode]);
 
 		error = device_create_file(st_class_member,
 					   &dev_attr_defined);
-- 
1.5.5.1


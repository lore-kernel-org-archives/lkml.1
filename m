Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbYGVF32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbYGVF32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbYGVFXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:07 -0400
Received: from mail.suse.de ([195.135.220.2]:53829 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbYGVFXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 23/79] device create: s390: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:47 -0700
Message-Id: <1216703983-21448-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/s390/char/raw3270.c    |   14 ++++++++------
 drivers/s390/char/tape_class.c |    7 +++----
 drivers/s390/char/vmur.c       |    5 +++--
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index 81a96e0..c3dee90 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -1168,17 +1168,19 @@ static int raw3270_create_attributes(struct raw3270 *rp)
 	if (rc)
 		goto out;
 
-	rp->clttydev = device_create(class3270, &rp->cdev->dev,
-				     MKDEV(IBM_TTY3270_MAJOR, rp->minor),
-				     "tty%s", rp->cdev->dev.bus_id);
+	rp->clttydev = device_create_drvdata(class3270, &rp->cdev->dev,
+					     MKDEV(IBM_TTY3270_MAJOR, rp->minor),
+					     NULL,
+					     "tty%s", rp->cdev->dev.bus_id);
 	if (IS_ERR(rp->clttydev)) {
 		rc = PTR_ERR(rp->clttydev);
 		goto out_ttydev;
 	}
 
-	rp->cltubdev = device_create(class3270, &rp->cdev->dev,
-				     MKDEV(IBM_FS3270_MAJOR, rp->minor),
-				     "tub%s", rp->cdev->dev.bus_id);
+	rp->cltubdev = device_create_drvdata(class3270, &rp->cdev->dev,
+					     MKDEV(IBM_FS3270_MAJOR, rp->minor),
+					     NULL,
+					     "tub%s", rp->cdev->dev.bus_id);
 	if (!IS_ERR(rp->cltubdev))
 		goto out;
 
diff --git a/drivers/s390/char/tape_class.c b/drivers/s390/char/tape_class.c
index 6dfdb7c..12c2a5a 100644
--- a/drivers/s390/char/tape_class.c
+++ b/drivers/s390/char/tape_class.c
@@ -69,10 +69,9 @@ struct tape_class_device *register_tape_dev(
 	if (rc)
 		goto fail_with_cdev;
 
-	tcd->class_device = device_create(tape_class, device,
-					  tcd->char_device->dev,
-					  "%s", tcd->device_name
-			);
+	tcd->class_device = device_create_drvdata(tape_class, device,
+						  tcd->char_device->dev,
+						  NULL, "%s", tcd->device_name);
 	rc = IS_ERR(tcd->class_device) ? PTR_ERR(tcd->class_device) : 0;
 	if (rc)
 		goto fail_with_cdev;
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index b0ac44b..c1f352b 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -896,8 +896,9 @@ static int ur_set_online(struct ccw_device *cdev)
 		goto fail_free_cdev;
 	}
 
-	urd->device = device_create(vmur_class, NULL, urd->char_device->dev,
-					"%s", node_id);
+	urd->device = device_create_drvdata(vmur_class, NULL,
+					    urd->char_device->dev, NULL,
+					    "%s", node_id);
 	if (IS_ERR(urd->device)) {
 		rc = PTR_ERR(urd->device);
 		TRACE("ur_set_online: device_create rc=%d\n", rc);
-- 
1.5.6.3


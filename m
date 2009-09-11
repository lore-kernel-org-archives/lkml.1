Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbZIKAbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbZIKAbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZIKAbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:31:31 -0400
Received: from kroah.org ([198.145.64.141]:38100 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbZIKA3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:11 2009
Message-Id: <20090911002411.326362527@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:23:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 15/22] SCSI: sd: fix bug in SCSI async probing
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=scsi-sd-fix-bug-in-scsi-async-probing.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 601e7638254c118fca135af9b1a9f35061420f62 upstream.

The async split up of probing in sd.c created a potential failure case where
something goes wrong with device_add(), but which we don't recover properly.
Since, in general, asynchronous error handling is hard, move the device_add()
into the asynchronous path (it should be fast) and make sure all the deferred
processing cannot fail.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/sd.c |   45 +++++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1902,24 +1902,6 @@ static void sd_probe_async(void *data, a
 	index = sdkp->index;
 	dev = &sdp->sdev_gendev;
 
-	if (!sdp->request_queue->rq_timeout) {
-		if (sdp->type != TYPE_MOD)
-			blk_queue_rq_timeout(sdp->request_queue, SD_TIMEOUT);
-		else
-			blk_queue_rq_timeout(sdp->request_queue,
-					     SD_MOD_TIMEOUT);
-	}
-
-	device_initialize(&sdkp->dev);
-	sdkp->dev.parent = &sdp->sdev_gendev;
-	sdkp->dev.class = &sd_disk_class;
-	dev_set_name(&sdkp->dev, dev_name(&sdp->sdev_gendev));
-
-	if (device_add(&sdkp->dev))
-		goto out_free_index;
-
-	get_device(&sdp->sdev_gendev);
-
 	if (index < SD_MAX_DISKS) {
 		gd->major = sd_major((index & 0xf0) >> 4);
 		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
@@ -1954,11 +1936,6 @@ static void sd_probe_async(void *data, a
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
-
-	return;
-
- out_free_index:
-	ida_remove(&sd_index_ida, index);
 }
 
 /**
@@ -2026,6 +2003,24 @@ static int sd_probe(struct device *dev)
 	sdkp->openers = 0;
 	sdkp->previous_state = 1;
 
+	if (!sdp->request_queue->rq_timeout) {
+		if (sdp->type != TYPE_MOD)
+			blk_queue_rq_timeout(sdp->request_queue, SD_TIMEOUT);
+		else
+			blk_queue_rq_timeout(sdp->request_queue,
+					     SD_MOD_TIMEOUT);
+	}
+
+	device_initialize(&sdkp->dev);
+	sdkp->dev.parent = &sdp->sdev_gendev;
+	sdkp->dev.class = &sd_disk_class;
+	dev_set_name(&sdkp->dev, dev_name(&sdp->sdev_gendev));
+
+	if (device_add(&sdkp->dev))
+		goto out_free_index;
+
+	get_device(&sdp->sdev_gendev);
+
 	async_schedule(sd_probe_async, sdkp);
 
 	return 0;
@@ -2055,8 +2050,10 @@ static int sd_probe(struct device *dev)
  **/
 static int sd_remove(struct device *dev)
 {
-	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct scsi_disk *sdkp;
 
+	async_synchronize_full();
+	sdkp = dev_get_drvdata(dev);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab0BDRVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:21:44 -0500
Received: from kroah.org ([198.145.64.141]:34612 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831Ab0BDRVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:35 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:53 2010
Message-Id: <20100204171452.915396715@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Haberland <stefan.haberland@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [11/74] [S390] dasd: fix possible NULL pointer errors
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Haberland <stefan.haberland@de.ibm.com>

commit 294001a80c9810e2fe27aaaad7df8be12a103065 upstream.

Fix possible NULL pointer in DASD messages and correct discipline
checking.

Signed-off-by: Stefan Haberland <stefan.haberland@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/s390/block/dasd.c       |    8 ++++----
 drivers/s390/block/dasd_eckd.c  |    2 +-
 drivers/s390/block/dasd_ioctl.c |    7 ++-----
 drivers/s390/block/dasd_proc.c  |    7 ++-----
 4 files changed, 9 insertions(+), 15 deletions(-)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1005,8 +1005,8 @@ static void dasd_handle_killed_request(s
 	if (device == NULL ||
 	    device != dasd_device_from_cdev_locked(cdev) ||
 	    strncmp(device->discipline->ebcname, (char *) &cqr->magic, 4)) {
-		DBF_DEV_EVENT(DBF_DEBUG, device, "invalid device in request: "
-			      "bus_id %s", dev_name(&cdev->dev));
+		DBF_EVENT_DEVID(DBF_DEBUG, cdev, "%s",
+				"invalid device in request");
 		return;
 	}
 
@@ -1078,8 +1078,8 @@ void dasd_int_handler(struct ccw_device 
 	device = (struct dasd_device *) cqr->startdev;
 	if (!device ||
 	    strncmp(device->discipline->ebcname, (char *) &cqr->magic, 4)) {
-		DBF_DEV_EVENT(DBF_DEBUG, device, "invalid device in request: "
-			      "bus_id %s", dev_name(&cdev->dev));
+		DBF_EVENT_DEVID(DBF_DEBUG, cdev, "%s",
+				"invalid device in request");
 		return;
 	}
 
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2980,7 +2980,7 @@ static void dasd_eckd_dump_sense_ccw(str
 	len += sprintf(page + len, KERN_ERR PRINTK_HEADER
 		       " in req: %p CS: 0x%02X DS: 0x%02X CC: 0x%02X RC: %d\n",
 		       req, scsw_cstat(&irb->scsw), scsw_dstat(&irb->scsw),
-		       scsw_cc(&irb->scsw), req->intrc);
+		       scsw_cc(&irb->scsw), req ? req->intrc : 0);
 	len += sprintf(page + len, KERN_ERR PRINTK_HEADER
 		       " device %s: Failing CCW: %p\n",
 		       dev_name(&device->cdev->dev),
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -260,7 +260,7 @@ static int dasd_ioctl_information(struct
 	struct ccw_dev_id dev_id;
 
 	base = block->base;
-	if (!base->discipline->fill_info)
+	if (!base->discipline || !base->discipline->fill_info)
 		return -EINVAL;
 
 	dasd_info = kzalloc(sizeof(struct dasd_information2_t), GFP_KERNEL);
@@ -303,10 +303,7 @@ static int dasd_ioctl_information(struct
 	dasd_info->features |=
 		((base->features & DASD_FEATURE_READONLY) != 0);
 
-	if (base->discipline)
-		memcpy(dasd_info->type, base->discipline->name, 4);
-	else
-		memcpy(dasd_info->type, "none", 4);
+	memcpy(dasd_info->type, base->discipline->name, 4);
 
 	if (block->request_queue->request_fn) {
 		struct list_head *l;
--- a/drivers/s390/block/dasd_proc.c
+++ b/drivers/s390/block/dasd_proc.c
@@ -71,7 +71,7 @@ dasd_devices_show(struct seq_file *m, vo
 	/* Print device number. */
 	seq_printf(m, "%s", dev_name(&device->cdev->dev));
 	/* Print discipline string. */
-	if (device != NULL && device->discipline != NULL)
+	if (device->discipline != NULL)
 		seq_printf(m, "(%s)", device->discipline->name);
 	else
 		seq_printf(m, "(none)");
@@ -91,10 +91,7 @@ dasd_devices_show(struct seq_file *m, vo
 	substr = (device->features & DASD_FEATURE_READONLY) ? "(ro)" : " ";
 	seq_printf(m, "%4s: ", substr);
 	/* Print device status information. */
-	switch ((device != NULL) ? device->state : -1) {
-	case -1:
-		seq_printf(m, "unknown");
-		break;
+	switch (device->state) {
 	case DASD_STATE_NEW:
 		seq_printf(m, "new");
 		break;



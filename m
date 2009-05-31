Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbZEaGp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbZEaGp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 02:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756964AbZEaGpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 02:45:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:13806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbZEaGpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 02:45:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,278,1241420400"; 
   d="scan'208,223";a="461985042"
From: "Xu, Dongxiao" <dongxiao.xu@intel.com>
To: "greg@kroah.com" <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Nashif, Anas" <anas.nashif@intel.com>,
       "Obara, Marcin" <marcin.obara@intel.com>
Date: Sun, 31 May 2009 14:43:46 +0800
Subject: [Patch 04/08] Staging: heci - fix softirq safe to unsafe spinlock
 issue
Thread-Topic: [Patch 04/08] Staging: heci - fix softirq safe to unsafe
 spinlock issue
Thread-Index: AcnhuyWMTr0NK7DiQLqwCjgMFSF4Cw==
Message-ID: <EADF0A36011179459010BDF5142A457501C9BF2AE2@pdsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 971440bc39590f5baecf3e4553b15a56b17a5865 Mon Sep 17 00:00:00 2001
From: Dongxiao Xu <dongxiao.xu@intel.com>
Date: Sun, 31 May 2009 22:45:38 +0800
Subject: [PATCH] heci: fix softirq safe to unsafe spinlock issue.

When spinlock is nested, and the outside one is spin_lock_bh, the inner
spinlock should also be spin_lock_bh, otherwise it will bring softirq-safe
to softirq-unsafe lock conversion.

Signed-off-by: Dongxiao Xu <dongxiao.xu@intel.com>
---
 drivers/staging/heci/heci_main.c |   24 ++++++++++++------------
 drivers/staging/heci/interrupt.c |    8 ++++----
 drivers/staging/heci/io_heci.c   |   20 ++++++++++----------
 3 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/heci/heci_main.c b/drivers/staging/heci/heci_main.c
index 5494ab5..1e5c26d 100644
--- a/drivers/staging/heci/heci_main.c
+++ b/drivers/staging/heci/heci_main.c
@@ -955,10 +955,10 @@ static ssize_t heci_read(struct file *file, char __user *ubuf,
 	}
 
 	err = heci_start_read(dev, if_num, file_ext);
-	spin_lock(&file_ext->read_io_lock);
+	spin_lock_bh(&file_ext->read_io_lock);
 	if (err != 0 && err != -EBUSY) {
 		DBG("heci start read failure with status = %d\n", err);
-		spin_unlock(&file_ext->read_io_lock);
+		spin_unlock_bh(&file_ext->read_io_lock);
 		rets = err;
 		goto out;
 	}
@@ -966,10 +966,10 @@ static ssize_t heci_read(struct file *file, char __user *ubuf,
 			&& !waitqueue_active(&file_ext->rx_wait)) {
 		if (file->f_flags & O_NONBLOCK) {
 			rets = -EAGAIN;
-			spin_unlock(&file_ext->read_io_lock);
+			spin_unlock_bh(&file_ext->read_io_lock);
 			goto out;
 		}
-		spin_unlock(&file_ext->read_io_lock);
+		spin_unlock_bh(&file_ext->read_io_lock);
 
 		if (wait_event_interruptible(file_ext->rx_wait,
 			(HECI_READ_COMPLETE == file_ext->reading_state
@@ -989,20 +989,20 @@ static ssize_t heci_read(struct file *file, char __user *ubuf,
 			rets = -EBUSY;
 			goto out;
 		}
-		spin_lock(&file_ext->read_io_lock);
+		spin_lock_bh(&file_ext->read_io_lock);
 	}
 
 	priv_cb = file_ext->read_cb;
 
 	if (!priv_cb) {
-		spin_unlock(&file_ext->read_io_lock);
+		spin_unlock_bh(&file_ext->read_io_lock);
 		return -ENODEV;
 	}
 	if (file_ext->reading_state != HECI_READ_COMPLETE) {
-		spin_unlock(&file_ext->read_io_lock);
+		spin_unlock_bh(&file_ext->read_io_lock);
 		return 0;
 	}
-	spin_unlock(&file_ext->read_io_lock);
+	spin_unlock_bh(&file_ext->read_io_lock);
 	/* now copy the data to user space */
 copy_buffer:
 	DBG("priv_cb->response_buffer size - %d\n",
@@ -1040,11 +1040,11 @@ free:
 		list_del(&priv_cb_pos->cb_list);
 	spin_unlock_bh(&dev->device_lock);
 	heci_free_cb_private(priv_cb);
-	spin_lock(&file_ext->read_io_lock);
+	spin_lock_bh(&file_ext->read_io_lock);
 	file_ext->reading_state = HECI_IDLE;
 	file_ext->read_cb = NULL;
 	file_ext->read_pending = 0;
-	spin_unlock(&file_ext->read_io_lock);
+	spin_unlock_bh(&file_ext->read_io_lock);
 out:	DBG("end heci read rets= %d\n", rets);
 	return rets;
 }
@@ -1106,11 +1106,11 @@ static ssize_t heci_write(struct file *file, const char __user *ubuf,
 			list_del(&priv_write_cb->cb_list);
 			heci_free_cb_private(priv_write_cb);
 			priv_write_cb = NULL;
-			spin_lock(&file_ext->read_io_lock);
+			spin_lock_bh(&file_ext->read_io_lock);
 			file_ext->reading_state = HECI_IDLE;
 			file_ext->read_cb = NULL;
 			file_ext->read_pending = 0;
-			spin_unlock(&file_ext->read_io_lock);
+			spin_unlock_bh(&file_ext->read_io_lock);
 		}
 	} else if (file_ext->reading_state == HECI_IDLE &&
 			file_ext->read_pending == 0)
diff --git a/drivers/staging/heci/interrupt.c b/drivers/staging/heci/interrupt.c
index aacd262..2db1851 100644
--- a/drivers/staging/heci/interrupt.c
+++ b/drivers/staging/heci/interrupt.c
@@ -622,7 +622,7 @@ static int heci_bh_read_client_message(struct io_heci_list *complete_list,
 				priv_cb_pos->file_private;
 		if ((file_ext != NULL) &&
 		    (_heci_bh_state_ok(file_ext, heci_hdr))) {
-			spin_lock(&file_ext->read_io_lock);
+			spin_lock_bh(&file_ext->read_io_lock);
 			file_ext->reading_state = HECI_READING;
 			buffer = (unsigned char *)
 				(priv_cb_pos->response_buffer.data +
@@ -636,7 +636,7 @@ static int heci_bh_read_client_message(struct io_heci_list *complete_list,
 					priv_cb_pos->information) {
 				DBG("message overflow.\n");
 				list_del(&priv_cb_pos->cb_list);
-				spin_unlock(&file_ext->read_io_lock);
+				spin_unlock_bh(&file_ext->read_io_lock);
 				return -ENOMEM;
 			}
 			if (buffer) {
@@ -647,7 +647,7 @@ static int heci_bh_read_client_message(struct io_heci_list *complete_list,
 			if (heci_hdr->msg_complete) {
 				file_ext->status = 0;
 				list_del(&priv_cb_pos->cb_list);
-				spin_unlock(&file_ext->read_io_lock);
+				spin_unlock_bh(&file_ext->read_io_lock);
 				DBG("completed read host client = %d,"
 					"ME client = %d, "
 					"data length = %lu\n",
@@ -662,7 +662,7 @@ static int heci_bh_read_client_message(struct io_heci_list *complete_list,
 				list_add_tail(&priv_cb_pos->cb_list,
 					&complete_list->heci_cb.cb_list);
 			} else {
-				spin_unlock(&file_ext->read_io_lock);
+				spin_unlock_bh(&file_ext->read_io_lock);
 			}
 
 			break;
diff --git a/drivers/staging/heci/io_heci.c b/drivers/staging/heci/io_heci.c
index 8a44fd5..8131470 100644
--- a/drivers/staging/heci/io_heci.c
+++ b/drivers/staging/heci/io_heci.c
@@ -648,26 +648,26 @@ int heci_start_read(struct iamt_heci_device *dev, int if_num,
 	}
 	spin_unlock_bh(&dev->device_lock);
 	DBG("check if read is pending.\n");
-	spin_lock(&file_ext->read_io_lock);
+	spin_lock_bh(&file_ext->read_io_lock);
 	if ((file_ext->read_pending) || (file_ext->read_cb != NULL)) {
 		DBG("read is pending.\n");
-		spin_unlock(&file_ext->read_io_lock);
+		spin_unlock_bh(&file_ext->read_io_lock);
 		return -EBUSY;
 	}
-	spin_unlock(&file_ext->read_io_lock);
+	spin_unlock_bh(&file_ext->read_io_lock);
 
 	priv_cb = kzalloc(sizeof(struct heci_cb_private), GFP_KERNEL);
 	if (!priv_cb)
 		return -ENOMEM;
 
-	spin_lock(&file_ext->read_io_lock);
+	spin_lock_bh(&file_ext->read_io_lock);
 	DBG("allocation call back success\n"
 	    "host client = %d, ME client = %d\n",
 	    file_ext->host_client_id, file_ext->me_client_id);
-	spin_unlock(&file_ext->read_io_lock);
+	spin_unlock_bh(&file_ext->read_io_lock);
 
 	spin_lock_bh(&dev->device_lock);
-	spin_lock(&file_ext->read_io_lock);
+	spin_lock_bh(&file_ext->read_io_lock);
 	for (i = 0; i < dev->num_heci_me_clients; i++) {
 		if (dev->me_clients[i].client_id == file_ext->me_client_id)
 			break;
@@ -675,7 +675,7 @@ int heci_start_read(struct iamt_heci_device *dev, int if_num,
 	}
 
 	BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
-	spin_unlock(&file_ext->read_io_lock);
+	spin_unlock_bh(&file_ext->read_io_lock);
 	if (i == dev->num_heci_me_clients) {
 		rets = -ENODEV;
 		goto unlock;
@@ -695,13 +695,13 @@ int heci_start_read(struct iamt_heci_device *dev, int if_num,
 	priv_cb->information = 0;
 	priv_cb->file_private = (void *) file_ext;
 	spin_lock_bh(&dev->device_lock);
-	spin_lock(&file_ext->read_io_lock);
+	spin_lock_bh(&file_ext->read_io_lock);
 	file_ext->read_cb = priv_cb;
 	if (dev->host_buffer_is_empty) {
 		dev->host_buffer_is_empty = 0;
 		if (!heci_send_flow_control(dev, file_ext)) {
 			rets = -ENODEV;
-			spin_unlock(&file_ext->read_io_lock);
+			spin_unlock_bh(&file_ext->read_io_lock);
 			goto unlock;
 		} else {
 			list_add_tail(&priv_cb->cb_list,
@@ -711,7 +711,7 @@ int heci_start_read(struct iamt_heci_device *dev, int if_num,
 		list_add_tail(&priv_cb->cb_list,
 			      &dev->ctrl_wr_list.heci_cb.cb_list);
 	}
-	spin_unlock(&file_ext->read_io_lock);
+	spin_unlock_bh(&file_ext->read_io_lock);
 	spin_unlock_bh(&dev->device_lock);
 	return rets;
 unlock:
-- 
1.6.0.rc1


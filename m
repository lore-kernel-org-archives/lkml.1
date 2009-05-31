Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbZEaGo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbZEaGo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 02:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbZEaGoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 02:44:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:12934 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454AbZEaGoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 02:44:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,278,1241420400"; 
   d="scan'208,223";a="417224695"
From: "Xu, Dongxiao" <dongxiao.xu@intel.com>
To: "greg@kroah.com" <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Nashif, Anas" <anas.nashif@intel.com>,
       "Obara, Marcin" <marcin.obara@intel.com>
Date: Sun, 31 May 2009 14:43:42 +0800
Subject: [Patch 03/08] Staging: heci - fix spinlock order mess of
 device_lock and read_io_lock
Thread-Topic: [Patch 03/08] Staging: heci - fix spinlock order mess of
 device_lock and read_io_lock
Thread-Index: AcnhuyOQ1M+XqE2zS7+ahuJyQy3J/w==
Message-ID: <EADF0A36011179459010BDF5142A457501C9BF2AE1@pdsmsx502.ccr.corp.intel.com>
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

>From 9b174f63f42bb53dc8813e379196130c7fc19012 Mon Sep 17 00:00:00 2001
From: Dongxiao Xu <dongxiao.xu@intel.com>
Date: Sun, 31 May 2009 22:45:20 +0800
Subject: [PATCH] heci: fix spinlock order mess of device_lock and read_io_lock.

In orginal code, the device_lock and read_io_lock is mess order when nested,
which may bring dead lock. This patch unify the spinlock order of device_lock
and read_io_lock. First acquire device_lock, then read_io_lock.

Signed-off-by: Dongxiao Xu <dongxiao.xu@intel.com>
---
 drivers/staging/heci/heci_main.c |    2 +-
 drivers/staging/heci/io_heci.c   |   17 +++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/heci/heci_main.c b/drivers/staging/heci/heci_main.c
index ad62550..5494ab5 100644
--- a/drivers/staging/heci/heci_main.c
+++ b/drivers/staging/heci/heci_main.c
@@ -954,8 +954,8 @@ static ssize_t heci_read(struct file *file, char __user *ubuf,
 		goto out;
 	}
 
-	spin_lock(&file_ext->read_io_lock);
 	err = heci_start_read(dev, if_num, file_ext);
+	spin_lock(&file_ext->read_io_lock);
 	if (err != 0 && err != -EBUSY) {
 		DBG("heci start read failure with status = %d\n", err);
 		spin_unlock(&file_ext->read_io_lock);
diff --git a/drivers/staging/heci/io_heci.c b/drivers/staging/heci/io_heci.c
index 26882a2..8a44fd5 100644
--- a/drivers/staging/heci/io_heci.c
+++ b/drivers/staging/heci/io_heci.c
@@ -637,8 +637,9 @@ int heci_start_read(struct iamt_heci_device *dev, int if_num,
 		DBG("received wrong function input param.\n");
 		return -ENODEV;
 	}
-	if (file_ext->state != HECI_FILE_CONNECTED)
+	if (file_ext->state != HECI_FILE_CONNECTED) {
 		return -ENODEV;
+	}
 
 	spin_lock_bh(&dev->device_lock);
 	if (dev->heci_state != HECI_ENABLED) {
@@ -647,18 +648,26 @@ int heci_start_read(struct iamt_heci_device *dev, int if_num,
 	}
 	spin_unlock_bh(&dev->device_lock);
 	DBG("check if read is pending.\n");
+	spin_lock(&file_ext->read_io_lock);
 	if ((file_ext->read_pending) || (file_ext->read_cb != NULL)) {
 		DBG("read is pending.\n");
+		spin_unlock(&file_ext->read_io_lock);
 		return -EBUSY;
 	}
+	spin_unlock(&file_ext->read_io_lock);
+
 	priv_cb = kzalloc(sizeof(struct heci_cb_private), GFP_KERNEL);
 	if (!priv_cb)
 		return -ENOMEM;
 
+	spin_lock(&file_ext->read_io_lock);
 	DBG("allocation call back success\n"
 	    "host client = %d, ME client = %d\n",
 	    file_ext->host_client_id, file_ext->me_client_id);
+	spin_unlock(&file_ext->read_io_lock);
+
 	spin_lock_bh(&dev->device_lock);
+	spin_lock(&file_ext->read_io_lock);
 	for (i = 0; i < dev->num_heci_me_clients; i++) {
 		if (dev->me_clients[i].client_id == file_ext->me_client_id)
 			break;
@@ -666,6 +675,7 @@ int heci_start_read(struct iamt_heci_device *dev, int if_num,
 	}
 
 	BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+	spin_unlock(&file_ext->read_io_lock);
 	if (i == dev->num_heci_me_clients) {
 		rets = -ENODEV;
 		goto unlock;
@@ -684,12 +694,14 @@ int heci_start_read(struct iamt_heci_device *dev, int if_num,
 	/* make sure information is zero before we start */
 	priv_cb->information = 0;
 	priv_cb->file_private = (void *) file_ext;
-	file_ext->read_cb = priv_cb;
 	spin_lock_bh(&dev->device_lock);
+	spin_lock(&file_ext->read_io_lock);
+	file_ext->read_cb = priv_cb;
 	if (dev->host_buffer_is_empty) {
 		dev->host_buffer_is_empty = 0;
 		if (!heci_send_flow_control(dev, file_ext)) {
 			rets = -ENODEV;
+			spin_unlock(&file_ext->read_io_lock);
 			goto unlock;
 		} else {
 			list_add_tail(&priv_cb->cb_list,
@@ -699,6 +711,7 @@ int heci_start_read(struct iamt_heci_device *dev, int if_num,
 		list_add_tail(&priv_cb->cb_list,
 			      &dev->ctrl_wr_list.heci_cb.cb_list);
 	}
+	spin_unlock(&file_ext->read_io_lock);
 	spin_unlock_bh(&dev->device_lock);
 	return rets;
 unlock:
-- 
1.6.0.rc1


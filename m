Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZEaGpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZEaGpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 02:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbZEaGpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 02:45:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:13806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbZEaGpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 02:45:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,278,1241420400"; 
   d="scan'208,223";a="461985044"
From: "Xu, Dongxiao" <dongxiao.xu@intel.com>
To: "greg@kroah.com" <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Nashif, Anas" <anas.nashif@intel.com>,
       "Obara, Marcin" <marcin.obara@intel.com>
Date: Sun, 31 May 2009 14:44:01 +0800
Subject: [Patch 08/08] Staging: heci - fix the problem that file_ext->state
 should be protected by device_lock
Thread-Topic: [Patch 08/08] Staging: heci - fix the problem that
 file_ext->state should be protected by device_lock
Thread-Index: Acnhuy6nUpL//3ZlSDa9GAA9ty4c/g==
Message-ID: <EADF0A36011179459010BDF5142A457501C9BF2AE7@pdsmsx502.ccr.corp.intel.com>
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

>From cf69185666dea842619d16c6213e7c6f19a270bd Mon Sep 17 00:00:00 2001
From: Dongxiao Xu <dongxiao.xu@intel.com>
Date: Sun, 31 May 2009 22:53:21 +0800
Subject: [PATCH] heci: fix the problem that file_ext->state should be protected by device_lock.

While access file_ext->state, we should use device_lock to protect it. The
original codes miss this in some places.

Signed-off-by: Dongxiao Xu <dongxiao.xu@intel.com>
---
 drivers/staging/heci/heci_init.c |    9 +++++++--
 drivers/staging/heci/heci_main.c |   15 ++++++++++++---
 drivers/staging/heci/io_heci.c   |    8 +++++++-
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/heci/heci_init.c b/drivers/staging/heci/heci_init.c
index 427f55d..31fd891 100644
--- a/drivers/staging/heci/heci_init.c
+++ b/drivers/staging/heci/heci_init.c
@@ -998,8 +998,12 @@ int heci_disconnect_host_client(struct iamt_heci_device *dev,
 	if ((!dev) || (!file_ext))
 		return -ENODEV;
 
-	if (file_ext->state != HECI_FILE_DISCONNECTING)
+	spin_lock_bh(&dev->device_lock);
+	if (file_ext->state != HECI_FILE_DISCONNECTING) {
+		spin_unlock_bh(&dev->device_lock);
 		return 0;
+	}
+	spin_unlock_bh(&dev->device_lock);
 
 	priv_cb = kzalloc(sizeof(struct heci_cb_private), GFP_KERNEL);
 	if (!priv_cb)
@@ -1031,6 +1035,8 @@ int heci_disconnect_host_client(struct iamt_heci_device *dev,
 	err = wait_event_timeout(dev->wait_recvd_msg,
 		 (HECI_FILE_DISCONNECTED == file_ext->state),
 		 timeout * HZ);
+
+	spin_lock_bh(&dev->device_lock);
 	if (HECI_FILE_DISCONNECTED == file_ext->state) {
 		rets = 0;
 		DBG("successfully disconnected from fw client.\n");
@@ -1045,7 +1051,6 @@ int heci_disconnect_host_client(struct iamt_heci_device *dev,
 		DBG("failed to disconnect from fw client.\n");
 	}
 
-	spin_lock_bh(&dev->device_lock);
 	heci_flush_list(&dev->ctrl_rd_list, file_ext);
 	heci_flush_list(&dev->ctrl_wr_list, file_ext);
 	spin_unlock_bh(&dev->device_lock);
diff --git a/drivers/staging/heci/heci_main.c b/drivers/staging/heci/heci_main.c
index 1e2f3db..b58e7e3 100644
--- a/drivers/staging/heci/heci_main.c
+++ b/drivers/staging/heci/heci_main.c
@@ -751,7 +751,9 @@ static int heci_open(struct inode *inode, struct file *file)
 		(1 << (file_ext->host_client_id % 8));
 	spin_unlock_bh(&dev->device_lock);
 	spin_lock(&file_ext->file_lock);
+	spin_lock_bh(&dev->device_lock);
 	file_ext->state = HECI_FILE_INITIALIZING;
+	spin_unlock_bh(&dev->device_lock);
 	file_ext->sm_state = 0;
 
 	file->private_data = file_ext;
@@ -785,8 +787,10 @@ static int heci_release(struct inode *inode, struct file *file)
 
 	if (file_ext != &dev->iamthif_file_ext) {
 		spin_lock(&file_ext->file_lock);
+		spin_lock_bh(&dev->device_lock);
 		if (file_ext->state == HECI_FILE_CONNECTED) {
 			file_ext->state = HECI_FILE_DISCONNECTING;
+			spin_unlock_bh(&dev->device_lock);
 			spin_unlock(&file_ext->file_lock);
 			DBG("disconnecting client host client = %d, "
 			    "ME client = %d\n",
@@ -794,8 +798,8 @@ static int heci_release(struct inode *inode, struct file *file)
 			    file_ext->me_client_id);
 			rets = heci_disconnect_host_client(dev, file_ext);
 			spin_lock(&file_ext->file_lock);
+			spin_lock_bh(&dev->device_lock);
 		}
-		spin_lock_bh(&dev->device_lock);
 		heci_flush_queues(dev, file_ext);
 		DBG("remove client host client = %d, ME client = %d\n",
 		    file_ext->host_client_id,
@@ -983,12 +987,15 @@ static ssize_t heci_read(struct file *file, char __user *ubuf,
 			return -ERESTARTSYS;
 		}
 
+		spin_lock_bh(&dev->device_lock);
 		if (HECI_FILE_INITIALIZING == file_ext->state ||
 		    HECI_FILE_DISCONNECTED == file_ext->state ||
 		    HECI_FILE_DISCONNECTING == file_ext->state) {
+			spin_unlock_bh(&dev->device_lock);
 			rets = -EBUSY;
 			goto out;
 		}
+		spin_unlock_bh(&dev->device_lock);
 		spin_lock_bh(&file_ext->read_io_lock);
 	}
 
@@ -1225,6 +1232,7 @@ static ssize_t heci_write(struct file *file, const char __user *ubuf,
 	priv_write_cb->request_buffer.size = length;
 
 	spin_lock(&file_ext->write_io_lock);
+	spin_lock_bh(&dev->device_lock);
 	DBG("host client = %d, ME client = %d\n",
 	    file_ext->host_client_id, file_ext->me_client_id);
 	if (file_ext->state != HECI_FILE_CONNECTED) {
@@ -1232,7 +1240,7 @@ static ssize_t heci_write(struct file *file, const char __user *ubuf,
 		DBG("host client = %d,  is not connected to ME client = %d",
 		    file_ext->host_client_id,
 		    file_ext->me_client_id);
-
+		spin_unlock_bh(&dev->device_lock);
 		goto unlock;
 	}
 	for (i = 0; i < dev->num_heci_me_clients; i++) {
@@ -1243,15 +1251,16 @@ static ssize_t heci_write(struct file *file, const char __user *ubuf,
 	BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
 	if (i == dev->num_heci_me_clients) {
 		rets = -ENODEV;
+		spin_unlock_bh(&dev->device_lock);
 		goto unlock;
 	}
 	if (length > dev->me_clients[i].props.max_msg_length || length <= 0) {
 		rets = -EINVAL;
+		spin_unlock_bh(&dev->device_lock);
 		goto unlock;
 	}
 	priv_write_cb->file_private = file_ext;
 
-	spin_lock_bh(&dev->device_lock);
 	if (flow_ctrl_creds(dev, file_ext) &&
 		dev->host_buffer_is_empty) {
 		spin_unlock_bh(&dev->device_lock);
diff --git a/drivers/staging/heci/io_heci.c b/drivers/staging/heci/io_heci.c
index 8131470..dadbee3 100644
--- a/drivers/staging/heci/io_heci.c
+++ b/drivers/staging/heci/io_heci.c
@@ -297,6 +297,7 @@ int heci_ioctl_connect_client(struct iamt_heci_device *dev, int if_num,
 		if (!heci_connect(dev, file_ext)) {
 			rets = -ENODEV;
 			spin_unlock_bh(&dev->device_lock);
+			spin_unlock(&file_ext->file_lock);
 			goto end;
 		} else {
 			file_ext->timer_count = HECI_CONNECT_TIMEOUT;
@@ -320,7 +321,9 @@ int heci_ioctl_connect_client(struct iamt_heci_device *dev, int if_num,
 			 || HECI_FILE_DISCONNECTED == file_ext->state),
 			timeout * HZ);
 
+	spin_lock_bh(&dev->device_lock);
 	if (HECI_FILE_CONNECTED == file_ext->state) {
+		spin_unlock_bh(&dev->device_lock);
 		DBG("successfully connected to FW client.\n");
 		rets = file_ext->status;
 		/* now copy the data to user space */
@@ -337,6 +340,7 @@ int heci_ioctl_connect_client(struct iamt_heci_device *dev, int if_num,
 	} else {
 		DBG("failed to connect to FW client.file_ext->state = %d.\n",
 		    file_ext->state);
+		spin_unlock_bh(&dev->device_lock);
 		if (!err) {
 			DBG("wait_event_interruptible_timeout failed on client"
 			    " connect message fw response message.\n");
@@ -637,11 +641,13 @@ int heci_start_read(struct iamt_heci_device *dev, int if_num,
 		DBG("received wrong function input param.\n");
 		return -ENODEV;
 	}
+
+	spin_lock_bh(&dev->device_lock);
 	if (file_ext->state != HECI_FILE_CONNECTED) {
+		spin_unlock_bh(&dev->device_lock);
 		return -ENODEV;
 	}
 
-	spin_lock_bh(&dev->device_lock);
 	if (dev->heci_state != HECI_ENABLED) {
 		spin_unlock_bh(&dev->device_lock);
 		return -ENODEV;
-- 
1.6.0.rc1


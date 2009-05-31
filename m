Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbZEaGoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbZEaGoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 02:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbZEaGoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 02:44:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:4178 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbZEaGoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 02:44:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,278,1241420400"; 
   d="scan'208,223";a="417224687"
From: "Xu, Dongxiao" <dongxiao.xu@intel.com>
To: "greg@kroah.com" <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Nashif, Anas" <anas.nashif@intel.com>,
       "Obara, Marcin" <marcin.obara@intel.com>
Date: Sun, 31 May 2009 14:43:35 +0800
Subject: [Patch 01/08] Staging: heci - fix userspace pointer mess
Thread-Topic: [Patch 01/08] Staging: heci - fix userspace pointer mess
Thread-Index: Acnhux8RnvYbAdtbTWye/jIuKM6qEQ==
Message-ID: <EADF0A36011179459010BDF5142A457501C9BF2ADF@pdsmsx502.ccr.corp.intel.com>
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

>From 19494a7b1de08e3c04c0d60c6e6a41ef6531bc0d Mon Sep 17 00:00:00 2001
From: Dongxiao Xu <dongxiao.xu@intel.com>
Date: Sun, 31 May 2009 22:43:30 +0800
Subject: [PATCH] heci: fix userspace pointer mess.

Fix userspace pointer mess.
 - In memcmp(), dest and src pointer should be both in kernel space.
 - Add (void __user *) modification before userspace pointer.

Signed-off-by: Dongxiao Xu <dongxiao.xu@intel.com>
---
 drivers/staging/heci/heci_main.c |    9 ++++++---
 drivers/staging/heci/io_heci.c   |   15 +++++++++------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/heci/heci_main.c b/drivers/staging/heci/heci_main.c
index 00e44c7..ad62550 100644
--- a/drivers/staging/heci/heci_main.c
+++ b/drivers/staging/heci/heci_main.c
@@ -1140,9 +1140,12 @@ static ssize_t heci_write(struct file *file, const char __user *ubuf,
 	spin_lock(&file_ext->file_lock);
 	file_ext->sm_state = 0;
 	if ((length == 4) &&
-	    ((memcmp(heci_wd_state_independence_msg[0], ubuf, 4) == 0) ||
-	     (memcmp(heci_wd_state_independence_msg[1], ubuf, 4) == 0) ||
-	     (memcmp(heci_wd_state_independence_msg[2], ubuf, 4) == 0)))
+	    ((memcmp(heci_wd_state_independence_msg[0], 
+				 priv_write_cb->request_buffer.data, 4) == 0) ||
+	     (memcmp(heci_wd_state_independence_msg[1], 
+				 priv_write_cb->request_buffer.data, 4) == 0) ||
+	     (memcmp(heci_wd_state_independence_msg[2], 
+				 priv_write_cb->request_buffer.data, 4) == 0)))
 		file_ext->sm_state |= HECI_WD_STATE_INDEPENDENCE_MSG_SENT;
 	spin_unlock(&file_ext->file_lock);
 
diff --git a/drivers/staging/heci/io_heci.c b/drivers/staging/heci/io_heci.c
index f7544a7..ff6d294 100644
--- a/drivers/staging/heci/io_heci.c
+++ b/drivers/staging/heci/io_heci.c
@@ -111,7 +111,7 @@ int heci_ioctl_get_version(struct iamt_heci_device *dev, int if_num,
 
 	rets = file_ext->status;
 	/* now copy the data to user space */
-	if (copy_to_user(k_msg.data, res_msg.data, res_msg.size)) {
+	if (copy_to_user((void __user *)k_msg.data, res_msg.data, res_msg.size)) {
 		rets = -EFAULT;
 		goto end;
 	}
@@ -188,7 +188,7 @@ int heci_ioctl_connect_client(struct iamt_heci_device *dev, int if_num,
 	/* copy the message to kernel space -
 	 * use a pointer already copied into kernel space
 	 */
-	if (copy_from_user(req_msg.data, k_msg.data, k_msg.size)) {
+	if (copy_from_user(req_msg.data, (void __user *)k_msg.data, k_msg.size)) {
 		rets = -EFAULT;
 		goto end;
 	}
@@ -266,7 +266,8 @@ int heci_ioctl_connect_client(struct iamt_heci_device *dev, int if_num,
 		spin_unlock_bh(&dev->device_lock);
 
 		/* now copy the data to user space */
-		if (copy_to_user(k_msg.data, res_msg.data, res_msg.size)) {
+		if (copy_to_user((void __user *)k_msg.data, 
+					res_msg.data, res_msg.size)) {
 			rets = -EFAULT;
 			goto end;
 		}
@@ -320,7 +321,8 @@ int heci_ioctl_connect_client(struct iamt_heci_device *dev, int if_num,
 		DBG("successfully connected to FW client.\n");
 		rets = file_ext->status;
 		/* now copy the data to user space */
-		if (copy_to_user(k_msg.data, res_msg.data, res_msg.size)) {
+		if (copy_to_user((void __user *)k_msg.data, 
+					res_msg.data, res_msg.size)) {
 			rets = -EFAULT;
 			goto end;
 		}
@@ -394,7 +396,8 @@ int heci_ioctl_wd(struct iamt_heci_device *dev, int if_num,
 	/* copy the message to kernel space - use a pointer already
 	 * copied into kernel space
 	 */
-	if (copy_from_user(req_msg.data, k_msg.data, req_msg.size)) {
+	if (copy_from_user(req_msg.data, 
+				(void __user *)k_msg.data, req_msg.size)) {
 		rets = -EFAULT;
 		goto end;
 	}
@@ -464,7 +467,7 @@ int heci_ioctl_bypass_wd(struct iamt_heci_device *dev, int if_num,
 		return -EMSGSIZE;
 	}
 	spin_unlock(&file_ext->file_lock);
-	if (copy_from_user(&flag, k_msg.data, 1)) {
+	if (copy_from_user(&flag, (void __user *)k_msg.data, 1)) {
 		rets = -EFAULT;
 		goto end;
 	}
-- 
1.6.0.rc1


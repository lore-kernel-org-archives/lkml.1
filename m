Return-Path: <linux-kernel-owner+w=401wt.eu-S936369AbZFPFzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936369AbZFPFzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZFPFvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:07 -0400
Received: from kroah.org ([198.145.64.141]:48337 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759898AbZFPFvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Marcel Holtmann <holtmann@linux.intel.com>,
       John Linville <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/64] firmware: allocate firmware id dynamically
Date: Mon, 15 Jun 2009 22:46:05 -0700
Message-Id: <1245131213-24168-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

The firmware loader has a statically allocated 30 bytes long string for
the firmware id (a.k.a. the firmware file name). There is no reason why
we couldnt allocate it dynamically, and avoid having restrictions on the
firmware names lengths.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
Cc: John Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 2427702..3591ba7 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -40,7 +40,7 @@ static int loading_timeout = 60;	/* In seconds */
 static DEFINE_MUTEX(fw_lock);
 
 struct firmware_priv {
-	char fw_id[FIRMWARE_NAME_MAX];
+	char *fw_id;
 	struct completion completion;
 	struct bin_attribute attr_data;
 	struct firmware *fw;
@@ -355,6 +355,7 @@ static void fw_dev_release(struct device *dev)
 	for (i = 0; i < fw_priv->nr_pages; i++)
 		__free_page(fw_priv->pages[i]);
 	kfree(fw_priv->pages);
+	kfree(fw_priv->fw_id);
 	kfree(fw_priv);
 	put_device(dev);
 
@@ -386,7 +387,13 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 
 	init_completion(&fw_priv->completion);
 	fw_priv->attr_data = firmware_attr_data_tmpl;
-	strlcpy(fw_priv->fw_id, fw_name, FIRMWARE_NAME_MAX);
+	fw_priv->fw_id = kstrdup(fw_name, GFP_KERNEL);
+	if (!fw_priv->fw_id) {
+		dev_err(device, "%s: Firmware name allocation failed\n",
+			__func__);
+		retval = -ENOMEM;
+		goto error_kfree;
+	}
 
 	fw_priv->timeout.function = firmware_class_timeout;
 	fw_priv->timeout.data = (u_long) fw_priv;
@@ -401,14 +408,15 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	if (retval) {
 		dev_err(device, "%s: device_register failed\n", __func__);
 		put_device(f_dev);
-		goto error_kfree1;
+		goto error_kfree_fw_id;
 	}
 	*dev_p = f_dev;
 	return 0;
 
+error_kfree_fw_id:
+	kfree(fw_priv->fw_id);
 error_kfree:
 	kfree(f_dev);
-error_kfree1:
 	kfree(fw_priv);
 	return retval;
 }
-- 
1.6.3.2


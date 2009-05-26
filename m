Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbZEZWuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbZEZWuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760144AbZEZWtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:49:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:36753 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760146AbZEZWtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:49:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,254,1241420400"; 
   d="scan'208";a="415865812"
Message-Id: <20090526225120.078277700@linux.intel.com>
References: <20090526224930.145059254@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 00:49:31 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: inux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samuel Ortiz <sameo@linux.intel.com>,
       Marcel Holtmann <holtmann@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>,
       John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/7 v2] firmware: allocate firmware id dynamically
Content-Disposition: inline; filename=firmware_class.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

The firmware loader has a statically allocated 30 bytes long string for the
firmware id (a.k.a. the firmware file name). There is no reason why we couldnt
allocate it dynamically, and avoid having restrictions on the firmware names
lengths.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
Cc: John Linville <linville@tuxdriver.com>

---
 drivers/base/firmware_class.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Index: iwm-2.6/drivers/base/firmware_class.c
===================================================================
--- iwm-2.6.orig/drivers/base/firmware_class.c	2009-05-26 16:30:41.000000000 +0200
+++ iwm-2.6/drivers/base/firmware_class.c	2009-05-26 16:37:20.000000000 +0200
@@ -40,7 +40,7 @@ static int loading_timeout = 60;	/* In s
 static DEFINE_MUTEX(fw_lock);
 
 struct firmware_priv {
-	char fw_id[FIRMWARE_NAME_MAX];
+	char *fw_id;
 	struct completion completion;
 	struct bin_attribute attr_data;
 	struct firmware *fw;
@@ -278,6 +278,7 @@ static void fw_dev_release(struct device
 {
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
 
+	kfree(fw_priv->fw_id);
 	kfree(fw_priv);
 	kfree(dev);
 
@@ -309,7 +310,13 @@ static int fw_register_device(struct dev
 
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
@@ -323,11 +330,14 @@ static int fw_register_device(struct dev
 	retval = device_register(f_dev);
 	if (retval) {
 		dev_err(device, "%s: device_register failed\n", __func__);
-		goto error_kfree;
+		goto error_kfree_fw_id;
 	}
 	*dev_p = f_dev;
 	return 0;
 
+error_kfree_fw_id:
+	kfree(fw_priv->fw_id);
+
 error_kfree:
 	kfree(fw_priv);
 	kfree(f_dev);

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

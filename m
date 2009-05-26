Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZEZOC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZEZOC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 10:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbZEZOCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 10:02:16 -0400
Received: from mga06.intel.com ([134.134.136.21]:39336 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754393AbZEZOCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 10:02:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,251,1241420400"; 
   d="scan'208";a="415714190"
Date: Tue, 26 May 2009 16:04:25 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Marcel Holtmann <holtmann@linux.intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: [PATCH] firmware: Allocate firmware id dynamically
Message-ID: <20090526140423.GA14683@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Since the firmware loader is not maintained by anyone, I'm sending this one to
you, for the next merge window:

From: Samuel Ortiz <sameo@linux.intel.com>

The firmware loader has a statically allocated 30 bytes long string for the
firmware id (a.k.a. the firmware file name). There is no reason why we couldnt
allocate dynamically, and avoid having restrictions on the firmware names
lengths.
Please note that we have to keep the FIRMWARE_NAME_MAX definition around as
some drivers rely on it.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---

 drivers/base/firmware_class.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d3a59c6..1f0daf9 100644
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
@@ -278,6 +278,7 @@ static void fw_dev_release(struct device *dev)
 {
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
 
+	kfree(fw_priv->fw_id);
 	kfree(fw_priv);
 	kfree(dev);
 
@@ -309,7 +310,13 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 
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
@@ -323,11 +330,14 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
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

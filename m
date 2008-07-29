Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbYG2W65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbYG2W65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbYG2W6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:58:49 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:36207 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918AbYG2W6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:58:48 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] firmware: use dev_printk when possible
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Tue, 29 Jul 2008 16:58:30 -0600
Message-ID: <20080729225758.28730.40730.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Convert printks to use dev_printk().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/base/firmware_class.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)


diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c9c92b0..b7e5710 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -164,8 +164,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 		}
 		/* fallthrough */
 	default:
-		printk(KERN_ERR "%s: unexpected value (%d)\n", __func__,
-		       loading);
+		dev_err(dev, "%s: unexpected value (%d)\n", __func__, loading);
 		/* fallthrough */
 	case -1:
 		fw_load_abort(fw_priv);
@@ -309,7 +308,7 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	*dev_p = NULL;
 
 	if (!fw_priv || !f_dev) {
-		printk(KERN_ERR "%s: kmalloc failed\n", __func__);
+		dev_err(device, "%s: kmalloc failed\n", __func__);
 		retval = -ENOMEM;
 		goto error_kfree;
 	}
@@ -329,8 +328,7 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	f_dev->uevent_suppress = 1;
 	retval = device_register(f_dev);
 	if (retval) {
-		printk(KERN_ERR "%s: device_register failed\n",
-		       __func__);
+		dev_err(device, "%s: device_register failed\n", __func__);
 		goto error_kfree;
 	}
 	*dev_p = f_dev;
@@ -363,15 +361,13 @@ static int fw_setup_device(struct firmware *fw, struct device **dev_p,
 	fw_priv->fw = fw;
 	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
 	if (retval) {
-		printk(KERN_ERR "%s: sysfs_create_bin_file failed\n",
-		       __func__);
+		dev_err(device, "%s: sysfs_create_bin_file failed\n", __func__);
 		goto error_unreg;
 	}
 
 	retval = device_create_file(f_dev, &dev_attr_loading);
 	if (retval) {
-		printk(KERN_ERR "%s: device_create_file failed\n",
-		       __func__);
+		dev_err(device, "%s: device_create_file failed\n", __func__);
 		goto error_unreg;
 	}
 
@@ -401,8 +397,8 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
-		printk(KERN_ERR "%s: kmalloc(struct firmware) failed\n",
-		       __func__);
+		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
+			__func__);
 		retval = -ENOMEM;
 		goto out;
 	}
@@ -411,15 +407,15 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	     builtin++) {
 		if (strcmp(name, builtin->name))
 			continue;
-		printk(KERN_INFO "firmware: using built-in firmware %s\n",
-		       name);
+		dev_info(device, "firmware: using built-in firmware %s\n",
+			 name);
 		firmware->size = builtin->size;
 		firmware->data = builtin->data;
 		return 0;
 	}
 
 	if (uevent)
-		printk(KERN_INFO "firmware: requesting %s\n", name);
+		dev_info(device, "firmware: requesting %s\n", name);
 
 	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
 	if (retval)


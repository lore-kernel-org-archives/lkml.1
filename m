Return-Path: <linux-kernel-owner+w=401wt.eu-S1762776AbZLKWZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762776AbZLKWZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762764AbZLKWZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:25:18 -0500
Received: from kroah.org ([198.145.64.141]:32784 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762710AbZLKWY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:24:59 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Ming Lei <tom.leiming@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Pavel Roskin <proski@gnu.org>, Abhay Salunke <abhay_salunke@dell.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/27] firmware_class: make request_firmware_nowait more useful
Date: Fri, 11 Dec 2009 14:24:31 -0800
Message-Id: <1260570289-6997-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

Unfortunately, one cannot hold on to the struct firmware
that request_firmware_nowait() hands off, which is needed
in some cases. Allow this by requiring the callback to
free it (via release_firmware).

Additionally, give it a gfp_t parameter -- all the current
users call it from a GFP_KERNEL context so the GFP_ATOMIC
isn't necessary. This also marks an API break which is
useful in a sense, although that is obviously not the
primary purpose of this change.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Pavel Roskin <proski@gnu.org>
Cc: Abhay Salunke <abhay_salunke@dell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c               |   14 ++++++--------
 drivers/firmware/dell_rbu.c                 |    9 +++++++--
 drivers/serial/ucc_uart.c                   |    8 +++++---
 drivers/staging/comedi/drivers/usbdux.c     |    5 ++++-
 drivers/staging/comedi/drivers/usbduxfast.c |    5 ++++-
 drivers/usb/atm/ueagle-atm.c                |    7 ++++---
 include/linux/firmware.h                    |    5 +++--
 7 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 7376367..a950241 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -601,12 +601,9 @@ request_firmware_work_func(void *arg)
 	}
 	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
 		fw_work->uevent);
-	if (ret < 0)
-		fw_work->cont(NULL, fw_work->context);
-	else {
-		fw_work->cont(fw, fw_work->context);
-		release_firmware(fw);
-	}
+
+	fw_work->cont(fw, fw_work->context);
+
 	module_put(fw_work->module);
 	kfree(fw_work);
 	return ret;
@@ -619,6 +616,7 @@ request_firmware_work_func(void *arg)
  *	is non-zero else the firmware copy must be done manually.
  * @name: name of firmware file
  * @device: device for which firmware is being loaded
+ * @gfp: allocation flags
  * @context: will be passed over to @cont, and
  *	@fw may be %NULL if firmware request fails.
  * @cont: function will be called asynchronously when the firmware
@@ -631,12 +629,12 @@ request_firmware_work_func(void *arg)
 int
 request_firmware_nowait(
 	struct module *module, int uevent,
-	const char *name, struct device *device, void *context,
+	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
 	struct task_struct *task;
 	struct firmware_work *fw_work = kmalloc(sizeof (struct firmware_work),
-						GFP_ATOMIC);
+						gfp);
 
 	if (!fw_work)
 		return -ENOMEM;
diff --git a/drivers/firmware/dell_rbu.c b/drivers/firmware/dell_rbu.c
index b4704e1..b3a0cf5 100644
--- a/drivers/firmware/dell_rbu.c
+++ b/drivers/firmware/dell_rbu.c
@@ -544,9 +544,12 @@ static void callbackfn_rbu(const struct firmware *fw, void *context)
 {
 	rbu_data.entry_created = 0;
 
-	if (!fw || !fw->size)
+	if (!fw)
 		return;
 
+	if (!fw->size)
+		goto out;
+
 	spin_lock(&rbu_data.lock);
 	if (!strcmp(image_type, "mono")) {
 		if (!img_update_realloc(fw->size))
@@ -568,6 +571,8 @@ static void callbackfn_rbu(const struct firmware *fw, void *context)
 	} else
 		pr_debug("invalid image type specified.\n");
 	spin_unlock(&rbu_data.lock);
+ out:
+	release_firmware(fw);
 }
 
 static ssize_t read_rbu_image_type(struct kobject *kobj,
@@ -615,7 +620,7 @@ static ssize_t write_rbu_image_type(struct kobject *kobj,
 			spin_unlock(&rbu_data.lock);
 			req_firm_rc = request_firmware_nowait(THIS_MODULE,
 				FW_ACTION_NOHOTPLUG, "dell_rbu",
-				&rbu_device->dev, &context,
+				&rbu_device->dev, GFP_KERNEL, &context,
 				callbackfn_rbu);
 			if (req_firm_rc) {
 				printk(KERN_ERR
diff --git a/drivers/serial/ucc_uart.c b/drivers/serial/ucc_uart.c
index 46de564..465f2fa 100644
--- a/drivers/serial/ucc_uart.c
+++ b/drivers/serial/ucc_uart.c
@@ -1179,16 +1179,18 @@ static void uart_firmware_cont(const struct firmware *fw, void *context)
 
 	if (firmware->header.length != fw->size) {
 		dev_err(dev, "invalid firmware\n");
-		return;
+		goto out;
 	}
 
 	ret = qe_upload_firmware(firmware);
 	if (ret) {
 		dev_err(dev, "could not load firmware\n");
-		return;
+		goto out;
 	}
 
 	firmware_loaded = 1;
+ out:
+	release_firmware(fw);
 }
 
 static int ucc_uart_probe(struct of_device *ofdev,
@@ -1247,7 +1249,7 @@ static int ucc_uart_probe(struct of_device *ofdev,
 			 */
 			ret = request_firmware_nowait(THIS_MODULE,
 				FW_ACTION_HOTPLUG, filename, &ofdev->dev,
-				&ofdev->dev, uart_firmware_cont);
+				GFP_KERNEL, &ofdev->dev, uart_firmware_cont);
 			if (ret) {
 				dev_err(&ofdev->dev,
 					"could not load firmware %s\n",
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index cca4e86..dfcd12b 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2327,9 +2327,11 @@ static void usbdux_firmware_request_complete_handler(const struct firmware *fw,
 	if (ret) {
 		dev_err(&usbdev->dev,
 			"Could not upload firmware (err=%d)\n", ret);
-		return;
+		goto out;
 	}
 	comedi_usb_auto_config(usbdev, BOARDNAME);
+ out:
+	release_firmware(fw);
 }
 
 /* allocate memory for the urbs and initialise them */
@@ -2580,6 +2582,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 				      FW_ACTION_HOTPLUG,
 				      "usbdux_firmware.bin",
 				      &udev->dev,
+				      GFP_KERNEL,
 				      usbduxsub + index,
 				      usbdux_firmware_request_complete_handler);
 
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index d143222..2e675cc 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1451,10 +1451,12 @@ static void usbduxfast_firmware_request_complete_handler(const struct firmware
 	if (ret) {
 		dev_err(&usbdev->dev,
 			"Could not upload firmware (err=%d)\n", ret);
-		return;
+		goto out;
 	}
 
 	comedi_usb_auto_config(usbdev, BOARDNAME);
+ out:
+	release_firmware(fw);
 }
 
 /*
@@ -1569,6 +1571,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 				      FW_ACTION_HOTPLUG,
 				      "usbduxfast_firmware.bin",
 				      &udev->dev,
+				      GFP_KERNEL,
 				      usbduxfastsub + index,
 				      usbduxfast_firmware_request_complete_handler);
 
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index bba4d3e..c539524 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -667,12 +667,12 @@ static void uea_upload_pre_firmware(const struct firmware *fw_entry, void *conte
 	else
 		uea_info(usb, "firmware uploaded\n");
 
-	uea_leaves(usb);
-	return;
+	goto err;
 
 err_fw_corrupted:
 	uea_err(usb, "firmware is corrupted\n");
 err:
+	release_firmware(fw_entry);
 	uea_leaves(usb);
 }
 
@@ -705,7 +705,8 @@ static int uea_load_firmware(struct usb_device *usb, unsigned int ver)
 		break;
 	}
 
-	ret = request_firmware_nowait(THIS_MODULE, 1, fw_name, &usb->dev, usb, uea_upload_pre_firmware);
+	ret = request_firmware_nowait(THIS_MODULE, 1, fw_name, &usb->dev,
+				      GFP_KERNEL, usb, uea_upload_pre_firmware);
 	if (ret)
 		uea_err(usb, "firmware %s is not available\n", fw_name);
 	else
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index d315446..043811f 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/gfp.h>
 
 #define FW_ACTION_NOHOTPLUG 0
 #define FW_ACTION_HOTPLUG 1
@@ -38,7 +39,7 @@ int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
 int request_firmware_nowait(
 	struct module *module, int uevent,
-	const char *name, struct device *device, void *context,
+	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context));
 
 void release_firmware(const struct firmware *fw);
@@ -51,7 +52,7 @@ static inline int request_firmware(const struct firmware **fw,
 }
 static inline int request_firmware_nowait(
 	struct module *module, int uevent,
-	const char *name, struct device *device, void *context,
+	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
 	return -EINVAL;
-- 
1.6.5.5


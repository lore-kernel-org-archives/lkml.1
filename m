Return-Path: <linux-kernel-owner+w=401wt.eu-S1032432AbXFIAFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032432AbXFIAFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031854AbXFIAEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:04:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:48284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969181AbXFIAEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:04:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Simon Arlott <simon@fire.lp0.eu>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/9] USB: cxacru: create sysfs attributes in atm_start instead of bind
Date: Fri,  8 Jun 2007 17:03:51 -0700
Message-Id: <11813474771075-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <11813474672336-git-send-email-gregkh@suse.de>
References: <20070609000312.GA17574@kroah.com>
 <11813474343815-git-send-email-gregkh@suse.de>
 <1181347441440-git-send-email-gregkh@suse.de>
 <11813474492376-git-send-email-gregkh@suse.de>
 <118134746039-git-send-email-gregkh@suse.de>
 <11813474672336-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Arlott <simon@fire.lp0.eu>

Since usbatm doesn't set the usb_interface driver data until after calling
bind and heavy_init, it would be NULL when the sysfs attributes are read.
Reading the MAC address from atm_dev before atm_dev exists would have been
be possible too.

Calling create_device_file in atm_start will avoid this problem, and the
data is useless until the first status poll runs.  However, it must be
ready before a status poll does a printk on line status change otherwise
userspace could react before the files exist.

For completeness I've moved remove_device_file to atm_stop so it's not
called in unbind when it's not needed.  There's no point starting ADSL if
atm_start could still fail either.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/atm/cxacru.c |   45 +++++++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 30b7bfb..68cf582 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -629,10 +629,22 @@ static int cxacru_card_status(struct cxacru_data *instance)
 	return 0;
 }
 
+static void cxacru_remove_device_files(struct usbatm_data *usbatm_instance,
+		struct atm_dev *atm_dev)
+{
+	struct usb_interface *intf = usbatm_instance->usb_intf;
+
+	#define CXACRU_DEVICE_REMOVE_FILE(_name) \
+		device_remove_file(&intf->dev, &dev_attr_##_name);
+	CXACRU_ALL_FILES(REMOVE);
+	#undef CXACRU_DEVICE_REMOVE_FILE
+}
+
 static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
 		struct atm_dev *atm_dev)
 {
 	struct cxacru_data *instance = usbatm_instance->driver_data;
+	struct usb_interface *intf = usbatm_instance->usb_intf;
 	/*
 	struct atm_dev *atm_dev = usbatm_instance->atm_dev;
 	*/
@@ -649,6 +661,13 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
 		return ret;
 	}
 
+	#define CXACRU_DEVICE_CREATE_FILE(_name) \
+		ret = device_create_file(&intf->dev, &dev_attr_##_name); \
+		if (unlikely(ret)) \
+			goto fail_sysfs;
+	CXACRU_ALL_FILES(CREATE);
+	#undef CXACRU_DEVICE_CREATE_FILE
+
 	/* start ADSL */
 	mutex_lock(&instance->adsl_state_serialize);
 	ret = cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_START, NULL, 0, NULL, 0);
@@ -680,6 +699,11 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
 	if (start_polling)
 		cxacru_poll_status(&instance->poll_work.work);
 	return 0;
+
+fail_sysfs:
+	usb_err(usbatm_instance, "cxacru_atm_start: device_create_file failed (%d)\n", ret);
+	cxacru_remove_device_files(usbatm_instance, atm_dev);
+	return ret;
 }
 
 static void cxacru_poll_status(struct work_struct *work)
@@ -1065,13 +1089,6 @@ static int cxacru_bind(struct usbatm_data *usbatm_instance,
 		goto fail;
 	}
 
-	#define CXACRU_DEVICE_CREATE_FILE(_name) \
-		ret = device_create_file(&intf->dev, &dev_attr_##_name); \
-		if (unlikely(ret)) \
-			goto fail_sysfs;
-	CXACRU_ALL_FILES(CREATE);
-	#undef CXACRU_DEVICE_CREATE_FILE
-
 	usb_fill_int_urb(instance->rcv_urb,
 			usb_dev, usb_rcvintpipe(usb_dev, CXACRU_EP_CMD),
 			instance->rcv_buf, PAGE_SIZE,
@@ -1092,14 +1109,6 @@ static int cxacru_bind(struct usbatm_data *usbatm_instance,
 
 	return 0;
 
- fail_sysfs:
-	dbg("cxacru_bind: device_create_file failed (%d)\n", ret);
-
-	#define CXACRU_DEVICE_REMOVE_FILE(_name) \
-		device_remove_file(&intf->dev, &dev_attr_##_name);
-	CXACRU_ALL_FILES(REMOVE);
-	#undef CXACRU_DEVICE_REVOVE_FILE
-
  fail:
 	free_page((unsigned long) instance->snd_buf);
 	free_page((unsigned long) instance->rcv_buf);
@@ -1146,11 +1155,6 @@ static void cxacru_unbind(struct usbatm_data *usbatm_instance,
 	free_page((unsigned long) instance->snd_buf);
 	free_page((unsigned long) instance->rcv_buf);
 
-	#define CXACRU_DEVICE_REMOVE_FILE(_name) \
-		device_remove_file(&intf->dev, &dev_attr_##_name);
-	CXACRU_ALL_FILES(REMOVE);
-	#undef CXACRU_DEVICE_REVOVE_FILE
-
 	kfree(instance);
 
 	usbatm_instance->driver_data = NULL;
@@ -1231,6 +1235,7 @@ static struct usbatm_driver cxacru_driver = {
 	.heavy_init	= cxacru_heavy_init,
 	.unbind		= cxacru_unbind,
 	.atm_start	= cxacru_atm_start,
+	.atm_stop	= cxacru_remove_device_files,
 	.bulk_in	= CXACRU_EP_DATA,
 	.bulk_out	= CXACRU_EP_DATA,
 	.rx_padding	= 3,
-- 
1.5.2.1


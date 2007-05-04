Return-Path: <linux-kernel-owner+w=401wt.eu-S1031423AbXEDRD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031423AbXEDRD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031424AbXEDRD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:03:28 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:43685 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031423AbXEDRD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:03:26 -0400
Message-ID: <463B675A.10900@simon.arlott.org.uk>
Date: Fri, 04 May 2007 18:03:22 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Duncan Sands <duncan.sands@math.u-psud.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Lichota <krzysiek@lichota.net>
Subject: [PATCH 1/2] cxacru: Create sysfs attributes in atm_start instead
 of bind
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since usbatm doesn't set the usb_interface driver data until after calling bind 
and heavy_init, it would be NULL when the sysfs attributes are read. Reading the 
MAC address from atm_dev before atm_dev exists would have been be possible too.

Calling create_device_file in atm_start will avoid this problem, and the data 
is useless until the first status poll runs. However, it must be ready before a 
status poll does a printk on line status change otherwise userspace could react 
before the files exist.

For completeness I've moved remove_device_file to atm_stop so it's not called in 
unbind when it's not needed.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
---
This is a resend of my email 28/04/07 with part of the description removed due 
to patch 2/2.

> #undef CXACRU_DEVICE_REVOVE_FILE
Oops.

drivers/usb/atm/cxacru.c |   45 +++++++++++++++++++++++++--------------------
1 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 0b12ace..4ecb4c7 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -618,10 +618,22 @@ static int cxacru_card_status(struct cxacru_data *instance)
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
@@ -638,6 +650,13 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
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
@@ -669,6 +688,11 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
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
@@ -1054,13 +1078,6 @@ static int cxacru_bind(struct usbatm_data *usbatm_instance,
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
@@ -1081,14 +1098,6 @@ static int cxacru_bind(struct usbatm_data *usbatm_instance,

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
@@ -1135,11 +1144,6 @@ static void cxacru_unbind(struct usbatm_data *usbatm_instance,
	free_page((unsigned long) instance->snd_buf);
	free_page((unsigned long) instance->rcv_buf);

-	#define CXACRU_DEVICE_REMOVE_FILE(_name) \
-		device_remove_file(&intf->dev, &dev_attr_##_name);
-	CXACRU_ALL_FILES(REMOVE);
-	#undef CXACRU_DEVICE_REVOVE_FILE
-
	kfree(instance);

	usbatm_instance->driver_data = NULL;
@@ -1220,6 +1224,7 @@ static struct usbatm_driver cxacru_driver = {
	.heavy_init	= cxacru_heavy_init,
	.unbind		= cxacru_unbind,
	.atm_start	= cxacru_atm_start,
+	.atm_stop	= cxacru_remove_device_files,
	.bulk_in	= CXACRU_EP_DATA,
	.bulk_out	= CXACRU_EP_DATA,
	.rx_padding	= 3,
-- 
1.5.0.1

-- 
Simon Arlott


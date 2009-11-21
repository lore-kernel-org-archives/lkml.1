Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbZKUPZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbZKUPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZKUPZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:25:57 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:39192 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbZKUPRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:17:25 -0500
Message-ID: <4B080344.5030104@simon.arlott.org.uk>
Date: Sat, 21 Nov 2009 15:12:04 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090927)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
CC: Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: [PATCH 3/8] cxacru: check device isn't being removed during sysfs
 calls
References: <4B08013B.90403@simon.arlott.org.uk>
In-Reply-To: <4B08013B.90403@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible for usb_get_intfdata() to return NULL if
sysfs is accessed while the module is being unloaded or
the device is being removed.

Move the access code to inline functions in usbatm.h,
and return -ENODEV if any of the pointers is NULL.

It should not be possible for the instance data or atm
device to be invalid until after unbind() completes and
the sysfs attributes have been removed.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c |   45 ++++++++++++++++++++++++++-------------------
 drivers/usb/atm/usbatm.c |    1 +
 drivers/usb/atm/usbatm.h |   30 ++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 8da4a06..f2e7414 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -200,9 +200,12 @@ static DEVICE_ATTR(_name, S_IWUSR | S_IRUGO, \
 static ssize_t cxacru_sysfs_show_##_name(struct device *dev, \
 	struct device_attribute *attr, char *buf) \
 { \
-	struct usb_interface *intf = to_usb_interface(dev); \
-	struct usbatm_data *usbatm_instance = usb_get_intfdata(intf); \
-	struct cxacru_data *instance = usbatm_instance->driver_data; \
+	struct cxacru_data *instance = to_usbatm_driver_data(\
+		to_usb_interface(dev)); \
+\
+	if (instance == NULL) \
+		return -ENODEV; \
+\
 	return cxacru_sysfs_showattr_##_type(instance->card_info[_value], buf); \
 } \
 CXACRU__ATTR_INIT(_name)
@@ -288,9 +291,11 @@ static ssize_t cxacru_sysfs_showattr_MODU(u32 value, char *buf)
 static ssize_t cxacru_sysfs_show_mac_address(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct usbatm_data *usbatm_instance = usb_get_intfdata(intf);
-	struct atm_dev *atm_dev = usbatm_instance->atm_dev;
+	struct atm_dev *atm_dev = to_usbatm_atm_dev(
+			to_usb_interface(dev));
+
+	if (atm_dev == NULL)
+		return -ENODEV;
 
 	return snprintf(buf, PAGE_SIZE, "%pM\n", atm_dev->esi);
 }
@@ -298,12 +303,15 @@ static ssize_t cxacru_sysfs_show_mac_address(struct device *dev,
 static ssize_t cxacru_sysfs_show_adsl_state(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct usbatm_data *usbatm_instance = usb_get_intfdata(intf);
-	struct cxacru_data *instance = usbatm_instance->driver_data;
-	u32 value = instance->card_info[CXINF_LINE_STARTABLE];
-
 	static char *str[] = { "running", "stopped" };
+	struct cxacru_data *instance = to_usbatm_driver_data(
+			to_usb_interface(dev));
+	u32 value;
+
+	if (instance == NULL)
+		return -ENODEV;
+
+	value = instance->card_info[CXINF_LINE_STARTABLE];
 	if (unlikely(value >= ARRAY_SIZE(str)))
 		return snprintf(buf, PAGE_SIZE, "%u\n", value);
 	return snprintf(buf, PAGE_SIZE, "%s\n", str[value]);
@@ -312,9 +320,8 @@ static ssize_t cxacru_sysfs_show_adsl_state(struct device *dev,
 static ssize_t cxacru_sysfs_store_adsl_state(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct usbatm_data *usbatm_instance = usb_get_intfdata(intf);
-	struct cxacru_data *instance = usbatm_instance->driver_data;
+	struct cxacru_data *instance = to_usbatm_driver_data(
+			to_usb_interface(dev));
 	int ret;
 	int poll = -1;
 	char str_cmd[8];
@@ -328,13 +335,16 @@ static ssize_t cxacru_sysfs_store_adsl_state(struct device *dev,
 		return -EINVAL;
 	ret = 0;
 
+	if (instance == NULL)
+		return -ENODEV;
+
 	if (mutex_lock_interruptible(&instance->adsl_state_serialize))
 		return -ERESTARTSYS;
 
 	if (!strcmp(str_cmd, "stop") || !strcmp(str_cmd, "restart")) {
 		ret = cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_STOP, NULL, 0, NULL, 0);
 		if (ret < 0) {
-			atm_err(usbatm_instance, "change adsl state:"
+			atm_err(instance->usbatm, "change adsl state:"
 				" CHIP_ADSL_LINE_STOP returned %d\n", ret);
 
 			ret = -EIO;
@@ -354,7 +364,7 @@ static ssize_t cxacru_sysfs_store_adsl_state(struct device *dev,
 	if (!strcmp(str_cmd, "start") || !strcmp(str_cmd, "restart")) {
 		ret = cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_START, NULL, 0, NULL, 0);
 		if (ret < 0) {
-			atm_err(usbatm_instance, "change adsl state:"
+			atm_err(instance->usbatm, "change adsl state:"
 				" CHIP_ADSL_LINE_START returned %d\n", ret);
 
 			ret = -EIO;
@@ -649,9 +659,6 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
 {
 	struct cxacru_data *instance = usbatm_instance->driver_data;
 	struct usb_interface *intf = usbatm_instance->usb_intf;
-	/*
-	struct atm_dev *atm_dev = usbatm_instance->atm_dev;
-	*/
 	int ret;
 	int start_polling = 1;
 
diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index fbea856..4038043 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -1333,6 +1333,7 @@ void usbatm_usb_disconnect(struct usb_interface *intf)
 	if (instance->atm_dev) {
 		sysfs_remove_link(&instance->atm_dev->class_dev.kobj, "device");
 		atm_dev_deregister(instance->atm_dev);
+		instance->atm_dev = NULL;
 	}
 
 	usbatm_put_instance(instance);	/* taken in usbatm_usb_probe */
diff --git a/drivers/usb/atm/usbatm.h b/drivers/usb/atm/usbatm.h
index f6f4508..629b39c 100644
--- a/drivers/usb/atm/usbatm.h
+++ b/drivers/usb/atm/usbatm.h
@@ -204,4 +204,34 @@ struct usbatm_data {
 	struct urb *urbs[0];
 };
 
+static inline void *to_usbatm_driver_data(struct usb_interface *intf)
+{
+	struct usbatm_data *usbatm_instance;
+
+	if (intf == NULL)
+		return NULL;
+
+	usbatm_instance = usb_get_intfdata(intf);
+
+	if (usbatm_instance == NULL) /* set NULL before unbind() */
+		return NULL;
+
+	return usbatm_instance->driver_data; /* set NULL after unbind() */
+}
+
+static inline void *to_usbatm_atm_dev(struct usb_interface *intf)
+{
+	struct usbatm_data *usbatm_instance;
+
+	if (intf == NULL)
+		return NULL;
+
+	usbatm_instance = usb_get_intfdata(intf);
+
+	if (usbatm_instance == NULL) /* set NULL before unbind() */
+		return NULL;
+
+	return usbatm_instance->atm_dev; /* set NULL after unbind() */
+}
+
 #endif	/* _USBATM_H_ */
-- 
1.6.3.3

-- 
Simon Arlott


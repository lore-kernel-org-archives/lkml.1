Return-Path: <linux-kernel-owner+w=401wt.eu-S1749667AbXDOOUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1749667AbXDOOUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 10:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXDOOUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 10:20:18 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:57322 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXDOOUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 10:20:11 -0400
Message-ID: <46223498.1030503@simon.arlott.org.uk>
Date: Sun, 15 Apr 2007 15:20:08 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Duncan Sands <duncan.sands@math.u-psud.fr>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH (rev 2)] cxacru: ADSL state management
References: <462172E3.7030408@simon.arlott.org.uk> <200704151208.59719.duncan.sands@math.u-psud.fr>
In-Reply-To: <200704151208.59719.duncan.sands@math.u-psud.fr>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The device has commands to start/stop the ADSL function, so this adds 
a sysfs attribute to allow it to be started/stopped/restarted. It also 
stops polling the device for status when the ADSL function is disabled.

There are no problems with sending multiple start or stop commands, 
even with a fast loop of them the device still works.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
---
This patch requires usb-cxacru-export-detailed-device-info-through-sysfs 
from gregkh-2.6.

Revision 2: Add adsl_state_serialize mutex and use it around ADSL 
start/stop commands followed by deciding on the poll state.

 drivers/usb/atm/cxacru.c |  226 ++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 217 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index c8b69bf..f203507 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -4,6 +4,7 @@
  *
  *  Copyright (C) 2004 David Woodhouse, Duncan Sands, Roman Kagan
  *  Copyright (C) 2005 Duncan Sands, Roman Kagan (rkagan % mail ! ru)
+ *  Copyright (C) 2007 Simon Arlott
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms of the GNU General Public License as published by the Free
@@ -145,6 +146,13 @@ enum cxacru_info_idx {
 	/* dunno what the missing two mean */
 	CXINF_MAX = 0x1c,
 };
+ 
+enum cxacru_poll_state {
+	CXPOLL_STOPPING,
+	CXPOLL_STOPPED,
+	CXPOLL_POLLING,
+	CXPOLL_SHUTDOWN
+};
 
 struct cxacru_modem_type {
 	u32 pll_f_clk;
@@ -158,8 +166,12 @@ struct cxacru_data {
 	const struct cxacru_modem_type *modem_type;
 
 	int line_status;
+	struct mutex adsl_state_serialize;
+	int adsl_status;
 	struct delayed_work poll_work;
 	u32 card_info[CXINF_MAX];
+	struct mutex poll_state_serialize;
+	int poll_state;
 
 	/* contol handles */
 	struct mutex cm_serialize;
@@ -171,10 +183,18 @@ struct cxacru_data {
 	struct completion snd_done;
 };
 
+static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
+	u8 *wdata, int wsize, u8 *rdata, int rsize);
+static void cxacru_poll_status(struct work_struct *work);
+
 /* Card info exported through sysfs */
 #define CXACRU__ATTR_INIT(_name) \
 static DEVICE_ATTR(_name, S_IRUGO, cxacru_sysfs_show_##_name, NULL)
 
+#define CXACRU_CMD_INIT(_name) \
+static DEVICE_ATTR(_name, S_IWUSR | S_IRUGO, \
+	cxacru_sysfs_show_##_name, cxacru_sysfs_store_##_name)
+
 #define CXACRU_ATTR_INIT(_value, _type, _name) \
 static ssize_t cxacru_sysfs_show_##_name(struct device *dev, \
 	struct device_attribute *attr, char *buf) \
@@ -187,9 +207,11 @@ static ssize_t cxacru_sysfs_show_##_name(struct device *dev, \
 CXACRU__ATTR_INIT(_name)
 
 #define CXACRU_ATTR_CREATE(_v, _t, _name) CXACRU_DEVICE_CREATE_FILE(_name)
+#define CXACRU_CMD_CREATE(_name)          CXACRU_DEVICE_CREATE_FILE(_name)
 #define CXACRU__ATTR_CREATE(_name)        CXACRU_DEVICE_CREATE_FILE(_name)
 
 #define CXACRU_ATTR_REMOVE(_v, _t, _name) CXACRU_DEVICE_REMOVE_FILE(_name)
+#define CXACRU_CMD_REMOVE(_name)          CXACRU_DEVICE_REMOVE_FILE(_name)
 #define CXACRU__ATTR_REMOVE(_name)        CXACRU_DEVICE_REMOVE_FILE(_name)
 
 static ssize_t cxacru_sysfs_showattr_u32(u32 value, char *buf)
@@ -278,6 +300,110 @@ static ssize_t cxacru_sysfs_show_mac_address(struct device *dev,
 			atm_dev->esi[3], atm_dev->esi[4], atm_dev->esi[5]);
 }
 
+static ssize_t cxacru_sysfs_show_adsl_state(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usbatm_data *usbatm_instance = usb_get_intfdata(intf);
+	struct cxacru_data *instance = usbatm_instance->driver_data;
+	u32 value = instance->card_info[CXINF_LINE_STARTABLE];
+
+	switch (value) {
+	case 0: return snprintf(buf, PAGE_SIZE, "running\n");
+	case 1: return snprintf(buf, PAGE_SIZE, "stopped\n");
+	default: return snprintf(buf, PAGE_SIZE, "unknown (%u)\n", value);
+	}
+}
+
+static ssize_t cxacru_sysfs_store_adsl_state(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usbatm_data *usbatm_instance = usb_get_intfdata(intf);
+	struct cxacru_data *instance = usbatm_instance->driver_data;
+	int ret = 0;
+	int poll = -1;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EACCES;
+
+	if (mutex_lock_interruptible(&instance->adsl_state_serialize))
+		return -ERESTARTSYS;
+
+	if (!strcmp(buf, "stop") || !strcmp(buf, "restart")) {
+		ret = cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_STOP, NULL, 0, NULL, 0);
+		if (ret < 0) {
+			atm_err(usbatm_instance, "change adsl state:"
+				" CHIP_ADSL_LINE_STOP returned %d\n", ret);
+
+			ret = -EIO;
+		} else {
+			ret = strlen(buf);
+			poll = CXPOLL_STOPPED;
+		}
+	}
+
+	/* Line status is only updated every second
+	 * and the device appears to only react to
+	 * START/STOP every second too. Wait 1.5s to
+	 * be sure that restart will have an effect. */
+	if (!strcmp(buf, "restart"))
+		msleep(1500);
+
+	if (!strcmp(buf, "start") || !strcmp(buf, "restart")) {
+		ret = cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_START, NULL, 0, NULL, 0);
+		if (ret < 0) {
+			atm_err(usbatm_instance, "change adsl state:"
+				" CHIP_ADSL_LINE_START returned %d\n", ret);
+
+			ret = -EIO;
+		} else {
+			ret = strlen(buf);
+			poll = CXPOLL_POLLING;
+		}
+	}
+
+	if (!strcmp(buf, "poll")) {
+		ret = strlen(buf);
+		poll = CXPOLL_POLLING;
+	}
+
+	if (!ret)
+		return -EINVAL;
+
+	if (poll == CXPOLL_POLLING) {
+		mutex_lock(&instance->poll_state_serialize);
+		switch (instance->poll_state) {
+		case CXPOLL_STOPPED:
+			/* start polling */
+			instance->poll_state = CXPOLL_POLLING;
+			break;
+
+		case CXPOLL_STOPPING:
+			/* abort stop request */
+			instance->poll_state = CXPOLL_POLLING;
+		case CXPOLL_POLLING:
+		case CXPOLL_SHUTDOWN:
+			/* don't start polling */
+			poll = -1;
+		}
+		mutex_unlock(&instance->poll_state_serialize);
+	} else if (poll == CXPOLL_STOPPED) {
+		mutex_lock(&instance->poll_state_serialize);
+		/* request stop */
+		if (instance->poll_state == CXPOLL_POLLING)
+			instance->poll_state = CXPOLL_STOPPING;
+		mutex_unlock(&instance->poll_state_serialize);
+	}
+
+	mutex_unlock(&instance->adsl_state_serialize);
+
+	if (poll == CXPOLL_POLLING)
+		cxacru_poll_status(&instance->poll_work.work);
+
+	return ret;
+}
+
 /*
  * All device attributes are included in CXACRU_ALL_FILES
  * so that the same list can be used multiple times:
@@ -312,7 +438,8 @@ CXACRU_ATTR_##_action(CXINF_LINE_STARTABLE,            bool, line_startable); \
 CXACRU_ATTR_##_action(CXINF_MODULATION,                MODU, modulation); \
 CXACRU_ATTR_##_action(CXINF_ADSL_HEADEND,              u32,  adsl_headend); \
 CXACRU_ATTR_##_action(CXINF_ADSL_HEADEND_ENVIRONMENT,  u32,  adsl_headend_environment); \
-CXACRU_ATTR_##_action(CXINF_CONTROLLER_VERSION,        u32,  adsl_controller_version);
+CXACRU_ATTR_##_action(CXINF_CONTROLLER_VERSION,        u32,  adsl_controller_version); \
+CXACRU_CMD_##_action(                                        adsl_state);
 
 CXACRU_ALL_FILES(INIT);
 
@@ -493,8 +620,6 @@ static int cxacru_card_status(struct cxacru_data *instance)
 	return 0;
 }
 
-static void cxacru_poll_status(struct work_struct *work);
-
 static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
 		struct atm_dev *atm_dev)
 {
@@ -503,6 +628,7 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
 	struct atm_dev *atm_dev = usbatm_instance->atm_dev;
 	*/
 	int ret;
+	int start_polling = 1;
 
 	dbg("cxacru_atm_start");
 
@@ -515,6 +641,7 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
 	}
 
 	/* start ADSL */
+	mutex_lock(&instance->adsl_state_serialize);
 	ret = cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_START, NULL, 0, NULL, 0);
 	if (ret < 0) {
 		atm_err(usbatm_instance, "cxacru_atm_start: CHIP_ADSL_LINE_START returned %d\n", ret);
@@ -522,7 +649,26 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
 	}
 
 	/* Start status polling */
-	cxacru_poll_status(&instance->poll_work.work);
+	mutex_lock(&instance->poll_state_serialize);
+	switch (instance->poll_state) {
+	case CXPOLL_STOPPED:
+		/* start polling */
+		instance->poll_state = CXPOLL_POLLING;
+		break;
+
+	case CXPOLL_STOPPING:
+		/* abort stop request */
+		instance->poll_state = CXPOLL_POLLING;
+	case CXPOLL_POLLING:
+	case CXPOLL_SHUTDOWN:
+		/* don't start polling */
+		start_polling = 0;
+	}
+	mutex_unlock(&instance->poll_state_serialize);
+	mutex_unlock(&instance->adsl_state_serialize);
+
+	if (start_polling)
+		cxacru_poll_status(&instance->poll_work.work);
 	return 0;
 }
 
@@ -533,16 +679,46 @@ static void cxacru_poll_status(struct work_struct *work)
 	u32 buf[CXINF_MAX] = {};
 	struct usbatm_data *usbatm = instance->usbatm;
 	struct atm_dev *atm_dev = usbatm->atm_dev;
+	int keep_polling = 1;
 	int ret;
 
 	ret = cxacru_cm_get_array(instance, CM_REQUEST_CARD_INFO_GET, buf, CXINF_MAX);
 	if (ret < 0) {
-		atm_warn(usbatm, "poll status: error %d\n", ret);
+		if (ret != -ESHUTDOWN)
+			atm_warn(usbatm, "poll status: error %d\n", ret);
+		
+		mutex_lock(&instance->poll_state_serialize);
+		if (instance->poll_state != CXPOLL_SHUTDOWN) {
+			instance->poll_state = CXPOLL_STOPPED;
+
+			if (ret != -ESHUTDOWN)
+				atm_warn(usbatm, "polling disabled, set adsl_state"
+						" to 'start' or 'poll' to resume\n");
+		}
+		mutex_unlock(&instance->poll_state_serialize);
 		goto reschedule;
 	}
 
 	memcpy(instance->card_info, buf, sizeof(instance->card_info));
 
+	if (instance->adsl_status != buf[CXINF_LINE_STARTABLE]) {
+		instance->adsl_status = buf[CXINF_LINE_STARTABLE];
+
+		switch (instance->adsl_status) {
+		case 0:
+			atm_printk(KERN_INFO, usbatm, "ADSL state: running\n");
+			break;
+
+		case 1:
+			atm_printk(KERN_INFO, usbatm, "ADSL state: stopped\n");
+			break;
+
+		default:
+			atm_printk(KERN_INFO, usbatm, "Unknown adsl status %02x\n", instance->adsl_status);
+			break;
+		}
+	}
+
 	if (instance->line_status == buf[CXINF_LINE_STATUS])
 		goto reschedule;
 
@@ -597,8 +773,20 @@ static void cxacru_poll_status(struct work_struct *work)
 		break;
 	}
 reschedule:
-	schedule_delayed_work(&instance->poll_work,
-			round_jiffies_relative(msecs_to_jiffies(POLL_INTERVAL*1000)));
+
+	mutex_lock(&instance->poll_state_serialize);
+	if (instance->poll_state == CXPOLL_STOPPING &&
+				instance->adsl_status == 1 && /* stopped */
+				instance->line_status == 0) /* down */
+		instance->poll_state = CXPOLL_STOPPED;
+
+	if (instance->poll_state == CXPOLL_STOPPED)
+		keep_polling = 0;
+	mutex_unlock(&instance->poll_state_serialize);
+
+	if (keep_polling)
+		schedule_delayed_work(&instance->poll_work,
+				round_jiffies_relative(POLL_INTERVAL*HZ));
 }
 
 static int cxacru_fw(struct usb_device *usb_dev, enum cxacru_fw_request fw,
@@ -835,6 +1023,13 @@ static int cxacru_bind(struct usbatm_data *usbatm_instance,
 	instance->modem_type = (struct cxacru_modem_type *) id->driver_info;
 	memset(instance->card_info, 0, sizeof(instance->card_info));
 
+	mutex_init(&instance->poll_state_serialize);
+	instance->poll_state = CXPOLL_STOPPED;
+	instance->line_status = -1;
+	instance->adsl_status = -1;
+
+	mutex_init(&instance->adsl_state_serialize);
+
 	instance->rcv_buf = (u8 *) __get_free_page(GFP_KERNEL);
 	if (!instance->rcv_buf) {
 		dbg("cxacru_bind: no memory for rcv_buf");
@@ -909,6 +1104,7 @@ static void cxacru_unbind(struct usbatm_data *usbatm_instance,
 		struct usb_interface *intf)
 {
 	struct cxacru_data *instance = usbatm_instance->driver_data;
+	int is_polling = 1;
 
 	dbg("cxacru_unbind entered");
 
@@ -917,8 +1113,20 @@ static void cxacru_unbind(struct usbatm_data *usbatm_instance,
 		return;
 	}
 
-	while (!cancel_delayed_work(&instance->poll_work))
-	       flush_scheduled_work();
+	mutex_lock(&instance->poll_state_serialize);
+	BUG_ON(instance->poll_state == CXPOLL_SHUTDOWN);
+
+	/* ensure that status polling continues unless
+	 * it has already stopped */
+	if (instance->poll_state == CXPOLL_STOPPED)
+		is_polling = 0;
+		
+	/* stop polling from being stopped or started */
+	instance->poll_state = CXPOLL_SHUTDOWN;
+	mutex_unlock(&instance->poll_state_serialize);
+
+	if (is_polling)
+		cancel_rearming_delayed_work(&instance->poll_work);
 
 	usb_kill_urb(instance->snd_urb);
 	usb_kill_urb(instance->rcv_urb);
-- 
1.5.0.1

-- 
Simon Arlott

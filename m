Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab0BXQCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 11:02:30 -0500
Received: from legolas.restena.lu ([158.64.1.34]:50998 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab0BXQCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 11:02:24 -0500
Date: Wed, 24 Feb 2010 17:01:12 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
Subject: [PATCH 2/3] hid: add suspend/resume hooks for hid drivers
Message-ID: <20100224170112.576403ee@neptune.home>
In-Reply-To: <20100224163101.3622d69f@neptune.home>
References: <20100221002001.0a7e05a7@neptune.home>
 <20100224163101.3622d69f@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
References: <20100224170049.0d04af3c@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add suspend/resume hooks for HID drivers so these can do some
additional state adjustment when device gets suspended/resumed.

This patch calls these hooks from usbhid suspend/resume functions,
only calling suspend on plain suspend, not autosuspend.
(it might be worth adding an autosuspend parameter to suspend
hook and calling suspend in both cases)

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-core.c              |   19 ++-
 include/linux/hid.h                 |    8 +
 2 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index e2997a8..8ad1a98 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1272,6 +1272,11 @@ static int hid_suspend(struct usb_interface *intf, pm_message_t message)
 		}
 
 	} else {
+		if (hid->driver && hid->driver->suspend) {
+			status = hid->driver->suspend(hid);
+			if (status < 0)
+				return status;
+		}
 		spin_lock_irq(&usbhid->lock);
 		set_bit(HID_REPORTED_IDLE, &usbhid->iofl);
 		spin_unlock_irq(&usbhid->lock);
@@ -1326,6 +1331,11 @@ static int hid_resume(struct usb_interface *intf)
 		hid_io_error(hid);
 	usbhid_restart_queues(usbhid);
 
+	if (hid->driver && hid->driver->resume) {
+		int ret = hid->driver->resume(hid);
+		if (ret < 0 && status == 0)
+			status = ret;
+	}
 	dev_dbg(&intf->dev, "resume status %d\n", status);
 	return 0;
 }
@@ -1334,9 +1344,16 @@ static int hid_reset_resume(struct usb_interface *intf)
 {
 	struct hid_device *hid = usb_get_intfdata(intf);
 	struct usbhid_device *usbhid = hid->driver_data;
+	int status;
 
 	clear_bit(HID_REPORTED_IDLE, &usbhid->iofl);
-	return hid_post_reset(intf);
+	status = hid_post_reset(intf);
+	if (hid->driver && hid->driver->reset_resume) {
+		int ret = hid->driver->reset_resume(hid);
+		if (ret < 0 && status == 0)
+			status = ret;
+	}
+	return status;
 }
 
 #endif /* CONFIG_PM */
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 8709365..b4409f1 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -589,6 +589,9 @@ struct hid_usage_id {
  * @report_fixup: called before report descriptor parsing (NULL means nop)
  * @input_mapping: invoked on input registering before mapping an usage
  * @input_mapped: invoked on input registering after mapping an usage
+ * @suspend: invoked on suspend (NULL means nop)
+ * @resume: invoked on resume if device was not reset (NULL means nop)
+ * @reset_resume: invoked on resume if device was reset (NULL means nop)
  *
  * raw_event and event should return 0 on no action performed, 1 when no
  * further processing should be done and negative on error
@@ -629,6 +632,11 @@ struct hid_driver {
 	int (*input_mapped)(struct hid_device *hdev,
 			struct hid_input *hidinput, struct hid_field *field,
 			struct hid_usage *usage, unsigned long **bit, int *max);
+#ifdef CONFIG_PM
+	int (*suspend)(struct hid_device *hdev);
+	int (*resume)(struct hid_device *hdev);
+	int (*reset_resume)(struct hid_device *hdev);
+#endif
 /* private: */
 	struct device_driver driver;
 };

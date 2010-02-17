Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab0BQR2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 12:28:15 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:63074 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab0BQR2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 12:28:14 -0500
Message-ID: <a82f528d5a1ecf9f64901ace786ef844.squirrel@intranet.cs.nmsu.edu>
Date: Wed, 17 Feb 2010 10:28:12 -0700
Subject: Problem with modification to hid_post_reset
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Linux" <linux-kernel@vger.kernel.org>,
       "Linux USB" <linux-usb@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is a short patch that I've been using to add hooks before and
after device reset. I probably won't end up needing the post_reset_finish
hook but I have it there for testing right now.

The first hook I need so I can set a flag that is dealt with on the first
raw event, and I need to ensure the flag is set prior to queue restart.

>From what I can tell, these shouldn't cause any problems... they should be
trivial but they are causing a kernel fault on resume from a suspend.

The enclosed patch probably has line wrapping problems. If someone wants
to test it I'll send a more proper patch, but I thought I'd throw it out
there and see if anyone sees anything obvious.

Thanks,

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index e2997a8..bfd698c 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1221,6 +1221,9 @@ static int hid_post_reset(struct usb_interface *intf)
 	struct usbhid_device *usbhid = hid->driver_data;
 	int status;

+	if (hid->driver && hid->driver->post_reset_start)
+		hid->driver->post_reset_start(hid);
+
 	spin_lock_irq(&usbhid->lock);
 	clear_bit(HID_RESET_PENDING, &usbhid->iofl);
 	spin_unlock_irq(&usbhid->lock);
@@ -1230,6 +1233,9 @@ static int hid_post_reset(struct usb_interface *intf)
 		hid_io_error(hid);
 	usbhid_restart_queues(usbhid);

+	if (hid->driver && hid->driver->post_reset_finish)
+		hid->driver->post_reset_finish(hid);
+
 	return 0;
 }

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 8709365..15c511c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -629,6 +631,10 @@ struct hid_driver {
 	int (*input_mapped)(struct hid_device *hdev,
 			struct hid_input *hidinput, struct hid_field *field,
 			struct hid_usage *usage, unsigned long **bit, int *max);
+
+	void (*post_reset_start)(struct hid_device *hdev);
+	void (*post_reset_finish)(struct hid_device *hdev);
+
 /* private: */
 	struct device_driver driver;
 };


---- G13 code ----

#define hid_get_g13data(hdev) \
	((struct g13_data *)(hid_get_drvdata(hdev)))

static void g13_post_reset_start(struct hid_device *hdev)
{
	struct g13_data *data;

	/* Get the underlying data value */
	data = hid_get_g13data(hdev);
	/* need_reset is declared as int */
	data->need_reset = 1;
}

static void g13_post_reset_finish(struct hid_device *hdev)
{
}

static struct hid_driver g13_driver = {
	.name 			= "hid-g13",
	.id_table 		= g13_devices,
	.probe 			= g13_probe,
	.remove 		= g13_remove,
	.raw_event 		= g13_raw_event,
 	.post_reset_start 	= g13_post_reset_start,
  	.post_reset_finish	= g13_post_reset_finish,
};




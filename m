Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbXC3SBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbXC3SBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXC3SBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:01:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbXC3SBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:01:15 -0400
Date: Fri, 30 Mar 2007 10:59:24 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: zaitcev@redhat.com, <dtor@insightbb.com>,
       <linux-usb-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       stuard_hayes@dell.com
Subject: usb hid: reset NumLock
Message-Id: <20070330105924.01a16dd6.zaitcev@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch for comments only, please do not apply (at least not as-is).
I haven't got the test results yet.

Dell people (Stuart and Charles) complained that on some USB keyboards,
if BIOS enables NumLock, it stays on even after Linux has started. Since
we always start with NumLock off, this confuses users. Quick double dab
at NumLock fixes it, but it's not nice.

The keyboard driver tries to reset LEDs at start, but this never works.
Since the bitmap dev->led is zero, the input_event() filters out any
attempts to switch LEDs off. So, the code in kbd_start() does nothing.

The Dell's solution looks like this (for 2.6.9 code base):

linux-2.6.9-42.0.3/drivers/char/keyboard.c:
@@ -931,6 +931,19 @@ void kbd_refresh_leds(struct input_handl
 
 	tasklet_disable(&keyboard_tasklet);
 	if (leds != 0xff) {
+		/*
+		 * We can't be sure of the state of the LEDs on keyboards
+		 * (e.g., BIOS might have left LED_NUML on), so set dev->led
+		 * opposite of ledstate, to make sure input_event() actually
+		 * sends the command to the keyboard to set each LED.
+		 */
+		if (test_bit(LED_SCROLLL, handle->dev->led) == !!(leds & 0x01))
+			change_bit(LED_SCROLLL, handle->dev->led);
+		if (test_bit(LED_NUML, handle->dev->led) == !!(leds & 0x02))
+			change_bit(LED_NUML, handle->dev->led);
+		if (test_bit(LED_CAPSL, handle->dev->led) == !!(leds & 0x04))
+			change_bit(LED_CAPSL, handle->dev->led);
+
 		input_event(handle->dev, EV_LED, LED_SCROLLL, !!(leds & 0x01));
 		input_event(handle->dev, EV_LED, LED_NUML,    !!(leds & 0x02));
 		input_event(handle->dev, EV_LED, LED_CAPSL,   !!(leds & 0x04));

I didn't like a) layering violation, and b) that they defeat filtering
unconditionally. Why have any filtering then?

Instead, I propose for USB HID driver to reset NumLock on probe. Like this:

--- a/drivers/usb/input/hid-core.c
+++ b/drivers/usb/input/hid-core.c
@@ -458,6 +458,18 @@ static int usb_hidinput_input_event(struct input_dev *dev, unsigned int type, un
 	return 0;
 }
 
+static void usbhid_set_leds(struct hid_device *hid, unsigned int code, int val)
+{
+	struct hid_field *field;
+	int offset;
+
+	/* This is often called for the mouse half. */
+	if ((offset = hidinput_find_field(hid, EV_LED, code, &field)) != -1) {
+		hid_set_field(field, offset, val);
+		usbhid_submit_report(hid, field->report, USB_DIR_OUT);
+	}
+}
+
 int usbhid_wait_io(struct hid_device *hid)
 {
 	struct usbhid_device *usbhid = hid->driver_data;
@@ -1328,9 +1340,18 @@ static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		return -ENODEV;
 	}
 
-	if ((hid->claimed & HID_CLAIMED_INPUT))
+	if ((hid->claimed & HID_CLAIMED_INPUT)) {
 		hid_ff_init(hid);
 
+		/*
+		 * We do this only if input has claimed the device because
+		 * we can only find fields after they were configured in
+		 * hidinput_connect.
+		 */
+		/* if (hid->quirks & HID_QUIRK_RESET_LEDS) */
+		usbhid_set_leds(hid, LED_NUML, 0);
+	}
+
 	if (hid->quirks & HID_QUIRK_SONY_PS3_CONTROLLER)
 		hid_fixup_sony_ps3_controller(interface_to_usbdev(intf),
 			intf->cur_altsetting->desc.bInterfaceNumber);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index d26b08f..f592f01 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -267,6 +267,7 @@ struct hid_item {
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00020000
 #define HID_QUIRK_IGNORE_MOUSE			0x00040000
 #define HID_QUIRK_SONY_PS3_CONTROLLER		0x00080000
+#define HID_QUIRK_RESET_LEDS			0x00100000
 
 /*
  * This is the global environment of the parser. This information is

URL with details, discussion, rejected patch to read BIOS byte at 0x417:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=228674

Jiri, Dmitry, any opinions please?

-- Pete

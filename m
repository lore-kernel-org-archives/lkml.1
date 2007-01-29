Return-Path: <linux-kernel-owner+w=401wt.eu-S1751006AbXA2LqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbXA2LqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:46:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXA2LqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:46:03 -0500
Received: from twin.jikos.cz ([213.151.79.26]:51070 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXA2LqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:46:01 -0500
Date: Mon, 29 Jan 2007 12:45:49 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Soeren Sonnenburg <kernel@nn7.de>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
Subject: Re: 2.6.20-rc6 pb_fnmode regression
In-Reply-To: <1170069874.13904.29.camel@localhost>
Message-ID: <Pine.LNX.4.64.0701291237570.9448@twin.jikos.cz>
References: <1169904555.2462.10.camel@localhost>  <Pine.LNX.4.64.0701291049190.9448@twin.jikos.cz>
  <1170066737.13904.12.camel@localhost>  <Pine.LNX.4.64.0701291138260.9448@twin.jikos.cz>
  <Pine.LNX.4.64.0701291202230.9448@twin.jikos.cz> <1170069874.13904.29.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Soeren Sonnenburg wrote:

> That sounds good for me. Breaking with what was there is not a problem 
> as long as this feature is still there, it can be done in a more clean 
> way this way, and the new /sys/foo/bar path is documented (basically 
> people nowadays expect slight user interface changes between kernel 
> versions).

So, does the patch below look OK to powerbook people? The only difference 
is that the module taking care of pb_fnmode parameter is now hid, instead 
of usbhid. If it is OK I will probably queue it as a bugfix for 
2.6.20-rc6, as it seems that quite a lot of users got used to be able to 
change pb_fnmode value through sysfs.

[PATCH] HID: pb_fnmode fix and move it to generic HID

The apple powerbook people are used to switch the pb_fnmode
setting at runtime through writing to sysfs, altering the
module parameter value. This was broken for them in 2.6.20-rc1
when generic HID layer was introduced, as the pb_fnmode flag
was made per-hiddevice, instead of global variable.

This patch moves the pb_fnmode module parameter from usbhid module
to hid module, but apart from that retains backward compatibility
with respect to changing the mode through sysfs.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---
commit f5d9972112d5a78233cae97d7b162d5e33389026
tree cf8140e884ad2fe11212579e1ba91a925da87e58
parent 99abfeafb5f2eea1bb481330ff37343e1133c924
author Jiri Kosina <jkosina@suse.cz> Mon, 29 Jan 2007 12:44:41 +0100
committer Jiri Kosina <jkosina@suse.cz> Mon, 29 Jan 2007 12:44:41 +0100

 drivers/hid/hid-input.c      |   11 ++++++++---
 drivers/usb/input/hid-core.c |    9 ---------
 include/linux/hid.h          |    1 -
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 9cf591a..54b0b95 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -35,6 +35,11 @@
 
 #include <linux/hid.h>
 
+static int hid_pb_fnmode = 1;
+module_param_named(pb_fnmode, hid_pb_fnmode, int, 0644);
+MODULE_PARM_DESC(pb_fnmode,
+		"Mode of fn key on PowerBooks (0 = disabled, 1 = fkeyslast, 2 = fkeysfirst)");
+
 #define unk	KEY_UNKNOWN
 
 static const unsigned char hid_keyboard[256] = {
@@ -154,7 +159,7 @@ static int hidinput_pb_event(struct hid_device *hid, struct input_dev *input,
 		return 1;
 	}
 
-	if (hid->pb_fnmode) {
+	if (hid_pb_fnmode) {
 		int do_translate;
 
 		trans = find_translation(powerbook_fn_keys, usage->code);
@@ -163,8 +168,8 @@ static int hidinput_pb_event(struct hid_device *hid, struct input_dev *input,
 				do_translate = 1;
 			else if (trans->flags & POWERBOOK_FLAG_FKEY)
 				do_translate =
-					(hid->pb_fnmode == 2 &&  (hid->quirks & HID_QUIRK_POWERBOOK_FN_ON)) ||
-					(hid->pb_fnmode == 1 && !(hid->quirks & HID_QUIRK_POWERBOOK_FN_ON));
+					(hid_pb_fnmode == 2 &&  (hid->quirks & HID_QUIRK_POWERBOOK_FN_ON)) ||
+					(hid_pb_fnmode == 1 && !(hid->quirks & HID_QUIRK_POWERBOOK_FN_ON));
 			else
 				do_translate = (hid->quirks & HID_QUIRK_POWERBOOK_FN_ON);
 
diff --git a/drivers/usb/input/hid-core.c b/drivers/usb/input/hid-core.c
index ea3636d..a2ee707 100644
--- a/drivers/usb/input/hid-core.c
+++ b/drivers/usb/input/hid-core.c
@@ -56,11 +56,6 @@ static unsigned int hid_mousepoll_interval;
 module_param_named(mousepoll, hid_mousepoll_interval, uint, 0644);
 MODULE_PARM_DESC(mousepoll, "Polling interval of mice");
 
-static int usbhid_pb_fnmode = 1;
-module_param_named(pb_fnmode, usbhid_pb_fnmode, int, 0644);
-MODULE_PARM_DESC(pb_fnmode,
-		"Mode of fn key on PowerBooks (0 = disabled, 1 = fkeyslast, 2 = fkeysfirst)");
-
 /*
  * Input submission and I/O error handler.
  */
@@ -1249,10 +1244,6 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 	hid->hiddev_hid_event = hiddev_hid_event;
 	hid->hiddev_report_event = hiddev_report_event;
 #endif
-#ifdef CONFIG_USB_HIDINPUT_POWERBOOK
-	hid->pb_fnmode = usbhid_pb_fnmode;
-#endif
-
 	return hid;
 
 fail:
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 770120a..342b4e6 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -438,7 +438,6 @@ struct hid_device {							/* device report descriptor */
 				  struct hid_usage *, __s32);
 	void (*hiddev_report_event) (struct hid_device *, struct hid_report *);
 #ifdef CONFIG_USB_HIDINPUT_POWERBOOK
-	unsigned int  pb_fnmode;
 	unsigned long pb_pressed_fn[NBITS(KEY_MAX)];
 	unsigned long pb_pressed_numlock[NBITS(KEY_MAX)];
 #endif

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751508AbYJRT5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbYJRT5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYJRT53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:57:29 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:54320 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYJRT53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:57:29 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Cc: "Justin Mattock" <justinmattock@gmail.com>,
       "Jiri Kosina" <jkosina@suse.cz>, "Sven Anders" <anders@anduras.de>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: appletouch regression
Date: Sat, 18 Oct 2008 21:56:59 +0200
Message-Id: <1224359819-15152-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <f488382f0810181134h24ed5da8lc12e62816436bb5@mail.gmail.com>
References: <f488382f0810181134h24ed5da8lc12e62816436bb5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Noonan wrote:
> On Sat, Oct 18, 2008 at 10:29 AM, Justin Mattock
> <justinmattock@gmail.com> wrote:
>> On Sat, Oct 18, 2008 at 9:44 AM, Steven Noonan <steven@uplinklabs.net> wrote:
>>> 2008/10/18 Sven Anders <anders@anduras.de>:
>>>> Steven Noonan schrieb:
>>>>> It seems that the appletouch driver is (sporadically) not detecting my
>>>>> Apple Trackpad anymore on Linus' current tree (2.6.27-05577-g0cfd810).
>>>>> When it is misbehaving, it doesn't have any /dev/input/event* entry
>>>>> that corresponds to the input from appletouch, and dmesg -should- show
>>>>> the following, as 2.6.27.1 does, but does not:
>>>>>
>>>>> appletouch: Geyser mode initialized.
>>>>> input: appletouch as /class/input/input4
>>>>> usbcore: registered new interface driver appletouch
>>>>> appletouch: 17" model detected
>>>>>
>>>>> On the current tree, occasionally all I get is:
>>>>>
>>>>> usbcore: registered new interface driver appletouch
[...]
> Any ideas, gentlemen?

Yeah, I see the problem. The device is grabbed by the hid bus and not
released even if apple driver says ENODEV (this is expected behaviour
and noted in the driver).

Could you try this patch? (Not ready for merge, it needs to be cleaned
up.)

---
 drivers/hid/hid-core.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 8a7d9db..94cf1db 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1539,6 +1539,34 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ }
 };
 
+static const struct hid_device_id hid_mouse_ignore_list[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
+	{ }
+};
+
+#include <linux/usb.h>
+
 static bool hid_ignore(struct hid_device *hdev)
 {
 	switch (hdev->vendor) {
@@ -1555,6 +1583,12 @@ static bool hid_ignore(struct hid_device *hdev)
 		break;
 	}
 
+	if (hdev->bus == BUS_USB && to_usb_interface(hdev->dev.parent)->
+			cur_altsetting->desc.bInterfaceProtocol ==
+			USB_INTERFACE_PROTOCOL_MOUSE &&
+			hid_match_id(hdev, hid_mouse_ignore_list))
+		return true;
+
 	return !!hid_match_id(hdev, hid_ignore_list);
 }
 
-- 
1.6.0.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762851AbXERXbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762851AbXERXbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 19:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXERXbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 19:31:25 -0400
Received: from twin.jikos.cz ([213.151.79.26]:38644 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbXERXbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 19:31:24 -0400
Date: Sat, 19 May 2007 01:31:21 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Tomas Carnecky <tom@dbservice.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: SideWinder GameVoice driver
In-Reply-To: <464E23CA.8040400@dbservice.com>
Message-ID: <Pine.LNX.4.64.0705190111310.27422@twin.jikos.cz>
References: <464C5FAC.8060609@dbservice.com> <Pine.LNX.4.64.0705171623280.27422@twin.jikos.cz>
 <464C708C.6090808@dbservice.com> <464CA34F.8090509@dbservice.com>
 <Pine.LNX.4.64.0705172309240.27422@twin.jikos.cz> <464D4F31.6000100@dbservice.com>
 <Pine.LNX.4.64.0705182304400.27422@twin.jikos.cz> <464E23CA.8040400@dbservice.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007, Tomas Carnecky wrote:

> There's no further processing needed in the kernel. The userspace 
> application would receive these input events and act accordingly, like: 
> read data from the soundcard and send it to the VoIP server, or only 
> certain channels based on which buttons are currently pressed etc.

Thanks. Now it's clear that the HID report descriptor of the device is 
just bogus, it simply makes no sense to claim this kind of device to be 
'Telephony/Headset'.

> I already thought about this option (to whitelist this particular
> vendor/device ID as an hid-input device), but I first wanted some
> feedback on the whole situation. As for the patch, I have zero knowledge
> of the hid subsystem.. but if you give me a go on this, I'll try to dig
> into the code and make a patch :)

Adding a HID_QUIRK_HIDINPUT quirk makes maybe a more sense than fixing 
this particular report descriptor to stop pretending that the device is 
Telephony/Headset - we might in future discover that there are more 
devices that have broken report descriptors and that we want to be forced 
to be handled by hid-input subsystem.

So, could you please test whether the quick and untested patch below 
(against 2.6.22-rc1) works as expected with the device?

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 7f81789..8696dbe 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -976,7 +976,7 @@ int hidinput_connect(struct hid_device *
 			if (IS_INPUT_APPLICATION(hid->collection[i].usage))
 				break;
 
-	if (i == hid->maxcollection)
+	if (i == hid->maxcollection && (hid->quirks & HID_QUIRK_HIDINPUT) == 0)
 		return -1;
 
 	if (hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index f6c4145..62a7f1e 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -209,6 +209,9 @@
 #define USB_DEVICE_ID_MGE_UPS		0xffff
 #define USB_DEVICE_ID_MGE_UPS1		0x0001
 
+#define USB_VENDOR_ID_MICROSOFT		0x045e
+#define USB_DEVICE_ID_SIDEWINDER_GV	0x003b
+
 #define USB_VENDOR_ID_NEC		0x073e
 #define USB_DEVICE_ID_NEC_USB_GAME_PAD	0x0301
 
@@ -290,6 +293,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_DINOVO_EDGE, HID_QUIRK_DUPLICATE_USAGES },
 
 	{ USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM, HID_QUIRK_HIDDEV },
+	{ USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV, HID_QUIRK_HIDINPUT },
 
 	{ USB_VENDOR_ID_AIPTEK, USB_DEVICE_ID_AIPTEK_01, HID_QUIRK_IGNORE },
 	{ USB_VENDOR_ID_AIPTEK, USB_DEVICE_ID_AIPTEK_10, HID_QUIRK_IGNORE },
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 827ee74..6e45d10 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -276,6 +276,7 @@ struct hid_item {
 #define HID_QUIRK_DUPLICATE_USAGES		0x00200000
 #define HID_QUIRK_RESET_LEDS			0x00400000
 #define HID_QUIRK_SWAPPED_MIN_MAX		0x00800000
+#define HID_QUIRK_HIDINPUT			0x01000000
 
 /*
  * This is the global environment of the parser. This information is

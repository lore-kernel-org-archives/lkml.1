Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbYBSMnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbYBSMnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 07:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYBSMnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 07:43:14 -0500
Received: from styx.suse.cz ([82.119.242.94]:44692 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751508AbYBSMnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:43:13 -0500
Date: Tue, 19 Feb 2008 13:43:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Adolfo R. Brandes" <arbrandes@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote
 Control
In-Reply-To: <b4292e150802120709u1ac16800l11366913a0b54a8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802191333050.30955@jikos.suse.cz>
References: <b4292e150712280848h36a5bbf5k76e121168e8bfd12@mail.gmail.com> 
 <Pine.LNX.4.64.0801171420400.15647@twin.jikos.cz> 
 <b4292e150801180901wfb55577kc884276622bc869e@mail.gmail.com> 
 <b4292e150801180958v43350590pc6ed4683bfc478ab@mail.gmail.com> 
 <Pine.LNX.4.64.0802112115580.7699@twin.jikos.cz> 
 <b4292e150802120523o7e44500as9be841618805e54e@mail.gmail.com>
 <b4292e150802120709u1ac16800l11366913a0b54a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Adolfo R. Brandes wrote:

> However, the TV key is still not seen by the X server (tested using
> xev and evrouter).  I'm attaching 3 files:
> * hid-input.c.patch: your patch with compilation warnings and errors
> fixed, against 2.6.24-rc6.
> * kern0.log: hid-debug and evbug output for these events: Connect, 0
> Key, Sleep Key, 0 Key, TV Key, Disconnect.
> * usbmon0.log: usbmon output for the same sequence of events (but at a
> different point in time).

Thanks for the data. The "TV" key is indeed very strange, as there seems 
to be report received, corresponding usbmon log:

de8ec680 1405369735 C Ii:2:014:2 0:8 3 = 064600
de8ec680 1405369751 S Ii:2:014:2 -115:8 5 <

but only the "release" report, that is sent just afterwards, seems to have 
reached HID layer, I don't know why. Could you please test the patch 
below, and send me the output?

diff --git a/drivers/hid/hid-input-quirks.c b/drivers/hid/hid-input-quirks.c
index a870ba5..99f05ce 100644
--- a/drivers/hid/hid-input-quirks.c
+++ b/drivers/hid/hid-input-quirks.c
@@ -418,6 +418,27 @@ void hidinput_event_quirks(struct hid_device *hid, struct hid_field *field, stru
 		input_event(input, usage->type, REL_WHEEL, -value);
 		return;
 	}
+	/* "Sleep" key */
+	if (hid->vendor == 0x0c16 && hid->product == 0x0002 &&
+			(usage->hid & HID_USAGE_PAGE) == HID_UP_GENDESK &&
+			(usage->hid & 0xf0) == 0x80 &&
+			(usage->hid & 0xf) == 0x2) {
+		input_event(input, usage->type, usage->code, 1);
+		input_sync(input);
+		input_event(input, usage->type, usage->code, 0);
+		input_sync(input);
+		return;
+	}
+	/* "TV" key */
+	if (hid->vendor == 0x0c16 && hid->product == 0x0002 &&
+			(usage->hid & HID_USAGE_PAGE) == HID_UP_LOGIVENDOR &&
+			(usage->hid & HID_USAGE) == 0x0000) {
+		input_event(input, usage->type, usage->code, 1);
+		input_sync(input);
+		input_event(input, usage->type, usage->code, 0);
+		input_sync(input);
+		return;
+	}
 }
 
 
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 5325d98..45b8059 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -721,8 +721,13 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 
 		case HID_UP_LOGIVENDOR:
 
-			goto ignore;
-		
+			set_bit(EV_REP, input->evbit);
+			switch(usage->hid & HID_USAGE) {
+				case 0x027: map_key_clear(KEY_TV);	break;
+				default: goto ignore;
+			};
+			break;
+
 		case HID_UP_PID:
 
 			switch(usage->hid & HID_USAGE) {
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index d95979f..650322b 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -195,6 +195,8 @@ static void hid_irq_in(struct urb *urb)
 	struct usbhid_device 	*usbhid = hid->driver_data;
 	int			status;
 
+	printk(KERN_DEBUG "input irq status %d received. len == %x\n",
+			urb->status, urb->actual_length);
 	switch (urb->status) {
 		case 0:			/* success */
 			usbhid->retry_delay = 0;

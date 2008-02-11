Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYBKUSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYBKUSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759990AbYBKURu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:17:50 -0500
Received: from twin.jikos.cz ([213.151.79.26]:46781 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811AbYBKURr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:17:47 -0500
Date: Mon, 11 Feb 2008 21:17:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Adolfo R. Brandes" <arbrandes@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote
 Control
In-Reply-To: <b4292e150801180958v43350590pc6ed4683bfc478ab@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802112115580.7699@twin.jikos.cz>
References: <b4292e150712280848h36a5bbf5k76e121168e8bfd12@mail.gmail.com> 
 <Pine.LNX.4.64.0801171420400.15647@twin.jikos.cz> 
 <b4292e150801180901wfb55577kc884276622bc869e@mail.gmail.com>
 <b4292e150801180958v43350590pc6ed4683bfc478ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008, Adolfo R. Brandes wrote:

>   I decided to ask the folks at Gyration about this before tearing my 
> (and Jiri's) hair out, and it seems that the 3 "missing keys" are 
> actually not meant to send USB signals, only IR ones.  I tested it on 
> Windows using an usb bus tracer, and as expected (duh) nothing gets 
> through for them.
>   Sorry about this, Jiri (although the "TV" and "Power" keys are still
> broken :)!

Hi Adolfo,

could you please try the testing patch below (against 2.6.24) and report 
back if it makes your "Power" and "TV" keys work? (and if it does not, 
please attach HID debugging output, as you already did before). Sorry that 
it took me too long to reply.

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 0b27da7..fc6e77e 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -802,6 +802,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case HID_UP_LOGIVENDOR:
 			set_bit(EV_REP, input->evbit);
 			switch(usage->hid & HID_USAGE) {
+				case 0x000: map_key_clear(KEY_TV);
 				/* Reported on Logitech Ultra X Media Remote */
 				case 0x004: map_key_clear(KEY_AGAIN);		break;
 				case 0x00d: map_key_clear(KEY_HOME);		break;
@@ -1039,6 +1040,28 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
 		return;
 	}
 
+	/* "Sleep" key */
+	if (hid->vendor == 0x0c16 && hid->product == 0x0002 &&
+			(usage->hid & HID_USAGE_PAGE == HID_UP_GENDESK) &&
+			(usage->hid & 0xf0 == 0x80)  &&
+			(usage->hid & 0xf == 0x2)) {
+		input_event(input, usage->type, usage->code, 1);
+		input_sync(input);
+		intpu_event(input, usage->type, usage->code, 0);
+		input_sync(input);
+		return;
+	}
+	/* "TV" key */
+	if (hid->vendor == 0x0c16 && hid->product == 0x0002 &&
+			(usage->hid & HID_USAGE_PAGE == HID_UP_LOGIVENDOR) &&
+			(usage->hid & HID_USAGE == 0x0000))
+		input_event(input, usage->type, usage->code, 1);
+		input_sync(input);
+		intpu_event(input, usage->type, usage->code, 0);
+		input_sync(input);
+		return;
+	}
+
 	/* Handling MS keyboards special buttons */
 	if (IS_MS_KB(hid) && usage->hid == (HID_UP_MSVENDOR | 0xff05)) {
 		int key = 0;

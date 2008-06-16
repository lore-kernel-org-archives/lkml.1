Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbYFQANl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbYFQANl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 20:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYFQANe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 20:13:34 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:33773 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbYFQANd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 20:13:33 -0400
X-Greylist: delayed 2494 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2008 20:13:33 EDT
To: linux-kernel@vger.kernel.org
Cc: jkosina@suse.cz
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote Control
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 16 Jun 2008 16:31:56 -0700
Message-ID: <871w2xnehf.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri & all,

What's the status on this bug?

I used this patch for 2.6.24:

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
+			((usage->hid & HID_USAGE_PAGE) == HID_UP_GENDESK) &&
+			((usage->hid & 0xf0) == 0x80)  &&
+			((usage->hid & 0xf) == 0x2)) {
+		input_event(input, usage->type, usage->code, 1);
+		input_sync(input);
+		input_event(input, usage->type, usage->code, 0);
+		input_sync(input);
+		return;
+	}
+	/* "TV" key */
+	if (hid->vendor == 0x0c16 && hid->product == 0x0002 &&
+			((usage->hid & HID_USAGE_PAGE) == HID_UP_LOGIVENDOR) &&
+			((usage->hid & HID_USAGE) == 0x0000)) {
+		input_event(input, usage->type, usage->code, 1);
+		input_sync(input);
+		input_event(input, usage->type, usage->code, 0);
+		input_sync(input);
+		return;
+	}
+
 	/* Handling MS keyboards special buttons */
 	if (IS_MS_KB(hid) && usage->hid == (HID_UP_MSVENDOR | 0xff05)) {
 		int key = 0;


It was working fine.

With 2.6.25.6, I've been trying to use the following patch.  It's a
slight modification of a patch posted previously by Jiri.

diff -ru vanilla.orig/drivers/hid/hid-input-quirks.c vanilla/drivers/hid/hid-input-quirks.c
--- vanilla.orig/drivers/hid/hid-input-quirks.c	2008-04-16 19:49:44.000000000 -0700
+++ vanilla/drivers/hid/hid-input-quirks.c	2008-06-09 14:47:01.000000000 -0700
@@ -418,6 +418,27 @@
 		input_event(input, usage->type, REL_WHEEL, -value);
 		return 1;
 	}
+	/* "Sleep" key */
+	if (hid->vendor == 0x0c16 && hid->product == 0x0002 &&
+	    (usage->hid & HID_USAGE_PAGE) == HID_UP_GENDESK &&
+	    (usage->hid & 0xf0) == 0x80 &&
+	    (usage->hid & 0xf) == 0x2) {
+		input_event(input, usage->type, usage->code, 1);
+		input_sync(input);
+		input_event(input, usage->type, usage->code, 0);
+		input_sync(input);
+		return 0;
+	}
+	/* "TV" key */
+	if (hid->vendor == 0x0c16 && hid->product == 0x0002 &&
+	    (usage->hid & HID_USAGE_PAGE) == HID_UP_LOGIVENDOR &&
+	    (usage->hid & HID_USAGE) == 0x0000) {
+		input_event(input, usage->type, usage->code, 1);
+		input_sync(input);
+		input_event(input, usage->type, usage->code, 0);
+		input_sync(input);
+		return 0;
+	}
 	return 0;
 }
 
diff -ru vanilla.orig/drivers/hid/hid-input.c vanilla/drivers/hid/hid-input.c
--- vanilla.orig/drivers/hid/hid-input.c	2008-04-16 19:49:44.000000000 -0700
+++ vanilla/drivers/hid/hid-input.c	2008-06-09 14:49:43.000000000 -0700
@@ -724,7 +724,12 @@
 
 		case HID_UP_LOGIVENDOR:
 
-			goto ignore;
+		  set_bit(EV_REP, input->evbit);
+		  switch(usage->hid & HID_USAGE) {
+		  	case 0x027: map_key_clear(KEY_TV); break;
+		  	default: goto ignore;
+		  };
+		  break;
 		
 		case HID_UP_PID:
 

However this patch does not seem to work at all:

 * the Power button keeps repeating the power key once pressed

 * the home (windows MCE green button) and the four keys below it
   (shortcuts to movies, music, photos, tv) do not work.

Is there anything I can help with to get a working patch?

Thanks,
Phil.

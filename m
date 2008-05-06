Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbYEFTym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbYEFTym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760352AbYEFTya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:54:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757465AbYEFTy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:54:27 -0400
Date: Tue, 6 May 2008 12:54:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dag Bakke <dag@bakke.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>,
       "Diego 'Flameeyes' Petteno" <flameeyes@gmail.com>
Subject: Re: [PATCH] fix apple alu keyboard with numpad
Message-Id: <20080506125406.dc047710.akpm@linux-foundation.org>
In-Reply-To: <4814612F.5030606@bakke.com>
References: <4814612F.5030606@bakke.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 13:19:11 +0200
Dag Bakke <dag@bakke.com> wrote:

> The nice apple alu keyboards with numpads are pretty much unusable in
> vanilla 2.6.25.
> (http://images.apple.com/keyboard/images/gallery/wired_1_20070813.jpg)
> Hitting the 'clear' key (=numlock) disables the numpad, and maps multiple
> alphanumeric keys to numpad symbols in typical laptopkeyboard fashion.
> 
> Furthermore, some of the F-keys do double duty as multimedia keys. The
> vanilla kernel defaults to multimedia keys, requiring the user to hit
> the 'fn' key to get F-key events. I use F-keys more often than multimedia
> keys, so I included the patch to change the default to be F-keys.
> 
> The following patch is taken from:
> https://bugs.launchpad.net/mactel-support/+bug/201887
> and appears to have been written by Eric Johney. I have merely lifted
> the two patches from the webpage above and submitted it, as I couldn't
> see it upstream after a brief search.
> 
> 
> Tested-by: dag@bakke.com
> 
> --- linux-2.6.25-gentoo/drivers/hid/hid-input.c 2008-04-17 04:49:44.000000000 +0200
> +++ linux-2.6.25-gentoo-r1-apple/drivers/hid/hid-input.c        2008-04-25 23:07:52.925613698 +0200
> @@ -34,7 +34,7 @@
>   #include <linux/hid.h>
>   #include <linux/hid-debug.h>
> 
> -static int hid_apple_fnmode = 1;
> +static int hid_apple_fnmode = 2;
>   module_param_named(pb_fnmode, hid_apple_fnmode, int, 0644);
>   MODULE_PARM_DESC(pb_fnmode,
>                  "Mode of fn key on Apple keyboards (0 = disabled, 1 = fkeyslast, 2 = fkeysfirst)");
> @@ -218,8 +218,9 @@
>                          }
>                  }
> 
> -               if (test_bit(usage->code, hid->pb_pressed_numlock) ||
> -                               test_bit(LED_NUML, input->led)) {
> +               if ((test_bit(usage->code, hid->pb_pressed_numlock) ||
> +                               test_bit(LED_NUML, input->led)) &&
> +                               (hid->product < 0x220 ||hid->product >= 0x300)) {
>                          trans = find_translation(powerbook_numlock_keys, usage->code);
> 
>                          if (trans) {
> 
> 
> 
> For "completeness" and the benfit of someone finding this in an archive
> later, the following 4 commands provides correct keys for
> the multimediakeys in X:
> 
> setxkbmap -model macintosh
> xmodmap -e "keycode 162 = XF86AudioPlay"
> xmodmap -e "keycode 153 = XF86AudioNext"
> xmodmap -e "keycode 144 = XF86AudioPrev"
> 
> Works with a US layout keyboard, anyway.
> 

This conflicts rather directly with
hid-disable-numlock-emulation-for-apple-aluminium-keyboards.patch below
(hm, seems we didn't get a changelog for that one).


Jiri, what should we do here?

Thanks

From: "Diego 'Flameeyes' Petteno" <flameeyes@gmail.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-input.c         |    5 ++--
 drivers/hid/usbhid/hid-quirks.c |   32 +++++++++++++++---------------
 include/linux/hid.h             |    1 
 3 files changed, 20 insertions(+), 18 deletions(-)

diff -puN drivers/hid/hid-input.c~hid-disable-numlock-emulation-for-apple-aluminium-keyboards drivers/hid/hid-input.c
--- a/drivers/hid/hid-input.c~hid-disable-numlock-emulation-for-apple-aluminium-keyboards
+++ a/drivers/hid/hid-input.c
@@ -218,8 +218,9 @@ int hidinput_apple_event(struct hid_devi
 			}
 		}
 
-		if (test_bit(usage->code, hid->pb_pressed_numlock) ||
-				test_bit(LED_NUML, input->led)) {
+		if (hid->quirks & HID_QUIRK_APPLE_NUMLOCK_EMULATION && (
+				test_bit(usage->code, hid->pb_pressed_numlock) ||
+				test_bit(LED_NUML, input->led))) {
 			trans = find_translation(powerbook_numlock_keys, usage->code);
 
 			if (trans) {
diff -puN drivers/hid/usbhid/hid-quirks.c~hid-disable-numlock-emulation-for-apple-aluminium-keyboards drivers/hid/usbhid/hid-quirks.c
--- a/drivers/hid/usbhid/hid-quirks.c~hid-disable-numlock-emulation-for-apple-aluminium-keyboards
+++ a/drivers/hid/usbhid/hid-quirks.c
@@ -613,28 +613,28 @@ static const struct hid_blacklist {
 
 	{ USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS, HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
 
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ANSI, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE | HID_QUIRK_APPLE_ISO_KEYBOARD},
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_JIS, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ANSI, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE | HID_QUIRK_APPLE_ISO_KEYBOARD},
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_JIS, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ANSI, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE | HID_QUIRK_APPLE_ISO_KEYBOARD},
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE | HID_QUIRK_APPLE_ISO_KEYBOARD},
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE | HID_QUIRK_APPLE_ISO_KEYBOARD},
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE | HID_QUIRK_APPLE_ISO_KEYBOARD},
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ANSI, HID_QUIRK_APPLE_HAS_FN },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_JIS, HID_QUIRK_APPLE_HAS_FN },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI, HID_QUIRK_APPLE_HAS_FN },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS, HID_QUIRK_APPLE_HAS_FN },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
 
 	{ USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_W7658, HID_QUIRK_RESET_LEDS },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KBD, HID_QUIRK_RESET_LEDS },
diff -puN include/linux/hid.h~hid-disable-numlock-emulation-for-apple-aluminium-keyboards include/linux/hid.h
--- a/include/linux/hid.h~hid-disable-numlock-emulation-for-apple-aluminium-keyboards
+++ a/include/linux/hid.h
@@ -285,6 +285,7 @@ struct hid_item {
 #define HID_QUIRK_HWHEEL_WHEEL_INVERT		0x04000000
 #define HID_QUIRK_MICROSOFT_KEYS		0x08000000
 #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
+#define HID_QUIRK_APPLE_NUMLOCK_EMULATION	0x20000000
 
 /*
  * Separate quirks for runtime report descriptor fixup
_


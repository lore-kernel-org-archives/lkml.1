Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbXFOKvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbXFOKvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 06:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbXFOKvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 06:51:10 -0400
Received: from twin.jikos.cz ([213.151.79.26]:35732 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbXFOKvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 06:51:09 -0400
Date: Fri, 15 Jun 2007 12:51:05 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Islam Amer <pharon@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: USB remote control missing keycodes
In-Reply-To: <Pine.LNX.4.64.0706151211210.23280@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0706151249520.23280@twin.jikos.cz>
References: <20070611101319.GA14284@DervishD> <466D2DF7.9020709@aladin.ro> 
 <1181563063.19258.11.camel@iamer-laptop>  <Pine.LNX.4.64.0706111656340.23280@twin.jikos.cz>
  <1181743734.6163.1.camel@iamer-laptop>  <Pine.LNX.4.64.0706131654180.23280@twin.jikos.cz>
  <d120d5000706130817v5b9291d4h8653ade63882d2bc@mail.gmail.com> 
 <Pine.LNX.4.64.0706131741420.23280@twin.jikos.cz>  <1181750326.6163.6.camel@iamer-laptop>
  <Pine.LNX.4.64.0706131809530.23280@twin.jikos.cz> <1181823597.6136.8.camel@iamer-laptop>
 <Pine.LNX.4.64.0706141425180.23280@twin.jikos.cz>
 <Pine.LNX.4.64.0706151211210.23280@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, Jiri Kosina wrote:

> please try the patch below (against 2.6.22-rc4) and send me the result.

Now I see in the logs that there are also messages about the 
report initialization failing, so we should also specify NOGET for this 
device.

Could you please try the patch below instead, which does just that? 
Thanks.

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 7f81789..a112da2 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -566,6 +566,10 @@ static void hidinput_configure_usage(str
 				case 0x0e5: map_key_clear(KEY_BASSBOOST);	break;
 				case 0x0e9: map_key_clear(KEY_VOLUMEUP);	break;
 				case 0x0ea: map_key_clear(KEY_VOLUMEDOWN);	break;
+
+				/* reserved in HUT 1.12. Reported on Petalynx remote */
+				case 0x0fa: map_key_clear(KEY_BACK);		break;
+
 				case 0x183: map_key_clear(KEY_CONFIG);		break;
 				case 0x184: map_key_clear(KEY_WORDPROCESSOR);	break;
 				case 0x185: map_key_clear(KEY_EDITOR);		break;
@@ -704,10 +708,10 @@ static void hidinput_configure_usage(str
 			}
 			break;
 
-		case HID_UP_LOGIVENDOR: /* Reported on Logitech Ultra X Media Remote */
-
+		case HID_UP_LOGIVENDOR:
 			set_bit(EV_REP, input->evbit);
 			switch(usage->hid & HID_USAGE) {
+				/* Reported on Logitech Ultra X Media Remote */
 				case 0x004: map_key_clear(KEY_AGAIN);		break;
 				case 0x00d: map_key_clear(KEY_HOME);		break;
 				case 0x024: map_key_clear(KEY_SHUFFLE);		break;
@@ -725,6 +729,14 @@ static void hidinput_configure_usage(str
 				case 0x04d: map_key_clear(KEY_SUBTITLE);	break;
 				case 0x051: map_key_clear(KEY_RED);		break;
 				case 0x052: map_key_clear(KEY_CLOSE);		break;
+
+				/* Reported on Petalynx Maxter remote */
+				case 0x05a: map_key_clear(KEY_TEXT);		break;
+				case 0x05b: map_key_clear(KEY_RED);		break;
+				case 0x05c: map_key_clear(KEY_GREEN);		break;
+				case 0x05d: map_key_clear(KEY_YELLOW);		break;
+				case 0x05e: map_key_clear(KEY_BLUE);		break;
+
 				default:    goto ignore;
 			}
 			break;
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index d91b9da..b575a07 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -688,6 +688,22 @@ static void hid_fixup_logitech_descripto
 	}
 }
 
+/* Petalynx Maxter Remote has maximum for consumer page set too low */
+static void hid_fixup_petalynx_descriptor(unsigned char *rdesc, int rsize)
+{
+	if (rsize >= 60 && rdesc[39] == 0x2a
+			&& rdesc[40] == 0xf5
+			&& rdesc[41] == 0x00
+			&& rdesc[59] == 0x26
+			&& rdesc[60] == 0xf9
+			&& rdesc[61] == 0x00) {
+		info("Fixing up Petalynx Maxter Remote report descriptor");
+		rdesc[60] = 0xfa;
+		rdesc[40] = 0xfa;
+	} else
+		info("Not fixing up Petalynx Maxter Remote report descriptor");
+}
+
 /*
  * Some USB barcode readers from cypress have usage min and usage max in
  * the wrong order
@@ -781,6 +797,9 @@ static struct hid_device *usb_hid_config
 	if (quirks & HID_QUIRK_SWAPPED_MIN_MAX)
 		hid_fixup_cypress_descriptor(rdesc, rsize);
 
+	if (quirks & HID_QUIRK_PETALYNX_DESCRIPTOR)
+		hid_fixup_petalynx_descriptor(rdesc, rsize);
+
 #ifdef CONFIG_HID_DEBUG
 	printk(KERN_DEBUG __FILE__ ": report descriptor (size %u, read %d) = ", rsize, n);
 	for (n = 0; n < rsize; n++)
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index f6c4145..bb34e90 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -220,6 +220,9 @@
 #define USB_VENDOR_ID_PANTHERLORD	0x0810
 #define USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK	0x0001
 
+#define USB_VENDOR_ID_PETALYNX		0x18b1
+#define USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE	0x0037
+
 #define USB_VENDOR_ID_PLAYDOTCOM	0x0b43
 #define USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII	0x0003
 
@@ -418,6 +421,8 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_PANTHERLORD, USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK, HID_QUIRK_MULTI_INPUT | HID_QUIRK_SKIP_OUTPUT_REPORTS },
 	{ USB_VENDOR_ID_PLAYDOTCOM, USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII, HID_QUIRK_MULTI_INPUT },
 
+	{ USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE, HID_QUIRK_PETALYNX_DESCRIPTOR | HID_QUIRK_NOGET },
+
 	{ USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER, HID_QUIRK_SONY_PS3_CONTROLLER },
 
 	{ USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_UC100KM, HID_QUIRK_NOGET },
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 827ee74..3b1d638 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -276,6 +276,7 @@ struct hid_item {
 #define HID_QUIRK_DUPLICATE_USAGES		0x00200000
 #define HID_QUIRK_RESET_LEDS			0x00400000
 #define HID_QUIRK_SWAPPED_MIN_MAX		0x00800000
+#define HID_QUIRK_PETALYNX_DESCRIPTOR		0x01000000
 
 /*
  * This is the global environment of the parser. This information is

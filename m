Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbYJKGyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbYJKGyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbYJKGj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:39:28 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:52476 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYJKGhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:07 -0400
Date: Sat, 11 Oct 2008 02:36:12 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 52/85] fujitsu-laptop: better handling of P8010 hotkey
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Peter Gruber <nokos@gmx.net>, Len Brown <len.brown@intel.com>
Message-id: <0e6a66e9cf231140d2e49064d48162728edb7746.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

This patch (mostly from Peter Gruber) improves the handling of the hotkeys
for P8010 laptops by passing more accurate input events back to userspace.
This is needed because the P8010 labels these buttons quite differently to
earlier laptops.  As part of this, a P8010-specific DMI callback check has
been implemented.  Finally there's some minor whitespace cleanups from
running the source through Lindent.

Signed-off-by: Peter Gruber <nokos@gmx.net>
Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/misc/fujitsu-laptop.c |  123 +++++++++++++++++++++++-----------------
 1 files changed, 71 insertions(+), 52 deletions(-)

diff --git a/drivers/misc/fujitsu-laptop.c b/drivers/misc/fujitsu-laptop.c
index 3e56203..f861db0 100644
--- a/drivers/misc/fujitsu-laptop.c
+++ b/drivers/misc/fujitsu-laptop.c
@@ -44,8 +44,9 @@
  * Hotkeys present on certain Fujitsu laptops (eg: the S6xxx series) are
  * also supported by this driver.
  *
- * This driver has been tested on a Fujitsu Lifebook S6410 and S7020.  It
- * should work on most P-series and S-series Lifebooks, but YMMV.
+ * This driver has been tested on a Fujitsu Lifebook S6410, S7020 and
+ * P8010.  It should work on most P-series and S-series Lifebooks, but
+ * YMMV.
  *
  * The module parameter use_alt_lcd_levels switches between different ACPI
  * brightness controls which are used by different Fujitsu laptops.  In most
@@ -65,7 +66,7 @@
 #include <linux/video_output.h>
 #include <linux/platform_device.h>
 
-#define FUJITSU_DRIVER_VERSION "0.4.2"
+#define FUJITSU_DRIVER_VERSION "0.4.3"
 
 #define FUJITSU_LCD_N_LEVELS 8
 
@@ -83,10 +84,10 @@
 #define ACPI_VIDEO_NOTIFY_DEC_BRIGHTNESS     0x87
 
 /* Hotkey details */
-#define LOCK_KEY	0x410	/* codes for the keys in the GIRB register */
-#define DISPLAY_KEY	0x411	/* keys are mapped to KEY_SCREENLOCK (the key with the key symbol) */
-#define ENERGY_KEY	0x412	/* KEY_MEDIA (the key with the laptop symbol, KEY_EMAIL (E key)) */
-#define REST_KEY	0x413	/* KEY_SUSPEND (R key) */
+#define KEY1_CODE	0x410	/* codes for the keys in the GIRB register */
+#define KEY2_CODE	0x411
+#define KEY3_CODE	0x412
+#define KEY4_CODE	0x413
 
 #define MAX_HOTKEY_RINGBUFFER_SIZE 100
 #define RINGBUFFERSIZE 40
@@ -123,6 +124,7 @@ struct fujitsu_t {
 	char phys[32];
 	struct backlight_device *bl_device;
 	struct platform_device *pf_device;
+	int keycode1, keycode2, keycode3, keycode4;
 
 	unsigned int max_brightness;
 	unsigned int brightness_changed;
@@ -430,7 +432,7 @@ static struct platform_driver fujitsupf_driver = {
 		   }
 };
 
-static int dmi_check_cb_s6410(const struct dmi_system_id *id)
+static void dmi_check_cb_common(const struct dmi_system_id *id)
 {
 	acpi_handle handle;
 	int have_blnf;
@@ -452,24 +454,40 @@ static int dmi_check_cb_s6410(const struct dmi_system_id *id)
 			    "auto-detecting disable_adjust\n");
 		disable_brightness_adjust = have_blnf ? 0 : 1;
 	}
+}
+
+static int dmi_check_cb_s6410(const struct dmi_system_id *id)
+{
+	dmi_check_cb_common(id);
+	fujitsu->keycode1 = KEY_SCREENLOCK;	/* "Lock" */
+	fujitsu->keycode2 = KEY_HELP;	/* "Mobility Center" */
+	return 0;
+}
+
+static int dmi_check_cb_p8010(const struct dmi_system_id *id)
+{
+	dmi_check_cb_common(id);
+	fujitsu->keycode1 = KEY_HELP;	/* "Support" */
+	fujitsu->keycode3 = KEY_SWITCHVIDEOMODE;	/* "Presentation" */
+	fujitsu->keycode4 = KEY_WWW;	/* "Internet" */
 	return 0;
 }
 
 static struct dmi_system_id __initdata fujitsu_dmi_table[] = {
 	{
-	 .ident = "Fujitsu Siemens",
+	 .ident = "Fujitsu Siemens S6410",
 	 .matches = {
 		     DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
 		     DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK S6410"),
 		     },
 	 .callback = dmi_check_cb_s6410},
 	{
-	 .ident = "FUJITSU LifeBook P8010",
+	 .ident = "Fujitsu LifeBook P8010",
 	 .matches = {
 		     DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
 		     DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook P8010"),
-		    },
-	 .callback = dmi_check_cb_s6410},
+		     },
+	 .callback = dmi_check_cb_p8010},
 	{}
 };
 
@@ -547,7 +565,6 @@ static int acpi_fujitsu_add(struct acpi_device *device)
 	}
 
 	/* do config (detect defaults) */
-	dmi_check_system(fujitsu_dmi_table);
 	use_alt_lcd_levels = use_alt_lcd_levels == 1 ? 1 : 0;
 	disable_brightness_keys = disable_brightness_keys == 1 ? 1 : 0;
 	disable_brightness_adjust = disable_brightness_adjust == 1 ? 1 : 0;
@@ -623,17 +640,17 @@ static void acpi_fujitsu_notify(acpi_handle handle, u32 event, void *data)
 			keycode = 0;
 			if (disable_brightness_keys != 1) {
 				if (oldb == 0) {
-					acpi_bus_generate_proc_event(fujitsu->
-						dev,
-						ACPI_VIDEO_NOTIFY_DEC_BRIGHTNESS,
-						0);
+					acpi_bus_generate_proc_event
+					    (fujitsu->dev,
+					     ACPI_VIDEO_NOTIFY_DEC_BRIGHTNESS,
+					     0);
 					keycode = KEY_BRIGHTNESSDOWN;
 				} else if (oldb ==
 					   (fujitsu->max_brightness) - 1) {
-					acpi_bus_generate_proc_event(fujitsu->
-						dev,
-						ACPI_VIDEO_NOTIFY_INC_BRIGHTNESS,
-						0);
+					acpi_bus_generate_proc_event
+					    (fujitsu->dev,
+					     ACPI_VIDEO_NOTIFY_INC_BRIGHTNESS,
+					     0);
 					keycode = KEY_BRIGHTNESSUP;
 				}
 			}
@@ -646,8 +663,7 @@ static void acpi_fujitsu_notify(acpi_handle handle, u32 event, void *data)
 			}
 			if (disable_brightness_keys != 1) {
 				acpi_bus_generate_proc_event(fujitsu->dev,
-					ACPI_VIDEO_NOTIFY_INC_BRIGHTNESS,
-					0);
+					ACPI_VIDEO_NOTIFY_INC_BRIGHTNESS, 0);
 				keycode = KEY_BRIGHTNESSUP;
 			}
 		} else if (oldb > newb) {
@@ -659,8 +675,7 @@ static void acpi_fujitsu_notify(acpi_handle handle, u32 event, void *data)
 			}
 			if (disable_brightness_keys != 1) {
 				acpi_bus_generate_proc_event(fujitsu->dev,
-					ACPI_VIDEO_NOTIFY_DEC_BRIGHTNESS,
-					0);
+					ACPI_VIDEO_NOTIFY_DEC_BRIGHTNESS, 0);
 				keycode = KEY_BRIGHTNESSDOWN;
 			}
 		} else {
@@ -742,10 +757,10 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 	input->id.product = 0x06;
 	input->dev.parent = &device->dev;
 	input->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_SCREENLOCK, input->keybit);
-	set_bit(KEY_MEDIA, input->keybit);
-	set_bit(KEY_EMAIL, input->keybit);
-	set_bit(KEY_SUSPEND, input->keybit);
+	set_bit(fujitsu->keycode1, input->keybit);
+	set_bit(fujitsu->keycode2, input->keybit);
+	set_bit(fujitsu->keycode3, input->keybit);
+	set_bit(fujitsu->keycode4, input->keybit);
 	set_bit(KEY_UNKNOWN, input->keybit);
 
 	error = input_register_device(input);
@@ -833,24 +848,24 @@ static void acpi_fujitsu_hotkey_notify(acpi_handle handle, u32 event,
 				    irb);
 
 			switch (irb & 0x4ff) {
-			case LOCK_KEY:
-				keycode = KEY_SCREENLOCK;
+			case KEY1_CODE:
+				keycode = fujitsu->keycode1;
 				break;
-			case DISPLAY_KEY:
-				keycode = KEY_MEDIA;
+			case KEY2_CODE:
+				keycode = fujitsu->keycode2;
 				break;
-			case ENERGY_KEY:
-				keycode = KEY_EMAIL;
+			case KEY3_CODE:
+				keycode = fujitsu->keycode3;
 				break;
-			case REST_KEY:
-				keycode = KEY_SUSPEND;
+			case KEY4_CODE:
+				keycode = fujitsu->keycode4;
 				break;
 			case 0:
 				keycode = 0;
 				break;
 			default:
 				vdbg_printk(FUJLAPTOP_DBG_WARN,
-					"Unknown GIRB result [%x]\n", irb);
+					    "Unknown GIRB result [%x]\n", irb);
 				keycode = -1;
 				break;
 			}
@@ -859,12 +874,12 @@ static void acpi_fujitsu_hotkey_notify(acpi_handle handle, u32 event,
 					"Push keycode into ringbuffer [%d]\n",
 					keycode);
 				status = kfifo_put(fujitsu_hotkey->fifo,
-						(unsigned char *)&keycode,
-						sizeof(keycode));
+						   (unsigned char *)&keycode,
+						   sizeof(keycode));
 				if (status != sizeof(keycode)) {
 					vdbg_printk(FUJLAPTOP_DBG_WARN,
-						"Could not push keycode [0x%x]\n",
-						keycode);
+					    "Could not push keycode [0x%x]\n",
+					    keycode);
 				} else {
 					input_report_key(input, keycode, 1);
 					input_sync(input);
@@ -879,8 +894,8 @@ static void acpi_fujitsu_hotkey_notify(acpi_handle handle, u32 event,
 					input_report_key(input, keycode_r, 0);
 					input_sync(input);
 					vdbg_printk(FUJLAPTOP_DBG_TRACE,
-						    "Pop keycode from ringbuffer [%d]\n",
-						    keycode_r);
+					  "Pop keycode from ringbuffer [%d]\n",
+					  keycode_r);
 				}
 			}
 		}
@@ -943,6 +958,11 @@ static int __init fujitsu_init(void)
 	if (!fujitsu)
 		return -ENOMEM;
 	memset(fujitsu, 0, sizeof(struct fujitsu_t));
+	fujitsu->keycode1 = KEY_PROG1;
+	fujitsu->keycode2 = KEY_PROG2;
+	fujitsu->keycode3 = KEY_PROG3;
+	fujitsu->keycode4 = KEY_PROG4;
+	dmi_check_system(fujitsu_dmi_table);
 
 	result = acpi_bus_register_driver(&acpi_fujitsu_driver);
 	if (result < 0) {
@@ -1076,15 +1096,14 @@ MODULE_DESCRIPTION("Fujitsu laptop extras support");
 MODULE_VERSION(FUJITSU_DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
-MODULE_ALIAS
-    ("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1D3:*:cvrS6410:*");
-MODULE_ALIAS
-    ("dmi:*:svnFUJITSU:*:pvr:rvnFUJITSU:rnFJNB19C:*:cvrS7020:*");
+MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1D3:*:cvrS6410:*");
+MODULE_ALIAS("dmi:*:svnFUJITSU:*:pvr:rvnFUJITSU:rnFJNB19C:*:cvrS7020:*");
 
 static struct pnp_device_id pnp_ids[] = {
-	{ .id = "FUJ02bf" },
-	{ .id = "FUJ02B1" },
-	{ .id = "FUJ02E3" },
-	{ .id = "" }
+	{.id = "FUJ02bf"},
+	{.id = "FUJ02B1"},
+	{.id = "FUJ02E3"},
+	{.id = ""}
 };
+
 MODULE_DEVICE_TABLE(pnp, pnp_ids);
-- 
1.5.5.1


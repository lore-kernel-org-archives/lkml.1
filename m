Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZLHH0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZLHH0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZLHH0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:26:11 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34704 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZLHH0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:26:09 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net
Cc: Corentin Chary <corentin.chary@gmail.com>,
       Alexandre Rostovtsev <tetromino@gmail.com>
Subject: [PATCH] asus-laptop: add Lenovo SL LenovoCare LED support
Date: Tue,  8 Dec 2009 15:26:09 +0800
Message-Id: <1260257169-7227-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ike Panhc <ikepanhc@canonical.com>

This patch is to enable the LenovoCare LED support on Lenovo SL laptop. Based
on the found of the control interface by Alexandre Rostovtsev

Turn on the LenovoCare LED:
 (As root privileges) echo 1 > /sys/class/leds/asus\:\:LenovoCare/brightness
Trun off the LenovoCare LED:
 (As root privileges) echo 0 > /sys/class/leds/asus\:\:LenovoCare/brightness

The patch against current checkout of acpi4asus is below.

Signed-off-by: Ike Panhc <ikepanhc@canonical.com>
---
 drivers/platform/x86/asus-laptop.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 3348cc6..f3c52b6 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -87,6 +87,7 @@
 #define LCD_ON      0x80	/* LCD backlight */
 #define GPS_ON      0x100	/* GPS */
 #define KEY_ON      0x200	/* Keyboard backlight */
+#define LLED_ON     0x400	/* Lenovo SL: LenovoCare LED */
 
 #define ASUS_LOG    ASUS_HOTK_FILE ": "
 #define ASUS_ERR    KERN_ERR    ASUS_LOG
@@ -123,6 +124,7 @@ ASUS_HANDLE(tled_set, ASUS_HOTK_PREFIX "TLED");
 ASUS_HANDLE(rled_set, ASUS_HOTK_PREFIX "RLED");	/* W1JC */
 ASUS_HANDLE(pled_set, ASUS_HOTK_PREFIX "PLED");	/* A7J */
 ASUS_HANDLE(gled_set, ASUS_HOTK_PREFIX "GLED");	/* G1, G2 (probably) */
+ASUS_HANDLE(lled_set, "\\_SB_.PCI0.SBRG.EC0_.HKEY.TVLS"); /* LenovoCare */
 
 /* LEDD */
 ASUS_HANDLE(ledd_set, ASUS_HOTK_PREFIX "SLCM");
@@ -285,6 +287,7 @@ ASUS_LED(rled, "record", 1);
 ASUS_LED(pled, "phone", 1);
 ASUS_LED(gled, "gaming", 1);
 ASUS_LED(kled, "kbd_backlight", 3);
+ASUS_LED(lled, "LenovoCare", 1);
 
 struct key_entry {
 	char type;
@@ -419,6 +422,9 @@ static void write_status(acpi_handle handle, int out, int mask)
 		handle = (out) ? gps_on_handle : gps_off_handle;
 		out = 0x02;
 		break;
+	case LLED_ON:
+		out = (out & 0x1) * 0xFF;
+		break;
 	default:
 		out &= 0x1;
 		break;
@@ -452,6 +458,7 @@ ASUS_LED_HANDLER(pled, PLED_ON);
 ASUS_LED_HANDLER(rled, RLED_ON);
 ASUS_LED_HANDLER(tled, TLED_ON);
 ASUS_LED_HANDLER(gled, GLED_ON);
+ASUS_LED_HANDLER(lled, LLED_ON);
 
 /*
  * Keyboard backlight
@@ -1146,6 +1153,7 @@ static int asus_hotk_get_info(void)
 	ASUS_HANDLE_INIT(rled_set);
 	ASUS_HANDLE_INIT(pled_set);
 	ASUS_HANDLE_INIT(gled_set);
+	ASUS_HANDLE_INIT(lled_set);
 
 	ASUS_HANDLE_INIT(ledd_set);
 
@@ -1338,6 +1346,7 @@ static void asus_led_exit(void)
 	ASUS_LED_UNREGISTER(rled);
 	ASUS_LED_UNREGISTER(gled);
 	ASUS_LED_UNREGISTER(kled);
+	ASUS_LED_UNREGISTER(lled);
 }
 
 static void asus_input_exit(void)
@@ -1417,19 +1426,25 @@ static int asus_led_init(struct device *dev)
 	if (rv)
 		goto out4;
 
+	rv = ASUS_LED_REGISTER(lled, dev);
+	if (rv)
+		goto out5;
+
 	if (kled_set_handle && kled_get_handle)
 		rv = ASUS_LED_REGISTER(kled, dev);
 	if (rv)
-		goto out5;
+		goto out6;
 
 	led_workqueue = create_singlethread_workqueue("led_workqueue");
 	if (!led_workqueue)
-		goto out6;
+		goto out7;
 
 	return 0;
-out6:
+out7:
 	rv = -ENOMEM;
 	ASUS_LED_UNREGISTER(kled);
+out6:
+	ASUS_LED_UNREGISTER(lled);
 out5:
 	ASUS_LED_UNREGISTER(gled);
 out4:
-- 
1.6.3.3


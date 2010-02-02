Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab0BBHyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:54:17 -0500
Received: from iksaif.net ([88.191.73.63]:50275 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab0BBHwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:12 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 22/28] asus-laptop: add backlight changes notifications
Date: Tue,  2 Feb 2010 08:39:05 +0100
Message-Id: <1265096351-15239-23-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-22-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-8-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-9-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-10-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-11-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-12-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-13-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-14-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-15-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-16-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-17-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-18-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-19-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-20-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-21-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-22-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't want to send KEY_BRIGHTNESSDOWN or KEY_BRIGHTNESSUP
because it would be a lie to tell userspace that we want
to change the brightness while it's actually done by the
firmware.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   29 +++++++++++++++++++++++++++--
 1 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 4f3c467..516add3 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -93,8 +93,10 @@ MODULE_PARM_DESC(bluetooth_status, "Set the wireless status on boot "
 /*
  * Some events we use, same for all Asus
  */
-#define ATKD_BR_UP	0x10
-#define ATKD_BR_DOWN	0x20
+#define ATKD_BR_UP	0x10	// (event & ~ATKD_BR_UP) = brightness level
+#define ATKD_BR_DOWN	0x20	// (event & ~ATKD_BR_DOWN) = britghness level
+#define ATKD_BR_MIN	ATKD_BR_UP
+#define ATKD_BR_MAX	(ATKD_BR_DOWN | 0xF)	// 0x2f
 #define ATKD_LCD_ON	0x33
 #define ATKD_LCD_OFF	0x34
 
@@ -245,11 +247,13 @@ struct asus_laptop {
 };
 
 static const struct key_entry asus_keymap[] = {
+	/* Lenovo SL Specific keycodes */
 	{KE_KEY, 0x02, { KEY_SCREENLOCK } },
 	{KE_KEY, 0x05, { KEY_WLAN } },
 	{KE_KEY, 0x08, { KEY_F13 } },
 	{KE_KEY, 0x17, { KEY_ZOOM } },
 	{KE_KEY, 0x1f, { KEY_BATTERY } },
+	/* End of Lenovo SL Specific keycodes */
 	{KE_KEY, 0x30, { KEY_VOLUMEUP } },
 	{KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
 	{KE_KEY, 0x32, { KEY_MUTE } },
@@ -626,6 +630,16 @@ static struct backlight_ops asusbl_ops = {
 	.update_status = update_bl_status,
 };
 
+static int asus_backlight_notify(struct asus_laptop *asus)
+{
+	struct backlight_device *bd = asus->backlight_device;
+	int old = bd->props.brightness;
+
+	backlight_force_update(bd, BACKLIGHT_UPDATE_HOTKEY);
+
+	return old;
+}
+
 static int asus_backlight_init(struct asus_laptop *asus)
 {
 	struct backlight_device *bd;
@@ -656,6 +670,7 @@ static void asus_backlight_exit(struct asus_laptop *asus)
 {
 	if (asus->backlight_device)
 		backlight_device_unregister(asus->backlight_device);
+	asus->backlight_device = NULL;
 }
 
 /*
@@ -1121,6 +1136,16 @@ static void asus_acpi_notify(struct acpi_device *device, u32 event)
 					dev_name(&asus->device->dev), event,
 					count);
 
+	/* Brightness events are special */
+	if (event >= ATKD_BR_MIN && event <= ATKD_BR_MAX) {
+
+		/* Ignore them completely if the acpi video driver is used */
+		if (asus->backlight_device != NULL) {
+			/* Update the backlight device. */
+			asus_backlight_notify(asus);
+		}
+		return ;
+	}
 	asus_input_notify(asus, event);
 }
 
-- 
1.6.6.1


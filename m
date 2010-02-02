Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0BBHzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:55:40 -0500
Received: from iksaif.net ([88.191.73.63]:50265 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847Ab0BBHwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:10 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 23/28] asus-laptop: leds, remove dead code and fix asus_led_exit()/asus_led_init()
Date: Tue,  2 Feb 2010 08:39:06 +0100
Message-Id: <1265096351-15239-24-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-23-git-send-email-corentincj@iksaif.net>
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
 <1265096351-15239-23-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corentin Chary <corentin.chary@gmail.com>

These bug where introduced in "asus-laptop: code movement".

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |   31 ++++++++++++++-----------------
 1 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 516add3..ca144d2 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -371,13 +371,7 @@ static int asus_led_set(struct asus_laptop *asus, char *method,
 				     enum led_brightness value);	\
 	static enum led_brightness object##_led_get(			\
 		struct led_classdev *led_cdev);				\
-	static void object##_led_update(struct work_struct *ignored);	\
-	static struct led_classdev object##_led = {			\
-		.name           = "asus::" ledname,			\
-		.brightness_set = object##_led_set,			\
-		.brightness_get = object##_led_get,			\
-		.max_brightness = max					\
-	}
+	static void object##_led_update(struct work_struct *ignored);
 
 ASUS_LED(mled, "mail", 1);
 ASUS_LED(tled, "touchpad", 1);
@@ -478,18 +472,20 @@ static enum led_brightness kled_led_get(struct led_classdev *led_cdev)
 	return asus_kled_lvl(asus);
 }
 
-#define ASUS_LED_UNREGISTER(object)				\
-	if (object##_led.dev)					\
-		led_classdev_unregister(&object##_led)
-
 static void asus_led_exit(struct asus_laptop *asus)
 {
-	ASUS_LED_UNREGISTER(mled);
-	ASUS_LED_UNREGISTER(tled);
-	ASUS_LED_UNREGISTER(pled);
-	ASUS_LED_UNREGISTER(rled);
-	ASUS_LED_UNREGISTER(gled);
-	ASUS_LED_UNREGISTER(kled);
+	if (asus->leds.mled.dev)
+		led_classdev_unregister(&asus->leds.mled);
+	if (asus->leds.tled.dev)
+		led_classdev_unregister(&asus->leds.tled);
+	if (asus->leds.pled.dev)
+		led_classdev_unregister(&asus->leds.pled);
+	if (asus->leds.rled.dev)
+		led_classdev_unregister(&asus->leds.rled);
+	if (asus->leds.gled.dev)
+		led_classdev_unregister(&asus->leds.gled);
+	if (asus->leds.kled.dev)
+		led_classdev_unregister(&asus->leds.kled);
 	if (asus->leds.workqueue) {
 		destroy_workqueue(asus->leds.workqueue);
 		asus->leds.workqueue = NULL;
@@ -507,6 +503,7 @@ static void asus_led_exit(struct asus_laptop *asus)
 		INIT_WORK(&asus->leds.object##_work, object##_led_update); \
 		ldev->name = "asus::" _name;				\
 		ldev->brightness_set = object##_led_set;		\
+		ldev->brightness_get = object##_led_get;		\
 		ldev->max_brightness = max;				\
 		rv = led_classdev_register(&asus->platform_device->dev, ldev); \
 		if (rv)							\
-- 
1.6.6.1


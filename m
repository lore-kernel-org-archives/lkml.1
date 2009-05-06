Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbZEFV4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbZEFV4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761267AbZEFVyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:25 -0400
Received: from kroah.org ([198.145.64.141]:56919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761337AbZEFVyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:56 2009
Message-Id: <20090506214755.892699093@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Len Brown <len.brown@intel.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 05/58] thinkpad-acpi: fix LED blinking through timer trigger
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=thinkpad-acpi-fix-led-blinking-through-timer-trigger.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

upstream commit: 75bd3bf2ade9d548be0d2bde60b5ee0fdce0b127

The set_blink hook code in the LED subdriver would never manage to get
a LED to blink, and instead it would just turn it on.  The consequence
of this is that the "timer" trigger would not cause the LED to blink
if given default parameters.

This problem exists since 2.6.26-rc1.

To fix it, switch the deferred LED work handling to use the
thinkpad-acpi-specific LED status (off/on/blink) directly.

This also makes the code easier to read, and to extend later.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: stable@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/platform/x86/thinkpad_acpi.c |   41 ++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -306,11 +306,17 @@ static u32 dbg_level;
 
 static struct workqueue_struct *tpacpi_wq;
 
+enum led_status_t {
+	TPACPI_LED_OFF = 0,
+	TPACPI_LED_ON,
+	TPACPI_LED_BLINK,
+};
+
 /* Special LED class that can defer work */
 struct tpacpi_led_classdev {
 	struct led_classdev led_classdev;
 	struct work_struct work;
-	enum led_brightness new_brightness;
+	enum led_status_t new_state;
 	unsigned int led;
 };
 
@@ -4057,7 +4063,7 @@ static void light_set_status_worker(stru
 			container_of(work, struct tpacpi_led_classdev, work);
 
 	if (likely(tpacpi_lifecycle == TPACPI_LIFE_RUNNING))
-		light_set_status((data->new_brightness != LED_OFF));
+		light_set_status((data->new_state != TPACPI_LED_OFF));
 }
 
 static void light_sysfs_set(struct led_classdev *led_cdev,
@@ -4067,7 +4073,8 @@ static void light_sysfs_set(struct led_c
 		container_of(led_cdev,
 			     struct tpacpi_led_classdev,
 			     led_classdev);
-	data->new_brightness = brightness;
+	data->new_state = (brightness != LED_OFF) ?
+				TPACPI_LED_ON : TPACPI_LED_OFF;
 	queue_work(tpacpi_wq, &data->work);
 }
 
@@ -4574,12 +4581,6 @@ enum {	/* For TPACPI_LED_OLD */
 	TPACPI_LED_EC_HLMS = 0x0e,	/* EC reg to select led to command */
 };
 
-enum led_status_t {
-	TPACPI_LED_OFF = 0,
-	TPACPI_LED_ON,
-	TPACPI_LED_BLINK,
-};
-
 static enum led_access_mode led_supported;
 
 TPACPI_HANDLE(led, ec, "SLED",	/* 570 */
@@ -4673,23 +4674,13 @@ static int led_set_status(const unsigned
 	return rc;
 }
 
-static void led_sysfs_set_status(unsigned int led,
-				 enum led_brightness brightness)
-{
-	led_set_status(led,
-			(brightness == LED_OFF) ?
-			TPACPI_LED_OFF :
-			(tpacpi_led_state_cache[led] == TPACPI_LED_BLINK) ?
-				TPACPI_LED_BLINK : TPACPI_LED_ON);
-}
-
 static void led_set_status_worker(struct work_struct *work)
 {
 	struct tpacpi_led_classdev *data =
 		container_of(work, struct tpacpi_led_classdev, work);
 
 	if (likely(tpacpi_lifecycle == TPACPI_LIFE_RUNNING))
-		led_sysfs_set_status(data->led, data->new_brightness);
+		led_set_status(data->led, data->new_state);
 }
 
 static void led_sysfs_set(struct led_classdev *led_cdev,
@@ -4698,7 +4689,13 @@ static void led_sysfs_set(struct led_cla
 	struct tpacpi_led_classdev *data = container_of(led_cdev,
 			     struct tpacpi_led_classdev, led_classdev);
 
-	data->new_brightness = brightness;
+	if (brightness == LED_OFF)
+		data->new_state = TPACPI_LED_OFF;
+	else if (tpacpi_led_state_cache[data->led] != TPACPI_LED_BLINK)
+		data->new_state = TPACPI_LED_ON;
+	else
+		data->new_state = TPACPI_LED_BLINK;
+
 	queue_work(tpacpi_wq, &data->work);
 }
 
@@ -4716,7 +4713,7 @@ static int led_sysfs_blink_set(struct le
 	} else if ((*delay_on != 500) || (*delay_off != 500))
 		return -EINVAL;
 
-	data->new_brightness = TPACPI_LED_BLINK;
+	data->new_state = TPACPI_LED_BLINK;
 	queue_work(tpacpi_wq, &data->work);
 
 	return 0;



Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbYERSxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbYERSxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759336AbYERSsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:48:14 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43499 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759455AbYERSsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:48:11 -0400
X-Sasl-enc: HW2bt8G1Z4Lyliv4SdBj6mnHmBhzjizdT3P+6G4SeSt2 1211136489
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, Thomas Renninger <trenn@suse.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 02/15] ACPI: thinkpad-acpi: fix LED handling on older ThinkPads
Date: Sun, 18 May 2008 15:47:52 -0300
Message-Id: <1211136485-19878-3-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The less tested codepaths for LED handling, used on ThinkPads 570, 600e/x,
770e, 770x, A21e, A2xm/p, T20-22, X20 and maybe a few others, would write
data to kernel memory it had no business touching, for leds number 3 and
above.  If one is lucky, that illegal write would cause an OOPS, but
chances are it would silently corrupt a byte.

The problem was introduced in commit af116101, "ACPI: thinkpad-acpi: add
sysfs led class support to thinkpad leds (v3.2)".

Fix the bug by refactoring the entire code to be far more obvious on what
it wants to do.  Also do some defensive "constification".

Issue reported by Karol Lewandowski <lmctlx@gmail.com> (he's an lucky guy
and got an OOPS instead of silent corruption :-) ).

Root cause of the OOPS identified by Adrian Bunk <bunk@kernel.org>.
Thanks, Adrian!

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Tested-by: Karol Lewandowski <lmctlx@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>
---
 drivers/misc/thinkpad_acpi.c |   55 +++++++++++++++++++++--------------------
 1 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 3c53668..5a560d9 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -3853,7 +3853,7 @@ static const char const *tpacpi_led_names[TPACPI_LED_NUMLEDS] = {
 	"tpacpi::standby",
 };
 
-static int led_get_status(unsigned int led)
+static int led_get_status(const unsigned int led)
 {
 	int status;
 	enum led_status_t led_s;
@@ -3877,41 +3877,42 @@ static int led_get_status(unsigned int led)
 	/* not reached */
 }
 
-static int led_set_status(unsigned int led, enum led_status_t ledstatus)
+static int led_set_status(const unsigned int led,
+			  const enum led_status_t ledstatus)
 {
 	/* off, on, blink. Index is led_status_t */
-	static const int const led_sled_arg1[] = { 0, 1, 3 };
-	static const int const led_exp_hlbl[] = { 0, 0, 1 };	/* led# * */
-	static const int const led_exp_hlcl[] = { 0, 1, 1 };	/* led# * */
-	static const int const led_led_arg1[] = { 0, 0x80, 0xc0 };
+	static const unsigned int const led_sled_arg1[] = { 0, 1, 3 };
+	static const unsigned int const led_led_arg1[] = { 0, 0x80, 0xc0 };
 
 	int rc = 0;
 
 	switch (led_supported) {
 	case TPACPI_LED_570:
-			/* 570 */
-			led = 1 << led;
-			if (!acpi_evalf(led_handle, NULL, NULL, "vdd",
-					led, led_sled_arg1[ledstatus]))
-				rc = -EIO;
-			break;
+		/* 570 */
+		if (led > 7)
+			return -EINVAL;
+		if (!acpi_evalf(led_handle, NULL, NULL, "vdd",
+				(1 << led), led_sled_arg1[ledstatus]))
+			rc = -EIO;
+		break;
 	case TPACPI_LED_OLD:
-			/* 600e/x, 770e, 770x, A21e, A2xm/p, T20-22, X20 */
-			led = 1 << led;
-			rc = ec_write(TPACPI_LED_EC_HLMS, led);
-			if (rc >= 0)
-				rc = ec_write(TPACPI_LED_EC_HLBL,
-					      led * led_exp_hlbl[ledstatus]);
-			if (rc >= 0)
-				rc = ec_write(TPACPI_LED_EC_HLCL,
-					      led * led_exp_hlcl[ledstatus]);
-			break;
+		/* 600e/x, 770e, 770x, A21e, A2xm/p, T20-22, X20 */
+		if (led > 7)
+			return -EINVAL;
+		rc = ec_write(TPACPI_LED_EC_HLMS, (1 << led));
+		if (rc >= 0)
+			rc = ec_write(TPACPI_LED_EC_HLBL,
+				      (ledstatus == TPACPI_LED_BLINK) << led);
+		if (rc >= 0)
+			rc = ec_write(TPACPI_LED_EC_HLCL,
+				      (ledstatus != TPACPI_LED_OFF) << led);
+		break;
 	case TPACPI_LED_NEW:
-			/* all others */
-			if (!acpi_evalf(led_handle, NULL, NULL, "vdd",
-					led, led_led_arg1[ledstatus]))
-				rc = -EIO;
-			break;
+		/* all others */
+		if (!acpi_evalf(led_handle, NULL, NULL, "vdd",
+				led, led_led_arg1[ledstatus]))
+			rc = -EIO;
+		break;
 	default:
 		rc = -ENXIO;
 	}
-- 
1.5.5.1


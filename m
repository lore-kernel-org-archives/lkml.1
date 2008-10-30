Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbYJ3LFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbYJ3LFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbYJ3LEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:04:48 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:42349 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbYJ3LEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:04:47 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <490994DC.7040409@gmail.com>
Date: Thu, 30 Oct 2008 11:05:00 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Mike Rapoport <mike@compulab.co.il>, eric miao <eric.y.miao@gmail.com>,
       rpurdie@rpsys.net, LKML <linux-kernel@vger.kernel.org>
Subject: [LED bug fix] leds-da903x (da9030 only) led brightness reversed.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brightness control register calculation (for the pwm) is
effectively the reverse of what would be expected.
1 is maximum brightness, 255 minimum.

This patch inverts this.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

---
diff --git a/drivers/leds/leds-da903x.c b/drivers/leds/leds-da903x.c
index f1fddb1..ab632e9 100644
--- a/drivers/leds/leds-da903x.c
+++ b/drivers/leds/leds-da903x.c
@@ -57,7 +57,7 @@ static void da903x_led_work(struct work_struct *work)
 		offset = DA9030_LED_OFFSET(led->id);
 		val = led->flags & ~0x87;
 		val |= (led->new_brightness) ? 0x80 : 0; /* EN bit */
-		val |= (led->new_brightness >> 5) & 0x7; /* PWM<2:0> */
+		val |= (0x7 - (led->new_brightness >> 5)) & 0x7; /* PWM<2:0> */
 		da903x_write(led->master, DA9030_LED1_CONTROL + offset, val);
 		break;
 	case DA9030_ID_VIBRA:

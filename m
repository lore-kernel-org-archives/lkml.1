Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbXETMPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbXETMPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 08:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbXETMOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 08:14:55 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:44669 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbXETMOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 08:14:54 -0400
Message-ID: <46503B69.4080807@tremplin-utc.net>
Date: Sun, 20 May 2007 14:13:29 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.3) Gecko/20070423 Mandriva/2.0.0.0-1mdv2008.0 (2008.0) Thunderbird/2.0.0.0 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: mitr@volny.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] wistron_btns: reduce polling frequency (to save power)
Content-Type: multipart/mixed;
 boundary="------------090503030907020108090405"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090503030907020108090405
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I'm usually not a fashion victim, but I felt into the trap this time: 
I've launched powertop. As I noticed that wistron_btns was part of the 
topers (10 wake-up's per seconds), here is a patch that should reduce 
the problem. The driver now polls the hardware only twice per second.

Actually, I've tried to decrease the timer to 1 Hz, using round_jiffies 
it would have been an even bigger win, but latency was just too big from 
a user point of view. It's pity, there doesn't seem to be any API to 
synchronize a 2 Hz timer with the rounded timers :-(

It should apply against 2.6.22-rc2 (as well as input tree). It's 
completely orthogonal to my previous patch "add led support", so you can 
apply both in the order you like ;-) There is no particular urgency in 
this patch, so I guess you can keep it for 2.6.23.

See you,
Eric


--------------090503030907020108090405
Content-Type: text/x-patch;
 name="wistron_btns-reduce-timer-frequency-2.6.22.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wistron_btns-reduce-timer-frequency-2.6.22.patch"

From: Eric Piel <eric.piel@tremplin-utc.net>

wriston_btns: Reduce polling frequency

Reduces the polling frequency from 10 Hz to 2 Hz, which should be less a burden
for laptops wrt energy saving. As it is multimedia keys, 500ms (maximum) of
latency should be still fine for the user. In order to keep fluent the feeling
when the user is pressing several keys in a raw (such as changing the volume),
the frequency is increased for a short duration after a key is pressed.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>

--- linux-2.6.21/drivers/input/misc/wistron_btns.c.bak	2007-05-18 00:37:42.000000000 +0200
+++ linux-2.6.21/drivers/input/misc/wistron_btns.c	2007-05-18 00:36:44.000000000 +0200
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/mc146818rtc.h>
 #include <linux/module.h>
@@ -37,9 +38,10 @@
  */
 #define MAX_POLL_ITERATIONS 64
 
-#define POLL_FREQUENCY 10 /* Number of polls per second */
+#define POLL_FREQUENCY 2 /* Number of polls per second when idle */
+#define POLL_FREQUENCY_BURST 10 /* Polls per second when a key was recently pressed */
 
-#if POLL_FREQUENCY > HZ
+#if POLL_FREQUENCY_BURST > HZ
 #error "POLL_FREQUENCY too high"
 #endif
 
@@ -1079,6 +1081,8 @@ static void handle_key(u8 code)
 
 static void poll_bios(unsigned long discard)
 {
+	static unsigned long jiffies_last_press;
+	unsigned long jiffies_now = jiffies;
 	u8 qlen;
 	u16 val;
 
@@ -1087,11 +1091,17 @@ static void poll_bios(unsigned long disc
 		if (qlen == 0)
 			break;
 		val = bios_pop_queue();
-		if (val != 0 && !discard)
+		if (val != 0 && !discard) {
 			handle_key((u8)val);
+			jiffies_last_press = jiffies_now;
+		}
 	}
 
-	mod_timer(&poll_timer, jiffies + HZ / POLL_FREQUENCY);
+	/* Increase precision if user is currently pressing keys (< 2s ago) */
+	if (time_after(jiffies_last_press, jiffies_now - (HZ * 2)))
+		mod_timer(&poll_timer, jiffies_now + HZ / POLL_FREQUENCY_BURST);
+	else
+		mod_timer(&poll_timer, jiffies_now + HZ / POLL_FREQUENCY);
 }
 
 static int __devinit wistron_probe(struct platform_device *dev)

--------------090503030907020108090405--

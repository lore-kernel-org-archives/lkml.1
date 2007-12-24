Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbXLXOvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbXLXOvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbXLXOvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:51:41 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:46905 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbXLXOvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:51:40 -0500
Date: Mon, 24 Dec 2007 15:51:28 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: perex@suse.cz, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 38/38] sound: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241551060.23999@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -r -u -p a/sound/drivers/serial-u16550.c b/sound/drivers/serial-u16550.c
--- a/sound/drivers/serial-u16550.c	2007-10-22 11:25:52.000000000 +0200
+++ b/sound/drivers/serial-u16550.c	2007-12-23 20:30:40.000000000 +0100
@@ -43,6 +43,7 @@
 #include <sound/initval.h>
 
 #include <linux/serial_reg.h>
+#include <linux/jiffies.h>
 
 #include <asm/io.h>
 
@@ -694,7 +695,7 @@ static void snd_uart16550_output_write(s
 			    (uart->adaptor == SNDRV_SERIAL_SOUNDCANVAS ||
 			     uart->adaptor == SNDRV_SERIAL_GENERIC) &&
 			    (uart->prev_out != substream->number ||
-			     jiffies-lasttime > 3*HZ)) {
+			     time_after(jiffies, lasttime + 3*HZ))) {
 
 				if (snd_uart16550_buffer_can_write(uart, 3)) {
 					/* Roland Soundcanvas part selection */
diff -r -u -p a/sound/oss/pss.c b/sound/oss/pss.c
--- a/sound/oss/pss.c	2006-11-30 19:05:48.000000000 +0100
+++ b/sound/oss/pss.c	2007-12-23 20:30:40.000000000 +0100
@@ -60,6 +60,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/jiffies.h>
 
 #include "sound_config.h"
 #include "sound_firmware.h"
@@ -271,7 +272,7 @@ static int pss_reset_dsp(pss_confdata * 
 	unsigned long   i, limit = jiffies + HZ/10;
 
 	outw(0x2000, REG(PSS_CONTROL));
-	for (i = 0; i < 32768 && (limit-jiffies >= 0); i++)
+	for (i = 0; i < 32768 && (time_after_eq(jiffies, limit)); i++)
 		inw(REG(PSS_CONTROL));
 	outw(0x0000, REG(PSS_CONTROL));
 	return 1;
@@ -371,11 +372,11 @@ static int pss_download_boot(pss_confdat
 		outw(0, REG(PSS_DATA));
 
 		limit = jiffies + HZ/10;
-		for (i = 0; i < 32768 && (limit - jiffies >= 0); i++)
+		for (i = 0; i < 32768 && (time_after_eq(jiffies, limit)); i++)
 			val = inw(REG(PSS_STATUS));
 
 		limit = jiffies + HZ/10;
-		for (i = 0; i < 32768 && (limit-jiffies >= 0); i++)
+		for (i = 0; i < 32768 && (time_after_eq(jiffies, limit)); i++)
 		{
 			val = inw(REG(PSS_STATUS));
 			if (val & 0x4000)
diff -r -u -p a/sound/oss/sb_common.c b/sound/oss/sb_common.c
--- a/sound/oss/sb_common.c	2007-02-09 17:34:30.000000000 +0100
+++ b/sound/oss/sb_common.c	2007-12-23 20:30:40.000000000 +0100
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
+#include <linux/jiffies.h>
 
 #include "sound_config.h"
 #include "sound_firmware.h"
@@ -97,7 +98,7 @@ int sb_dsp_command(sb_devc * devc, unsig
 	 * loops.
 	 */
 
-	for (i = 0; i < 500000 && (limit-jiffies)>0; i++)
+	for (i = 0; i < 500000 && time_before(jiffies, limit); i++)
 	{
 		if ((inb(DSP_STATUS) & 0x80) == 0)
 		{
diff -r -u -p a/sound/soc/s3c24xx/s3c24xx-i2s.c b/sound/soc/s3c24xx/s3c24xx-i2s.c
--- a/sound/soc/s3c24xx/s3c24xx-i2s.c	2007-10-22 11:25:53.000000000 +0200
+++ b/sound/soc/s3c24xx/s3c24xx-i2s.c	2007-12-23 20:30:40.000000000 +0100
@@ -24,6 +24,7 @@
 #include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/clk.h>
+#include <linux/jiffies.h>
 #include <sound/driver.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -184,7 +185,7 @@ static int s3c24xx_snd_lrsync(void)
 		if (iiscon & S3C2410_IISCON_LRINDEX)
 			break;
 
-		if (timeout < jiffies)
+		if (time_after(jiffies, timeout))
 			return -ETIMEDOUT;
 	}
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbXLZPXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbXLZPXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 10:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXLZPWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 10:22:43 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:33858 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbXLZPWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 10:22:40 -0500
Date: Wed, 26 Dec 2007 16:22:23 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: perex@perex.cz, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] sound/oss: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.58.0712261621390.1185@pc-041.diku.dk>
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

diff -u -p linux-2.6/sound/oss/pss.c linuxcopy/sound/oss/pss.c
--- linux-2.6/sound/oss/pss.c	2006-11-30 19:05:48.000000000 +0100
+++ linuxcopy/sound/oss/pss.c	2007-12-26 15:59:55.000000000 +0100
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
+	for (i = 0; i < 32768 && (time_before_eq(jiffies, limit)); i++)
 		inw(REG(PSS_CONTROL));
 	outw(0x0000, REG(PSS_CONTROL));
 	return 1;
@@ -371,11 +372,11 @@ static int pss_download_boot(pss_confdat
 		outw(0, REG(PSS_DATA));

 		limit = jiffies + HZ/10;
-		for (i = 0; i < 32768 && (limit - jiffies >= 0); i++)
+		for (i = 0; i < 32768 && (time_before_eq(jiffies, limit)); i++)
 			val = inw(REG(PSS_STATUS));

 		limit = jiffies + HZ/10;
-		for (i = 0; i < 32768 && (limit-jiffies >= 0); i++)
+		for (i = 0; i < 32768 && (time_before_eq(jiffies, limit)); i++)
 		{
 			val = inw(REG(PSS_STATUS));
 			if (val & 0x4000)
diff -u -p linux-2.6/sound/oss/sb_common.c linuxcopy/sound/oss/sb_common.c
--- linux-2.6/sound/oss/sb_common.c	2007-02-09 17:34:30.000000000 +0100
+++ linuxcopy/sound/oss/sb_common.c	2007-12-26 15:59:55.000000000 +0100
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

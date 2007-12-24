Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbXLXO2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbXLXO2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbXLXO1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:27:54 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:57914 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632AbXLXO1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:27:53 -0500
Date: Mon, 24 Dec 2007 15:27:32 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 14/38] drivers/char/rtc.c: Use time_before, time_before_eq,
 etc.
Message-ID: <Pine.LNX.4.64.0712241527070.23999@ask.diku.dk>
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

diff -r -u -p a/drivers/char/rtc.c b/drivers/char/rtc.c
--- a/drivers/char/rtc.c	2007-11-15 15:09:36.000000000 +0100
+++ b/drivers/char/rtc.c	2007-12-23 20:35:15.000000000 +0100
@@ -88,6 +88,7 @@
 
 #ifdef CONFIG_SPARC32
 #include <linux/pci.h>
+#include <linux/jiffies.h>
 #include <asm/ebus.h>
 
 static unsigned long rtc_port;
@@ -1282,7 +1283,8 @@ void rtc_get_rtc_time(struct rtc_time *r
 	 * Once the read clears, read the RTC time (again via ioctl). Easy.
 	 */
 
-	while (rtc_is_updating() != 0 && jiffies - uip_watchdog < 2*HZ/100)
+	while (rtc_is_updating() != 0 &&
+	       time_before(jiffies, uip_watchdog + 2*HZ/100))
 		cpu_relax();
 
 	/*

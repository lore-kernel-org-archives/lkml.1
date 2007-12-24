Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbXLXO0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbXLXO0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbXLXO0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:26:39 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:57762 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbXLXO0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:26:38 -0500
Date: Mon, 24 Dec 2007 15:26:18 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 12/38] drivers/char/ds1286.c: Use time_before, time_before_eq,
 etc.
Message-ID: <Pine.LNX.4.64.0712241525520.23999@ask.diku.dk>
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

diff -r -u -p a/drivers/char/ds1286.c b/drivers/char/ds1286.c
--- a/drivers/char/ds1286.c	2007-06-02 22:32:10.000000000 +0200
+++ b/drivers/char/ds1286.c	2007-12-23 20:30:39.000000000 +0100
@@ -39,6 +39,7 @@
 #include <linux/spinlock.h>
 #include <linux/bcd.h>
 #include <linux/proc_fs.h>
+#include <linux/jiffies.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -451,7 +452,7 @@ static void ds1286_get_time(struct rtc_t
 	 */
 
 	if (ds1286_is_updating() != 0)
-		while (jiffies - uip_watchdog < 2*HZ/100)
+		while (time_before(jiffies, uip_watchdog + 2*HZ/100))
 			barrier();
 
 	/*

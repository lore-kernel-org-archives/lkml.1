Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbXLXO1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbXLXO1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbXLXO1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:27:46 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:39287 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbXLXO1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:27:45 -0500
Date: Mon, 24 Dec 2007 15:27:01 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitry.torokhov@gmail.com, vojtech@suse.cz, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 13/38] drivers/char/keyboard.c: Use time_before, time_before_eq,
 etc.
Message-ID: <Pine.LNX.4.64.0712241526190.23999@ask.diku.dk>
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

diff -r -u -p a/drivers/char/keyboard.c b/drivers/char/keyboard.c
--- a/drivers/char/keyboard.c	2007-10-22 11:25:05.000000000 +0200
+++ b/drivers/char/keyboard.c	2007-12-23 20:35:00.000000000 +0100
@@ -43,6 +43,7 @@
 #include <linux/input.h>
 #include <linux/reboot.h>
 #include <linux/notifier.h>
+#include <linux/jiffies.h>
 
 extern void ctrl_alt_del(void);
 
@@ -929,7 +930,8 @@ static void k_brl(struct vc_data *vc, un
 	if (up_flag) {
 		if (brl_timeout) {
 			if (!committing ||
-			    jiffies - releasestart > (brl_timeout * HZ) / 1000) {
+			    time_after(jiffies,
+				       releasestart + (brl_timeout*HZ)/1000)) {
 				committing = pressed;
 				releasestart = jiffies;
 			}

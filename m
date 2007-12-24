Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbXLXOoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbXLXOoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbXLXOoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:44:07 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:36871 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbXLXOoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:44:06 -0500
Date: Mon, 24 Dec 2007 15:43:59 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 27/38] kernel: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241543320.23999@ask.diku.dk>
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

diff -r -u -p a/kernel/irq/spurious.c b/kernel/irq/spurious.c
--- a/kernel/irq/spurious.c	2007-07-20 17:46:05.000000000 +0200
+++ b/kernel/irq/spurious.c	2007-12-23 20:30:40.000000000 +0100
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
+#include <linux/jiffies.h>
 
 static int irqfixup __read_mostly;
 
@@ -178,7 +179,7 @@ void note_interrupt(unsigned int irq, st
 		 * otherwise the couter becomes a doomsday timer for otherwise
 		 * working systems
 		 */
-		if (jiffies - desc->last_unhandled > HZ/10)
+		if (time_after(jiffies, desc->last_unhandled + HZ/10))
 			desc->irqs_unhandled = 1;
 		else
 			desc->irqs_unhandled++;
diff -r -u -p a/kernel/timer.c b/kernel/timer.c
--- a/kernel/timer.c	2007-12-21 06:57:20.000000000 +0100
+++ b/kernel/timer.c	2007-12-23 20:30:40.000000000 +0100
@@ -165,7 +165,7 @@ unsigned long __round_jiffies(unsigned l
 	/* now that we have rounded, subtract the extra skew again */
 	j -= cpu * 3;
 
-	if (j <= jiffies) /* rounding ate our timeout entirely; */
+	if (time_before_eq(jiffies, j))/* rounding ate our timeout entirely; */
 		return original;
 	return j;
 }

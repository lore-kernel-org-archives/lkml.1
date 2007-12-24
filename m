Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbXLXOSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbXLXOSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbXLXOSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:18:01 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:58254 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbXLXOSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:18:00 -0500
Date: Mon, 24 Dec 2007 15:17:56 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: tony.luck@intel.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/38] arch/ia64: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241517020.23999@ask.diku.dk>
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

diff -r -u -p a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
--- a/arch/ia64/kernel/irq_ia64.c	2007-12-21 06:57:18.000000000 +0100
+++ b/arch/ia64/kernel/irq_ia64.c	2007-12-23 20:30:39.000000000 +0100
@@ -405,7 +405,7 @@ ia64_handle_irq (ia64_vector vector, str
 			static unsigned char count;
 			static long last_time;
 
-			if (jiffies - last_time > 5*HZ)
+			if (time_after(jiffies, last_time + 5*HZ))
 				count = 0;
 			if (++count < 5) {
 				last_time = jiffies;
diff -r -u -p a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
--- a/arch/ia64/kernel/mca.c	2007-12-21 06:57:18.000000000 +0100
+++ b/arch/ia64/kernel/mca.c	2007-12-23 20:31:54.000000000 +0100
@@ -76,6 +76,7 @@
 #include <linux/cpumask.h>
 #include <linux/kdebug.h>
 #include <linux/cpu.h>
+#include <linux/jiffies.h>
 
 #include <asm/delay.h>
 #include <asm/machvec.h>
@@ -285,7 +286,8 @@ static void ia64_mlogbuf_dump_from_init(
 	if (mlogbuf_finished)
 		return;
 
-	if (mlogbuf_timestamp && (mlogbuf_timestamp + 30*HZ > jiffies)) {
+	if (mlogbuf_timestamp &&
+	    (time_before(jiffies, mlogbuf_timestamp + 30*HZ))) {
 		printk(KERN_ERR "INIT: mlogbuf_dump is interrupted by INIT "
 			" and the system seems to be messed up.\n");
 		ia64_mlogbuf_finish(0);
diff -r -u -p a/arch/ia64/kernel/unaligned.c b/arch/ia64/kernel/unaligned.c
--- a/arch/ia64/kernel/unaligned.c	2007-10-22 11:24:57.000000000 +0200
+++ b/arch/ia64/kernel/unaligned.c	2007-12-23 20:30:39.000000000 +0100
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
+#include <linux/jiffies.h>
 
 #include <asm/intrinsics.h>
 #include <asm/processor.h>
@@ -1289,7 +1290,7 @@ within_logging_rate_limit (void)
 {
 	static unsigned long count, last_time;
 
-	if (jiffies - last_time > 5*HZ)
+	if (time_after(jiffies, last_time + 5*HZ))
 		count = 0;
 	if (count < 5) {
 		last_time = jiffies;

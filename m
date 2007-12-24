Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbXLXOTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbXLXOTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbXLXOTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:19:08 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:58072 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbXLXOTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:19:07 -0500
Date: Mon, 24 Dec 2007 15:18:56 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jes@sgi.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/38] arch/ia64/sn: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241518040.23999@ask.diku.dk>
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

diff -r -u -p a/arch/ia64/sn/kernel/xpc_main.c b/arch/ia64/sn/kernel/xpc_main.c
--- a/arch/ia64/sn/kernel/xpc_main.c	2007-11-12 10:35:56.000000000 +0100
+++ b/arch/ia64/sn/kernel/xpc_main.c	2007-12-23 20:32:54.000000000 +0100
@@ -56,6 +56,7 @@
 #include <linux/reboot.h>
 #include <linux/completion.h>
 #include <linux/kdebug.h>
+#include <linux/jiffies.h>
 #include <asm/sn/intr.h>
 #include <asm/sn/sn_sal.h>
 #include <asm/uaccess.h>
@@ -199,7 +200,7 @@ xpc_timeout_partition_disengage_request(
 	struct xpc_partition *part = (struct xpc_partition *) data;
 
 
-	DBUG_ON(jiffies < part->disengage_request_timeout);
+	DBUG_ON(time_before(jiffies, part->disengage_request_timeout));
 
 	(void) xpc_partition_disengaged(part);
 
@@ -230,7 +231,7 @@ xpc_hb_beater(unsigned long dummy)
 {
 	xpc_vars->heartbeat++;
 
-	if (jiffies >= xpc_hb_check_timeout) {
+	if (time_before_eq(jiffies, xpc_hb_check_timeout)) {
 		wake_up_interruptible(&xpc_act_IRQ_wq);
 	}
 
@@ -270,7 +271,7 @@ xpc_hb_checker(void *ignore)
 
 
 		/* checking of remote heartbeats is skewed by IRQ handling */
-		if (jiffies >= xpc_hb_check_timeout) {
+		if (time_before_eq(jiffies, xpc_hb_check_timeout)) {
 			dev_dbg(xpc_part, "checking remote heartbeats\n");
 			xpc_check_remote_hb();
 
@@ -305,7 +306,7 @@ xpc_hb_checker(void *ignore)
 		/* wait for IRQ or timeout */
 		(void) wait_event_interruptible(xpc_act_IRQ_wq,
 			    (last_IRQ_count < atomic_read(&xpc_act_IRQ_rcvd) ||
-					jiffies >= xpc_hb_check_timeout ||
+			     time_before_eq(jiffies, xpc_hb_check_timeout) ||
 						(volatile int) xpc_exiting));
 	}
 
diff -r -u -p a/arch/ia64/sn/kernel/xpc_partition.c b/arch/ia64/sn/kernel/xpc_partition.c
--- a/arch/ia64/sn/kernel/xpc_partition.c	2007-06-02 22:32:05.000000000 +0200
+++ b/arch/ia64/sn/kernel/xpc_partition.c	2007-12-23 20:33:17.000000000 +0100
@@ -22,6 +22,7 @@
 #include <linux/cache.h>
 #include <linux/mmzone.h>
 #include <linux/nodemask.h>
+#include <linux/jiffies.h>
 #include <asm/uncached.h>
 #include <asm/sn/bte.h>
 #include <asm/sn/intr.h>
@@ -877,7 +878,8 @@ xpc_partition_disengaged(struct xpc_part
 	disengaged = (xpc_partition_engaged(1UL << partid) == 0);
 	if (part->disengage_request_timeout) {
 		if (!disengaged) {
-			if (jiffies < part->disengage_request_timeout) {
+			if (time_before(jiffies,
+					part->disengage_request_timeout)) {
 				/* timelimit hasn't been reached yet */
 				return 0;
 			}
diff -r -u -p a/arch/mips/cobalt/reset.c b/arch/mips/cobalt/reset.c
--- a/arch/mips/cobalt/reset.c	2007-10-22 11:24:58.000000000 +0200
+++ b/arch/mips/cobalt/reset.c	2007-12-23 20:30:39.000000000 +0100
@@ -49,7 +49,7 @@ void cobalt_machine_halt(void)
 		if((diff & (COBALT_KEY_ENTER | COBALT_KEY_SELECT)) && !(~last & (COBALT_KEY_ENTER | COBALT_KEY_SELECT)))
 			writeb(RESET, RESET_PORT);
 
-		for (mark = jiffies; jiffies - mark < HZ;)
+		for (mark = jiffies; time_before(jiffies, mark + HZ);)
 			;
 	}
 }

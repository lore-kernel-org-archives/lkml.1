Return-Path: <linux-kernel-owner+w=401wt.eu-S1764022AbXGYMJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764022AbXGYMJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763249AbXGYMIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:08:39 -0400
Received: from rex.snapgear.com ([203.143.235.140]:33039 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763001AbXGYMIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:08:36 -0400
Date: Wed, 25 Jul 2007 22:07:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251207.l6PC7K8I032188@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: fix workqueues in 68328 serial driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix workqueues in 68328 serial driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/drivers/serial/68328serial.c linux-2.6.22-uc0/drivers/serial/68328serial.c
--- linux-2.6.22/drivers/serial/68328serial.c	2007-07-12 15:22:34.000000000 +1000
+++ linux-2.6.22-uc0/drivers/serial/68328serial.c	2007-07-12 15:25:25.000000000 +1000
@@ -401,9 +400,9 @@
 	return IRQ_HANDLED;
 }
 
-static void do_softint(void *private)
+static void do_softint(struct work_struct *work)
 {
-	struct m68k_serial	*info = (struct m68k_serial *) private;
+	struct m68k_serial	*info = container_of(work, struct m68k_serial, tqueue);
 	struct tty_struct	*tty;
 	
 	tty = info->tty;
@@ -425,9 +424,9 @@
  * 	do_serial_hangup() -> tty->hangup() -> rs_hangup()
  * 
  */
-static void do_serial_hangup(void *private)
+static void do_serial_hangup(struct work_struct *work)
 {
-	struct m68k_serial	*info = (struct m68k_serial *) private;
+	struct m68k_serial	*info = container_of(work, struct m68k_serial, tqueue_hangup);
 	struct tty_struct	*tty;
 	
 	tty = info->tty;
@@ -1444,8 +1390,8 @@
 	    info->event = 0;
 	    info->count = 0;
 	    info->blocked_open = 0;
-	    INIT_WORK(&info->tqueue, do_softint, info);
-	    INIT_WORK(&info->tqueue_hangup, do_serial_hangup, info);
+	    INIT_WORK(&info->tqueue, do_softint);
+	    INIT_WORK(&info->tqueue_hangup, do_serial_hangup);
 	    init_waitqueue_head(&info->open_wait);
 	    init_waitqueue_head(&info->close_wait);
 	    info->line = i;

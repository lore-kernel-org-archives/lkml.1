Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbZDMOgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbZDMOgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZDMOg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:36:28 -0400
Received: from relay.pcl-ipout01.plus.net ([212.159.7.99]:11704 "EHLO
	relay.pcl-ipout01.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802AbZDMOg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:36:28 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Apr 2009 10:36:27 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAM/o4knUnw4T/2dsb2JhbADMA4N8Bg
Date: Mon, 13 Apr 2009 15:26:33 +0100
From: Peter Horton <zero@colonel-panic.org>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: [PATCH] mtd: fix timeout in M25P80 driver
Message-ID: <20090413142633.GA1560@sloth.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Plusnet-Relay: a36a28986e2acedb5f7a1be57e7713a8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend erase timeout in M25P80 SPI Flash driver.

The M25P80 drivers fails erasing sectors on a M25P128 because the ready
wait timeout is too short. Change the timeout from a simple loop count to a
suitable number of seconds.

Signed-off-by: Peter Horton <zero@colonel-panic.org>
---
Index: linux-2.6.29-git12/drivers/mtd/devices/m25p80.c
===================================================================
--- linux-2.6.29-git12.orig/drivers/mtd/devices/m25p80.c	2009-04-12 21:41:16.000000000 +0000
+++ linux-2.6.29-git12/drivers/mtd/devices/m25p80.c	2009-04-12 21:43:01.000000000 +0000
@@ -54,7 +54,7 @@
 #define	SR_SRWD			0x80	/* SR write protect */
 
 /* Define max times to check status register before we give up. */
-#define	MAX_READY_WAIT_COUNT	100000
+#define	MAX_READY_WAIT_JIFFIES	(10 * HZ)	/* eg. M25P128 specs 6s max sector erase */
 #define	CMD_SIZE		4
 
 #ifdef CONFIG_M25PXX_USE_FAST_READ
@@ -145,20 +145,20 @@
  */
 static int wait_till_ready(struct m25p *flash)
 {
-	int count;
+	unsigned long deadline;
 	int sr;
 
-	/* one chip guarantees max 5 msec wait here after page writes,
-	 * but potentially three seconds (!) after page erase.
-	 */
-	for (count = 0; count < MAX_READY_WAIT_COUNT; count++) {
+	deadline = jiffies + MAX_READY_WAIT_JIFFIES;
+
+	do {
 		if ((sr = read_sr(flash)) < 0)
 			break;
 		else if (!(sr & SR_WIP))
 			return 0;
 
-		/* REVISIT sometimes sleeping would be best */
-	}
+		cond_resched();
+
+	} while (!time_after_eq(jiffies, deadline));
 
 	return 1;
 }

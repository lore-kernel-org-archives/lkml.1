Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbZDPFz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbZDPFz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbZDPFzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:55:05 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:64304
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756112AbZDPFzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:55:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgBAJxk5kl8qNY8/2dsb2JhbAAI0BuDfQY
X-IronPort-AV: E=Sophos;i="4.40,197,1238947200"; 
   d="scan'208";a="467881579"
Subject: [PATCH 3/9] omap-keypad: Use disable_irq_nosync() from within irq
	handlers.
From: Ben Nizette <bn@niasdigital.com>
To: dmitry.torokhov@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain
Date: Thu, 16 Apr 2009 15:54:34 +1000
Message-Id: <1239861274.29831.118.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


disable_irq() should wait for all running handlers to complete
before returning.  As such, if it's used to disable an interrupt
from that interrupt's handler it will deadlock.  This replaces
the dangerous instances with the _nosync() variant which doesn't
have this problem.

This patch may be overly paranoid, it'd be cleaner to just
disable all the row irqs _nosync() but it wouldn't be as
correct.  Up to $MAINTAINER :-)

Signed-off-by: Ben Nizette <bn@niasdigital.com>
---
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index 058fa8b..9606a1c 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -100,8 +100,16 @@ static irqreturn_t omap_kp_interrupt(int irq, void *dev_id)
 	/* disable keyboard interrupt and schedule for handling */
 	if (cpu_is_omap24xx()) {
 		int i;
-		for (i = 0; i < omap_kp->rows; i++)
-			disable_irq(gpio_to_irq(row_gpios[i]));
+		for (i = 0; i < omap_kp->rows; i++) {
+			/* The interrupt which we're currently handling should
+			 * be disabled _nosync() to avoid deadlocks waiting
+			 * for this handler to complete.  All others should
+			 * be disabled the regular way for SMP safety. */
+			if (gpio_to_irq(row_gpios[i]) == irq)
+				disable_irq_nosync(gpio_to_irq(row_gpios[i]));
+			else
+				disable_irq(gpio_to_irq(row_gpios[i]));
+		}
 	} else
 		/* disable keyboard interrupt and schedule for handling */
 		omap_writew(1, OMAP_MPUIO_BASE + OMAP_MPUIO_KBD_MASKIT);
-- 
1.6.0.2




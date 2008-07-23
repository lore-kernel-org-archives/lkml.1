Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYGWMmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYGWMmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYGWMmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:42:38 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:45882 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYGWMmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:42:37 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-4.tower-164.messagelabs.com!1216816949!10648424!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: David Brownell <dbrownell@users.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk@arm.linux.org.uk>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH] set_irq_wake: fix return code and wake status tracking
Date: Wed, 23 Jul 2008 14:42:25 +0200
Message-ID: <1216816945-20223-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.6.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Jul 2008 12:42:26.0505 (UTC) FILETIME=[8FC67390:01C8ECC1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 15a647eba94c3da27ccc666bea72e7cca06b2d19 set_irq_wake returned -ENXIO
if another device had it already enabled.  Zero is the right value to
return in this case.  Moreover the change to desc->status was not reverted
if desc->chip->set_wake returned an error.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@osdl.org>
---
 kernel/irq/manage.c |   39 +++++++++++++++++++++++++++------------
 1 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e01ad8e..227cd49 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -194,6 +194,17 @@ void enable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(enable_irq);
 
+int set_irq_wake_real(unsigned int irq, unsigned int on)
+{
+	struct irq_desc *desc = irq_desc + irq;
+	int ret = -ENXIO;
+
+	if (desc->chip->set_wake)
+		ret = desc->chip->set_wake(irq, on);
+
+	return ret;
+}
+
 /**
  *	set_irq_wake - control irq power management wakeup
  *	@irq:	interrupt to control
@@ -210,30 +221,34 @@ int set_irq_wake(unsigned int irq, unsigned int on)
 {
 	struct irq_desc *desc = irq_desc + irq;
 	unsigned long flags;
-	int ret = -ENXIO;
-	int (*set_wake)(unsigned, unsigned) = desc->chip->set_wake;
+	int ret = 0;
 
 	/* wakeup-capable irqs can be shared between drivers that
 	 * don't need to have the same sleep mode behaviors.
 	 */
 	spin_lock_irqsave(&desc->lock, flags);
 	if (on) {
-		if (desc->wake_depth++ == 0)
-			desc->status |= IRQ_WAKEUP;
-		else
-			set_wake = NULL;
+		if (desc->wake_depth++ == 0) {
+			ret = set_irq_wake_real(irq, on);
+			if (ret)
+				desc->wake_depth = 0;
+			else
+				desc->status |= IRQ_WAKEUP;
+		}
 	} else {
 		if (desc->wake_depth == 0) {
 			printk(KERN_WARNING "Unbalanced IRQ %d "
 					"wake disable\n", irq);
 			WARN_ON(1);
-		} else if (--desc->wake_depth == 0)
-			desc->status &= ~IRQ_WAKEUP;
-		else
-			set_wake = NULL;
+		} else if (--desc->wake_depth == 0) {
+			ret = set_irq_wake_real(irq, on);
+			if (ret)
+				desc->wake_depth = 1;
+			else
+				desc->status &= ~IRQ_WAKEUP;
+		}
 	}
-	if (set_wake)
-		ret = desc->chip->set_wake(irq, on);
+
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
-- 
1.5.6.3


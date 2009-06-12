Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbZFLRKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbZFLRKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZFLRKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:10:04 -0400
Received: from www.tglx.de ([62.245.132.106]:42103 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbZFLRKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:10:03 -0400
Date: Fri, 12 Jun 2009 19:09:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Russell King <rmk+lkml@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] genirq: do not disable IRQ_WAKEUP marked irqs on suspend
Message-ID: <alpine.LFD.2.00.0906121906140.3369@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0a0c5168df (PM: Introduce functions for suspending and resuming
device interrupts) iterates through all interrupts and disables them
on the hardware level. Some architectures have functionality
implemented to mark an interrupt source as wakeup source for suspend,
but the new power management code disables them unconditionally which
breaks the resume on interrupt functionality.

The wakeup interrupts are marked in the status with the IRQ_WAKEUP
bit. Skip the disablement for those interrupts which have the
IRQ_WAKEUP bit set.
    
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org

diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 638d8be..bce6afd 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -29,7 +29,8 @@ void suspend_device_irqs(void)
 		unsigned long flags;
 
 		spin_lock_irqsave(&desc->lock, flags);
-		__disable_irq(desc, irq, true);
+		if (!(desc->status & IRQ_WAKEUP))
+			__disable_irq(desc, irq, true);
 		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 

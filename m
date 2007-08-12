Return-Path: <linux-kernel-owner+w=401wt.eu-S935693AbXHLPpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935693AbXHLPpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765944AbXHLPog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:44:36 -0400
Received: from www.osadl.org ([213.239.205.134]:50289 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760493AbXHLPod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:44:33 -0400
Message-Id: <20070812152303.083017058@inhelltoy.tec.linutronix.de>
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 15:46:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin.slusarz" <marcin.slusarz@gmail.com>,
       Jarek Poplawski <jarkao2@o2.pl>
Subject: [patch 1/3] genirq: cleanup mismerge artifact
Content-Disposition: inline; filename=genirq-do-not-resend-level-irqs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 5a43a066b11ac2fe84cf67307f20b83bea390f83
genirq: Allow fasteoi handler to retrigger disabled interrupts

was erroneously applied to handle_level_irq(). This adds the irq
retrigger / resend functionality to the level irq handler.

Revert the offending bits.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/irq/chip.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c	2007-08-12 17:18:04.000000000 +0200
+++ linux-2.6/kernel/irq/chip.c	2007-08-12 17:18:04.000000000 +0200
@@ -352,13 +352,10 @@ handle_level_irq(unsigned int irq, struc
 	 * keep it masked and get out of here
 	 */
 	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
-		desc->status |= IRQ_PENDING;
+	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
 		goto out_unlock;
-	}
 
 	desc->status |= IRQ_INPROGRESS;
-	desc->status &= ~IRQ_PENDING;
 	spin_unlock(&desc->lock);
 
 	action_ret = handle_IRQ_event(irq, action);

-- 


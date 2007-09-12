Return-Path: <linux-kernel-owner+w=401wt.eu-S967153AbXILLSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967153AbXILLSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965842AbXILLSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:18:10 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:40238 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965366AbXILLSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:18:09 -0400
Date: Wed, 12 Sep 2007 12:17:58 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] free_irq(): Actually handle DEBUG_SHIRQ
Message-ID: <Pine.LNX.4.64N.0709121122120.24030@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Code used for DEBUG_SHIRQ in free_irq() is unreachable -- the for() loop 
within never terminates otherwise than by return.  This is an obvious fix.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Please apply.

 While at it, I have a question about the complementary code within 
request_irq(): when the option in question is enabled, a spurious IRQ is 
posted before internal setup is done by setup_irq().  This includes the 
->depth counter.  Now if the interrupt handler of some driver calls
disable_irq_nosync(), then code in setup_irq() will mess up the state of 
->depth afterwards if this is the first handler being installed (i.e. 
within the "if (!shared)" block).  This is reported later on when 
enable_irq() called by the driver, by means of a message like this:

Unbalanced enable for IRQ 34
WARNING: at kernel/irq/manage.c:158 enable_irq()

Now given DEBUG_SHIRQ is a debug facility, not to be normally used for 
production, is the phenomenon as described considered a design limitation 
we can live with, or is it a bug that qualifies for a fix?

 I can reproduce this problem easily with phylib.

  Maciej

patch-mips-2.6.23-rc5-20070904-debug-shirq-0
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/kernel/irq/manage.c linux-mips-2.6.23-rc5-20070904/kernel/irq/manage.c
--- linux-mips-2.6.23-rc5-20070904.macro/kernel/irq/manage.c	2007-09-04 04:56:21.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/kernel/irq/manage.c	2007-09-11 23:58:59.000000000 +0000
@@ -448,7 +448,7 @@ void free_irq(unsigned int irq, void *de
 			if (action->flags & IRQF_SHARED)
 				handler = action->handler;
 			kfree(action);
-			return;
+			break;
 		}
 		printk(KERN_ERR "Trying to free already-free IRQ %d\n", irq);
 		spin_unlock_irqrestore(&desc->lock, flags);

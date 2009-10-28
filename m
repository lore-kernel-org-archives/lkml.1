Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbZJ1HGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbZJ1HGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbZJ1HGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:06:52 -0400
Received: from londo.lunn.ch ([80.238.139.98]:43542 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbZJ1HGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:06:51 -0400
X-Greylist: delayed 1690 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Oct 2009 03:06:51 EDT
Date: Wed, 28 Oct 2009 07:37:21 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [patch] uml: IRQ register race condition
Message-ID: <20091028063721.GA4513@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

There is a race condition in um_request_irq(). The SIGIO handling is
first enabled with the call to activate_fd(). The irq handler is then
registered with request_irq(). What can happen is that directly after
activate_fd() the SIGIO goes off and the IRQ source is disabled at the
low level, the pollfd is set to -1. Since no irq handler has yet been
registered, the interrupt it left disabled at the low level. The
interrupt handler is then registered, but its too late, the interrupt
source has been disabled at the lower level and is never re-enabled.
To fix this race condition i swapped the order. First request_irq()
then activate_fd() the interrupt sources.

There is a second bug. In 2.6.31 there was a change to the way
__do_IRQ() and friends work for chained interrupt sources. The old way
was that all chained interrupt handlers were called. The new way is
that the chain is walked only until a handler returns IRQ_HANDLED or
IRQ_WAKE_THREAD. uml_net_interrupt() would always return IRQ_HANDLED,
irrespective of if the device really did receive an interrupt or
not. This mean with the new code only the first device on a chained
interrupt ever got its interrupts handled. The second/third/... device
never got any interrupts processed. I changed uml_net_interrupt() to
always return IRQ_NONE so that all handlers get called on a chained
interrupt.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 9483c19..2b0748e 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -145,7 +145,7 @@ static irqreturn_t uml_net_interrupt(int irq, void *dev_id)
 
 out:
 	spin_unlock(&lp->lock);
-	return IRQ_HANDLED;
+	return IRQ_NONE;
 }
 
 static int uml_net_open(struct net_device *dev)
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 454cdb4..3a31d57 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -345,13 +345,12 @@ int um_request_irq(unsigned int irq, int fd, int type,
 {
 	int err;
 
-	if (fd != -1) {
+	err = request_irq(irq, handler, irqflags, devname, dev_id);
+
+	if (!err && (fd != -1))
 		err = activate_fd(irq, fd, type, dev_id);
-		if (err)
-			return err;
-	}
 
-	return request_irq(irq, handler, irqflags, devname, dev_id);
+	return err;
 }
 
 EXPORT_SYMBOL(um_request_irq);

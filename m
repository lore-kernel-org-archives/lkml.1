Return-Path: <linux-kernel-owner+w=401wt.eu-S934072AbYDQBaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072AbYDQBaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761072AbYDQBJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:09:59 -0400
Received: from sous-sol.org ([216.99.217.87]:59028 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760369AbYDQBJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:09:58 -0400
Message-Id: <20080417010357.154430586@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:16 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: plip: replace spin_lock_irq with spin_lock_irqsave in irq context
Content-Disposition: inline; filename=plip-replace-spin_lock_irq-with-spin_lock_irqsave-in-irq-context.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

upstream commit: cabce28ec0a0ae3d0ddfa4461f0e8be94ade9e46

Plip uses spin_lock_irq/spin_unlock_irq in its IRQ handler (called from
parport IRQ handler), the latter enables interrupts without parport
subsystem IRQ handler expecting it.

The bug can be seen if you compile kernel with lock dependency checking
and use plip --- it produces a warning.

This patch changes it to spin_lock_irqsave/spin_lock_irqrestore, so that
it doesn't enable interrupts when already disabled.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/plip.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/plip.c
+++ b/drivers/net/plip.c
@@ -903,17 +903,18 @@ plip_interrupt(void *dev_id)
 	struct net_local *nl;
 	struct plip_local *rcv;
 	unsigned char c0;
+	unsigned long flags;
 
 	nl = netdev_priv(dev);
 	rcv = &nl->rcv_data;
 
-	spin_lock_irq (&nl->lock);
+	spin_lock_irqsave (&nl->lock, flags);
 
 	c0 = read_status(dev);
 	if ((c0 & 0xf8) != 0xc0) {
 		if ((dev->irq != -1) && (net_debug > 1))
 			printk(KERN_DEBUG "%s: spurious interrupt\n", dev->name);
-		spin_unlock_irq (&nl->lock);
+		spin_unlock_irqrestore (&nl->lock, flags);
 		return;
 	}
 
@@ -942,7 +943,7 @@ plip_interrupt(void *dev_id)
 		break;
 	}
 
-	spin_unlock_irq(&nl->lock);
+	spin_unlock_irqrestore(&nl->lock, flags);
 }
 
 static int

-- 

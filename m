Return-Path: <linux-kernel-owner+w=401wt.eu-S1751874AbYLUUyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbYLUUyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 15:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYLUUy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 15:54:28 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:34283 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYLUUy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 15:54:27 -0500
Date: Sun, 21 Dec 2008 21:54:23 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: kernel@pengutronix.de, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] arch/arm/plat-mxc: Add local_irq_restore in error handling
 code
Message-ID: <Pine.LNX.4.64.0812212153570.3635@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

There is a call to local_irq_restore in the normal exit case, so it would
seem that there should be one on an error return as well.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
expression E,E1,E2;
@@

local_irq_save(l);
... when != local_irq_restore(l)
    when != spin_unlock_irqrestore(E,l)
    when any
    when strict
(
if (...) { ... when != local_irq_restore(l)
               when != spin_unlock_irqrestore(E1,l)
+   local_irq_restore(l);
    return ...;
}
|
if (...)
+   {local_irq_restore(l);
    return ...;
+   }
|
spin_unlock_irqrestore(E2,l);
|
local_irq_restore(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/plat-mxc/dma-mx1-mx2.c |    1 +
 1 file changed, 1 insertion(+)

diff -u -p a/arch/arm/plat-mxc/dma-mx1-mx2.c b/arch/arm/plat-mxc/dma-mx1-mx2.c
--- a/arch/arm/plat-mxc/dma-mx1-mx2.c
+++ b/arch/arm/plat-mxc/dma-mx1-mx2.c
@@ -698,6 +698,7 @@ int imx_dma_request(int channel, const c
 	if (ret) {
 		printk(KERN_CRIT "Can't register IRQ %d for DMA channel %d\n",
 				MXC_INT_DMACH0 + channel, channel);
+		local_irq_restore(flags);
 		return ret;
 	}
 	init_timer(&imxdma->watchdog);

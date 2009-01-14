Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbZANTmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbZANTmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZANTmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:42:05 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:64087 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753089AbZANTmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:42:04 -0500
Date: Wed, 14 Jan 2009 22:41:59 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org
Subject: [PATCH] sdhci: Fix potential spinlock recursion
Message-ID: <20090114194159.GA25017@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed this bug while working on a driver that is derived
from the SDHCI driver:

BUG: spinlock recursion on CPU#0, swapper/0
 lock: df890668, .magic: dead4ead, .owner: swapper/0, .owner_cpu: 0
Call Trace:
[c04b5c50] [c0008b2c] show_stack+0x4c/0x16c (unreliable)
[c04b5c90] [c0193aa8] spin_bug+0x7c/0xc4
[c04b5cb0] [c0193dcc] _raw_spin_lock+0xb4/0xb8
[c04b5cc0] [c035baf4] _spin_lock+0x10/0x20
[c04b5cd0] [c02a8d60] esdhc_irq+0x20/0x210
[c04b5cf0] [c00665c0] handle_IRQ_event+0x5c/0xb0
[c04b5d10] [c0068708] handle_level_irq+0xa8/0x144
[c04b5d30] [c000684c] do_IRQ+0xac/0xec
[c04b5d50] [c0014f24] ret_from_except+0x0/0x14
--- Exception: 501 at __delay+0x34/0x74
    LR = esdhc_reset+0xa4/0x114
[c04b5e10] [c0480000] empty_zero_page+0x0/0x1000 (unreliable)
[c04b5e30] [c02a9150] esdhc_tasklet_card+0x104/0x148
[c04b5e50] [c003cabc] tasklet_action+0x78/0xfc
[c04b5e60] [c003cbc4] __do_softirq+0x84/0x124
[c04b5e90] [c00065dc] do_softirq+0x58/0x5c
[c04b5ea0] [c003ca40] irq_exit+0x94/0x98
[c04b5eb0] [c0006850] do_IRQ+0xb0/0xec
[c04b5ed0] [c0014f24] ret_from_except+0x0/0x14
--- Exception: 501 at cpu_idle+0xa0/0xec
    LR = cpu_idle+0xa0/0xec
[c04b5f90] [c0009d14] cpu_idle+0x50/0xec (unreliable)
[c04b5fb0] [c035c000] __got2_end+0x58/0x68
[c04b5fc0] [c04468fc] start_kernel+0x1a4/0x228
[c04b5ff0] [00003438] 0x3438

This happens because plain spin_lock() won't protect us from
softirqs (tasklets). So in the sdhci interrupt handler we must
grab the _irq version of the lock.

Note that the _irqsave version isn't mandatory here because
a) we aren't trying to protect ourselves from another hardirq, and
b) the sdhci driver requests irqs with IRQF_SHARED flag, and that
   guarantees that we'll get a huge warning if anyone will try to
   request the same interrupt with IRQF_DISABLED flag, since
   IRQF_SHARED | IRQF_DISABLED is guaranteed to be broken anyway.

Briefly looking into other mmc hosts I don't see any problems
with them, so the fix goes for the sdhci driver only.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 4d010a9..5248041 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1363,7 +1363,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 	u32 intmask;
 	int cardint = 0;
 
-	spin_lock(&host->lock);
+	spin_lock_irq(&host->lock);
 
 	intmask = readl(host->ioaddr + SDHCI_INT_STATUS);
 
@@ -1424,7 +1424,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 
 	mmiowb();
 out:
-	spin_unlock(&host->lock);
+	spin_unlock_irq(&host->lock);
 
 	/*
 	 * We have to delay this as it calls back into the driver.
-- 
1.5.6.5

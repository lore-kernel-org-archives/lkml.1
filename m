Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYFWXku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYFWXku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbYFWXkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:40:40 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:32498 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751516AbYFWXkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:40:39 -0400
Date: Tue, 24 Jun 2008 03:40:37 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -rt] ide: fix interrupts processing issue with preempt-able
	hardirqs
Message-ID: <20080623234037.GA6793@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IDE interrupt handler relies on the fact that, if necessary, hardirqs
will re-trigger on ISR exit. With fully preemtable IRQs this seems to be
not true, since if hardirq thread is currently running, and the same IRQ
raised again, then this IRQ will be simply lost.

This patch fixes following issue:

ALI15X3: IDE controller (0x10b9:0x5229 rev 0xc8) at  PCI slot 0001:03:1f.0
ALI15X3: 100% native mode on irq 18
    ide0: BM-DMA at 0x1120-0x1127, BIOS settings: hda:PIO, hdb:PIO
    ide1: BM-DMA at 0x1128-0x112f, BIOS settings: hdc:PIO, hdd:PIO
hda: Optiarc DVD RW AD-7190A, ATAPI CD/DVD-ROM drive
hda: UDMA/66 mode selected
ide0 at 0x1100-0x1107,0x110a on irq 18
ide-cd: cmd 0x5a timed out
hda: lost interrupt
hda: ATAPI 12X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-cd: cmd 0x3 timed out
hda: lost interrupt
ide-cd: cmd 0x3 timed out
hda: lost interrupt
...

Though, some IDE devices (e.g. SONY DVD RW AW-Q170A) seem to work fine
without this patch, probably because they trigger IRQ after some delay.

This patch should be almost no-op for the !RT kernels, thus no #ifdefs.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/ide/ide-io.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 6c1b288..a52733e 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1460,6 +1460,7 @@ static void unexpected_intr (int irq, ide_hwgroup_t *hwgroup)
  
 irqreturn_t ide_intr (int irq, void *dev_id)
 {
+	int ret = IRQ_NONE;
 	unsigned long flags;
 	ide_hwgroup_t *hwgroup = (ide_hwgroup_t *)dev_id;
 	ide_hwif_t *hwif;
@@ -1467,12 +1468,13 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 	ide_handler_t *handler;
 	ide_startstop_t startstop;
 
+again:
 	spin_lock_irqsave(&ide_lock, flags);
 	hwif = hwgroup->hwif;
 
 	if (!ide_ack_intr(hwif)) {
 		spin_unlock_irqrestore(&ide_lock, flags);
-		return IRQ_NONE;
+		return ret;
 	}
 
 	if ((handler = hwgroup->handler) == NULL || hwgroup->polling) {
@@ -1510,7 +1512,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 #endif /* CONFIG_BLK_DEV_IDEPCI */
 		}
 		spin_unlock_irqrestore(&ide_lock, flags);
-		return IRQ_NONE;
+		return ret;
 	}
 	drive = hwgroup->drive;
 	if (!drive) {
@@ -1532,7 +1534,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 		 * enough advance overhead that the latter isn't a problem.
 		 */
 		spin_unlock_irqrestore(&ide_lock, flags);
-		return IRQ_NONE;
+		return ret;
 	}
 	if (!hwgroup->busy) {
 		hwgroup->busy = 1;	/* paranoia */
@@ -1578,7 +1580,16 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 		}
 	}
 	spin_unlock_irqrestore(&ide_lock, flags);
-	return IRQ_HANDLED;
+	ret = IRQ_HANDLED;
+
+	/*
+	 * Previous handler() may have set things up for another interrupt to
+	 * occur soon... in case we've lost it (e.g. with preemtable hardirqs),
+	 * try again and then return gracefully if no irqs were pending.
+	 */
+	if (startstop != ide_stopped)
+		goto again;
+	return ret;
 }
 
 /**
-- 
1.5.5.4

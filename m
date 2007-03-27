Return-Path: <linux-kernel-owner+w=401wt.eu-S934234AbXC0W3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234AbXC0W3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934230AbXC0W2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:28:45 -0400
Received: from 49.sub-75-208-212.myvzw.com ([75.208.212.49]:55528 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934227AbXC0W2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:28:42 -0400
Message-Id: <20070327215828.085422178@goop.org>
References: <20070327214919.800272641@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Mar 2007 14:49:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
       Prarit Bhargava <prarit@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Lalancette <clalance@redhat.com>, John Hawkes <hawkes@sgi.com>
Subject: [patch 3/4] Locally disable the softlockup watchdog rather than touching it
Content-Disposition: inline; filename=softlockup-disable-rather-than-touch.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we're about to enter a prolonged period in which we know we're
going to hold off scheduler ticks, then disable the CPU's softlockup
watchdog for the duration.  This avoids having to repeatedly touch the
timestamp, or conversely, risk having the watchdog timeout in the
middle of your long operation.

A question about each of these changes is whether they expect just the
current CPU to be locked up, or the whole machine.
touch_softlockup_watchdog updates the per-cpu timestamp, so I assumed
that its per-cpu for all these cases.

One semantic change this makes is that softlockup_disable/enable does
a preempt_disable/enable.  I don't think this is a problem, since if
you're worried about triggering the softlockup watchdog, you're not
scheduling.

I haven't really worked out how this should interact with the nmi
watchdog; touch_nmi_watchdog() still ends up calling
touch_softlockup_watchdog(), so there's still some redundancy here.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Chris Lalancette <clalance@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: John Hawkes <hawkes@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

---
 arch/ia64/kernel/uncached.c  |    8 ++++++--
 drivers/ide/ide-iops.c       |   25 +++++++++++++++++++------
 drivers/ide/ide-taskfile.c   |    8 +++++++-
 drivers/mtd/nand/nand_base.c |    8 +++++++-
 4 files changed, 39 insertions(+), 10 deletions(-)

===================================================================
--- a/arch/ia64/kernel/uncached.c
+++ b/arch/ia64/kernel/uncached.c
@@ -253,13 +253,17 @@ static int __init uncached_build_memmap(
 	int nid = paddr_to_nid(uc_start - __IA64_UNCACHED_OFFSET);
 	struct gen_pool *pool = uncached_pools[nid].pool;
 	size_t size = uc_end - uc_start;
-
-	touch_softlockup_watchdog();
+	int sl_state;
+
+	sl_state = softlockup_disable();
 
 	if (pool != NULL) {
 		memset((char *)uc_start, 0, size);
 		(void) gen_pool_add(pool, uc_start, size, nid);
 	}
+
+	softlockup_enable(sl_state);
+
 	return 0;
 }
 
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1215,6 +1215,12 @@ int ide_wait_not_busy(ide_hwif_t *hwif, 
 int ide_wait_not_busy(ide_hwif_t *hwif, unsigned long timeout)
 {
 	u8 stat = 0;
+	int ret = -EBUSY;
+	int sl_state;
+
+	/* Tell softlockup this might take a while.
+	   XXX should this be global or per-cpu? */
+	sl_state = softlockup_disable();
 
 	while(timeout--) {
 		/*
@@ -1223,19 +1229,26 @@ int ide_wait_not_busy(ide_hwif_t *hwif, 
 		 */
 		mdelay(1);
 		stat = hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
-		if ((stat & BUSY_STAT) == 0)
-			return 0;
+		if ((stat & BUSY_STAT) == 0) {
+			ret = 0;
+			break;
+		}
+
 		/*
 		 * Assume a value of 0xff means nothing is connected to
 		 * the interface and it doesn't implement the pull-down
 		 * resistor on D7.
 		 */
-		if (stat == 0xff)
-			return -ENODEV;
-		touch_softlockup_watchdog();
+		if (stat == 0xff) {
+			ret = -ENODEV;
+			break;
+		}
 		touch_nmi_watchdog();
 	}
-	return -EBUSY;
+
+	softlockup_enable(sl_state);
+
+	return ret;
 }
 
 EXPORT_SYMBOL_GPL(ide_wait_not_busy);
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -310,10 +310,14 @@ static void ide_pio_datablock(ide_drive_
 static void ide_pio_datablock(ide_drive_t *drive, struct request *rq,
 				     unsigned int write)
 {
+	int sl_state;
+
 	if (rq->bio)	/* fs request */
 		rq->errors = 0;
 
-	touch_softlockup_watchdog();
+	/* Tell softlockup this might take a while.
+	   XXX should this be global or per-cpu? */
+	sl_state = softlockup_disable();
 
 	switch (drive->hwif->data_phase) {
 	case TASKFILE_MULTI_IN:
@@ -324,6 +328,8 @@ static void ide_pio_datablock(ide_drive_
 		ide_pio_sector(drive, write);
 		break;
 	}
+
+	softlockup_enable(sl_state);
 }
 
 static ide_startstop_t task_error(ide_drive_t *drive, struct request *rq,
===================================================================
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -419,15 +419,21 @@ void nand_wait_ready(struct mtd_info *mt
 {
 	struct nand_chip *chip = mtd->priv;
 	unsigned long timeo = jiffies + 2;
+	int sl_state;
+
+	/* Tell softlockup this might take a while.
+	   XXX should this be global or per-cpu? */
+	sl_state = softlockup_disable();
 
 	led_trigger_event(nand_led_trigger, LED_FULL);
 	/* wait until command is processed or timeout occures */
 	do {
 		if (chip->dev_ready(mtd))
 			break;
-		touch_softlockup_watchdog();
 	} while (time_before(jiffies, timeo));
 	led_trigger_event(nand_led_trigger, LED_OFF);
+
+	softlockup_enable(sl_state);
 }
 EXPORT_SYMBOL_GPL(nand_wait_ready);
 

-- 


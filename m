Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab0CJE1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 23:27:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:46756 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202Ab0CJE04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 23:26:56 -0500
Message-ID: <4B971F83.4030505@kernel.org>
Date: Wed, 10 Mar 2010 13:26:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.34
References: <20100301202330.GA14977@havoc.gtf.org> <alpine.LFD.2.00.1003091304400.3583@i5.linux-foundation.org> <4B96C7B2.3080008@garzik.org>
In-Reply-To: <4B96C7B2.3080008@garzik.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 04:26:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus, Jeff.

On 03/10/2010 07:12 AM, Jeff Garzik wrote:
> Coincedentally, it looks like someone else just reported the same
> problem, with 2.6.34-rc1.
> 
> It definitely sounds like a race.  READ DMA is a DMA command as the name
> implies, so that eliminates the possibility of polling-related paths in
> ata_sff_interrupt (libata-sff.c).
> 
> I'll flip some of my machines to the icky slow boring piix mode, rather
> than sexy AHCI mode :) to see if I can reproduce.  I have had a feeling
> that we needed a more sophisticated IRQ handling setup, this may be what
> was needed.  Lost interrupt recovery should occur faster than 30 seconds
> in any case, and should not require a hard reset if the hardware
> functions just fine outside of the lost-interrupt / race that just
> occurred.

Yeap, there is a race condition with clearing which I don't think we
can solve completely but with some modification I think we can at
least cover known failure cases.

For longer term, I don't think we can solve this by diddling with the
SFF registers.  The interface is just way too ancient and horrid to
build anything reliable on top of.  I'm planning on implementing
smarter IRQ storm handling and stepped timeouts for ATA commands.

Linus, can you please test whether the following patch resolves the
problem?

Thanks.

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 02441fd..5de4cf3 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1667,6 +1667,7 @@ unsigned int ata_sff_host_intr(struct ata_port *ap,
 {
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	u8 status, host_stat = 0;
+	bool bmdma_stopped = false;
 
 	VPRINTK("ata%u: protocol %d task_state %d\n",
 		ap->print_id, qc->tf.protocol, ap->hsm_task_state);
@@ -1699,6 +1700,7 @@ unsigned int ata_sff_host_intr(struct ata_port *ap,
 
 			/* before we do anything else, clear DMA-Start bit */
 			ap->ops->bmdma_stop(qc);
+			bmdma_stopped = true;
 
 			if (unlikely(host_stat & ATA_DMA_ERR)) {
 				/* error when transfering data to/from memory */
@@ -1716,8 +1718,14 @@ unsigned int ata_sff_host_intr(struct ata_port *ap,
 
 	/* check main status, clearing INTRQ if needed */
 	status = ata_sff_irq_status(ap);
-	if (status & ATA_BUSY)
-		goto idle_irq;
+	if (status & ATA_BUSY) {
+		if (bmdma_stopped) {
+			/* BMDMA engine is already stopped, we're screwed */
+			qc->err_mask |= AC_ERR_HSM;
+			ap->hsm_task_state = HSM_ST_ERR;
+		} else
+			goto idle_irq;
+	}
 
 	/* ack bmdma irq events */
 	ap->ops->sff_irq_clear(ap);
@@ -1762,13 +1770,15 @@ EXPORT_SYMBOL_GPL(ata_sff_host_intr);
 irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
+	bool retried = false;
 	unsigned int i;
-	unsigned int handled = 0, polling = 0;
+	unsigned int handled, idle, polling;
 	unsigned long flags;
 
 	/* TODO: make _irqsave conditional on x86 PCI IDE legacy mode */
 	spin_lock_irqsave(&host->lock, flags);
-
+retry:
+	handled = idle = polling = 0;
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 		struct ata_queued_cmd *qc;
@@ -1782,7 +1792,8 @@ irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 				handled |= ata_sff_host_intr(ap, qc);
 			else
 				polling |= 1 << i;
-		}
+		} else
+			idle |= 1 << i;
 	}
 
 	/*
@@ -1790,7 +1801,9 @@ irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 	 * asserting IRQ line, nobody cared will ensue.  Check IRQ
 	 * pending status if available and clear spurious IRQ.
 	 */
-	if (!handled) {
+	if (!handled && !retried) {
+		bool retry = false;
+
 		for (i = 0; i < host->n_ports; i++) {
 			struct ata_port *ap = host->ports[i];
 
@@ -1805,8 +1818,22 @@ irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 				ata_port_printk(ap, KERN_INFO,
 						"clearing spurious IRQ\n");
 
-			ap->ops->sff_check_status(ap);
-			ap->ops->sff_irq_clear(ap);
+			if (idle & (1 << i)) {
+				ap->ops->sff_check_status(ap);
+				ap->ops->sff_irq_clear(ap);
+			} else {
+				/* clear INTRQ and check if BUSY cleared */
+				if (!(ap->ops->sff_check_status(ap) & ATA_BUSY))
+					retry |= true;
+				/*
+				 * With command in flight, we can't do
+				 * sff_irq_clear() w/o racing with completion.
+				 */
+			}
+		}
+		if (retry) {
+			retried = true;
+			goto retry;
 		}
 	}

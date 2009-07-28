Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbZG1XEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbZG1XEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbZG1XET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:04:19 -0400
Received: from kroah.org ([198.145.64.141]:43104 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987AbZG1XEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:04:15 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:46 2009
Message-Id: <20090728225946.186554282@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:59:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Dillow <dave@thedillows.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 35/37] r8169: avoid losing MSI interrupts
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=r8169-avoid-losing-msi-interrupts.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Dillow <dave@thedillows.org>

[ Upstream commit f11a377b3f4e897d11f0e8d1fc688667e2f19708 ]

The 8169 chip only generates MSI interrupts when all enabled event
sources are quiescent and one or more sources transition to active. If
not all of the active events are acknowledged, or a new event becomes
active while the existing ones are cleared in the handler, we will not
see a new interrupt.

The current interrupt handler masks off the Rx and Tx events once the
NAPI handler has been scheduled, which opens a race window in which we
can get another Rx or Tx event and never ACK'ing it, stopping all
activity until the link is reset (ifconfig down/up). Fix this by always
ACK'ing all event sources, and loop in the handler until we have all
sources quiescent.

Signed-off-by: David Dillow <dave@thedillows.org>
Tested-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/r8169.c |  102 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 57 insertions(+), 45 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2850,54 +2850,64 @@ static irqreturn_t rtl8169_interrupt(int
 	int handled = 0;
 	int status;
 
+	/* loop handling interrupts until we have no new ones or
+	 * we hit a invalid/hotplug case.
+	 */
 	status = RTL_R16(IntrStatus);
+	while (status && status != 0xffff) {
+		handled = 1;
 
-	/* hotplug/major error/no more work/shared irq */
-	if ((status == 0xffff) || !status)
-		goto out;
-
-	handled = 1;
+		/* Handle all of the error cases first. These will reset
+		 * the chip, so just exit the loop.
+		 */
+		if (unlikely(!netif_running(dev))) {
+			rtl8169_asic_down(ioaddr);
+			break;
+		}
 
-	if (unlikely(!netif_running(dev))) {
-		rtl8169_asic_down(ioaddr);
-		goto out;
-	}
+		/* Work around for rx fifo overflow */
+		if (unlikely(status & RxFIFOOver) &&
+		(tp->mac_version == RTL_GIGA_MAC_VER_11)) {
+			netif_stop_queue(dev);
+			rtl8169_tx_timeout(dev);
+			break;
+		}
 
-	status &= tp->intr_mask;
-	RTL_W16(IntrStatus,
-		(status & RxFIFOOver) ? (status | RxOverflow) : status);
+		if (unlikely(status & SYSErr)) {
+			rtl8169_pcierr_interrupt(dev);
+			break;
+		}
 
-	if (!(status & tp->intr_event))
-		goto out;
+		if (status & LinkChg)
+			rtl8169_check_link_status(dev, tp, ioaddr);
 
-	/* Work around for rx fifo overflow */
-	if (unlikely(status & RxFIFOOver) &&
-	    (tp->mac_version == RTL_GIGA_MAC_VER_11)) {
-		netif_stop_queue(dev);
-		rtl8169_tx_timeout(dev);
-		goto out;
-	}
+		/* We need to see the lastest version of tp->intr_mask to
+		 * avoid ignoring an MSI interrupt and having to wait for
+		 * another event which may never come.
+		 */
+		smp_rmb();
+		if (status & tp->intr_mask & tp->napi_event) {
+			RTL_W16(IntrMask, tp->intr_event & ~tp->napi_event);
+			tp->intr_mask = ~tp->napi_event;
+
+			if (likely(napi_schedule_prep(&tp->napi)))
+				__napi_schedule(&tp->napi);
+			else if (netif_msg_intr(tp)) {
+				printk(KERN_INFO "%s: interrupt %04x in poll\n",
+				dev->name, status);
+			}
+		}
 
-	if (unlikely(status & SYSErr)) {
-		rtl8169_pcierr_interrupt(dev);
-		goto out;
+		/* We only get a new MSI interrupt when all active irq
+		 * sources on the chip have been acknowledged. So, ack
+		 * everything we've seen and check if new sources have become
+		 * active to avoid blocking all interrupts from the chip.
+		 */
+		RTL_W16(IntrStatus,
+			(status & RxFIFOOver) ? (status | RxOverflow) : status);
+		status = RTL_R16(IntrStatus);
 	}
 
-	if (status & LinkChg)
-		rtl8169_check_link_status(dev, tp, ioaddr);
-
-	if (status & tp->napi_event) {
-		RTL_W16(IntrMask, tp->intr_event & ~tp->napi_event);
-		tp->intr_mask = ~tp->napi_event;
-
-		if (likely(netif_rx_schedule_prep(dev, &tp->napi)))
-			__netif_rx_schedule(dev, &tp->napi);
-		else if (netif_msg_intr(tp)) {
-			printk(KERN_INFO "%s: interrupt %04x in poll\n",
-			       dev->name, status);
-		}
-	}
-out:
 	return IRQ_RETVAL(handled);
 }
 
@@ -2913,13 +2923,15 @@ static int rtl8169_poll(struct napi_stru
 
 	if (work_done < budget) {
 		netif_rx_complete(dev, napi);
-		tp->intr_mask = 0xffff;
-		/*
-		 * 20040426: the barrier is not strictly required but the
-		 * behavior of the irq handler could be less predictable
-		 * without it. Btw, the lack of flush for the posted pci
-		 * write is safe - FR
+
+		/* We need for force the visibility of tp->intr_mask
+		 * for other CPUs, as we can loose an MSI interrupt
+		 * and potentially wait for a retransmit timeout if we don't.
+		 * The posted write to IntrMask is safe, as it will
+		 * eventually make it to the chip and we won't loose anything
+		 * until it does.
 		 */
+		tp->intr_mask = 0xffff;
 		smp_wmb();
 		RTL_W16(IntrMask, tp->intr_event);
 	}



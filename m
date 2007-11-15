Return-Path: <linux-kernel-owner+w=401wt.eu-S1765450AbXKOGp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765450AbXKOGp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761223AbXKOGmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:42:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55098 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761251AbXKOGms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:42:48 -0500
Date: Wed, 14 Nov 2007 22:40:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Manfred Spraul <manfred@colorfullife.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 04/16] forcedeth msi bugfix
Message-ID: <20071115064010.GD18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="forcedeth-msi-bugfix.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Manfred Spraul <manfred@colorfullife.com>

patch a7475906bc496456ded9e4b062f94067fb93057a in mainline.

pci_enable_msi() replaces the INTx irq number in pci_dev->irq with the
new MSI irq number.
The forcedeth driver did not update the copy in netdevice->irq and
parts of the driver used the stale copy.
See bugzilla.kernel.org, bug 9047.

The patch
- updates netdevice->irq
- replaces all accesses to netdevice->irq with pci_dev->irq.

The patch is against 2.6.23.1. IMHO suitable for both 2.6.23 and 2.6.24

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/forcedeth.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -988,7 +988,7 @@ static void nv_enable_irq(struct net_dev
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			enable_irq(dev->irq);
+			enable_irq(np->pci_dev->irq);
 	} else {
 		enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_RX].vector);
 		enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_TX].vector);
@@ -1004,7 +1004,7 @@ static void nv_disable_irq(struct net_de
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			disable_irq(dev->irq);
+			disable_irq(np->pci_dev->irq);
 	} else {
 		disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_RX].vector);
 		disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_TX].vector);
@@ -1601,7 +1601,7 @@ static void nv_do_rx_refill(unsigned lon
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			disable_irq(dev->irq);
+			disable_irq(np->pci_dev->irq);
 	} else {
 		disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_RX].vector);
 	}
@@ -1619,7 +1619,7 @@ static void nv_do_rx_refill(unsigned lon
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			enable_irq(dev->irq);
+			enable_irq(np->pci_dev->irq);
 	} else {
 		enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_RX].vector);
 	}
@@ -3557,10 +3557,12 @@ static int nv_request_irq(struct net_dev
 	if (ret != 0 && np->msi_flags & NV_MSI_CAPABLE) {
 		if ((ret = pci_enable_msi(np->pci_dev)) == 0) {
 			np->msi_flags |= NV_MSI_ENABLED;
+			dev->irq = np->pci_dev->irq;
 			if (request_irq(np->pci_dev->irq, handler, IRQF_SHARED, dev->name, dev) != 0) {
 				printk(KERN_INFO "forcedeth: request_irq failed %d\n", ret);
 				pci_disable_msi(np->pci_dev);
 				np->msi_flags &= ~NV_MSI_ENABLED;
+				dev->irq = np->pci_dev->irq;
 				goto out_err;
 			}
 
@@ -3623,7 +3625,7 @@ static void nv_do_nic_poll(unsigned long
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			disable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			disable_irq_lockdep(dev->irq);
+			disable_irq_lockdep(np->pci_dev->irq);
 		mask = np->irqmask;
 	} else {
 		if (np->nic_poll_irq & NVREG_IRQ_RX_ALL) {
@@ -3641,6 +3643,8 @@ static void nv_do_nic_poll(unsigned long
 	}
 	np->nic_poll_irq = 0;
 
+	/* disable_irq() contains synchronize_irq, thus no irq handler can run now */
+
 	if (np->recover_error) {
 		np->recover_error = 0;
 		printk(KERN_INFO "forcedeth: MAC in recoverable error state\n");
@@ -3677,7 +3681,6 @@ static void nv_do_nic_poll(unsigned long
 		}
 	}
 
-	/* FIXME: Do we need synchronize_irq(dev->irq) here? */
 
 	writel(mask, base + NvRegIrqMask);
 	pci_push(base);
@@ -3690,7 +3693,7 @@ static void nv_do_nic_poll(unsigned long
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			enable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			enable_irq_lockdep(dev->irq);
+			enable_irq_lockdep(np->pci_dev->irq);
 	} else {
 		if (np->nic_poll_irq & NVREG_IRQ_RX_ALL) {
 			nv_nic_irq_rx(0, dev);
@@ -4943,7 +4946,7 @@ static int nv_close(struct net_device *d
 	np->in_shutdown = 1;
 	spin_unlock_irq(&np->lock);
 	netif_poll_disable(dev);
-	synchronize_irq(dev->irq);
+	synchronize_irq(np->pci_dev->irq);
 
 	del_timer_sync(&np->oom_kick);
 	del_timer_sync(&np->nic_poll);

-- 

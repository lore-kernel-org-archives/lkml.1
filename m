Return-Path: <linux-kernel-owner+w=401wt.eu-S1762081AbZAWBZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081AbZAWBZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760263AbZAWBPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:14 -0500
Received: from kroah.org ([198.145.64.141]:50606 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760226AbZAWBPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:00 -0500
Date: Thu, 22 Jan 2009 17:12:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Joe Chou <Joe.Chou@rdc.com.tw>,
       Florian Fainelli <florian@openwrt.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 23/46] r6040: save and restore MIER correctly in the
	interrupt routine
Message-ID: <20090123011217.GX19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="r6040-save-and-restore-mier-correctly-in-the-interrupt-routine.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joe Chou <Joe.Chou@rdc.com.tw>

[ Upstream commit: 3e7c469f07ff14cbf9a814739e1fc99a863e0943 ]

This patch saves the MIER register contents before treating
interrupts, then restores them correcty at the end of the
interrupt routine.

Signed-off-by: Joe Chou <Joe.Chou@rdc.com.tw>
Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r6040.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -681,8 +681,10 @@ static irqreturn_t r6040_interrupt(int i
 	struct net_device *dev = dev_id;
 	struct r6040_private *lp = netdev_priv(dev);
 	void __iomem *ioaddr = lp->base;
-	u16 status;
+	u16 misr, status;
 
+	/* Save MIER */
+	misr = ioread16(ioaddr + MIER);
 	/* Mask off RDC MAC interrupt */
 	iowrite16(MSK_INT, ioaddr + MIER);
 	/* Read MISR status and clear */
@@ -702,7 +704,7 @@ static irqreturn_t r6040_interrupt(int i
 			dev->stats.rx_fifo_errors++;
 
 		/* Mask off RX interrupt */
-		iowrite16(ioread16(ioaddr + MIER) & ~RX_INTS, ioaddr + MIER);
+		misr &= ~RX_INTS;
 		netif_rx_schedule(dev, &lp->napi);
 	}
 
@@ -710,6 +712,9 @@ static irqreturn_t r6040_interrupt(int i
 	if (status & TX_INTS)
 		r6040_tx(dev);
 
+	/* Restore RDC MAC interrupt */
+	iowrite16(misr, ioaddr + MIER);
+
 	return IRQ_HANDLED;
 }
 


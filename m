Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0BCFSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 00:18:13 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34404 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0BCFRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 00:17:17 -0500
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Rob Herring <r.herring@freescale.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, Dinh.Nguyen@freescale.com,
       bryan.wu@canonical.com
Subject: [PATCHv2 08/11] fec: fix uninitialized rx buffer usage
Date: Tue,  2 Feb 2010 21:16:30 -0800
Message-Id: <e46b06510f7eb6ca51ea8b96335b2d32ec8bf6f8.1265173480.git.amit.kucheria@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <752ae69adb57d4f73fa011ba380cea1b927b9c8b.1265173480.git.amit.kucheria@canonical.com>
References: <cover.1265173246.git.amit.kucheria@verdurent.com>
 <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com>
 <9fa7a3c70c46a1f776c6520051481cff6525ef02.1265173480.git.amit.kucheria@canonical.com>
 <ccc89dd7a6035abf5a78680404a2b30b9e025353.1265173480.git.amit.kucheria@canonical.com>
 <ec63e5978fd5ac5d308ede5916e648ba925818eb.1265173480.git.amit.kucheria@canonical.com>
 <f10f79e7313ecdeeb59ab881795baedf2430c636.1265173480.git.amit.kucheria@canonical.com>
 <240f12ca87d7666f31263aabc620a9ec197cd8ff.1265173480.git.amit.kucheria@canonical.com>
 <752ae69adb57d4f73fa011ba380cea1b927b9c8b.1265173480.git.amit.kucheria@canonical.com>
In-Reply-To: <cover.1265173480.git.amit.kucheria@canonical.com>
References: <cover.1265173480.git.amit.kucheria@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <r.herring@freescale.com>

The fec driver was enabling receive buffer descriptor without allocating
the buffers. Make sure the buffer descriptors are initialized to not
start receiving packets.

Open also calls fec_restart after the rx buffers are allocated. With the code
in fec_restart, it zeroes out the buffer descriptors that have just been
setup.

Signed-off-by: Rob Herring <r.herring@freescale.com>
Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 drivers/net/fec.c |   57 +++++++++++++++++++++++++++--------------------------
 1 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/net/fec.c b/drivers/net/fec.c
index 16a1d58..9a8743d 100644
--- a/drivers/net/fec.c
+++ b/drivers/net/fec.c
@@ -1658,6 +1658,7 @@ static int fec_enet_init(struct net_device *dev, int index)
 {
 	struct fec_enet_private *fep = netdev_priv(dev);
 	struct bufdesc *cbd_base;
+	struct bufdesc *bdp;
 	int i;
 
 	/* Allocate memory for buffer descriptors. */
@@ -1710,6 +1711,34 @@ static int fec_enet_init(struct net_device *dev, int index)
 	/* Set MII speed to 2.5 MHz */
 	fep->phy_speed = ((((clk_get_rate(fep->clk) / 2 + 4999999)
 					/ 2500000) / 2) & 0x3F) << 1;
+
+	/* Initialize the receive buffer descriptors. */
+	bdp = fep->rx_bd_base;
+	for (i = 0; i < RX_RING_SIZE; i++) {
+
+		/* Initialize the BD for every fragment in the page. */
+		bdp->cbd_sc = 0;
+		bdp++;
+	}
+
+	/* Set the last buffer to wrap */
+	bdp--;
+	bdp->cbd_sc |= BD_SC_WRAP;
+
+	/* ...and the same for transmit */
+	bdp = fep->tx_bd_base;
+	for (i = 0; i < TX_RING_SIZE; i++) {
+
+		/* Initialize the BD for every fragment in the page. */
+		bdp->cbd_sc = 0;
+		bdp->cbd_bufaddr = 0;
+		bdp++;
+	}
+
+	/* Set the last buffer to wrap */
+	bdp--;
+	bdp->cbd_sc |= BD_SC_WRAP;
+
 	fec_restart(dev, 0);
 
 	/* Queue up command to detect the PHY and initialize the
@@ -1730,7 +1759,6 @@ static void
 fec_restart(struct net_device *dev, int duplex)
 {
 	struct fec_enet_private *fep = netdev_priv(dev);
-	struct bufdesc *bdp;
 	int i;
 
 	/* Whack a reset.  We should wait for this. */
@@ -1768,33 +1796,6 @@ fec_restart(struct net_device *dev, int duplex)
 		}
 	}
 
-	/* Initialize the receive buffer descriptors. */
-	bdp = fep->rx_bd_base;
-	for (i = 0; i < RX_RING_SIZE; i++) {
-
-		/* Initialize the BD for every fragment in the page. */
-		bdp->cbd_sc = BD_ENET_RX_EMPTY;
-		bdp++;
-	}
-
-	/* Set the last buffer to wrap */
-	bdp--;
-	bdp->cbd_sc |= BD_SC_WRAP;
-
-	/* ...and the same for transmit */
-	bdp = fep->tx_bd_base;
-	for (i = 0; i < TX_RING_SIZE; i++) {
-
-		/* Initialize the BD for every fragment in the page. */
-		bdp->cbd_sc = 0;
-		bdp->cbd_bufaddr = 0;
-		bdp++;
-	}
-
-	/* Set the last buffer to wrap */
-	bdp--;
-	bdp->cbd_sc |= BD_SC_WRAP;
-
 	/* Enable MII mode */
 	if (duplex) {
 		/* MII enable / FD enable */
-- 
1.6.3.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S932302AbXKOGp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbXKOGp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761718AbXKOGmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:42:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55102 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761504AbXKOGmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:42:50 -0500
Date: Wed, 14 Nov 2007 22:40:37 -0800
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
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 08/16] skge: fix ram buffer size calculation
Message-ID: <20071115064037.GH18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="skge-ram-buffer-fix.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stephen Hemminger <shemminger@linux-foundation.org>

patch 7fb7ac241162dc51ec0f7644d4a97b2855213c32 in mainline.

This fixes problems with transmit hangs on older fiber based SysKonnect boards.

Adjust ram buffer sizing calculation to make it correct on all boards
and make it like the code in sky2 driver.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Jeff Garzik <jeff@garzik.org>

---
 drivers/net/skge.c |   51 ++++++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

--- a/drivers/net/skge.c
+++ b/drivers/net/skge.c
@@ -2400,32 +2400,31 @@ static int skge_ioctl(struct net_device 
 	return err;
 }
 
-static void skge_ramset(struct skge_hw *hw, u16 q, u32 start, size_t len)
+/* Assign Ram Buffer allocation to queue */
+static void skge_ramset(struct skge_hw *hw, u16 q, u32 start, u32 space)
 {
 	u32 end;
 
-	start /= 8;
-	len /= 8;
-	end = start + len - 1;
+	/* convert from K bytes to qwords used for hw register */
+	start *= 1024/8;
+	space *= 1024/8;
+	end = start + space - 1;
 
 	skge_write8(hw, RB_ADDR(q, RB_CTRL), RB_RST_CLR);
 	skge_write32(hw, RB_ADDR(q, RB_START), start);
+	skge_write32(hw, RB_ADDR(q, RB_END), end);
 	skge_write32(hw, RB_ADDR(q, RB_WP), start);
 	skge_write32(hw, RB_ADDR(q, RB_RP), start);
-	skge_write32(hw, RB_ADDR(q, RB_END), end);
 
 	if (q == Q_R1 || q == Q_R2) {
+		u32 tp = space - space/4;
+
 		/* Set thresholds on receive queue's */
-		skge_write32(hw, RB_ADDR(q, RB_RX_UTPP),
-			     start + (2*len)/3);
-		skge_write32(hw, RB_ADDR(q, RB_RX_LTPP),
-			     start + (len/3));
-	} else {
-		/* Enable store & forward on Tx queue's because
-		 * Tx FIFO is only 4K on Genesis and 1K on Yukon
-		 */
+		skge_write32(hw, RB_ADDR(q, RB_RX_UTPP), tp);
+		skge_write32(hw, RB_ADDR(q, RB_RX_LTPP), space/4);
+	} else if (hw->chip_id != CHIP_ID_GENESIS)
+		/* Genesis Tx Fifo is too small for normal store/forward */
 		skge_write8(hw, RB_ADDR(q, RB_CTRL), RB_ENA_STFWD);
-	}
 
 	skge_write8(hw, RB_ADDR(q, RB_CTRL), RB_ENA_OP_MD);
 }
@@ -2453,7 +2452,7 @@ static int skge_up(struct net_device *de
 	struct skge_port *skge = netdev_priv(dev);
 	struct skge_hw *hw = skge->hw;
 	int port = skge->port;
-	u32 chunk, ram_addr;
+	u32 ramaddr, ramsize, rxspace;
 	size_t rx_size, tx_size;
 	int err;
 
@@ -2508,14 +2507,15 @@ static int skge_up(struct net_device *de
 	spin_unlock_bh(&hw->phy_lock);
 
 	/* Configure RAMbuffers */
-	chunk = hw->ram_size / ((hw->ports + 1)*2);
-	ram_addr = hw->ram_offset + 2 * chunk * port;
+	ramsize = (hw->ram_size - hw->ram_offset) / hw->ports;
+	ramaddr = hw->ram_offset + port * ramsize;
+	rxspace = 8 + (2*(ramsize - 16))/3;
 
-	skge_ramset(hw, rxqaddr[port], ram_addr, chunk);
-	skge_qset(skge, rxqaddr[port], skge->rx_ring.to_clean);
+	skge_ramset(hw, rxqaddr[port], ramaddr, rxspace);
+	skge_ramset(hw, txqaddr[port], ramaddr + rxspace, ramsize - rxspace);
 
+	skge_qset(skge, rxqaddr[port], skge->rx_ring.to_clean);
 	BUG_ON(skge->tx_ring.to_use != skge->tx_ring.to_clean);
-	skge_ramset(hw, txqaddr[port], ram_addr+chunk, chunk);
 	skge_qset(skge, txqaddr[port], skge->tx_ring.to_use);
 
 	/* Start receiver BMU */
@@ -3450,15 +3450,12 @@ static int skge_reset(struct skge_hw *hw
 	if (hw->chip_id == CHIP_ID_GENESIS) {
 		if (t8 == 3) {
 			/* special case: 4 x 64k x 36, offset = 0x80000 */
-			hw->ram_size = 0x100000;
-			hw->ram_offset = 0x80000;
+			hw->ram_size = 1024;
+			hw->ram_offset = 512;
 		} else
 			hw->ram_size = t8 * 512;
-	}
-	else if (t8 == 0)
-		hw->ram_size = 0x20000;
-	else
-		hw->ram_size = t8 * 4096;
+	} else /* Yukon */
+		hw->ram_size = t8 ? t8 * 4 : 128;
 
 	hw->intr_mask = IS_HW_ERR;
 

-- 

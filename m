Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbXKOGsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbXKOGsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762002AbXKOGnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:43:01 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55150 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944AbXKOGm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:42:59 -0500
Date: Wed, 14 Nov 2007 22:40:56 -0800
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
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 11/16] sky2: ethtool register reserved area blackout
Message-ID: <20071115064056.GK18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sky2-ethdump.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen Hemminger <shemminger@linux-foundation.org>

patch 295b54c4902c52cd00d7c837d50a86e39e26caec in mainline.

Make sure and not dump reserved areas of device space.
Touching some of these causes machine check exceptions on boards
like D-Link DGE-550SX.

Coding note, used a complex switch statement rather than bitmap
because it is easier to relate the block values to the documentation
rather than looking at a encoded bitmask.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/sky2.c |   62 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 9 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -3570,20 +3570,64 @@ static void sky2_get_regs(struct net_dev
 {
 	const struct sky2_port *sky2 = netdev_priv(dev);
 	const void __iomem *io = sky2->hw->regs;
+	unsigned int b;
 
 	regs->version = 1;
-	memset(p, 0, regs->len);
 
-	memcpy_fromio(p, io, B3_RAM_ADDR);
-
-	/* skip diagnostic ram region */
-	memcpy_fromio(p + B3_RI_WTO_R1, io + B3_RI_WTO_R1, 0x2000 - B3_RI_WTO_R1);
+	for (b = 0; b < 128; b++) {
+		/* This complicated switch statement is to make sure and
+		 * only access regions that are unreserved.
+		 * Some blocks are only valid on dual port cards.
+		 * and block 3 has some special diagnostic registers that
+		 * are poison.
+		 */
+		switch (b) {
+		case 3:
+			/* skip diagnostic ram region */
+			memcpy_fromio(p + 0x10, io + 0x10, 128 - 0x10);
+			break;
 
-	/* copy GMAC registers */
-	memcpy_fromio(p + BASE_GMAC_1, io + BASE_GMAC_1, 0x1000);
-	if (sky2->hw->ports > 1)
-		memcpy_fromio(p + BASE_GMAC_2, io + BASE_GMAC_2, 0x1000);
+		/* dual port cards only */
+		case 5:		/* Tx Arbiter 2 */
+		case 9: 	/* RX2 */
+		case 14 ... 15:	/* TX2 */
+		case 17: case 19: /* Ram Buffer 2 */
+		case 22 ... 23: /* Tx Ram Buffer 2 */
+		case 25: 	/* Rx MAC Fifo 1 */
+		case 27: 	/* Tx MAC Fifo 2 */
+		case 31:	/* GPHY 2 */
+		case 40 ... 47: /* Pattern Ram 2 */
+		case 52: case 54: /* TCP Segmentation 2 */
+		case 112 ... 116: /* GMAC 2 */
+			if (sky2->hw->ports == 1)
+				goto reserved;
+			/* fall through */
+		case 0:		/* Control */
+		case 2:		/* Mac address */
+		case 4:		/* Tx Arbiter 1 */
+		case 7:		/* PCI express reg */
+		case 8:		/* RX1 */
+		case 12 ... 13: /* TX1 */
+		case 16: case 18:/* Rx Ram Buffer 1 */
+		case 20 ... 21: /* Tx Ram Buffer 1 */
+		case 24: 	/* Rx MAC Fifo 1 */
+		case 26: 	/* Tx MAC Fifo 1 */
+		case 28 ... 29: /* Descriptor and status unit */
+		case 30:	/* GPHY 1*/
+		case 32 ... 39: /* Pattern Ram 1 */
+		case 48: case 50: /* TCP Segmentation 1 */
+		case 56 ... 60:	/* PCI space */
+		case 80 ... 84:	/* GMAC 1 */
+			memcpy_fromio(p, io, 128);
+			break;
+		default:
+reserved:
+			memset(p, 0, 128);
+		}
 
+		p += 128;
+		io += 128;
+	}
 }
 
 /* In order to do Jumbo packets on these chips, need to turn off the

-- 

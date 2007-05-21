Return-Path: <linux-kernel-owner+w=401wt.eu-S935543AbXEUTwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935543AbXEUTwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934116AbXEUT3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:29:40 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52675 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934108AbXEUT3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:29:36 -0400
Message-Id: <20070521191716.782832000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Michael Chan" <mchan@broadcom.com>,
       Matt Carlson <mcarlson@broadcom.com>,
       David S Miller <davem@davemloft.net>
Subject: [patch 21/69] TG3: Fix TSO bugs.
Content-Disposition: inline; filename=tg3-fix-tso-bugs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From:  <mchan@broadcom.com>

1. Remove the check for skb->len greater than MTU when doing TSO.
When the destination has a smaller MSS than the source, a TSO packet
may be smaller than the MTU and we still need to process it as a TSO
packet.

2. On 5705A3 devices with TSO enabled, the DMA engine can hang due to a
hardware bug.  This patch avoids the hanging condition by reducing the
DMA burst size.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

---
 drivers/net/tg3.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- linux-2.6.21.1.orig/drivers/net/tg3.c
+++ linux-2.6.21.1/drivers/net/tg3.c
@@ -3895,8 +3895,7 @@ static int tg3_start_xmit(struct sk_buff
 	entry = tp->tx_prod;
 	base_flags = 0;
 	mss = 0;
-	if (skb->len > (tp->dev->mtu + ETH_HLEN) &&
-	    (mss = skb_shinfo(skb)->gso_size) != 0) {
+	if ((mss = skb_shinfo(skb)->gso_size) != 0) {
 		int tcp_opt_len, ip_tcp_len;
 
 		if (skb_header_cloned(skb) &&
@@ -4053,8 +4052,7 @@ static int tg3_start_xmit_dma_bug(struct
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		base_flags |= TXD_FLAG_TCPUDP_CSUM;
 	mss = 0;
-	if (skb->len > (tp->dev->mtu + ETH_HLEN) &&
-	    (mss = skb_shinfo(skb)->gso_size) != 0) {
+	if ((mss = skb_shinfo(skb)->gso_size) != 0) {
 		int tcp_opt_len, ip_tcp_len, hdr_len;
 
 		if (skb_header_cloned(skb) &&
@@ -6348,8 +6346,7 @@ static int tg3_reset_hw(struct tg3 *tp, 
 	     tp->pci_chip_rev_id != CHIPREV_ID_5705_A0) ||
 	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5750)) {
 		if (tp->tg3_flags2 & TG3_FLG2_TSO_CAPABLE &&
-		    (tp->pci_chip_rev_id == CHIPREV_ID_5705_A1 ||
-		     tp->pci_chip_rev_id == CHIPREV_ID_5705_A2)) {
+		    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5705) {
 			rdmac_mode |= RDMAC_MODE_FIFO_SIZE_128;
 		} else if (!(tr32(TG3PCI_PCISTATE) & PCISTATE_BUS_SPEED_HIGH) &&
 			   !(tp->tg3_flags2 & TG3_FLG2_IS_5788)) {

-- 

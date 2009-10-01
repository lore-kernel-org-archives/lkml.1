Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbZJAXYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbZJAXYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZJAXXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:23:20 -0400
Received: from kroah.org ([198.145.64.141]:39657 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbZJAXXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:23:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:18:05 2009
Message-Id: <20091001231804.861826549@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:16:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Baruch Siach <baruch@tkos.co.il>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 3/9] enc28j60: fix RX buffer overflow
References: <20091001231633.719696398@mini.kroah.org>
Content-Disposition: inline; filename=enc28j60-fix-rx-buffer-overflow.patch
In-Reply-To: <20091001231938.GA29593@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Baruch Siach <baruch@tkos.co.il>

commit 22692018b93f0782cda5a843cecfffda1854eb8d upstream.

The enc28j60 driver doesn't check whether the length of the packet as reported
by the hardware fits into the preallocated buffer. When stressed, the hardware
may report insanely large packets even tough the "Receive OK" bit is set. Fix
this.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/enc28j60.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/enc28j60.c
+++ b/drivers/net/enc28j60.c
@@ -919,7 +919,7 @@ static void enc28j60_hw_rx(struct net_de
 	if (netif_msg_rx_status(priv))
 		enc28j60_dump_rsv(priv, __FUNCTION__, next_packet, len, rxstat);
 
-	if (!RSV_GETBIT(rxstat, RSV_RXOK)) {
+	if (!RSV_GETBIT(rxstat, RSV_RXOK) || len > MAX_FRAMELEN) {
 		if (netif_msg_rx_err(priv))
 			dev_err(&ndev->dev, "Rx Error (%04x)\n", rxstat);
 		ndev->stats.rx_errors++;
@@ -927,6 +927,8 @@ static void enc28j60_hw_rx(struct net_de
 			ndev->stats.rx_crc_errors++;
 		if (RSV_GETBIT(rxstat, RSV_LENCHECKERR))
 			ndev->stats.rx_frame_errors++;
+		if (len > MAX_FRAMELEN)
+			ndev->stats.rx_over_errors++;
 	} else {
 		skb = dev_alloc_skb(len + NET_IP_ALIGN);
 		if (!skb) {



Return-Path: <linux-kernel-owner+w=401wt.eu-S935801AbXEUTxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935801AbXEUTxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765974AbXEUT3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:29:47 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52693 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934138AbXEUT3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:29:46 -0400
Message-Id: <20070521191721.500445000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:36 -0700
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
       David S Miller <davem@davemloft.net>
Subject: [patch 24/69] BNX2: Fix TSO problem with small MSS.
Content-Disposition: inline; filename=bnx2-fix-tso-problem-with-small-mss.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From:  <mchan@broadcom.com>

Remove the check for skb->len greater than MTU when doing TSO.  When
the destination has a smaller MSS than the source, a TSO packet may
be smaller than the MTU at the source and we still need to process it
as a TSO packet.

Thanks to Brian Ristuccia <bristuccia@starentnetworks.com> for
reporting the problem.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/net/bnx2.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.21.1.orig/drivers/net/bnx2.c
+++ linux-2.6.21.1/drivers/net/bnx2.c
@@ -4510,8 +4510,7 @@ bnx2_start_xmit(struct sk_buff *skb, str
 		vlan_tag_flags |=
 			(TX_BD_FLAGS_VLAN_TAG | (vlan_tx_tag_get(skb) << 16));
 	}
-	if ((mss = skb_shinfo(skb)->gso_size) &&
-		(skb->len > (bp->dev->mtu + ETH_HLEN))) {
+	if ((mss = skb_shinfo(skb)->gso_size)) {
 		u32 tcp_opt_len, ip_tcp_len;
 
 		if (skb_header_cloned(skb) &&

-- 

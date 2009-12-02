Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZLBDSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZLBDSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 22:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZLBDSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 22:18:30 -0500
Received: from mail.atheros.com ([12.36.123.2]:50680 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbZLBDS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 22:18:29 -0500
From: <jie.yang@atheros.com>
To: <davem@davemloft.net>
CC: <ben@decadent.org.uk>, <558426@bugs.debian.org>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, Jie Yang <jie.yang@atheros.com>
Subject: [PATCH net-next]atl1e:disable NETIF_F_TSO6 for hardware limit
Date: Wed, 2 Dec 2009 11:18:34 +0800
Message-ID: <1259723914457-git-send-email-jie.yang@atheros.com>
X-Mailer: git-send-email 1.5.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Yang <jie.yang@atheros.com>

For hardware limit to support TSOV6, just disable this feature
Signed-off-by: Jie Yang <jie.yang@atheros.com>
---

 drivers/net/atl1e/atl1e_main.c |   36 ------------------------------------
 1 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/net/atl1e/atl1e_main.c b/drivers/net/atl1e/atl1e_main.c
index ad17e74..08f8c09 100644
--- a/drivers/net/atl1e/atl1e_main.c
+++ b/drivers/net/atl1e/atl1e_main.c
@@ -1664,41 +1664,6 @@ static int atl1e_tso_csum(struct atl1e_adapter *adapter,
 			}
 			return 0;
 		}
-
-		if (offload_type & SKB_GSO_TCPV6) {
-			real_len = (((unsigned char *)ipv6_hdr(skb) - skb->data)
-					+ ntohs(ipv6_hdr(skb)->payload_len));
-			if (real_len < skb->len)
-				pskb_trim(skb, real_len);
-
-			/* check payload == 0 byte ? */
-			hdr_len = (skb_transport_offset(skb) + tcp_hdrlen(skb));
-			if (unlikely(skb->len == hdr_len)) {
-				/* only xsum need */
-				dev_warn(&pdev->dev,
-					"IPV6 tso with zero data??\n");
-				goto check_sum;
-			} else {
-				tcp_hdr(skb)->check = ~csum_ipv6_magic(
-						&ipv6_hdr(skb)->saddr,
-						&ipv6_hdr(skb)->daddr,
-						0, IPPROTO_TCP, 0);
-				tpd->word3 |= 1 << TPD_IP_VERSION_SHIFT;
-				hdr_len >>= 1;
-				tpd->word3 |= (hdr_len & TPD_V6_IPHLLO_MASK) <<
-					TPD_V6_IPHLLO_SHIFT;
-				tpd->word3 |= ((hdr_len >> 3) &
-					TPD_V6_IPHLHI_MASK) <<
-					TPD_V6_IPHLHI_SHIFT;
-				tpd->word3 |= (tcp_hdrlen(skb) >> 2 &
-					TPD_TCPHDRLEN_MASK) <<
-					TPD_TCPHDRLEN_SHIFT;
-				tpd->word3 |= ((skb_shinfo(skb)->gso_size) &
-					TPD_MSS_MASK) << TPD_MSS_SHIFT;
-					tpd->word3 |= 1 << TPD_SEGMENT_EN_SHIFT;
-			}
-		}
-		return 0;
 	}
 
 check_sum:
@@ -2287,7 +2252,6 @@ static int atl1e_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 		NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
 	netdev->features |= NETIF_F_LLTX;
 	netdev->features |= NETIF_F_TSO;
-	netdev->features |= NETIF_F_TSO6;
 
 	return 0;
 }

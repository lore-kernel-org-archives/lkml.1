Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739Ab0A0AE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab0A0AE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717Ab0A0ADr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:03:47 -0500
Received: from kroah.org ([198.145.64.141]:35152 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab0AZXnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:15 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:23 2010
Message-Id: <20100126233923.618150610@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jie Yang <jie.yang@atheros.com>,
       "David S. Miller" <davem@davemloft.net>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [21/98] atl1e:disable NETIF_F_TSO6 for hardware limit
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jie Yang <jie.yang@atheros.com>

commit 7c7afb083675b3d4d012a2aacec3a958ba484ab0 upstream.

For hardware limit to support TSOV6, just disable this feature
Signed-off-by: Jie Yang <jie.yang@atheros.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atl1e/atl1e_main.c |   36 ------------------------------------
 1 file changed, 36 deletions(-)

--- a/drivers/net/atl1e/atl1e_main.c
+++ b/drivers/net/atl1e/atl1e_main.c
@@ -1666,41 +1666,6 @@ static int atl1e_tso_csum(struct atl1e_a
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
@@ -2289,7 +2254,6 @@ static int atl1e_init_netdev(struct net_
 		NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
 	netdev->features |= NETIF_F_LLTX;
 	netdev->features |= NETIF_F_TSO;
-	netdev->features |= NETIF_F_TSO6;
 
 	return 0;
 }



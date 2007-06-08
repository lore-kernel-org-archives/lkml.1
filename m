Return-Path: <linux-kernel-owner+w=401wt.eu-S967994AbXFHH23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967994AbXFHH23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938121AbXFHHSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:18:43 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33318 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938116AbXFHHSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:18:42 -0400
Message-Id: <20070608071552.050180000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:32 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Kazunori MIYAZAWA <kazunori@miyazawa.org>
Subject: [patch 21/32] IPSEC: Fix panic when using inter address familiy IPsec on loopback.
Content-Disposition: inline; filename=ipsec-fix-panic-when-using-inter-address-familiy-ipsec-on-loopback.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Kazunori MIYAZAWA <kazunori@miyazawa.org>

---
 net/ipv4/xfrm4_input.c       |    6 ++----
 net/ipv4/xfrm4_mode_tunnel.c |    2 ++
 net/ipv6/xfrm6_input.c       |    6 ++----
 net/ipv6/xfrm6_mode_tunnel.c |    1 +
 4 files changed, 7 insertions(+), 8 deletions(-)

--- linux-2.6.20.13.orig/net/ipv4/xfrm4_input.c
+++ linux-2.6.20.13/net/ipv4/xfrm4_input.c
@@ -136,10 +136,8 @@ int xfrm4_rcv_encap(struct sk_buff *skb,
 	nf_reset(skb);
 
 	if (decaps) {
-		if (!(skb->dev->flags&IFF_LOOPBACK)) {
-			dst_release(skb->dst);
-			skb->dst = NULL;
-		}
+		dst_release(skb->dst);
+		skb->dst = NULL;
 		netif_rx(skb);
 		return 0;
 	} else {
--- linux-2.6.20.13.orig/net/ipv4/xfrm4_mode_tunnel.c
+++ linux-2.6.20.13/net/ipv4/xfrm4_mode_tunnel.c
@@ -66,6 +66,8 @@ static int xfrm4_tunnel_output(struct xf
 	top_iph->daddr = x->id.daddr.a4;
 	top_iph->protocol = IPPROTO_IPIP;
 
+	skb->protocol = htons(ETH_P_IP);
+
 	memset(&(IPCB(skb)->opt), 0, sizeof(struct ip_options));
 	return 0;
 }
--- linux-2.6.20.13.orig/net/ipv6/xfrm6_input.c
+++ linux-2.6.20.13/net/ipv6/xfrm6_input.c
@@ -103,10 +103,8 @@ int xfrm6_rcv_spi(struct sk_buff *skb, _
 	nf_reset(skb);
 
 	if (decaps) {
-		if (!(skb->dev->flags&IFF_LOOPBACK)) {
-			dst_release(skb->dst);
-			skb->dst = NULL;
-		}
+		dst_release(skb->dst);
+		skb->dst = NULL;
 		netif_rx(skb);
 		return -1;
 	} else {
--- linux-2.6.20.13.orig/net/ipv6/xfrm6_mode_tunnel.c
+++ linux-2.6.20.13/net/ipv6/xfrm6_mode_tunnel.c
@@ -65,6 +65,7 @@ static int xfrm6_tunnel_output(struct xf
 	top_iph->hop_limit = dst_metric(dst->child, RTAX_HOPLIMIT);
 	ipv6_addr_copy(&top_iph->saddr, (struct in6_addr *)&x->props.saddr);
 	ipv6_addr_copy(&top_iph->daddr, (struct in6_addr *)&x->id.daddr);
+	skb->protocol = htons(ETH_P_IPV6);
 	return 0;
 }
 

-- 

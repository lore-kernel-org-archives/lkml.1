Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbXJQIBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbXJQIBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 04:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbXJQIA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 04:00:57 -0400
Received: from hu-out-0506.google.com ([72.14.214.224]:40110 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbXJQIAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 04:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:sender;
        b=mMkG7u8dM/x4TUIDoIfhqye3irhIojkjs4Z3xRF30Rfr1CaLk9NtrEwOuf49b18h2MQhPtUQQIDLkRxXDKSO1MqPz6zKPg8WoyxtSAQNSQ5LV8mT/yLU2seHZtBJXQk8nUgKJkg8yiQ8ra/EIi2RolhqiKtJvEpkTkJOC/cbWeA=
Message-ID: <4715C133.60505@iki.fi>
Date: Wed, 17 Oct 2007 11:00:51 +0300
From: =?ISO-8859-1?Q?Timo_Ter=E4s?= <timo.teras@iki.fi>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: davem@davemloft.net, netdev@vger.kernel.org
CC: kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org
Subject: [PATCH] ip_gre: sendto/recvfrom NBMA address
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When GRE tunnel is in NBMA mode, this patch allows an application to use
a PF_PACKET socket to:
- send a packet to specific NBMA address with sendto()
- use recvfrom() to receive packet and check which NBMA address it came from

Signed-off-by: Timo Teras <timo.teras@iki.fi>

---

This is useful for implementing NHRP over NBMA GRE tunnels.

Sent earlier to netdev list only. Resending to wider audience with
a style issue fixed.

net/ipv4/ip_gre.c |   12 +++++++++++-
1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index f151900..b1e3816 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1033,7 +1033,6 @@ static int ipgre_tunnel_change_mtu(struct net_device *dev, int new_mtu)
	return 0;
}

-#ifdef CONFIG_NET_IPGRE_BROADCAST
/* Nice toy. Unfortunately, useless in real life :-)
   It allows to construct virtual multiprotocol broadcast "LAN"
   over the Internet, provided multicast routing is tuned.
@@ -1092,10 +1091,19 @@ static int ipgre_header(struct sk_buff *skb, struct net_device *dev,
	return -t->hlen;
}

+static int ipgre_header_parse(const struct sk_buff *skb, unsigned char *haddr)
+{
+	struct iphdr *iph = (struct iphdr *) skb_mac_header(skb);
+	memcpy(haddr, &iph->saddr, 4);
+	return 4;
+}
+
static const struct header_ops ipgre_header_ops = {
	.create	= ipgre_header,
+	.parse  = ipgre_header_parse,
};

+#ifdef CONFIG_NET_IPGRE_BROADCAST
static int ipgre_open(struct net_device *dev)
{
	struct ip_tunnel *t = netdev_priv(dev);
@@ -1197,6 +1205,8 @@ static int ipgre_tunnel_init(struct net_device *dev)
			dev->stop = ipgre_close;
		}
#endif
+	} else {
+		dev->header_ops = &ipgre_header_ops;
	}

	if (!tdev && tunnel->parms.link)


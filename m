Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614Ab0AETAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0AETAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041Ab0AETAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:00:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab0AETAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:00:36 -0500
Date: Tue, 5 Jan 2010 20:57:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH] net: packet: option to only pass skb protocol
Message-ID: <20100105185732.GA30346@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sending packets with a packet socket it is often necessary to set
protocol in msg_name: otherwise the protocol field in the skb will not
be set correctly.  However, currently doing this also requires
supplying the interface index.

The following patch makes it possible to avoid supplying the interface
index by interpreting index 0 as "use device this socket is bound to".

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/packet/af_packet.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e0516a2..a81dae8 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -958,7 +958,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 					+ offsetof(struct sockaddr_ll,
 						sll_addr)))
 			goto out;
-		ifindex	= saddr->sll_ifindex;
+		ifindex	= saddr->sll_ifindex ? : po->ifindex;
 		proto	= saddr->sll_protocol;
 		addr	= saddr->sll_addr;
 	}
@@ -1074,7 +1074,7 @@ static int packet_snd(struct socket *sock,
 			goto out;
 		if (msg->msg_namelen < (saddr->sll_halen + offsetof(struct sockaddr_ll, sll_addr)))
 			goto out;
-		ifindex	= saddr->sll_ifindex;
+		ifindex	= saddr->sll_ifindex ? : po->ifindex;
 		proto	= saddr->sll_protocol;
 		addr	= saddr->sll_addr;
 	}
-- 
1.6.6.rc1.43.gf55cc

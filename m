Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453Ab0AXTnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0AXTnO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 14:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695Ab0AXTnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 14:43:13 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:49729 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab0AXTnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 14:43:13 -0500
Message-ID: <4B5CA2CA.4040307@gmail.com>
Date: Sun, 24 Jan 2010 20:43:06 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
       "David S. Miller" <davem@davemloft.net>
CC: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vlan: fix vlan_skb_recv()
References: <20100123165657.187c11e4@neptune.home>	<20100123223132.0e62d8cb@neptune.home>	<4B5C4E5E.2010507@gmail.com>	<20100124160228.366f4e72@neptune.home>	<20100124162549.2b39b222@neptune.home>	<4B5C74BF.5060604@gmail.com> <20100124201808.2bbbf0b0@neptune.home>
In-Reply-To: <20100124201808.2bbbf0b0@neptune.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 24 Jan 2010 20:43:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 24/01/2010 20:18, Bruno Prémont a écrit :
> Yep, works fine and RX stats look right as well.
> 
> So
> Reported-By: Bruno Prémont <bonbons@linux-vserver.org>
> Tested-By: Bruno Prémont <bonbons@linux-vserver.org>
> 
> Thanks,

Thanks very much Bruno, here is the official patch submission then.

[PATCH] vlan: fix vlan_skb_recv()

Bruno Prémont found commit 9793241fe92f7d930
(vlan: Precise RX stats accounting) added a regression for non
hw accelerated vlans.

[   26.390576] BUG: unable to handle kernel NULL pointer dereference at (null)
[   26.396369] IP: [<df856b89>] vlan_skb_recv+0x89/0x280 [8021q]

vlan_dev_info() was used with original device, instead of
skb->dev. Also spotted by Américo Wang.

Reported-By: Bruno Prémont <bonbons@linux-vserver.org>
Tested-By: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/8021q/vlan_dev.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index b788978..c1b92ca 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -163,7 +163,7 @@ int vlan_skb_recv(struct sk_buff *skb, struct net_device *dev,
 		goto err_unlock;
 	}
 
-	rx_stats = per_cpu_ptr(vlan_dev_info(dev)->vlan_rx_stats,
+	rx_stats = per_cpu_ptr(vlan_dev_info(skb->dev)->vlan_rx_stats,
 			       smp_processor_id());
 	rx_stats->rx_packets++;
 	rx_stats->rx_bytes += skb->len;

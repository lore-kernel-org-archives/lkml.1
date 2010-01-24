Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010Ab0AXQ0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0AXQ0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 11:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636Ab0AXQ0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 11:26:45 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:39492 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0AXQ0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 11:26:45 -0500
Message-ID: <4B5C74BF.5060604@gmail.com>
Date: Sun, 24 Jan 2010 17:26:39 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc5 regression] NULL pointer dereference in vlan_skb_recv
 - probably introduced by commit 9793241fe92f7d9303fb221e43fc598eb065f267
References: <20100123165657.187c11e4@neptune.home>	<20100123223132.0e62d8cb@neptune.home>	<4B5C4E5E.2010507@gmail.com>	<20100124160228.366f4e72@neptune.home> <20100124162549.2b39b222@neptune.home>
In-Reply-To: <20100124162549.2b39b222@neptune.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 24 Jan 2010 17:26:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 24/01/2010 16:25, Bruno Prémont a écrit :
> 
> In addition to previous mail, I'm also dumping the result of
> vlan_dev_info(dev) shows that the returned pointer is not the same
> during vlan_dev_init() and vlan_skb_recv() ...
> 

> 
> This might explain the NULL rx_stats pointer, but why do there exist
> two distinct vlan_dev_info(dev)? (unless in one case dev would be
> the physical network device and in the other case it would be vlan device?
> that is lan versus lan.658 in my case...)
> 


Ok, I believe I found the problem :)

Please try following patch, if it works I'll submit with appropriate Changelog and signatures

Thanks


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

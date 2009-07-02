Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZGBKvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZGBKvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZGBKvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:51:33 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:50577 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZGBKvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:51:32 -0400
Message-ID: <4A4C9125.8020705@gmail.com>
Date: Thu, 02 Jul 2009 12:51:17 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
References: <20090630.213927.180401151.davem@davemloft.net> <20090702075724.GA10608@elte.hu>
In-Reply-To: <20090702075724.GA10608@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 02 Jul 2009 12:51:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
>> The following changes since commit 52989765629e7d182b4f146050ebba0abf2cb0b7:
>>   Linus Torvalds (1):
>>         Merge git://git.kernel.org/.../davem/net-2.6
>>
>> are available in the git repository at:
>>
>>   master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master
> 
> Hm, something in this lot quickly wrecked networking here - see the 
> tx timeout dump below. It starts with:
> 
> [  351.004596] WARNING: at net/sched/sch_generic.c:246 dev_watchdog+0x10b/0x19c()
> [  351.011815] Hardware name: System Product Name
> [  351.016220] NETDEV WATCHDOG: eth0 (forcedeth): transmit queue 0 timed out
> 
> Config attached. Unfortunately i've got no time to do bisection 
> today.



forcedeth might have a problem, in its netif_wake_queue() logic, but
I could not see why a recent patch could make this problem visible now.

CPU0/1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
is not a new cpu either :)

forcedeth uses an internal tx_stop without appropriate barrier.

Could you try following patch ?

(random guess as I dont have much time right now)

Thank you


diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 1094d29..dc6bbde 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -2165,7 +2165,7 @@ static int nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	empty_slots = nv_get_empty_tx_slots(np);
 	if (unlikely(empty_slots <= entries)) {
 		netif_stop_queue(dev);
-		np->tx_stop = 1;
+		set_mb(np->tx_stop, 1);
 		spin_unlock_irqrestore(&np->lock, flags);
 		return NETDEV_TX_BUSY;
 	}
@@ -2286,7 +2286,7 @@ static int nv_start_xmit_optimized(struct sk_buff *skb, struct net_device *dev)
 	empty_slots = nv_get_empty_tx_slots(np);
 	if (unlikely(empty_slots <= entries)) {
 		netif_stop_queue(dev);
-		np->tx_stop = 1;
+		set_mb(np->tx_stop, 1);
 		spin_unlock_irqrestore(&np->lock, flags);
 		return NETDEV_TX_BUSY;
 	}
@@ -2564,7 +2564,7 @@ static void nv_tx_timeout(struct net_device *dev)
 	else
 		status = readl(base + NvRegIrqStatus) & NVREG_IRQSTAT_MASK;
 
-	printk(KERN_INFO "%s: Got tx_timeout. irq: %08x\n", dev->name, status);
+	printk(KERN_INFO "%s: Got tx_timeout. irq: %08x tx_stop=%d\n", dev->name, status, np->tx_stop);
 
 	{
 		int i;

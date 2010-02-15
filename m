Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0BOJgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 04:36:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab0BOJga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 04:36:30 -0500
Date: Mon, 15 Feb 2010 10:36:20 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the net tree
Message-ID: <20100215093619.GA2644@psychotron.lab.eng.brq.redhat.com>
References: <20100215143257.7af33452.sfr@canb.auug.org.au>
 <20100214.225117.242995108.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100214.225117.242995108.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mon, Feb 15, 2010 at 07:51:17AM CET, davem@davemloft.net wrote:
>From: Stephen Rothwell <sfr@canb.auug.org.au>
>Date: Mon, 15 Feb 2010 14:32:57 +1100
>
>> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
>> produced this warning:
>> 
>> net/mac80211/iface.c: In function 'ieee80211_stop':
>> net/mac80211/iface.c:416: warning: passing argument 4 of '__dev_addr_unsync' makes pointer from integer without a cast
>> include/linux/netdevice.h:1967: note: expected 'int *' but argument is of type 'int'
>> 
>> Introduced by commit 4cd24eaf0c6ee7f0242e34ee77ec899f255e66b5 ("net: use
>> netdev_mc_count and netdev_mc_empty when appropriate").
>
>I'll fix this like so:
>
>mac80211: Fix error introduced in netdev_mc_count() changes.
>
>Commit 4cd24eaf0c6ee7f0242e34ee77ec899f255e66b5
>("net: use netdev_mc_count and netdev_mc_empty when appropriate")
>added this hunk to net/mac80211/iface.c:
>
> 	__dev_addr_unsync(&local->mc_list, &local->mc_count,
>-			  &dev->mc_list, &dev->mc_count);
>+			  &dev->mc_list, dev->mc_count);
>
>which is definitely not correct, introduced a warning (reported
>by Stephen Rothwell):
>
>net/mac80211/iface.c: In function 'ieee80211_stop':
>net/mac80211/iface.c:416: warning: passing argument 4 of '__dev_addr_unsync' makes pointer from integer without a cast
>include/linux/netdevice.h:1967: note: expected 'int *' but argument is of type 'int'
>
>and is thus reverted here.

Oups :( sorry about this. Must have missed that when reviewing spatch output..

Thanks David.

Jirka
>
>Signed-off-by: David S. Miller <davem@davemloft.net>
>---
> net/mac80211/iface.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
>index f943f5f..09fff46 100644
>--- a/net/mac80211/iface.c
>+++ b/net/mac80211/iface.c
>@@ -413,7 +413,7 @@ static int ieee80211_stop(struct net_device *dev)
> 	netif_addr_lock_bh(dev);
> 	spin_lock_bh(&local->filter_lock);
> 	__dev_addr_unsync(&local->mc_list, &local->mc_count,
>-			  &dev->mc_list, dev->mc_count);
>+			  &dev->mc_list, &dev->mc_count);
> 	spin_unlock_bh(&local->filter_lock);
> 	netif_addr_unlock_bh(dev);
> 
>-- 
>1.6.6.1
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab0BOGvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:51:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44961
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754035Ab0BOGvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:51:08 -0500
Date: Sun, 14 Feb 2010 22:51:17 -0800 (PST)
Message-Id: <20100214.225117.242995108.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       jpirko@redhat.com
Subject: Re: linux-next: build warning after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100215143257.7af33452.sfr@canb.auug.org.au>
References: <20100215143257.7af33452.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 15 Feb 2010 14:32:57 +1100

> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> net/mac80211/iface.c: In function 'ieee80211_stop':
> net/mac80211/iface.c:416: warning: passing argument 4 of '__dev_addr_unsync' makes pointer from integer without a cast
> include/linux/netdevice.h:1967: note: expected 'int *' but argument is of type 'int'
> 
> Introduced by commit 4cd24eaf0c6ee7f0242e34ee77ec899f255e66b5 ("net: use
> netdev_mc_count and netdev_mc_empty when appropriate").

I'll fix this like so:

mac80211: Fix error introduced in netdev_mc_count() changes.

Commit 4cd24eaf0c6ee7f0242e34ee77ec899f255e66b5
("net: use netdev_mc_count and netdev_mc_empty when appropriate")
added this hunk to net/mac80211/iface.c:

 	__dev_addr_unsync(&local->mc_list, &local->mc_count,
-			  &dev->mc_list, &dev->mc_count);
+			  &dev->mc_list, dev->mc_count);

which is definitely not correct, introduced a warning (reported
by Stephen Rothwell):

net/mac80211/iface.c: In function 'ieee80211_stop':
net/mac80211/iface.c:416: warning: passing argument 4 of '__dev_addr_unsync' makes pointer from integer without a cast
include/linux/netdevice.h:1967: note: expected 'int *' but argument is of type 'int'

and is thus reverted here.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/mac80211/iface.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index f943f5f..09fff46 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -413,7 +413,7 @@ static int ieee80211_stop(struct net_device *dev)
 	netif_addr_lock_bh(dev);
 	spin_lock_bh(&local->filter_lock);
 	__dev_addr_unsync(&local->mc_list, &local->mc_count,
-			  &dev->mc_list, dev->mc_count);
+			  &dev->mc_list, &dev->mc_count);
 	spin_unlock_bh(&local->filter_lock);
 	netif_addr_unlock_bh(dev);
 
-- 
1.6.6.1


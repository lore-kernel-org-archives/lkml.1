Return-Path: <linux-kernel-owner+w=401wt.eu-S933552AbXGQIZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbXGQIZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbXGQIXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:23:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:63981 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765855AbXGQIXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:23:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pnM9XM9C/1Uc3AfwFrureWkeVoVpByqv9ZSon6xKH1+lEE8m4vOzWx1YVLIICtz1dD51lHAtn7/fzJi3NwOy70TXP6kgAIDWEgLC9jEgNjN+zaiuJvut4/p2SvZSDYZ4bLYx/6CGdqMILy4cPsuM0qABgFG78aEdo7jpDfsXVys=
From: Denis Cheng <crquan@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Denis Cheng <crquan@gmail.com>
Subject: [PATCH 3/4] [NET] merge dev_unicast_discard and dev_mc_discard into one
Date: Tue, 17 Jul 2007 16:23:24 +0800
Message-Id: <11846606302073-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184660618735-git-send-email-crquan@gmail.com>
References: <11846606051099-git-send-email-crquan@gmail.com>
 <1184660618735-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

this two functions can share the dev->_xmit_lock acquired context.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/core/dev.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 3ba63aa..17c9cbd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2777,23 +2777,16 @@ int dev_unicast_add(struct net_device *dev, void *addr, int alen)
 }
 EXPORT_SYMBOL(dev_unicast_add);
 
-static void dev_unicast_discard(struct net_device *dev)
+static void dev_addr_discard(struct net_device *dev)
 {
 	netif_tx_lock_bh(dev);
+
 	__dev_addr_discard(&dev->uc_list);
 	dev->uc_count = 0;
-	netif_tx_unlock_bh(dev);
-}
 
-/*
- *	Discard multicast list when a device is downed
- */
-
-static void dev_mc_discard(struct net_device *dev)
-{
-	netif_tx_lock_bh(dev);
 	__dev_addr_discard(&dev->mc_list);
 	dev->mc_count = 0;
+
 	netif_tx_unlock_bh(dev);
 }
 
@@ -3751,8 +3744,7 @@ void unregister_netdevice(struct net_device *dev)
 	/*
 	 *	Flush the unicast and multicast chains
 	 */
-	dev_unicast_discard(dev);
-	dev_mc_discard(dev);
+	dev_addr_discard(dev);
 
 	if (dev->uninit)
 		dev->uninit(dev);
-- 
1.5.2.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S933351AbXGQIXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351AbXGQIXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbXGQIX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:23:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:63981 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbXGQIXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=at8ia22SbxBjp7dldOU1FMxOQRyMhfWxLu7nrq0N8AMVd5DiJVgDZA+M68No+MwWWvQmKyi6sRGWAJHEjYI7PpuNTN5wfGnTfdFeybE4f+fDTm047adrR9f/DIXiTuTffzpchznkm/IFQ/FASDEJyae1plzxKnXhC3HN9h3HH0E=
From: Denis Cheng <crquan@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Denis Cheng <crquan@gmail.com>
Subject: [PATCH 1/4] [NET] move dev_mc_discard from dev_mcast.c to dev.c
Date: Tue, 17 Jul 2007 16:23:22 +0800
Message-Id: <11846606051099-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

because this function is only called by unregister_netdevice,
this moving could make this non-global function static,
and also remove a function declaration in netdevice.h

another way, the sequential call to dev_unicast_discard and then
dev_mc_discard in unregister_netdevice have a similar mechanism that:
(netif_tx_lock_bh / __dev_addr_discard / netif_tx_unlock_bh),
they should merged into one to eliminate duplicates in acquiring and
releasing the dev->_xmit_lock, this would be done in my following patch.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 include/linux/netdevice.h |    1 -
 net/core/dev.c            |   12 ++++++++++++
 net/core/dev_mcast.c      |   12 ------------
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 322b5ea..895cec2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1108,7 +1108,6 @@ extern int 		dev_mc_delete(struct net_device *dev, void *addr, int alen, int all
 extern int		dev_mc_add(struct net_device *dev, void *addr, int alen, int newonly);
 extern int		dev_mc_sync(struct net_device *to, struct net_device *from);
 extern void		dev_mc_unsync(struct net_device *to, struct net_device *from);
-extern void		dev_mc_discard(struct net_device *dev);
 extern int 		__dev_addr_delete(struct dev_addr_list **list, int *count, void *addr, int alen, int all);
 extern int		__dev_addr_add(struct dev_addr_list **list, int *count, void *addr, int alen, int newonly);
 extern void		__dev_addr_discard(struct dev_addr_list **list);
diff --git a/net/core/dev.c b/net/core/dev.c
index 13a0d9f..b17f1bf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2785,6 +2785,18 @@ static void dev_unicast_discard(struct net_device *dev)
 	netif_tx_unlock_bh(dev);
 }
 
+/*
+ *	Discard multicast list when a device is downed
+ */
+
+static void dev_mc_discard(struct net_device *dev)
+{
+	netif_tx_lock_bh(dev);
+	__dev_addr_discard(&dev->mc_list);
+	dev->mc_count = 0;
+	netif_tx_unlock_bh(dev);
+}
+
 unsigned dev_get_flags(const struct net_device *dev)
 {
 	unsigned flags;
diff --git a/net/core/dev_mcast.c b/net/core/dev_mcast.c
index 235a2a8..99aece1 100644
--- a/net/core/dev_mcast.c
+++ b/net/core/dev_mcast.c
@@ -177,18 +177,6 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
 }
 EXPORT_SYMBOL(dev_mc_unsync);
 
-/*
- *	Discard multicast list when a device is downed
- */
-
-void dev_mc_discard(struct net_device *dev)
-{
-	netif_tx_lock_bh(dev);
-	__dev_addr_discard(&dev->mc_list);
-	dev->mc_count = 0;
-	netif_tx_unlock_bh(dev);
-}
-
 #ifdef CONFIG_PROC_FS
 static void *dev_mc_seq_start(struct seq_file *seq, loff_t *pos)
 {
-- 
1.5.2.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848Ab0BQBNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 20:13:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:37714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933749Ab0BQBNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 20:13:07 -0500
Message-ID: <4B7B4484.4060909@kernel.org>
Date: Wed, 17 Feb 2010 10:21:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next 2/2] percpu: add __percpu sparse annotations to net
 drivers
References: <4B7B445A.1080108@kernel.org>
In-Reply-To: <4B7B445A.1080108@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Feb 2010 01:12:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __percpu sparse annotations to net drivers.

These annotations are to make sparse consider percpu variables to be
in a different address space and warn if accessed without going
through percpu accessors.  This patch doesn't affect normal builds.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/chelsio/sge.c  |    2 +-
 drivers/net/loopback.c     |   16 +++++++++-------
 drivers/net/veth.c         |    4 ++--
 include/linux/if_macvlan.h |    2 +-
 4 files changed, 13 insertions(+), 11 deletions(-)

Index: net-next/drivers/net/chelsio/sge.c
===================================================================
--- net-next.orig/drivers/net/chelsio/sge.c
+++ net-next/drivers/net/chelsio/sge.c
@@ -267,7 +267,7 @@ struct sge {
 	struct sk_buff	*espibug_skb[MAX_NPORTS];
 	u32		sge_control;	/* shadow value of sge control reg */
 	struct sge_intr_counts stats;
-	struct sge_port_stats *port_stats[MAX_NPORTS];
+	struct sge_port_stats __percpu *port_stats[MAX_NPORTS];
 	struct sched	*tx_sched;
 	struct cmdQ cmdQ[SGE_CMDQ_N] ____cacheline_aligned_in_smp;
 };
Index: net-next/drivers/net/loopback.c
===================================================================
--- net-next.orig/drivers/net/loopback.c
+++ net-next/drivers/net/loopback.c
@@ -72,7 +72,8 @@ struct pcpu_lstats {
 static netdev_tx_t loopback_xmit(struct sk_buff *skb,
 				 struct net_device *dev)
 {
-	struct pcpu_lstats *pcpu_lstats, *lb_stats;
+	struct pcpu_lstats __percpu *pcpu_lstats;
+	struct pcpu_lstats *lb_stats;
 	int len;
 
 	skb_orphan(skb);
@@ -80,7 +81,7 @@ static netdev_tx_t loopback_xmit(struct
 	skb->protocol = eth_type_trans(skb, dev);
 
 	/* it's OK to use per_cpu_ptr() because BHs are off */
-	pcpu_lstats = dev->ml_priv;
+	pcpu_lstats = (void __percpu __force *)dev->ml_priv;
 	lb_stats = this_cpu_ptr(pcpu_lstats);
 
 	len = skb->len;
@@ -95,14 +96,14 @@ static netdev_tx_t loopback_xmit(struct
 
 static struct net_device_stats *loopback_get_stats(struct net_device *dev)
 {
-	const struct pcpu_lstats *pcpu_lstats;
+	const struct pcpu_lstats __percpu *pcpu_lstats;
 	struct net_device_stats *stats = &dev->stats;
 	unsigned long bytes = 0;
 	unsigned long packets = 0;
 	unsigned long drops = 0;
 	int i;
 
-	pcpu_lstats = dev->ml_priv;
+	pcpu_lstats = (void __percpu __force *)dev->ml_priv;
 	for_each_possible_cpu(i) {
 		const struct pcpu_lstats *lb_stats;
 
@@ -135,19 +136,20 @@ static const struct ethtool_ops loopback
 
 static int loopback_dev_init(struct net_device *dev)
 {
-	struct pcpu_lstats *lstats;
+	struct pcpu_lstats __percpu *lstats;
 
 	lstats = alloc_percpu(struct pcpu_lstats);
 	if (!lstats)
 		return -ENOMEM;
 
-	dev->ml_priv = lstats;
+	dev->ml_priv = (void __force *)lstats;
 	return 0;
 }
 
 static void loopback_dev_free(struct net_device *dev)
 {
-	struct pcpu_lstats *lstats = dev->ml_priv;
+	struct pcpu_lstats __percpu *lstats =
+		(void __percpu __force *)dev->ml_priv;
 
 	free_percpu(lstats);
 	free_netdev(dev);
Index: net-next/drivers/net/veth.c
===================================================================
--- net-next.orig/drivers/net/veth.c
+++ net-next/drivers/net/veth.c
@@ -34,7 +34,7 @@ struct veth_net_stats {
 
 struct veth_priv {
 	struct net_device *peer;
-	struct veth_net_stats *stats;
+	struct veth_net_stats __percpu *stats;
 	unsigned ip_summed;
 };
 
@@ -263,7 +263,7 @@ static int veth_change_mtu(struct net_de
 
 static int veth_dev_init(struct net_device *dev)
 {
-	struct veth_net_stats *stats;
+	struct veth_net_stats __percpu *stats;
 	struct veth_priv *priv;
 
 	stats = alloc_percpu(struct veth_net_stats);
Index: net-next/include/linux/if_macvlan.h
===================================================================
--- net-next.orig/include/linux/if_macvlan.h
+++ net-next/include/linux/if_macvlan.h
@@ -30,7 +30,7 @@ struct macvlan_dev {
 	struct hlist_node	hlist;
 	struct macvlan_port	*port;
 	struct net_device	*lowerdev;
-	struct macvlan_rx_stats *rx_stats;
+	struct macvlan_rx_stats __percpu *rx_stats;
 	enum macvlan_mode	mode;
 	int (*receive)(struct sk_buff *skb);
 	int (*forward)(struct net_device *dev, struct sk_buff *skb);

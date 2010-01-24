Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748Ab0AXP0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab0AXP0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 10:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277Ab0AXP0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 10:26:15 -0500
Received: from ppp-156-220.adsl.restena.lu ([158.64.156.220]:43477 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab0AXP0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 10:26:14 -0500
Date: Sun, 24 Jan 2010 16:25:49 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc5 regression] NULL pointer dereference in
 vlan_skb_recv - probably introduced by commit
 9793241fe92f7d9303fb221e43fc598eb065f267
Message-ID: <20100124162549.2b39b222@neptune.home>
In-Reply-To: <20100124160228.366f4e72@neptune.home>
References: <20100123165657.187c11e4@neptune.home>
	<20100123223132.0e62d8cb@neptune.home>
	<4B5C4E5E.2010507@gmail.com>
	<20100124160228.366f4e72@neptune.home>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 January 2010 Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le 23/01/2010 22:31, Bruno Prémont a écrit :
> >> Above part of code did change between 2.6.32 and 2.6.33-rc5 with
> >> commit 9793241fe92f7d9303fb221e43fc598eb065f267 (vlan: Precise RX
> >> stats accounting)
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9793241fe92f7d9303fb221e43fc598eb065f267
> > 
> > Reverting just that commit gets the system running correctly.
> > 
> > Bruno
> 
> I have no idea how this patch can break vlan networking.
> 
> Your disassembly and .config seems to show your machine is not SMP

Exact

> Maybe something is broken on UP and alloc_percpu() ?

Apparently not, see below and previous mail

> Could you add a debug in vlan_dev_init()

In addition to previous mail, I'm also dumping the result of
vlan_dev_info(dev) shows that the returned pointer is not the same
during vlan_dev_init() and vlan_skb_recv() ...

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index b788978..f370ce1 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -165,8 +165,11 @@ int vlan_skb_recv(struct sk_buff *skb, struct net_device *dev,
 
        rx_stats = per_cpu_ptr(vlan_dev_info(dev)->vlan_rx_stats,
                               smp_processor_id());
-       rx_stats->rx_packets++;
-       rx_stats->rx_bytes += skb->len;
+       if (rx_stats) {
+               rx_stats->rx_packets++;
+               rx_stats->rx_bytes += skb->len;
+       } else
+               pr_err("vlan_skb_recv() %p->rx_stats=%p -> %p\n", vlan_dev_info(dev), vlan_dev_info(dev)->vlan_rx_stats, rx_stats);
 
        skb_pull_rcsum(skb, VLAN_HLEN);
 
@@ -738,6 +741,7 @@ static int vlan_dev_init(struct net_device *dev)
        vlan_dev_info(dev)->vlan_rx_stats = alloc_percpu(struct vlan_rx_stats);
        if (!vlan_dev_info(dev)->vlan_rx_stats)
                return -ENOMEM;
+       pr_err("vlan_dev_init() %p->rx_stats=%p\n", vlan_dev_info(dev), vlan_dev_info(dev)->vlan_rx_stats);
 
        return 0;
 }

This slightly adjusted change produces the following output:
...
[ 1192.257978] ADDRCONF(NETDEV_UP): lan: link is not ready
[ 1192.399059] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[ 1192.399063] All bugs added by David S. Miller <davem@redhat.com>
[ 1192.404475] vlan_dev_init() da4ff360->rx_stats=dbd5a340
                               ^^^^^^^^
[ 1196.000225] b44: lan: Link is up at 100 Mbps, full duplex.
[ 1196.000234] b44: lan: Flow control is off for TX and off for RX.
[ 1196.000379] ADDRCONF(NETDEV_CHANGE): lan: link becomes ready
[ 1203.160226] lan.658: no IPv6 routers present
[ 1212.760561] vlan_skb_recv() ddbb8b60->rx_stats=(null) -> (null)
                               ^^^^^^^^
[ 1212.794961] vlan_skb_recv() ddbb8b60->rx_stats=(null) -> (null)
[ 1219.247018] svc: failed to register lockdv1 RPC service (errno 97).
[ 1219.249919] mount.nfs used greatest stack depth: 1008 bytes left
[ 1221.388602] vlan_skb_recv() ddbb8b60->rx_stats=(null) -> (null)
[ 1221.388690] vlan_skb_recv() ddbb8b60->rx_stats=(null) -> (null)
[ 1278.793350] vlan_skb_recv() ddbb8b60->rx_stats=(null) -> (null)
[ 1283.750363] vlan_skb_recv() ddbb8b60->rx_stats=(null) -> (null)
...

This might explain the NULL rx_stats pointer, but why do there exist
two distinct vlan_dev_info(dev)? (unless in one case dev would be
the physical network device and in the other case it would be vlan device?
that is lan versus lan.658 in my case...)

Thanks,
Bruno

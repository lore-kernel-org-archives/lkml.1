Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668Ab0AXPLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab0AXPLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 10:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386Ab0AXPLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 10:11:46 -0500
Received: from ppp-156-220.adsl.restena.lu ([158.64.156.220]:36247 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab0AXPLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 10:11:45 -0500
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jan 2010 10:11:45 EST
Date: Sun, 24 Jan 2010 16:02:28 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc5 regression] NULL pointer dereference in
 vlan_skb_recv - probably introduced by commit
 9793241fe92f7d9303fb221e43fc598eb065f267
Message-ID: <20100124160228.366f4e72@neptune.home>
In-Reply-To: <4B5C4E5E.2010507@gmail.com>
References: <20100123165657.187c11e4@neptune.home>
	<20100123223132.0e62d8cb@neptune.home>
	<4B5C4E5E.2010507@gmail.com>
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
> 
> Maybe something is broken on UP and alloc_percpu() ?
> 
> Could you add a debug in vlan_dev_init()
> 
> 
>  	vlan_dev_info(dev)->vlan_rx_stats = alloc_percpu(struct
> vlan_rx_stats); if (!vlan_dev_info(dev)->vlan_rx_stats)
>  	return -ENOMEM;
> +	pr_err("vlan_dev_init() rx_stats=%p\n",
> vlan_dev_info(dev)->vlan_rx_stats);
> 
> 
> This make sure vlan_dev_init() is called and percpu allocation is
> properly done.
> 
> Thanks

Readding your "precise RX stats" commit with following additional changes I get
(first hunk to avoid crash):

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index b788978..9216a98 100644
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
+               pr_err("vlan_skb_recv() rx_stats=%p -> %p\n",
  vlan_dev_info(dev)->vlan_rx_stats, rx_stats); 
        skb_pull_rcsum(skb, VLAN_HLEN);
 
@@ -738,6 +741,7 @@ static int vlan_dev_init(struct net_device *dev)
        vlan_dev_info(dev)->vlan_rx_stats = alloc_percpu(struct
  vlan_rx_stats); if (!vlan_dev_info(dev)->vlan_rx_stats)
                return -ENOMEM;
+       pr_err("vlan_dev_init() rx_stats=%p\n",
  vlan_dev_info(dev)->vlan_rx_stats); 
        return 0;
 }


...
[   13.877610] Ending clean XFS mount for filesystem: loop0
[   15.795601] Adding 1004020k swap on /dev/sda5.  Priority:-1 extents:1 across:1004020k 
[   16.612143] ADDRCONF(NETDEV_UP): lan: link is not ready
[   16.851846] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   16.851856] All bugs added by David S. Miller <davem@redhat.com>
[   16.878049] vlan_dev_init() rx_stats=dceae290
[   20.040395] b44: lan: Link is up at 100 Mbps, full duplex.
[   20.040404] b44: lan: Flow control is off for TX and off for RX.
[   20.040535] ADDRCONF(NETDEV_CHANGE): lan: link becomes ready
[   25.019941] RPC: Registered udp transport module.
[   25.019950] RPC: Registered tcp transport module.
[   25.019956] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   25.382400] svc: failed to register lockdv1 RPC service (errno 97).
[   25.385278] mount.nfs used greatest stack depth: 1012 bytes left
[   25.872973] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   26.740561] vlan_skb_recv() rx_stats=(null) -> (null)
[   26.775071] vlan_skb_recv() rx_stats=(null) -> (null)
[   27.050223] lan.658: no IPv6 routers present
[   58.357052] vlan_skb_recv() rx_stats=(null) -> (null)
[   63.350334] vlan_skb_recv() rx_stats=(null) -> (null)
[   91.767589] vlan_skb_recv() rx_stats=(null) -> (null)
[   91.932344] vlan_skb_recv() rx_stats=(null) -> (null)
[   91.933053] vlan_skb_recv() rx_stats=(null) -> (null)
[   91.998628] vlan_skb_recv() rx_stats=(null) -> (null)
[   92.002752] vlan_skb_recv() rx_stats=(null) -> (null)
[   92.007918] vlan_skb_recv() rx_stats=(null) -> (null)
[   92.009644] vlan_skb_recv() rx_stats=(null) -> (null)
[   92.016789] vlan_skb_recv() rx_stats=(null) -> (null)
[   92.018520] vlan_skb_recv() rx_stats=(null) -> (null)
[   92.041737] vlan_skb_recv() rx_stats=(null) -> (null)
...

So during vlan_dev_init() rx_stats is properly initialized, but when
packets reach the vlan dev later on exactly that same pointer is NULL...

So question is, who did reset vlan_dev_info(dev)->vlan_rx_stats to NULL?

Thanks,
Bruno

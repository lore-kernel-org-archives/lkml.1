Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbXHRFb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbXHRFb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 01:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbXHRFbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 01:31:20 -0400
Received: from 1wt.eu ([62.212.114.60]:1730 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbXHRFbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 01:31:19 -0400
Date: Sat, 18 Aug 2007 07:23:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: K Naru <squat_rack@yahoo.com>
Cc: rl@hellgate.ch, linux-kernel@vger.kernel.org
Subject: Re: [Patch 2.6.22.2 ] : drivers/net/via-rhine.c:   Offload checksum handling to VT6105M
Message-ID: <20070818052351.GN6002@1wt.eu>
References: <534451.72377.qm@web53807.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534451.72377.qm@web53807.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 11:34:37AM -0700, K Naru wrote:
> From: Kim Naru (squat_rack@yahoo.com)
> 
> Added support to offload TCP/UDP/IP checksum to the
> VIA Technologies VT6105M chip.
> Firstly, let the stack know this chip is capable of
> doing its own checksum(IPV4 only).
> Secondly offload checksum to VT6105M, if necessary. 
> 
> 
> Verbose Mode:
> 
> #1. Define 3 bits(18,19,20) in Transmit Descriptor 1
> of chip, which affect checksum processing.
> The prefix(TDES1) for the 3 variables is the short
> name for Transmit Descriptior 1.
> #2. In rhine_init_one(), if pci_rev >=  VT6105M then
> set  NETIF_F_IP_CSUM(see skbuff.h for details).
> #3. In rhine_start_tx() if NETIF_F_IP_CSUM is set AND
> the stack requires a checksum then
> set either bit 19(UDP),20(TCP) AND bit 18(IP).
> 
> Note : The numbered items above(i.e.#1,#2,#3) denote
> pseudo code.
> 
> This patch was developed and tested on Imedia
> linux-2.6.20 under a PC-Engines Alix System board
> (www.pcengines.ch/alix.htm). It was tested(compilation
> only) on linux-2.6.22.2. The minor code change between
> 2.6.20 and 2.6.22 is the use of ip_hdr() in 2.26.22.
> 
> In 2.6.20 :
>                 struct iphdr *ip = skb->nh.iph;
> In 2.6.22 :
>                 const struct iphdr *ip = ip_hdr(skb);
> 
> Testing:
> 
> 
> ttcp,netperf ftp and top  where used. There appears to
> be a small CPU utilization gain. Throughput results 
> where more inconclusive.
> 
> The data sheet used to get information is 'VT6105M
> Data Sheet, Revision 1.63  June21,2006'.
> 
> Signed-off-by: Kim Naru (squat_rack@yahoo.com)
> 
> ---
> 
> 
> --- drivers/net/via-rhine.c     2007-08-17
> 00:24:33.000000000 -0700
> +++ drivers/net/via-rhine.c.orig        2007-08-15
> 05:03:20.000000000 -0700
> @@ -95,8 +95,6 @@ static const int
> multicast_filter_limit 
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>
>  #include <linux/skbuff.h>
> -#include <linux/in.h>
> -#include <linux/ip.h>
>  #include <linux/init.h>
>  #include <linux/delay.h>
>  #include <linux/mii.h>
> @@ -345,9 +343,6 @@ struct tx_desc {
>  
>  /* Initial value for tx_desc.desc_length, Buffer size
> goes to bits 0-10 */
>  #define TXDESC         0x00e08000
> -#define TDES1_TCPCK    0x00100000  /* Bit 20,
> Transmit Desc 1 (VT6105M Data Sheet 1.63) */
> -#define TDES1_UDPCK    0x00080000  /* Bit 19,
> Transmit Desc 1 (VT6105M Data Sheet 1.63) */     
> -#define TDES1_IPCK     0x00040000  /* Bit 18,
> Transmit Desc 1 (VT6105M Data Sheet 1.63) */     
>  
>  enum rx_status_bits {
>         RxOK=0x8000, RxWholePkt=0x0300, RxErr=0x008F
> @@ -793,9 +788,6 @@ static int __devinit
> rhine_init_one(stru
>         if (rp->quirks & rqRhineI)
>                 dev->features |=
> NETIF_F_SG|NETIF_F_HW_CSUM;
>  
> -       if (pci_rev >=  VT6105M)    
> -               dev->features |= NETIF_F_IP_CSUM;   /*
> tell stack chip does checksum */
> -
>         /* dev->name not defined before
> register_netdev()! */
>         rc = register_netdev(dev);
>         if (rc)
> @@ -1270,20 +1262,6 @@ static int
> rhine_start_tx(struct sk_buff
>  
>         /* lock eth irq */
>         spin_lock_irq(&rp->lock);
> -
> -       if ((dev->features & NETIF_F_IP_CSUM) &&
> (skb->ip_summed == CHECKSUM_PARTIAL)) { 
> -               const struct iphdr *ip = ip_hdr(skb);
> -
> -               /* offload checksum to chip. */
> -
> -               if (ip->protocol == IPPROTO_TCP)
> -                       rp->tx_ring[entry].desc_length
> |= TDES1_TCPCK;
> -               else if (ip->protocol == IPPROTO_UDP)
> -                       rp->tx_ring[entry].desc_length
> |=  TDES1_UDPCK;
> -               rp->tx_ring[entry].desc_length |= 
> TDES1_IPCK;
> -
> -       }
> -
>         wmb();
>         rp->tx_ring[entry].tx_status =
> cpu_to_le32(DescOwn);
>         wmb();


your patch was reversed! Also it's not at the proper level.
You should proceed this way :

   $  diff -u ./drivers/net/via-rhine.c{.orig,}

Note the "./" which makes your patch work both at -p0 and -p1

Willy


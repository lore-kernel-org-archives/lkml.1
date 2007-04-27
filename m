Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbXD0O2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbXD0O2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbXD0O2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:28:46 -0400
Received: from omta01sl.mx.bigpond.com ([144.140.92.153]:16488 "EHLO
	omta01sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbXD0O2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:28:44 -0400
Message-ID: <4632088C.8000509@bigpond.net.au>
Date: Sat, 28 Apr 2007 00:28:28 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, jgarzik@pobox.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux-2.6.21 hangs during post boot initialization phase
References: <463166C2.6060106@bigpond.net.au> <alpine.LFD.0.98.0704262035410.9964@woody.linux-foundation.org> <46319297.905@bigpond.net.au> <20070427122247.GA19017@hmsreliant.homelinux.net>
In-Reply-To: <20070427122247.GA19017@hmsreliant.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta01sl.mx.bigpond.com from [138.130.231.4] using ID pwil3058@bigpond.net.au at Fri, 27 Apr 2007 14:28:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> On Fri, Apr 27, 2007 at 04:05:11PM +1000, Peter Williams wrote:
>> Linus Torvalds wrote:
>>> On Fri, 27 Apr 2007, Peter Williams wrote:
>>>> The 2.6.21 kernel is hanging during the post boot phase where various 
>>>> daemons
>>>> are being started (not always the same daemon unfortunately).
>>>>
>>>> This problem was not present in 2.6.21-rc7 and there is no oops or other
>>>> unusual output in the system log at the time the hang occurs.
>>> Can you use "git bisect" to narrow it down a bit more? It's only 125 
>>> commits, so bisecting even just three or four kernels will narrow it down 
>>> to a handful.
>> As the changes became, smaller the builds became quicker :-) and after 7 
>> iterations we have:
>>
>>
>> author	Neil Horman <nhorman@tuxdriver.com>
>> 	Fri, 20 Apr 2007 13:54:58 +0000 (09:54 -0400)
>> committer	Jeff Garzik <jeff@garzik.org>
>> 	Tue, 24 Apr 2007 16:43:07 +0000 (12:43 -0400)
>> commit	b748d9e3b80dc7e6ce6bf7399f57964b99a4104c
>> tree	887909e1f735bb444ef0e3e370f34401fa6eee02	tree | snapshot
>> parent	d91c088b39e3c66d309938de858775bb90fd1ead	commit | diff
>> sis900: Allocate rx replacement buffer before rx operation
>>
>> The sis900 driver appears to have a bug in which the receive routine
>> passes the skbuff holding the received frame to the network stack before
>> refilling the buffer in the rx ring.  If a new skbuff cannot be 
>> allocated, the
>> driver simply leaves a hole in the rx ring, which causes the driver to stop
>> receiving frames and become non-recoverable without an rmmod/insmod 
>> according to
>> reporters.  This patch reverses that order, attempting to allocate a 
>> replacement
>> buffer first, and receiving the new frame only if one can be allocated. 
>>  If no
>> skbuff can be allocated, the current skbuf in the rx ring is recycled, 
>> dropping
>> the current frame, but keeping the NIC operational.
>>
>> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
>> Signed-off-by: Jeff Garzik <jeff@garzik.org>
>>
>> Peter
>> -- 
>> Peter Williams                                   pwil3058@bigpond.net.au
>>
>> "Learning, n. The kind of ignorance distinguishing the studious."
>>  -- Ambrose Bierce
> 
> This was reported to me last night, and I've posted a patch to fix it, its
> available here:
> http://marc.info/?l=linux-netdev&m=117761259222165&w=2
> 
> It applies on top of the previous patch, and should fix your problem.
> 
> Here's a copy of the patch
> 
> Thanks & Regards
> Neil
> 
> 
> diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
> index a6a0f09..7e44939 100644
> --- a/drivers/net/sis900.c
> +++ b/drivers/net/sis900.c
> @@ -1754,6 +1754,7 @@ static int sis900_rx(struct net_device *net_dev)
>  			sis_priv->rx_ring[entry].cmdsts = RX_BUF_SIZE;
>  		} else {
>  			struct sk_buff * skb;
> +			struct sk_buff * rx_skb;
>  
>  			pci_unmap_single(sis_priv->pci_dev,
>  				sis_priv->rx_ring[entry].bufptr, RX_BUF_SIZE,
> @@ -1787,10 +1788,10 @@ static int sis900_rx(struct net_device *net_dev)
>  			}
>  
>  			/* give the socket buffer to upper layers */
> -			skb = sis_priv->rx_skbuff[entry];
> -			skb_put(skb, rx_size);
> -			skb->protocol = eth_type_trans(skb, net_dev);
> -			netif_rx(skb);
> +			rx_skb = sis_priv->rx_skbuff[entry];
> +			skb_put(rx_skb, rx_size);
> +			skb->protocol = eth_type_trans(rx_skb, net_dev);
> +			netif_rx(rx_skb);
>  
>  			/* some network statistics */
>  			if ((rx_status & BCAST) == MCAST)

This patch fixes the problem for me.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

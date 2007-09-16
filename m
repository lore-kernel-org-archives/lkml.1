Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbXIPHvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbXIPHvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 03:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbXIPHvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 03:51:04 -0400
Received: from fwil.voltaire.com ([193.47.165.2]:44658 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751336AbXIPHvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 03:51:01 -0400
X-Greylist: delayed 984 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Sep 2007 03:51:00 EDT
Message-ID: <46ECDC7F.2070805@voltaire.com>
Date: Sun, 16 Sep 2007 10:34:23 +0300
From: Or Gerlitz <ogerlitz@voltaire.com>
User-Agent: Thunderbird 1.4.1 (Windows/20051006)
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>
CC: Steve Wise <swise@opengridcomputing.com>, rdreier@cisco.com,
       sean.hefty@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH] RDMA/CMA: Use neigh_event_send() to initiate
 neighbour discovery.
References: <20070912100025.3190.89259.stgit@dell3.ogc.int>
In-Reply-To: <20070912100025.3190.89259.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Sep 2007 07:34:32.0542 (UTC) FILETIME=[05F727E0:01C7F834]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> RDMA/CMA: Use neigh_event_send() to initiate neighbour discovery.
> 
> Calling arp_send() to initiate neighbour discovery (ND) doesn't do the
> full ND protocol.  Namely, it doesn't handle retransmitting the arp
> request if it is dropped. The function neigh_event_send() does all this.
> Without doing full ND, rdma address resolution fails in the presence of
> dropped arp bcast packets.

Jay,

Is there a way to deploy something similar for the gratuitous arp being 
sent by the bonding driver at bond_arp_send()?

We have seen rare situations where the skb was dropped by the stack and 
hence bonding fail-over was detected by the remote peer only when its 
neighboring subsystem probe failures dictated that a new arp must be issued.

Or.
> 
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
> 
>  drivers/infiniband/core/addr.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
> index c5c33d3..5381c80 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -161,8 +161,7 @@ static void addr_send_arp(struct sockadd
>  	if (ip_route_output_key(&rt, &fl))
>  		return;
>  
> -	arp_send(ARPOP_REQUEST, ETH_P_ARP, rt->rt_gateway, rt->idev->dev,
> -		 rt->rt_src, NULL, rt->idev->dev->dev_addr, NULL);
> +	neigh_event_send(rt->u.dst.neighbour, NULL);
>  	ip_rt_put(rt);
>  }


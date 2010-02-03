Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0BCEkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 23:40:01 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52509 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab0BCEj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 23:39:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z6+0N3X/bzbchpa7jIsc8YOI/6n+wx1qcQEmJfeVm05SZS8kf7d2lgESQJAzDdHn/+
         w/wq7l5uCPvE/NZRjRglVxhNbTA8bH6v9OTbuSFxAhUPtcULHtNyeuDRFlkROVhtpBM9
         bjFaA95ODrm1qFjEWs8AQZhh8vrTVtTIJLaJM=
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed
 port numbers
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
       netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
       linux-sctp@vger.kernel.org, David Miller <davem@davemloft.net>
In-Reply-To: <20100203043332.3817.27932.sendpatchset@localhost.localdomain>
References: <20100203043332.3817.27932.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 05:39:53 +0100
Message-ID: <1265171993.3274.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 02 février 2010 à 23:30 -0500, Amerigo Wang a écrit :
> This patch introduces /proc/sys/net/ipv4/ip_local_reserved_ports,
> it can be used like ip_local_port_range, but this is used to
> reserve ports for third-party applications which use fixed
> port numbers within ip_local_port_range.
> 
> This only affects the applications which call socket functions
> like bind(2) with port number 0, to prevent the kernel getting the ports
> within the specified range for them. For applications which use fixed
> port number, it will have no effects.
> 
> Any comments are welcome.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: David Miller <davem@davemloft.net>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>

>  		.procname	= "igmp_max_memberships",
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index f0126fd..83045ca 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -210,8 +210,11 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
>  		inet_get_local_port_range(&low, &high);
>  		remaining = (high - low) + 1;
>  
> +again:
>  		rand = net_random();
>  		first = (((u64)rand * remaining) >> 32) + low;
> +		if (inet_is_reserved_local_port(first))
> +			goto again;
>  		/*
>  		 * force rand to be an odd multiple of UDP_HTABLE_SIZE
>  		 */

Unless I misread the patch, you are checking only the 'first' port that
udp_lib_get_port() chose.

I would use inet_get_local_reserved_ports(&min_res, &max_res);
and check every port that we chose in the loop to avoid it if necessary.



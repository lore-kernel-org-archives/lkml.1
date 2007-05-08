Return-Path: <linux-kernel-owner+w=401wt.eu-S966965AbXEHNRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966965AbXEHNRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934686AbXEHNRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:17:20 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:46372 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934588AbXEHNRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:17:19 -0400
Date: Tue, 8 May 2007 09:17:16 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] lguest: two net bugfixes
In-Reply-To: <1178623374.7286.10.camel@localhost.localdomain>
Message-ID: <Line.LNX.4.64.0705080916560.23450@d.namei>
References: <1178623374.7286.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Rusty Russell wrote:

> 1) Bridging via host is broken: we need to set "promisc" bit in MAC
>    address published by the host so the guest sends us everything.
>    Thanks James Morris for the report (I don't use bridging).
> 
> 2) Lguest network device uses 0 to mean "noone at this slot".  It used to
>    use 0xFF, and one spot was missed.  Minor: it just means we'll have a
>    useless extra transmit for broadcast packets.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: James Morris <jmorris@namei.org>



> ---
>  Documentation/lguest/lguest.c |    2 ++
>  drivers/net/lguest_net.c      |    2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff -r 999a9058a151 Documentation/lguest/lguest.c
> --- a/Documentation/lguest/lguest.c	Tue May 08 19:49:33 2007 +1000
> +++ b/Documentation/lguest/lguest.c	Tue May 08 21:04:51 2007 +1000
> @@ -860,6 +860,10 @@ static void setup_tun_net(const char *ar
>  
>  	/* We are peer 0, ie. first slot. */
>  	configure_device(ipfd, ifr.ifr_name, ip, dev->mem);
> +
> +	/* Set "promisc" bit: we want every single packet. */
> +	*((u8 *)dev->mem) |= 0x1;
> +
>  	close(ipfd);
>  
>  	verbose("device %p: tun net %u.%u.%u.%u\n",
> diff -r 999a9058a151 drivers/net/lguest_net.c
> --- a/drivers/net/lguest_net.c	Tue May 08 19:49:33 2007 +1000
> +++ b/drivers/net/lguest_net.c	Tue May 08 21:03:47 2007 +1000
> @@ -249,7 +249,7 @@ static int lguestnet_close(struct net_de
>  	struct lguestnet_info *info = dev->priv;
>  
>  	/* Clear all trace: others might deliver packets, we'll ignore it. */
> -	memset(&info->peer[info->me], 0xFF, sizeof(info->peer[info->me]));
> +	memset(&info->peer[info->me], 0, sizeof(info->peer[info->me]));
>  
>  	/* Deregister sg lists. */
>  	hcall(LHCALL_BIND_DMA, peer_key(info, info->me), __pa(info->dma), 0);
> 
> 
> 

-- 
James Morris
<jmorris@namei.org>

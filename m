Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYL2VIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYL2VIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYL2VID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:08:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356AbYL2VIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:08:00 -0500
Date: Mon, 29 Dec 2008 13:07:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Roland Dreier <rdreier@cisco.com>
cc: Aleksey Senin <alekseys@voltaire.com>,
       "general@lists.openfabrics.org" <general@lists.openfabrics.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: origin tree build failure
In-Reply-To: <adaljtyu45d.fsf@cisco.com>
Message-ID: <alpine.LFD.2.00.0812291304471.3082@localhost.localdomain>
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au> <ada4p0nve4r.fsf@cisco.com> <1230544737.4261.33.camel@alst60> <adaljtyu45d.fsf@cisco.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Dec 2008, Roland Dreier wrote:
>
> Something like the following maybe?  (This turns off the RDMA CM if
> INFINIBAND=y and IPV6=m -- another possibility would be to just turn off
> RDMA CM IPv6 support in the case that IB is build-in but IPv6 is
> modular, but that seems like a worse idea overall)
> 
> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> index a5dc78a..538a0ba 100644
> --- a/drivers/infiniband/Kconfig
> +++ b/drivers/infiniband/Kconfig
> @@ -36,7 +36,7 @@ config INFINIBAND_USER_MEM
>  
>  config INFINIBAND_ADDR_TRANS
>  	bool
> -	depends on INET
> +	depends on INET && !(INFINIBAND = y && IPV6 = m)
>  	default y

I'd suggest

  config IF_IPV6
	bool
	depends on INET
	depends on !(INFINIBAND = y && IPV6 = m)
	default y

and then you can use it not only for the above:

  config INFINIBAND_ADDR_TRANS
	bool
	depends on IF_IPV6
	default y

but also use it in the source code as a more readable version:

> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
> index d98b05b..ec7abb5 100644
> --- a/drivers/infiniband/core/addr.c> +++ b/drivers/infiniband/core/addr.c
> @@ -128,6 +128,7 @@ int rdma_translate_ip(struct sockaddr *addr, struct rdma_dev_addr *dev_addr)
>  		ret = rdma_copy_addr(dev_addr, dev, NULL);
>  		dev_put(dev);
>  		break;
> +#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)

ie use

	#ifdef CONFIG_IF_IPV6

here instead.

		Linus

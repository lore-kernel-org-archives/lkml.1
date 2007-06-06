Return-Path: <linux-kernel-owner+w=401wt.eu-S964876AbXFFBjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876AbXFFBjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933993AbXFFBiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:38:23 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:40665 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933927AbXFFBiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:38:22 -0400
Message-ID: <46661001.5090406@xensource.com>
Date: Tue, 05 Jun 2007 18:38:09 -0700
From: Jeremy Fitzhardinge <jeremy@xensource.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Andi Kleen <ak@suse.de>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] paravirt: helper to disable all IO space
References: <46660CB2.60409@xensource.com>
In-Reply-To: <46660CB2.60409@xensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2007 01:38:21.0867 (UTC) FILETIME=[5DEA6FB0:01C7A7DB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> In a virtual environment, device drivers such as legacy IDE will waste
> quite a lot of time probing for their devices which will never appear.
> This helper function allows a paravirt implementation to lay claim to
> the whole iomem and ioport space, thereby disabling all device drivers
> trying to claim IO resources.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
>
> diff -r 83c67f9402b5 arch/i386/kernel/paravirt.c
> --- a/arch/i386/kernel/paravirt.c	Tue Jun 05 17:41:04 2007 -0700
> +++ b/arch/i386/kernel/paravirt.c	Tue Jun 05 18:17:29 2007 -0700
> @@ -227,6 +227,39 @@ static int __init print_banner(void)
>  	return 0;
>  }
>  core_initcall(print_banner);
> +
> +static struct resource reserve_ioports = {
> +	.start = 0,
> +	.end = IO_SPACE_LIMIT,
> +	.name = "paravirt-ioport",
> +	.flags = IORESOURCE_IO | IORESOURCE_BUSY,
> +};
> +
> +static struct resource reserve_iomem = {
> +	.start = 0,
> +	.end = -1,
> +	.name = "paravirt-iomem",
> +	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
> +};
> +
> +/*
> + * Reserve the whole legacy IO space to prevent any legacy drivers
> + * from wasting time probing for their hardware.  This is a fairly
> + * brute-force approach to disabling all non-virtual drivers.
> + * 
> + * Note that this must be called very early to have any effect.
> + */
> +int paravirt_disable_iospace(void)
> +{
> +	int ret = 0;
> +
> +	ret = request_resource(&ioport_resource, &reserve_ioports);
> +	if (ret == 0)
> +		ret = request_resource(&iomem_resource, &reserve_iomem);
> +
> +	return ret;
> +}
> +
>  
>  struct paravirt_ops paravirt_ops = {
>  	.name = "bare hardware",
> diff -r 83c67f9402b5 arch/i386/xen/setup.c
> --- a/arch/i386/xen/setup.c	Tue Jun 05 17:41:04 2007 -0700
> +++ b/arch/i386/xen/setup.c	Tue Jun 05 18:17:29 2007 -0700
>   

Oops.  This was supposed to be in the corresponding Xen patch.

    J

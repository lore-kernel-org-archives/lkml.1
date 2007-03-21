Return-Path: <linux-kernel-owner+w=401wt.eu-S1751016AbXCUM7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016AbXCUM7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXCUM7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:59:38 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:47985 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbXCUM7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:59:37 -0400
Date: Wed, 21 Mar 2007 21:56:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Wu, Bryan" <bryan.wu@analog.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/4] Blackfin: architecture update patch
Message-ID: <20070321125631.GA13192@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Wu, Bryan" <bryan.wu@analog.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	bert hubert <bert.hubert@netherlabs.nl>,
	linux-kernel@vger.kernel.org
References: <1174471618.5648.50.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174471618.5648.50.camel@roc-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 06:06:58PM +0800, Wu, Bryan wrote:
> +++ linux-2.6/arch/blackfin/Kconfig	2007-03-21 14:38:42.000000000 +0800
> @@ -21,6 +21,10 @@ config RWSEM_XCHGADD_ALGORITHM
>  	bool
>  	default n
>  
> +config BLACKFIN
> +	bool
> +	default y
> +
>  config BFIN
>  	bool
>  	default y

Again, there's no reason to have both of these. Pick one and stick with
it.

> diff -purN linux-2.6-orig/arch/blackfin/kernel/flat.c linux-2.6/arch/blackfin/kernel/flat.c
> --- linux-2.6-orig/arch/blackfin/kernel/flat.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6/arch/blackfin/kernel/flat.c	2007-03-21 14:43:37.000000000 +0800
[snip]
> +	switch (type) {
> +		case FLAT_BFIN_RELOC_TYPE_16_BIT:
> +		case FLAT_BFIN_RELOC_TYPE_16H_BIT:
> +			usptr = (unsigned short *)ptr;
> +#ifdef DEBUG_BFIN_RELOC
> +			pr_info(" *usptr = %x", get_unaligned(usptr));
> +#endif
> +			val = get_unaligned(usptr);

The debugging here looks broken, just use pr_debug() and DEBUG as normal,
then you can kill off this DEBUG_BFIN_RELOC thing.

> @@ -346,3 +351,46 @@ unsigned long get_wchan(struct task_stru
>  	while (count++ < 16);
>  	return 0;
>  }
> +
> +#if !defined(CONFIG_NO_ACCESS_CHECK)
> +int _access_ok(unsigned long addr, unsigned long size)

You may want to change this to CONFIG_ACCESS_CHECK instead, it's a bit
more intuitive than checking ! CONFIG_NO_ACCESS_CHECK.

> --- linux-2.6-orig/arch/blackfin/mach-bf533/boards/ezkit.c	2007-03-21 17:32:30.000000000 +0800
> +++ linux-2.6/arch/blackfin/mach-bf533/boards/ezkit.c	2007-03-21 14:42:17.000000000 +0800
> @@ -6,7 +6,7 @@
>   * Created:      2005
>   * Description:
>   *
> - * Rev:          $Id: ezkit.c,v 1.27 2006/11/24 10:23:54 aubrey Exp $
> + * Rev:          $Id: ezkit.c 2794 2007-03-05 05:27:47Z cooloney $
>   *
>   * Modified:     Robin Getz <rgetz@blackfin.uclinux.org> - Named the boards
>   *               Copyright 2005 National ICT Australia (NICTA)

The RCS tags should be killed off as well, it's clear that they don't
really mean anthing, even in this case.

> diff -purN linux-2.6-orig/arch/blackfin/mach-bf533/boards/generic_board.c linux-2.6/arch/blackfin/mach-bf533/boards/generic_board.c
> --- linux-2.6-orig/arch/blackfin/mach-bf533/boards/generic_board.c	2007-03-21 17:32:30.000000000 +0800
> +++ linux-2.6/arch/blackfin/mach-bf533/boards/generic_board.c	2007-03-21 14:42:17.000000000 +0800
> @@ -6,7 +6,7 @@
>   * Created:      2005
>   * Description:
>   *
> - * Rev:          $Id: generic_board.c,v 1.9 2006/09/23 06:35:21 vapier Exp $
> + * Rev:          $Id: generic_board.c 2684 2007-01-22 03:59:04Z vapier $
>   *
>   * Modified:
>   *               Copyright 2005 National ICT Australia (NICTA)

An then do-nothing patches like this can be left out..

> +#if defined(CONFIG_USB_ISP1760_HCD) || defined(CONFIG_USB_ISP1760_HCD_MODULE)
> +static struct resource bfin_isp1761_resources[] = {
> +	[0] = {
> +		.name	= "isp1761-regs",
> +		.start  = ISP1761_BASE + 0x00000000,
> +		.end    = ISP1761_BASE + 0x000fffff,
> +		.flags  = IORESOURCE_MEM,
> +	},
> +	[1] = {
> +		.start  = ISP1761_IRQ,
> +		.end    = ISP1761_IRQ,
> +		.flags  = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
> +	},

Here you have low level.

> +};
> +
> +static struct platform_device bfin_isp1761_device = {
> +	.name           = "isp1761",
> +	.id             = 0,
> +	.num_resources  = ARRAY_SIZE(bfin_isp1761_resources),
> +	.resource       = bfin_isp1761_resources,
> +};
> +
> +static struct platform_device *bfin_isp1761_devices[] = {
> +	&bfin_isp1761_device,
> +};
> +
> +int __init bfin_isp1761_init(void)
> +{
> +	unsigned int num_devices=ARRAY_SIZE(bfin_isp1761_devices);
> +
> +	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
> +	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
> +
But here you set it to falling?

> diff -purN linux-2.6-orig/include/asm-blackfin/asm-offsets.h linux-2.6/include/asm-blackfin/asm-offsets.h
> --- linux-2.6-orig/include/asm-blackfin/asm-offsets.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6/include/asm-blackfin/asm-offsets.h	2007-03-21 15:21:10.000000000 +0800

This is generated by Kbuild, there's no point in including it in the
diff.

> -
> +/* CSYNC implementation for C file */
>  #if defined(ANOMALY_05000312) && defined(ANOMALY_05000244)

Is there some reason these aren't config options? Perhaps an errata
sub-menu might be more intuitive.

> diff -purN linux-2.6-orig/include/asm-blackfin/entry.h linux-2.6/include/asm-blackfin/entry.h
> --- linux-2.6-orig/include/asm-blackfin/entry.h	2007-03-21 17:32:31.000000000 +0800
> +++ linux-2.6/include/asm-blackfin/entry.h	2007-03-21 14:15:41.000000000 +0800
> @@ -52,10 +52,8 @@
>  #define RESTORE_ALL_SYS		restore_context_no_interrupts
>  #define RESTORE_CONTEXT		restore_context_with_interrupts
>  
> -#define STR(X) STR1(X)
> -#define STR1(X) #X
> -# define PT_OFF_ORIG_P0		208
> -# define PT_OFF_SR		8
> +#define PT_OFF_ORIG_P0		208
> +#define PT_OFF_SR		8
>  

Should these be in asm-offsets?

The rest of the patch looks good, this is certainly an improvement!

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761838AbXE1RJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838AbXE1RJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbXE1RJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:09:46 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2236 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbXE1RJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:09:45 -0400
Date: Mon, 28 May 2007 18:09:36 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: fix section mismatch warnings
Message-ID: <20070528170936.GC5737@flint.arm.linux.org.uk>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	LKML <linux-kernel@vger.kernel.org>
References: <20070528163253.GA29174@uranus.ravnborg.org> <20070528164427.GB29174@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528164427.GB29174@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 06:44:27PM +0200, Sam Ravnborg wrote:
> diff --git a/arch/arm/mach-sa1100/neponset.c b/arch/arm/mach-sa1100/neponset.c
> index d7c038a..17ebdc4 100644
> --- a/arch/arm/mach-sa1100/neponset.c
> +++ b/arch/arm/mach-sa1100/neponset.c
> @@ -139,12 +139,12 @@ static u_int neponset_get_mctrl(struct uart_port *port)
>  	return ret;
>  }
>  
> -static struct sa1100_port_fns neponset_port_fns __initdata = {
> +static struct sa1100_port_fns neponset_port_fns __devinitdata = {
>  	.set_mctrl	= neponset_set_mctrl,
>  	.get_mctrl	= neponset_get_mctrl,
>  };
>  
> -static int neponset_probe(struct platform_device *dev)
> +static int __devinit neponset_probe(struct platform_device *dev)
>  {
>  	sa1100_register_uart_fns(&neponset_port_fns);
>  
> @@ -299,7 +299,7 @@ static struct platform_device *devices[] __initdata = {
>  	&smc91x_device,
>  };
>  
> -static int __init neponset_init(void)
> +static int __devinit neponset_init(void)
>  {
>  	platform_driver_register(&neponset_device_driver);
>  

How can this hunk be correct?  neponset_init() is only called from
subsys_initcall() - it's not something we want to keep at init time.
I'm afraid I suspect faulty section analysis.

Given that (in the other messages) that there's other problems with
the warnings being generated, I'm reluctant to apply this off-hand.
I feel that the patch need quite careful review to make sure that
we're not introducing incorrect stuff such as the above.

I'll try and commit some of these changes this week though.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

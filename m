Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab0BYSnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:43:07 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56458 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab0BYSnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:43:05 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19CByt8k83RpTDvP+y/30Wl
Date: Thu, 25 Feb 2010 10:43:55 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thomas Weber <swirl@gmx.li>, Sergio Aquirre <saaguirre@ti.com>
Cc: linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Vikram Pandita <vikram.pandita@ti.com>,
       Syed Rafiuddin <rafiuddin.syed@ti.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Thomas Weber <weber@corscience.de>
Subject: Re: [RESEND][PATCH/RFC] OMAP2: serial.c: Fix number of uarts in
 early_init
Message-ID: <20100225184355.GF28173@atomide.com>
References: <1267090819-17796-1-git-send-email-swirl@gmx.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267090819-17796-1-git-send-email-swirl@gmx.li>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Weber <swirl@gmx.li> [100225 01:36]:
> 
> The omap_serial_early_init prints the following errors:
> 
> Could not get uart4_ick
> Could not get uart4_fck
> 
> because all the uarts available in omap_uart[] will be initialized.
> Only omap4430 and omap3630 have 4 uarts at the moment.
> This patch reduces the number of uarts when cpu is not omap4430 or
> omap3630.

..and I only patched omap_serial_init and forgot about
the omap_serial_early_init..

Looks good to me, Sergio, care to test and Ack this? Also, sounds
like we still need to patch omap4 for uart4 for the clocks.

Regards,

Tony
 
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  arch/arm/mach-omap2/serial.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
> index b79bc89..da77930 100644
> --- a/arch/arm/mach-omap2/serial.c
> +++ b/arch/arm/mach-omap2/serial.c
> @@ -644,16 +644,21 @@ static void serial_out_override(struct uart_port *up, int offset, int value)
>  }
>  void __init omap_serial_early_init(void)
>  {
> -	int i;
> +	int i, nr_ports;
>  	char name[16];
>  
> +	if (!(cpu_is_omap3630() || cpu_is_omap4430()))
> +		nr_ports = 3;
> +	else
> +		nr_ports = ARRAY_SIZE(omap_uart);
> +
>  	/*
>  	 * Make sure the serial ports are muxed on at this point.
>  	 * You have to mux them off in device drivers later on
>  	 * if not needed.
>  	 */
>  
> -	for (i = 0; i < ARRAY_SIZE(omap_uart); i++) {
> +	for (i = 0; i < nr_ports; i++) {
>  		struct omap_uart_state *uart = &omap_uart[i];
>  		struct platform_device *pdev = &uart->pdev;
>  		struct device *dev = &pdev->dev;
> @@ -669,17 +674,17 @@ void __init omap_serial_early_init(void)
>  			continue;
>  		}
>  
> -		sprintf(name, "uart%d_ick", i+1);
> +		sprintf(name, "uart%d_ick", i + 1);
>  		uart->ick = clk_get(NULL, name);
>  		if (IS_ERR(uart->ick)) {
> -			printk(KERN_ERR "Could not get uart%d_ick\n", i+1);
> +			printk(KERN_ERR "Could not get uart%d_ick\n", i + 1);
>  			uart->ick = NULL;
>  		}
>  
>  		sprintf(name, "uart%d_fck", i+1);
>  		uart->fck = clk_get(NULL, name);
>  		if (IS_ERR(uart->fck)) {
> -			printk(KERN_ERR "Could not get uart%d_fck\n", i+1);
> +			printk(KERN_ERR "Could not get uart%d_fck\n", i + 1);
>  			uart->fck = NULL;
>  		}
>  
> -- 
> 1.6.4.4
> 

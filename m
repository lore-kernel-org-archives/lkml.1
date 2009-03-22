Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZCVL5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZCVL5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 07:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZCVL5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 07:57:15 -0400
Received: from smtp4.welho.com ([213.243.153.38]:35867 "EHLO smtp4.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbZCVL5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 07:57:14 -0400
Date: Sun, 22 Mar 2009 13:57:10 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>, David Brownell <david-b@pacbell.net>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       Sedji GAOUAOU <sedji.gaouaou@atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] AT91: manage clock by functionality instead of CPUs
Message-ID: <20090322115710.GV10127@sci.fi>
Mail-Followup-To: Nicolas Ferre <nicolas.ferre@atmel.com>,
	Andrew Victor <linux@maxim.org.za>,
	David Brownell <david-b@pacbell.net>,
	Patrice VILCHEZ <patrice.vilchez@atmel.com>,
	Sedji GAOUAOU <sedji.gaouaou@atmel.com>,
	ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <49C37677.8090508@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C37677.8090508@atmel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 11:56:55AM +0100, Nicolas Ferre wrote:
> --- a/arch/arm/mach-at91/clock.c
> +++ b/arch/arm/mach-at91/clock.c
> @@ -45,6 +45,25 @@
>  #define clk_is_sys(x)		((x)->type & CLK_TYPE_SYSTEM)
>  
>  
> +/*
> + * Chips have some kind of clocks : group them by functionality
> + */
> +#define cpu_has_utmi()		(  cpu_is_at91cap9() \
> +				|| cpu_is_at91sam9rl())
> +
> +#define cpu_has_800M_plla()	(cpu_is_at91sam9g20())
> +
> +#define cpu_has_pllb()		(!(cpu_is_at91sam9rl()))

Useless parentheses.

> +
> +#define cpu_has_upll()		(0)

Is this for some future chip?

> +
> +/* USB host HS & FS */
> +#define cpu_has_uhp()		(!cpu_is_at91sam9rl())
> +
> +/* USB device FS only */
> +#define cpu_has_udpfs()		(!(cpu_is_at91sam9rl()))

Useless parentheses.

> +
> +
>  static LIST_HEAD(clocks);
>  static DEFINE_SPINLOCK(clk_lock);
>  
> @@ -142,7 +161,7 @@ static struct clk utmi_clk = {
>  };
>  static struct clk uhpck = {
>  	.name		= "uhpck",
> -	.parent		= &pllb,
> +	/*.parent		= ... we choose parent at runtime */
>  	.mode		= pmc_sys_mode,
>  };
>  
> @@ -175,7 +194,12 @@ static struct clk __init *at91_css_to_cl
>  		case AT91_PMC_CSS_PLLA:
>  			return &plla;
>  		case AT91_PMC_CSS_PLLB:
> -			return &pllb;
> +			if (cpu_has_upll())
> +				/* CSS_PLLB == CSS_UPLL */
> +				return &utmi_clk;
> +			else
> +				if (cpu_has_pllb())
> +					return &pllb;

Put "else if" on one line?

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/

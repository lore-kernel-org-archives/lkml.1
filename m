Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbYE1FOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbYE1FOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 01:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbYE1FNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 01:13:54 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:42647
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378AbYE1FNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 01:13:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMAAMeGPEh8qN9Z/2dsb2JhbAAIrmY
X-IronPort-AV: E=Sophos;i="4.27,552,1204470000"; 
   d="scan'208";a="226758238"
Subject: Re: Latest gpio gumph
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
In-Reply-To: <200805272144.33334.david-b@pacbell.net>
References: <1211942475.27810.37.camel@moss.renham>
	 <200805272144.33334.david-b@pacbell.net>
Content-Type: text/plain
Organization: Nias Digital
Date: Wed, 28 May 2008 15:13:53 +1000
Message-Id: <1211951633.27810.72.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-27 at 21:44 -0700, David Brownell wrote:
> On Tuesday 27 May 2008, Ben Nizette wrote:
> > Hey David,
> > 
> > Have you got a git/quilt repo somewhere with all the latest gpiolib (and
> > gpio framework) stuff glued in?  I've seen most of it hit -mm but
> > developing against -mm on (especially on obscure archs like AVR32 as I
> > do) is always fraught.
> 
> All the relevant stuff is now upstream (2.6.26-rc4) except:
> 
>   - the userspace sysfs interface (which is in MM, and ISTR
>     you were cc'd on that)

Yup, indeed.

> 
>   - an avr32 patch, appended (no response on the avr32 list)
> 
> Nothing else touches core code; if you're using AVR32, then
> you won't care about at91 gpiolib and inlining support, or the
> patch sent this AM on LKML (which I've not yet reviewed).

Righteo, thanks.

	--Ben.

> 
> - Dave
> 
> 
> 
> ====== CUT HERE
> From: David Brownell <dbrownell@users.sourceforge.net>
> Subject: AVR32: minor GPIO handling updates
> 
>  * gpio_direction_output() should disable the pullups just like
>    at32_select_gpio(... AT32_GPIOF_OUTPUT) does, for consistency
>    between those alternative initialization paths.
> 
>  * On the odd chance some code uses a pin as a GPIO IRQ without
>    calling gpio_request() or gpio_direction_input(), the debug
>    dump should still show its pin status.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  arch/avr32/mach-at32ap/pio.c |    3 +++
>  1 files changed, 3 insertions(+)
> 
> --- a/arch/avr32/mach-at32ap/pio.c	2008-05-02 12:30:59.000000000 -0700
> +++ b/arch/avr32/mach-at32ap/pio.c	2008-05-02 12:41:29.000000000 -0700
> @@ -191,6 +191,7 @@ static int direction_output(struct gpio_
>  		return -EINVAL;
>  
>  	gpio_set(chip, offset, value);
> +	pio_writel(pio, PUDR, mask);
>  	pio_writel(pio, OER, mask);
>  	return 0;
>  }
> @@ -318,6 +319,8 @@ static void pio_bank_show(struct seq_fil
>  		const char *label;
>  
>  		label = gpiochip_is_requested(chip, i);
> +		if (!label && (imr & mask))
> +			label = "[irq]";
>  		if (!label)
>  			continue;
>  

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbYBYWdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbYBYWdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757915AbYBYWdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:33:41 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:38175 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757481AbYBYWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:33:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=6AXsOGdkbNxo1byUAleU3Sjrdl87/mCjtH1Hi1VscvQ2cny3QDQ8XrbMBDGaZN2dIkM+sgr/3JthHxJGLYLlW5Tx+1DWPme7odLi6J831EcJYwHCMzs/RoUX8flZM3mTlbkspkayTDlqibiC8XyYuuUcebLLU8K/g4/P2E8ZpHk=  ;
X-YMail-OSG: KRDt5JcVM1mnjIb8K0JuYS8Zoo_kh1X7a_jjFa6uKeCfCEnpuWCcM5.tv0EyLOYRuszKtfnXNQ--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 25 Feb 2008 14:33:38 -0800
From: David Brownell <david-b@pacbell.net>
To: peterz@infradead.org
Subject: Re: [patch 2.6.25-rc3] lockdep:  add spin_lock_irq_nested()
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080225223338.9602E25E979@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I'm think that the reason this only _changes_ the false
> recursion notification ...

Whoops, it's because of the following typo:

> --- a/arch/arm/plat-omap/gpio.c	2008-02-24 19:02:32.000000000 -0800
> +++ b/arch/arm/plat-omap/gpio.c	2008-02-25 10:54:29.000000000 -0800
> @@ -1332,6 +1332,28 @@ static struct clk *gpio_fclks[OMAP34XX_N
>  static struct clk *gpio_iclks[OMAP34XX_NR_GPIOS];
>  #endif
>  
> +#ifdef CONFIG_LOCKDEP
> +
> +/* tell lockdep that this IRQ's locks and its parent's locks are in
> + * different categories, so that it won't detect false recursion.
> + */
> +static struct lock_class_key gpio_lock_class;
> +
> +static inline void mark_gpio_locking(unsigned gpio_irq)
> +{
> +	lockdep_set_class(&irq_desc[gpio_irq].lock, &gpio_lock_class);
> +}
> +
> +#else
> +
> +static inline void mark_gpio_locking(unsigned gpio_irq)
> +{
> +	/* NOP */
> +}
> +
> +#endif
> +
> +
>  static int __init _omap_gpio_init(void)
>  {
>  	int i;
> @@ -1532,6 +1554,7 @@ static int __init _omap_gpio_init(void)
>  				set_irq_chip(j, &gpio_irq_chip);
>  			set_irq_handler(j, handle_simple_irq);
>  			set_irq_flags(j, IRQF_VALID);
> +			mark_gpio_locking(i);

should be		mark_gpio_locking(j).

That's an off-by-one error in ASCII or QWERTY (adjacency), and
in terms of typefaces it's a few pixels.  Sigh.

Since that seems to behave, I'll send along a couple patches
like this ... unless you say this isn't really, after all, the
right way to address this problem.  Note that neither IRQ has
ever been triggered at this point ... I'll move the marking up
a bit to ensure the lock has never been taken either.

- Dave


>  		}
>  		set_irq_chained_handler(bank->irq, gpio_irq_handler);
>  		set_irq_data(bank->irq, bank);
>

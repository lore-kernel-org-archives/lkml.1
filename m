Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514Ab0ABVGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab0ABVGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 16:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261Ab0ABVGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 16:06:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48620 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0ABVGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 16:06:37 -0500
Date: Sat, 2 Jan 2010 22:06:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       linux-input@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 32-rc1 aka 32-rc2: warning at manage.c:361 (set_irq_wake),
 matrix-keypad related?
Message-ID: <20100102210633.GA3075@elf.ucw.cz>
References: <20090930200746.GA1384@ucw.cz>
 <20091006050649.GH27881@core.coreip.homeip.net>
 <20091006075816.GA1362@ucw.cz>
 <20091007043603.GC10204@core.coreip.homeip.net>
 <f17812d70910070742y5e27f9c3u38e3299b94f33613@mail.gmail.com>
 <20091007163327.GA12053@core.coreip.homeip.net>
 <20091007211225.GB17805@elf.ucw.cz>
 <20091203031709.GE9121@core.coreip.homeip.net>
 <20100102135608.GA5872@ucw.cz>
 <20100102152723.GA10476@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102152723.GA10476@ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-01-02 16:27:24, Pavel Machek wrote:
> On Sat 2010-01-02 14:56:09, Pavel Machek wrote:
> > Hi!
> > 
> > > > > We ignore the failure right now in the mainline but that causes stack
> > > > > traces on resume as we trying to disable not enabled wakeup GPIOs. That
> > > > > was original Pavel's complaint.
> > > > 
> > > > Yep...
> > > > 
> > > > I'd say that BUG() simply should not trigger if wakeup can not be
> > > > enabled/disabled for particular source...?
> > > 
> > > Pavel,
> > > 
> > > Could you please try the patch below and let me know if it fixes the
> > > problem for you?
> > 
> > (sorry for long delay).
> > 
> > With 33-rc1+your patch, warnings are no longer there. 
> > 
> > I still have one on irq191, but that's gpio button driver.
> > 
> > But please, hold the patch for few more days. I may have cleaner/nicer
> > solution. It seems that zaurus is doing something very stupid in low
> > layers.
> 
> I'm thinking that maybe something like this should do the trick.

And it does, simplyfing pxa-specific code. More testing would be nice,
but I guess simplifying pxa is preferable to adding workarounds in
input.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

> --- ./arch/arm.ofic/mach-pxa/mfp-pxa2xx.c	2009-09-10 00:13:59.000000000 +0200
> +++ ./arch/arm/mach-pxa/mfp-pxa2xx.c	2009-12-29 03:16:40.000000000 +0100
> @@ -34,7 +34,6 @@
>  struct gpio_desc {
>  	unsigned	valid		: 1;
>  	unsigned	can_wakeup	: 1;
> -	unsigned	keypad_gpio	: 1;
>  	unsigned	dir_inverted	: 1;
>  	unsigned int	mask; /* bit mask in PWER or PKWR */
>  	unsigned int	mux_mask; /* bit mask of muxed gpio bits, 0 if no mux */
> @@ -178,9 +177,6 @@
>  	if (!d->valid)
>  		return -EINVAL;
>  
> -	if (d->keypad_gpio)
> -		return -EINVAL;
> -
>  	mux_taken = (PWER & d->mux_mask) & (~d->mask);
>  	if (on && mux_taken)
>  		return -EBUSY;
> @@ -231,32 +227,6 @@
>  #endif /* CONFIG_PXA25x */
>  
>  #ifdef CONFIG_PXA27x
> -static int pxa27x_pkwr_gpio[] = {
> -	13, 16, 17, 34, 36, 37, 38, 39, 90, 91, 93, 94,
> -	95, 96, 97, 98, 99, 100, 101, 102
> -};
> -
> -int keypad_set_wake(unsigned int on)
> -{
> -	unsigned int i, gpio, mask = 0;
> -
> -	if (!on) {
> -		PKWR = 0;
> -		return 0;
> -	}
> -
> -	for (i = 0; i < ARRAY_SIZE(pxa27x_pkwr_gpio); i++) {
> -
> -		gpio = pxa27x_pkwr_gpio[i];
> -
> -		if (gpio_desc[gpio].config & MFP_LPM_CAN_WAKEUP)
> -			mask |= gpio_desc[gpio].mask;
> -	}
> -
> -	PKWR = mask;
> -	return 0;
> -}
> -
>  #define PWER_WEMUX2_GPIO38	(1 << 16)
>  #define PWER_WEMUX2_GPIO53	(2 << 16)
>  #define PWER_WEMUX2_GPIO40	(3 << 16)
> @@ -273,6 +243,12 @@
>  	gpio_desc[(gpio)].mux_mask = PWER_ ## mux ## _MASK;	\
>  } while (0)
>  
> +
> +static int pxa27x_pkwr_gpio[] = {
> +	13, 16, 17, 34, 36, 37, 38, 39, 90, 91, 93, 94,
> +	95, 96, 97, 98, 99, 100, 101, 102
> +};
> +
>  static void __init pxa27x_mfp_init(void)
>  {
>  	int i, gpio;
> @@ -291,7 +267,6 @@
>  	for (i = 0; i < ARRAY_SIZE(pxa27x_pkwr_gpio); i++) {
>  		gpio = pxa27x_pkwr_gpio[i];
>  		gpio_desc[gpio].can_wakeup = 1;
> -		gpio_desc[gpio].keypad_gpio = 1;
>  		gpio_desc[gpio].mask = 1 << i;
>  	}
>  
> --- ./arch/arm.ofic/mach-pxa/pxa27x.c	2009-09-10 00:13:59.000000000 +0200
> +++ ./arch/arm/mach-pxa/pxa27x.c	2009-12-29 03:13:00.000000000 +0100
> @@ -323,9 +323,6 @@
>  	if (gpio >= 0 && gpio < 128)
>  		return gpio_set_wake(gpio, on);
>  
> -	if (irq == IRQ_KEYPAD)
> -		return keypad_set_wake(on);
> -
>  	switch (irq) {
>  	case IRQ_RTCAlrm:
>  		mask = PWER_RTC;
> 
> 
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

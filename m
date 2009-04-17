Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbZDQMYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbZDQMYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 08:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbZDQMYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 08:24:04 -0400
Received: from [213.79.90.228] ([213.79.90.228]:13442 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755540AbZDQMYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 08:24:01 -0400
Date: Fri, 17 Apr 2009 16:23:59 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] powerpc/fsl_soc: Isolate legacy fsl_spi support to
	mpc832x_rdb boards
Message-ID: <20090417122359.GA6707@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090123195041.GF21237@oksana.dev.rtsoft.ru> <20090123194958.GA17355@oksana.dev.rtsoft.ru> <87bpr71p1o.fsf_-_@macbook.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <87bpr71p1o.fsf_-_@macbook.be.48ers.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Sorry for the late response (and don't hesitate to ping me if I
don't answer, some things get lost in my inbox traffic, sorry).

On Wed, Apr 08, 2009 at 11:18:43AM +0200, Peter Korsgaard wrote:
> >>>>> "Anton" == Anton Vorontsov <avorontsov@ru.mvista.com> writes:
> 
> Hi,
> 
>  Anton> The advantages of this:
>  Anton> - Don't encourage legacy support;
>  Anton> - Less external symbols, less code to compile-in for !MPC832x_RDB
>  Anton>   platforms.
> 
> It's nice with your cleanups, but I wonder how to handle more
> complicated chip select handling than simply toggling a single gpio.
> 
> I have a board (or 2 actually, but they are similar in this regard)
> with a mpc8347 using SPI to a number of addon boards. For signal
> integrity reasons the SPI signals are routed to a MUX, so the chip
> select logic has to set the MUX in addition to controlling the CS line
> of the device.

So that's just a bit complicated GPIO controller. I believe you
should describe it in the device tree and use it's muxed lines as
usual GPIOs.

Something ling

muxed_pio: gpio-controller@.. {
	#gpio-cells = <2>;
	compatible = "..,<board>-muxed-gpios";
	reg = <...>;
	gpios = <...>; <- specify pure BLK1, BLK2, OPT1, OPT2 GPIOs
	gpio-controller;
};

And then,

> I've been using code like this since late 2007, but this patch
> ofcourse breaks it:
> 
> static void thinx_spi_activate_cs(u8 cs, u8 polarity)
> {
> 	static u8 old_cs = 255;
> 
> 	if (cs != old_cs) {
> 		/* mux setup (cs 2:1)*/
> 		gpio_set_value(gpio1 + GPIO_SPI_MUX_NOE, 1);
> 		gpio_set_value(gpio1 + GPIO_SPI_MUX_SEL0, cs&2);
> 		gpio_set_value(gpio1 + GPIO_SPI_MUX_SEL1, cs&4);
> 		gpio_set_value(gpio1 + GPIO_SPI_MUX_NOE, 0);
> 		old_cs = cs;
> 	}
> 
> 	switch (cs) {
> 	case 0: gpio_set_value(gpio1 + GPIO_SPI_CS_BKL1, polarity); break;
> 	case 1: gpio_set_value(gpio1 + GPIO_SPI_CS_BKL2, polarity); break;
> 	case 2: gpio_set_value(gpio1 + GPIO_SPI_CS_OPT1, polarity); break;
> 	case 3: gpio_set_value(gpio1 + GPIO_SPI_CS_OPT2, polarity); break;
> 	}
> }

^^^ Put this logic into the "<board>-muxed-gpios" GPIO controller
driver.

Then spi node would look like this:

spi-controller@.. {
	...
	gpios = <&muxed_pio cs1 0   /* muxed CS_BLK1 */
		 &muxed_pio cs2 0   /* muxed CS_BLK2 */
		 &muxed_pio cs3 0   /* muxed CS_OPT1 */
		 &muxed_pio cs4 0>; /* muxed CS_OPT2 */
};

Hope this helps,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

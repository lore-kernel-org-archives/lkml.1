Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbZDQFOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbZDQFOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZDQFN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:13:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:12331 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZDQFN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=MlFTEEbuZEaIfWfllygUwLmP24dK9Y6fpYzjbwmwj6FJjFQh0/rd2YUBhVZWqCaYMB
         aJDKXeSlHfB2C75F+y3JnBMBqv2nvHDjTRmJCwZDm9ECQP8p7LpP4hOS/GJU+9/pjoeQ
         FFHzZgVF1NQP/tM9a+/7f3ftyfg2Hrxw47nf8=
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] powerpc/fsl_soc: Isolate legacy fsl_spi support to mpc832x_rdb boards
References: <20090123195041.GF21237@oksana.dev.rtsoft.ru>
	<20090123194958.GA17355@oksana.dev.rtsoft.ru>
	<87bpr71p1o.fsf_-_@macbook.be.48ers.dk>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Fri, 17 Apr 2009 07:13:54 +0200
In-Reply-To: <87bpr71p1o.fsf_-_@macbook.be.48ers.dk> (Peter Korsgaard's message of "Wed\, 08 Apr 2009 11\:18\:43 +0200")
Message-ID: <87k55jamlp.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Peter" == Peter Korsgaard <jacmet@sunsite.dk> writes:

Anyone? I've locally reverted the commit, but most likely I'm not the
only one using the spi_mpc83xx driver without direct gpio controlled
chip select handling.

 Anton> The advantages of this:
 Anton> - Don't encourage legacy support;
 Anton> - Less external symbols, less code to compile-in for !MPC832x_RDB
 Anton> platforms.

 Peter> It's nice with your cleanups, but I wonder how to handle more
 Peter> complicated chip select handling than simply toggling a single gpio.

 Peter> I have a board (or 2 actually, but they are similar in this regard)
 Peter> with a mpc8347 using SPI to a number of addon boards. For signal
 Peter> integrity reasons the SPI signals are routed to a MUX, so the chip
 Peter> select logic has to set the MUX in addition to controlling the CS line
 Peter> of the device.

 Peter> I've been using code like this since late 2007, but this patch
 Peter> ofcourse breaks it:

 Peter> static void thinx_spi_activate_cs(u8 cs, u8 polarity)
 Peter> {
 Peter> 	static u8 old_cs = 255;

 Peter> 	if (cs != old_cs) {
 Peter> 		/* mux setup (cs 2:1)*/
 Peter> 		gpio_set_value(gpio1 + GPIO_SPI_MUX_NOE, 1);
 Peter> 		gpio_set_value(gpio1 + GPIO_SPI_MUX_SEL0, cs&2);
 Peter> 		gpio_set_value(gpio1 + GPIO_SPI_MUX_SEL1, cs&4);
 Peter> 		gpio_set_value(gpio1 + GPIO_SPI_MUX_NOE, 0);
 Peter> 		old_cs = cs;
 Peter> 	}

 Peter> 	switch (cs) {
 Peter> 	case 0: gpio_set_value(gpio1 + GPIO_SPI_CS_BKL1, polarity); break;
 Peter> 	case 1: gpio_set_value(gpio1 + GPIO_SPI_CS_BKL2, polarity); break;
 Peter> 	case 2: gpio_set_value(gpio1 + GPIO_SPI_CS_OPT1, polarity); break;
 Peter> 	case 3: gpio_set_value(gpio1 + GPIO_SPI_CS_OPT2, polarity); break;
 Peter> 	}
 Peter> }

 Peter> static void thinx_spi_deactivate_cs(u8 cs, u8 polarity)
 Peter> {
 Peter> 	switch (cs) {
 Peter> 	case 0: gpio_set_value(gpio1 + GPIO_SPI_CS_BKL1, !polarity); break;
 Peter> 	case 1: gpio_set_value(gpio1 + GPIO_SPI_CS_BKL2, !polarity); break;
 Peter> 	case 2: gpio_set_value(gpio1 + GPIO_SPI_CS_OPT1, !polarity); break;
 Peter> 	case 3: gpio_set_value(gpio1 + GPIO_SPI_CS_OPT2, !polarity); break;
 Peter> 	}
 Peter> }

 Peter> static __init int thinx_spi_init(void)
 Peter> {
 Peter> 	struct device_node *np;
 Peter> 	struct of_gpio_chip *gc;
 Peter> 	static const int gpios[] = {
 Peter> 		GPIO_SPI_CS_BKL1,
 Peter> 		GPIO_SPI_CS_BKL2,
 Peter> 		GPIO_SPI_CS_OPT1,
 Peter> 		GPIO_SPI_CS_OPT2,
 Peter> 		GPIO_SPI_MUX_NOE,
 Peter> 		GPIO_SPI_MUX_SEL0,
 Peter> 		GPIO_SPI_MUX_SEL1
 Peter> 	};
 Peter> 	int i;

 Peter> 	np = of_find_node_by_name(NULL, "gpio-controller");
 Peter> 	if (!np || !np->data) {
 Peter> 		printk(KERN_ERR
 Peter> 		       "gpio1 node not found or controller not registerred\n");
 Peter> 		return -ENODEV;
 Peter> 	}
 Peter> 	gc = np->data;
 Peter> 	gpio1 = gc->gc.base;

 Peter> 	for (i=0; i<ARRAY_SIZE(gpios); i++) {
 Peter> 		gpio_request(gpio1 + gpios[i], "spi");
 Peter> 		gpio_direction_output(gpio1 + gpios[i], 1);
 Peter> 	}

 Peter> 	fsl_spi_init(thinx_spi_boardinfo, ARRAY_SIZE(thinx_spi_boardinfo),
 Peter> 		     thinx_spi_activate_cs, thinx_spi_deactivate_cs);

 Peter> 	return 0;
 Peter> }

 Peter> Now, I don't quite see how to handle this with the new OF bindings -
 Peter> Any ideas?

-- 
Bye, Peter Korsgaard

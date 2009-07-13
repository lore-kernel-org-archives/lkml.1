Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZGMRe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZGMRe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbZGMRe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:34:57 -0400
Received: from ru.mvista.com ([213.79.90.228]:63836 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756559AbZGMRe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:34:56 -0400
Date: Mon, 13 Jul 2009 21:34:55 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/2] Setting GPIOs simultaneously
Message-ID: <20090713173455.GA9866@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090713151911.GA28114@oksana.dev.rtsoft.ru>
 <OFF188389D.68E638A2-ONC12575F2.00568C5B-C12575F2.0057FC95@transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <OFF188389D.68E638A2-ONC12575F2.00568C5B-C12575F2.0057FC95@transmode.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 06:01:02PM +0200, Joakim Tjernlund wrote:
> 
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote on 13/07/2009 17:19:11:
> >
> > Hi all,
> >
> > I've been sitting on these patches for some time, but now it appears
> > that the set_sync() feature is needed elsewhere. So here are the
> > patches.
> >
> > Joakim, I think this is what you need.
> 
> Yes, it sure looks so :) I will have to look closer later as
> I will be traveling the next few days.
> 
> Question though, have you considered using a bitmask instead of
> an array:
> static void qe_gpio_set_sync(struct gpio_chip *gc, unsigned int num,
> 	 		      unsigned int gpio_mask, unsigned int vals)
> If you want to set bit 0, 3 and 8 you would set positions 0, 3 and 8 in gpio_mask
> to ones. Similarly in vals, set bit positions 0, 3 and 8 to requested value.

Yeah, I thought about it. We could do the u64 masks (to handle up
to 64 bits parallel IO buses).

It's all easy with dumb memory-mapped GPIO controllers, because
we have a 8/16/32/64 bits registers with linear bit<->gpio mapping.

But some gpio controllers aren't that easy. I know at least one
(FPGA-based) gpio controller that won't change any GPIO lines
for real unless changes are "commited". The controller has several
banks (registers) of PIOs (total count > 64 bits), but you can commit
all the changes to the banks at once (synchronously). This isn't
because the controller is uber-cool, it's just the controller has
sequential IO. So with masks approach you won't able to use _sync()
calls that easily for all GPIOs range.

But OK, if we throw away the special cases, I can't imagine any
clear api for this approach, all I can think of is something
along these lines:

int num = 3;
u32 gpios[3];
u64 shifts[3];

/* this implies checks whether we can use _sync() */
if (!gpio_get_shifts(num, gpios, shifts))
	return -EINVAL;

gpio_set_values_sync(chip, 1 << shifts[0] | 1 << shifts[1],
		     val0 << shifts[0] | val1 << shifts[1]).

We can implement it, if that's acceptable. But that's a bit
ugly, I think.

> While being at it, the reason for me needing this is that the spi_mpc83xx driver
> was recently converted to a OF only driver so I have no way of defining my own
> CS function anymore. While OF is good I don't feel that OF drivers should block the native
> method, OF should be a layer on top of the native methods.

Um, I don't get it. You have a mux, which is a sort of GPIO controller.
All you need to do is to write "of-gpio-mux" driver, that will get all
the needed gpios from the underlaying GPIO controller.

In the device tree it'll look like this:

muxed_gpio: gpio-controller {
	#gpio-cells = <2>;
	compatible = "board-gpio-mux", "generic-gpio-mux";
	gpios = <&qe_pio_d  2 0   /* AD0 */
		 &qe_pio_d 17 0   /* AD1 */
		 &qe_pio_d  5 0>; /* AD2 */
	gpio-controller;
};

spi-controller {
	gpios = <&muxed_gpio 0 0
		 &muxed_gpio 1 0
		 &muxed_gpio 2 0
		 &muxed_gpio 3 0
		 &muxed_gpio 4 0
		 &muxed_gpio 5 0
		 &muxed_gpio 6 0
		 &muxed_gpio 7 0>;

	spi-device@0 {
		reg = <0>;
	};
	...
	spi-device@7 {
		reg = <0>;
	};
};

So you don't have to modify the spi driver.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

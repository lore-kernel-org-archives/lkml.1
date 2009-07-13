Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbZGMT76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbZGMT76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 15:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZGMT75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 15:59:57 -0400
Received: from gw1.transmode.se ([213.115.205.20]:37705 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746AbZGMT75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 15:59:57 -0400
In-Reply-To: <20090713173455.GA9866@oksana.dev.rtsoft.ru>
References: <20090713151911.GA28114@oksana.dev.rtsoft.ru> <OFF188389D.68E638A2-ONC12575F2.00568C5B-C12575F2.0057FC95@transmode.se> <20090713173455.GA9866@oksana.dev.rtsoft.ru>
Subject: Re: [PATCH 0/2] Setting GPIOs simultaneously
X-KeepSent: 9378E65D:FBBCCFD5-C12575F2:006B28D5;
 type=4; name=$KeepSent
To: avorontsov@ru.mvista.com
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OF9378E65D.FBBCCFD5-ONC12575F2.006B28D5-C12575F2.006DDAE5@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Mon, 13 Jul 2009 21:59:54 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5 HF407|May 07, 2009) at
 2009-07-13 21:59:55
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov <avorontsov@ru.mvista.com> wrote on 13/07/2009 19:34:55:
>
> On Mon, Jul 13, 2009 at 06:01:02PM +0200, Joakim Tjernlund wrote:
> >
> > Anton Vorontsov <avorontsov@ru.mvista.com> wrote on 13/07/2009 17:19:11:
> > >
> > > Hi all,
> > >
> > > I've been sitting on these patches for some time, but now it appears
> > > that the set_sync() feature is needed elsewhere. So here are the
> > > patches.
> > >
> > > Joakim, I think this is what you need.
> >
> > Yes, it sure looks so :) I will have to look closer later as
> > I will be traveling the next few days.
> >
> > Question though, have you considered using a bitmask instead of
> > an array:
> > static void qe_gpio_set_sync(struct gpio_chip *gc, unsigned int num,
> >                 unsigned int gpio_mask, unsigned int vals)
> > If you want to set bit 0, 3 and 8 you would set positions 0, 3 and 8 in gpio_mask
> > to ones. Similarly in vals, set bit positions 0, 3 and 8 to requested value.
>
> Yeah, I thought about it. We could do the u64 masks (to handle up
> to 64 bits parallel IO buses).
>
> It's all easy with dumb memory-mapped GPIO controllers, because
> we have a 8/16/32/64 bits registers with linear bit<->gpio mapping.

Yes, this is gpio ..

>
> But some gpio controllers aren't that easy. I know at least one
> (FPGA-based) gpio controller that won't change any GPIO lines
> for real unless changes are "commited". The controller has several
> banks (registers) of PIOs (total count > 64 bits), but you can commit
> all the changes to the banks at once (synchronously). This isn't
> because the controller is uber-cool, it's just the controller has
> sequential IO. So with masks approach you won't able to use _sync()
> calls that easily for all GPIOs range.

.. but this one I am not sure qualify as gpio. Feels more like
its own device that should have its own driver.

>
> But OK, if we throw away the special cases, I can't imagine any
> clear api for this approach, all I can think of is something
> along these lines:
>
> int num = 3;
> u32 gpios[3];
> u64 shifts[3];
>
> /* this implies checks whether we can use _sync() */
> if (!gpio_get_shifts(num, gpios, shifts))
>    return -EINVAL;
>
> gpio_set_values_sync(chip, 1 << shifts[0] | 1 << shifts[1],
>            val0 << shifts[0] | val1 << shifts[1]).
>
> We can implement it, if that's acceptable. But that's a bit
> ugly, I think.

I see, that doesn't look good that either.

>
> > While being at it, the reason for me needing this is that the spi_mpc83xx driver
> > was recently converted to a OF only driver so I have no way of defining my own
> > CS function anymore. While OF is good I don't feel that OF drivers should
> block the native
> > method, OF should be a layer on top of the native methods.
>
> Um, I don't get it. You have a mux, which is a sort of GPIO controller.
> All you need to do is to write "of-gpio-mux" driver, that will get all
> the needed gpios from the underlaying GPIO controller.

Well, I already have a mux controller that is using the native spi methods. I
don't want to write a new one, far more complicated than what I got now.
While the OF system is very powerful and flexible I still think that
one should be able to use native SPI methods too. Why can they not
co-exist?

>
> In the device tree it'll look like this:

I must admit that I just started to look at the GPIO subsystem, but
I do wonder if mpc83xx_spi_cs_control() can do this muxing
without any change.

Very good example BTW.

      Jocke


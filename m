Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbZFKV3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbZFKV3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZFKV3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:29:03 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:33034 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbZFKV3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:29:02 -0400
Date: Thu, 11 Jun 2009 17:28:50 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: Tobias_Mueller@twam.info
Cc: akpm@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>,
       deepak@laptop.org, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       jordan@cosmicpenguin.net, cjb@laptop.org,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/2] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver  
 support
Message-ID: <20090611172850.6c418b1d@mycelium.queued.net>
In-Reply-To: <17be05570906111311s717f126cyd4edf0847b839eef@mail.gmail.com>
References: <20090610001033.27b7f69f@mycelium.queued.net>
	<17be05570906111152j3ecb0102qfd6f53221c7ae9f9@mail.gmail.com>
	<20090611160059.6d70f54a@mycelium.queued.net>
	<17be05570906111311s717f126cyd4edf0847b839eef@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009 22:11:58 +0200
Tobias Müller <Tobias_Mueller@twam.info> wrote:

> >>  #define DRV_NAME "cs5535-gpio"
> >>  #define GPIO_BAR 1
> >> +#define GPIO_DEFAULT_MASK 0x0B003C66
> >
> > Where does this mask of available GPIOs originate from?
> 
> I had a comment in my original patch:
> 
> /**
> * Some GPIO pins
> *  31-29,23 : reserved (always mask out)
> *  28       : Power Button
> *  26       : PME#
> *  22-16    : LPC
> *  14,15    : SMBus
> *  9,8      : UART1
> *  7        : PCI INTB
> *  3,4      : UART2/DDC
> *  2        : IDE_IRQ0
> *  1        : AC_BEEP
> *  0        : PCI INTA
> *
> * If a mask was not specified, be conservative and only allow:
> *  1,2,5,6,10-13,24,25,27
> */
> 
> I'll add this in my patch to clear it out.
> 

But why are you being conservative in the first place?  If something's
using GPIOs, unless they're unmapped, you should allow it to use them
without requiring a boot arg.

For example, OLPC uses GPIO 7 for its DCON IRQ.  With the masking
scheme, OLPC will need to set that mask from the default.  I don't see
the point of having the mask at all if other drivers in the kernel are
going to be requesting GPIOs (presumably they know what they're doing).


> >> +     /* disable output aux 1 & 2 on this pin */
> >> +     __cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_AUX1);
> >> +     __cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_AUX2);
> >> +
> >> +     /* disable input aux 1 on this pin */
> >> +     __cs5535_gpio_clear(chip, offset, GPIO_INPUT_AUX1);
> >> +
> >> +     /* disable output */
> >> +     __cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_ENABLE);
> >> +
> >> +     /* enable input */
> >> +     __cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
> >
> > I don't think this is the right place for all of this.  Your earlier
> > email mentioned disabling OUT_AUX{1,2} for outputs, and IN_AUX for
> > inputs.  I'm fine with doing that here, but I don't see why you're
> > also disabling output and enabling input by default.
> 
> I mentioned this in an ealier mail too. When I request the GPIO from
> userspace the direction file always contains "in", so I thought
> this is the standard direction after resetting as I should be in a
> defined state after requesting. But I didn't found anything
> about this in GPIO lib documentation, so I would be fine to change
> this if there is any common default behavoir.

To be honest, I'd have to play around with it a bit before I
knew whether it actually breaks anything or not. I'm not sure if
it would break anything on OLPC, and I don't have any other geode
machines that do anything interesting w/ GPIOs.

Maybe David can clear up whether this behavior is correct from the
userspace GPIO usage standpoint..


> 
> >> -             .ngpio = 28,
> >> +             .ngpio = 32,
> >
> > Since GPIOs 29-31 aren't externally available, and 28 is
> > unavailable anyways, shouldn't we just set ngpio to 28?
> I thought that 32 is in consistency with the datasheet as it always
> talks about 32 GPIO pins.

Fair enough.

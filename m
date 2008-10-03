Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYJCIpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYJCIpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYJCIpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:45:08 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:31625 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751640AbYJCIpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:45:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zW4Fy5IjFD3EgBXeKggJKvhzcxmXiUNicslguUXZMCREV7a9MjF+YM2RDTNVRhcYSOf+FNdH/YGPLwu/poUpP966owJ2iXgCx0LGaUHHDv0+II+HVwg6IfLYpoGCHNbJ9xRJoZuznwdNXiwlyF39VMQnpwK5KulTNIf5UMvw0CU=  ;
X-YMail-OSG: pCpwnrMVM1m5ngdGlbuFl_vhRJhuBIWhdsve_XNEMAlRvrXcrZYexCLKCy1dB5mBPbC1EY4HFqFPUPdnfk_R4iB8LVxJLz0MwxJz4G2JO4TKtBKonA8rw9NL30xbsJkX6_PT7dC3DST_eM3lEfEot1QrfkDry8rBtCXKzUS7xZE_fwrzLQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH/RFC] hardware irq debouncing support
Date: Fri, 3 Oct 2008 01:45:01 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>
References: <200809241251.32606.david-b@pacbell.net> <20081003073816.GB25482@atomide.com>
In-Reply-To: <20081003073816.GB25482@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810030145.02779.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008, Tony Lindgren wrote:
> * David Brownell <david-b@pacbell.net> [080924 22:51]:
> > Hardware IRQ debouncing is common for IRQ controllers which are
> > part of GPIO modules ... they often deal with mechanical switches,
> > buttons, and so forth.  This patch:
> > 
> >  - Provides simple support for that in genirq
> > 
> >  - Includes sample implementations for some Linux systems
> >    which already include non-generic support for this:
> > 
> >      * Atmel SOCs (AT91, AT32 -- the same GPIO module)
> >      * OMAP2/OMAP3 (not quite as simple)
> >
> > 		...
> > Comments?
> > 
> > Having this mechanism in genirq would let boards remove a bunch of
> > nonportable code, and would let drivers like gpio_keys, gpio_mouse,
> > and various touchscreens work more reliably.  It'd also let various
> > SOC-specific MMC and CF card drivers switch over to more standard
> > (and widely understandable) mechanisms.
> 
> Yeah this would nuke bunch of omap specific code for dealing with
> battery covers, MMC slot open etc..

It would be hidden away behind IRQF_DEBOUNCE ... not so much
making the code vanish, as making hardware-specific interfaces
vanish in favor of what seems to be the most popular idiom.

(Regular input GPIOs could be debounced too, but every time
I've noticed debouncing in use, it's coupled to an IRQ.)


> > I'd like to submit such updates for the 2.6.28 merge window, in
> > part to let mainline avoid needing yet another driver-specific
> > programming interface for IRQ debouncing.  (For TWL4030/TPS659x0,
> > as used in most OMAP3 boards including the Gumstix Overo and the
> > BeagleBoard.)
> 
> What's the plan for sysfs_notify event for these switches? Are you
> planning to add something like that to gpiolib?

I'm not sure what you mean -- which particular switches?
If the issue is the MMC card detect switches, that seems
more like an MMC question...

There was discussion of having the gpio_export() code
support notification that way, triggered by interrupts
on IRQ-capable GPIOs, but nobody seems to have wanted
it enough to translate from talk to code.  ;)

- Dave

 
> Tony
> 
> 
> > p.s. Tony and Kevin:  note the locking bugfix in the OMAP2/3 bit.
> 
> Here's my ack for that:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

For the whole patch, I'll presume, not just that locking fix.  ;)

> 
> > 
> > ---
> >  arch/arm/mach-at91/gpio.c    |   13 +++++++++++++
> >  arch/arm/plat-omap/gpio.c    |   15 ++++++++++++++-
> >  arch/avr32/mach-at32ap/pio.c |   14 ++++++++++++++
> >  include/linux/interrupt.h    |    2 ++
> >  include/linux/irq.h          |    3 +++
> >  kernel/irq/manage.c          |   27 +++++++++++++++++++++++++++
> >  6 files changed, 73 insertions(+), 1 deletion(-)
> > 

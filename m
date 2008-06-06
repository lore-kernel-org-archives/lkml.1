Return-Path: <linux-kernel-owner+w=401wt.eu-S1760085AbYFFFbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085AbYFFFbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 01:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYFFFbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 01:31:22 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:34366 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752584AbYFFFbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 01:31:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UIrfW5vptrfnw55/G4Hr1yCqKtgH4IAGvMtmN9XnhZz2iEUkj6zrwM5jQSC4b4VFfh4zVaVZNRMiLr5JFnr+2ARD+3rBspWZoOKQk3S3ag2cmysgHCfykOFjR/5Bclk/vAH0/WkvR7YJntXzUiIowQOGgwYX4EoiNFogNEZ9aw0=  ;
X-YMail-OSG: .SXSKAYVM1l0RJhmdEJ0fRL2OE.T8bRZsoRRRtVFp6hLlXkHyn7QjcT.YjMZjUcTmUmjma.A.iFLZd1e9neqZpcUcvtYJgKgjpwaFCzt4n.RqMKXq_1Nkc9nm.kbgxhQSlw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] generic GPIO parameter API
Date: Thu, 5 Jun 2008 22:29:37 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0806021841500.30390@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0806021841500.30390@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806052229.37143.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008, Guennadi Liakhovetski wrote:
> Hi,
> 
> as far as I understand, the current GPIO API only presents very basic GPIO 
> functionality: direction and level reading and writing. Whereas many GPIO 
> controllers have many further configurable parameters: pull-ups and 
> pull-downs, drive strength, slew rate, etc.

Not at all how I'd describe it.  Those omitted mechanisms are part
of pin configuration, in the same way as function multiplexing is.
(That is, assigning a given pin for use as a GPIO, vs hooking it up
to an I2C, MMC, SPI, LCD, I2S, or memory controller.)

Those mechanisms are highly chip-specific.  Far more so than simple
boolean GPIO mechanisms.  With rare exceptions, they're needed only
in platform-specific board setup code, which is already accessing
lots of platform-specific programming interfaces.  I'm really not
keen on having them become part of the GPIO framework.  The thought
makes me think of trying to swallow a kitchen sink; sorry ...



> And it is desirable to be able  
> to access those features too. Of course, we cannot extent the API with all 
> these possible functions. Would a generic GPIO parameter handling API be 
> desirable?

Were a general interface for this needed, I'd call it a "pin config"
interface (or something similar).

Some platforms would have simple mappings of GPIOs to pins; others
don't, with a GPIO appearing on multiple pins.  (Potentially with
different drive options, etc.)  Such a mapping would make this API
seem quite simple, where it's practical.

A reverse mapping would (pin to GPIO) would likewise not always
be simple, when multiple GPIOs could be routed to a given pin.
It'd be easy to handle the case of a pin that has no GPIO function;
just return an errno instead of a GPIO number.

Of course such a programming interface wouldn't be usable on all
systems ... ones where the configurations are ganged don't have
per-pin parameters like this.  (Examples include cases where one
bit reconfigures several pins, or several parameters of one pin.)


> Like 
> 
> struct gpio_parameter {
> 	char *name;
> 	void *arg;
> 	int (*get)(struct gpio_chip *chip, void *arg, unsigned offset, 
> 			int value);
> 	int (*set)(struct gpio_chip *chip, void *arg, unsigned offset, 
> 			int value);
> };
> 
> int gpio_register_parameter(struct gpio_chip *chip, struct gpio_parameter 
> 				*param);
> struct gpio_parameter *gpio_find_parameter(struct gpio_chip *chip, char 
> 						*name);
> 
> The parameters should be accessible from the kernel and over sysfs, based 
> on the gpio-sysfs interface. Would this be useful?

I don't have any use cases for such an interface myself.

That's the sort of thing I'd expect to do in configfs, if I
needed a userspace solution.

Have you looked at the existing solutions for such stuff?  IMO
the platform code solves this well enough.  Of interest, the
model it uses isn't "pin and attributes", in most cases.  (Or
at least, not directly.)  Examples that come quickly to mind:

  arch/arm/plat-omap/mux.c
  arch/arm/mach-omap1/mux.c
  arch/arm/mach-omap2/mux.c
  include/asm-arm/arch-omap/mux.h
	OMAP2/OMAP3 has a much cleaner hardware design than OMAP1.
	In both cases there's a plethora of pin/ball config options at
	several levels ... family (omap15xx, omap16xx, omap7xx, etc)
	chip (1611, 2430, etc), revision (es2.0, es2.1, etc) etc.

	A conclusion here is that such configuration is rarely used
	outside board setup code.  (And such usage is being removed.)

  arch/arm/mach-at91/gpio.c
  include/asm-arm/arch-at91/gpio.h ... the at91_set_*() calls
  arch/avr32/mach-at32ap/pio.c
  include/asm-avr32/arch-at32ap/portmux.h ... at32_select_*()
	Essentially the same very simple hardware design, on two
	different SOC frameworks.  Again, such configuration is
	rarely used outside board setup (maybe never).

	These don't use symbolic pin config identifiers, though
	some similar code (in u-Boot or some other pre-Linux code)
	uses them to specify pin configurations that affect several
	characteristics (somewhat like the new MFP stuff on PXA).

  arch/arm/mach-pxa/mfp*c
  include/asm-arm/arch-pxa/mfp*h
	Confusing terminology (never talks "pin", always "GPIO"
	even for non-GPIO functions) and what I think of as a
	kind of quirky hardware model ... and this MFP stuff is
	pretty new, I've not seen pxa3xx docs to explain it.
	But again, this is mostly for board setup.

  arch/arm/mach-davinci/mux.c
  include/asm-arm/arch-davinici/mux.h
	Not clear from the source code, but these are all
	ganged config options.  See the chip docs.

It's worth noting that FPGA pin configurations are fancier than
any of these, in all cases I've had occasion to look at, but
such configuration is done when the configuration bitstream is
generated (from Verilog, VHDL, or whatever) not at runtime.

- Dave

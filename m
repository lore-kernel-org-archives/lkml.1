Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab0COKUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 06:20:50 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:44004 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964804Ab0COKUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 06:20:47 -0400
Date: Mon, 15 Mar 2010 11:20:45 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-serial@vger.kernel.org, gregkh@suse.de,
       nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] serial: Add driver for the Altera JTAG UART
Message-ID: <20100315102045.GM21818@distanz.ch>
References: <cover.1267807169.git.klto@zhaw.ch> <15dc056891fb785001073bab4f9a0d0f3bf99af1.1267807169.git.klto@zhaw.ch> <20100312124835.724eb806.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312124835.724eb806.akpm@linux-foundation.org>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-03-12 at 21:48:35 +0100, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri,  5 Mar 2010 17:52:22 +0100
> Tobias Klauser <tklauser@distanz.ch> wrote:
> 
> > Add an UART driver for the JTAG UART component available as a SOPC
> > (System on Programmable Chip) component for Altera FPGAs.
> > 
> > ...
> >
> > --- a/drivers/serial/Kconfig
> > +++ b/drivers/serial/Kconfig
> > @@ -1490,4 +1490,25 @@ config SERIAL_GRLIB_GAISLER_APBUART_CONSOLE
> >  	help
> >  	Support for running a console on the GRLIB APBUART
> >  
> > +config SERIAL_ALTERA_JTAGUART
> > +	bool "Altera JTAG UART support"
> > +	select SERIAL_CORE
> > +	help
> > +	  This driver supports the Altera JTAG UART port.
> > +
> > +config SERIAL_ALTERA_JTAGUART_CONSOLE
> > +	bool "Altera JTAG UART console support"
> > +	depends on SERIAL_ALTERA_JTAGUART
> > +	select SERIAL_CORE_CONSOLE
> > +	help
> > +	  Enable a Altera JTAG UART port to be the system console.
> > +
> > +config SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS
> > +	bool "Bypass output when no connection"
> > +	depends on SERIAL_ALTERA_JTAGUART_CONSOLE
> > +	select SERIAL_CORE_CONSOLE
> > +	help
> > +	  Bypass console output and keep going even if there is no
> > +	  JTAG terminal connection with the host.
> 
> So this driver will be available on all CPU architectures.
> 
> I'm guessing that the hardware _isn't_ available on all CPU
> architectures?  Maybe that's wrong.

In principle it is available on all CPU. I can think of a hardware
component with an Altera FPGA containing this UART. But at the moment no
such implementation is known to me and the UART is only usable on the
nios2 CPU architecture  (which is not in mainline yet - we're planning
to change that, submitting the arch-sepcific drivers is the first step
towards this).

> If this hardware is only available on certain CPUs then we face
> tradeoffs.  By making it universally available, the code gets better
> compile tesst coverage and that can detect problems (usually minor
> ones).  otoh, it can increase your maintenance load a bit, and adds a
> risk that people will ship unusable kernel modules and will see
> increased build times.  I have no particular opinion either way.

I'd like to have this universally available if no one objects. It'd be
nice to get better test coverage and I don't really mind the additional
maintanance load. AFAICS other UART driver are only available on one
single architecture too, so I hoped it would be fine to go the same way
with the altera_{jtag,}uart drivers.

> >  endmenu
> > diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
> > index 5548fe7..6228b6e 100644
> > --- a/drivers/serial/Makefile
> > +++ b/drivers/serial/Makefile
> > @@ -82,3 +82,4 @@ obj-$(CONFIG_KGDB_SERIAL_CONSOLE) += kgdboc.o
> >  obj-$(CONFIG_SERIAL_QE) += ucc_uart.o
> >  obj-$(CONFIG_SERIAL_TIMBERDALE)	+= timbuart.o
> >  obj-$(CONFIG_SERIAL_GRLIB_GAISLER_APBUART) += apbuart.o
> > +obj-$(CONFIG_SERIAL_ALTERA_JTAGUART) += altera_jtaguart.o
> > diff --git a/drivers/serial/altera_jtaguart.c b/drivers/serial/altera_jtaguart.c
> > new file mode 100644
> > index 0000000..f9b49b5
> > --- /dev/null
> > +++ b/drivers/serial/altera_jtaguart.c
> > @@ -0,0 +1,504 @@
> > +/*
> > + * altera_jtaguart.c -- Altera JTAG UART driver
> > + *
> > + * Based on mcf.c -- Freescale ColdFire UART driver
> > + *
> > + * (C) Copyright 2003-2007, Greg Ungerer <gerg@snapgear.com>
> > + * (C) Copyright 2008, Thomas Chou <thomas@wytron.com.tw>
> > + * (C) Copyright 2010, Tobias Klauser <tklauser@distanz.ch>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/module.h>
> > +#include <linux/console.h>
> > +#include <linux/tty.h>
> > +#include <linux/tty_flip.h>
> > +#include <linux/serial.h>
> > +#include <linux/serial_core.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/io.h>
> > +#include <linux/altera_jtaguart.h>
> 
> Does it make sense to put altera_jtaguart.h into include/linux?  Could
> we put it in drivers/serial/?

It is stored in include/linux and not in drivers/serial because we need
to include it from arch/nios2 for the platform device setup. Including
<linux/altera_jtaguart.h> looks nicer than including
"../drivers/serial/altera_jtaguart.h". The same holds true for the
altera_uart driver.

Thanks a lot,
Tobias

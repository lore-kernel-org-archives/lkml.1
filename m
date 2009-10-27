Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZJ0Wc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZJ0Wc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 18:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZJ0Wc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 18:32:57 -0400
Received: from kroah.org ([198.145.64.141]:55112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944AbZJ0Wc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 18:32:56 -0400
Date: Tue, 27 Oct 2009 15:11:21 -0700
From: Greg KH <greg@kroah.com>
To: Bart Hartgers <bart.hartgers@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike McCormack <mikem@ring3k.org>
Subject: Re: [PATCH 1/7] ark3116: (3rd try) Setup some basic infrastructure
 for new ark3116 driver.
Message-ID: <20091027221121.GA20746@kroah.com>
References: <20091025175057.270011110@gmail.com>
 <20091025175316.391430732@gmail.com>
 <20091027174603.GD23368@kroah.com>
 <7eb6a4d80910271435w5ec28f3j4b4424a6d3eeaeaf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7eb6a4d80910271435w5ec28f3j4b4424a6d3eeaeaf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 10:35:31PM +0100, Bart Hartgers wrote:
> 2009/10/27 Greg KH <greg@kroah.com>:
> > On Sun, Oct 25, 2009 at 06:50:58PM +0100, bart.hartgers@gmail.com wrote:
> >> Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
> >> ---
> >> Index: linux-2.6.32-rc4/drivers/usb/serial/ark3116.c
> >> ===================================================================
> >> --- linux-2.6.32-rc4.orig/drivers/usb/serial/ark3116.c        2009-10-18 14:25:02.000000000 +0200
> >> +++ linux-2.6.32-rc4/drivers/usb/serial/ark3116.c     2009-10-18 14:25:14.000000000 +0200
> >> @@ -1,4 +1,6 @@
> >>  /*
> >> + * Copyright (C) 2009 by Bart Hartgers (bart.hartgers+ark3116@gmail.com)
> >> + * Original version:
> >>   * Copyright (C) 2006
> >>   *   Simon Schulz (ark3116_driver <at> auctionant.de)
> >>   *
> >> @@ -6,10 +8,13 @@
> >>   * - implements a driver for the arkmicro ark3116 chipset (vendor=0x6547,
> >>   *   productid=0x0232) (used in a datacable called KQ-U8A)
> >>   *
> >> - * - based on code by krisfx -> thanks !!
> >> - *   (see http://www.linuxquestions.org/questions/showthread.php?p=2184457#post2184457)
> >> + * Supports full modem status lines, break, hardware flow control. Does not
> >> + * support software flow control, since I do not know how to enable it in hw.
> >>   *
> >> - *  - based on logs created by usbsnoopy
> >> + * This driver is a essentially new implementation. I initially dug
> >> + * into the old ark3116.c driver and suddenly realized the ark3116 is
> >> + * a 16450 with a USB interface glued to it. See comments at the
> >> + * bottom of this file.
> >>   *
> >>   * This program is free software; you can redistribute it and/or modify it
> >>   * under the terms of the GNU General Public License as published by the
> >> @@ -19,15 +24,31 @@
> >>
> >>  #include <linux/kernel.h>
> >>  #include <linux/init.h>
> >> +#include <asm/atomic.h>
> >> +#include <linux/ioctl.h>
> >>  #include <linux/tty.h>
> >> +#include <linux/tty_flip.h>
> >>  #include <linux/module.h>
> >>  #include <linux/usb.h>
> >>  #include <linux/usb/serial.h>
> >>  #include <linux/serial.h>
> >> +#include <linux/serial_reg.h>
> >>  #include <linux/uaccess.h>
> >> -
> >> +#include <linux/mutex.h>
> >>
> >>  static int debug;
> >> +/*
> >> + * Version information
> >> + */
> >> +
> >> +#define DRIVER_VERSION "v0.3"
> >> +#define DRIVER_AUTHOR "Bart Hartgers <bart.hartgers+ark3116@gmail.com>"
> >> +#define DRIVER_DESC "USB ARK3116 serial/IrDA driver"
> >> +#define DRIVER_DEV_DESC "ARK3116 RS232/IrDA"
> >> +#define DRIVER_NAME "ark3116"
> >> +
> >> +/* usb timeout of 1 second */
> >> +#define ARK_TIMEOUT (1*HZ)
> >>
> >>  static struct usb_device_id id_table [] = {
> >>       { USB_DEVICE(0x6547, 0x0232) },
> >> @@ -45,6 +66,52 @@ static int is_irda(struct usb_serial *se
> >>       return 0;
> >>  }
> >>
> >> +struct ark3116_private {
> >> +     wait_queue_head_t       delta_msr_wait;
> >> +     struct async_icount     icount;
> >> +     int                     irda;   /* 1 for irda device */
> >> +
> >> +     /* protects hw register updates */
> >> +     struct mutex            lock;
> >> +
> >> +     int                     quot;   /* baudrate divisor */
> >> +     __u8                    lcr;    /* line control register value */
> >> +     __u8                    hcr;    /* handshake control register (0x8)
> >> +                                      * value
> >> +                                      */
> >> +     /* register values - updated asynchronously */
> >> +     atomic_t                mcr;
> >> +     atomic_t                msr;
> >> +     atomic_t                lsr;
> >
> > These don't need to be atomic, please don't use them if they are not
> > needed.  Just use the lock to protect updating them if needed.
> >
> At least lsr and msr are (or will be in patch 6) updated by the
> interrupt_callback. I am happy to add another lock (for
> interrupt-context it would need a spinlock rather than a mutex,
> right?). I am just surprised that is considered cleaner than using
> atomic_t.

Yes, just use a spinlock.  atomic_t are bad as they can be a mess (you
will thrash cachelines multiple times if you hit multiple atomic_t
values, but only once for a spinlock for those same multiple values.)

It's just not worth it for a driver like this, just use a u32 and a
spinlock.

thanks,

greg k-h

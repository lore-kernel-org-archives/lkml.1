Return-Path: <linux-kernel-owner+w=401wt.eu-S932488AbZJ0Vfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbZJ0Vfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932463AbZJ0Vfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:35:32 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:61493 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbZJ0Vf2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:35:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TU4hylmrlaB36LJb/50wUDt0sySLJQuBRTSaITup/9bHd16CWWOTH596lQH2hi1MF2
         fBLaXAD1faPh5gSFJ0CxDbYOuImEnFKKssVoKQxScr24RUoOgK0jlVQ/Ce9anydfvFSr
         aoKRbRjaK/VbYkS2kK3Fo1ofs4FQSFN+keoLU=
MIME-Version: 1.0
In-Reply-To: <20091027174603.GD23368@kroah.com>
References: <20091025175057.270011110@gmail.com>
	 <20091025175316.391430732@gmail.com>
	 <20091027174603.GD23368@kroah.com>
Date: Tue, 27 Oct 2009 22:35:31 +0100
Message-ID: <7eb6a4d80910271435w5ec28f3j4b4424a6d3eeaeaf@mail.gmail.com>
Subject: Re: [PATCH 1/7] ark3116: (3rd try) Setup some basic infrastructure 
	for new ark3116 driver.
From: Bart Hartgers <bart.hartgers@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike McCormack <mikem@ring3k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/27 Greg KH <greg@kroah.com>:
> On Sun, Oct 25, 2009 at 06:50:58PM +0100, bart.hartgers@gmail.com wrote:
>> Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
>> ---
>> Index: linux-2.6.32-rc4/drivers/usb/serial/ark3116.c
>> ===================================================================
>> --- linux-2.6.32-rc4.orig/drivers/usb/serial/ark3116.c        2009-10-18 14:25:02.000000000 +0200
>> +++ linux-2.6.32-rc4/drivers/usb/serial/ark3116.c     2009-10-18 14:25:14.000000000 +0200
>> @@ -1,4 +1,6 @@
>>  /*
>> + * Copyright (C) 2009 by Bart Hartgers (bart.hartgers+ark3116@gmail.com)
>> + * Original version:
>>   * Copyright (C) 2006
>>   *   Simon Schulz (ark3116_driver <at> auctionant.de)
>>   *
>> @@ -6,10 +8,13 @@
>>   * - implements a driver for the arkmicro ark3116 chipset (vendor=0x6547,
>>   *   productid=0x0232) (used in a datacable called KQ-U8A)
>>   *
>> - * - based on code by krisfx -> thanks !!
>> - *   (see http://www.linuxquestions.org/questions/showthread.php?p=2184457#post2184457)
>> + * Supports full modem status lines, break, hardware flow control. Does not
>> + * support software flow control, since I do not know how to enable it in hw.
>>   *
>> - *  - based on logs created by usbsnoopy
>> + * This driver is a essentially new implementation. I initially dug
>> + * into the old ark3116.c driver and suddenly realized the ark3116 is
>> + * a 16450 with a USB interface glued to it. See comments at the
>> + * bottom of this file.
>>   *
>>   * This program is free software; you can redistribute it and/or modify it
>>   * under the terms of the GNU General Public License as published by the
>> @@ -19,15 +24,31 @@
>>
>>  #include <linux/kernel.h>
>>  #include <linux/init.h>
>> +#include <asm/atomic.h>
>> +#include <linux/ioctl.h>
>>  #include <linux/tty.h>
>> +#include <linux/tty_flip.h>
>>  #include <linux/module.h>
>>  #include <linux/usb.h>
>>  #include <linux/usb/serial.h>
>>  #include <linux/serial.h>
>> +#include <linux/serial_reg.h>
>>  #include <linux/uaccess.h>
>> -
>> +#include <linux/mutex.h>
>>
>>  static int debug;
>> +/*
>> + * Version information
>> + */
>> +
>> +#define DRIVER_VERSION "v0.3"
>> +#define DRIVER_AUTHOR "Bart Hartgers <bart.hartgers+ark3116@gmail.com>"
>> +#define DRIVER_DESC "USB ARK3116 serial/IrDA driver"
>> +#define DRIVER_DEV_DESC "ARK3116 RS232/IrDA"
>> +#define DRIVER_NAME "ark3116"
>> +
>> +/* usb timeout of 1 second */
>> +#define ARK_TIMEOUT (1*HZ)
>>
>>  static struct usb_device_id id_table [] = {
>>       { USB_DEVICE(0x6547, 0x0232) },
>> @@ -45,6 +66,52 @@ static int is_irda(struct usb_serial *se
>>       return 0;
>>  }
>>
>> +struct ark3116_private {
>> +     wait_queue_head_t       delta_msr_wait;
>> +     struct async_icount     icount;
>> +     int                     irda;   /* 1 for irda device */
>> +
>> +     /* protects hw register updates */
>> +     struct mutex            lock;
>> +
>> +     int                     quot;   /* baudrate divisor */
>> +     __u8                    lcr;    /* line control register value */
>> +     __u8                    hcr;    /* handshake control register (0x8)
>> +                                      * value
>> +                                      */
>> +     /* register values - updated asynchronously */
>> +     atomic_t                mcr;
>> +     atomic_t                msr;
>> +     atomic_t                lsr;
>
> These don't need to be atomic, please don't use them if they are not
> needed.  Just use the lock to protect updating them if needed.
>
At least lsr and msr are (or will be in patch 6) updated by the
interrupt_callback. I am happy to add another lock (for
interrupt-context it would need a spinlock rather than a mutex,
right?). I am just surprised that is considered cleaner than using
atomic_t.

For mcr I am not sure whether a race between tiocmget and tiocmset is
possible. I didn't see any obvious locking in usb-serial.c or
tty_io.c, that's why I used an atomic_t. Am I missing something?

> Care to respin this series based on the review so far?
Will do somewhere tomorrow. Mike and I are working out how to combine
our patches.

Groeten,
Bart

>
> thanks,
>
> greg k-h
>



-- 
Bart Hartgers - New e-mail: bart.hartgers@gmail.com

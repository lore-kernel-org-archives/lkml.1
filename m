Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZLWQqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZLWQqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 11:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbZLWQqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 11:46:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51575 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbZLWQqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 11:46:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefani Seibold <stefani@seibold.net>, Greg KH <greg@kroah.com>
Subject: Re: [Regression, 2.6.33-rc1->current git] NULL pointer in usb_serial_probe() introduced by the recent kfifo changes
Date: Wed, 23 Dec 2009 17:46:29 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc1-tst; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200912230251.31568.rjw@sisk.pl> <20091223053734.GC22808@kroah.com> <1261555848.22729.41.camel@wall-e>
In-Reply-To: <1261555848.22729.41.camel@wall-e>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912231746.29757.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 December 2009, Stefani Seibold wrote:
> Am Dienstag, den 22.12.2009, 21:37 -0800 schrieb Greg KH:
> > On Wed, Dec 23, 2009 at 02:51:31AM +0100, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > Something like the patch below is necessary to fix a new NULL pointer deref
> > > in usb_serial_probe() that appeared after the recent kfifo changes (in short,
> > > the kfifo changes modified the semantics of kfifo_alloc() that
> > > usb_serial_probe() reiled on).
> > 
> > What semantic changed?  I thought that the kfifo patches came with
> > patches that also fixed up any changed that were needed.  What went
> > wrong here?
> > 
> 
> This one is a new user of the kfifo API, so it forget to port it to the
> new kfifo API.
> 
> Please make the write_fifo in place. Here is my patch to fix the
> regression and full ported version.
> 
> Stefani
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>

Tested-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  drivers/usb/serial/generic.c    |   12 ++++++------
>  drivers/usb/serial/usb-serial.c |    5 ++---
>  include/linux/usb/serial.h      |    3 ++-
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff -u -N -r -p old/drivers/usb/serial/generic.c new/drivers/usb/serial/generic.c
> --- old/drivers/usb/serial/generic.c	2009-12-23 08:54:06.966476248 +0100
> +++ new/drivers/usb/serial/generic.c	2009-12-23 09:06:25.778474708 +0100
> @@ -276,7 +276,7 @@ static int usb_serial_generic_write_star
>  	if (port->write_urb_busy)
>  		start_io = false;
>  	else {
> -		start_io = (kfifo_len(port->write_fifo) != 0);
> +		start_io = (kfifo_len(&port->write_fifo) != 0);
>  		port->write_urb_busy = start_io;
>  	}
>  	spin_unlock_irqrestore(&port->lock, flags);
> @@ -285,7 +285,7 @@ static int usb_serial_generic_write_star
>  		return 0;
>  
>  	data = port->write_urb->transfer_buffer;
> -	count = kfifo_out_locked(port->write_fifo, data, port->bulk_out_size, &port->lock);
> +	count = kfifo_out_locked(&port->write_fifo, data, port->bulk_out_size, &port->lock);
>  	usb_serial_debug_data(debug, &port->dev, __func__, count, data);
>  
>  	/* set up our urb */
> @@ -345,7 +345,7 @@ int usb_serial_generic_write(struct tty_
>  		return usb_serial_multi_urb_write(tty, port,
>  						  buf, count);
>  
> -	count = kfifo_in_locked(port->write_fifo, buf, count, &port->lock);
> +	count = kfifo_in_locked(&port->write_fifo, buf, count, &port->lock);
>  	result = usb_serial_generic_write_start(port);
>  
>  	if (result >= 0)
> @@ -370,7 +370,7 @@ int usb_serial_generic_write_room(struct
>  				(serial->type->max_in_flight_urbs -
>  				 port->urbs_in_flight);
>  	} else if (serial->num_bulk_out)
> -		room = port->write_fifo->size - kfifo_len(port->write_fifo);
> +		room = kfifo_avail(&port->write_fifo);
>  	spin_unlock_irqrestore(&port->lock, flags);
>  
>  	dbg("%s - returns %d", __func__, room);
> @@ -391,7 +391,7 @@ int usb_serial_generic_chars_in_buffer(s
>  		chars = port->tx_bytes_flight;
>  		spin_unlock_irqrestore(&port->lock, flags);
>  	} else if (serial->num_bulk_out)
> -		chars = kfifo_len(port->write_fifo);
> +		chars = kfifo_len(&port->write_fifo);
>  
>  	dbg("%s - returns %d", __func__, chars);
>  	return chars;
> @@ -507,7 +507,7 @@ void usb_serial_generic_write_bulk_callb
>  		if (status) {
>  			dbg("%s - nonzero multi-urb write bulk status "
>  				"received: %d", __func__, status);
> -			kfifo_reset(port->write_fifo);
> +			kfifo_reset_out(&port->write_fifo);
>  		} else
>  			usb_serial_generic_write_start(port);
>  	}
> diff -u -N -r -p old/drivers/usb/serial/usb-serial.c new/drivers/usb/serial/usb-serial.c
> --- old/drivers/usb/serial/usb-serial.c	2009-12-23 08:54:23.204476351 +0100
> +++ new/drivers/usb/serial/usb-serial.c	2009-12-23 09:06:39.664475312 +0100
> @@ -595,8 +595,7 @@ static void port_release(struct device *
>  	usb_free_urb(port->write_urb);
>  	usb_free_urb(port->interrupt_in_urb);
>  	usb_free_urb(port->interrupt_out_urb);
> -	if (!IS_ERR(port->write_fifo) && port->write_fifo)
> -		kfifo_free(port->write_fifo);
> +	kfifo_free(&port->write_fifo);
>  	kfree(port->bulk_in_buffer);
>  	kfree(port->bulk_out_buffer);
>  	kfree(port->interrupt_in_buffer);
> @@ -939,7 +938,7 @@ int usb_serial_probe(struct usb_interfac
>  			dev_err(&interface->dev, "No free urbs available\n");
>  			goto probe_error;
>  		}
> -		if (kfifo_alloc(port->write_fifo, PAGE_SIZE, GFP_KERNEL))
> +		if (kfifo_alloc(&port->write_fifo, PAGE_SIZE, GFP_KERNEL))
>  			goto probe_error;
>  		buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
>  		port->bulk_out_size = buffer_size;
> diff -u -N -r -p old/include/linux/usb/serial.h new/include/linux/usb/serial.h
> --- old/include/linux/usb/serial.h	2009-12-23 08:54:34.368476110 +0100
> +++ new/include/linux/usb/serial.h	2009-12-23 09:06:32.870725683 +0100
> @@ -16,6 +16,7 @@
>  #include <linux/kref.h>
>  #include <linux/mutex.h>
>  #include <linux/sysrq.h>
> +#include <linux/kfifo.h>
>  
>  #define SERIAL_TTY_MAJOR	188	/* Nice legal number now */
>  #define SERIAL_TTY_MINORS	254	/* loads of devices :) */
> @@ -94,7 +95,7 @@ struct usb_serial_port {
>  	unsigned char		*bulk_out_buffer;
>  	int			bulk_out_size;
>  	struct urb		*write_urb;
> -	struct kfifo		*write_fifo;
> +	struct kfifo		write_fifo;
>  	int			write_urb_busy;
>  	__u8			bulk_out_endpointAddress;
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


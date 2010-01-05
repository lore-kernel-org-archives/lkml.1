Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420Ab0AELfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0AELfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237Ab0AELf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:35:29 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33506 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab0AELf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:35:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M7HCkAQ+sP6u9lGjvQy4JyXver0zCckwhHson5J5gATI4iEHpaC3AUhsvrYW8Gg8I6
         SBTQyBHQLGUd53dU8WwZKWGYZ3uelx/YnEQCRnPa2OczVE+bXhAOiKkpy+CxWlvEcgJl
         hyd3U5dRidtMCIURwP3gkJFKSN/1+WDC7WzmU=
Date: Tue, 5 Jan 2010 12:35:25 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Johan Hovold <jhovold@gmail.com>, Pete Zaitcev <zaitcev@redhat.com>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB: serial: kfifo_len locking
Message-ID: <20100105113525.GA19371@localhost>
References: <20100104174352.GA26606@localhost>
 <1262632804.4814.17.camel@wall-e>
 <20100105004344.082bb69f@redhat.com>
 <20100105110418.GA10442@localhost>
 <1262689759.21020.2.camel@wall-e>
 <20100105111401.GB10442@localhost>
 <1262690734.22009.3.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262690734.22009.3.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Which does not make any sense at all. Bad merge? What do you say Greg?
> > > 
> > > I don't know where is your problem? This are two different functions
> > > usb_serial_generic_write_room() and usb_serial_generic_chars_in_buffer()
> > 
> > Exactly my point. 
> > 
> > The drain patch needed to modify chars_in_buffer, but the patch in Greg's
> > tree modifies write_room instead (which does not make sense and was
> > neither part of the submitted patch).
> > 
> Sorry, but i am not sure if i the right address about your complains.
> The only thing i have done in the usb serial driver is the port to the
> new kfifo API. This is the original patch i had posted:

The drain patch merge was a side-track and you were CC:d as you
were part of the original thread. 

You did however remove the locking on kfifo_len that the original author
had put there with the exact patch you're quoting:

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

Here's the change. The fifo used to be protected by a lock, but is no
longer.

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
> As you can see i didn't changed noting about this drain thing.

Never say you did.

/Johan


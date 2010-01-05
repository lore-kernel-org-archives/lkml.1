Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238Ab0AEMBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0AEMBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 07:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967Ab0AEMBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 07:01:30 -0500
Received: from www84.your-server.de ([213.133.104.84]:47463 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0AEMB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 07:01:29 -0500
Subject: Re: USB: serial: kfifo_len locking
From: Stefani Seibold <stefani@seibold.net>
To: Johan Hovold <jhovold@gmail.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <20100105113525.GA19371@localhost>
References: <20100104174352.GA26606@localhost>
	 <1262632804.4814.17.camel@wall-e> <20100105004344.082bb69f@redhat.com>
	 <20100105110418.GA10442@localhost> <1262689759.21020.2.camel@wall-e>
	 <20100105111401.GB10442@localhost> <1262690734.22009.3.camel@wall-e>
	 <20100105113525.GA19371@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 05 Jan 2010 13:01:21 +0100
Message-ID: <1262692881.23577.15.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 05.01.2010, 12:35 +0100 schrieb Johan Hovold:
> > > > > Which does not make any sense at all. Bad merge? What do you say Greg?
> > > > 
> > > > I don't know where is your problem? This are two different functions
> > > > usb_serial_generic_write_room() and usb_serial_generic_chars_in_buffer()
> > > 
> > > Exactly my point. 
> > > 
> > > The drain patch needed to modify chars_in_buffer, but the patch in Greg's
> > > tree modifies write_room instead (which does not make sense and was
> > > neither part of the submitted patch).
> > > 
> > Sorry, but i am not sure if i the right address about your complains.
> > The only thing i have done in the usb serial driver is the port to the
> > new kfifo API. This is the original patch i had posted:
> 
> The drain patch merge was a side-track and you were CC:d as you
> were part of the original thread. 
> 
> You did however remove the locking on kfifo_len that the original author
> had put there with the exact patch you're quoting:
> 
> > diff -u -N -r -p old/drivers/usb/serial/generic.c new/drivers/usb/serial/generic.c
> > --- old/drivers/usb/serial/generic.c	2009-12-23 08:54:06.966476248 +0100
> > +++ new/drivers/usb/serial/generic.c	2009-12-23 09:06:25.778474708 +0100
> > @@ -276,7 +276,7 @@ static int usb_serial_generic_write_star
> >  	if (port->write_urb_busy)
> >  		start_io = false;
> >  	else {
> > -		start_io = (kfifo_len(port->write_fifo) != 0);
> > +		start_io = (kfifo_len(&port->write_fifo) != 0);
> >  		port->write_urb_busy = start_io;
> >  	}
> >  	spin_unlock_irqrestore(&port->lock, flags);
> > @@ -285,7 +285,7 @@ static int usb_serial_generic_write_star
> >  		return 0;
> >  
> >  	data = port->write_urb->transfer_buffer;
> > -	count = kfifo_out_locked(port->write_fifo, data, port->bulk_out_size, &port->lock);
> > +	count = kfifo_out_locked(&port->write_fifo, data, port->bulk_out_size, &port->lock);
> >  	usb_serial_debug_data(debug, &port->dev, __func__, count, data);
> >  
> >  	/* set up our urb */
> > @@ -345,7 +345,7 @@ int usb_serial_generic_write(struct tty_
> >  		return usb_serial_multi_urb_write(tty, port,
> >  						  buf, count);
> >  
> > -	count = kfifo_in_locked(port->write_fifo, buf, count, &port->lock);
> > +	count = kfifo_in_locked(&port->write_fifo, buf, count, &port->lock);
> >  	result = usb_serial_generic_write_start(port);
> >  
> >  	if (result >= 0)
> > @@ -370,7 +370,7 @@ int usb_serial_generic_write_room(struct
> >  				(serial->type->max_in_flight_urbs -
> >  				 port->urbs_in_flight);
> >  	} else if (serial->num_bulk_out)
> > -		room = port->write_fifo->size - kfifo_len(port->write_fifo);
> > +		room = kfifo_avail(&port->write_fifo);
> >  	spin_unlock_irqrestore(&port->lock, flags);
> >  
> >  	dbg("%s - returns %d", __func__, room);
> > @@ -391,7 +391,7 @@ int usb_serial_generic_chars_in_buffer(s
> >  		chars = port->tx_bytes_flight;
> >  		spin_unlock_irqrestore(&port->lock, flags);
> >  	} else if (serial->num_bulk_out)
> > -		chars = kfifo_len(port->write_fifo);
> > +		chars = kfifo_len(&port->write_fifo);
> 
> Here's the change. The fifo used to be protected by a lock, but is no
> longer.
> 

I posted yesterday a patch to this thread. It would be great if you read
and check this patch before complaining again!!!!

> Never say you did.
> 

Sorry, i had no real idea what is your problem, if this is not what you
want. As i mentioned i posted to you yesterday a fix for the possible
kfifo_len() bug, but i didn't get a response if this is fixing your
problem. Again the patch:

diff -u -N -r  -p linux-2.6.33-rc2.orig/drivers/usb/serial/generic.c linux-2.6.33-rc2.new/drivers/usb/serial/generic.c
--- linux-2.6.33-rc2.orig/drivers/usb/serial/generic.c	2009-12-27 23:37:03.566060210 +0100
+++ linux-2.6.33-rc2.new/drivers/usb/serial/generic.c	2010-01-04 20:15:38.023351711 +0100
@@ -386,12 +386,12 @@ int usb_serial_generic_chars_in_buffer(s
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (serial->type->max_in_flight_urbs) {
-		spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&port->lock, flags);
+	if (serial->type->max_in_flight_urbs)
 		chars = port->tx_bytes_flight;
-		spin_unlock_irqrestore(&port->lock, flags);
-	} else if (serial->num_bulk_out)
+	else if (serial->num_bulk_out)
 		chars = kfifo_len(&port->write_fifo);
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	dbg("%s - returns %d", __func__, chars);
 	return chars;

This patch should solve the possible race (if there is one). With this
patch all kfifo_... access are locked by the port->lock spinlock. If
this is what you want i will posted it as a bug fix to andrew.

Stefani



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111Ab0AELJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0AELJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711Ab0AELJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:09:29 -0500
Received: from www84.your-server.de ([213.133.104.84]:57447 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab0AELJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:09:28 -0500
Subject: Re: USB: serial: kfifo_len locking
From: Stefani Seibold <stefani@seibold.net>
To: Johan Hovold <jhovold@gmail.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <20100105110418.GA10442@localhost>
References: <20100104174352.GA26606@localhost>
	 <1262632804.4814.17.camel@wall-e> <20100105004344.082bb69f@redhat.com>
	 <20100105110418.GA10442@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 05 Jan 2010 12:09:19 +0100
Message-ID: <1262689759.21020.2.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 05.01.2010, 12:04 +0100 schrieb Johan Hovold:
> > This actually was a side effect of the "byte lost on close" patch
> > that I submitted, it should be in Greg's tree. The relevant part goes
> > like this:
> > diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
> > index f1ea3a3..3372faa 100644
> > --- a/drivers/usb/serial/generic.c
> > +++ b/drivers/usb/serial/generic.c
> > @@ -386,12 +386,15 @@ int usb_serial_generic_chars_in_buffer(struct tty_struct *tty)
> >  
> >  	dbg("%s - port %d", __func__, port->number);
> >  
> > +	spin_lock_irqsave(&port->lock, flags);
> >  	if (serial->type->max_in_flight_urbs) {
> > -		spin_lock_irqsave(&port->lock, flags);
> >  		chars = port->tx_bytes_flight;
> > -		spin_unlock_irqrestore(&port->lock, flags);
> > -	} else if (serial->num_bulk_out)
> > -		chars = kfifo_len(&port->write_fifo);
> > +	} else if (serial->num_bulk_out) {
> > +		/* This overcounts badly, but is good enough for drain wait. */
> > +		chars = __kfifo_len(port->write_fifo);
> > +		chars += port->write_urb_busy * port->bulk_out_size;
> > +	}
> > +	spin_unlock_irqrestore(&port->lock, flags);
> >  
> >  	dbg("%s - returns %d", __func__, chars);
> >  	return chars;
> 
> That is indeed what you submitted on Dec 7, but this is what is in
> Greg's tree:
> 
> http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=usb/usb-serial-mct_usb232-add-drain-on-close.patch;h=c464f1a82e93df0dd41762a8cb33b0b22e90cdd7;hb=1ea72e7c40b239c6b6f88a4993196be66fc3d892
> 
> 38 --- a/drivers/usb/serial/generic.c
> 39 +++ b/drivers/usb/serial/generic.c
> 40 @@ -369,8 +369,11 @@ int usb_serial_generic_write_room(struct
> 41                         room = port->bulk_out_size *
> 42                                 (serial->type->max_in_flight_urbs -
> 43                                  port->urbs_in_flight);
> 44 -       } else if (serial->num_bulk_out)
> 45 +       } else if (serial->num_bulk_out) {
> 46 +               /* This overcounts badly, but is good enough for drain wait. */
> 47                 room = kfifo_avail(&port->write_fifo);
> 48 +               room += port->write_urb_busy * port->bulk_out_size;
> 49 +       }
> 50         spin_unlock_irqrestore(&port->lock, flags);
> 51  
> 52         dbg("%s - returns %d", __func__, room);
> 
> 
> Which does not make any sense at all. Bad merge? What do you say Greg?
> 

I don't know where is your problem? This are two different functions
usb_serial_generic_write_room() and usb_serial_generic_chars_in_buffer()

Stefani



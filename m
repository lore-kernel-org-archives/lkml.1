Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZLWQP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZLWQP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 11:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZLWQPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 11:15:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51490 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbZLWQPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 11:15:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Regression, 2.6.33-rc1->current git] NULL pointer in usb_serial_probe() introduced by the recent kfifo changes
Date: Wed, 23 Dec 2009 17:16:40 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc1-tst; KDE/4.3.3; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0912222304090.14449-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912222304090.14449-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912231716.41004.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 December 2009, Alan Stern wrote:
> On Wed, 23 Dec 2009, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > Something like the patch below is necessary to fix a new NULL pointer deref
> > in usb_serial_probe() that appeared after the recent kfifo changes (in short,
> > the kfifo changes modified the semantics of kfifo_alloc() that
> > usb_serial_probe() reiled on).
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> >  drivers/usb/serial/usb-serial.c |   10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6/drivers/usb/serial/usb-serial.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/usb/serial/usb-serial.c
> > +++ linux-2.6/drivers/usb/serial/usb-serial.c
> > @@ -595,8 +595,10 @@ static void port_release(struct device *
> >  	usb_free_urb(port->write_urb);
> >  	usb_free_urb(port->interrupt_in_urb);
> >  	usb_free_urb(port->interrupt_out_urb);
> > -	if (!IS_ERR(port->write_fifo) && port->write_fifo)
> > +	if (port->write_fifo) {
> >  		kfifo_free(port->write_fifo);
> > +		kfree(port->write_fifo);
> > +	}
> >  	kfree(port->bulk_in_buffer);
> >  	kfree(port->bulk_out_buffer);
> >  	kfree(port->interrupt_in_buffer);
> > @@ -939,6 +941,12 @@ int usb_serial_probe(struct usb_interfac
> >  			dev_err(&interface->dev, "No free urbs available\n");
> >  			goto probe_error;
> >  		}
> > +		port->write_fifo = kzalloc(sizeof(struct kfifo), GFP_KERNEL);
> > +		if (!port->write_fifo) {
> > +			dev_err(&interface->dev,
> > +				"Couldn't allocate write_fifo\n");
> > +			goto probe_error;
> > +		}
> >  		if (kfifo_alloc(port->write_fifo, PAGE_SIZE, GFP_KERNEL))
> >  			goto probe_error;
> >  		buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
> 
> Although this would mean further changes elsewhere, doesn't it make
> more sense to embed the struct kfifo directly in the usb_serial_port
> structure instead of allocating it dynamically?

I guess it would, but I wanted to avoid making any further changes.

Rafael

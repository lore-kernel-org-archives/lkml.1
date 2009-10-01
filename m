Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbZJBARq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbZJBARq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 20:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZJBARq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 20:17:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbZJBARp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 20:17:45 -0400
Date: Thu, 1 Oct 2009 16:53:08 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, stable@kernel.org
Subject: Re: patch usb-serial-straighten-out-serial_open.patch added to
 2.6.31-stable tree
Message-ID: <20091001235308.GA20497@suse.de>
References: <20091001220412.853C248902@coco.kroah.org>
 <200910020140.30677.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910020140.30677.s.L-H@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 01:40:28AM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Friday 02 October 2009, gregkh@suse.de wrote:
> > 
> > This is a note to let you know that we have just queued up the patch titled
> > 
> >     Subject: usb-serial: straighten out serial_open
> > 
> > to the 2.6.31-stable tree.  Its filename is
> > 
> >     usb-serial-straighten-out-serial_open.patch
> 
> This patch breaks compilation of the current 2.6.31 -stable queue:
> [...]
>   LD [M]  drivers/usb/mon/usbmon.o                                                               
>   LD      drivers/usb/serial/built-in.o                                                          
>   CC [M]  drivers/usb/serial/usb-serial.o                                                        
> drivers/usb/serial/usb-serial.c: In function 'serial_open':                                      
> drivers/usb/serial/usb-serial.c:272: error: 'flip' undeclared (first use in this function)       
> drivers/usb/serial/usb-serial.c:272: error: (Each undeclared identifier is reported only once    
> drivers/usb/serial/usb-serial.c:272: error: for each function it appears in.)                    
> make[6]: *** [drivers/usb/serial/usb-serial.o] Error 1                                           
> make[5]: *** [drivers/usb/serial] Error 2                                                        
> make[4]: *** [drivers/usb] Error 2                                                               
> make[3]: *** [drivers] Error 2                                                                   
> [...]
> 
> > From 320348c8d5c9b591282633ddb8959b42f7fc7a1c Mon Sep 17 00:00:00 2001
> > From: Alan Stern <stern@rowland.harvard.edu>
> > Date: Tue, 1 Sep 2009 11:39:59 -0400
> > Subject: usb-serial: straighten out serial_open
> > 
> > From: Alan Stern <stern@rowland.harvard.edu>
> > 
> > commit 320348c8d5c9b591282633ddb8959b42f7fc7a1c upstream.
> > 
> > This patch (as1291) removes a bunch of code from serial_open(), things
> > that were rendered unnecessary by earlier patches.  A missing spinlock
> > is added to protect port->port.count, which needs to be incremented
> > even if the open fails but not if the tty has gotten a hangup.  The
> > test for whether the hardware has been initialized, based on the use
> > count, is replaced by a more transparent test of the
> > ASYNCB_INITIALIZED bit in the port flags.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/usb/serial/usb-serial.c |   59 ++++++++++++++--------------------------
> >  1 file changed, 22 insertions(+), 37 deletions(-)
> > 
> > --- a/drivers/usb/serial/usb-serial.c
> > +++ b/drivers/usb/serial/usb-serial.c
> > @@ -245,55 +245,40 @@ static int serial_install(struct tty_dri
> >  	return retval;
> >  }
> >  
> > -static int serial_open (struct tty_struct *tty, struct file *filp)
> > +static int serial_open(struct tty_struct *tty, struct file *filp)
> >  {
> > -	struct usb_serial *serial;
> > -	struct usb_serial_port *port;
> > -	int retval = 0;
> > -	int first = 0;
> > -
> > -	port = tty->driver_data;
> > -	serial = port->serial;
> > +	struct usb_serial_port *port = tty->driver_data;
> > +	struct usb_serial *serial = port->serial;
> > +	int retval;
> >  
> >  	dbg("%s - port %d", __func__, port->number);
> >  
> > -	if (mutex_lock_interruptible(&port->mutex))
> > -		return -ERESTARTSYS;
> > -
> > -	++port->port.count;
> > +	spin_lock_irq(&port->port.lock);
> > +	if (!tty_hung_up_p(filp))
> > +		++port->port.count;
> > +	spin_unlock_irq(&port->port.lock);
> >  	tty_port_tty_set(&port->port, tty);
> >  
> > -	/* If the console is attached, the device is already open */
> > -	if (port->port.count == 1 && !port->console) {
> > -		first = 1;
> > +	/* Do the device-specific open only if the hardware isn't
> > +	 * already initialized.
> > +	 */
> > +	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
> > +		if (mutex_lock_interruptible(&port->mutex))
> > +			return -ERESTARTSYS;
> >  		mutex_lock(&serial->disc_mutex);
> > -
> > -		/* only call the device specific open if this
> > -		 * is the first time the port is opened */
> > -		retval = serial->type->open(tty, port, filp);
> > -		if (retval)
> > -			goto bailout_module_put;
> > +		if (serial->disconnected)
> > +			retval = -ENODEV;
> > +		else
> > +			retval = port->serial->type->open(tty, port, flip);
> 
> s/flip/filp/

Sorry, yes, I made the change already to the queue, odd that the patch
that went out was wrong.  My fault in the backporting of this.

greg k-h

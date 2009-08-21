Return-Path: <linux-kernel-owner+w=401wt.eu-S932723AbZHUUwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbZHUUwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932665AbZHUUw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:52:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37677 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932480AbZHUUw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:52:28 -0400
Date: Fri, 21 Aug 2009 16:52:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Bruno =?ISO-8859-14?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090821194252.582ef5cd@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0908211534140.4029-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009, Alan Cox wrote:

> > 	serial_open()				/* first user */
> > 		tty_port_block_til_ready()	/* returns immediately */
> > 		serial->type->open()		/* initializes the hardware */
> > 
> > 	serial_open()				/* second user */
> > 		tty_port_block_til_ready()	/* blocks */
> 
> If the first user succeeded then second should open immediately as the use
> count is >= 1 already. It is re-opening the open device, unless the
> hangup occurs first.

What about protecting the use counter?  In tty_port.c it's always
protected by port->lock, but not in serial_open().  Is that a mistake?

How are hangups synchronized with opens?  Do you rely on the BKL?  
Suppose a hangup occurs, and do_tty_hangup() marks all the existing
file references with hung_up_tty_fops.  But before it gets around to
calling tty->ops->hangup(), another open occurs.  I can't imagine the
BKL will prevent this; do_tty_hangup() is so complex it must sleep
somewhere.  Thus it's possible for __tty_open() to call
tty->ops->open() before tty->ops->hangup() is called, which means the
open will succeed.

The when the driver's hangup routine finally gets around to calling
tty_port_hangup(), port->count will be set back to 0.  So now we've got
an uncounted open file.


> Most drivers tend to look like
> 
> 	open
> 		test ASYNC_INITIALIZED
> 			init hardware
> 			[either in full or clean up partial]
> 			set ASYNC_INITIALIZED)
> 		any other alloc/counter magic
> 		tty->private_data = my stuff

tty->driver_data, right?

> 		block_til_ready
> 	return ok/error
> 
> 	close
> 		if (hung_up)
> 			return
> 		if (tty->driver_data == NULL)
> 			return
> 		counts

Is "counts" shorthand for:

		if (tty_port_close_start(...) == 0)
			return
?

> 		clean up resources
> 		if (last && test_clear INITIALIZED)

How do you check for "last"?  Doesn't the fact that we are here mean 
that there are no remaining open references?

> 			deinit-hardware
> 	return ok/error
> 
> 	hangup
> 		if (initialized & test_clear INITIALIZED) {

What is "initialized" supposed to be?  Isn't INITIALIZED enough?

> 			deinit hardware
> 		}
> 
> which is where I was trying to get the USB code.

It doesn't look as though we're too far away.  Thanks for the detailed 
explanations.

Alan Stern

P.S.: Consider this code in tty_port_block_til_ready():

	/* if non-blocking mode is set we can pass directly to open unless
	   the port has just hung up or is in another error state */
	if ((filp->f_flags & O_NONBLOCK) ||
			(tty->flags & (1 << TTY_IO_ERROR))) {
		port->flags |= ASYNC_NORMAL_ACTIVE;
		return 0;
	}

The comment doesn't agree with the logic of the test.  Which is wrong?


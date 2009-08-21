Return-Path: <linux-kernel-owner+w=401wt.eu-S932741AbZHUXQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbZHUXQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 19:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932533AbZHUXQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 19:16:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52246 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932494AbZHUXQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 19:16:10 -0400
Date: Sat, 22 Aug 2009 00:16:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bruno =?ISO-8859-14?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090822001637.72a08078@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0908211534140.4029-100000@iolanthe.rowland.org>
References: <20090821194252.582ef5cd@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0908211534140.4029-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What about protecting the use counter?  In tty_port.c it's always
> protected by port->lock, but not in serial_open().  Is that a mistake?

Ah good an easy question to begin with

Yes it is in error.

> How are hangups synchronized with opens?  Do you rely on the BKL? 

In a sense this is up the driver. hangup can only occur from two paths

1.	User triggered hangup (requires open has completed, user has an
fd)

2.	Driver calls hangup from its interrupt or other similar event
handler

The core of both hangup and open are still BKL protected against
one another (ugly - wants fixing), release_one_dev() liekwise. This is
probably inadequate as they may well sleep in various spots

> Suppose a hangup occurs, and do_tty_hangup() marks all the existing
> file references with hung_up_tty_fops.  But before it gets around to
> calling tty->ops->hangup(), another open occurs.  I can't imagine the
> BKL will prevent this; do_tty_hangup() is so complex it must sleep
> somewhere.  Thus it's possible for __tty_open() to call
> tty->ops->open() before tty->ops->hangup() is called, which means the
> open will succeed.

I don't think that is any different (logically) to the new open occuring
just after the hangup. In other words I agree its a race but I am not
sure it is of itself an actual problem

> The when the driver's hangup routine finally gets around to calling
> tty_port_hangup(), port->count will be set back to 0.  So now we've got
> an uncounted open file.

But that would be and I don't immediately see anything preventing it from
happening. Or if it can't happen there is a good deal of luck rather than
judgement involved 8)

The hangup path doesn't sleep until it has set TTY_HUPPED and I think
until the tty_kref_put calls are done. The ops->close/hangup can
certainly sleep however and would be the first point that hangup sleeps.
So it is I think safe that way - but not at all a good design at the
moment.

On the open side tty_reopen can sleep as can tty_init_dev.

block_til_ready ought to be safe as of itself and is coded to avoid the
problem. It checks tty_hung_up_p under the port lock before adjusting the
port count. hangup takes the same lock when adjusting the port count.

tty_hung_up_p relies on the filp operations changes and BKL

So I think the tty_port parts work (half through luck) but the serial.c
bits may well not and without the BKL it would fall apart totally at the
moment.

> 
> 
> > Most drivers tend to look like
> > 
> > 	open
> > 		test ASYNC_INITIALIZED
> > 			init hardware
> > 			[either in full or clean up partial]
> > 			set ASYNC_INITIALIZED)
> > 		any other alloc/counter magic
> > 		tty->private_data = my stuff
> 
> tty->driver_data, right?

Yes sorry

> 
> > 		block_til_ready
> > 	return ok/error
> > 
> > 	close
> > 		if (hung_up)
> > 			return
> > 		if (tty->driver_data == NULL)
> > 			return
> > 		counts
> 
> Is "counts" shorthand for:
> 
> 		if (tty_port_close_start(...) == 0)
> 			return

Usually - but not all drivers use tty_port_close_start yet, some still
open code all the open/close posix logic or some variant of it

> ?
> 
> > 		clean up resources
> > 		if (last && test_clear INITIALIZED)
> 
> How do you check for "last"?  Doesn't the fact that we are here mean 
> that there are no remaining open references?

It means there are no remaining file references to the handle, but you
may have multiple file handles referencing the same tty

(eg

	open /dev/ttyS0
	open /dev/ttyS0

produces two handles to one tty. The tty closes at the hardware level
when the last file handle reference goes away. This is important because
of open /dev/tty, and the like)

ie we have a count of users of the file, which on hitting zero calls
tty_release_dev and eventually the port close method. we have a separate
count above that of opens to the port which we drop by one for each final
close of a file handle.

> 
> > 			deinit-hardware
> > 	return ok/error
> > 
> > 	hangup
> > 		if (initialized & test_clear INITIALIZED) {
> 
> What is "initialized" supposed to be?  Isn't INITIALIZED enough?

It depends on the driver. I believe for anything using the helpers it is
enough but I may be wrong.

> P.S.: Consider this code in tty_port_block_til_ready():
> 
> 	/* if non-blocking mode is set we can pass directly to open unless
> 	   the port has just hung up or is in another error state */
> 	if ((filp->f_flags & O_NONBLOCK) ||
> 			(tty->flags & (1 << TTY_IO_ERROR))) {
> 		port->flags |= ASYNC_NORMAL_ACTIVE;
> 		return 0;
> 	}
> 
> The comment doesn't agree with the logic of the test.  Which is wrong?

The code and comment were copied from the original drivers (and occur in
several places ;))

The intended logic is

	if O_NONBLOCK is set
		succeed immediately
	if there is a hangup (or other pending error)
		succeed immediately

So if this occurs

	open
		hangup

we don't do

	open
		hangup
	block for carrier
	twiddle thumbs ...


but do

	open
		hangup
	ok fd = 4
	read fd
		-EIO

(ditto for a hangup from say unplugging the hardware where it would
 make no sense to wait for the carrier)

 
--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds

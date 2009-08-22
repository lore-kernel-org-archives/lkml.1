Return-Path: <linux-kernel-owner+w=401wt.eu-S933181AbZHVCaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbZHVCaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 22:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbZHVCaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 22:30:23 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51032 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933141AbZHVCaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 22:30:22 -0400
Date: Fri, 21 Aug 2009 22:30:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Bruno =?ISO-8859-14?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090822001637.72a08078@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0908212214300.31042-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Aug 2009, Alan Cox wrote:

> > What about protecting the use counter?  In tty_port.c it's always
> > protected by port->lock, but not in serial_open().  Is that a mistake?
> 
> Ah good an easy question to begin with
> 
> Yes it is in error.

Okay, I'll fix it.

> The core of both hangup and open are still BKL protected against
> one another (ugly - wants fixing), release_one_dev() liekwise. This is
> probably inadequate as they may well sleep in various spots

Would you consider ideas for changing the protection to something else?  
I don't have anything in mind at the moment -- I need to study the code
some more to understand it better.  But eventually a possibility may
suggest itself.

> > > 		clean up resources
> > > 		if (last && test_clear INITIALIZED)
> > 
> > How do you check for "last"?  Doesn't the fact that we are here mean 
> > that there are no remaining open references?
> 
> It means there are no remaining file references to the handle, but you
> may have multiple file handles referencing the same tty

So basically this amounts to testing whether port->count == 0?  But 
isn't that already implicit when tty_port_close_start() returns 0?

It sounds like this is another little thingy needed only by drivers
that don't use the new helpers.

> > P.S.: Consider this code in tty_port_block_til_ready():
> > 
> > 	/* if non-blocking mode is set we can pass directly to open unless
> > 	   the port has just hung up or is in another error state */
> > 	if ((filp->f_flags & O_NONBLOCK) ||
> > 			(tty->flags & (1 << TTY_IO_ERROR))) {
> > 		port->flags |= ASYNC_NORMAL_ACTIVE;
> > 		return 0;
> > 	}
> > 
> > The comment doesn't agree with the logic of the test.  Which is wrong?
> 
> The code and comment were copied from the original drivers (and occur in
> several places ;))
> 
> The intended logic is
> 
> 	if O_NONBLOCK is set
> 		succeed immediately
> 	if there is a hangup (or other pending error)
> 		succeed immediately

Got it -- the comment is wrong.  It should say something like:

	/* If non-blocking mode is set or the port is in an error state
	 * then we can return directly; tty_open() will handle everything.
	 */

Thanks,

Alan Stern




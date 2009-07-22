Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbZGVSV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbZGVSV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 14:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZGVSV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 14:21:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44365 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752944AbZGVSV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 14:21:26 -0400
Date: Wed, 22 Jul 2009 14:21:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Daniel Mack <daniel@caiaq.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
In-Reply-To: <20090722171707.5fa39803@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0907221352340.3918-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009, Alan Cox wrote:

> > >           free resources
> > >           wake any pending openers
> >
> > Where exactly is the code that wakes the other openers?
>
> tty_port_close_end wakes port->open_wait
> 
> if another opener was blocked during the hangup they then exit
> tty_blocked_until_ready and error

Hmmm.  serial_open() doesn't call tty_port_block_til_ready() until just 
before it returns.  Shouldn't it do this before locking port->mutex and 
incrementing port->port.count?

In fact, should usb-serial.c be touching port->port.count at all?  Is 
it reserved for use by the tty core?

> > There's an obvious race here between hangup and close.  The assignment 
> > of hung_up_tty_fops to filp->f_op is protected by the BKL and not much 
> > else.  Does the code in tty_release_dev() check to see whether this 
> > assignment has been made before calling tty->ops->close()?  It doesn't 
> > like like it to me.  With the wrong timing, you could end up telling 
> > the device driver to stop the uart twice.
> 
> The core hangup and close code are interlocked (now - didn't use to be).

But are they interlocked enough?

> > > The tty notion of "open" is really open->hangup or open->close. Once the
> > > hangup occurs you may have a file handle to a tty object but it doesn't
> > > talk to hardware.
> > 
> > But it still talks to the device driver via tty_release_dev's call to 
> > tty->ops->close.  How is the driver supposed to know that this method 
> > call shouldn't talk to the hardware?
> 
> tty_hung_up_p() will be true

With no synchronization.  So there's still a race.

Why doesn't tty_release_dev() test tty_hung_up_p() before calling
tty->ops->close() instead of making the driver do it?

> > In fact, what point is there in making the call at all?  Once the 
> > hangup has occurred, the driver shouldn't do _anything_ when the 
> > corresponding release happens.  As you say, the notion is open->hangup 
> > or open->close, not open->(hangup followed by close).
> 
> Beats me - not something I designed. However the driver would always need
> to be aware of it because the following can occur
> 
> 			CPU1			CPU2
> 			close begins
> 						hangup
> 						update ops
> 			close handler runs
> 
> The tty_port code handles that internally, but has to handle it anyway.

This is the race I have been talking about.

> There are similar issues with all the other calls if they are pending and
> I've not even begun to tackle them yet as they are basically
> inconveniences only. Also because I'm still hoping someone will implement
> revoke() on Linux and do all the hard work for me.

:-)

Alan Stern




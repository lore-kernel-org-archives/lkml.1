Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZHURjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZHURjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZHURjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:39:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39502 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752139AbZHURjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:39:53 -0400
Date: Fri, 21 Aug 2009 13:39:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Bruno =?ISO-8859-14?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090821164843.639aedaf@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0908211326120.4029-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009, Alan Cox wrote:

> > Alan, related to this problem is the fact that usb_serial_driver
> > doesn't include a "hangup" method.  I'm not sure that making
> > serial_hangup() call serial_do_down() is correct, but if it is then
> > shouldn't we call port->serial->type->open() afterwards?  Otherwise the
> > lower driver can't know that the port is still open.
> 
> After a hangup the port isn't open (at the physical level anyway). It may
> be re-opened by another open() call later

Or, oddly enough, another open() call earlier...

> but the original user lost
> access to it and shouldn't touch the h/w post hangup completion.

Then surely serial_open() should call serial->type->open() _after_ 
tty_port_block_til_ready(), not before.

> > Furthermore, shouldn't we check ASYNCB_INITIALIZED in serial_close()?
> 
> Possibly - I was in the middle of debugging the newest bits when Linus
> annoyed me. Certainly there are issues in the current code if you get
> a hangup while waiting for open to complete. I fixed that in the patches
> I sent Greg but didn't finish debugging it.

Well, yes.  The way it is now, you get:

	serial_open()				/* first user */
		serial->type->open()		/* initializes the hardware */
		tty_port_block_til_ready()	/* returns immediately */

	serial_open()				/* second user */
		serial->type->open skipped because the port
			is already open
		tty_port_block_til_ready()	/* blocks */

	serial_hangup()				/* first connection drops */
		serial_do_down()
			serial->type-close()	/* resets the hardware */

		... tty_port_block_til_ready() returns

Now the second user tries to do stuff but the hardware isn't ready.  
Instead this should go:

	serial_open()				/* first user */
		tty_port_block_til_ready()	/* returns immediately */
		serial->type->open()		/* initializes the hardware */

	serial_open()				/* second user */
		tty_port_block_til_ready()	/* blocks */

	serial_hangup()				/* first connection drops */
		serial_do_down()
			serial->type-close()	/* resets the hardware */

		... tty_port_block_til_ready() returns
		serial->type->open()		/* not skipped */

Now the second user can proceed to use the hardware.  Or have I 
misunderstood how this is intended to work?

Alan Stern

P.S.: Can you explain the reason why tty_port and tty_struct are two 
separate structures?  Isn't the same port always associated with the 
same tty?


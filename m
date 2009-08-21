Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbZHUSmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbZHUSmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbZHUSmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:42:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60111 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753841AbZHUSmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:42:17 -0400
Date: Fri, 21 Aug 2009 19:42:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bruno =?ISO-8859-14?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090821194252.582ef5cd@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0908211326120.4029-100000@iolanthe.rowland.org>
References: <20090821164843.639aedaf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0908211326120.4029-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Then surely serial_open() should call serial->type->open() _after_ 
> tty_port_block_til_ready(), not before.

It needs the hardware active and running to do the block_til_ready

> Now the second user tries to do stuff but the hardware isn't ready.  
> Instead this should go:
> 
> 	serial_open()				/* first user */
> 		tty_port_block_til_ready()	/* returns immediately */
> 		serial->type->open()		/* initializes the hardware */
> 
> 	serial_open()				/* second user */
> 		tty_port_block_til_ready()	/* blocks */

If the first user succeeded then second should open immediately as the use
count is >= 1 already. It is re-opening the open device, unless the
hangup occurs first.

> 
> 	serial_hangup()				/* first connection drops */
> 		serial_do_down()
> 			serial->type-close()	/* resets the hardware */
> 
> 		... tty_port_block_til_ready() returns
> 		serial->type->open()		/* not skipped */
> 
> Now the second user can proceed to use the hardware.  Or have I 
> misunderstood how this is intended to work?


Usual paths

	open
	block_til_ready
	open returns 0
	do stuff
	close

	open
	block_til_ready
	open returns 0
	do stuff
	hangup (closes hw side)
	further stuff errors
	close (does nothing to the hw side tty_port_close knows about
	this)

	open
	block_til_ready
	hangup
	open returns error
	close path called - knows about hangup in tty_close_port


Hence the reason it always calls the close path to cleanup hardware and
other resources even if open returns an error

> 
> Alan Stern
> 
> P.S.: Can you explain the reason why tty_port and tty_struct are two 
> separate structures?  Isn't the same port always associated with the 
> same tty?

The tty structure is the virtual interface side, the tty_port is the
hardware device. Historically the port side varied randomly by device
preventing any commonality being extracted into helpers.

For most hardware the tty_port lifetime is the physical port lifetime,
the tty lifetime is open->final close (or a final kref drop afterwards)

It also means eventually that we can have a tty_port and things hung off
it for all hardware which means

- Most of the locking costs for receiving v hangup go away (as you
  queue to the tty_port not the tty - ie move the tty_buffer struct)
- It becomes possible to have a proper generic console/debug console
  without hacks and fake tty devices.


Most drivers tend to look like

	open
		test ASYNC_INITIALIZED
			init hardware
			[either in full or clean up partial]
			set ASYNC_INITIALIZED)
		any other alloc/counter magic
		tty->private_data = my stuff
		block_til_ready
	return ok/error

	close
		if (hung_up)
			return
		if (tty->driver_data == NULL)
			return
		counts
		clean up resources
		if (last && test_clear INITIALIZED)
			deinit-hardware
	return ok/error

	hangup
		if (initialized & test_clear INITIALIZED) {
			deinit hardware
		}

which is where I was trying to get the USB code.


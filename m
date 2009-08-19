Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbZHSSU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbZHSSU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZHSSU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:20:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36532 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751413AbZHSSUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:20:25 -0400
Date: Wed, 19 Aug 2009 14:20:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Greg KH <gregkh@suse.de>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090819192256.0e907b54@neptune.home>
Message-ID: <Pine.LNX.4.44L0.0908191413460.3229-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009, Bruno [UTF-8] Prémont wrote:

> I did try to understand what happens exactly, using backtrace from
> kernel compiled with debug info and running objdump on usbserial.ko.

> Verifying by adding a few printk()'s inside serial_do_free() confirms my
> understanding of the objdump and also tells me that after unplug
> serial_do_free() is called twice (with different addresses for port->serial->type)!

In fact, with different values for port->serial.  Probably because port 
was deallocated before the second call occurred.

> The first one (right after unplug) survives, the second one (when exiting
> minicom) crashes.
> 
> Extract from the logs with my printk()'s
> [  266.290632] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
> [  266.290938] ftdi_sio 2-2:1.1: device disconnected
> [  266.292378] tty_port_close_start: count = -1
> [  266.292535] serial_do_free(port @da0d9000)
> [  266.292692]   serial @da3e9840
> [  266.292791]   type   @deb45660
> /* exit minicom */
> [  290.728196] serial_do_free(port @da0d9000)
> [  290.728341]   serial @da0d9200
> [  290.728461]   type   @3a6e6967
> [  290.728591] BUG: unable to handle kernel paging request at 3a6e6983
> [  290.728823] IP: [<deb02d5d>] serial_do_free+0x6d/0xd0 [usbserial]

> Printk's were added:
> 
> 	if (port->console)
> 		return;
> 	/* here */
> 	serial = serial->port;
> 	owner = serial->type->driver.owner /* crash here */
> 
> Is it useful to check calls to serial_do_free() for my pl2303
> usb2serial converter? (e.g. to compare behavior from both of them)

You could try; it wouldn't hurt.  More useful would be to add some 
debugging messages to destroy_serial().  There should not be any calls 
to serial_do_free() after destroy_serial() runs.

Also add some messages to the places that call usb_serial_put() and
usb_serial_get_by_index().

Alan Stern


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751350AbZIGTZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbZIGTZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 15:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbZIGTZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 15:25:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:53826 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750998AbZIGTZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 15:25:06 -0400
Date: Mon, 7 Sep 2009 15:25:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Miklos Szeredi <miklos@szeredi.hu>
cc: alan@linux.intel.com, <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: WARNINGs in usb-serial.c
In-Reply-To: <E1MkiMA-0000vX-5L@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.44L0.0909071509250.9972-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Miklos Szeredi wrote:

> > This is unexpected, because port->serial is initialized in
> > usb_serial_probe() and is not set to NULL until destroy_serial(), after
> > which port should not be used at all.  Can you add a
> > 
> > #define DEBUG
> > 
> > line at the start of usb-serial.c (before the #include lines) so that
> > we can tell if destroy_serial() is getting called too early?  When you
> > do, post the dmesg log showing everything from the time you start
> > running your test.
> 
> drivers/usb/serial/usb-serial.c: serial_install
> drivers/usb/serial/usb-serial.c: serial_open - port 0
...
> PPP generic driver version 2.4.2
> drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
> drivers/usb/serial/usb-serial.c: serial_open - port 0
> drivers/usb/serial/usb-serial.c: serial_tiocmset - port 0
> drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
> drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5404
> drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
> drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
> drivers/usb/serial/usb-serial.c: serial_open - port 0

This is the third open with no intervening closes.  At this point
port->port.count should be equal to 3 (it gets incremented in
serial_open() and decremented when serial_close() calls
tty_port_close_start()).

> drivers/usb/serial/usb-serial.c: destroy_serial - GSM modem (1-port)
> drivers/usb/serial/usb-serial.c: return_serial
> drivers/usb/serial/usb-serial.c: serial_close - port 0

I don't understand this.  How did we get to destroy_serial()?  It is
called from only one place: usb_serial_put().  That in turn is called
from only a few places, of which the most important are
serial_release() and usb_serial_disconnect().  But neither of them
shows up in the debugging log.

We need more debugging info.  You can try printing the value of 
port->port.count just before the end of serial_open() and at the start 
of serial_close().  You can also add a WARN() at the start of 
destroy_serial() so that the stack dump will show how we got there.

> drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> IP: [<ffffffffa01ca09c>] serial_chars_in_buffer+0x47/0x5f [usbserial]

Now this is understandable.  Since destroy_serial() was called too 
soon, anything afterward will try to follow a NULL pointer.

Alan Stern


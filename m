Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbZIHBnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbZIHBnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 21:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZIHBnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 21:43:15 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50373 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753102AbZIHBnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 21:43:14 -0400
Date: Mon, 7 Sep 2009 21:43:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Miklos Szeredi <miklos@szeredi.hu>
cc: alan@linux.intel.com, <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: WARNINGs in usb-serial.c
In-Reply-To: <E1MkkWY-00014V-9E@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.44L0.0909072138340.13297-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Miklos Szeredi wrote:

> OK, here's the debug output with the info.  Looks like the
> destroy_serial() is called via serial_open().
> 
> drivers/usb/serial/usb-serial.c: serial_install
> drivers/usb/serial/usb-serial.c: serial_open - port 0
> serial_open = 1
...
> drivers/usb/serial/usb-serial.c: serial_open - port 0
> serial_open = 2
> drivers/usb/serial/usb-serial.c: serial_tiocmset - port 0
> drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
> drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5404
> drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
> drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
> drivers/usb/serial/usb-serial.c: serial_open - port 0
> Pid: 5007, comm: pppd Not tainted 2.6.31-rc8-gkh-00038-g37d0892-dirty #42
> Call Trace:
>  [<ffffffff810687bb>] ? trace_hardirqs_on_caller+0x10b/0x12f
>  [<ffffffffa01cc532>] ? destroy_serial+0x0/0x10e [usbserial]
>  [<ffffffffa01cc54a>] destroy_serial+0x18/0x10e [usbserial]
>  [<ffffffffa01cc532>] ? destroy_serial+0x0/0x10e [usbserial]
>  [<ffffffff8116ddbd>] kref_put+0x43/0x4f
>  [<ffffffffa01cb0e3>] serial_open+0x11b/0x188 [usbserial]

You're right; serial_open() is somehow calling usb_serial_put().

But in my version of the code there's no way for that to happen.  Could 
it be that your version is different from mine?  For comparison, here 
is my copy of serial_open().

Alan Stern


static int serial_open(struct tty_struct *tty, struct file *filp)
{
	struct usb_serial_port *port = tty->driver_data;
	struct usb_serial *serial = port->serial;
	int retval;

	dbg("%s - port %d", __func__, port->number);

	spin_lock_irq(&port->port.lock);
	if (!tty_hung_up_p(filp))
		++port->port.count;
	spin_unlock_irq(&port->port.lock);
	tty_port_tty_set(&port->port, tty);

	/* Do the device-specific open only if the hardware isn't
	 * already initialized.
	 */
	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
		if (mutex_lock_interruptible(&port->mutex))
			return -ERESTARTSYS;
		mutex_lock(&serial->disc_mutex);
		if (serial->disconnected)
			retval = -ENODEV;
		else
			retval = port->serial->type->open(tty, port);
		mutex_unlock(&serial->disc_mutex);
		mutex_unlock(&port->mutex);
		if (retval)
			return retval;
		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
	}

	/* Now do the correct tty layer semantics */
	retval = tty_port_block_til_ready(&port->port, tty, filp);
	return retval;
}



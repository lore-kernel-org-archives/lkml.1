Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab0CHPfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:35:41 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37630 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752818Ab0CHPfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:35:39 -0500
Date: Mon, 8 Mar 2010 10:35:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-serial: Fix usb serial console open/close regression
In-Reply-To: <1268061698-9846-1-git-send-email-jason.wessel@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1003081028400.1596-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, Jason Wessel wrote:

> Commit e1108a63e10d344284011cccc06328b2cd3e5da3 ("usb_serial: Use the
> shutdown() operation") breaks the ability to use a usb console
> starting in 2.6.32.  This was observed when using
> console=ttyUSB0,115200 as a boot argument with an FTDI device.  The
> error is:
> 
> ftdi_sio ttyUSB0: ftdi_submit_read_urb - failed submitting read urb, error -22
> 
> The handling of the ASYNCB_INITIALIZED changed in 2.6.32 such that in
> tty_port_shutdown() it always clears the flag if it is set.  As a work
> around the usb console must reset this flag, in order for the hw to
> stay open.
> 
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Alan Cox <alan@linux.intel.com>
> CC: Alan Stern <stern@rowland.harvard.edu>
> CC: Oliver Neukum <oliver@neukum.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: linux-usb@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> 
> ---
>  drivers/usb/serial/usb-serial.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> --- a/drivers/usb/serial/usb-serial.c
> +++ b/drivers/usb/serial/usb-serial.c
> @@ -287,10 +287,13 @@ static void serial_down(struct tty_port 
>  	struct usb_serial_driver *drv = port->serial->type;
>  	/*
>  	 * The console is magical.  Do not hang up the console hardware
> -	 * or there will be tears.
> +	 * or there will be tears.  If this is a console the initialized
> +	 * flag is reset.
>  	 */
> -	if (port->console)
> +	if (port->console) {
> +		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
>  		return;
> +	}
>  	if (drv->close)
>  		drv->close(port);
>  }

This is a little unfortunate.  It would be better to prevent
tty_port_shutdown() from clearing ASYNCB_INITIALIZED in the first
place.  The problem is that the tty core doesn't know when the port is
being used as a console.  There ought to be a way to tell it.

Alan Stern


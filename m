Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZEMOtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZEMOtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZEMOsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:48:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58137 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751067AbZEMOst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:48:49 -0400
Date: Wed, 13 May 2009 10:48:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Mack <daniel@caiaq.de>
cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-serial: ftdi: don't dereference NULL pointer
In-Reply-To: <1242213703-3004-1-git-send-email-daniel@caiaq.de>
Message-ID: <Pine.LNX.4.44L0.0905131033060.3004-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009, Daniel Mack wrote:

> The FTDI USB serial driver dereferences its priv structure in
> ftdi_close() without checking for NULL pointer conditions, see the Oops
> attached.
> 
> The flaw can be reproduced using the following steps:
> 
>  - connect an FTDI serial converter
>  - run cu -l ttyUSB0
>  - disconnect the device
>  - hit enter in the cu session
> 
> The root cause for this is that ftdi_sio_port_remove() is called upon
> the devices disconnect which sets the private pointer to NULL, but the
> device remains opened until 'cu' gets a write error and subsequently
> closes the device.
> 
> As we can't call cancel_delayed_work_sync() from ftdi_close() anymore,
> do that from ftdi_sio_port_remove() now.

> @@ -1601,11 +1602,14 @@ static void ftdi_close(struct tty_struct *tty,
>  	mutex_unlock(&port->serial->disc_mutex);
>  
>  	/* cancel any scheduled reading */
> -	cancel_delayed_work_sync(&priv->rx_work);
> +	if (priv)
> +		cancel_delayed_work_sync(&priv->rx_work);
>  
>  	/* shutdown our bulk read */
>  	usb_kill_urb(port->read_urb);
> -	kref_put(&priv->kref, ftdi_sio_priv_release);
> +
> +	if (priv)
> +		kref_put(&priv->kref, ftdi_sio_priv_release);
>  } /* ftdi_close */

This patch is wrong because it leaks priv: If the pointer is NULL in 
ftdi_close() then the final kref_put() will never be issued.

How about getting rid of the

		usb_set_serial_port_data(port, NULL);

line in ftdi_sio_port_remove() instead?  It's not the greatest
solution, but it's the best we can do given the way the usb-serial
framework is set up.

It would also be a good idea to get rid of this comment:

	/* all open ports are closed at this point
	 *    (by usbserial.c:__serial_close, which calls ftdi_close)
	 */

since it is completely wrong.  And the similar comment preceding 
ftdi_shutdown().

Moving the cancel_delayed_work_sync() does make sense.

Alan Stern


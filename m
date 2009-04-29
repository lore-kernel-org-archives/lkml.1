Return-Path: <linux-kernel-owner+w=401wt.eu-S1758468AbZD2QHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbZD2QHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbZD2QG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:06:58 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:60020 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbZD2QG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:06:57 -0400
Date: Wed, 29 Apr 2009 18:06:52 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: BUG: NULL pointer dereference in try_to_del_timer_sync()
Message-ID: <20090429160652.GF6291@buzzloop.caiaq.de>
References: <Pine.LNX.4.44L0.0904291147230.24643-100000@netrider.rowland.org> <Pine.LNX.4.44L0.0904291159240.24643-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904291159240.24643-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 12:00:58PM -0400, Alan Stern wrote:
> On Wed, 29 Apr 2009, Alan Stern wrote:
> 
> > Looks like the ftdi_sio driver doesn't use proper reference counting 
> > for its private data structure.  Does this patch help?
> 
> Oops, I forgot to initialize the kref.  Try this patch instead.

Yep, that did it! Very good, thanks a lot.
Feel free to add my 'Tested-by' :)

Daniel


> Index: 2.6.30-rc3/drivers/usb/serial/ftdi_sio.c
> ===================================================================
> --- 2.6.30-rc3.orig/drivers/usb/serial/ftdi_sio.c
> +++ 2.6.30-rc3/drivers/usb/serial/ftdi_sio.c
> @@ -56,6 +56,7 @@ static __u16 vendor = FTDI_VID;
>  static __u16 product;
>  
>  struct ftdi_private {
> +	struct kref kref;
>  	ftdi_chip_type_t chip_type;
>  				/* type of device, either SIO or FT8U232AM */
>  	int baud_base;		/* baud base clock for divisor setting */
> @@ -1352,6 +1353,7 @@ static int ftdi_sio_port_probe(struct us
>  		return -ENOMEM;
>  	}
>  
> +	kref_init(&priv->kref);
>  	spin_lock_init(&priv->rx_lock);
>  	spin_lock_init(&priv->tx_lock);
>  	init_waitqueue_head(&priv->delta_msr_wait);
> @@ -1468,6 +1470,13 @@ static void ftdi_shutdown(struct usb_ser
>  	dbg("%s", __func__);
>  }
>  
> +static void ftdi_sio_priv_release(struct kref *k)
> +{
> +	struct ftdi_private *priv = container_of(k, struct ftdi_private, kref);
> +
> +	kfree(priv);
> +}
> +
>  static int ftdi_sio_port_remove(struct usb_serial_port *port)
>  {
>  	struct ftdi_private *priv = usb_get_serial_port_data(port);
> @@ -1482,7 +1491,7 @@ static int ftdi_sio_port_remove(struct u
>  
>  	if (priv) {
>  		usb_set_serial_port_data(port, NULL);
> -		kfree(priv);
> +		kref_put(&priv->kref, ftdi_sio_priv_release);
>  	}
>  
>  	return 0;
> @@ -1547,7 +1556,8 @@ static int ftdi_open(struct tty_struct *
>  		dev_err(&port->dev,
>  			"%s - failed submitting read urb, error %d\n",
>  			__func__, result);
> -
> +	else
> +		kref_get(&priv->kref);
>  
>  	return result;
>  } /* ftdi_open */
> @@ -1589,11 +1599,11 @@ static void ftdi_close(struct tty_struct
>  	mutex_unlock(&port->serial->disc_mutex);
>  
>  	/* cancel any scheduled reading */
> -	cancel_delayed_work(&priv->rx_work);
> -	flush_scheduled_work();
> +	cancel_delayed_work_sync(&priv->rx_work);
>  
>  	/* shutdown our bulk read */
>  	usb_kill_urb(port->read_urb);
> +	kref_put(&priv->kref, ftdi_sio_priv_release);
>  } /* ftdi_close */
>  
>  
> 

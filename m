Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbZH0INs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbZH0INs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 04:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbZH0INr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 04:13:47 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:38762 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbZH0INp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 04:13:45 -0400
From: Oliver Neukum <oliver@neukum.org>
To: David VomLehn <dvomlehn@cisco.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1, v2] usb-use-kfifo-to-buffer-usb-generic-serial-writes.patch
Date: Thu, 27 Aug 2009 10:14:53 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc4-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com
References: <20090827013454.GA23601@cuplxvomd02.corp.sa.net>
In-Reply-To: <20090827013454.GA23601@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908271014.54282.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	/* send the data out the bulk port */
> +	result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
> +	if (result) {
> +		dev_err(&port->dev,
> +			"%s - failed submitting write urb, error %d\n",
> +						__func__, result);
> +		/* don't have to grab the lock here, as we will
> +		   retry if != 0 */
> +		port->write_urb_busy = 0;
> +		status = result;

This looks deficient. If the first part of a transmission fails,
the fifo's remaining content should be discarded and if possible
an error returned to user space.

[..]
> @@ -487,8 +515,8 @@ void usb_serial_generic_write_bulk_callback(struct urb
> *urb) port->urbs_in_flight = 0;
>  		spin_unlock_irqrestore(&port->lock, flags);
>  	} else {
> -		/* Handle the case for single urb mode */
>  		port->write_urb_busy = 0;
> +		usb_serial_generic_write_start(port, 0);

This is a problem. This may fail due to a system suspend.
In that case you cannot depend on the next write restarting
IO. You need to restart IO in resume()


> @@ -970,6 +971,11 @@ int usb_serial_probe(struct usb_interface *interface,
>  			dev_err(&interface->dev, "No free urbs available\n");
>  			goto probe_error;
>  		}
> +		port->write_fifo = kfifo_alloc(PAGE_SIZE, GFP_KERNEL,
> +			&port->write_fifo_lock);

Whence do you take the fifo's size? What does this do to latency?

[..]
> @@ -96,6 +98,8 @@ struct usb_serial_port {
>  	unsigned char		*bulk_out_buffer;
>  	int			bulk_out_size;
>  	struct urb		*write_urb;
> +	struct kfifo		*write_fifo;
> +	spinlock_t		write_fifo_lock;

Do you really need a separate lock?

	Regards
		Oliver


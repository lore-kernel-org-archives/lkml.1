Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390Ab0AELE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0AELE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405Ab0AELEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:04:24 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49503 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab0AELEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:04:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sjWzAijtsnZ5VQdV26JbrnDrl6yTQIKvGQW76fjk3k5fGoHQywTkd3W2hGyI36IOAD
         cUzNECMX5M0GTp85aGYx99PZGGPa6ObY5Equ4Nt4jSe1hMIRxyWXD1060Oydg7ZGuO0J
         /mE6pbjepKL36G6FC0B9Xp5qtL95tte7bRIeo=
Date: Tue, 5 Jan 2010 12:04:18 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Pete Zaitcev <zaitcev@redhat.com>, Greg KH <greg@kroah.com>
Cc: Stefani Seibold <stefani@seibold.net>, Johan Hovold <jhovold@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: USB: serial: kfifo_len locking
Message-ID: <20100105110418.GA10442@localhost>
References: <20100104174352.GA26606@localhost>
 <1262632804.4814.17.camel@wall-e>
 <20100105004344.082bb69f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105004344.082bb69f@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This actually was a side effect of the "byte lost on close" patch
> that I submitted, it should be in Greg's tree. The relevant part goes
> like this:
> diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
> index f1ea3a3..3372faa 100644
> --- a/drivers/usb/serial/generic.c
> +++ b/drivers/usb/serial/generic.c
> @@ -386,12 +386,15 @@ int usb_serial_generic_chars_in_buffer(struct tty_struct *tty)
>  
>  	dbg("%s - port %d", __func__, port->number);
>  
> +	spin_lock_irqsave(&port->lock, flags);
>  	if (serial->type->max_in_flight_urbs) {
> -		spin_lock_irqsave(&port->lock, flags);
>  		chars = port->tx_bytes_flight;
> -		spin_unlock_irqrestore(&port->lock, flags);
> -	} else if (serial->num_bulk_out)
> -		chars = kfifo_len(&port->write_fifo);
> +	} else if (serial->num_bulk_out) {
> +		/* This overcounts badly, but is good enough for drain wait. */
> +		chars = __kfifo_len(port->write_fifo);
> +		chars += port->write_urb_busy * port->bulk_out_size;
> +	}
> +	spin_unlock_irqrestore(&port->lock, flags);
>  
>  	dbg("%s - returns %d", __func__, chars);
>  	return chars;

That is indeed what you submitted on Dec 7, but this is what is in
Greg's tree:

http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=usb/usb-serial-mct_usb232-add-drain-on-close.patch;h=c464f1a82e93df0dd41762a8cb33b0b22e90cdd7;hb=1ea72e7c40b239c6b6f88a4993196be66fc3d892

38 --- a/drivers/usb/serial/generic.c
39 +++ b/drivers/usb/serial/generic.c
40 @@ -369,8 +369,11 @@ int usb_serial_generic_write_room(struct
41                         room = port->bulk_out_size *
42                                 (serial->type->max_in_flight_urbs -
43                                  port->urbs_in_flight);
44 -       } else if (serial->num_bulk_out)
45 +       } else if (serial->num_bulk_out) {
46 +               /* This overcounts badly, but is good enough for drain wait. */
47                 room = kfifo_avail(&port->write_fifo);
48 +               room += port->write_urb_busy * port->bulk_out_size;
49 +       }
50         spin_unlock_irqrestore(&port->lock, flags);
51  
52         dbg("%s - returns %d", __func__, room);


Which does not make any sense at all. Bad merge? What do you say Greg?

/Johan


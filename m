Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413Ab0AEMLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0AEMLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 07:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154Ab0AEMLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 07:11:08 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:10221 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0AEMLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 07:11:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VrGD+9vBXkWkwe/dDzw7p38xN4J9jCMAkIwTC44yn6K1CfsP75+2R0FBBLpu7hduhU
         j5kJNFxsOfnIU7yEZj9mjEmmDYKQ3S84w+D4uu3LDxK89IdCeMx+K+wSfdLZFU1HzDnY
         PIs4IuhYCvYQRaJXjBSPnxoQDfvDbihDZO7/4=
Date: Tue, 5 Jan 2010 13:10:59 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Johan Hovold <jhovold@gmail.com>, Pete Zaitcev <zaitcev@redhat.com>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB: serial: kfifo_len locking
Message-ID: <20100105121059.GC10442@localhost>
References: <20100104174352.GA26606@localhost>
 <1262632804.4814.17.camel@wall-e>
 <20100105004344.082bb69f@redhat.com>
 <20100105110418.GA10442@localhost>
 <1262689759.21020.2.camel@wall-e>
 <20100105111401.GB10442@localhost>
 <1262690734.22009.3.camel@wall-e>
 <20100105113525.GA19371@localhost>
 <1262692881.23577.15.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262692881.23577.15.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Here's the change. The fifo used to be protected by a lock, but is no
> > longer.
>  
> I posted yesterday a patch to this thread. It would be great if you read
> and check this patch before complaining again!!!!
> 
> > Never say you did.
> 
> Sorry, i had no real idea what is your problem, if this is not what you
> want. As i mentioned i posted to you yesterday a fix for the possible
> kfifo_len() bug, but i didn't get a response if this is fixing your
> problem. Again the patch:
> 
> diff -u -N -r  -p linux-2.6.33-rc2.orig/drivers/usb/serial/generic.c linux-2.6.33-rc2.new/drivers/usb/serial/generic.c
> --- linux-2.6.33-rc2.orig/drivers/usb/serial/generic.c	2009-12-27 23:37:03.566060210 +0100
> +++ linux-2.6.33-rc2.new/drivers/usb/serial/generic.c	2010-01-04 20:15:38.023351711 +0100
> @@ -386,12 +386,12 @@ int usb_serial_generic_chars_in_buffer(s
>  
>  	dbg("%s - port %d", __func__, port->number);
>  
> -	if (serial->type->max_in_flight_urbs) {
> -		spin_lock_irqsave(&port->lock, flags);
> +	spin_lock_irqsave(&port->lock, flags);
> +	if (serial->type->max_in_flight_urbs)
>  		chars = port->tx_bytes_flight;
> -		spin_unlock_irqrestore(&port->lock, flags);
> -	} else if (serial->num_bulk_out)
> +	else if (serial->num_bulk_out)
>  		chars = kfifo_len(&port->write_fifo);
> +	spin_unlock_irqrestore(&port->lock, flags);
>  
>  	dbg("%s - returns %d", __func__, chars);
>  	return chars;
> 
> This patch should solve the possible race (if there is one). With this
> patch all kfifo_... access are locked by the port->lock spinlock. If
> this is what you want i will posted it as a bug fix to andrew.

Yes, please do.


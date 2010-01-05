Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233Ab0AEHok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0AEHok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480Ab0AEHoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:44:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab0AEHoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:44:39 -0500
Date: Tue, 5 Jan 2010 00:43:44 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Johan Hovold <jhovold@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: USB: serial: kfifo_len locking
Message-ID: <20100105004344.082bb69f@redhat.com>
In-Reply-To: <1262632804.4814.17.camel@wall-e>
References: <20100104174352.GA26606@localhost>
	<1262632804.4814.17.camel@wall-e>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Jan 2010 20:20:04 +0100
Stefani Seibold <stefani@seibold.net> wrote:
> Am Montag, den 04.01.2010, 18:43 +0100 schrieb Johan Hovold:

> > I noticed that the locking that used to protect kfifo_len in
> > usb_serial_generic_chars_in_buffer was removed when the kifo api changed
> > to not use internal locking (c1e13f25674ed564948ecb7dfe5f83e578892896 -- 
> > kfifo: move out spinlock). 
> > 
> > Was this intentional?
> > 
> 
> Yes, the locking is not necessary until only one reader and one writer
> is using the fifo. If you don't trust this you can apply this patch:
> 
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
> Then everything kfifo_... access in the usb serial is handled with an
> active spinlock.

This actually was a side effect of the "byte lost on close" patch
that I submitted, it should be in Greg's tree. The relevant part goes
like this:

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index f1ea3a3..3372faa 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -386,12 +386,15 @@ int usb_serial_generic_chars_in_buffer(struct tty_struct *tty)
 
 	dbg("%s - port %d", __func__, port->number);
 
+	spin_lock_irqsave(&port->lock, flags);
 	if (serial->type->max_in_flight_urbs) {
-		spin_lock_irqsave(&port->lock, flags);
 		chars = port->tx_bytes_flight;
-		spin_unlock_irqrestore(&port->lock, flags);
-	} else if (serial->num_bulk_out)
-		chars = kfifo_len(&port->write_fifo);
+	} else if (serial->num_bulk_out) {
+		/* This overcounts badly, but is good enough for drain wait. */
+		chars = __kfifo_len(port->write_fifo);
+		chars += port->write_urb_busy * port->bulk_out_size;
+	}
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	dbg("%s - returns %d", __func__, chars);
 	return chars;

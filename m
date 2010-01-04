Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879Ab0ADTUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0ADTUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417Ab0ADTUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:20:14 -0500
Received: from www84.your-server.de ([213.133.104.84]:59893 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab0ADTUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:20:12 -0500
Subject: Re: USB: serial: kfifo_len locking
From: Stefani Seibold <stefani@seibold.net>
To: Johan Hovold <jhovold@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <20100104174352.GA26606@localhost>
References: <20100104174352.GA26606@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 04 Jan 2010 20:20:04 +0100
Message-ID: <1262632804.4814.17.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 04.01.2010, 18:43 +0100 schrieb Johan Hovold:
> Hi Stefani,
> 
> I noticed that the locking that used to protect kfifo_len in
> usb_serial_generic_chars_in_buffer was removed when the kifo api changed
> to not use internal locking (c1e13f25674ed564948ecb7dfe5f83e578892896 -- 
> kfifo: move out spinlock). 
> 
> Was this intentional?
> 

Yes, the locking is not necessary until only one reader and one writer
is using the fifo. If you don't trust this you can apply this patch:

--- linux-2.6.33-rc2.orig/drivers/usb/serial/generic.c	2009-12-27 23:37:03.566060210 +0100
+++ linux-2.6.33-rc2.new/drivers/usb/serial/generic.c	2010-01-04 20:15:38.023351711 +0100
@@ -386,12 +386,12 @@ int usb_serial_generic_chars_in_buffer(s
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (serial->type->max_in_flight_urbs) {
-		spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&port->lock, flags);
+	if (serial->type->max_in_flight_urbs)
 		chars = port->tx_bytes_flight;
-		spin_unlock_irqrestore(&port->lock, flags);
-	} else if (serial->num_bulk_out)
+	else if (serial->num_bulk_out)
 		chars = kfifo_len(&port->write_fifo);
+	spin_unlock_irqrestore(&port->lock, flags);

Then everything kfifo_... access in the usb serial is handled with an
active spinlock.

> I found a related discussion here
> 
> 	http://lkml.org/lkml/2009/12/18/433
> 
> where you seem to say that no such locking is required as long as
> kfifo_reset is never called (and that one could use kfifo_reset_out
> instead)?
> However, kfifo_reset was still being called when the locking was removed
> and not until later was it changed to kfifo_reset_out
> (119eecc831a42bd090543568932e440c6831f1bb -- Fix usb_serial_probe()
> problem introduced by the recent kfifo changes).  
> 

In the reader part kfifo_reset_out() will make the reset safer, to
prevent side effects against kfifo_len()

> Does this last change imply that no locking in
> usb_serial_generic_chars_in_buffer is required? 

Sorry, i don't understand the USB serial code, so i tried my best to
port it to the new API. The author must know if locking for the fifo
access is required.

> If this is the case,
> perhaps such locking guidelines could be added to kfifo.h?
> 

The locking guidelines are still available in the function descriptions:
until only: 

Note that with only one concurrent reader and one concurrent writer, you
don't need extra locking to use these functions.

Stefani



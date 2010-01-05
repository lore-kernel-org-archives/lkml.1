Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770Ab0AERBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0AERBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214Ab0AERBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:01:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab0AERBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:01:37 -0500
Date: Tue, 5 Jan 2010 10:00:45 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Johan Hovold <jhovold@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: USB: serial: kfifo_len locking
Message-ID: <20100105100045.71afd561@redhat.com>
In-Reply-To: <1262689759.21020.2.camel@wall-e>
References: <20100104174352.GA26606@localhost>
	<1262632804.4814.17.camel@wall-e>
	<20100105004344.082bb69f@redhat.com>
	<20100105110418.GA10442@localhost>
	<1262689759.21020.2.camel@wall-e>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jan 2010 12:09:19 +0100
Stefani Seibold <stefani@seibold.net> wrote:

> > 39 +++ b/drivers/usb/serial/generic.c
> > 40 @@ -369,8 +369,11 @@ int usb_serial_generic_write_room(struct
> > 41                         room = port->bulk_out_size *
> > 42                                 (serial->type->max_in_flight_urbs -
> > 43                                  port->urbs_in_flight);
> > 44 -       } else if (serial->num_bulk_out)
> > 45 +       } else if (serial->num_bulk_out) {
> > 46 +               /* This overcounts badly, but is good enough for drain wait. */
> > 47                 room = kfifo_avail(&port->write_fifo);
> > 48 +               room += port->write_urb_busy * port->bulk_out_size;
> > 49 +       }
> > 50         spin_unlock_irqrestore(&port->lock, flags);

> > Which does not make any sense at all. Bad merge? What do you say Greg?
> 
> I don't know where is your problem? This are two different functions
> usb_serial_generic_write_room() and usb_serial_generic_chars_in_buffer()

Looks like a bad merge indeed. The fix that accounts for the write
urb has to apply to chars_in_buffer, so that we can wait until until
it goes to zero.

Please feel free to fix up the kfifo API, I'll pick up the pieces
regarding the lost bytes on close after you're done.

-- Pete

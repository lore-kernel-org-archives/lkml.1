Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337Ab0ASPwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab0ASPwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 10:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325Ab0ASPwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 10:52:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:65200 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0ASPw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 10:52:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Lo9I17doZxzm0gmfswRcsTxC4abu/q+i+QZZRusXKuphaKgh3/vPw+QZ3/nJtmd4RS
         PUBE/PDQjUJ0LgwSMK7osMc7Gru2DOFaZjCwb9WDe6Ly5MNh2qRN5zJtpisjM+tX4R/M
         tFEKrp/0yDjyZnpAM1BBI/YvE/G5GF96Muw68=
Date: Tue, 19 Jan 2010 16:52:25 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oliver Neukum <oliver@neukum.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
 writes" causes gobi_loader to hang
Message-ID: <20100119155225.GB2104@localhost>
References: <20100117025535.GB7045@srcf.ucam.org>
 <201001191420.29652.oliver@neukum.org>
 <20100119132934.0c1688f7@lxorguk.ukuu.org.uk>
 <201001191457.00504.oliver@neukum.org>
 <20100119142657.02856d15@lxorguk.ukuu.org.uk>
 <20100119152536.GA2104@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119152536.GA2104@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The log shows no call to usb_serial_generic_write_room()
> > > Do you consider this a bug in the tty layer?
> > 
> > Actually this all makes sense because of where it was hanging. A reply of
> > 0 to the tty->ops->write will cause it to either return (O_NONBLOCK) or
> > sleep in the n_tty write code waiting for a write_wait wakeup
> > (tty_wakeup(tty))
> > 
> > So the fix does indeed look correct.
> 
> Is it really a fix? If the fifo is already full the write urb should be
> in use and Oliver's patch would amount to only a minor optimisation as
> usb_serial_generic_write_start would return 0 anyway.

So the question seems to be: why doesn't the on-going transfer finish (so
that tty_wakeup is called)?


> drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
> drivers/usb/serial/usb-serial.c: serial_write - port 0, 29 byte(s)
> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 29
> bytes
> drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes
> into fifo

Writer got woken but fifo is still full so write returns 0 and writer goes
back to sleep.

> drivers/usb/serial/generic.c: usb_serial_generic_write_bulk_callback -
> port 0
> drivers/usb/serial/generic.c: usb_serial_generic_write_start - starting
> IO
> qcserial ttyUSB0: usb_serial_generic_write_start - length = 512, data =
> f0 f8 0a 01 f0 00 0b 01 f0 0c 10 01 f0 38 10 01 f0 0f 22 a0 e3 04 40 92
> e5 1c 30 94 e5 a3 32 a0 e1 7f 3f c3 e3 ff 33 c3 e3 0f 35 c3 e3 0e 12 83
> e2 08 00 91 e5 00 00 50 e3 0a 00 00 0a 0a 20 d0 e5 02 00 52 e3 0d 00 00
> 0a 60 31 91 e5 0a 30 c0 e5 64 21 91 e5 0b 20 c0 e5 38 10 81 e2 44 30 91
> e5 c0 30 c3 e3 44 30 81 e5 04 00 a0 e1 96 fc ff eb 50 31 94 e5 fe df 8d
> e3 03 f0 a0 e1 fe ff ff ea 08 30 94 e5 0a 20 c3 e5 38 20 84 e2 44 30 92
> e5 80 30 83 e3 44 30 82 e5 ea ff ff ea 02 60 a0 e1 01 50 a0 e1 04 d0 4d
> e2 00 70 a0 e1 03 80 a0 e1 4d ff ff eb a5 2f a0 e1 86 30 82 e1 00 00 a0
> e3 2f 20 e0 e3 00 00 8d e5 b2 20 cd e1 00 10 9d e5 03 19 81 e3 00 10 8d
> e5 a6 4f a0 e1 a3 20 a0 e1 84 3f 82 e1 08 20 97 e5 48 30 82 e5 0f 32 a0
> e3 40 10 82 e5 0c 00 82 e5 44 50 82 e5 04 10 93 e5 2c 30 91 e5 e4 00 97
> e5 20 20 9f e5 01 30 83 e3 2c 30 81 e5 80 20 87 e5 50 81 87 e5 10 30 9f
> e5 00 10 a0 e1 0c e0 9f e5 03 f0 a0 e1 fe ff ff ea 20 81 00 f0 8c 89 00
> f0 10 b6 00 f0 0f 32 a0 e3 04 40 93 e5 08 20 94 e5 40 30 92 e5 04 d0 4d
> e2 00 30 8d e5 04 00 a0 e1 5b fc ff eb d1 30 dd e1 00 00 53 e3 03 00 00
> ba 50 31 94 e5 fe df 8d e3 03 f0 a0 e1 fe ff ff ea 04 00 9f e5 73 05 00
> eb f8 ff ff ea 4c 10 01 f0 0f c2 a0 e3 18 40 dc e5 18 d0 4d e2 00 00 54
> e3 0e 60 a0 e1 14 00 8d e5 01 a0 a0 e1 10 20 8d e5 03 90 a0 e1 20 b0 9d
> e5 51 01 00 1a 0f 32 a0 e3 04 80 93 e5 50 26 9f e5 0c 30 98 e5 00 10 92
> e5 01 00 53 e1 00 00 a0 13 01 00 a0 03 00 00 50 e3 41 01 00 0a 14 50 9d
> e5 01 20 75 e2 00 20 a0 33 00 00 52 e3 0d 00 00 1a b4 31 dd e1 3f 00 13
> e3 02 30 a0 e1 03 00 00

New transfer started from completion handler.

> drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0

Writer woken up from completion handler after having started the
next transfer.

> drivers/usb/serial/usb-serial.c: serial_write - port 0, 29 byte(s)
> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 29
> bytes
> drivers/usb/serial/generic.c: usb_serial_generic_write - put 29 bytes
> into fifo
> drivers/usb/serial/usb-serial.c: serial_write - port 0, 2048 byte(s)
> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 2048
> bytes
> drivers/usb/serial/generic.c: usb_serial_generic_write - put 483 bytes
> into fifo
> drivers/usb/serial/usb-serial.c: serial_write - port 0, 1565 byte(s)
> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 1565
> bytes
> drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes
> into fifo

Now there was some room (29 + 483 = 512 bytes bytes just transfered).

> drivers/usb/serial/generic.c: usb_serial_generic_read_bulk_callback -
> port 0

Waiting forever for on-going transfer to finish...


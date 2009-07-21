Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZGUTUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZGUTUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbZGUTUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:20:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48581 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754389AbZGUTUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:20:23 -0400
Date: Tue, 21 Jul 2009 20:21:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Mack <daniel@caiaq.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090721202123.404339aa@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0907211423420.2088-100000@iolanthe.rowland.org>
References: <20090721171625.6e2c54e4@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0907211423420.2088-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	file->f_ops = &hung_up_tty_ops;
> > 
> > 		(so the USB close will never be called)
> 
> That doesn't make sense.  The driver's open method has been called, so 
> of course the driver expects its close method to be called.

The driver close method yes - but that uses tty_port_close_start() which
sees the port was hung up and leaves well alone.

> > 	ldisc hangup
> > 	tty->ops->hangup (no-op on USB serial)
> 
> What do you mean?  There is a serial_hangup method in usb-serial.c
> and it does get called; see below.

Thats me not reading carefully. It isn't just a resource free it does
stuff. That calls drv->close() so in fact the USB layer for want of a
better word "fakes" the close.

> [  283.624088]  [<f08b09d7>] serial_hangup+0x45/0x66 [usbserial]
> [  283.624187]  [<c112018c>] do_tty_hangup+0x28c/0x2b9

So we passed

        /* This breaks for file handles being sent over AF_UNIX sockets ?
        */ list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
                if (filp->f_op->write == redirected_tty_write)
                        cons_filp = filp;
                if (filp->f_op->write != tty_write)
                        continue;
                closecount++;
                tty_fasync(-1, filp, 0);        /* can't block */
                filp->f_op = &hung_up_tty_fops;
        }

and changed the fops. As you say my theory was completely wrong

> Close the open file descriptor:
> [  291.227977] tty_release_dev of tty2 (tty count=2)...
> [  291.230492] tty_release_dev of ttyUSB0 (tty count=1)...
> [  291.230630] serial_close port 107 (ef7fd920)
> 
> That line was inserted in serial_close.  As you can see, the port 
> number is wrong because the port structure has already been 
> deallocated by port_free.  And that leads to the following corruption.

Bingo - and that in turn means that the tty layer doesn't realise the
port has been hung up which makes tty_port_close_start do random things
which causes us to double free.

So in fact we need to delay the resource free until the tty layer has
really finished with it as the port resource contains the tty layer port.

We can't just skip freeing the resources in the hangup method as
tty_port_close_start() will return 0 and leak them on a hangup.

Alan: does this make sense

	Take an extra tty layer reference to the usb_serial at open time

	Put that reference in the tty shutdown() hook which is called
	when the tty struct gets its final kref_put (ie after the close,
	and if there is any outstanding other use eg in an IRQ handler on
	another processor).

Am I understanding the usb_serial_port lifetime correctly ?


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZGUViv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZGUViv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbZGUViu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:38:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36075 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752398AbZGUVit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:38:49 -0400
Date: Tue, 21 Jul 2009 17:38:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Daniel Mack <daniel@caiaq.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
In-Reply-To: <20090721202123.404339aa@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0907211632080.2679-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Alan Cox wrote:

> > > 	ldisc hangup
> > > 	tty->ops->hangup (no-op on USB serial)
> > 
> > What do you mean?  There is a serial_hangup method in usb-serial.c
> > and it does get called; see below.
> 
> Thats me not reading carefully. It isn't just a resource free it does
> stuff. That calls drv->close() so in fact the USB layer for want of a
> better word "fakes" the close.

I see.  Both serial_hangup() and serial_close() call serial_do_down()  
and thus drv->close.  So we obviously don't want both of them to be 
called if the device is unplugged before the file is closed.  But that
is just what tty_release_dev does...

> > [  283.624088]  [<f08b09d7>] serial_hangup+0x45/0x66 [usbserial]
> > [  283.624187]  [<c112018c>] do_tty_hangup+0x28c/0x2b9
> 
> So we passed
> 
>         /* This breaks for file handles being sent over AF_UNIX sockets ?
>         */ list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
>                 if (filp->f_op->write == redirected_tty_write)
>                         cons_filp = filp;
>                 if (filp->f_op->write != tty_write)
>                         continue;
>                 closecount++;
>                 tty_fasync(-1, filp, 0);        /* can't block */
>                 filp->f_op = &hung_up_tty_fops;
>         }
> 
> and changed the fops. As you say my theory was completely wrong
> 
> > Close the open file descriptor:
> > [  291.227977] tty_release_dev of tty2 (tty count=2)...
> > [  291.230492] tty_release_dev of ttyUSB0 (tty count=1)...
> > [  291.230630] serial_close port 107 (ef7fd920)
> > 
> > That line was inserted in serial_close.  As you can see, the port 
> > number is wrong because the port structure has already been 
> > deallocated by port_free.  And that leads to the following corruption.
> 
> Bingo - and that in turn means that the tty layer doesn't realise the
> port has been hung up which makes tty_port_close_start do random things
> which causes us to double free.
> 
> So in fact we need to delay the resource free until the tty layer has
> really finished with it as the port resource contains the tty layer port.

By "port resource" you mean the usb_serial_port structure, right?

> We can't just skip freeing the resources in the hangup method as
> tty_port_close_start() will return 0 and leak them on a hangup.

Wait a second.  Does the same serial_hangup() routine get called when
an RS-232 (for example) hangup event occurs, like DCD turning off, and
when the USB device is unplugged?  Sure, the second implies the first,
but they need to be treated differently.  After the first, the hardware
is still present and so the port resources shouldn't be released.

> Alan: does this make sense
> 
> 	Take an extra tty layer reference to the usb_serial at open time
> 
> 	Put that reference in the tty shutdown() hook which is called
> 	when the tty struct gets its final kref_put (ie after the close,
> 	and if there is any outstanding other use eg in an IRQ handler on
> 	another processor).

I don't think that will work; we mustn't deallocate the usb_serial_port
structures before calling serial->type->release(), which happens in 
destroy_serial().  Yes, this is stupid, but some of the subdrivers 
depend on it.

But the real problem isn't the references to the usb_serial.  It seems
like a mistake to call serial_do_free() during serial_hangup() -- you
can fake a close but you can't fake a release.  It's probably also
wrong to call serial_do_down().

> Am I understanding the usb_serial_port lifetime correctly ?

Perhaps not; I'll explain.  It's very simplistic, because when I wrote 
it I didn't know what was going on with the tty layer internals.  (I 
still don't, come to that.)

So usb_serial_port gets treated like any other character device.  The
refcount is initialized to 1, it gets incremented during serial_open(),
decremented during serial_do_free() -- which used to be during
serial_close(), and then decremented a final time in destroy_serial().

Meanwhile, the higher usb_serial structure has a refcount also.  It
gets incremented during serial_open(), decremented during
serial_do_free(), and decremented finally during
usb_serial_disconnect().

Logically, the usb_serial structure should exist only as long as any of
the usb_serial_ports need it.  So logically, each of them should take a
reference to it as they are created and drop their reference as they
are deallocated, as you suggested.  But since they can't get 
deallocated until after the usb_serial's refcount has dropped to 0, I 
had to use a more roundabout method.

The usb_serial_port structures should exist as long as they are needed, 
which means as long as the USB device is connected or the tty device 
file is open.  That's how my original design was meant to work, but it 
is now messed up by the fact that we get two "close" events -- a fake 
one during disconnect and then the real one later.

Eliminating the fake calls seems like the cleanest solution.  
Alternatively, we could keep the fake close (but not the fake release!)
and change serial_close() so that it calls serial_do_free() even if 
tty_port_close_start returns 0.

Alan Stern


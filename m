Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZGVWek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZGVWek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbZGVWek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:34:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34760 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754672AbZGVWej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:34:39 -0400
Date: Wed, 22 Jul 2009 23:35:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Mack <daniel@caiaq.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090722233544.34b91378@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0907221352340.3918-100000@iolanthe.rowland.org>
References: <20090722171707.5fa39803@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0907221352340.3918-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmmm.  serial_open() doesn't call tty_port_block_til_ready() until just 
> before it returns.  Shouldn't it do this before locking port->mutex and 
> incrementing port->port.count?

There shouldn't be a serial_open or serial_close as such IMHO, but I can't
simply rewrite everything in one go. Instead commonality is getting
extracted piece by piece.

> In fact, should usb-serial.c be touching port->port.count at all?  Is 
> it reserved for use by the tty core?

Ultimately I am pretty sure that for open and close usb serial should in
fact have to provide

	-	power management hooks
	-	hardware init/shutdown hooks
	-	modem control
	-	modem status

and nothing else. The same model will fit all the other drivers but they
all currently contain different code for this and do stuff differently.
Power to some means PCI D3 to USB means the usb autopm etc.
Hibernate/Resume has to fit there somewhere and I'll freely admit I've
not quite figured out how that should go together with this model.

So far I've extract the modem hooks needed for open/close (DTR control,
CD state, wakeups) and some of the code duplicated everywhere in
open/close/hangup (and which in USB serial were basically a work of
fiction with no resemblance to the standard). The open is only half done
so far (hence the wait_until helper) and the close path is not all there
- hence close_start/close_end.

At the moment I have two main goals

- Get to the point where every serial port in the system contains a tty
  port
- Remove the 10 million alternative mis-implementations of half the tty
  code found in each driver or in "glue" that does what the tty layer
  should be doing (half of usb-serial, most of the uart layer)

All without being able to just break it for six months and drop support
for most of the hardware.

> > > There's an obvious race here between hangup and close.  The assignment 
> > > of hung_up_tty_fops to filp->f_op is protected by the BKL and not much 
> > > else.  Does the code in tty_release_dev() check to see whether this 
> > > assignment has been made before calling tty->ops->close()?  It doesn't 
> > > like like it to me.  With the wrong timing, you could end up telling 
> > > the device driver to stop the uart twice.
> > 
> > The core hangup and close code are interlocked (now - didn't use to be).
> 
> But are they interlocked enough?

I think so at this point. I may be wrong. I was wrong about it earlier
this -rc series ;)

> Why doesn't tty_release_dev() test tty_hung_up_p() before calling
> tty->ops->close() instead of making the driver do it?

Ask Ted, see if he can remember why he did it that way 15 years ago on a
non SMP non lock using (except for kernel mode non-pre-emption) kernel.
Basically the tty layer was designed for a different world and then
patched up badly. The original design was wrong in several areas and the
result is a can of worms that eventually had to be opened.

Alan

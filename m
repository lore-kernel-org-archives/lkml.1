Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbZG2I70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbZG2I70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 04:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZG2I70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 04:59:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32887 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750912AbZG2I7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 04:59:25 -0400
Date: Wed, 29 Jul 2009 09:59:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090729095923.4ca5ca3e@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907281736260.3161@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp>
	<20090727161424.GA4233@skywalker>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker>
	<87skgikjr8.fsf@devron.myhome.or.jp>
	<20090727222010.1a5efb7b@lxorguk.ukuu.org.uk>
	<87r5w19xsb.fsf@devron.myhome.or.jp>
	<20090728112203.7b70adba@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280848090.3186@localhost.localdomain>
	<20090728174213.5e927428@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
	<20090728180649.596c5412@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281141070.3186@localhost.localdomain>
	<20090728195651.3a402a31@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
	<20090729004639.71f0eabc@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281651160.3186@localhost.localdomain>
	<20090729013442.493effa6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281736260.3161@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > - The driver ensures that it will not call
> >   tty_flip_buffer_push/flush_to_ldisc again for this port until re-opened
> 
> That's just bogus.

I didn't invent it, thats how it works and its not an area I've touched.

> If that is wrong as per hangup code, then the bug is in the hangup 
> handling, not in the tty_flush_to_ldisc().

I wouldn't argue with that - I merely pointed out they need synchronizing
> 
> > - The driver calls tty_hangup
> > - tty_hangup ensures that tty_flip_buffer_push cannot occur again
> >   (by killing the workqueue)
> > - resources may well then get freed before close()
> 
> They had better not be, since all the data structures touched are inside 
> the 'tty_struct' (which we're dereferencing in other ways anyway in that 
> whole routine).

You are only looking at pty. That code is used for all the real physical
tty devices too. With real devices the underlying physical device and its
structures can get dumped. When you run the n_tty ldisc you call back out
to the drivers for echo etc.

> So the only thing that the hangup code needs to do is to make that the 
> "tty->buf.work.work" function pointer is a nop. And it does, as far as I
> can tell.

What happens if the hangup occurs just after you start running the ldisc
on another CPU ?

> So regardless, by now we have moved from "trivial bug that bites people in 
> real life" to "theoretical bug that looks impossible to trigger".

Actually all the hangup races turn up for people. Not often but now and
then. Also because you have vhangup() you can cause them in software by
leaving one app spinning in a loop hanging up and opening stuff while you
try and make it break.

> Well, put this way: the only thing that actually stops the outstanding 
> timer (for the delayed work) is the tty_ldisc_halt() call in 
> tty_ldisc_hangup(). If that _isn't_ called, then your argument is 
> pointless, since the tty_flush_to_ldisc() will be done by a timer later 
> (and Ogawa's patch thus clearly introduces nothing new).
> 
> And when it _is_ called, it also clears TTY_LDISC, so now tty_ldisc_ref() 
> will return NULL, so then flush_to_ldisc() will be a no-op.

IFF the hangup doesn't occur while you are entering flush_to_ldisc()

Consider a real tty for a bit

	CPU0					CPU1
n_tty methods
	flush_to_ldisc
	get ldisc ref
						INTERRUPT
						tty_hangup
						do_tty_hangup
	ldisc work				tty_ldisc_hangup
						RESET_TERMIOS is false
						tty->ops->hangup()
						[usb]serial_hangup()
						[usb]serial_do_down()
							close physical
								driver

	tty->ops->write
						[usb]serial_write
						WARN()


So as I said before you need to fix flush_to_ldisc and the hangup running
against one another. At the very least I think you need a
tty_ldisc_wait_idle(tty); just before

        if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {

so that you stall the hangup until n_tty exits the ldisc.


(The other case is calling ld->ops->hangup then calling ld->ops->write
which no ldisc seems to care about)


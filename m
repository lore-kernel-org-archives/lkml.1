Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZGUWyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZGUWyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbZGUWyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:54:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50675 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753257AbZGUWyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:54:15 -0400
Date: Tue, 21 Jul 2009 23:55:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Mack <daniel@caiaq.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090721235512.7a1784be@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0907211632080.2679-100000@iolanthe.rowland.org>
References: <20090721202123.404339aa@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0907211632080.2679-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We can't just skip freeing the resources in the hangup method as
> > tty_port_close_start() will return 0 and leak them on a hangup.
> 
> Wait a second.  Does the same serial_hangup() routine get called when
> an RS-232 (for example) hangup event occurs, like DCD turning off, and
> when the USB device is unplugged?  Sure, the second implies the first,
> but they need to be treated differently.  After the first, the hardware
> is still present and so the port resources shouldn't be released.

The sequences of behaviour for the tty interface are usually

	open
		allocate resources
		start uart

	do stuff

	close
		stop uart
		free resources

and if a hang up occurs:

	open
		allocate resources
		start uart
	do stuff

	hangup event
		stop uart
		free resources
		wake any pending openers

	[pending open completes]
		allocate resources
		start uart

	[original opener closes]
	close
		was hung up
		do nothing much


> Perhaps not; I'll explain.  It's very simplistic, because when I wrote 
> it I didn't know what was going on with the tty layer internals.  (I 
> still don't, come to that.)

Ok so between us we know the answer I hope 8)

> The usb_serial_port structures should exist as long as they are needed, 
> which means as long as the USB device is connected or the tty device 
> file is open.  That's how my original design was meant to work, but it 
> is now messed up by the fact that we get two "close" events -- a fake 
> one during disconnect and then the real one later.

The tty notion of "open" is really open->hangup or open->close. Once the
hangup occurs you may have a file handle to a tty object but it doesn't
talk to hardware. You need to open it again to get access again. Between
hangup and close you are sitting on a dead file handle that returns
errors if you use it. The hardware is owned by whoever opened it next.

The historical model for this is from dial in. A carrier drop is
effectively a secure attention key, it has to kill off anything left on
the port so an evil user cannot leave a key logger active on the port.

> Eliminating the fake calls seems like the cleanest solution.  
> Alternatively, we could keep the fake close (but not the fake release!)
> and change serial_close() so that it calls serial_do_free() even if 
> tty_port_close_start returns 0.

There are several other cases where tty_port_close_start returns zero
(such as multiple openers and not being the last one)

Alan

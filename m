Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZGUQPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZGUQPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZGUQPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:15:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37868 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751134AbZGUQPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:15:20 -0400
Date: Tue, 21 Jul 2009 17:16:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Mack <daniel@caiaq.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090721171625.6e2c54e4@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0907211141180.2652-100000@iolanthe.rowland.org>
References: <20090721004531.1036d9af@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0907211141180.2652-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If that is occuring then the bug is elsewhere. The hang up sequence
> > reconnects the user space to the hung up tty ops and no longer references
> > the hardware.
> 
> I got something similar with a pl2303 device, though not a crash.  I 
> plugged in the device, opened /dev/ttyUSB0, unplugged the device, then 
> tried to read from the open file descriptor.  The read provoked this:

That looks like it occurs after the read, however that trace shows the
close() method being called off sys_close() which in turn means a hang up
didn't occur when it was unplugged.

> This is only a lockdep warning, and I don't understand its
> significance.  Even worse, when I plugged in a USB flash drive
> afterward this appeared:

Looks like something freed the resources but didn't hang up when the
disconnect occurred

> So it looks like something really is wrong, some sort of 
> use-after-free.  Maybe a refcounting imbalance.

A tty getting destructed before it should have been would perhaps do some
of it but it doesn't explain how the close path got where it did.

What should be occurring is

	USB disconnect
		usb_serial_disconnect(interface)
		tty_hangup(tty)   [this is buggy and commented as such in
		the USB code as it should do it synchronously]

	tty_hangup()
	do_tty_hangup()

	file->f_ops = &hung_up_tty_ops;

		(so the USB close will never be called)

	ldisc hangup
	tty->ops->hangup (no-op on USB serial)

so the trace to me implies that the usb_serial_disconnect is not
happening. That in turn leads the close method to be called on a
disconnected port which in turn crashes stuff.

(and it also explains why Daniel's change although bogus stops the crash)



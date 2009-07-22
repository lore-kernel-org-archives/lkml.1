Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486AbZGVQQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbZGVQQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZGVQQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:16:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34665 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752117AbZGVQQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:16:22 -0400
Date: Wed, 22 Jul 2009 17:17:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Mack <daniel@caiaq.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090722171707.5fa39803@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0907221014210.2935-100000@iolanthe.rowland.org>
References: <20090721235512.7a1784be@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0907221014210.2935-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 		free resources
> > 		wake any pending openers
> 
> Where exactly is the code that wakes the other openers?

tty_port_close_end wakes port->open_wait

if another opener was blocked during the hangup they then exit
tty_blocked_until_ready and error

if another open occurs after the hangup completes (but while the other
use has the port open bug hung up then they will execute

	serial_open()
		->type->open()

> To rephrase the question above, how is the device driver made aware 
> that it needs to reallocate resources and restart the uart?

For the case where it needs to do that the hangup will have finished and
it will get another call to serial_open()

> There's an obvious race here between hangup and close.  The assignment 
> of hung_up_tty_fops to filp->f_op is protected by the BKL and not much 
> else.  Does the code in tty_release_dev() check to see whether this 
> assignment has been made before calling tty->ops->close()?  It doesn't 
> like like it to me.  With the wrong timing, you could end up telling 
> the device driver to stop the uart twice.

The core hangup and close code are interlocked (now - didn't use to be).

> > The tty notion of "open" is really open->hangup or open->close. Once the
> > hangup occurs you may have a file handle to a tty object but it doesn't
> > talk to hardware.
> 
> But it still talks to the device driver via tty_release_dev's call to 
> tty->ops->close.  How is the driver supposed to know that this method 
> call shouldn't talk to the hardware?

tty_hung_up_p() will be true

> In fact, what point is there in making the call at all?  Once the 
> hangup has occurred, the driver shouldn't do _anything_ when the 
> corresponding release happens.  As you say, the notion is open->hangup 
> or open->close, not open->(hangup followed by close).

Beats me - not something I designed. However the driver would always need
to be aware of it because the following can occur

			CPU1			CPU2
			close begins
						hangup
						update ops
			close handler runs

The tty_port code handles that internally, but has to handle it anyway.

There are similar issues with all the other calls if they are pending and
I've not even begun to tackle them yet as they are basically
inconveniences only. Also because I'm still hoping someone will implement
revoke() on Linux and do all the hard work for me.

> What about the other historical model, a user sitting at a terminal and
> telling his modem to dial-out?  One wouldn't think the modem's device
> file would need to be reopened between calls.

The termios flags control this behaviour.

Alan

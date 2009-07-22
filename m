Return-Path: <linux-kernel-owner+w=401wt.eu-S1751586AbZGVOob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbZGVOob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbZGVOob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:44:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35813 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751380AbZGVOoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:44:30 -0400
Date: Wed, 22 Jul 2009 10:44:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Daniel Mack <daniel@caiaq.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
In-Reply-To: <20090721235512.7a1784be@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0907221014210.2935-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Alan Cox wrote:

> The sequences of behaviour for the tty interface are usually
> 
> 	open
> 		allocate resources
> 		start uart
> 
> 	do stuff
> 
> 	close
> 		stop uart
> 		free resources
> 
> and if a hang up occurs:
> 
> 	open
> 		allocate resources
> 		start uart
> 	do stuff
> 
> 	hangup event
> 		stop uart
> 		free resources
> 		wake any pending openers

Where exactly is the code that wakes the other openers?

> 
> 	[pending open completes]

Does this completion involve calling tty->ops->open()?  Or was it 
called earlier, before the open was forced to block?

> 		allocate resources
> 		start uart

To rephrase the question above, how is the device driver made aware 
that it needs to reallocate resources and restart the uart?

> 	[original opener closes]
> 	close
> 		was hung up
> 		do nothing much

There's an obvious race here between hangup and close.  The assignment 
of hung_up_tty_fops to filp->f_op is protected by the BKL and not much 
else.  Does the code in tty_release_dev() check to see whether this 
assignment has been made before calling tty->ops->close()?  It doesn't 
like like it to me.  With the wrong timing, you could end up telling 
the device driver to stop the uart twice.


> The tty notion of "open" is really open->hangup or open->close. Once the
> hangup occurs you may have a file handle to a tty object but it doesn't
> talk to hardware.

But it still talks to the device driver via tty_release_dev's call to 
tty->ops->close.  How is the driver supposed to know that this method 
call shouldn't talk to the hardware?

In fact, what point is there in making the call at all?  Once the 
hangup has occurred, the driver shouldn't do _anything_ when the 
corresponding release happens.  As you say, the notion is open->hangup 
or open->close, not open->(hangup followed by close).

> You need to open it again to get access again. Between
> hangup and close you are sitting on a dead file handle that returns
> errors if you use it. The hardware is owned by whoever opened it next.
> 
> The historical model for this is from dial in. A carrier drop is
> effectively a secure attention key, it has to kill off anything left on
> the port so an evil user cannot leave a key logger active on the port.

What about the other historical model, a user sitting at a terminal and
telling his modem to dial-out?  One wouldn't think the modem's device
file would need to be reopened between calls.

> > Eliminating the fake calls seems like the cleanest solution.  
> > Alternatively, we could keep the fake close (but not the fake release!)
> > and change serial_close() so that it calls serial_do_free() even if 
> > tty_port_close_start returns 0.
> 
> There are several other cases where tty_port_close_start returns zero
> (such as multiple openers and not being the last one)

I've seen the patch you just posted, and I agree -- it isn't the right
fix for the long run.  By all means, call tty->ops->shutdown in process
context and that's where we will release the port resources.

But the overall intent still isn't clear, not without the answers to 
the questions above.

Alan Stern


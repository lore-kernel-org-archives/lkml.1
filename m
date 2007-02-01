Return-Path: <linux-kernel-owner+w=401wt.eu-S1422943AbXBATJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422943AbXBATJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 14:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422947AbXBATJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 14:09:33 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2664 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422943AbXBATJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 14:09:32 -0500
Date: Thu, 1 Feb 2007 19:09:19 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Aubrey Li <aubreylee@gmail.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [BUG]: 2.6.19.2: Weird serial core issue
Message-ID: <20070201190919.GA18642@flint.arm.linux.org.uk>
Mail-Followup-To: Aubrey Li <aubreylee@gmail.com>,
	Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
References: <6d6a94c50701310249o2b2c8024i4d3f28ec1601246a@mail.gmail.com> <20070131162123.67e22e23@localhost.localdomain> <6d6a94c50701311833m5952c6fdn8e1f0db28d674e79@mail.gmail.com> <20070201094522.GA24608@flint.arm.linux.org.uk> <6d6a94c50702010209t94964ew1aebfad2677aa315@mail.gmail.com> <20070201111618.GA3462@flint.arm.linux.org.uk> <6d6a94c50702010954g7cb769y8cba30fbad658984@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d6a94c50702010954g7cb769y8cba30fbad658984@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 01:54:23AM +0800, Aubrey Li wrote:
> On 2/1/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> >serial core does not and should not "record" the terminal settings.
> >That's the job of the tty layer.
> 
> OK, if tty layer save the new terminal settings to an old one properly,
> How could this happen?

I don't understand that comment.

> >No.  You haven't analysed the call path causing tty_ioctl() to be
> >invoked, so you have no basis to point the finger *anywhere* at the
> >moment.
> >
> >Find out from where tty_ioctl() is called - maybe by adding a call
> >to dump_stack().  I think you'll find it is coming from userspace.
> >
> 
> If I recall correctly, the call path is as follows:
> 
> sys_ioctl->vfs_ioctl->do_ioctl->tty_ioctl->n_tty_ioctl->set_termios,

And here is the proof that it's *userspace* which is effecting this change.
If "sys_ioctl" is the very first function in the list then that's a result
of some userspace process issuing an ioctl.

> Yes, from the back trace stack, it appears to come from userspace. But
> I didn't startup any application. If there should be one, I think it's
> shell.

Shells typically alter the termios settings - eg, to turn off echo while
they're waiting for command input.  When command input has finished (by
pressing the enter key) they typically turn it back on.

Changing the termios settings while the shell is waiting for input is not
something they expect to happen, and this is the kind of behaviour I'd
expect in this scenario.

> I can't believe it's caused by the userspace, I'll go further to find
> the root cause.

Ho hum.  Guess you're in for a long investigation then. 8/

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

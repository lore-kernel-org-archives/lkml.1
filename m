Return-Path: <linux-kernel-owner+w=401wt.eu-S1422793AbXBARy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422793AbXBARy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 12:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422842AbXBARyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 12:54:25 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:41405 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422793AbXBARyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 12:54:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t1razkwTGqtqUk2Q8iLpNI5Sav2gZrzJkLWdkz7zd4vgP1cl6I4nHLJ+iK9VfhHOhCollE20KC9gToWfgCL2RFLvGpOQ+I4CExcFWdN3X390ndXGm/4Ipt1tdWvK2/Xwep7W33Sbl4/97iBVtaoLXF+emvTSG4AIHqE3aKmpU/8=
Message-ID: <6d6a94c50702010954g7cb769y8cba30fbad658984@mail.gmail.com>
Date: Fri, 2 Feb 2007 01:54:23 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Aubrey Li" <aubreylee@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [BUG]: 2.6.19.2: Weird serial core issue
In-Reply-To: <20070201111618.GA3462@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d6a94c50701310249o2b2c8024i4d3f28ec1601246a@mail.gmail.com>
	 <20070131162123.67e22e23@localhost.localdomain>
	 <6d6a94c50701311833m5952c6fdn8e1f0db28d674e79@mail.gmail.com>
	 <20070201094522.GA24608@flint.arm.linux.org.uk>
	 <6d6a94c50702010209t94964ew1aebfad2677aa315@mail.gmail.com>
	 <20070201111618.GA3462@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> On Thu, Feb 01, 2007 at 06:09:24PM +0800, Aubrey Li wrote:
> > On 2/1/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > >On Thu, Feb 01, 2007 at 10:33:40AM +0800, Aubrey Li wrote:
> > >> On 2/1/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> > >> >What code is running on that console at the time. Most likely that user
> > >> >code is also saving/restoring terminal settings so overwrite yours
> > >> >
> > >>
> > >> I implemented the serial driver by myself, :). See the attachment.
> > >> I didn't save/restore terminal setting in the my_set_termios().
> > >>
> > >> I trace this back till tty_tioctl(..., unsigned long arg), everytime I
> > >> type "ENTER" key,
> > >> the argument "arg" passed into tty_ioctl() is the address of a termios
> > >> structure, which include wrong c_cflag.
> > >
> > >If userspace is issuing an ioctl to re-enable crtscts, and the kernel
> > >is obliging, how can this be a kernel bug?
> >
> > But the fact is not.
> > 1) kernel boot up and enable crtscts by default
> > 2) issue an ioctl to disable crtscts.
> > 3) not do anything but type "ENTER", kernel re-enable crtscts.
> >
> > That's wrong. Terminal setting seems not be recorded by the serial core.
>
> serial core does not and should not "record" the terminal settings.
> That's the job of the tty layer.

OK, if tty layer save the new terminal settings to an old one properly,
How could this happen?

>
> > Is it clear?
>
> No.  You haven't analysed the call path causing tty_ioctl() to be
> invoked, so you have no basis to point the finger *anywhere* at the
> moment.
>
> Find out from where tty_ioctl() is called - maybe by adding a call
> to dump_stack().  I think you'll find it is coming from userspace.
>

If I recall correctly, the call path is as follows:

sys_ioctl->vfs_ioctl->do_ioctl->tty_ioctl->n_tty_ioctl->set_termios,

In set_termios, tmp_termios will be pointed to the argument "arg",
which includes the   wrong c_cflag.

Yes, from the back trace stack, it appears to come from userspace. But
I didn't startup any application. If there should be one, I think it's
shell.

But why shell remembers the initial terminal settings correctly, other
than last inital terminal settings? It must be passed from kernel
space, from tty layer, right?

I can't believe it's caused by the userspace, I'll go further to find
the root cause.

-Aubrey

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbZGaSxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbZGaSxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 14:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZGaSxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 14:53:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45199 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752296AbZGaSxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 14:53:05 -0400
Date: Fri, 31 Jul 2009 14:53:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <dbrownell@users.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 07/10] ehci-dbgp,ehci: Allow early or late use of the
 dbgp device
In-Reply-To: <4A73284B.6030903@windriver.com>
Message-ID: <Pine.LNX.4.44L0.0907311448460.2643-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009, Jason Wessel wrote:

> >> --- a/drivers/usb/host/ehci-hub.c
> >> +++ b/drivers/usb/host/ehci-hub.c
> >> @@ -816,6 +816,15 @@ static int ehci_hub_control (
> >>      case SetPortFeature:
> >>          selector = wIndex >> 8;
> >>          wIndex &= 0xff;
> >> +        if (unlikely(ehci->debug)) {
> >
> > Don't you need a similar test for ClearPortFeature?  Or does that not
> > matter?
> 
> I guess it depends if the user space tries to poke it, and then
> perhaps yes.  Do you know if that would be the case?

It's extremely unlikely.

> The rejection of the SetPortFeature at this level prevents the generic
> hub code from activating the port, in so far as all my tests cases
> show.
> 
> Given that it won't hurt anything to have the same code in the
> ClearPortFeature I can put it in.

It probably doesn't matter.

> >> +                retval = -ENODEV;
> >> +                goto error_exit;
> >
> > This is the wrong return value.  You should return -EPIPE, i.e., goto
> > error instead of error_exit.
> 
> 
> Do you have some insight as to how to account for the not using the
> port another way?  If I return -EPIPE, vs -ENODEV.  The kernel code
> does very different things.  I chose -ENODEV based on the results
> below.
> 
> With -ENODEV the kernel emits the following when trying to probe the
> usb port with the dbgp device.
> 
> 
> hub 2-0:1.0: cannot reset port 1 (err = -19)
> hub 2-0:1.0: cannot reset port 1 (err = -19)
> hub 2-0:1.0: cannot reset port 1 (err = -19)
> hub 2-0:1.0: cannot reset port 1 (err = -19)
> hub 2-0:1.0: unable to enumerate USB device on port 1
> 
> 
> With returning -EPIPE you get this result.
> 
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> USB Serial support registered for generic
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: cannot reset port 1 (err = -32)
> hub 2-0:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
> hub 2-0:1.0: unable to enumerate USB device on port 1
> 
> 
> I was looking for the easiest maintainable approach to disabling the
> physical port from getting reset by the HCD hub driver, which does
> different things depending on the error code that is passed back.

Evidently I was wrong; -ENODEV is better.

> Knowing what happens with -EPIPE, would you still prefer it to be
> changed that way?  Another possibility here is to implement the
> restriction on the port reset another way, if you have any
> suggestions.
> 
> In general folks may not need to use earlyprintk=dbpg,keep too often,
> but it sure is nice when it works because you can use it as a full
> console monitoring device after the /sbin/init handoff, including
> debugging USB printk's because the usb debug controller driver is
> completely separate.

What happens across a system suspend?

Alan Stern


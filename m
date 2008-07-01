Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYGAS1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYGAS1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYGAS1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:27:39 -0400
Received: from ns2.suse.de ([195.135.220.15]:42064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbYGAS1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:27:38 -0400
Date: Tue, 1 Jul 2008 11:25:43 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Becker <Stefan.Becker@nokia.com>
Cc: ext Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       ext David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ext Leonardo Chiquitto <leonardo.lists@gmail.com>
Subject: Re: [PATCH] USB: fix interrupt disabling for HCDs with shared
	interrupt handlers
Message-ID: <20080701182543.GA32098@suse.de>
References: <Pine.LNX.4.44L0.0807011005430.2780-100000@iolanthe.rowland.org> <486A590A.4090806@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486A590A.4090806@nokia.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 07:19:22PM +0300, Stefan Becker wrote:
> Hi Alan & Greg,
>
> third time is the charm (I hope)...
>
> ext Alan Stern wrote:
>> flags must be unsigned long.  You don't have to initialize it to 0.
>
> *Sigh* there are certain things you just shouldn't do when burning the 
> midnight oil. I changed the patch according to your suggestions and also 
> copied the comment for usb_hcd_irq() from David's changes.
>
> I hope this can still make it into 2.6.26, because it seems to solve a lot 
> of problems for the users out there...


Hm, isn't this also an issue in 2.6.25 as well?  I've had a few very
strange reports of USB just locking up in 2.6.25, could this also be the
cause there?

thanks,

greg k-h
> commit 89fa7659cb90f621513d7193b06cf19386451c33
> Author: Stefan Becker <stefan.becker@nokia.com>
> Date:   Mon Jun 30 21:18:29 2008 +0300
>
>    USB: fix interrupt disabling for HCDs with shared interrupt handlers
>       As has been discussed several times on LKML, IRQF_SHARED | 
> IRQF_DISABLED
>    doesn't work reliably, i.e. a shared interrupt handler CAN'T be certain 
> to
>    be called with interrupts disabled. Most USB HCD handlers use 
> IRQF_DISABLED
>    and therefore havoc can break out if they share their interrupt with a
>    handler that doesn't use it.
>       On my test machine the yenta_socket interrupt handler (no 
> IRQF_DISABLED)
>    was registered before ehci_hcd and one uhci_hcd instance. Therefore all
>    usb_hcd_irq() invocations for ehci_hcd and for one uhci_hcd instance
>    happened with interrupts enabled. That led to random lockups as USB core
>    HCD functions that acquire the same spinlock could be called twice
>    from interrupt handlers.
>       This patch updates usb_hcd_irq() to always disable/restore 
> interrupts.
>    usb_add_hcd() will silently remove any IRQF_DISABLED requested from HCD 
> code.
>       Signed-off-by: Stefan Becker <stefan.becker@nokia.com>

Alan and Dave, do you both ack this thing?  I know you've been involved
in creating it, just want to get the formal approval :)

thanks,

greg k-h

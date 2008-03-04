Return-Path: <linux-kernel-owner+w=401wt.eu-S1765445AbYCDQai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765445AbYCDQai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765125AbYCDQaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:30:01 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56789 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1765203AbYCDQ37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:29:59 -0500
Date: Tue, 4 Mar 2008 11:29:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>,
       Christian Kujau <lists@nerdbynature.de>
cc: LKML <linux-kernel@vger.kernel.org>, <0x0007@gmail.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
In-Reply-To: <alpine.DEB.1.00.0803032330190.5974@sheep.housecafe.de>
Message-ID: <Pine.LNX.4.44L0.0803041118100.4039-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Christian Kujau wrote:

> On Mon, 3 Mar 2008, Christian Kujau wrote:
> > after upgrading to 2.6.25-rc3, kern.log shows:
> >
> > [ 1535.884848] ------------[ cut here ]------------
> > [ 1535.884855] WARNING: at drivers/usb/host/ehci-hcd.c:287
> 
> Hm, after ~24h of uptime, this message appeared 25 times already.
> The WLAN USB device was used the whole time, the usb-storage module
> was hardly used over the day:
> 
> # grep usb /proc/interrupts
>   10:   10693403    XT-PIC-XT        ohci_hcd:usb3, eth0
>   11:   10270770    XT-PIC-XT        sym53c8xx, ehci_hcd:usb1
>   12:         91    XT-PIC-XT        ohci_hcd:usb2
> 
> I even tried to trigger the system freeze[0] by using usb-storage
> and reading a lot from it, but no freeze, and the message could
> not be triggered either - they pop up every now and then, but too often, 
> IMHO.
> 
> Can anybody shed some light on this?

Dave, it seems to me that this must be an example of a race between the 
iaa watchdog timer expiring and end_unlink_async() running.  It's not 
good enough for end_unlink_async() to call iaa_watchdog_done(), because 
on an SMP system the timer may already have fired and the watchdog 
routine may be spinning on ehci->lock.

It's even worse, because end_unlink_async() can call 
start_unlink_async().  If that happens, the watchdog routine will think 
the timer has expired when in fact it has just been restarted.

How about replacing the

	WARN_ON(!ehci->reclaim);

line in ehci_iaa_watchdog() with

	if (unlikely(!ehci->reclaim || 
			!HC_IS_RUNNING(ehci_to_hcd(ehci)->state) ||
			timer_pending(&ehci->iaa_watchdog))
		goto done;

where "done:" is added just before the spin_unlock_irqrestore?

Alan Stern


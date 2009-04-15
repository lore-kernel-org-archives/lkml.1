Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbZDOCpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbZDOCpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbZDOCo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:44:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:59161 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZDOCo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:44:56 -0400
Date: Tue, 14 Apr 2009 19:46:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090414194641.662fc976@infradead.org>
In-Reply-To: <49E5480F.10501@garzik.org>
References: <49E4FAC6.1030400@garzik.org>
	<20090415014930.GA29413@kroah.com>
	<49E5480F.10501@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 22:35:59 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Greg KH wrote:
> > On Tue, Apr 14, 2009 at 05:06:14PM -0400, Jeff Garzik wrote:
> >> Once of the x86-64 machines I use for testing runs off of two 2GB
> >> USB flash drives, one for Fedora 10 userland, and one for kernel
> >> repository 
> >> + builds.
> >>
> >> It boots correctly in 2.6.27, but fails with the same symptoms in 
> >> 2.6.28, 2.6.29 and 2.6.30-rc1:
> >>
> >> 	1) The kernel boots
> >> 	2) After time passes, kernel begins executing initramfs
> >> 	   userland
> >> 	3) the kernel prints out probe messages for the USB
> >> keyboard, SCSI probe messages for the two USB flash drives
> >>
> >> Or IOW, the keyboard and two SCSI drives appear after initramfs
> >> begins booting.  And this is for drivers built into the kernel
> >> (though same behavior with modules).
> >>
> >> This no-boot regression is 100% reproducible, and neatly bisects
> >> down to
> >>
> >>> commit 8520f38099ccfdac2147a0852f84ee7a8ee5e197
> >>> Author: Alan Stern <stern@rowland.harvard.edu>
> >>> Date:   Mon Sep 22 14:44:26 2008 -0400
> >>>
> >>>     USB: change hub initialization sleeps to delayed_work
> >>>     
> >>>     This patch (as1137) changes the hub_activate() routine,
> >>> replacing the power-power-up and debounce delays with
> >>> delayed_work calls.  The idea is that on systems where the USB
> >>> stack is compiled into the kernel rather than built as modules,
> >>> these delays will no longer block the boot thread.  At least 100
> >>> ms is saved for each root hub, which can add up to a significant
> >>> savings in total boot time. 
> >>>     Arjan van de Ven was very pleased to see that this shaved 700
> >>> ms off his computer's boot time.  Since his total boot time is on
> >>> the order of two seconds, the improvement is considerable.
> >>>     
> >>>     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> >>>     Tested-by: Arjan van de Ven <arjan@infradead.org>
> >>>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >>
> >> My preliminary guess is that this made things --too--
> >> asynchronous, and for some reason userland begins executing before
> >> the SCSI core initializes the USB storage as Linux block devices.
> >>
> >> In any case, I cannot boot because of the above commit :)
> > 
> > Like Arjan said, this is because we are initializing faster now, and
> > things are a bit more asynchronous.  Use the root_delay boot option,
> > that's what I use for my USB-based systems, and have not had a
> > problem with that at all.
> 
> Is that solution really scalable to every user with a regression
> severe enough it prevents them from booting?
> 
> When did regressions become an acceptable tradeoff for speed?
> 
> This system boots just fine under kernel 2.6.27, 2.6.26, 2.6.25, and
> so on.  Switch the kernel to 2.6.28, and it no longer boots.  A
> regression cannot get more clear than that.

You had pure luck though.

We used to wait 100 msec per USB bus.
A normal laptop has like 5 of these.
if your usb storage was in the first one, basically you got a "free"
500msec delay there. You are/were happy.

Now.. if you stuck your disk in the last port you would get a 100msec
delay. Probably not enough for what you want. But you didn't stick
your disk there....

In the new code all ports get their power turned on and THEN things
wait... so all ports get the 100 msec treatment, not the
500/400/300/200/100 staggering.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

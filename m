Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbZDOBxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbZDOBxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZDOBxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:53:20 -0400
Received: from kroah.org ([198.145.64.141]:50127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753109AbZDOBxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:53:19 -0400
Date: Tue, 14 Apr 2009 18:49:44 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090415014930.GA29413@kroah.com>
References: <49E4FAC6.1030400@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E4FAC6.1030400@garzik.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 05:06:14PM -0400, Jeff Garzik wrote:
> 
> Once of the x86-64 machines I use for testing runs off of two 2GB USB 
> flash drives, one for Fedora 10 userland, and one for kernel repository 
> + builds.
> 
> It boots correctly in 2.6.27, but fails with the same symptoms in 
> 2.6.28, 2.6.29 and 2.6.30-rc1:
> 
> 	1) The kernel boots
> 	2) After time passes, kernel begins executing initramfs
> 	   userland
> 	3) the kernel prints out probe messages for the USB keyboard,
> 	   SCSI probe messages for the two USB flash drives
> 
> Or IOW, the keyboard and two SCSI drives appear after initramfs begins 
> booting.  And this is for drivers built into the kernel (though same 
> behavior with modules).
> 
> This no-boot regression is 100% reproducible, and neatly bisects down to
> 
> > commit 8520f38099ccfdac2147a0852f84ee7a8ee5e197
> > Author: Alan Stern <stern@rowland.harvard.edu>
> > Date:   Mon Sep 22 14:44:26 2008 -0400
> > 
> >     USB: change hub initialization sleeps to delayed_work
> >     
> >     This patch (as1137) changes the hub_activate() routine, replacing the
> >     power-power-up and debounce delays with delayed_work calls.  The idea
> >     is that on systems where the USB stack is compiled into the kernel
> >     rather than built as modules, these delays will no longer block the
> >     boot thread.  At least 100 ms is saved for each root hub, which can
> >     add up to a significant savings in total boot time.
> >     
> >     Arjan van de Ven was very pleased to see that this shaved 700 ms off
> >     his computer's boot time.  Since his total boot time is on the order
> >     of two seconds, the improvement is considerable.
> >     
> >     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> >     Tested-by: Arjan van de Ven <arjan@infradead.org>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> 
> My preliminary guess is that this made things --too-- asynchronous, and 
> for some reason userland begins executing before the SCSI core 
> initializes the USB storage as Linux block devices.
> 
> In any case, I cannot boot because of the above commit :)

Like Arjan said, this is because we are initializing faster now, and
things are a bit more asynchronous.  Use the root_delay boot option,
that's what I use for my USB-based systems, and have not had a problem
with that at all.

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S933912AbXC0RPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912AbXC0RPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933908AbXC0RPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:15:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42968 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933912AbXC0RPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:15:15 -0400
Date: Tue, 27 Mar 2007 13:15:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       <gregkh@suse.de>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
In-Reply-To: <200703271824.46804.maximlevitsky@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703271306230.2558-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007, Maxim Levitsky wrote:

> Hi,
> 	I noticed that after suspend/resume cycle all my usb devices are unplugged/replugged by uhci driver.
> While it is not that big problem to me, that can be a real problem if a device is a flash card with mounted 
> file-system, because disappeared device will cause file-system corruption.
> 
> I found why this happens.
> 
> drivers/usb/host/pci-quirks.c:uhci_check_and_reset_hc checks that the BIOS didn't play with USB controller, and on my system
> with or without a USB Legacy support turned on in the BIOS, the BIOS does meddle with USB controller,
> 
> But I suggest adding a option that will allow the user to bypass that check, because for example on my system USB works perfectly
> if I disable the checks that this function does (but I agree that those checks are  very valuable, since I almost sure that on many systems USB
> won't work without resetting the USB controller.)

No.  It just isn't safe to do that.  If the BIOS has done something to the
controller then it may very well have reset the attached devices too.  Or
changed their addresses, or done something else equally drastic.

> Secondary,  this function checks for UHCI_USBCMD_CONFIGURE, that is not set on resume,
> According to both UHCI and ICH8 documentation this is software only bit, but I didn't find any place in kernel where it is set,
> (But such place exist, because reading from usb IO ports confirm that it is set during normal work, I will try to find it)

It is set in drivers/usb/host/uhci-hcd.c:start_rh().

> Disabling both check for UHCI_USBLEGSUP and UHCI_USBCMD_CONFIGURE makes all usb devices (I have mouse,keyborad, and joystick)
> work fine on resume from ram without this "virtual" replugging.

The UHCI specification is rather sparse in many respects, and it doesn't 
say what the host firmware should or should not do during a resume.  So 
the driver has to be very conservative and assume that any indication of a 
change means that the entire controller must be reset.

> Suspend to disk still causes "virtual replugging"  and I think that controller is reset and will unplug/replug devices anyway
> Resolving this problem is very difficult. Maybe it possible to check on unplugging event that this caused by suspend  if the same device is
> replugged then don't remove/reinstall driver, but this is very difficult to implement properly,
> Maybe just refuse to suspend if some valuable device is connected (sorry if it is done this way already)

Long ago I posted a patch that would take care of all this.  Not just for
UHCI, but for any USB controller.  Maybe I should dig it out, update it,
and submit it.

> Also I want to note that I didn't yet checked any EHCI devices, because I don't have any (I am going to buy a usb stick soon)
> But I feel that the above will be true for ehci too....

EHCI controllers tend to be better behaved than UHCI controllers, perhaps
because the specification is much more careful to explain what must be
done.  In many cases a computer can resume from suspend-to-RAM with all 
the EHCI-connected devices still intact.

Alan Stern


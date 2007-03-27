Return-Path: <linux-kernel-owner+w=401wt.eu-S934084AbXC0Ry5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084AbXC0Ry5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934080AbXC0Ry5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:54:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:47656 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934086AbXC0Ryz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=U8pNLqOEr+guS342MzJExs6YlUp8fYsMP2kA6pyXHsgNptmIHK3xHwdQNiKqAntiD6RYC4QCxUREJH6nSZoaQKJUfEKpNsvzWggSZ5E+tHrI77N+i5M4svdjnmHxq4gTSa6sp0gaBdu+bcGF3T3jmniq9Df0xjIOVDG/r+e1eqM=
From: Maxim <maximlevitsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
Date: Tue, 27 Mar 2007 19:54:42 +0200
User-Agent: KMail/1.9.6
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       gregkh@suse.de
References: <Pine.LNX.4.44L0.0703271306230.2558-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0703271306230.2558-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703271954.42628.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 March 2007 19:15:14 Alan Stern wrote:
> On Tue, 27 Mar 2007, Maxim Levitsky wrote:
> 
> > Hi,
> > 	I noticed that after suspend/resume cycle all my usb devices are unplugged/replugged by uhci driver.
> > While it is not that big problem to me, that can be a real problem if a device is a flash card with mounted 
> > file-system, because disappeared device will cause file-system corruption.
> > 
> > I found why this happens.
> > 
> > drivers/usb/host/pci-quirks.c:uhci_check_and_reset_hc checks that the BIOS didn't play with USB controller, and on my system
> > with or without a USB Legacy support turned on in the BIOS, the BIOS does meddle with USB controller,
> > 
> > But I suggest adding a option that will allow the user to bypass that check, because for example on my system USB works perfectly
> > if I disable the checks that this function does (but I agree that those checks are  very valuable, since I almost sure that on many systems USB
> > won't work without resetting the USB controller.)
> 
> No.  It just isn't safe to do that.  If the BIOS has done something to the
> controller then it may very well have reset the attached devices too.  Or
> changed their addresses, or done something else equally drastic.

I agree, I was only saying a option to override this check, for users who know that this is not the case.

> 
> > Secondary,  this function checks for UHCI_USBCMD_CONFIGURE, that is not set on resume,
> > According to both UHCI and ICH8 documentation this is software only bit, but I didn't find any place in kernel where it is set,
> > (But such place exist, because reading from usb IO ports confirm that it is set during normal work, I will try to find it)
> 
> It is set in drivers/usb/host/uhci-hcd.c:start_rh().
Thanks a lot, it would take a lot of time to find that out to me,
> 
> > Disabling both check for UHCI_USBLEGSUP and UHCI_USBCMD_CONFIGURE makes all usb devices (I have mouse,keyborad, and joystick)
> > work fine on resume from ram without this "virtual" replugging.
> 
> The UHCI specification is rather sparse in many respects, and it doesn't 
> say what the host firmware should or should not do during a resume.  So 
> the driver has to be very conservative and assume that any indication of a 
> change means that the entire controller must be reset.
> 
> > Suspend to disk still causes "virtual replugging"  and I think that controller is reset and will unplug/replug devices anyway
> > Resolving this problem is very difficult. Maybe it possible to check on unplugging event that this caused by suspend  if the same device is
> > replugged then don't remove/reinstall driver, but this is very difficult to implement properly,
> > Maybe just refuse to suspend if some valuable device is connected (sorry if it is done this way already)
> 
> Long ago I posted a patch that would take care of all this.  Not just for
> UHCI, but for any USB controller.  Maybe I should dig it out, update it,
> and submit it.
This sounds great, where is it ? .... :-)
This will improve linux suspend to ram/disk a lot.
> 
> > Also I want to note that I didn't yet checked any EHCI devices, because I don't have any (I am going to buy a usb stick soon)
> > But I feel that the above will be true for ehci too....
> 
> EHCI controllers tend to be better behaved than UHCI controllers, perhaps
> because the specification is much more careful to explain what must be
> done.  In many cases a computer can resume from suspend-to-RAM with all 
> the EHCI-connected devices still intact.
Big thanks, maybe usb stick I am going to buy will work with suspend to ram....
> 
> Alan Stern
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Hi,

	Thanks a lot for so quick reply,
	I want to note to myself that making a assumptions generally a bad idea,
	Until now I thought that linux always unplugs/re plugs usb devices on suspend/resume,
	that this is normal, but it looks that linux is better... :-)

	Best regards,
		Maxim Levitsky

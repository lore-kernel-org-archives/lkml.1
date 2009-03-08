Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZCHD1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZCHD1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 22:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZCHD1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 22:27:30 -0500
Received: from netrider.rowland.org ([192.131.102.5]:43587 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753210AbZCHD13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 22:27:29 -0500
Date: Sat, 7 Mar 2009 22:27:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Loading both ehci-hcd and uhci-hcd drivers causes my
 printer to fail
In-Reply-To: <1236457327.6077.83.camel@maxim-laptop>
Message-ID: <Pine.LNX.4.44L0.0903072219240.8870-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Mar 2009, Maxim Levitsky wrote:

> On Sat, 2009-03-07 at 11:52 -0800, Greg KH wrote:
> > On Sat, Mar 07, 2009 at 09:20:44PM +0200, Maxim Levitsky wrote:
> > > Hi,
> > > 
> > > Short summary:
> > > 
> > > I have HP1018 printer, and it works well in windows.
> > > When I use in in linux, I often see messages like:
> > > 
> > > usbfs: USBDEVFS_CONTROL failed cmd python rqt 128 rq 6 len 255 ret -110
> > > 
> > > This is using hp backend that talks to printer using usbfs.
> > > I also tried usblp, but it just doesn't say anything in kernel log. I
> > > think it silently ignores similar errors, because the end result is the
> > > same, the printer sometimes works, but sometimes doesn't.
> > > (printer needs firmware to be uploaded to it, and I do upload it).
> > > 
> > > On the other hand, IF I remove _ether_ ehci-hcd or uhci-hcd from kernel,
> > > then everything works fine, I already rebooted the printer many times,
> > > used it to print, upload firmware, and everything just work, but as soon
> > > as I load the second driver it fails in same way again.
> > > 
> > > USB issues with this class of printers are nothing but new, for example
> > > see:
> > > 
> > > http://foo2zjs.rkkda.com/forum/read.php?9,374
> > > https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/54419
> > 
> > What kernel version are you using?
> > 
> > > I compiled without CONFIG_USB_EHCI_ROOT_HUB_TT
> > > and it did help (didn't that much testing, but at least firmware loads
> > > ok, and no error messages)
> > 
> > Can you provide the full kernel log messages from when you plug in your
> > printer?  Are there any other messages saying that you need to be sure
> > to load one driver before the other?
> I am familiar with these messages, maybe instead uhci should depend on
> ehci or something like that?

No, adding a dependency won't work because it is valid to load 
uhci-hcd without ehci-hcd.  The only time a problem occurs is if you 
load both of them in the wrong order.  (And in fact it's pretty rare 
for that to cause a real problem -- mostly you just get some annoying 
messages in the log.)

> Tommorow I try to load them manually in correct order.
> Btw, if I unload both and then load first ehci then uhci, this is ok
> (if they were loaded incorrectly)
> 
> 
> Confirm again that without CONFIG_USB_EHCI_ROOT_HUB_TT both drivers
> work.
> 
> dmesg (from /var/log/kern.log.0) attached
> It shows how I rebooted the printer often.
> It also have this error message about the order.
> 
> But this isn't related.
> I currently blacklisted uhci-hcd, so only ehci-hcd gets loaded.
> Then I loaded the uhci, and got same bug
> (This is why I attached an older dmesg, if you need I reproduce that bug
> again)

The dmesg you attached shows that you unloaded uhci-hcd but the printer 
still failed to work.  This contradicts your statement above that if 
you remove either driver then everything works fine.

The information in the log isn't really enough to tell what's 
happening.  It would be better if you could provide a usbmon trace 
showing the problem.

CONFIG_USB_EHCI_ROOT_HUB_TT shouldn't make any difference at all.  
That setting matters only for hardware using the ARC/TDI design, which
is not present in your Intel chipset.  Likewise, provided ehci-hcd is
loaded first, it shouldn't make any difference whether uhci-hcd is
loaded or not.

Alan Stern


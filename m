Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbZCHQJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbZCHQJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZCHQJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:09:28 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:52242 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZCHQJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SVmhJkNFPE8CkmutxV7RqVSRtkvCQYa5Y6vTalmucfX8LhZ8fHoPOLXqxKWYggATIy
         9AW0bL7d+0jOcUccIR7lz7dkWW/7zDSEmDNdNK+8nOF24XrUC41mxzCWuYyxdczShMVM
         IZFjv/fg15M0hk+3/qqQO9RfyViNV22Oz5PHs=
Subject: Re: [BUG] Loading both ehci-hcd and uhci-hcd drivers causes my
 printer to fail
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0903072219240.8870-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0903072219240.8870-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 18:09:18 +0200
Message-Id: <1236528558.11774.50.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-07 at 22:27 -0500, Alan Stern wrote:
> On Sat, 7 Mar 2009, Maxim Levitsky wrote:
> 
> > On Sat, 2009-03-07 at 11:52 -0800, Greg KH wrote:
> > > On Sat, Mar 07, 2009 at 09:20:44PM +0200, Maxim Levitsky wrote:
> > > > Hi,
> > > > 
> > > > Short summary:
> > > > 
> > > > I have HP1018 printer, and it works well in windows.
> > > > When I use in in linux, I often see messages like:
> > > > 
> > > > usbfs: USBDEVFS_CONTROL failed cmd python rqt 128 rq 6 len 255 ret -110
> > > > 
> > > > This is using hp backend that talks to printer using usbfs.
> > > > I also tried usblp, but it just doesn't say anything in kernel log. I
> > > > think it silently ignores similar errors, because the end result is the
> > > > same, the printer sometimes works, but sometimes doesn't.
> > > > (printer needs firmware to be uploaded to it, and I do upload it).
> > > > 
> > > > On the other hand, IF I remove _ether_ ehci-hcd or uhci-hcd from kernel,
> > > > then everything works fine, I already rebooted the printer many times,
> > > > used it to print, upload firmware, and everything just work, but as soon
> > > > as I load the second driver it fails in same way again.
> > > > 
> > > > USB issues with this class of printers are nothing but new, for example
> > > > see:
> > > > 
> > > > http://foo2zjs.rkkda.com/forum/read.php?9,374
> > > > https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/54419
> > > 
> > > What kernel version are you using?
> > > 
> > > > I compiled without CONFIG_USB_EHCI_ROOT_HUB_TT
> > > > and it did help (didn't that much testing, but at least firmware loads
> > > > ok, and no error messages)
> > > 
> > > Can you provide the full kernel log messages from when you plug in your
> > > printer?  Are there any other messages saying that you need to be sure
> > > to load one driver before the other?
> > I am familiar with these messages, maybe instead uhci should depend on
> > ehci or something like that?
> 
> No, adding a dependency won't work because it is valid to load 
> uhci-hcd without ehci-hcd.  The only time a problem occurs is if you 
> load both of them in the wrong order.  (And in fact it's pretty rare 
> for that to cause a real problem -- mostly you just get some annoying 
> messages in the log.)
But since it can cause a problem, this has to be somehow automatically
fixed isn't it?
For example how to I ensure the correct order with udev?



> 
> > Tommorow I try to load them manually in correct order.
> > Btw, if I unload both and then load first ehci then uhci, this is ok
> > (if they were loaded incorrectly)
> > 
> > 
> > Confirm again that without CONFIG_USB_EHCI_ROOT_HUB_TT both drivers
> > work.
> > 
> > dmesg (from /var/log/kern.log.0) attached
> > It shows how I rebooted the printer often.
> > It also have this error message about the order.
> > 
> > But this isn't related.
> > I currently blacklisted uhci-hcd, so only ehci-hcd gets loaded.
> > Then I loaded the uhci, and got same bug
> > (This is why I attached an older dmesg, if you need I reproduce that bug
> > again)
> 
> The dmesg you attached shows that you unloaded uhci-hcd but the printer 
> still failed to work.  This contradicts your statement above that if 
> you remove either driver then everything works fine.
We both yes and no:
#define	ETIMEDOUT	110

I forgot to tell you that without CONFIG_USB_EHCI_ROOT_HUB_TT or without
one of the drivers it is still possible to see that error, if I attempt
to query printer status while firmware is loading.
I think this is not a bug, and printer works after such message.
This is what you have seen in the logs, I tried to make the printer
crash, so I tried the above.




> 
> The information in the log isn't really enough to tell what's 
> happening.  It would be better if you could provide a usbmon trace 
> showing the problem.

> 
> CONFIG_USB_EHCI_ROOT_HUB_TT shouldn't make any difference at all.  
> That setting matters only for hardware using the ARC/TDI design, which
> is not present in your Intel chipset.  Likewise, provided ehci-hcd is
> loaded first, it shouldn't make any difference whether uhci-hcd is
> loaded or not.
Well, I retest this.
But it seems to work


> Alan Stern
> 

Best regards,
	Maxim Levitsky


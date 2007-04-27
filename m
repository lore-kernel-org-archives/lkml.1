Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbXD0Wm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbXD0Wm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbXD0Wm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:42:27 -0400
Received: from styx.suse.cz ([82.119.242.94]:49980 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754351AbXD0WmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:42:25 -0400
Date: Sat, 28 Apr 2007 00:42:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: "VE (HOME)" <ve@vetienne.net>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, fubar@us.ibm.com,
       Paul Walmsley <paul@booyaka.com>
Subject: Re: USB HID bug (was [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1)
In-Reply-To: <20070427211836.GC5917@kroah.com>
Message-ID: <Pine.LNX.4.64.0704280024170.7370@jikos.suse.cz>
References: <200704262058.33087.ve@vetienne.net> <20070426211146.f370cf81.akpm@linux-foundation.org>
 <010a01c788ae$0a7d0140$5601a8c0@apws2> <20070427211836.GC5917@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Greg KH wrote:

> >  BUG: at drivers/hid/usbhid/hid-quirks.c:480 usbhid_exists_dquirk()
[ .. stacktraces stripped .. ]
> Jiri, any thoughts about this?  This looks like it comes from your tree
> as 2.6.21 doesn't have the drivers/hid/usbhid/ directory...

Paul (author of the corresponding patch) added to CC. 

This BUG (it's in fact a warning) is this one:

       WARN_ON(idVendor == 0);

I now don't immediately see how this could happen - the vendor ID seems to 
be propagated properly from hid_probe() (nothing has been changed in this 
codepath), so this would mean that hid_probe() has been passed 
usb_interface for which 
le16_to_cpu(interface_to_usbdev(intf).dev->descriptor.idVendor) is equal 
to zero ...  and this definitely shouldn't happen for any sane device 
(could the original poster please verify with lsusb, just to be 100% 
sure?).

It would also help if the original poster, who is able to reproduce this 
WARN_ON, would verify whether hid_probe() is really being passed such 
strange usb_interface from upper USB layer ... please see the patch below, 
and send me the output if possible.

Paul, do you have any idea? In fact, what was your reason for putting this 
WARN_ON() there? Did you ever meet any condition when idVendor == 0 
appears there?

Thanks.

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index f929dee..2a77d8b 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -984,6 +984,8 @@ static int hid_probe(struct usb_interfac
 	dbg("HID probe called for ifnum %d",
 			intf->altsetting->desc.bInterfaceNumber);
 
+	printk(KERN_DEBUG "DEBUG - hid_probe: idVendor: %x\n", 
+			le16_to_cpu(interface_to_usbdev(intf)->descriptor.idVendor));
 	if (!(hid = usb_hid_configure(intf)))
 		return -ENODEV;
 

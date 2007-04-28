Return-Path: <linux-kernel-owner+w=401wt.eu-S1161504AbXD1HVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161504AbXD1HVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161534AbXD1HVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:21:23 -0400
Received: from mail1.vetienne.net ([87.98.219.23]:3040 "EHLO
	mail1.vetienne.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161504AbXD1HVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:21:22 -0400
From: Vincent ETIENNE <ve@vetienne.net>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: USB HID bug (was [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1)
Date: Sat, 28 Apr 2007 09:21:18 +0200
User-Agent: KMail/1.9.6
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Paul Walmsley <paul@booyaka.com>
References: <200704262058.33087.ve@vetienne.net> <20070427211836.GC5917@kroah.com> <Pine.LNX.4.64.0704280024170.7370@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0704280024170.7370@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704280921.19265.ve@vetienne.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Saturday 28 April 2007 00:42:45 Jiri Kosina, vous avez écrit :
> On Fri, 27 Apr 2007, Greg KH wrote:
> > >  BUG: at drivers/hid/usbhid/hid-quirks.c:480 usbhid_exists_dquirk()
>
> [ .. stacktraces stripped .. ]
>
> > Jiri, any thoughts about this?  This looks like it comes from your tree
> > as 2.6.21 doesn't have the drivers/hid/usbhid/ directory...
>
> Paul (author of the corresponding patch) added to CC.
>
> This BUG (it's in fact a warning) is this one:
>
>        WARN_ON(idVendor == 0);
>
> I now don't immediately see how this could happen - the vendor ID seems to
> be propagated properly from hid_probe() (nothing has been changed in this
> codepath), so this would mean that hid_probe() has been passed
> usb_interface for which
> le16_to_cpu(interface_to_usbdev(intf).dev->descriptor.idVendor) is equal
> to zero ...  and this definitely shouldn't happen for any sane device
> (could the original poster please verify with lsusb, just to be 100%
> sure?).

You could download the result of lsusb -vvv from 
http://mail1.vetienne.net/linux/lsusb.log

>
> It would also help if the original poster, who is able to reproduce this
> WARN_ON, would verify whether hid_probe() is really being passed such
> strange usb_interface from upper USB layer ... please see the patch below,
> and send me the output if possible.
>
> Paul, do you have any idea? In fact, what was your reason for putting this
> WARN_ON() there? Did you ever meet any condition when idVendor == 0
> appears there?
>
> Thanks.
>
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index f929dee..2a77d8b 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -984,6 +984,8 @@ static int hid_probe(struct usb_interfac
>  	dbg("HID probe called for ifnum %d",
>  			intf->altsetting->desc.bInterfaceNumber);
>
> +	printk(KERN_DEBUG "DEBUG - hid_probe: idVendor: %x\n",
> +			le16_to_cpu(interface_to_usbdev(intf)->descriptor.idVendor));
>  	if (!(hid = usb_hid_configure(intf)))
>  		return -ENODEV;

With your patch it seems like idVendor passed is 0. You could see it there ;

http://mail1.vetienne.net/linux/dmesg.2.6.21-rc7-mm2+patch-usbhid

I could confirm that the keyboard is working ( yesterday i was just behind the 
box due to test on the network ). But i don't remember if the keyboard is USB 
or PS2 (i only have ssh access to the box for the next 3/4 days)

  Vincent

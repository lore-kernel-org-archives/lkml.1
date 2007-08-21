Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbXHULhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbXHULhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbXHULhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:37:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:63518 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbXHULhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:37:23 -0400
Subject: Re: [linux-usb-devel] why was MODALIAS removed from usb kernel
	events? [u]
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: "Andreas Jellinghaus [c]" <aj@ciphirelabs.com>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
In-Reply-To: <20070821073656.GA6691@kroah.com>
References: <200708171622.05115.aj@ciphirelabs.com>
	 <20070821073656.GA6691@kroah.com>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 13:41:08 +0200
Message-Id: <1187696468.2489.10.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18uPka7ZMMxxwjK3+k03fpTVuGstMwsCgGeRJ3
 0solV6CtGDxgzxwq9L9+Wu+8iUO29eJ+GDRqdELit11rxVWqrv
 pKClc5+8Orcdn58jpMiGX+h90vNOmlR
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 00:36 -0700, Greg KH wrote: 
> On Fri, Aug 17, 2007 at 04:22:04PM +0200, Andreas Jellinghaus [c] wrote:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9f8b17e643fe6aa505629658445849397bda4e4f
> > 
> > removes MODALIAS from one of the events,
> 
> Which event?
> 
> If you enable CONFIG_USB_DEVICE_CLASS, does everything work the same
> again?
> 
> > this breaks user space applications like openct - everything that
> > depends on getting an event that has both the DEVICE= path to the usb
> > device and any information on the interface, so it can check if the
> > device is something it supports (in case of openct: smart card reader,
> > i.e. bInterfaceClass 0b).
> 
> What specific udev rule are you matching against here that is now
> broken?
> 
> > The text does not mention MODALIAS nor the reason for it's removal.
> 
> The reason is we don't need the usb_device class anymore, but we still
> provide for the compatibility if you have an old distro with old udev
> rules that is expecting it (only rule we ran into was the one for the
> usbfs /dev nodes, but there might be more.)
> 
> confused,

Hmm, I'm a bit confused too. :)

The subject says MODALIAS was removed, but I don't think that it ever
was there for a usb-device event. And sure, it's still there for a
usb-interface event.

Andreas, do I read this right, you miss:
  DEVICE, PRODUCT, TYPE
in the usb-interface event, and they only exist in the usb-device event?

And MODALIAS is not what you miss, and the subject of the mail is
misleading?

Note:
DEVICE only exists when USB_DEVICE_CLASS=y, because it unfortunately is
prefixed with the /proc mount path, which doesn't exist when the /proc
device node support is not compiled in, so nothing should depend on the
existence of DEVICE. Most of the recent distros don't mount or configure
usbfs anymore, but use /dev/bus/usb/ device nodes, which can handle
access control lists for local users.

Is this patch fixing your problem?


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: usb: add PRODUCT, TYPE to usb-interface events

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

 message.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index b6bd05e..3b57d53 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1358,6 +1358,30 @@ static int usb_if_uevent(struct device *dev, char **envp, int num_envp,
 	usb_dev = interface_to_usbdev(intf);
 	alt = intf->cur_altsetting;
 
+#ifdef CONFIG_USB_DEVICEFS
+	if (add_uevent_var(envp, num_envp, &i,
+			   buffer, buffer_size, &length,
+			   "DEVICE=/proc/bus/usb/%03d/%03d",
+			   usb_dev->bus->busnum, usb_dev->devnum))
+		return -ENOMEM;
+#endif
+
+	if (add_uevent_var(envp, num_envp, &i,
+			   buffer, buffer_size, &length,
+			   "PRODUCT=%x/%x/%x",
+			   le16_to_cpu(usb_dev->descriptor.idVendor),
+			   le16_to_cpu(usb_dev->descriptor.idProduct),
+			   le16_to_cpu(usb_dev->descriptor.bcdDevice)))
+		return -ENOMEM;
+
+	if (add_uevent_var(envp, num_envp, &i,
+			   buffer, buffer_size, &length,
+			   "TYPE=%d/%d/%d",
+			   usb_dev->descriptor.bDeviceClass,
+			   usb_dev->descriptor.bDeviceSubClass,
+			   usb_dev->descriptor.bDeviceProtocol))
+		return -ENOMEM;
+
 	if (add_uevent_var(envp, num_envp, &i,
 		   buffer, buffer_size, &length,
 		   "INTERFACE=%d/%d/%d",


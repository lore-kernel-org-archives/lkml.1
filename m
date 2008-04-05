Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbYDEDrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbYDEDrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 23:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYDEDrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 23:47:03 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2350 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751230AbYDEDrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 23:47:01 -0400
Date: Fri, 4 Apr 2008 23:46:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>, Greg KH <greg@kroah.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb unbind/bind => WARNING at fs/sysfs/dir.c [Was: 2.6.25-rc8-mm1]
In-Reply-To: <Pine.LNX.4.44L0.0804041721080.2175-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.0804042331460.16995-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, Alan Stern wrote:

> On Fri, 4 Apr 2008, Greg KH wrote:
> 
> > On Fri, Apr 04, 2008 at 10:16:32PM +0200, Jiri Slaby wrote:
> > > On 04/02/2008 06:32 AM, Andrew Morton wrote:
> > >> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/
> > >
> > > After
> > > $ echo -n 4-1.2 >/sys/bus/usb/drivers/usb/unbind
> > > $ echo -n 4-1.2 >/sys/bus/usb/drivers/usb/bind
> > >
> > > I have this in logs:
> > >
> > > sysfs: duplicate filename 'usbdev4.12_ep81' can not be created
> > 
> > Does this also show up in 2.6.25-rc8 without -mm?
> > 
> > I thought I fixed this already, I don't see what slipped into -mm that
> > would have caused it to come back.  Time to run some more tests...
> > 
> > Oh, also note that binding and unbinding the main "usb" driver is not
> > encouraged, or even supported.  I'm amazed it works, as this is not
> > something that any "real" user would do as it makes no sense at all
> > because we have no "alternative" drivers yet for the main USB device.
> 
> It's a real bug.  I don't have time to track it down now.  Next week...

Here's the answer.  The bug was introduced when the definition of 
device_is_registered() in include/linux/device.h was changed.  The old 
definition returned 0 when called inside a driver's remove method for a 
device being unregistered, whereas the new definition returns 1.  I 
don't know when this change was made.

This patch ought to fix the problem.  Jiri, can you confirm that it 
works?

Alan Stern

-----------------------------------------------------------

Removing an interface's sysfs files before unregistering the interface
doesn't work properly, because usb_unbind_interface() will reinstall
altsetting 0 and thereby create new sysfs files.  This patch (as1074)
removes the files after the unregistration is finished.  It's not
quite as clean, but at least it works.

Also, there's no need to check if an interface has been registered
before removing its sysfs files.  If it hasn't been registered then
the files won't have been created, so usb_remove_sysfs_intf_files()
will simply do nothing.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/usb/core/message.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/message.c
+++ usb-2.6/drivers/usb/core/message.c
@@ -1089,8 +1089,8 @@ void usb_disable_device(struct usb_devic
 				continue;
 			dev_dbg(&dev->dev, "unregistering interface %s\n",
 				interface->dev.bus_id);
-			usb_remove_sysfs_intf_files(interface);
 			device_del(&interface->dev);
+			usb_remove_sysfs_intf_files(interface);
 		}
 
 		/* Now that the interfaces are unbound, nobody should
@@ -1231,7 +1231,7 @@ int usb_set_interface(struct usb_device 
 	 */
 
 	/* prevent submissions using previous endpoint settings */
-	if (iface->cur_altsetting != alt && device_is_registered(&iface->dev))
+	if (iface->cur_altsetting != alt)
 		usb_remove_sysfs_intf_files(iface);
 	usb_disable_interface(dev, iface);
 
@@ -1330,8 +1330,7 @@ int usb_reset_configuration(struct usb_d
 		struct usb_interface *intf = config->interface[i];
 		struct usb_host_interface *alt;
 
-		if (device_is_registered(&intf->dev))
-			usb_remove_sysfs_intf_files(intf);
+		usb_remove_sysfs_intf_files(intf);
 		alt = usb_altnum_to_altsetting(intf, 0);
 
 		/* No altsetting 0?  We'll assume the first altsetting.


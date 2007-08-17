Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbXHQRM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbXHQRM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 13:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbXHQRMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 13:12:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60555 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753817AbXHQRMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 13:12:19 -0400
Date: Fri, 17 Aug 2007 13:12:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Andreas Jellinghaus [c]" <aj@ciphirelabs.com>
cc: linux-kernel@vger.kernel.org, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] why was MODALIAS removed from usb kernel
 events? [u]
In-Reply-To: <200708171705.35793.aj@ciphirelabs.com>
Message-ID: <Pine.LNX.4.44L0.0708171306360.2546-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, Andreas Jellinghaus [c] wrote:

> I need some kernel event that has both DEVICE and MODALIAS set. 
> up to including kernel 2.6.21 this seems to come from 
> drivers/usb/core/driver.c if I read the code correctly, and then
> it was removed.
> 
> udevmonitor --kernel --environment shows one event with both on 2.6.21 plain, 
> but not on 2.6.22 plain.

Does this patch improve matters?

Alan Stern



Index: 2.6.22/drivers/usb/core/message.c
===================================================================
--- 2.6.22.orig/drivers/usb/core/message.c
+++ 2.6.22/drivers/usb/core/message.c
@@ -1344,6 +1344,30 @@ static int usb_if_uevent(struct device *
 	usb_dev = interface_to_usbdev(intf);
 	alt = intf->cur_altsetting;
 
+#ifdef	CONFIG_USB_DEVICEFS
+	/* If this is available, userspace programs can directly read
+	 * all the device descriptors we don't tell them about.  Or
+	 * act as usermode drivers.
+	 */
+	if (add_uevent_var(envp, num_envp, &i,
+			   buffer, buffer_size, &length,
+			   "DEVICE=/proc/bus/usb/%03d/%03d",
+			   usb_dev->bus->busnum, usb_dev->devnum))
+		return -ENOMEM;
+#endif
+
+	if (add_uevent_var(envp, num_envp, &i,
+			   buffer, buffer_size, &length,
+			   "BUSNUM=%03d",
+			   usb_dev->bus->busnum))
+		return -ENOMEM;
+
+	if (add_uevent_var(envp, num_envp, &i,
+			   buffer, buffer_size, &length,
+			   "DEVNUM=%03d",
+			   usb_dev->devnum))
+		return -ENOMEM;
+
 	if (add_uevent_var(envp, num_envp, &i,
 		   buffer, buffer_size, &length,
 		   "INTERFACE=%d/%d/%d",


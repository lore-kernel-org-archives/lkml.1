Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606Ab0AWXpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab0AWXpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 18:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932132Ab0AWXmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 18:42:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43513 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab0AWXmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 18:42:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/8] PM: Allow USB devices to suspend/resume asynchronously
Date: Sun, 24 Jan 2010 00:40:25 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-usb@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux SCSI <linux-scsi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Nigel Cunningham <ncunningham@crca.org.au>
References: <201001240033.34253.rjw@sisk.pl>
In-Reply-To: <201001240033.34253.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001240040.25931.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Set power.async_suspend for USB devices, endpoints and interfaces,
allowing them to be suspended and resumed asynchronously during
system sleep transitions.

The power.async_suspend flag is also set for devices that don't have
suspend or resume callbacks, because otherwise they would make the
main suspend/resume thread wait for their "asynchronous" children
(during suspend) or parents (during resume), effectively negating the
possible gains from executing these devices' suspend and resume
callbacks asynchronously.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/usb/core/endpoint.c |    1 +
 drivers/usb/core/hcd-pci.c  |    1 +
 drivers/usb/core/hub.c      |    1 +
 drivers/usb/core/message.c  |    1 +
 4 files changed, 4 insertions(+)

Index: linux-2.6/drivers/usb/core/hub.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/hub.c
+++ linux-2.6/drivers/usb/core/hub.c
@@ -1817,6 +1817,7 @@ int usb_new_device(struct usb_device *ud
 	/* Tell the world! */
 	announce_device(udev);
 
+	device_enable_async_suspend(&udev->dev);
 	/* Register the device.  The device driver is responsible
 	 * for configuring the device and invoking the add-device
 	 * notifier chain (used by usbfs and possibly others).
Index: linux-2.6/drivers/usb/core/message.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/message.c
+++ linux-2.6/drivers/usb/core/message.c
@@ -1867,6 +1867,7 @@ free_interfaces:
 			"adding %s (config #%d, interface %d)\n",
 			dev_name(&intf->dev), configuration,
 			intf->cur_altsetting->desc.bInterfaceNumber);
+		device_enable_async_suspend(&intf->dev);
 		ret = device_add(&intf->dev);
 		if (ret != 0) {
 			dev_err(&dev->dev, "device_add(%s) --> %d\n",
Index: linux-2.6/drivers/usb/core/endpoint.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/endpoint.c
+++ linux-2.6/drivers/usb/core/endpoint.c
@@ -186,6 +186,7 @@ int usb_create_ep_devs(struct device *pa
 	ep_dev->dev.parent = parent;
 	ep_dev->dev.release = ep_device_release;
 	dev_set_name(&ep_dev->dev, "ep_%02x", endpoint->desc.bEndpointAddress);
+	device_enable_async_suspend(&ep_dev->dev);
 
 	retval = device_register(&ep_dev->dev);
 	if (retval)


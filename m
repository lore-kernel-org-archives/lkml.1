Return-Path: <linux-kernel-owner+w=401wt.eu-S1751945AbXBJVIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbXBJVIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 16:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbXBJVIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 16:08:48 -0500
Received: from sardaukar.technologeek.org ([213.41.134.240]:47609 "EHLO
	sonic.technologeek.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751954AbXBJVIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 16:08:47 -0500
From: Julien BLACHE <jb@jblache.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] Fix USB vendor and product IDs endianness for USB HID devices
Date: Sat, 10 Feb 2007 22:08:50 +0100
Message-ID: <87k5yp90v1.fsf@sonic.technologeek.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Hi,

The generic HID layer changes introduced an endianness bug for USB HID
devices.

The USB vendor and product IDs are not byteswapped appropriately, and
thus come out in the wrong endianness when fetched through the evdev
using ioctl() on big endian platforms.

This byteswapping used to be done in hidinput_connect() (by
usb_to_input_id()) when filling up the hid device structure, and now
needs to be done upstream. USB is the only user so far, and the
hid_device structure is set up in usb_hid_configure().


Signed-off-by: Julien BLACHE <jb@jblache.org>


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=usbhid_vid_pid_endianness_fix.patch
Content-Description: [PATCH] Fix USB vendor and product IDs endianness for
 USB HID devices

--- hid-core.c~	2007-02-05 11:16:33.905278861 +0100
+++ hid-core.c	2007-02-10 21:53:52.366333019 +0100
@@ -1220,8 +1220,8 @@
 			 le16_to_cpu(dev->descriptor.idProduct));
 
 	hid->bus = BUS_USB;
-	hid->vendor = dev->descriptor.idVendor;
-	hid->product = dev->descriptor.idProduct;
+	hid->vendor = le16_to_cpu(dev->descriptor.idVendor);
+	hid->product = le16_to_cpu(dev->descriptor.idProduct);
 
 	usb_make_path(dev, hid->phys, sizeof(hid->phys));
 	strlcat(hid->phys, "/input", sizeof(hid->phys));

--=-=-=



Please apply, and this is a candidate for -stable as it breaks a
documented API/ABI in userspace.

JB.

-- 
Julien BLACHE                                   <http://www.jblache.org> 
<jb@jblache.org>                                  GPG KeyID 0xF5D65169

--=-=-=--

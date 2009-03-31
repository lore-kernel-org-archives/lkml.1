Return-Path: <linux-kernel-owner+w=401wt.eu-S1764318AbZCaXcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764318AbZCaXcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763637AbZCaXVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:21:11 -0400
Received: from sous-sol.org ([216.99.217.87]:33232 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763685AbZCaXVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:21:06 -0400
Message-Id: <20090331231448.601106125@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:10:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 12/45] USB: add quirk to avoid config and interface strings
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=usb-add-quirk-to-avoid-config-and-interface-strings.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alan Stern <stern@rowland.harvard.edu>

upstream commit: 1662e3a7f076e51e3073faf9ce77157b529c475b

Apparently the Configuration and Interface strings aren't used as
often as the Vendor, Product, and Serial strings.  In at least one
device (a Saitek Cyborg Gold 3D joystick), attempts to read the
Configuration string cause the device to stop responding to Control
requests.

This patch (as1226) adds a quirks flag, telling the kernel not to
read a device's Configuration or Interface strings, together with a
new quirk for the offending joystick.

Reported-by: Melchior FRANZ <melchior.franz@gmail.com>
Tested-by: Melchior FRANZ <melchior.franz@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/core/message.c |    3 ++-
 drivers/usb/core/quirks.c  |    4 ++++
 drivers/usb/core/sysfs.c   |    4 +++-
 include/linux/usb/quirks.h |    3 +++
 4 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1719,7 +1719,8 @@ free_interfaces:
 	}
 	kfree(new_interfaces);
 
-	if (cp->string == NULL)
+	if (cp->string == NULL &&
+			!(dev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
 		cp->string = usb_cache_string(dev, cp->desc.iConfiguration);
 
 	/* Now that all the interfaces are set up, register them
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -54,6 +54,10 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0638, 0x0a13), .driver_info =
 	  USB_QUIRK_STRING_FETCH_255 },
 
+	/* Saitek Cyborg Gold Joystick */
+	{ USB_DEVICE(0x06a3, 0x0006), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/usb.h>
+#include <linux/usb/quirks.h>
 #include "usb.h"
 
 /* Active configuration fields */
@@ -813,7 +814,8 @@ int usb_create_sysfs_intf_files(struct u
 	if (intf->sysfs_files_created || intf->unregistering)
 		return 0;
 
-	if (alt->string == NULL)
+	if (alt->string == NULL &&
+			!(udev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
 		alt->string = usb_cache_string(udev, alt->desc.iInterface);
 	if (alt->string)
 		retval = device_create_file(&intf->dev, &dev_attr_interface);
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -16,4 +16,7 @@
 /* device can't handle Set-Interface requests */
 #define USB_QUIRK_NO_SET_INTF		0x00000004
 
+/* device can't handle its Configuration or Interface strings */
+#define USB_QUIRK_CONFIG_INTF_STRINGS	0x00000008
+
 #endif /* __LINUX_USB_QUIRKS_H */


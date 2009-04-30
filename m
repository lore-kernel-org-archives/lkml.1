Return-Path: <linux-kernel-owner+w=401wt.eu-S1764991AbZD3RM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764991AbZD3RM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764226AbZD3RH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:29 -0400
Received: from kroah.org ([198.145.64.141]:56238 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763616AbZD3RHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:40 2009
Message-Id: <20090430165740.211218395@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:02 -0700
From: Greg KH <gregkh@suse.de>
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
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 13/88] USB: add quirk to avoid config and interface strings
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0012-USB-add-quirk-to-avoid-config-and-interface-strings.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

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
@@ -1637,7 +1637,8 @@ free_interfaces:
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
@@ -847,7 +848,8 @@ int usb_create_sysfs_intf_files(struct u
 	 * and missing in others.  Hence its attribute cannot be created
 	 * before the uevent is broadcast.
 	 */
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



Return-Path: <linux-kernel-owner+w=401wt.eu-S1760273AbYHIBoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273AbYHIBoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYHIBoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:44:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52134 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYHIBn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:43:58 -0400
Date: Fri, 8 Aug 2008 18:39:17 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [01/03] USB: add CONFIG_USB_DEBUG_MESSAGES and usb_dbg()
Message-ID: <20080809013917.GB10910@kroah.com>
References: <20080809013820.GA10910@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809013820.GA10910@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

This adds the core function usb_dbg() and a new config option to enable
this.

It can only be disabled if CONFIG_EMBEDDED is set.

It allows the usb core debugging messages to be enabled/disabled on the
fly with the usbcore "debug" module parameter.

Note, other sections of the kernel rely on CONFIG_USB_DEBUG, they will
also need to be converted.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/Kconfig |   13 +++++++++++++
 drivers/usb/core/usb.c   |   12 ++++++++++--
 drivers/usb/core/usb.h   |   22 ++++++++++++++++++++++
 3 files changed, 45 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -9,6 +9,19 @@ config USB_DEBUG
 	  of debug messages to the system log. Select this if you are having a
 	  problem with USB support and want to see more of what is going on.
 
+config USB_DEBUG_MESSAGES
+	default y
+	bool "USB debugging messages" if EMBEDDED
+	depends on USB
+	help
+	  Say Y here if you want the USB core & hub drivers to be able to
+	  produce debugging messages if needed.  The messages can be
+	  enabled or disabled with the usbcore.debug module parameter.
+	  This option just allows you to save a bit of space if you do not
+	  want them to even be built into the kernel.
+
+	  If you have any doubts about this, say Y here.
+
 config USB_ANNOUNCE_NEW_DEVICES
 	bool "USB announce new devices"
 	depends on USB
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -61,6 +61,14 @@ MODULE_PARM_DESC(autosuspend, "default a
 #define usb_autosuspend_delay		0
 #endif
 
+/* if debug is on or not */
+int usb_debug;
+
+/* USB debugging */
+#if defined(CONFIG_USB_DEBUG_MESSAGES)
+module_param_named(debug, usb_debug, bool, 0644);
+MODULE_PARM_DESC(debug, "USB debugging enabled or not");
+#endif
 
 /**
  * usb_ifnum_to_if - get the interface object with a given interface number
@@ -502,14 +510,14 @@ static struct usb_device *match_device(s
 	struct usb_device *ret_dev = NULL;
 	int child;
 
-	dev_dbg(&dev->dev, "check for vendor %04x, product %04x ...\n",
+	usb_dbg(&dev->dev, "check for vendor %04x, product %04x ...\n",
 	    le16_to_cpu(dev->descriptor.idVendor),
 	    le16_to_cpu(dev->descriptor.idProduct));
 
 	/* see if this device matches */
 	if ((vendor_id == le16_to_cpu(dev->descriptor.idVendor)) &&
 	    (product_id == le16_to_cpu(dev->descriptor.idProduct))) {
-		dev_dbg(&dev->dev, "matched this device!\n");
+		usb_dbg(&dev->dev, "matched this device!\n");
 		ret_dev = usb_get_dev(dev);
 		goto exit;
 	}
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -132,6 +132,28 @@ static inline int is_active(const struct
 /* for labeling diagnostics */
 extern const char *usbcore_name;
 
+/* USB debugging */
+/* if debug is on or not for the USB core */
+extern int usb_debug;
+
+#if defined(CONFIG_USB_DEBUG_MESSAGES)
+/* macro for debugging */
+#define usb_dbg(dev, format, arg...)					\
+	({								\
+		if (usb_debug)						\
+			dev_printk(KERN_DEBUG , dev , format , ## arg); \
+		0;							\
+	})
+#else
+#define usb_dbg(dev, format, arg...)					\
+	({								\
+		if (0)							\
+			dev_printk(KERN_DEBUG , dev , format , ## arg);	\
+		0;							\
+	})
+#endif
+
+
 /* sysfs stuff */
 extern struct attribute_group *usb_device_groups[];
 extern struct attribute_group *usb_interface_groups[];

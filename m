Return-Path: <linux-kernel-owner+w=401wt.eu-S1761794AbZAWBXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761794AbZAWBXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758892AbZAWBPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:20 -0500
Received: from kroah.org ([198.145.64.141]:50652 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760239AbZAWBPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:04 -0500
Date: Thu, 22 Jan 2009 17:12:24 -0800
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 26/46] USB: re-enable interface after driver unbinds
Message-ID: <20090123011224.GA19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-re-enable-interface-after-driver-unbinds.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 2caf7fcdb8532045680f06b67b9e63f0c9613aaa upstream.

This patch (as1197) fixes an error introduced recently.  Since a
significant number of devices can't handle Set-Interface requests, we
no longer call usb_set_interface() when a driver unbinds from an
interface, provided the interface is already in altsetting 0.  However
the interface still does get disabled, and the call to
usb_set_interface() was the only thing re-enabling it.  Since the
interface doesn't get re-enabled, further attempts to use it fail.

So the patch adds a call to usb_enable_interface() when a driver
unbinds and the interface is in altsetting 0.  For this to work
right, the interface's endpoints have to be re-enabled but their
toggles have to be left alone.  Therefore an additional argument is
added to usb_enable_endpoint() and usb_enable_interface(), a flag
indicating whether or not the endpoint toggles should be reset.

This is a forward-ported version of a patch which fixes Bugzilla
#12301.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: David Roka <roka@dawid.hu>
Reported-by: Erik Ekman <erik@kryo.se>
Tested-by: Erik Ekman <erik@kryo.se>
Tested-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/driver.c  |    9 ++++++---
 drivers/usb/core/hub.c     |    2 +-
 drivers/usb/core/message.c |   25 +++++++++++++++----------
 drivers/usb/core/usb.c     |    2 +-
 drivers/usb/core/usb.h     |    4 +++-
 5 files changed, 26 insertions(+), 16 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -279,9 +279,12 @@ static int usb_unbind_interface(struct d
 	 * altsetting means creating new endpoint device entries).
 	 * When either of these happens, defer the Set-Interface.
 	 */
-	if (intf->cur_altsetting->desc.bAlternateSetting == 0)
-		;	/* Already in altsetting 0 so skip Set-Interface */
-	else if (!error && intf->dev.power.status == DPM_ON)
+	if (intf->cur_altsetting->desc.bAlternateSetting == 0) {
+		/* Already in altsetting 0 so skip Set-Interface.
+		 * Just re-enable it without affecting the endpoint toggles.
+		 */
+		usb_enable_interface(udev, intf, false);
+	} else if (!error && intf->dev.power.status == DPM_ON)
 		usb_set_interface(udev, intf->altsetting[0].
 				desc.bInterfaceNumber, 0);
 	else
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2385,7 +2385,7 @@ void usb_ep0_reinit(struct usb_device *u
 {
 	usb_disable_endpoint(udev, 0 + USB_DIR_IN);
 	usb_disable_endpoint(udev, 0 + USB_DIR_OUT);
-	usb_enable_endpoint(udev, &udev->ep0);
+	usb_enable_endpoint(udev, &udev->ep0, true);
 }
 EXPORT_SYMBOL_GPL(usb_ep0_reinit);
 
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1113,22 +1113,26 @@ void usb_disable_device(struct usb_devic
  * usb_enable_endpoint - Enable an endpoint for USB communications
  * @dev: the device whose interface is being enabled
  * @ep: the endpoint
+ * @reset_toggle: flag to set the endpoint's toggle back to 0
  *
- * Resets the endpoint toggle, and sets dev->ep_{in,out} pointers.
+ * Resets the endpoint toggle if asked, and sets dev->ep_{in,out} pointers.
  * For control endpoints, both the input and output sides are handled.
  */
-void usb_enable_endpoint(struct usb_device *dev, struct usb_host_endpoint *ep)
+void usb_enable_endpoint(struct usb_device *dev, struct usb_host_endpoint *ep,
+		bool reset_toggle)
 {
 	int epnum = usb_endpoint_num(&ep->desc);
 	int is_out = usb_endpoint_dir_out(&ep->desc);
 	int is_control = usb_endpoint_xfer_control(&ep->desc);
 
 	if (is_out || is_control) {
-		usb_settoggle(dev, epnum, 1, 0);
+		if (reset_toggle)
+			usb_settoggle(dev, epnum, 1, 0);
 		dev->ep_out[epnum] = ep;
 	}
 	if (!is_out || is_control) {
-		usb_settoggle(dev, epnum, 0, 0);
+		if (reset_toggle)
+			usb_settoggle(dev, epnum, 0, 0);
 		dev->ep_in[epnum] = ep;
 	}
 	ep->enabled = 1;
@@ -1138,17 +1142,18 @@ void usb_enable_endpoint(struct usb_devi
  * usb_enable_interface - Enable all the endpoints for an interface
  * @dev: the device whose interface is being enabled
  * @intf: pointer to the interface descriptor
+ * @reset_toggles: flag to set the endpoints' toggles back to 0
  *
  * Enables all the endpoints for the interface's current altsetting.
  */
-static void usb_enable_interface(struct usb_device *dev,
-				 struct usb_interface *intf)
+void usb_enable_interface(struct usb_device *dev,
+		struct usb_interface *intf, bool reset_toggles)
 {
 	struct usb_host_interface *alt = intf->cur_altsetting;
 	int i;
 
 	for (i = 0; i < alt->desc.bNumEndpoints; ++i)
-		usb_enable_endpoint(dev, &alt->endpoint[i]);
+		usb_enable_endpoint(dev, &alt->endpoint[i], reset_toggles);
 }
 
 /**
@@ -1271,7 +1276,7 @@ int usb_set_interface(struct usb_device 
 	 * during the SETUP stage - hence EP0 toggles are "don't care" here.
 	 * (Likewise, EP0 never "halts" on well designed devices.)
 	 */
-	usb_enable_interface(dev, iface);
+	usb_enable_interface(dev, iface, true);
 	if (device_is_registered(&iface->dev))
 		usb_create_sysfs_intf_files(iface);
 
@@ -1346,7 +1351,7 @@ int usb_reset_configuration(struct usb_d
 			alt = &intf->altsetting[0];
 
 		intf->cur_altsetting = alt;
-		usb_enable_interface(dev, intf);
+		usb_enable_interface(dev, intf, true);
 		if (device_is_registered(&intf->dev))
 			usb_create_sysfs_intf_files(intf);
 	}
@@ -1604,7 +1609,7 @@ free_interfaces:
 			alt = &intf->altsetting[0];
 
 		intf->cur_altsetting = alt;
-		usb_enable_interface(dev, intf);
+		usb_enable_interface(dev, intf, true);
 		intf->dev.parent = &dev->dev;
 		intf->dev.driver = NULL;
 		intf->dev.bus = &usb_bus_type;
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -362,7 +362,7 @@ struct usb_device *usb_alloc_dev(struct 
 	dev->ep0.desc.bLength = USB_DT_ENDPOINT_SIZE;
 	dev->ep0.desc.bDescriptorType = USB_DT_ENDPOINT;
 	/* ep0 maxpacket comes later, from device descriptor */
-	usb_enable_endpoint(dev, &dev->ep0);
+	usb_enable_endpoint(dev, &dev->ep0, true);
 	dev->can_submit = 1;
 
 	/* Save readable and stable topology id, distinguishing devices
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -10,7 +10,9 @@ extern int usb_create_ep_files(struct de
 extern void usb_remove_ep_files(struct usb_host_endpoint *endpoint);
 
 extern void usb_enable_endpoint(struct usb_device *dev,
-		struct usb_host_endpoint *ep);
+		struct usb_host_endpoint *ep, bool reset_toggle);
+extern void usb_enable_interface(struct usb_device *dev,
+		struct usb_interface *intf, bool reset_toggles);
 extern void usb_disable_endpoint(struct usb_device *dev, unsigned int epaddr);
 extern void usb_disable_interface(struct usb_device *dev,
 		struct usb_interface *intf);


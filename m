Return-Path: <linux-kernel-owner+w=401wt.eu-S1761149AbZAaDCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761149AbZAaDCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbZAaCr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:27 -0500
Received: from kroah.org ([198.145.64.141]:55262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753089AbZAaCrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:18 -0500
Date: Fri, 30 Jan 2009 18:42:36 -0800
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
Subject: [patch 11/43] USB: fix toggle mismatch in disable_endpoint paths
Message-ID: <20090131024236.GL12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-toggle-mismatch-in-disable_endpoint-paths.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit ddeac4e75f2527a340f9dc655bde49bb2429b39b upstream.

This patch (as1200) finishes some fixes that were left incomplete by
an earlier patch.

Although nobody has addressed this issue in the past, it turns out
that we need to distinguish between two different modes of disabling
and enabling endpoints.  In one mode only the data structures in
usbcore are affected, and in the other mode the host controller and
device hardware states are affected as well.

The earlier patch added an extra argument to the routines in the
enable_endpoint pathways to reflect this difference.  This patch adds
corresponding arguments to the disable_endpoint pathways.  Without
this change, the endpoint toggle state can get out of sync between
the host and the device.  The exact mechanism depends on the details
of the host controller (whether or not it stores its own copy of the
toggle values).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Dan Streetman <ddstreet@ieee.org>
Tested-by: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/driver.c  |    2 +-
 drivers/usb/core/hub.c     |    4 ++--
 drivers/usb/core/message.c |   40 ++++++++++++++++++++++++----------------
 drivers/usb/core/usb.h     |    5 +++--
 4 files changed, 30 insertions(+), 21 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -269,7 +269,7 @@ static int usb_unbind_interface(struct d
 	 * supports "soft" unbinding.
 	 */
 	if (!driver->soft_unbind)
-		usb_disable_interface(udev, intf);
+		usb_disable_interface(udev, intf, false);
 
 	driver->disconnect(intf);
 
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2383,8 +2383,8 @@ static int hub_port_debounce(struct usb_
 
 void usb_ep0_reinit(struct usb_device *udev)
 {
-	usb_disable_endpoint(udev, 0 + USB_DIR_IN);
-	usb_disable_endpoint(udev, 0 + USB_DIR_OUT);
+	usb_disable_endpoint(udev, 0 + USB_DIR_IN, true);
+	usb_disable_endpoint(udev, 0 + USB_DIR_OUT, true);
 	usb_enable_endpoint(udev, &udev->ep0, true);
 }
 EXPORT_SYMBOL_GPL(usb_ep0_reinit);
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1009,14 +1009,15 @@ EXPORT_SYMBOL_GPL(usb_clear_halt);
  * @dev: the device whose endpoint is being disabled
  * @epaddr: the endpoint's address.  Endpoint number for output,
  *	endpoint number + USB_DIR_IN for input
+ * @reset_hardware: flag to erase any endpoint state stored in the
+ *	controller hardware
  *
- * Deallocates hcd/hardware state for this endpoint ... and nukes all
- * pending urbs.
- *
- * If the HCD hasn't registered a disable() function, this sets the
- * endpoint's maxpacket size to 0 to prevent further submissions.
+ * Disables the endpoint for URB submission and nukes all pending URBs.
+ * If @reset_hardware is set then also deallocates hcd/hardware state
+ * for the endpoint.
  */
-void usb_disable_endpoint(struct usb_device *dev, unsigned int epaddr)
+void usb_disable_endpoint(struct usb_device *dev, unsigned int epaddr,
+		bool reset_hardware)
 {
 	unsigned int epnum = epaddr & USB_ENDPOINT_NUMBER_MASK;
 	struct usb_host_endpoint *ep;
@@ -1026,15 +1027,18 @@ void usb_disable_endpoint(struct usb_dev
 
 	if (usb_endpoint_out(epaddr)) {
 		ep = dev->ep_out[epnum];
-		dev->ep_out[epnum] = NULL;
+		if (reset_hardware)
+			dev->ep_out[epnum] = NULL;
 	} else {
 		ep = dev->ep_in[epnum];
-		dev->ep_in[epnum] = NULL;
+		if (reset_hardware)
+			dev->ep_in[epnum] = NULL;
 	}
 	if (ep) {
 		ep->enabled = 0;
 		usb_hcd_flush_endpoint(dev, ep);
-		usb_hcd_disable_endpoint(dev, ep);
+		if (reset_hardware)
+			usb_hcd_disable_endpoint(dev, ep);
 	}
 }
 
@@ -1042,17 +1046,21 @@ void usb_disable_endpoint(struct usb_dev
  * usb_disable_interface -- Disable all endpoints for an interface
  * @dev: the device whose interface is being disabled
  * @intf: pointer to the interface descriptor
+ * @reset_hardware: flag to erase any endpoint state stored in the
+ *	controller hardware
  *
  * Disables all the endpoints for the interface's current altsetting.
  */
-void usb_disable_interface(struct usb_device *dev, struct usb_interface *intf)
+void usb_disable_interface(struct usb_device *dev, struct usb_interface *intf,
+		bool reset_hardware)
 {
 	struct usb_host_interface *alt = intf->cur_altsetting;
 	int i;
 
 	for (i = 0; i < alt->desc.bNumEndpoints; ++i) {
 		usb_disable_endpoint(dev,
-				alt->endpoint[i].desc.bEndpointAddress);
+				alt->endpoint[i].desc.bEndpointAddress,
+				reset_hardware);
 	}
 }
 
@@ -1073,8 +1081,8 @@ void usb_disable_device(struct usb_devic
 	dev_dbg(&dev->dev, "%s nuking %s URBs\n", __func__,
 		skip_ep0 ? "non-ep0" : "all");
 	for (i = skip_ep0; i < 16; ++i) {
-		usb_disable_endpoint(dev, i);
-		usb_disable_endpoint(dev, i + USB_DIR_IN);
+		usb_disable_endpoint(dev, i, true);
+		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
 	}
 	dev->toggle[0] = dev->toggle[1] = 0;
 
@@ -1242,7 +1250,7 @@ int usb_set_interface(struct usb_device 
 	/* prevent submissions using previous endpoint settings */
 	if (iface->cur_altsetting != alt)
 		usb_remove_sysfs_intf_files(iface);
-	usb_disable_interface(dev, iface);
+	usb_disable_interface(dev, iface, true);
 
 	iface->cur_altsetting = alt;
 
@@ -1320,8 +1328,8 @@ int usb_reset_configuration(struct usb_d
 	 */
 
 	for (i = 1; i < 16; ++i) {
-		usb_disable_endpoint(dev, i);
-		usb_disable_endpoint(dev, i + USB_DIR_IN);
+		usb_disable_endpoint(dev, i, true);
+		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
 	}
 
 	config = dev->actconfig;
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -13,9 +13,10 @@ extern void usb_enable_endpoint(struct u
 		struct usb_host_endpoint *ep, bool reset_toggle);
 extern void usb_enable_interface(struct usb_device *dev,
 		struct usb_interface *intf, bool reset_toggles);
-extern void usb_disable_endpoint(struct usb_device *dev, unsigned int epaddr);
+extern void usb_disable_endpoint(struct usb_device *dev, unsigned int epaddr,
+		bool reset_hardware);
 extern void usb_disable_interface(struct usb_device *dev,
-		struct usb_interface *intf);
+		struct usb_interface *intf, bool reset_hardware);
 extern void usb_release_interface_cache(struct kref *ref);
 extern void usb_disable_device(struct usb_device *dev, int skip_ep0);
 extern int usb_deauthorize_device(struct usb_device *);


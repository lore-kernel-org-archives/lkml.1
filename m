Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935309Ab0CMBPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:15:15 -0500
Received: from kroah.org ([198.145.64.141]:32800 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934929Ab0CMAUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:55 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:13 2010
Message-Id: <20100313001513.614987690@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 097/123] USB: Move hcd free_dev call into usb_disconnect to fix oops
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit f7410ced7f931bb1ad79d1336412cf7b7a33cb14 upstream.

USB: Move hcd free_dev call into usb_disconnect

I found a way to oops the kernel:

1. Open a USB device through devio.
2. Remove the hcd module in the host kernel.
3. Close the devio file descriptor.

The problem is that closing the file descriptor does usb_release_dev
as it is the last reference.  usb_release_dev then tries to invoke
the hcd free_dev function (or rather dereferencing the hcd driver
struct).  This causes an oops as the hcd driver has already been
unloaded so the struct is gone.

This patch tries to fix this by bringing the free_dev call earlier
and into usb_disconnect.  I have verified that repeating the
above steps no longer crashes with this patch applied.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hcd.h |    2 +-
 drivers/usb/core/hub.c |   12 ++++++++++++
 drivers/usb/core/usb.c |    3 ---
 3 files changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -248,7 +248,7 @@ struct hc_driver {
 	/* xHCI specific functions */
 		/* Called by usb_alloc_dev to alloc HC device structures */
 	int	(*alloc_dev)(struct usb_hcd *, struct usb_device *);
-		/* Called by usb_release_dev to free HC device structures */
+		/* Called by usb_disconnect to free HC device structures */
 	void	(*free_dev)(struct usb_hcd *, struct usb_device *);
 
 	/* Bandwidth computation functions */
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1554,6 +1554,15 @@ static inline void usb_stop_pm(struct us
 
 #endif
 
+static void hub_free_dev(struct usb_device *udev)
+{
+	struct usb_hcd *hcd = bus_to_hcd(udev->bus);
+
+	/* Root hubs aren't real devices, so don't free HCD resources */
+	if (hcd->driver->free_dev && udev->parent)
+		hcd->driver->free_dev(hcd, udev);
+}
+
 /**
  * usb_disconnect - disconnect a device (usbcore-internal)
  * @pdev: pointer to device being disconnected
@@ -1624,6 +1633,8 @@ void usb_disconnect(struct usb_device **
 
 	usb_stop_pm(udev);
 
+	hub_free_dev(udev);
+
 	put_device(&udev->dev);
 }
 
@@ -3191,6 +3202,7 @@ loop_disable:
 loop:
 		usb_ep0_reinit(udev);
 		release_address(udev);
+		hub_free_dev(udev);
 		usb_put_dev(udev);
 		if ((status == -ENOTCONN) || (status == -ENOTSUPP))
 			break;
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -228,9 +228,6 @@ static void usb_release_dev(struct devic
 	hcd = bus_to_hcd(udev->bus);
 
 	usb_destroy_configuration(udev);
-	/* Root hubs aren't real devices, so don't free HCD resources */
-	if (hcd->driver->free_dev && udev->parent)
-		hcd->driver->free_dev(hcd, udev);
 	usb_put_hcd(hcd);
 	kfree(udev->product);
 	kfree(udev->manufacturer);



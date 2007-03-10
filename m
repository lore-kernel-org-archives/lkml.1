Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbXCJGU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbXCJGU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbXCJGUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:20:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:41093 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbXCJGUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:20:17 -0500
Date: Fri, 9 Mar 2007 22:18:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Rainer Weikusat <rweikusat@sncag.com>
Subject: [patch 16/20] fix for bugzilla #7544 (keyspan USB-to-serial converter)
Message-ID: <20070310061834.GQ31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-for-bugzilla-7544.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rainer Weikusat <rweikusat@sncag.com>

At least the Keyspan USA-19HS USB-to-serial converter supports
two different configurations, one where the input endpoints
have interrupt transfer type and one where they are bulk endpoints.
The default UHCI configuration uses the interrupt input endpoints.
The keyspan driver, OTOH, assumes that the device has only bulk
endpoints (all URBs are initialized by calling usb_fill_bulk_urb
in keyspan.c/ keyspan_setup_urb). This causes the interval field
of the input URBs to have a value of zero instead of one, which
'accidentally' worked with Linux at least up to 2.6.17.11 but
stopped to with 2.6.18, which changed the UHCI support code handling
URBs for interrupt endpoints. The patch below modifies to driver to
initialize its input URBs either as interrupt or as bulk URBs,
depending on the transfertype contained in the associated endpoint
descriptor (only tested with the default configuration) enabling
the driver to again receive data from the serial converter.

Greg K-H reworked the patch.

Signed-off-by: Rainer Weikusat <rweikusat@sncag.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/keyspan.c |   49 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1275,11 +1275,31 @@ static int keyspan_fake_startup (struct 
 }
 
 /* Helper functions used by keyspan_setup_urbs */
+static struct usb_endpoint_descriptor const *find_ep(struct usb_serial const *serial,
+						     int endpoint)
+{
+	struct usb_host_interface *iface_desc;
+	struct usb_endpoint_descriptor *ep;
+	int i;
+
+	iface_desc = serial->interface->cur_altsetting;
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
+		ep = &iface_desc->endpoint[i].desc;
+		if (ep->bEndpointAddress == endpoint)
+			return ep;
+	}
+	dev_warn(&serial->interface->dev, "found no endpoint descriptor for "
+		 "endpoint %x\n", endpoint);
+	return NULL;
+}
+
 static struct urb *keyspan_setup_urb (struct usb_serial *serial, int endpoint,
 				      int dir, void *ctx, char *buf, int len,
 				      void (*callback)(struct urb *))
 {
 	struct urb *urb;
+	struct usb_endpoint_descriptor const *ep_desc;
+	char const *ep_type_name;
 
 	if (endpoint == -1)
 		return NULL;		/* endpoint not needed */
@@ -1291,11 +1311,32 @@ static struct urb *keyspan_setup_urb (st
 		return NULL;
 	}
 
-		/* Fill URB using supplied data. */
-	usb_fill_bulk_urb(urb, serial->dev,
-		      usb_sndbulkpipe(serial->dev, endpoint) | dir,
-		      buf, len, callback, ctx);
+	ep_desc = find_ep(serial, endpoint);
+	if (!ep_desc) {
+		/* leak the urb, something's wrong and the callers don't care */
+		return urb;
+	}
+	if (usb_endpoint_xfer_int(ep_desc)) {
+		ep_type_name = "INT";
+		usb_fill_int_urb(urb, serial->dev,
+				 usb_sndintpipe(serial->dev, endpoint) | dir,
+				 buf, len, callback, ctx,
+				 ep_desc->bInterval);
+	} else if (usb_endpoint_xfer_bulk(ep_desc)) {
+		ep_type_name = "BULK";
+		usb_fill_bulk_urb(urb, serial->dev,
+				  usb_sndbulkpipe(serial->dev, endpoint) | dir,
+				  buf, len, callback, ctx);
+	} else {
+		dev_warn(&serial->interface->dev,
+			 "unsupported endpoint type %x\n",
+			 ep_desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK);
+		usb_free_urb(urb);
+		return NULL;
+	}
 
+	dbg("%s - using urb %p for %s endpoint %x",
+	    __func__, urb, ep_type_name, endpoint);
 	return urb;
 }
 

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbXBDEk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbXBDEk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 23:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXBDEk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 23:40:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:34396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbXBDEkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 23:40:55 -0500
Date: Sat, 3 Feb 2007 20:39:36 -0800
From: Greg KH <greg@kroah.com>
To: Rainer Weikusat <rainer.weikusat@sncag.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rainer Weikusat <rweikusat@sncag.com>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: unfixed regression in 2.6.20-rc6 (since 2.6.19)
Message-ID: <20070204043935.GA8829@kroah.com>
References: <877ivb2kvc.fsf@semtex.sncag.com> <20070125185101.GA26279@kroah.com> <87y7nq131x.fsf@semtex.sncag.com> <20070126174828.GA28890@kroah.com> <87d54z1dhb.fsf@semtex.sncag.com> <slrnerqjit.f71.olecom@flower.upol.cz> <20070129234340.GA6881@kroah.com> <87k5z4za4l.fsf@semtex.sncag.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k5z4za4l.fsf@semtex.sncag.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 06:40:10PM +0100, Rainer Weikusat wrote:
> Greg KH <greg@kroah.com> writes:
> 
> [...]
> 
> > Rainer's problem is a real bug in the USB driver code, which we need to
> > work on getting fixed,

Ok, here's an updated version, that should tell us where things are
going wrong (if they are.)

Can you try this out with debugging enabled for the driver:
	modprobe keyspan debug=1

and let me know what the output of the kernel log is when you plug your
device in?

I threw it at all of the keyspan devices that I have here, but
unfortunatly, they all have BULK endpoints.

But it all still works, which is good to see :)

Let me know what you find.

thanks,

greg k-h

-----------------------
From: Rainer Weikusat <rainer.weikusat@sncag.com>
Date: Wed, 03 Jan 2007 15:36:25 +0100
Subject: [PATCH 2.6.20-rc3] fix for bugzilla #7544 (keyspan USB-to-serial converter)
To: Greg KH <greg@kroah.com>
Message-ID: <87ejqcdvo6.fsf@semtex.sncag.com>


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

--- gregkh-2.6.orig/drivers/usb/serial/keyspan.c
+++ gregkh-2.6/drivers/usb/serial/keyspan.c
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
 

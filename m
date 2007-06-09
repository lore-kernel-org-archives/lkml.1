Return-Path: <linux-kernel-owner+w=401wt.eu-S1032597AbXFIAGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032597AbXFIAGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031389AbXFIAEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:04:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:33849 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968865AbXFIAEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:04:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 8/9] USB: Fix up bogus bInterval values in endpoint descriptors
Date: Fri,  8 Jun 2007 17:03:53 -0700
Message-Id: <11813474933434-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <11813474852263-git-send-email-gregkh@suse.de>
References: <20070609000312.GA17574@kroah.com>
 <11813474343815-git-send-email-gregkh@suse.de>
 <1181347441440-git-send-email-gregkh@suse.de>
 <11813474492376-git-send-email-gregkh@suse.de>
 <118134746039-git-send-email-gregkh@suse.de>
 <11813474672336-git-send-email-gregkh@suse.de>
 <11813474771075-git-send-email-gregkh@suse.de>
 <11813474852263-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as904) adds code to check for endpoint descriptor bInterval
values outside the legal limits.  Illegal values are set to 32 ms, which
seems like a reasonable default.

This fixes Bugzilla #8432.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/config.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 2d4fd53..dd34823 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -1,4 +1,5 @@
 #include <linux/usb.h>
+#include <linux/usb/ch9.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -49,7 +50,7 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno, int inum,
 	unsigned char *buffer0 = buffer;
 	struct usb_endpoint_descriptor *d;
 	struct usb_host_endpoint *endpoint;
-	int n, i;
+	int n, i, j;
 
 	d = (struct usb_endpoint_descriptor *) buffer;
 	buffer += d->bLength;
@@ -84,6 +85,45 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno, int inum,
 	memcpy(&endpoint->desc, d, n);
 	INIT_LIST_HEAD(&endpoint->urb_list);
 
+	/* If the bInterval value is outside the legal range,
+	 * set it to a default value: 32 ms */
+	i = 0;		/* i = min, j = max, n = default */
+	j = 255;
+	if (usb_endpoint_xfer_int(d)) {
+		i = 1;
+		switch (to_usb_device(ddev)->speed) {
+		case USB_SPEED_HIGH:
+			n = 9;		/* 32 ms = 2^(9-1) uframes */
+			j = 16;
+			break;
+		default:		/* USB_SPEED_FULL or _LOW */
+			/* For low-speed, 10 ms is the official minimum.
+			 * But some "overclocked" devices might want faster
+			 * polling so we'll allow it. */
+			n = 32;
+			break;
+		}
+	} else if (usb_endpoint_xfer_isoc(d)) {
+		i = 1;
+		j = 16;
+		switch (to_usb_device(ddev)->speed) {
+		case USB_SPEED_HIGH:
+			n = 9;		/* 32 ms = 2^(9-1) uframes */
+			break;
+		default:		/* USB_SPEED_FULL */
+			n = 6;		/* 32 ms = 2^(6-1) frames */
+			break;
+		}
+	}
+	if (d->bInterval < i || d->bInterval > j) {
+		dev_warn(ddev, "config %d interface %d altsetting %d "
+		    "endpoint 0x%X has an invalid bInterval %d, "
+		    "changing to %d\n",
+		    cfgno, inum, asnum,
+		    d->bEndpointAddress, d->bInterval, n);
+		endpoint->desc.bInterval = n;
+	}
+
 	/* Skip over any Class Specific or Vendor Specific descriptors;
 	 * find the next endpoint or interface descriptor */
 	endpoint->extra = buffer;
-- 
1.5.2.1

